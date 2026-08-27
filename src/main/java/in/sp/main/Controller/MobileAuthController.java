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
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

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
    public ResponseEntity<Map<String, Object>> verifyEmailOtp(@RequestBody Map<String, String> body,
                                                              HttpServletRequest request) {
        String email = MobileValidation.normalizeEmail(body == null ? null : body.get("email"));
        String otp = body == null || body.get("otp") == null ? "" : body.get("otp").trim();
        String emailErr = MobileValidation.requireEmail(email);
        if (emailErr != null) {
            return ResponseEntity.badRequest().body(error(emailErr));
        }
        if (!otpVerificationService.verifyOtp(email, otp, OtpPurpose.USER_REGISTER)) {
            return ResponseEntity.badRequest().body(error("Invalid or expired email OTP"));
        }
        if (request != null) {
            request.getSession(true).setAttribute("REG_VERIFIED_EMAIL", email);
        }
        Map<String, Object> res = new LinkedHashMap<>();
        res.put("success", true);
        res.put("message", "Email verified successfully");
        return ResponseEntity.ok(res);
    }

    @GetMapping("/otp/phone-status")
    public ResponseEntity<Map<String, Object>> phoneOtpStatus() {
        Map<String, Object> res = new LinkedHashMap<>();
        res.put("success", true);
        res.put("available", otpVerificationService.isPhoneOtpAvailable());
        return ResponseEntity.ok(res);
    }

    @PostMapping("/otp/send-phone")
    public ResponseEntity<Map<String, Object>> sendPhoneOtp(@RequestBody Map<String, String> body) {
        String phone = MobileValidation.trim(body == null ? null : body.get("phoneNumber"));
        String phoneErr = MobileValidation.requirePhone(phone, true);
        if (phoneErr != null) {
            return ResponseEntity.badRequest().body(error(phoneErr));
        }
        if (userRepository.findByPhoneNumber(phone).isPresent()) {
            return ResponseEntity.status(HttpStatus.CONFLICT).body(error("Phone number already registered."));
        }
        if (!otpVerificationService.isPhoneOtpAvailable()) {
            return ResponseEntity.status(HttpStatus.SERVICE_UNAVAILABLE)
                    .body(error("SMS verification is not configured on this server."));
        }
        try {
            otpVerificationService.sendPhoneOtp(phone, OtpPurpose.USER_PHONE_REGISTER);
            Map<String, Object> res = new LinkedHashMap<>();
            res.put("success", true);
            res.put("message", "Verification code sent to your phone");
            res.put("channel", "SMS");
            return ResponseEntity.ok(res);
        } catch (ResponseStatusException ex) {
            return ResponseEntity.status(ex.getStatusCode()).body(error(ex.getReason()));
        } catch (IllegalStateException ex) {
            return ResponseEntity.status(HttpStatus.TOO_MANY_REQUESTS).body(error(ex.getMessage()));
        } catch (IllegalArgumentException ex) {
            return ResponseEntity.badRequest().body(error(ex.getMessage()));
        }
    }

    @PostMapping("/otp/verify-phone")
    public ResponseEntity<Map<String, Object>> verifyPhoneOtp(@RequestBody Map<String, String> body) {
        String phone = MobileValidation.trim(body == null ? null : body.get("phoneNumber"));
        String otp = body == null || body.get("otp") == null ? "" : body.get("otp").trim();
        String phoneErr = MobileValidation.requirePhone(phone, true);
        if (phoneErr != null) {
            return ResponseEntity.badRequest().body(error(phoneErr));
        }
        if (!otpVerificationService.verifyPhoneOtp(phone, otp, OtpPurpose.USER_PHONE_REGISTER)) {
            return ResponseEntity.badRequest().body(error("Invalid or expired phone OTP"));
        }
        Map<String, Object> res = new LinkedHashMap<>();
        res.put("success", true);
        res.put("message", "Phone verified successfully");
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
        if (!otpVerificationService.hasVerifiedOtp(normEmail, OtpPurpose.USER_REGISTER, otpExpirationMinutes)) {
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
        otpVerificationService.consumeVerifiedOtp(normEmail, OtpPurpose.USER_REGISTER, otpExpirationMinutes);
        response.put("success", true);
        response.put("message", "Registration successful. You can now sign in.");
        response.put("userId", user.getId());
        response.put("email", user.getEmail());
        response.put("status", VerificationStatus.VERIFIED.name());
        return ResponseEntity.status(HttpStatus.CREATED).body(response);
    }

    /**
     * Web registration page ({@code /users/register}) — same rules as form POST but JSON + session redirect.
     */
    @PostMapping("/register-web")
    public ResponseEntity<Map<String, Object>> registerWeb(@RequestBody Map<String, String> body,
                                                             HttpServletRequest request) {
        Map<String, Object> response = new LinkedHashMap<>();
        HttpSession session = request == null ? null : request.getSession(true);

        if (body == null) {
            return ResponseEntity.badRequest().body(error("Request body is required"));
        }

        String fullName = MobileValidation.trim(body.get("fullName"));
        String email = MobileValidation.normalizeEmail(body.get("email"));
        String phone = MobileValidation.trim(body.get("phoneNumber"));
        String password = body.get("password") == null ? "" : body.get("password");
        String confirmPassword = body.get("confirmPassword") == null ? "" : body.get("confirmPassword");
        String city = MobileValidation.trim(body.get("city"));
        String dob = MobileValidation.trim(body.get("dob"));
        String genderRaw = MobileValidation.trim(body.get("gender"));
        String acceptedTerms = MobileValidation.trim(body.get("acceptedTerms"));
        String emailOtp = body.get("emailOtp") == null ? "" : body.get("emailOtp").trim();

        if (!"true".equalsIgnoreCase(acceptedTerms)) {
            return ResponseEntity.badRequest().body(error("You must accept the Terms & Conditions and Privacy Policy to register."));
        }
        if (fullName.isEmpty()) {
            return ResponseEntity.badRequest().body(error("Full name is required."));
        }
        String emailErr = MobileValidation.requireEmail(email);
        if (emailErr != null) {
            return ResponseEntity.badRequest().body(error(emailErr));
        }
        String phoneErr = MobileValidation.requirePhone(phone, true);
        if (phoneErr != null) {
            return ResponseEntity.badRequest().body(error(phoneErr));
        }
        String passErr = MobileValidation.requirePassword(password);
        if (passErr != null) {
            return ResponseEntity.badRequest().body(error(passErr));
        }
        String confirmErr = MobileValidation.requireConfirm(password, confirmPassword);
        if (confirmErr != null) {
            return ResponseEntity.badRequest().body(error(confirmErr));
        }
        if (city.isEmpty()) {
            return ResponseEntity.badRequest().body(error("City / Location is required."));
        }

        if (userRepository.findByEmail(email).isPresent()) {
            return ResponseEntity.status(HttpStatus.CONFLICT).body(error("Email already registered. Please sign in."));
        }
        if (userRepository.findByPhoneNumber(phone).isPresent()) {
            return ResponseEntity.badRequest().body(error("Phone number already registered."));
        }
        if (!ensureEmailVerified(session, email, emailOtp)) {
            return ResponseEntity.badRequest().body(error("Email not verified. Please verify the OTP sent to your email first."));
        }

        User user = new User();
        user.setFullName(fullName);
        user.setEmail(email);
        user.setPhoneNumber(phone);
        user.setCity(city);
        user.setPassword(passwordService.encode(password));
        user.setVerificationStatus(VerificationStatus.VERIFIED);
        user.setIdentityDocument("web-member|lang:English");

        if (!dob.isEmpty()) {
            try {
                LocalDate birthDate = LocalDate.parse(dob);
                if (birthDate.isAfter(LocalDate.now())) {
                    return ResponseEntity.badRequest().body(error("Date of birth cannot be in the future."));
                }
                user.setDob(dob);
                user.setAge(Period.between(birthDate, LocalDate.now()).getYears());
            } catch (Exception e) {
                return ResponseEntity.badRequest().body(error("Date of birth must be YYYY-MM-DD."));
            }
        }
        if (!genderRaw.isEmpty()) {
            try {
                Gender g = Gender.valueOf(genderRaw.toUpperCase());
                if (g == Gender.MALE) {
                    return ResponseEntity.badRequest().body(error("Registration is restricted to Female / Other."));
                }
                user.setGender(g);
            } catch (IllegalArgumentException e) {
                return ResponseEntity.badRequest().body(error("Gender must be FEMALE or OTHER."));
            }
        }

        try {
            userService.createUser(user);
        } catch (Exception ex) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(error("Registration failed. Please try again or use a different email/phone."));
        }

        otpVerificationService.consumeVerifiedOtp(email, OtpPurpose.USER_REGISTER, otpExpirationMinutes);
        if (session != null) {
            session.removeAttribute("REG_VERIFIED_EMAIL");
            session.setAttribute("regSuccessName", fullName);
            session.setAttribute("regSuccessEmail", email);
            session.setAttribute("regSuccessPhone", phone);
        }

        response.put("success", true);
        response.put("message", "Registration successful.");
        response.put("redirectUrl", (request == null ? "" : request.getContextPath()) + "/users/register/success");
        return ResponseEntity.status(HttpStatus.CREATED).body(response);
    }

    private boolean ensureEmailVerified(HttpSession session, String normEmail, String emailOtp) {
        if (normEmail == null || normEmail.isBlank()) {
            return false;
        }
        if (session != null && normEmail.equals(session.getAttribute("REG_VERIFIED_EMAIL"))) {
            return true;
        }
        if (otpVerificationService.hasVerifiedOtp(normEmail, OtpPurpose.USER_REGISTER, otpExpirationMinutes)) {
            return true;
        }
        if (emailOtp != null && !emailOtp.isBlank()
                && otpVerificationService.verifyOtp(normEmail, emailOtp, OtpPurpose.USER_REGISTER)) {
            if (session != null) {
                session.setAttribute("REG_VERIFIED_EMAIL", normEmail);
            }
            return true;
        }
        return false;
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
