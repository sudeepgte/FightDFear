package in.sp.main.Service;

import java.time.LocalDateTime;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import in.sp.main.Entities.CentreProfileStatus;
import in.sp.main.Entities.MartialArtsCenter;
import in.sp.main.Entities.OtpPurpose;
import in.sp.main.Repository.MartialArtsCenterRepository;
import in.sp.main.Util.MobileValidation;

@Service
public class CentreRegistrationService {

    @Autowired
    private MartialArtsCenterRepository centreRepository;

    @Autowired
    private PasswordService passwordService;

    @Autowired
    private OtpVerificationService otpVerificationService;

    @Autowired
    private CentreProfileService centreProfileService;

    @Value("${otp.expiration-minutes:10}")
    private int otpExpirationMinutes;

    public void sendRegistrationOtp(String email) {
        String normalizedEmail = MobileValidation.normalizeEmail(email);
        String emailErr = MobileValidation.requireEmail(normalizedEmail);
        if (emailErr != null) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, emailErr);
        }
        if (centreRepository.findByEmail(normalizedEmail).isPresent()) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "Email already registered");
        }
        otpVerificationService.sendOtp(normalizedEmail, OtpPurpose.CENTRE_REGISTER, in.sp.main.Entities.OtpChannel.EMAIL);
    }

    public void verifyRegistrationOtp(String email, String otp) {
        String normalizedEmail = MobileValidation.normalizeEmail(email);
        String emailErr = MobileValidation.requireEmail(normalizedEmail);
        if (emailErr != null) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, emailErr);
        }
        if (centreRepository.findByEmail(normalizedEmail).isPresent()) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "Email already registered");
        }
        if (!otpVerificationService.verifyOtp(normalizedEmail, otp, OtpPurpose.CENTRE_REGISTER)) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Invalid or expired email OTP");
        }
    }

    @Transactional
    public MartialArtsCenter registerQuick(
            String name,
            String email,
            String phone,
            String password,
            String confirmPassword,
            String emailOtp,
            boolean acceptedTerms,
            String contactPerson) {

        String normalizedEmail = MobileValidation.normalizeEmail(email);
        String trimmedName = MobileValidation.trim(name);
        String trimmedPhone = MobileValidation.trim(phone);

        if (trimmedName.isBlank()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Centre / trainer name is required");
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
                normalizedEmail, OtpPurpose.CENTRE_REGISTER, otpExpirationMinutes)) {
            throw new ResponseStatusException(
                    HttpStatus.BAD_REQUEST, "Email not verified. Please verify your email OTP first.");
        }
        if (centreRepository.findByEmail(normalizedEmail).isPresent()) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "Email already registered");
        }

        MartialArtsCenter centre = new MartialArtsCenter();
        centre.setName(trimmedName);
        centre.setEmail(normalizedEmail);
        centre.setPhoneNumber(trimmedPhone);
        centre.setPassword(passwordService.encode(password));
        centre.setContactPerson(MobileValidation.trim(contactPerson).isBlank()
                ? trimmedName : MobileValidation.trim(contactPerson));
        centre.setApproved(false);
        centre.setAcceptedTermsAt(LocalDateTime.now());
        centreProfileService.setLifecycleStatus(centre, CentreProfileStatus.REGISTERED);
        centre = centreRepository.save(centre);
        centreProfileService.setLifecycleStatus(centre, CentreProfileStatus.PROFILE_INCOMPLETE);
        return centreProfileService.refreshCompletion(centre);
    }

    @Transactional
    public MartialArtsCenter submitForVerification(MartialArtsCenter centre) {
        centreProfileService.refreshCompletion(centre);
        if (!centreProfileService.isReadyForVerification(centre)) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST,
                    "Complete all mandatory profile fields and upload required documents before submitting");
        }
        CentreProfileStatus status = centre.getCentreProfileStatus();
        if (status == CentreProfileStatus.PENDING_ADMIN_APPROVAL) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Profile is already pending admin approval");
        }
        if (status == CentreProfileStatus.SUSPENDED) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "Suspended accounts cannot submit for verification");
        }
        centreProfileService.setLifecycleStatus(centre, CentreProfileStatus.PENDING_ADMIN_APPROVAL);
        centre.setSubmittedForVerificationAt(LocalDateTime.now());
        centre.setChangesRequestedNote(null);
        if (status == CentreProfileStatus.REJECTED || status == CentreProfileStatus.CHANGES_REQUESTED) {
            centre.setRejectionReason(null);
        }
        return centreRepository.save(centre);
    }
}
