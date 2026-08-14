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
import in.sp.main.Entities.User;
import in.sp.main.Entities.VerificationStatus;
import in.sp.main.Repository.UserRepository;
import in.sp.main.Util.MobileValidation;

@Service
public class CreatorRegistrationService {

    @Autowired
    private UserRepository userRepository;
    @Autowired
    private PasswordService passwordService;
    @Autowired
    private OtpVerificationService otpVerificationService;
    @Autowired
    private CreatorProfileService creatorProfileService;
    @Autowired
    private UserService userService;

    @Value("${otp.expiration-minutes:10}")
    private int otpExpirationMinutes;

    public void sendRegistrationOtp(String email) {
        String normalizedEmail = MobileValidation.normalizeEmail(email);
        String emailErr = MobileValidation.requireEmail(normalizedEmail);
        if (emailErr != null) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, emailErr);
        }
        if (userRepository.findByEmail(normalizedEmail).isPresent()) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "Email already registered");
        }
        try {
            otpVerificationService.sendOtp(normalizedEmail, OtpPurpose.CREATOR_REGISTER, OtpChannel.EMAIL);
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
        if (userRepository.findByEmail(normalizedEmail).isPresent()) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "Email already registered");
        }
        if (!otpVerificationService.verifyOtp(normalizedEmail, otp, OtpPurpose.CREATOR_REGISTER)) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Invalid or expired email OTP");
        }
    }

    @Transactional
    public User registerQuick(
            String fullName,
            String email,
            String phone,
            String password,
            String confirmPassword,
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
                normalizedEmail, OtpPurpose.CREATOR_REGISTER, otpExpirationMinutes)) {
            throw new ResponseStatusException(
                    HttpStatus.BAD_REQUEST, "Email not verified. Please verify your email OTP first.");
        }
        if (userRepository.findByEmail(normalizedEmail).isPresent()) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "Email already registered");
        }

        User user = new User();
        user.setFullName(trimmedName);
        user.setEmail(normalizedEmail);
        user.setPhoneNumber(trimmedPhone);
        user.setPassword(passwordService.encode(password));
        user.setVerificationStatus(VerificationStatus.PENDING);
        creatorProfileService.setLifecycleStatus(user, PartnerProfileStatus.REGISTERED);
        user = userService.createUser(user);
        creatorProfileService.setLifecycleStatus(user, PartnerProfileStatus.PROFILE_INCOMPLETE);
        return creatorProfileService.refreshCompletion(user);
    }

    @Transactional
    public User submitForVerification(User user) {
        if (user.getCreatorProfileStatus() == null) {
            creatorProfileService.setLifecycleStatus(user, PartnerProfileStatus.PROFILE_INCOMPLETE);
        }
        creatorProfileService.refreshCompletion(user);
        if (!creatorProfileService.isReadyForVerification(user)) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST,
                    "Complete all mandatory profile fields before submitting");
        }
        PartnerProfileStatus status = user.getCreatorProfileStatus();
        if (status == PartnerProfileStatus.PENDING_ADMIN_APPROVAL) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Profile is already pending admin approval");
        }
        if (status == PartnerProfileStatus.SUSPENDED || user.isBannedCreator()) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "Suspended accounts cannot submit for verification");
        }
        if (status == PartnerProfileStatus.APPROVED) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "You are already an approved creator");
        }
        creatorProfileService.setLifecycleStatus(user, PartnerProfileStatus.PENDING_ADMIN_APPROVAL);
        user.setCreatorSubmittedForVerificationAt(LocalDateTime.now());
        user.setCreatorChangesRequestedNote(null);
        if (status == PartnerProfileStatus.REJECTED || status == PartnerProfileStatus.CHANGES_REQUESTED) {
            user.setCreatorRejectionReason(null);
        }
        return userRepository.save(user);
    }
}
