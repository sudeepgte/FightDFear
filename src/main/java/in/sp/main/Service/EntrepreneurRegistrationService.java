package in.sp.main.Service;

import java.time.LocalDateTime;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import in.sp.main.Entities.Entrepreneur;
import in.sp.main.Entities.OtpChannel;
import in.sp.main.Entities.OtpPurpose;
import in.sp.main.Entities.PartnerProfileStatus;
import in.sp.main.Repository.EntrepreneurRepository;
import in.sp.main.Util.MobileValidation;

@Service
public class EntrepreneurRegistrationService {

    @Autowired
    private EntrepreneurRepository entrepreneurRepository;

    @Autowired
    private PasswordService passwordService;

    @Autowired
    private OtpVerificationService otpVerificationService;

    @Autowired
    private EntrepreneurProfileService entrepreneurProfileService;

    @Value("${otp.expiration-minutes:10}")
    private int otpExpirationMinutes;

    public void sendRegistrationOtp(String email) {
        String normalizedEmail = MobileValidation.normalizeEmail(email);
        String emailErr = MobileValidation.requireEmail(normalizedEmail);
        if (emailErr != null) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, emailErr);
        }
        if (entrepreneurRepository.findByEmail(normalizedEmail).isPresent()) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "Email already registered");
        }
        try {
            otpVerificationService.sendOtp(normalizedEmail, OtpPurpose.ENTREPRENEUR_REGISTER, OtpChannel.EMAIL);
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
        if (entrepreneurRepository.findByEmail(normalizedEmail).isPresent()) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "Email already registered");
        }
        if (!otpVerificationService.verifyOtp(normalizedEmail, otp, OtpPurpose.ENTREPRENEUR_REGISTER)) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Invalid or expired email OTP");
        }
    }

    @Transactional
    public Entrepreneur registerQuick(
            String fullName,
            String email,
            String phone,
            String password,
            String confirmPassword,
            String emailOtp,
            boolean acceptedTerms) {

        String normalizedEmail = MobileValidation.normalizeEmail(email);
        String trimmedName = MobileValidation.trim(fullName);
        String trimmedPhone = MobileValidation.trim(phone);

        if (trimmedName.isBlank()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Full name is required");
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
                normalizedEmail, OtpPurpose.ENTREPRENEUR_REGISTER, otpExpirationMinutes)) {
            throw new ResponseStatusException(
                    HttpStatus.BAD_REQUEST, "Email not verified. Please verify your email OTP first.");
        }
        if (entrepreneurRepository.findByEmail(normalizedEmail).isPresent()) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "Email already registered");
        }

        Entrepreneur entrepreneur = new Entrepreneur();
        entrepreneur.setFullName(trimmedName);
        entrepreneur.setEmail(normalizedEmail);
        entrepreneur.setPhone(trimmedPhone);
        entrepreneur.setPassword(passwordService.encode(password));
        entrepreneur.setAcceptedTermsAt(LocalDateTime.now());
        entrepreneurProfileService.setLifecycleStatus(entrepreneur, PartnerProfileStatus.REGISTERED);
        entrepreneur = entrepreneurRepository.save(entrepreneur);
        entrepreneurProfileService.setLifecycleStatus(entrepreneur, PartnerProfileStatus.PROFILE_INCOMPLETE);
        return entrepreneurProfileService.refreshCompletion(entrepreneur);
    }

    @Transactional
    public Entrepreneur submitForVerification(Entrepreneur entrepreneur) {
        entrepreneurProfileService.refreshCompletion(entrepreneur);
        if (!entrepreneurProfileService.isReadyForVerification(entrepreneur)) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST,
                    "Complete all mandatory profile fields before submitting");
        }
        PartnerProfileStatus status = entrepreneur.getPartnerProfileStatus();
        if (status == PartnerProfileStatus.PENDING_ADMIN_APPROVAL) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Profile is already pending admin approval");
        }
        if (status == PartnerProfileStatus.SUSPENDED) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "Suspended accounts cannot submit for verification");
        }
        entrepreneurProfileService.setLifecycleStatus(entrepreneur, PartnerProfileStatus.PENDING_ADMIN_APPROVAL);
        entrepreneur.setSubmittedForVerificationAt(LocalDateTime.now());
        entrepreneur.setChangesRequestedNote(null);
        if (status == PartnerProfileStatus.REJECTED || status == PartnerProfileStatus.CHANGES_REQUESTED) {
            entrepreneur.setRejectionReason(null);
        }
        return entrepreneurRepository.save(entrepreneur);
    }
}
