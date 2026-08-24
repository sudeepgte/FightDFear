package in.sp.main.Controller;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import in.sp.main.Config.JwtUtil;
import in.sp.main.Entities.FinancialEducator;
import in.sp.main.Entities.FinancialEnrollment;
import in.sp.main.Entities.FinancialLiveSession;
import in.sp.main.Entities.FinancialVideo;
import in.sp.main.Entities.FinancialWorkshop;
import in.sp.main.Entities.PartnerProfileStatus;
import in.sp.main.Repository.FinancialEducatorRepository;
import in.sp.main.Repository.FinancialEnrollmentRepository;
import in.sp.main.Repository.FinancialLiveSessionRepository;
import in.sp.main.Repository.FinancialVideoRepository;
import in.sp.main.Repository.FinancialWorkshopRepository;
import in.sp.main.Service.FileUploadService;
import in.sp.main.Service.FinancialEducatorProfileService;
import in.sp.main.Service.FinancialEducatorRegistrationService;
import in.sp.main.Service.FinancialLiteracyCareService;
import in.sp.main.Service.FinancialLiteracyCatalogService;
import in.sp.main.Service.PartnerLifecycleSupport;
import in.sp.main.Service.PasswordService;
import in.sp.main.Util.MobileValidation;
import jakarta.servlet.http.HttpSession;

@RestController
@RequestMapping("/api/financial-literacy/educator")
public class MobileFinancialEducatorAuthController {

    @Autowired private FinancialEducatorRepository educatorRepo;
    @Autowired private FinancialVideoRepository videoRepo;
    @Autowired private FinancialLiveSessionRepository liveRepo;
    @Autowired private FinancialWorkshopRepository workshopRepo;
    @Autowired private FinancialEnrollmentRepository enrollmentRepo;
    @Autowired private PasswordService passwordService;
    @Autowired private JwtUtil jwtUtil;
    @Autowired private FinancialEducatorRegistrationService registrationService;
    @Autowired private FinancialEducatorProfileService profileService;
    @Autowired private FinancialLiteracyCatalogService catalog;
    @Autowired private FinancialLiteracyCareService careService;
    @Autowired private FileUploadService fileUploadService;

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
            FinancialEducator e = registrationService.registerQuick(
                    str(body, "fullName"), str(body, "email"), str(body, "phone"),
                    str(body, "password"), str(body, "confirmPassword"), accepted);
            Map<String, Object> res = new LinkedHashMap<>();
            res.put("success", true);
            res.put("message", "Account created. Login and complete your profile to submit for verification.");
            res.put("educatorId", e.getId());
            return ResponseEntity.status(HttpStatus.CREATED).body(res);
        } catch (org.springframework.web.server.ResponseStatusException ex) {
            return ResponseEntity.status(ex.getStatusCode()).body(error(ex.getReason()));
        }
    }

    @PostMapping("/login")
    public ResponseEntity<Map<String, Object>> login(@RequestBody Map<String, String> body, HttpSession session) {
        String email = MobileValidation.normalizeEmail(body == null ? null : body.get("email"));
        String password = body == null ? "" : body.getOrDefault("password", "");
        if (email.isBlank() || password.isBlank()) return badRequest("Email and password are required");
        Optional<FinancialEducator> opt = educatorRepo.findByEmail(email.toLowerCase(Locale.ROOT));
        if (opt.isEmpty()) return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(error("Educator not found"));
        FinancialEducator e = opt.get();
        boolean ok = passwordService.matchesAndUpgrade(password, e.getPassword(), hashed -> {
            e.setPassword(hashed);
            educatorRepo.save(e);
        });
        if (!ok) return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(error("Invalid password"));
        if (e.getPartnerProfileStatus() == PartnerProfileStatus.SUSPENDED || e.isSuspended()) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(error("Your educator account has been suspended"));
        }
        profileService.refreshCompletion(e);
        session.setAttribute("loggedEducator", e);
        String token = jwtUtil.generateToken(e.getEmail(), "EDUCATOR");
        Map<String, Object> res = new LinkedHashMap<>();
        res.put("success", true);
        res.put("token", token);
        res.put("tokenType", "Bearer");
        res.put("role", "EDUCATOR");
        res.putAll(profileService.profilePayload(e));
        res.put("needsProfileCompletion", PartnerLifecycleSupport.needsProfileCompletion(e.getPartnerProfileStatus()));
        return ResponseEntity.ok(res);
    }

    @GetMapping("/profile")
    public ResponseEntity<Map<String, Object>> getProfile(HttpSession session) {
        FinancialEducator e = requireEducator(session);
        if (e == null) return unauthorized();
        Map<String, Object> res = new LinkedHashMap<>();
        res.put("success", true);
        res.putAll(profileService.profilePayload(e));
        return ResponseEntity.ok(res);
    }

    @PutMapping("/profile")
    @Transactional
    public ResponseEntity<Map<String, Object>> updateProfile(@RequestBody Map<String, Object> body, HttpSession session) {
        FinancialEducator e = requireEducator(session);
        if (e == null) return unauthorized();
        if (body != null) {
            if (body.get("fullName") != null) {
                String name = String.valueOf(body.get("fullName")).trim();
                if (name.isBlank()) return badRequest("Full name is required");
                e.setFullName(name);
            }
            if (body.get("phone") != null) {
                String phone = String.valueOf(body.get("phone")).trim();
                String err = MobileValidation.requirePhone(phone, true);
                if (err != null) return badRequest(err);
                e.setPhone(phone);
            }
            if (body.get("city") != null) e.setCity(blankToNull(String.valueOf(body.get("city"))));
            if (body.get("bio") != null) e.setBio(blankToNull(String.valueOf(body.get("bio"))));
            if (body.get("organization") != null) e.setOrganization(blankToNull(String.valueOf(body.get("organization"))));
            if (body.get("yearsExperience") instanceof Number n) e.setYearsExperience(n.intValue());
            if (body.get("expertise") != null && body.get("categoriesOffered") == null) {
                String exp = FinancialEducatorProfileService.normalizeExpertise(String.valueOf(body.get("expertise")));
                if (exp == null) return badRequest("Choose a valid expertise");
                e.setExpertise(exp);
                e.setCategoriesOffered(exp);
            }
            profileService.applyExtraFields(e, body);
        }
        profileService.refreshCompletion(e);
        session.setAttribute("loggedEducator", e);
        Map<String, Object> res = new LinkedHashMap<>();
        res.put("success", true);
        res.put("message", "Profile saved");
        res.putAll(profileService.profilePayload(e));
        return ResponseEntity.ok(res);
    }

    @PostMapping("/submit-verification")
    public ResponseEntity<Map<String, Object>> submitVerification(HttpSession session) {
        FinancialEducator e = requireEducator(session);
        if (e == null) return unauthorized();
        try {
            registrationService.submitForVerification(e);
            session.setAttribute("loggedEducator", e);
            Map<String, Object> res = new LinkedHashMap<>();
            res.put("success", true);
            res.put("message", "Submitted for admin verification");
            res.putAll(profileService.profilePayload(e));
            return ResponseEntity.ok(res);
        } catch (org.springframework.web.server.ResponseStatusException ex) {
            return ResponseEntity.status(ex.getStatusCode()).body(error(ex.getReason()));
        }
    }

    @GetMapping("/me")
    public ResponseEntity<Map<String, Object>> me(HttpSession session) {
        FinancialEducator e = requireEducator(session);
        if (e == null) return unauthorized();
        List<Map<String, Object>> videos = videoRepo.findByEducator_IdOrderByCreatedAtDesc(e.getId())
                .stream().map(v -> catalog.videoMap(v, false)).toList();
        List<Map<String, Object>> live = liveRepo.findByEducator_IdOrderByCreatedAtDesc(e.getId())
                .stream().map(catalog::liveMap).toList();
        List<Map<String, Object>> workshops = workshopRepo.findByEducator_IdOrderByCreatedAtDesc(e.getId())
                .stream().map(catalog::workshopMap).toList();
        List<Map<String, Object>> enrollments = new java.util.ArrayList<>();
        for (FinancialLiveSession s : liveRepo.findByEducator_IdOrderByCreatedAtDesc(e.getId())) {
            enrollmentRepo.findByLiveSession_IdOrderByCreatedAtDesc(s.getId()).forEach(en -> enrollments.add(catalog.enrollmentMap(en)));
        }
        for (FinancialWorkshop w : workshopRepo.findByEducator_IdOrderByCreatedAtDesc(e.getId())) {
            enrollmentRepo.findByWorkshop_IdOrderByCreatedAtDesc(w.getId()).forEach(en -> enrollments.add(catalog.enrollmentMap(en)));
        }
        Map<String, Object> data = new LinkedHashMap<>();
        data.put("educator", profileService.profilePayload(e));
        data.put("videos", videos);
        data.put("liveSessions", live);
        data.put("workshops", workshops);
        data.put("enrollments", enrollments);
        data.put("approved", FinancialEducatorProfileService.isApproved(e));
        data.put("payoutBalance", e.getPayoutBalance());
        data.put("upiId", e.getUpiId() == null ? "" : e.getUpiId());
        data.put("cancelPolicy", FinancialLiteracyCareService.CANCEL_POLICY);
        double earnings = enrollments.stream()
                .filter(m -> "PAID".equalsIgnoreCase(String.valueOf(m.get("paymentStatus")))
                        || "completed".equalsIgnoreCase(String.valueOf(m.get("status"))))
                .mapToDouble(m -> m.get("amount") instanceof Number n ? n.doubleValue() : 0)
                .sum();
        data.put("totalEarnings", earnings);
        return ResponseEntity.ok(ok(data));
    }

    @PostMapping("/videos")
    public ResponseEntity<Map<String, Object>> addVideo(@RequestBody Map<String, Object> body, HttpSession session) {
        FinancialEducator e = requireApproved(session);
        if (e == null) return unauthorized();
        if (!FinancialEducatorProfileService.isApproved(e)) return forbidden("Approved educator profile required to publish.");
        try {
            FinancialVideo v = catalog.addVideo(str(body, "title"), str(body, "category"),
                    str(body, "description"), str(body, "videoUrl"), e);
            return ResponseEntity.ok(ok(Map.of("message", "Video published", "video", catalog.videoMap(v, false))));
        } catch (org.springframework.web.server.ResponseStatusException ex) {
            return ResponseEntity.status(ex.getStatusCode()).body(error(ex.getReason()));
        }
    }

    @DeleteMapping("/videos/{id}")
    @Transactional
    public ResponseEntity<Map<String, Object>> deleteVideo(@PathVariable Long id, HttpSession session) {
        FinancialEducator e = requireEducator(session);
        if (e == null) return unauthorized();
        FinancialVideo v = videoRepo.findById(id).orElse(null);
        if (v == null || v.getEducator() == null || !v.getEducator().getId().equals(e.getId())) {
            return badRequest("Video not found");
        }
        videoRepo.delete(v);
        return ResponseEntity.ok(ok(Map.of("message", "Video deleted")));
    }

    @PostMapping("/live-sessions")
    public ResponseEntity<Map<String, Object>> addLive(@RequestBody Map<String, Object> body, HttpSession session) {
        FinancialEducator e = requireApproved(session);
        if (e == null) return unauthorized();
        if (!FinancialEducatorProfileService.isApproved(e)) return forbidden("Approved educator profile required to publish.");
        Integer seats = body.get("seats") instanceof Number n ? n.intValue() : 20;
        try {
            Double fee = body.get("fee") instanceof Number n ? n.doubleValue() : 0d;
            FinancialLiveSession s = catalog.addLive(str(body, "title"), str(body, "speaker"),
                    str(body, "date"), str(body, "time"), str(body, "meetingUrl"), seats, str(body, "description"), e,
                    fee, str(body, "category"));
            return ResponseEntity.ok(ok(Map.of("message", "Live session published", "session", catalog.liveMap(s))));
        } catch (org.springframework.web.server.ResponseStatusException ex) {
            return ResponseEntity.status(ex.getStatusCode()).body(error(ex.getReason()));
        }
    }

    @DeleteMapping("/live-sessions/{id}")
    @Transactional
    public ResponseEntity<Map<String, Object>> deleteLive(@PathVariable Long id, HttpSession session) {
        FinancialEducator e = requireEducator(session);
        if (e == null) return unauthorized();
        FinancialLiveSession s = liveRepo.findById(id).orElse(null);
        if (s == null || s.getEducator() == null || !s.getEducator().getId().equals(e.getId())) {
            return badRequest("Session not found");
        }
        enrollmentRepo.findByLiveSession_IdOrderByCreatedAtDesc(id).forEach(enrollmentRepo::delete);
        liveRepo.delete(s);
        return ResponseEntity.ok(ok(Map.of("message", "Session deleted")));
    }

    @PostMapping("/workshops")
    public ResponseEntity<Map<String, Object>> addWorkshop(@RequestBody Map<String, Object> body, HttpSession session) {
        FinancialEducator e = requireApproved(session);
        if (e == null) return unauthorized();
        if (!FinancialEducatorProfileService.isApproved(e)) return forbidden("Approved educator profile required to publish.");
        Integer seats = body.get("seats") instanceof Number n ? n.intValue() : 20;
        try {
            Double fee = body.get("fee") instanceof Number n ? n.doubleValue() : 0d;
            FinancialWorkshop w = catalog.addWorkshop(str(body, "title"), str(body, "venue"),
                    str(body, "date"), str(body, "time"), str(body, "city"), seats, str(body, "description"), e,
                    fee, str(body, "category"));
            return ResponseEntity.ok(ok(Map.of("message", "Workshop published", "workshop", catalog.workshopMap(w))));
        } catch (org.springframework.web.server.ResponseStatusException ex) {
            return ResponseEntity.status(ex.getStatusCode()).body(error(ex.getReason()));
        }
    }

    @DeleteMapping("/workshops/{id}")
    @Transactional
    public ResponseEntity<Map<String, Object>> deleteWorkshop(@PathVariable Long id, HttpSession session) {
        FinancialEducator e = requireEducator(session);
        if (e == null) return unauthorized();
        FinancialWorkshop w = workshopRepo.findById(id).orElse(null);
        if (w == null || w.getEducator() == null || !w.getEducator().getId().equals(e.getId())) {
            return badRequest("Workshop not found");
        }
        enrollmentRepo.findByWorkshop_IdOrderByCreatedAtDesc(id).forEach(enrollmentRepo::delete);
        workshopRepo.delete(w);
        return ResponseEntity.ok(ok(Map.of("message", "Workshop deleted")));
    }

    @PostMapping("/enrollments/{id}/status")
    public ResponseEntity<Map<String, Object>> enrollmentStatus(
            @PathVariable Long id, @RequestBody Map<String, String> body, HttpSession session) {
        FinancialEducator e = requireApproved(session);
        if (e == null) return unauthorized();
        FinancialEnrollment en = enrollmentRepo.findById(id).orElse(null);
        if (en == null) return badRequest("Registration not found");
        boolean mine = (en.getLiveSession() != null && en.getLiveSession().getEducator() != null
                && en.getLiveSession().getEducator().getId().equals(e.getId()))
                || (en.getWorkshop() != null && en.getWorkshop().getEducator() != null
                && en.getWorkshop().getEducator().getId().equals(e.getId()));
        if (!mine) return forbidden("Not your registration");
        String status = body == null ? "" : body.getOrDefault("status", "").trim().toLowerCase(Locale.ROOT);
        if (!List.of("approved", "rejected", "completed").contains(status)) {
            return badRequest("Status must be approved, rejected or completed");
        }
        String current = en.getStatus() == null ? "" : en.getStatus().toLowerCase(Locale.ROOT);
        if ("completed".equals(status) && !List.of("approved", "paid", "pending").contains(current)) {
            return badRequest("Only confirmed registrations can be completed");
        }
        if (("approved".equals(status) || "rejected".equals(status)) && !"pending".equals(current) && !"paid".equals(current)) {
            return badRequest("Only pending registrations can be updated");
        }
        catalog.setEnrollmentStatus(id, status);
        return ResponseEntity.ok(ok(Map.of("message", "Registration " + status, "registration", catalog.enrollmentMap(en))));
    }

    @PostMapping("/payout/request")
    @Transactional
    public ResponseEntity<Map<String, Object>> requestPayout(HttpSession session) {
        FinancialEducator e = requireEducator(session);
        if (e == null) return unauthorized();
        try {
            return ResponseEntity.ok(careService.requestPayout(educatorRepo.findById(e.getId()).orElse(e)));
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
        FinancialEducator e = requireEducator(session);
        if (e == null) return unauthorized();
        e = educatorRepo.findById(e.getId()).orElse(e);
        try {
            if (profileImage != null && !profileImage.isEmpty()) {
                e.setProfilePhotoPath(fileUploadService.saveFile(profileImage));
            }
            if (galleryPhotos != null) {
                List<String> existing = new ArrayList<>();
                if (e.getGalleryPhotos() != null && !e.getGalleryPhotos().isBlank()) {
                    existing.addAll(Arrays.asList(e.getGalleryPhotos().split(",")));
                }
                for (MultipartFile photo : galleryPhotos) {
                    if (photo != null && !photo.isEmpty()) {
                        existing.add(fileUploadService.saveFile(photo));
                    }
                }
                e.setGalleryPhotos(String.join(",", existing.stream().map(String::trim).filter(x -> !x.isEmpty()).toList()));
            }
            educatorRepo.save(e);
            Map<String, Object> res = new LinkedHashMap<>();
            res.put("success", true);
            res.put("message", "Photos saved");
            res.put("profileImageUrl", e.getProfilePhotoPath());
            res.put("galleryPhotos", e.getGalleryPhotos());
            return ResponseEntity.ok(res);
        } catch (Exception ex) {
            return ResponseEntity.badRequest().body(error("Upload failed: " + ex.getMessage()));
        }
    }

    @PostMapping("/enrollments/{id}/notes")
    @Transactional
    public ResponseEntity<Map<String, Object>> updateNotes(
            @PathVariable Long id,
            @RequestBody Map<String, String> body,
            HttpSession session) {
        FinancialEducator e = requireEducator(session);
        if (e == null) return unauthorized();
        FinancialEnrollment en = enrollmentRepo.findById(id).orElse(null);
        if (en == null) return badRequest("Registration not found");
        boolean mine = (en.getLiveSession() != null && en.getLiveSession().getEducator() != null
                && en.getLiveSession().getEducator().getId().equals(e.getId()))
                || (en.getWorkshop() != null && en.getWorkshop().getEducator() != null
                && en.getWorkshop().getEducator().getId().equals(e.getId()));
        if (!mine) return forbidden("Not your registration");
        en.setCoachNotes(body == null ? "" : body.getOrDefault("coachNotes", ""));
        enrollmentRepo.save(en);
        return ResponseEntity.ok(ok(Map.of("message", "Notes saved", "coachNotes", en.getCoachNotes())));
    }

    private FinancialEducator requireEducator(HttpSession session) {
        Object raw = session == null ? null : session.getAttribute("loggedEducator");
        if (!(raw instanceof FinancialEducator e)) return null;
        return educatorRepo.findById(e.getId()).orElse(e);
    }

    private FinancialEducator requireApproved(HttpSession session) {
        return requireEducator(session);
    }

    private static String str(Map<String, Object> body, String key) {
        if (body == null || body.get(key) == null) return "";
        return String.valueOf(body.get(key)).trim();
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

    private ResponseEntity<Map<String, Object>> forbidden(String msg) {
        return ResponseEntity.status(HttpStatus.FORBIDDEN).body(error(msg));
    }

    private ResponseEntity<Map<String, Object>> badRequest(String error) {
        return ResponseEntity.badRequest().body(error(error));
    }
}
