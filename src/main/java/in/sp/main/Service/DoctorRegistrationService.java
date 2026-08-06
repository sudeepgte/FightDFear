package in.sp.main.Service;

import java.time.LocalDateTime;
import java.util.Locale;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import in.sp.main.Entities.Doctor;
import in.sp.main.Entities.DoctorProfileStatus;
import in.sp.main.Entities.Gender;
import in.sp.main.Entities.OtpChannel;
import in.sp.main.Entities.OtpPurpose;
import in.sp.main.Repository.DoctorRepository;
import in.sp.main.Util.MobileValidation;

@Service
public class DoctorRegistrationService {

    @Autowired
    private DoctorRepository doctorRepository;

    @Autowired
    private PasswordService passwordService;

    @Autowired
    private OtpVerificationService otpVerificationService;

    @Autowired
    private DoctorProfileService doctorProfileService;

    @Transactional
    public Doctor registerQuick(
            String fullName,
            String email,
            String phone,
            String password,
            String confirmPassword,
            String emailOtp,
            boolean acceptedTerms) {

        String normalizedEmail = MobileValidation.normalizeEmail(email);
        String trimmedName = trim(fullName);
        String trimmedPhone = trim(phone);

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

        if (!otpVerificationService.verifyOtp(normalizedEmail, emailOtp, OtpPurpose.DOCTOR_REGISTER)) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Invalid or expired email OTP");
        }

        if (doctorRepository.findByEmail(normalizedEmail).isPresent()) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "Email already registered");
        }
        if (doctorRepository.findByPhone(trimmedPhone).isPresent()) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "Phone number already registered");
        }

        Doctor doctor = new Doctor();
        doctor.setFullName(trimmedName);
        doctor.setEmail(normalizedEmail);
        doctor.setPhone(trimmedPhone);
        doctor.setPassword(passwordService.encode(password));
        doctor.setGender(Gender.FEMALE);
        doctorProfileService.setLifecycleStatus(doctor, DoctorProfileStatus.REGISTERED);
        doctor.setAcceptedTermsAt(LocalDateTime.now());
        doctor.setRating(0.0);
        doctor.setEmergencyAvailable(false);
        doctorProfileService.refreshCompletion(doctor);

        return doctorRepository.save(doctor);
    }

    public void initializeLegacyRegisteredDoctor(Doctor doctor) {
        doctorProfileService.setLifecycleStatus(doctor, DoctorProfileStatus.PROFILE_INCOMPLETE);
        if (doctor.getRating() == null) {
            doctor.setRating(0.0);
        }
        if (doctor.getEmergencyAvailable() == null) {
            doctor.setEmergencyAvailable(false);
        }
        doctorProfileService.refreshCompletion(doctor);
    }

    @Transactional
    public void submitForVerification(Doctor doctor) {
        doctorProfileService.refreshCompletion(doctor);
        if (!doctorProfileService.isReadyForVerification(doctor)) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST,
                    "Complete all mandatory profile fields and upload required documents before submitting");
        }
        DoctorProfileStatus status = doctor.getDoctorProfileStatus();
        if (status == DoctorProfileStatus.APPROVED) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Profile is already approved");
        }
        if (status == DoctorProfileStatus.PENDING_ADMIN_APPROVAL) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Profile is already pending admin approval");
        }
        doctorProfileService.setLifecycleStatus(doctor, DoctorProfileStatus.PENDING_ADMIN_APPROVAL);
        doctor.setSubmittedForVerificationAt(LocalDateTime.now());
        doctor.setChangesRequestedNote(null);
        doctorRepository.save(doctor);
    }

    public void sendRegistrationOtp(String email) {
        String normalizedEmail = MobileValidation.normalizeEmail(email);
        String emailErr = MobileValidation.requireEmail(normalizedEmail);
        if (emailErr != null) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, emailErr);
        }
        if (doctorRepository.findByEmail(normalizedEmail).isPresent()) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "Email already registered");
        }
        try {
            otpVerificationService.sendOtp(normalizedEmail, OtpPurpose.DOCTOR_REGISTER, OtpChannel.EMAIL);
        } catch (IllegalStateException ex) {
            throw new ResponseStatusException(HttpStatus.TOO_MANY_REQUESTS, ex.getMessage());
        }
    }

    public Optional<Doctor> findByEmail(String email) {
        return doctorRepository.findByEmail(MobileValidation.normalizeEmail(email));
    }

    public Doctor requireLoginDoctor(Doctor doctor) {
        if (doctor == null) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Doctor login required");
        }
        DoctorProfileStatus status = doctor.getDoctorProfileStatus();
        if (status == null) {
            status = DoctorProfileStatus.PROFILE_INCOMPLETE;
            doctorProfileService.setLifecycleStatus(doctor, status);
        }
        if (status == DoctorProfileStatus.SUSPENDED) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "Your account has been suspended. Contact support.");
        }
        doctorProfileService.ensureLoginProfileState(doctor);
        return doctorRepository.save(doctor);
    }

    private static String trim(String value) {
        return value == null ? "" : value.trim();
    }
}
