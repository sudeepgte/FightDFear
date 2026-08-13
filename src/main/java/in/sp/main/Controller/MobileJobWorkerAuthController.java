package in.sp.main.Controller;

import in.sp.main.Config.JwtUtil;
import in.sp.main.Entities.JobApplication;
import in.sp.main.Entities.User;
import in.sp.main.Entities.VerificationStatus;
import in.sp.main.Repository.JobApplicationRepository;
import in.sp.main.Service.FileUploadService;
import in.sp.main.Service.JobWorkerProfileService;
import in.sp.main.Service.JobWorkerRegistrationService;
import in.sp.main.Service.PasswordService;
import in.sp.main.Service.UserService;
import in.sp.main.Service.WomenJobsCareService;
import in.sp.main.Util.MobileValidation;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/marketplace/jobs")
public class MobileJobWorkerAuthController {

    @Autowired
    private JobWorkerRegistrationService workerRegistrationService;
    @Autowired
    private UserService userService;
    @Autowired
    private PasswordService passwordService;
    @Autowired
    private JwtUtil jwtUtil;
    @Autowired
    private JobApplicationRepository jobAppRepo;
    @Autowired
    private JobWorkerProfileService profileService;
    @Autowired
    private WomenJobsCareService careService;
    @Autowired
    private FileUploadService fileUploadService;

    @PostMapping("/otp/send-email")
    public ResponseEntity<Map<String, Object>> sendEmailOtp(@RequestBody Map<String, String> body) {
        try {
            workerRegistrationService.sendRegistrationOtp(body == null ? null : body.get("email"));
            Map<String, Object> res = new LinkedHashMap<>();
            res.put("success", true);
            res.put("message", "OTP sent to your email");
            return ResponseEntity.ok(res);
        } catch (org.springframework.web.server.ResponseStatusException ex) {
            return ResponseEntity.status(ex.getStatusCode()).body(error(ex.getReason()));
        }
    }

    @PostMapping("/otp/verify-email")
    public ResponseEntity<Map<String, Object>> verifyEmailOtp(@RequestBody Map<String, String> body) {
        try {
            workerRegistrationService.verifyRegistrationOtp(
                    body == null ? null : body.get("email"),
                    body == null ? null : body.get("otp"));
            Map<String, Object> res = new LinkedHashMap<>();
            res.put("success", true);
            res.put("message", "Email verified");
            return ResponseEntity.ok(res);
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
            User user = workerRegistrationService.registerQuick(
                    str(body, "fullName"),
                    str(body, "email"),
                    str(body, "phone"),
                    str(body, "password"),
                    str(body, "confirmPassword"),
                    str(body, "jobCategory"),
                    accepted);
            Map<String, Object> res = new LinkedHashMap<>();
            res.put("success", true);
            res.put("message", "Account created. Please login and complete your worker profile to submit for verification.");
            res.put("userId", user.getId());
            res.put("suggestedCategory", JobWorkerRegistrationService.suggestedCategory(user));
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
        if (user.getVerificationStatus() == VerificationStatus.REJECTED) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(error("Account rejected by admin"));
        }
        if (user.isBanned()) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(error("Account banned"));
        }

        session.setAttribute("user", user);
        String token = jwtUtil.generateToken(user.getEmail(), "USER");

        JobApplication latest = jobAppRepo.findByUser_Id(user.getId()).stream()
                .max((a, b) -> {
                    var at = a.getAppliedAt();
                    var bt = b.getAppliedAt();
                    if (at == null && bt == null) return 0;
                    if (at == null) return -1;
                    if (bt == null) return 1;
                    return at.compareTo(bt);
                })
                .orElse(null);
        boolean verified = latest != null && latest.getStatus() == VerificationStatus.VERIFIED;
        List<String> missing = profileService.missingItems(latest, user);

        Map<String, Object> res = new LinkedHashMap<>();
        res.put("success", true);
        res.put("token", token);
        res.put("tokenType", "Bearer");
        res.put("role", "USER");
        res.put("userId", user.getId());
        res.put("email", user.getEmail());
        res.put("name", user.getFullName());
        res.put("phone", user.getPhoneNumber());
        res.put("isVerifiedWorker", verified);
        res.put("needsProfileCompletion", !missing.isEmpty());
        res.put("suggestedCategory", JobWorkerRegistrationService.suggestedCategory(user));
        if (latest != null) {
            res.put("applicationStatus", latest.getStatus() == null ? null : latest.getStatus().name());
        }
        return ResponseEntity.ok(res);
    }

    @GetMapping("/profile")
    public ResponseEntity<Map<String, Object>> profile(HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        return ResponseEntity.ok(profileService.profilePayload(user));
    }

    @PutMapping("/profile")
    @Transactional
    public ResponseEntity<Map<String, Object>> updateProfile(
            @RequestBody Map<String, Object> body,
            HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        profileService.applyFields(user, body);
        return ResponseEntity.ok(profileService.profilePayload(user));
    }

    @PostMapping("/submit-verification")
    @Transactional
    public ResponseEntity<Map<String, Object>> submit(HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        JobApplication app = profileService.latestFor(user);
        List<String> missing = profileService.missingItems(app, user);
        if (!missing.isEmpty()) {
            return ResponseEntity.badRequest().body(error("Complete " + missing.get(0) + " before submitting."));
        }
        if (app.getStatus() != VerificationStatus.VERIFIED) {
            app.setStatus(VerificationStatus.PENDING);
            jobAppRepo.save(app);
        }
        Map<String, Object> res = profileService.profilePayload(user);
        res.put("message", "Submitted for admin verification");
        return ResponseEntity.ok(res);
    }

    @PostMapping("/payout/request")
    @Transactional
    public ResponseEntity<Map<String, Object>> requestPayout(HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        try {
            return ResponseEntity.ok(careService.requestPayout(profileService.latestFor(user)));
        } catch (org.springframework.web.server.ResponseStatusException ex) {
            return ResponseEntity.status(ex.getStatusCode()).body(error(ex.getReason()));
        }
    }

    @PostMapping("/photos")
    @Transactional
    public ResponseEntity<Map<String, Object>> uploadPhotos(
            @RequestParam(value = "profileImage", required = false) MultipartFile profileImage,
            @RequestParam(value = "galleryPhotos", required = false) MultipartFile[] galleryPhotos,
            HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        JobApplication app = profileService.latestFor(user);
        if (app == null) {
            app = profileService.applyFields(user, Map.of());
        }
        try {
            if (profileImage != null && !profileImage.isEmpty()) {
                app.setProfileImageUrl(fileUploadService.saveFile(profileImage));
            }
            if (galleryPhotos != null) {
                List<String> existing = new ArrayList<>();
                if (app.getGalleryPhotos() != null && !app.getGalleryPhotos().isBlank()) {
                    existing.addAll(Arrays.asList(app.getGalleryPhotos().split(",")));
                }
                for (MultipartFile photo : galleryPhotos) {
                    if (photo != null && !photo.isEmpty()) {
                        existing.add(fileUploadService.saveFile(photo));
                    }
                }
                app.setGalleryPhotos(String.join(",", existing.stream().map(String::trim).filter(s -> !s.isEmpty()).toList()));
            }
            jobAppRepo.save(app);
            Map<String, Object> res = new LinkedHashMap<>();
            res.put("success", true);
            res.put("message", "Photos saved");
            res.put("profileImageUrl", app.getProfileImageUrl());
            res.put("galleryPhotos", app.getGalleryPhotos());
            return ResponseEntity.ok(res);
        } catch (Exception ex) {
            return ResponseEntity.badRequest().body(error("Upload failed: " + ex.getMessage()));
        }
    }

    private User requireUser(HttpSession session) {
        if (session == null) return null;
        Object u = session.getAttribute("user");
        return u instanceof User ? (User) u : null;
    }

    private ResponseEntity<Map<String, Object>> unauthorized() {
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(error("Login required"));
    }

    private static String str(Map<String, Object> body, String key) {
        if (body == null || body.get(key) == null) return "";
        return String.valueOf(body.get(key)).trim();
    }

    private static Map<String, Object> error(String msg) {
        Map<String, Object> out = new LinkedHashMap<>();
        out.put("success", false);
        out.put("error", msg);
        return out;
    }
}
