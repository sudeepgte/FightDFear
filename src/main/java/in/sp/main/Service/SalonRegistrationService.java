package in.sp.main.Service;

import java.time.LocalDateTime;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import in.sp.main.Entities.OtpChannel;
import in.sp.main.Entities.OtpPurpose;
import in.sp.main.Entities.PartnerProfileStatus;
import in.sp.main.Entities.Salon;
import in.sp.main.Repository.SalonRepository;
import in.sp.main.Util.MobileValidation;

@Service
public class SalonRegistrationService {

    @Autowired
    private SalonRepository salonRepository;

    @Autowired
    private PasswordService passwordService;

    @Autowired
    private OtpVerificationService otpVerificationService;

    @Autowired
    private SalonProfileService salonProfileService;

    @Value("${otp.expiration-minutes:10}")
    private int otpExpirationMinutes;

    public void sendRegistrationOtp(String email) {
        String normalizedEmail = MobileValidation.normalizeEmail(email);
        String emailErr = MobileValidation.requireEmail(normalizedEmail);
        if (emailErr != null) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, emailErr);
        }
        if (salonRepository.existsByEmail(normalizedEmail)
                || salonRepository.findByUsername(normalizedEmail).isPresent()) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "Email already registered");
        }
        try {
            otpVerificationService.sendOtp(normalizedEmail, OtpPurpose.SALON_REGISTER, OtpChannel.EMAIL);
        } catch (IllegalStateException ex) {
            throw new ResponseStatusException(HttpStatus.TOO_MANY_REQUESTS, ex.getMessage());
        }
    }

    public void verifyRegistrationOtp(String email, String otp) {
        String normalizedEmail = MobileValidation.normalizeEmail(email);
        String emailErr = MobileValidation.requireEmail(normalizedEmail);
        if (emailErr != null) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, emailErr);
        }
        if (salonRepository.existsByEmail(normalizedEmail)) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "Email already registered");
        }
        if (!otpVerificationService.verifyOtp(normalizedEmail, otp, OtpPurpose.SALON_REGISTER)) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Invalid or expired email OTP");
        }
    }

    @Transactional
    public Salon registerQuick(
            String username,
            String fullName,
            String email,
            String phone,
            String password,
            String confirmPassword,
            String emailOtp,
            boolean acceptedTerms) {

        String normalizedEmail = MobileValidation.normalizeEmail(email);
        String trimmedUsername = MobileValidation.trim(username).toLowerCase();
        if (trimmedUsername.isBlank()) trimmedUsername = normalizedEmail;
        String trimmedPhone = MobileValidation.trim(phone);
        String trimmedName = MobileValidation.trim(fullName);

        if (trimmedUsername.isBlank() || trimmedUsername.length() < 3) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Username must be at least 3 characters");
        }
        String emailErr = MobileValidation.requireEmail(normalizedEmail);
        if (emailErr != null) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, emailErr);
        }
        String phoneErr = MobileValidation.requirePhone(trimmedPhone, true);
        if (phoneErr != null) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, phoneErr);
        }
        String passErr = MobileValidation.requirePassword(password);
        if (passErr != null) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, passErr);
        }
        String confirmErr = MobileValidation.requireConfirm(password, confirmPassword);
        if (confirmErr != null) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, confirmErr);
        }
        if (!acceptedTerms) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "You must accept the Terms and Privacy Policy");
        }
        if (!otpVerificationService.consumeVerifiedOtp(
                normalizedEmail, OtpPurpose.SALON_REGISTER, otpExpirationMinutes)) {
            throw new ResponseStatusException(
                    HttpStatus.BAD_REQUEST, "Email not verified. Please verify your email OTP first.");
        }
        if (salonRepository.findByUsername(trimmedUsername).isPresent()) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "Username already registered");
        }
        if (salonRepository.existsByEmail(normalizedEmail)) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "Email already registered");
        }

        Salon salon = new Salon();
        salon.setUsername(trimmedUsername);
        salon.setEmail(normalizedEmail);
        salon.setPhone(trimmedPhone);
        salon.setPassword(passwordService.encode(password));
        salon.setName(trimmedName.isBlank() ? null : trimmedName);
        salon.setApproved(false);
        salon.setHygieneCertificateUrl("mobile-pending");
        salon.setAcceptedTermsAt(LocalDateTime.now());
        salonProfileService.setLifecycleStatus(salon, PartnerProfileStatus.REGISTERED);
        salon = salonRepository.save(salon);
        salonProfileService.setLifecycleStatus(salon, PartnerProfileStatus.PROFILE_INCOMPLETE);
        return salonProfileService.refreshCompletion(salon);
    }

    @Transactional
    public Salon submitForVerification(Salon salon) {
        salonProfileService.refreshCompletion(salon);
        if (!salonProfileService.isReadyForVerification(salon)) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST,
                    "Complete all mandatory profile fields before submitting");
        }
        PartnerProfileStatus status = salon.getPartnerProfileStatus();
        if (status == PartnerProfileStatus.PENDING_ADMIN_APPROVAL) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Profile is already pending admin approval");
        }
        if (status == PartnerProfileStatus.SUSPENDED) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "Suspended accounts cannot submit for verification");
        }
        salonProfileService.setLifecycleStatus(salon, PartnerProfileStatus.PENDING_ADMIN_APPROVAL);
        salon.setSubmittedForVerificationAt(LocalDateTime.now());
        salon.setChangesRequestedNote(null);
        if (status == PartnerProfileStatus.REJECTED || status == PartnerProfileStatus.CHANGES_REQUESTED) {
            salon.setRejectionReason(null);
        }
        return salonRepository.save(salon);
    }
}
