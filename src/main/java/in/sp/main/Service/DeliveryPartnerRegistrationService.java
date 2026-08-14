package in.sp.main.Service;

import java.time.LocalDateTime;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import in.sp.main.Entities.DeliveryPartner;
import in.sp.main.Entities.OtpChannel;
import in.sp.main.Entities.OtpPurpose;
import in.sp.main.Entities.PartnerProfileStatus;
import in.sp.main.Repository.DeliveryPartnerRepository;
import in.sp.main.Util.MobileValidation;

@Service
public class DeliveryPartnerRegistrationService {

    @Autowired
    private DeliveryPartnerRepository deliveryPartnerRepository;
    @Autowired
    private PasswordService passwordService;
    @Autowired
    private OtpVerificationService otpVerificationService;
    @Autowired
    private DeliveryPartnerProfileService deliveryPartnerProfileService;

    @Value("${otp.expiration-minutes:10}")
    private int otpExpirationMinutes;

    public void sendRegistrationOtp(String email) {
        String normalizedEmail = MobileValidation.normalizeEmail(email);
        String emailErr = MobileValidation.requireEmail(normalizedEmail);
        if (emailErr != null) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, emailErr);
        }
        if (deliveryPartnerRepository.findByEmail(normalizedEmail).isPresent()) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "Email already registered");
        }
        try {
            otpVerificationService.sendOtp(normalizedEmail, OtpPurpose.DELIVERY_REGISTER, OtpChannel.EMAIL);
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
        if (deliveryPartnerRepository.findByEmail(normalizedEmail).isPresent()) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "Email already registered");
        }
        if (!otpVerificationService.verifyOtp(normalizedEmail, otp, OtpPurpose.DELIVERY_REGISTER)) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Invalid or expired email OTP");
        }
    }

    @Transactional
    public DeliveryPartner registerQuick(
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
                normalizedEmail, OtpPurpose.DELIVERY_REGISTER, otpExpirationMinutes)) {
            throw new ResponseStatusException(
                    HttpStatus.BAD_REQUEST, "Email not verified. Please verify your email OTP first.");
        }
        if (deliveryPartnerRepository.findByEmail(normalizedEmail).isPresent()) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "Email already registered");
        }

        DeliveryPartner partner = new DeliveryPartner();
        partner.setFullName(trimmedName);
        partner.setEmail(normalizedEmail);
        partner.setPhone(trimmedPhone);
        partner.setPassword(passwordService.encode(password));
        partner.setSuspended(false);
        partner.setRating(0.0);
        partner.setAcceptedTermsAt(LocalDateTime.now());
        deliveryPartnerProfileService.setLifecycleStatus(partner, PartnerProfileStatus.REGISTERED);
        partner = deliveryPartnerRepository.save(partner);
        deliveryPartnerProfileService.setLifecycleStatus(partner, PartnerProfileStatus.PROFILE_INCOMPLETE);
        return deliveryPartnerProfileService.refreshCompletion(partner);
    }

    @Transactional
    public DeliveryPartner submitForVerification(DeliveryPartner partner) {
        deliveryPartnerProfileService.refreshCompletion(partner);
        if (!deliveryPartnerProfileService.isReadyForVerification(partner)) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST,
                    "Complete all mandatory profile fields before submitting");
        }
        PartnerProfileStatus status = partner.getPartnerProfileStatus();
        if (status == PartnerProfileStatus.PENDING_ADMIN_APPROVAL) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Profile is already pending admin approval");
        }
        if (status == PartnerProfileStatus.SUSPENDED) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "Suspended accounts cannot submit for verification");
        }
        deliveryPartnerProfileService.setLifecycleStatus(partner, PartnerProfileStatus.PENDING_ADMIN_APPROVAL);
        partner.setSubmittedForVerificationAt(LocalDateTime.now());
        partner.setChangesRequestedNote(null);
        if (status == PartnerProfileStatus.REJECTED || status == PartnerProfileStatus.CHANGES_REQUESTED) {
            partner.setRejectionReason(null);
        }
        return deliveryPartnerRepository.save(partner);
    }
}
