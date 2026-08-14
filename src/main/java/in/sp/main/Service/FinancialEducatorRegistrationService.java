package in.sp.main.Service;

import java.time.LocalDateTime;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import in.sp.main.Entities.FinancialEducator;
import in.sp.main.Entities.OtpChannel;
import in.sp.main.Entities.OtpPurpose;
import in.sp.main.Entities.PartnerProfileStatus;
import in.sp.main.Repository.FinancialEducatorRepository;
import in.sp.main.Util.MobileValidation;

@Service
public class FinancialEducatorRegistrationService {

    @Autowired
    private FinancialEducatorRepository educatorRepository;
    @Autowired
    private PasswordService passwordService;
    @Autowired
    private OtpVerificationService otpVerificationService;
    @Autowired
    private FinancialEducatorProfileService profileService;

    @Value("${otp.expiration-minutes:10}")
    private int otpExpirationMinutes;

    public void sendRegistrationOtp(String email) {
        String normalizedEmail = MobileValidation.normalizeEmail(email);
        String emailErr = MobileValidation.requireEmail(normalizedEmail);
        if (emailErr != null) throw new ResponseStatusException(HttpStatus.BAD_REQUEST, emailErr);
        if (educatorRepository.findByEmail(normalizedEmail).isPresent()) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "Email already registered");
        }
        try {
            otpVerificationService.sendOtp(normalizedEmail, OtpPurpose.FINANCIAL_REGISTER, OtpChannel.EMAIL);
        } catch (IllegalStateException ex) {
            throw new ResponseStatusException(HttpStatus.TOO_MANY_REQUESTS, ex.getMessage());
        }
    }

    public void verifyRegistrationOtp(String email, String otp) {
        String normalizedEmail = MobileValidation.normalizeEmail(email);
        String emailErr = MobileValidation.requireEmail(normalizedEmail);
        if (emailErr != null) throw new ResponseStatusException(HttpStatus.BAD_REQUEST, emailErr);
        if (educatorRepository.findByEmail(normalizedEmail).isPresent()) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "Email already registered");
        }
        if (!otpVerificationService.verifyOtp(normalizedEmail, otp, OtpPurpose.FINANCIAL_REGISTER)) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Invalid or expired email OTP");
        }
    }

    @Transactional
    public FinancialEducator registerQuick(
            String fullName, String email, String phone,
            String password, String confirmPassword, boolean acceptedTerms) {

        String normalizedEmail = MobileValidation.normalizeEmail(email);
        String trimmedName = MobileValidation.trim(fullName);
        String trimmedPhone = MobileValidation.trim(phone);

        if (trimmedName.isBlank()) throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Full name is required");
        String emailErr = MobileValidation.requireEmail(normalizedEmail);
        if (emailErr != null) throw new ResponseStatusException(HttpStatus.BAD_REQUEST, emailErr);
        String phoneErr = MobileValidation.requirePhone(trimmedPhone, true);
        if (phoneErr != null) throw new ResponseStatusException(HttpStatus.BAD_REQUEST, phoneErr);
        String passErr = MobileValidation.requirePassword(password);
        if (passErr != null) throw new ResponseStatusException(HttpStatus.BAD_REQUEST, passErr);
        String confirmErr = MobileValidation.requireConfirm(password, confirmPassword);
        if (confirmErr != null) throw new ResponseStatusException(HttpStatus.BAD_REQUEST, confirmErr);
        if (!acceptedTerms) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "You must accept the Terms and Privacy Policy");
        }
        if (!otpVerificationService.consumeVerifiedOtp(
                normalizedEmail, OtpPurpose.FINANCIAL_REGISTER, otpExpirationMinutes)) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST,
                    "Email not verified. Please verify your email OTP first.");
        }
        if (educatorRepository.findByEmail(normalizedEmail).isPresent()) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "Email already registered");
        }

        FinancialEducator e = new FinancialEducator();
        e.setFullName(trimmedName);
        e.setEmail(normalizedEmail);
        e.setPhone(trimmedPhone);
        e.setPassword(passwordService.encode(password));
        e.setSuspended(false);
        e.setAcceptedTermsAt(LocalDateTime.now());
        profileService.setLifecycleStatus(e, PartnerProfileStatus.REGISTERED);
        e = educatorRepository.save(e);
        profileService.setLifecycleStatus(e, PartnerProfileStatus.PROFILE_INCOMPLETE);
        return profileService.refreshCompletion(e);
    }

    @Transactional
    public FinancialEducator submitForVerification(FinancialEducator e) {
        profileService.refreshCompletion(e);
        if (!profileService.isReadyForVerification(e)) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST,
                    "Complete all mandatory profile fields before submitting");
        }
        PartnerProfileStatus status = e.getPartnerProfileStatus();
        if (status == PartnerProfileStatus.PENDING_ADMIN_APPROVAL) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Profile is already pending admin approval");
        }
        if (status == PartnerProfileStatus.SUSPENDED || e.isSuspended()) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "Suspended accounts cannot submit for verification");
        }
        if (status == PartnerProfileStatus.APPROVED) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "You are already an approved educator");
        }
        profileService.setLifecycleStatus(e, PartnerProfileStatus.PENDING_ADMIN_APPROVAL);
        e.setSubmittedForVerificationAt(LocalDateTime.now());
        e.setChangesRequestedNote(null);
        if (status == PartnerProfileStatus.REJECTED || status == PartnerProfileStatus.CHANGES_REQUESTED) {
            e.setRejectionReason(null);
        }
        return educatorRepository.save(e);
    }
}
