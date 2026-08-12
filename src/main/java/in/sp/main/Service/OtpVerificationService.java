package in.sp.main.Service;

import java.security.SecureRandom;
import java.time.Duration;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Optional;
import java.util.function.Function;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import in.sp.main.Entities.EmailOtpVerification;
import in.sp.main.Entities.OtpChannel;
import in.sp.main.Entities.OtpPurpose;
import in.sp.main.Repository.EmailOtpVerificationRepository;
import in.sp.main.Service.Otp.OtpDeliveryChannel;

@Service
public class OtpVerificationService {

    private static final SecureRandom RANDOM = new SecureRandom();

    @Autowired
    private EmailOtpVerificationRepository otpRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private List<OtpDeliveryChannel> deliveryChannels;

    @Autowired
    private EmailService emailService;

    @Autowired
    private RateLimitService rateLimitService;

    @Value("${otp.expiration-minutes:10}")
    private int expirationMinutes;

    @Value("${otp.resend-cooldown-seconds:60}")
    private int resendCooldownSeconds;

    @Value("${otp.email.enabled:true}")
    private boolean emailEnabled;

    @Value("${otp.sms.enabled:false}")
    private boolean smsEnabled;

    @Transactional
    public void sendOtp(String email, OtpPurpose purpose, OtpChannel channel) {
        String normalized = normalizeEmail(email);
        if (normalized.isBlank()) {
            throw new IllegalArgumentException("Email is required");
        }
        if (channel == OtpChannel.EMAIL && !emailEnabled) {
            throw new IllegalStateException("Email OTP is not enabled");
        }
        if (channel == OtpChannel.SMS && !smsEnabled) {
            throw new IllegalStateException("SMS OTP is not enabled yet");
        }

        if (channel == OtpChannel.EMAIL) {
            rateLimitService.checkOrThrow("otp:email:" + normalized, 5, Duration.ofHours(1));
        }

        Optional<EmailOtpVerification> latest = otpRepository
                .findTopByEmailAndPurposeAndVerifiedFalseOrderByCreatedAtDesc(normalized, purpose);
        if (latest.isPresent()) {
            EmailOtpVerification existing = latest.get();
            LocalDateTime cooldownUntil = existing.getCreatedAt().plusSeconds(resendCooldownSeconds);
            if (LocalDateTime.now().isBefore(cooldownUntil)) {
                throw new IllegalStateException("Please wait before requesting another OTP");
            }
        }

        String code = generateCode();
        String subject = "Your Fight D Fear verification code";
        String body = "Your verification code is: " + code + "\n\n"
                + "This code expires in " + expirationMinutes + " minutes.\n"
                + "If you did not request this, you can ignore this email.";
        try {
            if (channel == OtpChannel.EMAIL) {
                // Send synchronously so the API does not report "OTP sent" when SMTP fails.
                emailService.sendEmail(normalized, subject, body);
            } else {
                OtpDeliveryChannel delivery = resolveChannel(channel);
                delivery.send(normalized, subject, body);
            }
        } catch (org.springframework.web.server.ResponseStatusException ex) {
            throw ex;
        } catch (Exception ex) {
            throw new org.springframework.web.server.ResponseStatusException(
                    org.springframework.http.HttpStatus.SERVICE_UNAVAILABLE,
                    "Could not send verification email. Please try again in a moment.");
        }

        EmailOtpVerification record = new EmailOtpVerification();
        record.setEmail(normalized);
        record.setCodeHash(passwordEncoder.encode(code));
        record.setPurpose(purpose);
        record.setChannel(channel);
        record.setVerified(false);
        record.setExpiresAt(LocalDateTime.now().plusMinutes(expirationMinutes));
        otpRepository.save(record);
    }

    @Transactional
    public boolean verifyOtp(String email, String code, OtpPurpose purpose) {
        String normalized = normalizeEmail(email);
        if (normalized.isBlank() || code == null || code.isBlank()) {
            return false;
        }

        Optional<EmailOtpVerification> opt = otpRepository
                .findTopByEmailAndPurposeAndVerifiedFalseOrderByCreatedAtDesc(normalized, purpose);
        if (opt.isEmpty()) {
            return false;
        }

        EmailOtpVerification record = opt.get();
        if (record.isExpired()) {
            return false;
        }
        if (!passwordEncoder.matches(code.trim(), record.getCodeHash())) {
            return false;
        }

        record.setVerified(true);
        otpRepository.save(record);
        return true;
    }

    @Transactional
    public boolean consumeVerifiedOtp(String email, OtpPurpose purpose, int maxAgeMinutes) {
        String normalized = normalizeEmail(email);
        Optional<EmailOtpVerification> opt = otpRepository
                .findTopByEmailAndPurposeAndVerifiedTrueOrderByCreatedAtDesc(normalized, purpose);
        if (opt.isEmpty()) {
            return false;
        }
        EmailOtpVerification record = opt.get();
        if (record.isExpired()) {
            return false;
        }
        LocalDateTime maxAge = LocalDateTime.now().minusMinutes(maxAgeMinutes);
        if (record.getCreatedAt().isBefore(maxAge)) {
            return false;
        }
        otpRepository.delete(record);
        return true;
    }

    private OtpDeliveryChannel resolveChannel(OtpChannel channel) {
        Map<OtpChannel, OtpDeliveryChannel> byChannel = deliveryChannels.stream()
                .collect(Collectors.toMap(OtpDeliveryChannel::channel, Function.identity(), (a, b) -> a));
        OtpDeliveryChannel delivery = byChannel.get(channel);
        if (delivery == null) {
            throw new IllegalStateException("No OTP delivery channel configured for " + channel);
        }
        return delivery;
    }

    private static String generateCode() {
        int value = 100000 + RANDOM.nextInt(900000);
        return String.valueOf(value);
    }

    private static String normalizeEmail(String email) {
        return email == null ? "" : email.trim().toLowerCase(Locale.ROOT);
    }
}
