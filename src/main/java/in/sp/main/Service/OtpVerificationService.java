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

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.support.TransactionTemplate;
import org.springframework.web.server.ResponseStatusException;

import in.sp.main.Entities.EmailOtpVerification;
import in.sp.main.Entities.OtpChannel;
import in.sp.main.Entities.OtpPurpose;
import in.sp.main.Exception.RateLimitExceededException;
import in.sp.main.Repository.EmailOtpVerificationRepository;
import in.sp.main.Service.Otp.OtpDeliveryChannel;

@Service
public class OtpVerificationService {

    private static final Logger log = LoggerFactory.getLogger(OtpVerificationService.class);
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

    @Autowired
    private TransactionTemplate transactionTemplate;

    @Autowired
    private SMSService smsService;

    @Value("${otp.expiration-minutes:10}")
    private int expirationMinutes;

    @Value("${otp.resend-cooldown-seconds:60}")
    private int resendCooldownSeconds;

    @Value("${otp.email.enabled:true}")
    private boolean emailEnabled;

    @Value("${otp.sms.enabled:false}")
    private boolean smsEnabled;

    public boolean isPhoneOtpAvailable() {
        return smsService.isConfigured();
    }

    @Transactional
    public void sendPhoneOtp(String phoneRaw, OtpPurpose purpose) {
        String phone10 = normalizePhone10(phoneRaw);
        if (phone10 == null) {
            throw new IllegalArgumentException("Valid 10-digit phone number is required");
        }
        if (!isPhoneOtpAvailable()) {
            throw new IllegalStateException("SMS OTP is not configured on this server");
        }

        String storageKey = phoneStorageKey(phone10);
        rateLimitService.checkOrThrow("otp:sms:" + phone10, 5, Duration.ofHours(1));

        Optional<EmailOtpVerification> latest = otpRepository
                .findTopByEmailAndPurposeAndVerifiedFalseOrderByCreatedAtDesc(storageKey, purpose);
        if (latest.isPresent()) {
            EmailOtpVerification existing = latest.get();
            LocalDateTime cooldownUntil = existing.getCreatedAt().plusSeconds(resendCooldownSeconds);
            if (LocalDateTime.now().isBefore(cooldownUntil)) {
                throw new IllegalStateException(cooldownMessage(cooldownUntil));
            }
        }

        String code = generateCode();
        String body = "Your Fight D Fear verification code is " + code
                + ". Valid for " + expirationMinutes + " minutes.";
        try {
            OtpDeliveryChannel delivery = resolveChannel(OtpChannel.SMS);
            delivery.send(phone10, "Fight D Fear OTP", body);
        } catch (ResponseStatusException ex) {
            throw ex;
        } catch (Exception ex) {
            throw new ResponseStatusException(
                    org.springframework.http.HttpStatus.SERVICE_UNAVAILABLE,
                    "Could not send verification SMS. Please try again in a moment.");
        }

        EmailOtpVerification record = new EmailOtpVerification();
        record.setEmail(storageKey);
        record.setCodeHash(passwordEncoder.encode(code));
        record.setPurpose(purpose);
        record.setChannel(OtpChannel.SMS);
        record.setVerified(false);
        record.setExpiresAt(LocalDateTime.now().plusMinutes(expirationMinutes));
        otpRepository.save(record);
    }

    @Transactional
    public boolean verifyPhoneOtp(String phoneRaw, String code, OtpPurpose purpose) {
        String phone10 = normalizePhone10(phoneRaw);
        if (phone10 == null || code == null || code.isBlank()) {
            return false;
        }
        return verifyOtpForStorageKey(phoneStorageKey(phone10), code, purpose);
    }

    @Transactional
    public boolean consumeVerifiedPhoneOtp(String phoneRaw, OtpPurpose purpose, int maxAgeMinutes) {
        String phone10 = normalizePhone10(phoneRaw);
        if (phone10 == null) {
            return false;
        }
        return consumeVerifiedOtpForStorageKey(phoneStorageKey(phone10), purpose, maxAgeMinutes);
    }

    /**
     * Send OTP then persist the hashed code.
     * SMTP runs outside any DB transaction so mail latency cannot hold a JDBC connection
     * (common cause of intermittent "Could not send verification email" failures).
     */
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

        transactionTemplate.executeWithoutResult(status -> prepareSend(normalized, purpose, channel));

        String code = generateCode();
        String subject = "Your Fight D Fear verification code";
        String body = "Your verification code is: " + code + "\n\n"
                + "This code expires in " + expirationMinutes + " minutes.\n"
                + "If you did not request this, you can ignore this email.";
        try {
            if (channel == OtpChannel.EMAIL) {
                emailService.sendEmail(normalized, subject, body);
            } else {
                OtpDeliveryChannel delivery = resolveChannel(channel);
                delivery.send(normalized, subject, body);
            }
        } catch (ResponseStatusException ex) {
            throw ex;
        } catch (RateLimitExceededException ex) {
            throw ex;
        } catch (IllegalStateException ex) {
            log.error("OTP email delivery failed for {} purpose={}: {}", normalized, purpose, ex.getMessage());
            throw new ResponseStatusException(
                    HttpStatus.SERVICE_UNAVAILABLE,
                    userFacingMailError(ex.getMessage()));
        } catch (Exception ex) {
            log.error("OTP email delivery failed for {} purpose={}", normalized, purpose, ex);
            throw new ResponseStatusException(
                    HttpStatus.SERVICE_UNAVAILABLE,
                    "Unable to send verification email right now. Please try again.");
        }

        transactionTemplate.executeWithoutResult(status -> persistOtp(normalized, purpose, channel, code));
        log.info("OTP stored for {} purpose={} expiresInMinutes={}", normalized, purpose, expirationMinutes);
    }

    private void prepareSend(String normalized, OtpPurpose purpose, OtpChannel channel) {
        if (channel == OtpChannel.EMAIL) {
            rateLimitService.checkOrThrow("otp:email:" + normalized, 5, Duration.ofHours(1));
        }
        Optional<EmailOtpVerification> latest = otpRepository
                .findTopByEmailAndPurposeAndVerifiedFalseOrderByCreatedAtDesc(normalized, purpose);
        if (latest.isPresent()) {
            EmailOtpVerification existing = latest.get();
            LocalDateTime cooldownUntil = existing.getCreatedAt().plusSeconds(resendCooldownSeconds);
            if (LocalDateTime.now().isBefore(cooldownUntil)) {
                throw new IllegalStateException(cooldownMessage(cooldownUntil));
            }
        }
    }

    public int getExpirationMinutes() {
        return expirationMinutes;
    }

    public int getResendCooldownSeconds() {
        return resendCooldownSeconds;
    }

    private String cooldownMessage(LocalDateTime cooldownUntil) {
        long wait = Math.max(1, Duration.between(LocalDateTime.now(), cooldownUntil).getSeconds());
        return "Please wait " + wait + " seconds before requesting another OTP. Each code is valid for "
                + expirationMinutes + " minutes.";
    }

    private void persistOtp(String normalized, OtpPurpose purpose, OtpChannel channel, String code) {
        EmailOtpVerification record = new EmailOtpVerification();
        record.setEmail(normalized);
        record.setCodeHash(passwordEncoder.encode(code));
        record.setPurpose(purpose);
        record.setChannel(channel);
        record.setVerified(false);
        record.setExpiresAt(LocalDateTime.now().plusMinutes(expirationMinutes));
        otpRepository.save(record);
    }

    private static String userFacingMailError(String detail) {
        if (detail == null || detail.isBlank()) {
            return "Unable to send verification email right now. Please try again.";
        }
        String d = detail.toLowerCase(Locale.ROOT);
        if (d.contains("not configured") || d.contains("mail.username is empty")) {
            return "Unable to send verification email right now. Email service is not configured.";
        }
        if (d.contains("authentication") || d.contains("username and password not accepted")
                || d.contains("535") || d.contains("app password")) {
            return "Unable to send verification email right now. Email authentication failed.";
        }
        if (d.contains("timed out") || d.contains("timeout") || d.contains("connection")) {
            return "Unable to send verification email right now. Mail server connection failed.";
        }
        return "Unable to send verification email right now. Please try again.";
    }

    @Transactional
    public boolean verifyOtp(String email, String code, OtpPurpose purpose) {
        String normalized = normalizeEmail(email);
        if (normalized.isBlank() || code == null || code.isBlank()) {
            return false;
        }
        return verifyOtpForStorageKey(normalized, code, purpose);
    }

    @Transactional
    public boolean consumeVerifiedOtp(String email, OtpPurpose purpose, int maxAgeMinutes) {
        String normalized = normalizeEmail(email);
        return consumeVerifiedOtpForStorageKey(normalized, purpose, maxAgeMinutes);
    }

    public boolean hasVerifiedOtp(String email, OtpPurpose purpose, int maxAgeMinutes) {
        String normalized = normalizeEmail(email);
        return hasVerifiedOtpForStorageKey(normalized, purpose, maxAgeMinutes);
    }

    public boolean hasVerifiedPhoneOtp(String phoneRaw, OtpPurpose purpose, int maxAgeMinutes) {
        String phone10 = normalizePhone10(phoneRaw);
        if (phone10 == null) {
            return false;
        }
        return hasVerifiedOtpForStorageKey(phoneStorageKey(phone10), purpose, maxAgeMinutes);
    }

    private boolean verifyOtpForStorageKey(String storageKey, String code, OtpPurpose purpose) {
        Optional<EmailOtpVerification> opt = otpRepository
                .findTopByEmailAndPurposeAndVerifiedFalseOrderByCreatedAtDesc(storageKey, purpose);
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
        record.setExpiresAt(LocalDateTime.now().plusMinutes(expirationMinutes));
        otpRepository.save(record);
        return true;
    }

    private boolean hasVerifiedOtpForStorageKey(String storageKey, OtpPurpose purpose, int maxAgeMinutes) {
        if (storageKey == null || storageKey.isBlank()) {
            return false;
        }
        Optional<EmailOtpVerification> opt = otpRepository
                .findTopByEmailAndPurposeAndVerifiedTrueOrderByCreatedAtDesc(storageKey, purpose);
        if (opt.isEmpty()) {
            return false;
        }
        EmailOtpVerification record = opt.get();
        if (record.isExpired()) {
            return false;
        }
        LocalDateTime maxAge = LocalDateTime.now().minusMinutes(maxAgeMinutes);
        return !record.getCreatedAt().isBefore(maxAge);
    }

    private boolean consumeVerifiedOtpForStorageKey(String storageKey, OtpPurpose purpose, int maxAgeMinutes) {
        Optional<EmailOtpVerification> opt = otpRepository
                .findTopByEmailAndPurposeAndVerifiedTrueOrderByCreatedAtDesc(storageKey, purpose);
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

    private static String normalizePhone10(String raw) {
        if (raw == null) {
            return null;
        }
        String digits = raw.replaceAll("\\D", "");
        return digits.length() == 10 ? digits : null;
    }

    private static String phoneStorageKey(String phone10) {
        return "phone:" + phone10;
    }
}
