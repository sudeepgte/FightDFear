package in.sp.main.Service;

import java.time.LocalDateTime;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import in.sp.main.Entities.Investor;
import in.sp.main.Entities.OtpChannel;
import in.sp.main.Entities.OtpPurpose;
import in.sp.main.Entities.PartnerProfileStatus;
import in.sp.main.Repository.InvestorRepository;
import in.sp.main.Util.MobileValidation;

@Service
public class InvestorRegistrationService {

    @Autowired
    private InvestorRepository investorRepository;

    @Autowired
    private PasswordService passwordService;

    @Autowired
    private OtpVerificationService otpVerificationService;

    @Autowired
    private InvestorProfileService investorProfileService;

    @Value("${otp.expiration-minutes:10}")
    private int otpExpirationMinutes;

    public void sendRegistrationOtp(String email) {
        String normalizedEmail = MobileValidation.normalizeEmail(email);
        String emailErr = MobileValidation.requireEmail(normalizedEmail);
        if (emailErr != null) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, emailErr);
        }
        if (investorRepository.findByEmail(normalizedEmail).isPresent()) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "Email already registered");
        }
        try {
            otpVerificationService.sendOtp(normalizedEmail, OtpPurpose.INVESTOR_REGISTER, OtpChannel.EMAIL);
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
        if (investorRepository.findByEmail(normalizedEmail).isPresent()) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "Email already registered");
        }
        if (!otpVerificationService.verifyOtp(normalizedEmail, otp, OtpPurpose.INVESTOR_REGISTER)) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Invalid or expired email OTP");
        }
    }

    @Transactional
    public Investor registerQuick(
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
                normalizedEmail, OtpPurpose.INVESTOR_REGISTER, otpExpirationMinutes)) {
            throw new ResponseStatusException(
                    HttpStatus.BAD_REQUEST, "Email not verified. Please verify your email OTP first.");
        }
        if (investorRepository.findByEmail(normalizedEmail).isPresent()) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "Email already registered");
        }

        Investor investor = new Investor();
        investor.setFullName(trimmedName);
        investor.setEmail(normalizedEmail);
        investor.setPhone(trimmedPhone);
        investor.setPassword(passwordService.encode(password));
        investor.setSubscribed(false);
        investor.setAcceptedTermsAt(LocalDateTime.now());
        investorProfileService.setLifecycleStatus(investor, PartnerProfileStatus.REGISTERED);
        investor = investorRepository.save(investor);
        investorProfileService.setLifecycleStatus(investor, PartnerProfileStatus.PROFILE_INCOMPLETE);
        return investorProfileService.refreshCompletion(investor);
    }

    @Transactional
    public Investor submitForVerification(Investor investor) {
        investorProfileService.refreshCompletion(investor);
        if (!investorProfileService.isReadyForVerification(investor)) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST,
                    "Complete all mandatory profile fields before submitting");
        }
        PartnerProfileStatus status = investor.getPartnerProfileStatus();
        if (status == PartnerProfileStatus.PENDING_ADMIN_APPROVAL) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Profile is already pending admin approval");
        }
        if (status == PartnerProfileStatus.SUSPENDED) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "Suspended accounts cannot submit for verification");
        }
        investorProfileService.setLifecycleStatus(investor, PartnerProfileStatus.PENDING_ADMIN_APPROVAL);
        investor.setSubmittedForVerificationAt(LocalDateTime.now());
        investor.setChangesRequestedNote(null);
        if (status == PartnerProfileStatus.REJECTED || status == PartnerProfileStatus.CHANGES_REQUESTED) {
            investor.setRejectionReason(null);
        }
        return investorRepository.save(investor);
    }
}
