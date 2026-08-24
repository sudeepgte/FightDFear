package in.sp.main.Controller;

import in.sp.main.Config.JwtUtil;
import in.sp.main.Entities.EmergencyContact;
import in.sp.main.Entities.Gender;
import in.sp.main.Entities.User;
import in.sp.main.Entities.VerificationStatus;
import in.sp.main.Repository.UserRepository;
import in.sp.main.Entities.OtpChannel;
import in.sp.main.Entities.OtpPurpose;
import in.sp.main.Service.OtpVerificationService;
import in.sp.main.Service.PasswordService;
import in.sp.main.Service.RateLimitService;
import in.sp.main.Service.UserService;
import in.sp.main.Util.MobileValidation;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.time.Period;
import java.time.Duration;
import java.util.LinkedHashMap;
import java.util.Map;

/**
 * JSON auth for native / Flutter clients. Returns a Bearer JWT (not cookie-only).
 */
@RestController
@RequestMapping("/api/auth")
public class MobileAuthController {

    @Autowired
    private UserService userService;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PasswordService passwordService;

    @Autowired
    private JwtUtil jwtUtil;

    @Autowired
    private RateLimitService rateLimitService;

    @Autowired
    private OtpVerificationService otpVerificationService;

    @org.springframework.beans.factory.annotation.Value("${otp.expiration-minutes:10}")
    private int otpExpirationMinutes;

    @GetMapping("/health")
    public ResponseEntity<Map<String, Object>> health() {
        Map<String, Object> response = new LinkedHashMap<>();
        response.put("success", true);
        response.put("status", "ok");
        return ResponseEntity.ok(response);
    }

    @PostMapping("/otp/send-email")
    public ResponseEntity<Map<String, Object>> sendEmailOtp(@RequestBody Map<String, String> body) {
        String email = MobileValidation.normalizeEmail(body == null ? null : body.get("email"));
        String emailErr = MobileValidation.requireEmail(email);
        if (emailErr != null) {
            return ResponseEntity.badRequest().body(error(emailErr));
        }
        if (userRepository.findByEmail(email).isPresent()) {
            return ResponseEntity.status(HttpStatus.CONFLICT).body(error("Email already registered. Please sign in."));
        }
        try {
            otpVerificationService.sendOtp(email, OtpPurpose.USER_REGISTER, OtpChannel.EMAIL);
            Map<String, Object> res = new LinkedHashMap<>();
            res.put("success", true);
            res.put("message", "Verification code sent to your email");
            res.put("channel", "EMAIL");
            return ResponseEntity.ok(res);
        } catch (org.springframework.web.server.ResponseStatusException ex) {
            return ResponseEntity.status(ex.getStatusCode()).body(error(ex.getReason()));
        } catch (IllegalStateException ex) {
            return ResponseEntity.status(HttpStatus.TOO_MANY_REQUESTS).body(error(ex.getMessage()));
        }
    }

    @PostMapping("/otp/verify-email")
    public ResponseEntity<Map<String, Object>> verifyEmailOtp(@RequestBody Map<String, String> body) {
        String email = MobileValidation.normalizeEmail(body == null ? null : body.get("email"));
        String otp = body == null || body.get("otp") == null ? "" : body.get("otp").trim();
        String emailErr = MobileValidation.requireEmail(email);
        if (emailErr != null) {
            return ResponseEntity.badRequest().body(error(emailErr));
        }
        if (!otpVerificationService.verifyOtp(email, otp, OtpPurpose.USER_REGISTER)) {
            return ResponseEntity.badRequest().body(error("Invalid or expired email OTP"));
        }
        Map<String, Object> res = new LinkedHashMap<>();
        res.put("success", true);
        res.put("message", "Email verified successfully");
        return ResponseEntity.ok(res);
    }

    @PostMapping("/register")
    public ResponseEntity<Map<String, Object>> register(@RequestBody Map<String, String> body) {
        Map<String, Object> response = new LinkedHashMap<>();
        if (body == null) {
            response.put("success", false);
            response.put("error", "Request body is required");
            return ResponseEntity.badRequest().body(response);
        }

        String email = MobileValidation.normalizeEmail(body.get("email"));
        String password = body.get("password") == null ? "" : body.get("password");
        String fullName = MobileValidation.trim(body.get("fullName"));
        String phone = MobileValidation.trim(body.get("phoneNumber"));
        String homeAddress = MobileValidation.trim(body.get("homeAddress"));
        String dob = MobileValidation.trim(body.get("dob"));
        String genderRaw = MobileValidation.trim(body.get("gender"));
        String emergencyContact = MobileValidation.trim(body.get("emergencyContact"));
        String preferredLanguage = MobileValidation.trim(body.get("preferredLanguage"));
        String profilePhoto = MobileValidation.trim(body.get("profilePhoto"));

        if (fullName.isEmpty()) {
            response.put("success", false);
            response.put("error", "fullName is required");
            return ResponseEntity.badRequest().body(response);
        }
        String emailErr = MobileValidation.requireEmail(email);
        if (emailErr != null) {
            response.put("success", false);
            response.put("error", emailErr);
            return ResponseEntity.badRequest().body(response);
        }
        String phoneErr = MobileValidation.requirePhone(phone, true);
        if (phoneErr != null) {
            response.put("success", false);
            response.put("error", phoneErr);
            return ResponseEntity.badRequest().body(response);
        }
        String passErr = MobileValidation.requirePassword(password);
        if (passErr != null) {
            response.put("success", false);
            response.put("error", passErr);
            return ResponseEntity.badRequest().body(response);
        }

        String normEmail = email;
        if (userRepository.findByEmail(normEmail).isPresent()) {
            response.put("success", false);
            response.put("error", "Email already registered. Please sign in.");
            return ResponseEntity.status(HttpStatus.CONFLICT).body(response);
        }
        if (!otpVerificationService.consumeVerifiedOtp(normEmail, OtpPurpose.USER_REGISTER, otpExpirationMinutes)) {
            response.put("success", false);
            response.put("error", "Email not verified. Please verify the OTP sent to your email first.");
            return ResponseEntity.badRequest().body(response);
        }

        User user = new User();
        user.setEmail(normEmail);
        user.setFullName(fullName);
        user.setPhoneNumber(phone);
        user.setHomeAddress(homeAddress.isEmpty() ? null : homeAddress);
        user.setPassword(passwordService.encode(password));
        // Members are app users after email OTP — not job workers.
        user.setVerificationStatus(VerificationStatus.VERIFIED);
        user.setIdentityDocument(preferredLanguage.isEmpty()
                ? "mobile-member"
                : "mobile-member|lang:" + preferredLanguage);
        if (!profilePhoto.isEmpty()) {
            user.setProfilePhoto(profilePhoto);
        }

        if (!dob.isEmpty()) {
            try {
                LocalDate birthDate = LocalDate.parse(dob);
                if (birthDate.isAfter(LocalDate.now())) {
                    response.put("success", false);
                    response.put("error", "Date of birth cannot be in the future");
                    return ResponseEntity.badRequest().body(response);
                }
                user.setDob(dob);
                user.setAge(Period.between(birthDate, LocalDate.now()).getYears());
            } catch (Exception e) {
                response.put("success", false);
                response.put("error", "dob must be YYYY-MM-DD");
                return ResponseEntity.badRequest().body(response);
            }
        }
        if (!genderRaw.isEmpty()) {
            try {
                user.setGender(Gender.valueOf(genderRaw.toUpperCase()));
            } catch (IllegalArgumentException e) {
                response.put("success", false);
                response.put("error", "gender must be MALE, FEMALE, or OTHER");
                return ResponseEntity.badRequest().body(response);
            }
        }

        if (!emergencyContact.isEmpty()) {
            if (!emergencyContact.matches("^\\d{10}$")) {
                response.put("success", false);
                response.put("error", "Emergency contact must be exactly 10 digits");
                return ResponseEntity.badRequest().body(response);
            }
            EmergencyContact ec = new EmergencyContact("Emergency", emergencyContact, "Emergency", null);
            ec.setUser(user);
            user.setEmergencyContacts(java.util.List.of(ec));
        }

        userService.createUser(user);
        response.put("success", true);
        response.put("message", "Registration successful. You can now sign in.");
        response.put("userId", user.getId());
        response.put("email", user.getEmail());
        response.put("status", VerificationStatus.VERIFIED.name());
        return ResponseEntity.status(HttpStatus.CREATED).body(response);
    }

    private static String trim(String value) {
        return value == null ? "" : value.trim();
    }

    @PostMapping("/login")
    public ResponseEntity<Map<String, Object>> login(
            @RequestBody Map<String, String> body,
            HttpServletRequest request) {
        Map<String, Object> response = new LinkedHashMap<>();
        String email = body == null ? null : body.get("email");
        String password = body == null ? null : body.get("password");

        String normEmail = email == null ? "" : email.trim().toLowerCase();
        String rawPassword = password == null ? "" : password;

        if (normEmail.isEmpty() || rawPassword.isEmpty()) {
            response.put("success", false);
            response.put("error", "Email and password are required");
            return ResponseEntity.badRequest().body(response);
        }

        String clientIp = request == null ? "unknown" : request.getRemoteAddr();
        rateLimitService.checkOrThrow("login:" + clientIp + ":" + normEmail, 10, Duration.ofMinutes(15));

        User user = userService.findByUsername(normEmail);
        boolean ok = false;
        if (user != null && user.getPassword() != null) {
            ok = passwordService.matchesAndUpgrade(rawPassword, user.getPassword(), hashed -> {
                user.setPassword(hashed);
                userService.createUser(user);
            });
        }

        if (!ok) {
            response.put("success", false);
            response.put("error", "Invalid credentials");
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(response);
        }

        VerificationStatus status = user.getVerificationStatus();
        if (status == VerificationStatus.REJECTED) {
            response.put("success", false);
            response.put("error", "Account rejected by admin");
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(response);
        }
        if (user.isBanned()) {
            response.put("success", false);
            response.put("error", "Account banned");
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(response);
        }
        // Members sign in after email OTP. Job workers are gated separately via Women Jobs admin approval.

        String token = jwtUtil.generateToken(user.getEmail(), "USER");
        response.put("success", true);
        response.put("token", token);
        response.put("tokenType", "Bearer");
        response.put("userId", user.getId());
        response.put("email", user.getEmail());
        response.put("name", user.getFullName());
        response.put("phone", user.getPhoneNumber());
        response.put("status", status == null ? VerificationStatus.VERIFIED.name() : status.name());
        return ResponseEntity.ok(response);
    }

    private static Map<String, Object> error(String msg) {
        Map<String, Object> out = new LinkedHashMap<>();
        out.put("success", false);
        out.put("error", msg == null ? "Request failed" : msg);
        return out;
    }
}
