package in.sp.main.Controller;

import java.util.LinkedHashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import in.sp.main.Config.JwtUtil;
import in.sp.main.Entities.PartnerProfileStatus;
import in.sp.main.Entities.User;
import in.sp.main.Repository.UserRepository;
import in.sp.main.Service.CreatorCareService;
import in.sp.main.Service.CreatorProfileService;
import in.sp.main.Service.CreatorRegistrationService;
import in.sp.main.Service.FileUploadService;
import in.sp.main.Service.PartnerLifecycleSupport;
import in.sp.main.Service.PasswordService;
import in.sp.main.Service.UserService;
import in.sp.main.Util.MobileValidation;
import jakarta.servlet.http.HttpSession;

@RestController
@RequestMapping("/api/creator-hub")
public class MobileCreatorAuthController {

    @Autowired
    private CreatorRegistrationService registrationService;
    @Autowired
    private CreatorProfileService profileService;
    @Autowired
    private UserService userService;
    @Autowired
    private PasswordService passwordService;
    @Autowired
    private JwtUtil jwtUtil;
    @Autowired
    private UserRepository userRepository;
    @Autowired
    private CreatorCareService creatorCareService;
    @Autowired
    private FileUploadService fileUploadService;

    @PostMapping("/otp/send-email")
    public ResponseEntity<Map<String, Object>> sendEmailOtp(@RequestBody Map<String, String> body) {
        try {
            registrationService.sendRegistrationOtp(body == null ? null : body.get("email"));
            return ResponseEntity.ok(ok(Map.of("message", "OTP sent to your email")));
        } catch (org.springframework.web.server.ResponseStatusException ex) {
            return ResponseEntity.status(ex.getStatusCode()).body(error(ex.getReason()));
        }
    }

    @PostMapping("/otp/verify-email")
    public ResponseEntity<Map<String, Object>> verifyEmailOtp(@RequestBody Map<String, String> body) {
        try {
            registrationService.verifyRegistrationOtp(
                    body == null ? null : body.get("email"),
                    body == null ? null : body.get("otp"));
            return ResponseEntity.ok(ok(Map.of("message", "Email verified")));
        } catch (org.springframework.web.server.ResponseStatusException ex) {
            return ResponseEntity.status(ex.getStatusCode()).body(error(ex.getReason()));
        }
    }

    @PostMapping("/register-quick")
    public ResponseEntity<Map<String, Object>> registerQuick(@RequestBody Map<String, Object> body) {
        try {
            boolean accepted = body != null && (
                    Boolean.TRUE.equals(body.get("acceptedTerms"))
                            || "true".equalsIgnoreCase(String.valueOf(body.get("acceptedTerms"))));
            User user = registrationService.registerQuick(
                    str(body, "fullName"),
                    str(body, "email"),
                    str(body, "phone"),
                    str(body, "password"),
                    str(body, "confirmPassword"),
                    accepted);
            Map<String, Object> res = new LinkedHashMap<>();
            res.put("success", true);
            res.put("message", "Account created. Please login and complete your creator profile to submit for verification.");
            res.put("userId", user.getId());
            res.put("partnerProfileStatus", user.getCreatorProfileStatus() == null
                    ? null : user.getCreatorProfileStatus().name());
            return ResponseEntity.status(HttpStatus.CREATED).body(res);
        } catch (org.springframework.web.server.ResponseStatusException ex) {
            return ResponseEntity.status(ex.getStatusCode()).body(error(ex.getReason()));
        }
    }

    @PostMapping("/login")
    public ResponseEntity<Map<String, Object>> login(@RequestBody Map<String, String> body, HttpSession session) {
        String email = MobileValidation.normalizeEmail(body == null ? null : body.get("email"));
        String password = body == null || body.get("password") == null ? "" : body.get("password");
        if (email.isBlank() || password.isBlank()) {
            return ResponseEntity.badRequest().body(error("Email and password are required"));
        }
        User user = userService.findByUsername(email);
        boolean ok = false;
        if (user != null && user.getPassword() != null) {
            ok = passwordService.matchesAndUpgrade(password, user.getPassword(), hashed -> {
                user.setPassword(hashed);
                userService.createUser(user);
            });
        }
        if (!ok) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(error("Invalid credentials"));
        }
        if (user.isBanned() || user.isBannedCreator()) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(error("Creator account is banned"));
        }
        if (user.getCreatorProfileStatus() == PartnerProfileStatus.SUSPENDED) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(error("Your creator account has been suspended"));
        }
        profileService.refreshCompletion(user);

        session.setAttribute("user", user);
        String token = jwtUtil.generateToken(user.getEmail(), "USER");

        Map<String, Object> res = new LinkedHashMap<>();
        res.put("success", true);
        res.put("token", token);
        res.put("tokenType", "Bearer");
        res.put("role", "USER");
        res.put("userId", user.getId());
        res.put("email", user.getEmail());
        res.put("name", user.getFullName());
        res.put("phone", user.getPhoneNumber());
        res.putAll(profileService.profilePayload(user));
        res.put("needsProfileCompletion",
                PartnerLifecycleSupport.needsProfileCompletion(user.getCreatorProfileStatus()));
        return ResponseEntity.ok(res);
    }

    @GetMapping("/creator-profile")
    public ResponseEntity<Map<String, Object>> getProfile(HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        user = userRepository.findById(user.getId()).orElse(user);
        Map<String, Object> res = new LinkedHashMap<>();
        res.put("success", true);
        res.putAll(profileService.profilePayload(user));
        return ResponseEntity.ok(res);
    }

    @PutMapping("/creator-profile")
    @Transactional
    public ResponseEntity<Map<String, Object>> updateProfile(
            @RequestBody Map<String, Object> body,
            HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        user = userRepository.findById(user.getId()).orElse(user);
        if (user.getCreatorProfileStatus() == null) {
            profileService.setLifecycleStatus(user, PartnerProfileStatus.PROFILE_INCOMPLETE);
        }
        profileService.applyExtraFields(user, body);
        profileService.refreshCompletion(user);
        session.setAttribute("user", user);
        Map<String, Object> res = new LinkedHashMap<>();
        res.put("success", true);
        res.put("message", "Profile saved");
        res.putAll(profileService.profilePayload(user));
        return ResponseEntity.ok(res);
    }

    @PostMapping("/submit-verification")
    public ResponseEntity<Map<String, Object>> submitVerification(HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        try {
            User fresh = userRepository.findById(user.getId()).orElse(user);
            registrationService.submitForVerification(fresh);
            session.setAttribute("user", fresh);
            Map<String, Object> res = new LinkedHashMap<>();
            res.put("success", true);
            res.put("message", "Submitted for admin verification");
            res.putAll(profileService.profilePayload(fresh));
            return ResponseEntity.ok(res);
        } catch (org.springframework.web.server.ResponseStatusException ex) {
            return ResponseEntity.status(ex.getStatusCode()).body(error(ex.getReason()));
        }
    }

    @PostMapping("/payout/request")
    @Transactional
    public ResponseEntity<Map<String, Object>> requestPayout(HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        try {
            return ResponseEntity.ok(creatorCareService.requestPayout(userRepository.findById(user.getId()).orElse(user)));
        } catch (org.springframework.web.server.ResponseStatusException ex) {
            return ResponseEntity.status(ex.getStatusCode()).body(error(ex.getReason()));
        }
    }

    @PostMapping(value = "/photos", consumes = org.springframework.http.MediaType.MULTIPART_FORM_DATA_VALUE)
    @Transactional
    public ResponseEntity<Map<String, Object>> uploadPhotos(
            @org.springframework.web.bind.annotation.RequestParam(value = "profileImage", required = false)
            org.springframework.web.multipart.MultipartFile profileImage,
            @org.springframework.web.bind.annotation.RequestParam(value = "galleryPhotos", required = false)
            org.springframework.web.multipart.MultipartFile galleryPhotos,
            HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        user = userRepository.findById(user.getId()).orElse(user);
        try {
            if (profileImage != null && !profileImage.isEmpty()) {
                user.setProfilePhoto(fileUploadService.saveFile(profileImage));
            }
            if (galleryPhotos != null && !galleryPhotos.isEmpty()) {
                String path = fileUploadService.saveFile(galleryPhotos);
                String existing = user.getCreatorGalleryPhotos();
                user.setCreatorGalleryPhotos(existing == null || existing.isBlank() ? path : existing + "," + path);
            }
            userRepository.save(user);
            Map<String, Object> res = new LinkedHashMap<>();
            res.put("success", true);
            res.put("message", "Photos saved");
            res.putAll(profileService.profilePayload(user));
            return ResponseEntity.ok(res);
        } catch (Exception ex) {
            return badRequest(ex.getMessage() == null ? "Upload failed" : ex.getMessage());
        }
    }

    private User requireUser(HttpSession session) {
        Object u = session == null ? null : session.getAttribute("user");
        if (!(u instanceof User user)) return null;
        return userRepository.findById(user.getId()).orElse(user);
    }

    private static String str(Map<String, Object> body, String key) {
        if (body == null || body.get(key) == null) return "";
        return String.valueOf(body.get(key));
    }

    private static String blankToNull(String v) {
        if (v == null) return null;
        String t = v.trim();
        return t.isEmpty() ? null : t;
    }

    private static Map<String, Object> error(String msg) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("success", false);
        m.put("error", msg == null ? "Request failed" : msg);
        return m;
    }

    private static Map<String, Object> ok(Map<String, Object> data) {
        Map<String, Object> out = new LinkedHashMap<>();
        out.put("success", true);
        out.putAll(data);
        return out;
    }

    private ResponseEntity<Map<String, Object>> unauthorized() {
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(error("Login required"));
    }

    private ResponseEntity<Map<String, Object>> badRequest(String error) {
        return ResponseEntity.badRequest().body(error(error));
    }
}
