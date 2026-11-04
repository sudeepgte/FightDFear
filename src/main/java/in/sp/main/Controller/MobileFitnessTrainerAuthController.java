package in.sp.main.Controller;

import in.sp.main.Config.JwtUtil;
import in.sp.main.Entities.FitnessAttendance;
import in.sp.main.Entities.FitnessBooking;
import in.sp.main.Entities.FitnessPackage;
import in.sp.main.Entities.FitnessProgressLog;
import in.sp.main.Entities.FitnessTrainer;
import in.sp.main.Entities.PartnerProfileStatus;
import in.sp.main.Entities.VerificationStatus;
import in.sp.main.Repository.FitnessBookingRepository;
import in.sp.main.Repository.FitnessTrainerRepository;
import in.sp.main.Service.FitnessCareService;
import in.sp.main.Service.FitnessTrainerProfileService;
import in.sp.main.Service.FitnessTrainerRegistrationService;
import in.sp.main.Service.FileUploadService;
import in.sp.main.Service.PartnerLifecycleSupport;
import in.sp.main.Service.PasswordService;
import in.sp.main.Util.MobileValidation;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.time.LocalDate;
import java.time.LocalTime;
import in.sp.main.Entities.User;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Optional;
import java.util.Set;
import java.util.stream.Collectors;


@RestController
@RequestMapping("/api/fitness/trainer")
public class MobileFitnessTrainerAuthController {

    private static final Set<String> ALLOWED_BOOKING_STATUSES = Set.of(
            "PENDING", "APPROVED", "REJECTED", "COMPLETED", "CANCELLED"
    );

    @Autowired
    private FitnessTrainerRepository trainerRepo;
    @Autowired
    private FitnessBookingRepository bookingRepo;
    @Autowired
    private PasswordService passwordService;
    @Autowired
    private JwtUtil jwtUtil;
    @Autowired
    private FitnessTrainerRegistrationService trainerRegistrationService;
    @Autowired
    private FitnessTrainerProfileService trainerProfileService;
    @Autowired
    private FileUploadService fileUploadService;

    @Autowired
    private FitnessCareService fitnessCareService;
    @Autowired
    private in.sp.main.Service.FitnessService fitnessService;
    @Autowired
    private in.sp.main.Repository.FitnessPackageRepository fitnessPackageRepo;
    @Autowired
    private in.sp.main.Repository.FitnessAttendanceRepository fitnessAttendanceRepo;
    @Autowired
    private in.sp.main.Repository.FitnessProgressLogRepository fitnessProgressLogRepo;
    @Autowired
    private in.sp.main.Service.FitnessQrAttendanceService fitnessQrAttendanceService;
    @Autowired
    private in.sp.main.Repository.FitnessClassRepository fitnessClassRepo;
    @Autowired
    private in.sp.main.Repository.UserRepository userRepo;


    @PostMapping("/otp/send-email")
    public ResponseEntity<Map<String, Object>> sendEmailOtp(@RequestBody Map<String, String> body) {
        try {
            trainerRegistrationService.sendRegistrationOtp(body == null ? null : body.get("email"));
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
            trainerRegistrationService.verifyRegistrationOtp(
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
            FitnessTrainer t = trainerRegistrationService.registerQuick(
                    str(body, "fullName"),
                    str(body, "email"),
                    str(body, "phone"),
                    str(body, "password"),
                    str(body, "confirmPassword"),
                    str(body, "emailOtp"),
                    accepted);
            Map<String, Object> res = new LinkedHashMap<>();
            res.put("success", true);
            res.put("message", "Account created. Login and complete your profile to submit for verification.");
            res.put("trainerId", t.getId());
            res.put("partnerProfileStatus", t.getPartnerProfileStatus() == null
                    ? null : t.getPartnerProfileStatus().name());
            res.put("profileCompletionPct", t.getProfileCompletionPct());
            return ResponseEntity.status(HttpStatus.CREATED).body(res);
        } catch (org.springframework.web.server.ResponseStatusException ex) {
            return ResponseEntity.status(ex.getStatusCode()).body(error(ex.getReason()));
        }
    }

    /**
     * Legacy full registration — kept for older clients.
     */
    @PostMapping("/register")
    public ResponseEntity<Map<String, Object>> register(@RequestBody Map<String, String> body) {
        String fullName = trim(body == null ? null : body.get("fullName"));
        String email = MobileValidation.normalizeEmail(body == null ? null : body.get("email"));
        String phone = trim(body == null ? null : body.get("phone"));
        String password = body == null ? "" : body.getOrDefault("password", "");
        String confirmPassword = body == null ? "" : body.getOrDefault("confirmPassword", "");
        String specializations = trim(body == null ? null : body.get("specializations"));
        String availableTimings = trim(body == null ? null : body.get("availableTimings"));
        String city = trim(body == null ? null : body.get("city"));
        String experienceRaw = trim(body == null ? null : body.get("experience"));
        String feesRaw = trim(body == null ? null : body.get("sessionFees"));

        if (fullName.isBlank()) return badRequest("fullName is required");
        String emailErr = MobileValidation.requireEmail(email);
        if (emailErr != null) return badRequest(emailErr);
        String phoneErr = MobileValidation.requirePhone(phone, true);
        if (phoneErr != null) return badRequest(phoneErr);
        String passErr = MobileValidation.requirePassword(password);
        if (passErr != null) return badRequest(passErr);
        String confirmErr = MobileValidation.requireConfirm(password, confirmPassword);
        if (confirmErr != null) return badRequest(confirmErr);
        if (trainerRepo.findByEmail(email).isPresent()) {
            return ResponseEntity.status(HttpStatus.CONFLICT).body(error("Email already registered"));
        }

        FitnessTrainer t = new FitnessTrainer();
        t.setFullName(fullName);
        t.setEmail(email);
        t.setPhone(phone.isBlank() ? null : phone);
        t.setPassword(passwordService.encode(password));
        t.setSpecializations(specializations.isBlank() ? null : specializations);
        t.setAvailableTimings(availableTimings.isBlank() ? null : availableTimings);
        t.setCity(city.isBlank() ? null : city);
        t.setCertificationsPath("mobile-pending");
        t.setSuspended(false);
        t.setRating(0.0);
        t.setSessionFees(null);

        if (!experienceRaw.isBlank()) {
            try {
                t.setExperience(Integer.parseInt(experienceRaw));
            } catch (NumberFormatException e) {
                return badRequest("Invalid experience");
            }
        }
        if (!feesRaw.isBlank()) {
            try {
                t.setSessionFees(Double.parseDouble(feesRaw));
            } catch (NumberFormatException e) {
                return badRequest("Invalid sessionFees");
            }
        }

        trainerProfileService.setLifecycleStatus(t, PartnerProfileStatus.REGISTERED);
        trainerRepo.save(t);
        trainerProfileService.setLifecycleStatus(t, PartnerProfileStatus.PROFILE_INCOMPLETE);
        trainerProfileService.refreshCompletion(t);

        Map<String, Object> res = new LinkedHashMap<>();
        res.put("success", true);
        res.put("message", "Registration submitted. Complete your profile and await admin verification.");
        res.put("trainerId", t.getId());
        res.put("status", "PENDING");
        res.put("partnerProfileStatus", t.getPartnerProfileStatus() == null
                ? null : t.getPartnerProfileStatus().name());
        return ResponseEntity.status(HttpStatus.CREATED).body(res);
    }

    @PostMapping("/login")
    public ResponseEntity<Map<String, Object>> login(@RequestBody Map<String, String> body, HttpSession session) {
        String email = trim(body == null ? null : body.get("email")).toLowerCase(Locale.ROOT);
        String password = body == null ? "" : body.getOrDefault("password", "");
        if (email.isBlank() || password.isBlank()) return badRequest("Email and password are required");

        Optional<FitnessTrainer> opt = trainerRepo.findByEmail(email);
        if (opt.isEmpty()) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(error("Trainer not found"));
        }
        FitnessTrainer t = opt.get();
        boolean ok = passwordService.matchesAndUpgrade(password, t.getPassword(), hashed -> {
            t.setPassword(hashed);
            trainerRepo.save(t);
        });
        if (!ok) return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(error("Invalid password"));

        if (t.isSuspended() || t.getPartnerProfileStatus() == PartnerProfileStatus.SUSPENDED) {
            if (t.getPartnerProfileStatus() != PartnerProfileStatus.SUSPENDED) {
                trainerProfileService.setLifecycleStatus(t, PartnerProfileStatus.SUSPENDED);
                trainerRepo.save(t);
            }
            return ResponseEntity.status(HttpStatus.FORBIDDEN)
                    .body(error("Your trainer account has been suspended"));
        }

        PartnerProfileStatus status = t.getPartnerProfileStatus();
        if (status == null) {
            // Migrate legacy rows so incomplete trainers can finish profile.
            if (t.getVerificationStatus() == VerificationStatus.VERIFIED) {
                trainerProfileService.setLifecycleStatus(t, PartnerProfileStatus.APPROVED);
            } else if (t.getVerificationStatus() == VerificationStatus.REJECTED) {
                trainerProfileService.setLifecycleStatus(t, PartnerProfileStatus.REJECTED);
            } else {
                trainerProfileService.setLifecycleStatus(t, PartnerProfileStatus.PROFILE_INCOMPLETE);
            }
            trainerProfileService.refreshCompletion(t);
        } else {
            trainerProfileService.refreshCompletion(t);
        }

        session.setAttribute("loggedTrainer", t);
        String token = jwtUtil.generateToken(t.getEmail(), "TRAINER");
        boolean isApproved = FitnessTrainerProfileService.isApproved(t);
        Map<String, Object> res = new LinkedHashMap<>();
        res.put("success", true);
        res.put("token", token);
        res.put("tokenType", "Bearer");
        res.put("role", "TRAINER");
        res.put("approved", isApproved);
        res.put("status", isApproved ? "APPROVED" : (t.getPartnerProfileStatus() != null ? t.getPartnerProfileStatus().name() : "PROFILE_INCOMPLETE"));
        res.put("partnerProfileStatus", isApproved ? "APPROVED" : (t.getPartnerProfileStatus() != null ? t.getPartnerProfileStatus().name() : "PROFILE_INCOMPLETE"));
        res.put("trainer", trainerSummary(t));
        res.put("needsProfileCompletion", !isApproved && PartnerLifecycleSupport.needsProfileCompletion(t.getPartnerProfileStatus()));
        res.put("canSubmitForVerification", !isApproved && trainerProfileService.isReadyForVerification(t)
                && t.getPartnerProfileStatus() != PartnerProfileStatus.PENDING_ADMIN_APPROVAL);

        return ResponseEntity.ok(res);
    }

    @GetMapping("/profile")
    public ResponseEntity<Map<String, Object>> getProfile(HttpSession session) {
        FitnessTrainer t = requireTrainer(session);
        if (t == null) return unauthorized();
        t = trainerRepo.findById(t.getId()).orElse(t);
        Map<String, Object> res = new LinkedHashMap<>();
        res.put("success", true);
        res.putAll(trainerProfileService.profilePayload(t));
        return ResponseEntity.ok(res);
    }

    @PutMapping("/profile")
    @Transactional
    public ResponseEntity<Map<String, Object>> updateProfile(
            @RequestBody Map<String, Object> body,
            HttpSession session) {
        FitnessTrainer t = requireTrainer(session);
        if (t == null) return unauthorized();
        t = trainerRepo.findById(t.getId()).orElse(t);
        trainerProfileService.applyExtraFields(t, body);
        trainerProfileService.refreshCompletion(t);
        Map<String, Object> res = new LinkedHashMap<>();
        res.put("success", true);
        res.put("message", "Profile saved");
        res.putAll(trainerProfileService.profilePayload(t));
        return ResponseEntity.ok(res);
    }

    @PostMapping("/submit-verification")
    public ResponseEntity<Map<String, Object>> submitVerification(HttpSession session) {
        FitnessTrainer t = requireTrainer(session);
        if (t == null) return unauthorized();
        try {
            FitnessTrainer trainer = trainerRepo.findById(t.getId()).orElse(t);
            trainerRegistrationService.submitForVerification(trainer);
            Map<String, Object> res = new LinkedHashMap<>();
            res.put("success", true);
            res.put("message", "Submitted for admin verification");
            res.putAll(trainerProfileService.profilePayload(trainer));
            return ResponseEntity.ok(res);
        } catch (org.springframework.web.server.ResponseStatusException ex) {
            return ResponseEntity.status(ex.getStatusCode()).body(error(ex.getReason()));
        }
    }

    @PostMapping(value = "/profile/upload", consumes = org.springframework.http.MediaType.MULTIPART_FORM_DATA_VALUE)
    @Transactional
    public ResponseEntity<Map<String, Object>> uploadProfileDocuments(
            @RequestParam(value = "profilePhoto", required = false) MultipartFile profilePhoto,
            @RequestParam(value = "certificate", required = false) MultipartFile certificate,
            HttpSession session) {
        FitnessTrainer t = requireTrainer(session);
        if (t == null) return unauthorized();
        t = trainerRepo.findById(t.getId()).orElse(t);
        if ((profilePhoto == null || profilePhoto.isEmpty()) && (certificate == null || certificate.isEmpty())) {
            return badRequest("Upload profilePhoto and/or certificate");
        }
        try {
            if (profilePhoto != null && !profilePhoto.isEmpty()) {
                t.setProfilePhotoPath(fileUploadService.saveFile(profilePhoto));
            }
            if (certificate != null && !certificate.isEmpty()) {
                t.setCertificationsPath(fileUploadService.saveFile(certificate));
            }
            trainerProfileService.refreshCompletion(t);
            Map<String, Object> res = new LinkedHashMap<>();
            res.put("success", true);
            res.put("message", "Documents uploaded");
            res.putAll(trainerProfileService.profilePayload(t));
            return ResponseEntity.ok(res);
        } catch (Exception ex) {
            return badRequest(ex.getMessage() == null ? "Upload failed" : ex.getMessage());
        }
    }

    @PutMapping("/online-status")
    @Transactional
    public ResponseEntity<Map<String, Object>> updateOnlineStatus(
            @RequestBody Map<String, Object> body,
            HttpSession session) {
        FitnessTrainer t = requireTrainer(session);
        if (t == null) return unauthorized();
        t = trainerRepo.findById(t.getId()).orElse(t);
        Object raw = body == null ? null : body.get("online");
        boolean online = raw == null || Boolean.TRUE.equals(raw)
                || "true".equalsIgnoreCase(String.valueOf(raw));
        t.setOnlineAvailable(online);
        trainerRepo.save(t);
        Map<String, Object> res = new LinkedHashMap<>();
        res.put("success", true);
        res.put("onlineAvailable", t.isOnlineAvailable());
        return ResponseEntity.ok(res);
    }

    @GetMapping("/me")
    public ResponseEntity<Map<String, Object>> dashboard(HttpSession session) {
        FitnessTrainer t = requireTrainer(session);
        if (t == null) return unauthorized();
        t = trainerRepo.findById(t.getId()).orElse(t);

        var bookings = bookingRepo.findByTrainer_Id(t.getId());
        var bookingDtos = bookings.stream().map(b -> {
            Map<String, Object> m = new LinkedHashMap<>();
            m.put("id", b.getId());
            m.put("status", b.getStatus());
            m.put("category", b.getCategory());
            m.put("bookingDate", b.getBookingDate() == null ? null : b.getBookingDate().toString());
            m.put("bookingTime", b.getBookingTime());
            m.put("sessionType", b.getSessionType());
            m.put("paymentAmount", b.getPaymentAmount());
            m.put("paymentStatus", b.getPaymentStatus());
            m.put("duration", b.getDuration());
            m.put("totalSessions", b.getTotalSessions());
            m.put("completedSessions", b.getCompletedSessions());
            m.put("coachNotes", b.getCoachNotes());
            m.put("canCancel", fitnessCareService.canCancel(b));
            if (b.getUser() != null) {
                m.put("clientName", b.getUser().getFullName());
                m.put("clientPhone", b.getUser().getPhoneNumber());
            }
            if (b.getFitnessClass() != null) {
                m.put("classId", b.getFitnessClass().getId());
                m.put("className", b.getFitnessClass().getClassName());
            }
            return m;
        }).toList();

        long pendingCount = bookings.stream().filter(b -> "PENDING".equals(b.getStatus())).count();
        long approvedCount = bookings.stream().filter(b -> "APPROVED".equals(b.getStatus())).count();
        long completedCount = bookings.stream().filter(b -> "COMPLETED".equals(b.getStatus())).count();
        double totalEarnings = bookings.stream()
                .filter(b -> "COMPLETED".equals(b.getStatus()))
                .mapToDouble(b -> b.getPaymentAmount() == null ? 0.0 : b.getPaymentAmount())
                .sum();

        Map<String, Object> data = new LinkedHashMap<>();
        data.put("success", true);
        Map<String, Object> payload = trainerProfileService.profilePayload(t);
        data.put("trainer", trainerSummary(t));
        // Surface completion fields at top level (same as doctor / centre dashboards)
        data.put("partnerProfileStatus", payload.get("partnerProfileStatus"));
        data.put("partnerProfileStatusLabel", payload.get("partnerProfileStatusLabel"));
        data.put("profileCompletionPct", payload.get("profileCompletionPct"));
        data.put("missingItems", payload.get("missingItems"));
        data.put("canSubmitForVerification", payload.get("canSubmitForVerification"));
        data.put("nextStepGuidance", payload.get("nextStepGuidance"));
        data.put("rejectionReason", payload.get("rejectionReason"));
        data.put("changesRequestedNote", payload.get("changesRequestedNote"));
        data.put("needsProfileCompletion",
                PartnerLifecycleSupport.needsProfileCompletion(t.getPartnerProfileStatus()));
        data.put("bookings", bookingDtos);
        data.put("bookingCount", bookings.size());
        data.put("pendingCount", pendingCount);
        data.put("approvedCount", approvedCount);
        data.put("completedCount", completedCount);
        data.put("upcomingCount", approvedCount);
        data.put("totalEarnings", totalEarnings);
        data.put("payoutBalance", t.getPayoutBalance());
        data.put("upiId", t.getUpiId());
        data.put("cancelPolicy", FitnessCareService.CANCEL_POLICY);
        data.put("onlineAvailable", t.isOnlineAvailable());
        data.put("clients", buildClientsList(bookings));
        return ResponseEntity.ok(data);
    }

    private List<Map<String, Object>> buildClientsList(List<FitnessBooking> bookings) {
        Map<Long, Map<String, Object>> byUser = new LinkedHashMap<>();
        for (FitnessBooking b : bookings) {
            if (b.getUser() == null) continue;
            Long uid = b.getUser().getId();
            Map<String, Object> row = byUser.computeIfAbsent(uid, id -> {
                Map<String, Object> m = new LinkedHashMap<>();
                m.put("userId", id);
                m.put("fullName", b.getUser().getFullName());
                m.put("phone", b.getUser().getPhoneNumber());
                m.put("email", b.getUser().getEmail());
                m.put("bookingCount", 0);
                m.put("lastStatus", b.getStatus());
                return m;
            });
            row.put("bookingCount", ((Number) row.get("bookingCount")).intValue() + 1);
            row.put("lastStatus", b.getStatus());
        }
        return new java.util.ArrayList<>(byUser.values());
    }

    @PostMapping("/bookings/{id}/status")
    @Transactional
    public ResponseEntity<Map<String, Object>> updateBookingStatus(
            @PathVariable("id") Long id,
            @RequestBody Map<String, String> body,
            HttpSession session) {
        FitnessTrainer t = requireTrainer(session);
        if (t == null) return unauthorized();
        FitnessBooking b = bookingRepo.findById(id).orElse(null);
        if (b == null || b.getTrainer() == null || !b.getTrainer().getId().equals(t.getId())) {
            return badRequest("Booking not found");
        }
        String statusRaw = trim(body == null ? null : body.get("status")).toUpperCase(Locale.ROOT);
        if (!ALLOWED_BOOKING_STATUSES.contains(statusRaw)) {
            return badRequest("Invalid booking status");
        }

        if ("REJECTED".equals(statusRaw) || "CANCELLED".equals(statusRaw)) {
            b.setStatus(statusRaw);
            if ("PAID".equalsIgnoreCase(b.getPaymentStatus()) && b.getUser() != null && b.getPaymentAmount() != null && b.getPaymentAmount() > 0) {
                User u = b.getUser();
                double currentBal = u.getWalletBalance() != null ? u.getWalletBalance() : 0.0;
                u.setWalletBalance(currentBal + b.getPaymentAmount());
                userRepo.save(u);
                b.setPaymentStatus("REFUNDED");
            }
        } else if ("COMPLETED".equals(statusRaw)) {
            int total = b.getTotalSessions() != null && b.getTotalSessions() > 0 ? b.getTotalSessions() : 1;
            int completed = b.getCompletedSessions() != null ? b.getCompletedSessions() : 0;
            completed++;
            b.setCompletedSessions(completed);
            if (completed >= total) {
                b.setStatus("COMPLETED");
                if (!"PAID".equalsIgnoreCase(b.getPaymentStatus())) {
                    b.setPaymentStatus("PAID");
                }
            } else {
                b.setStatus("APPROVED"); // Still has remaining sessions
            }
        } else {
            b.setStatus(statusRaw);
        }

        bookingRepo.save(b);
        Map<String, Object> res = new LinkedHashMap<>();
        res.put("success", true);
        res.put("message", "Booking updated");
        res.put("status", b.getStatus());
        res.put("completedSessions", b.getCompletedSessions());
        res.put("totalSessions", b.getTotalSessions());
        return ResponseEntity.ok(res);
    }

    @PostMapping("/bookings/{id}/reschedule")
    @Transactional
    public ResponseEntity<Map<String, Object>> rescheduleBooking(
            @PathVariable("id") Long id,
            @RequestBody Map<String, Object> body,
            HttpSession session) {
        FitnessTrainer t = requireTrainer(session);
        if (t == null) return unauthorized();
        FitnessBooking b = bookingRepo.findById(id).orElse(null);
        if (b == null || b.getTrainer() == null || !b.getTrainer().getId().equals(t.getId())) {
            return badRequest("Booking not found");
        }

        String newDateStr = str(body, "newDate");
        String newTime = str(body, "newTime");
        if (newDateStr.isBlank() || newTime.isBlank()) {
            return badRequest("newDate and newTime are required");
        }

        try {
            LocalDate newDate = LocalDate.parse(newDateStr);
            b.setBookingDate(newDate);
            b.setBookingTime(newTime);
            bookingRepo.save(b);

            Map<String, Object> res = new LinkedHashMap<>();
            res.put("success", true);
            res.put("message", "Session rescheduled to " + newDateStr + " at " + newTime);
            res.put("bookingDate", newDateStr);
            res.put("bookingTime", newTime);
            return ResponseEntity.ok(res);
        } catch (Exception ex) {
            return badRequest("Invalid date or time: " + ex.getMessage());
        }
    }

    @PostMapping("/payout/request")
    @Transactional
    public ResponseEntity<Map<String, Object>> requestPayout(HttpSession session) {
        FitnessTrainer t = requireTrainer(session);
        if (t == null) return unauthorized();
        try {
            return ResponseEntity.ok(fitnessCareService.requestPayout(trainerRepo.findById(t.getId()).orElse(t)));
        } catch (org.springframework.web.server.ResponseStatusException ex) {
            return ResponseEntity.status(ex.getStatusCode()).body(error(ex.getReason()));
        }
    }

    @PostMapping("/bookings/{id}/notes")
    @Transactional
    public ResponseEntity<Map<String, Object>> updateNotes(
            @PathVariable("id") Long id,
            @RequestBody Map<String, Object> body,
            HttpSession session) {
        FitnessTrainer t = requireTrainer(session);
        if (t == null) return unauthorized();
        FitnessBooking b = bookingRepo.findById(id).orElse(null);
        if (b == null || b.getTrainer() == null || !b.getTrainer().getId().equals(t.getId())) {
            return badRequest("Booking not found");
        }
        b.setCoachNotes(body == null || body.get("coachNotes") == null ? "" : String.valueOf(body.get("coachNotes")));
        bookingRepo.save(b);
        Map<String, Object> res = new LinkedHashMap<>();
        res.put("success", true);
        res.put("message", "Notes saved");
        return ResponseEntity.ok(res);
    }

    @PostMapping(value = "/photos", consumes = org.springframework.http.MediaType.MULTIPART_FORM_DATA_VALUE)
    @Transactional
    public ResponseEntity<Map<String, Object>> uploadPhotos(
            @RequestParam(value = "profileImage", required = false) MultipartFile profileImage,
            @RequestParam(value = "galleryPhotos", required = false) MultipartFile galleryPhotos,
            @RequestParam(value = "certificate", required = false) MultipartFile certificate,
            HttpSession session) {
        FitnessTrainer t = requireTrainer(session);
        if (t == null) return unauthorized();
        t = trainerRepo.findById(t.getId()).orElse(t);
        try {
            if (profileImage != null && !profileImage.isEmpty()) {
                t.setProfilePhotoPath(fileUploadService.saveFile(profileImage));
            }
            if (galleryPhotos != null && !galleryPhotos.isEmpty()) {
                String path = fileUploadService.saveFile(galleryPhotos);
                String existing = t.getGalleryPhotos();
                t.setGalleryPhotos(existing == null || existing.isBlank() ? path : existing + "," + path);
            }
            if (certificate != null && !certificate.isEmpty()) {
                t.setCertificationsPath(fileUploadService.saveFile(certificate));
            }
            trainerRepo.save(t);
            Map<String, Object> res = new LinkedHashMap<>();
            res.put("success", true);
            res.put("message", "Photos saved");
            res.putAll(trainerProfileService.profilePayload(t));
            return ResponseEntity.ok(res);
        } catch (Exception ex) {
            return badRequest(ex.getMessage() == null ? "Upload failed" : ex.getMessage());
        }
    }

    @GetMapping("/packages")
    public ResponseEntity<Map<String, Object>> getTrainerPackages(HttpSession session) {
        FitnessTrainer t = requireTrainer(session);
        if (t == null) return unauthorized();
        List<FitnessPackage> packages = fitnessPackageRepo.findByTrainer_Id(t.getId());
        List<Map<String, Object>> dtos = packages.stream().map(p -> {
            Map<String, Object> m = new LinkedHashMap<String, Object>();
            m.put("id", p.getId());
            m.put("packageName", p.getPackageName());
            m.put("category", p.getCategory());
            m.put("description", p.getDescription());
            m.put("sessionCount", p.getSessionCount());
            m.put("durationDays", p.getDurationDays());
            m.put("price", p.getPrice());
            m.put("sessionType", p.getSessionType());
            m.put("active", p.isActive());
            return m;
        }).collect(Collectors.toList());

        Map<String, Object> res = new LinkedHashMap<>();
        res.put("success", true);
        res.put("packages", dtos);
        return ResponseEntity.ok(res);
    }

    @PostMapping("/packages")
    @Transactional
    public ResponseEntity<Map<String, Object>> savePackage(
            @RequestBody Map<String, Object> body,
            HttpSession session) {
        FitnessTrainer t = requireTrainer(session);
        if (t == null) return unauthorized();

        Long packageId = null;
        if (body.get("id") != null && !str(body, "id").isBlank()) {
            try { packageId = Long.parseLong(str(body, "id")); } catch (Exception ignored) {}
        }
        String name = str(body, "packageName");
        String category = str(body, "category");
        String description = str(body, "description");
        Integer sessionCount = 1;
        Integer durationDays = 30;
        Double price = 0.0;
        try { if (body.get("sessionCount") != null) sessionCount = Integer.parseInt(str(body, "sessionCount")); } catch (Exception ignored) {}
        try { if (body.get("durationDays") != null) durationDays = Integer.parseInt(str(body, "durationDays")); } catch (Exception ignored) {}
        try { if (body.get("price") != null) price = Double.parseDouble(str(body, "price")); } catch (Exception ignored) {}
        String sessionType = str(body, "sessionType");

        try {
            FitnessPackage pkg = fitnessService.createOrUpdatePackage(t, packageId, name, category, description,
                    sessionCount, durationDays, price, sessionType);
            Map<String, Object> res = new LinkedHashMap<>();
            res.put("success", true);
            res.put("message", "Package saved successfully");
            res.put("packageId", pkg.getId());
            return ResponseEntity.ok(res);
        } catch (Exception ex) {
            return badRequest(ex.getMessage() == null ? "Save failed" : ex.getMessage());
        }
    }

    @DeleteMapping("/packages/{id}")
    @Transactional
    public ResponseEntity<Map<String, Object>> deletePackage(@PathVariable("id") Long id, HttpSession session) {
        FitnessTrainer t = requireTrainer(session);
        if (t == null) return unauthorized();
        try {
            fitnessService.deletePackage(t, id);
            Map<String, Object> res = new LinkedHashMap<>();
            res.put("success", true);
            res.put("message", "Package deleted");
            return ResponseEntity.ok(res);
        } catch (Exception ex) {
            return badRequest(ex.getMessage() == null ? "Delete failed" : ex.getMessage());
        }
    }

    @PostMapping("/attendance")
    @Transactional
    public ResponseEntity<Map<String, Object>> markAttendance(
            @RequestBody Map<String, Object> body,
            HttpSession session) {
        FitnessTrainer t = requireTrainer(session);
        if (t == null) return unauthorized();

        Long bookingId;
        try {
            bookingId = Long.parseLong(str(body, "bookingId"));
        } catch (Exception e) {
            return badRequest("Valid bookingId is required");
        }

        String sessionDateStr = str(body, "sessionDate");
        LocalDate date = sessionDateStr.isBlank() ? LocalDate.now() : LocalDate.parse(sessionDateStr);
        String sessionTime = str(body, "sessionTime");
        String status = str(body, "status");
        if (status.isBlank()) status = "PRESENT";
        String notes = str(body, "notes");

        try {
            FitnessAttendance att = fitnessService.markAttendance(t, bookingId, date, sessionTime, status, notes);
            Map<String, Object> res = new LinkedHashMap<>();
            res.put("success", true);
            res.put("message", "Attendance recorded");
            res.put("attendanceId", att.getId());
            return ResponseEntity.ok(res);
        } catch (Exception ex) {
            return badRequest(ex.getMessage() == null ? "Attendance failed" : ex.getMessage());
        }
    }

    @PostMapping("/progress")
    @Transactional
    public ResponseEntity<Map<String, Object>> logProgress(
            @RequestBody Map<String, Object> body,
            HttpSession session) {
        FitnessTrainer t = requireTrainer(session);
        if (t == null) return unauthorized();

        Long userId;
        try {
            userId = Long.parseLong(str(body, "userId"));
        } catch (Exception e) {
            return badRequest("Valid userId is required");
        }

        Double weightKg = null;
        Double bodyFat = null;
        Integer workouts = 1;
        try { if (body.get("weightKg") != null) weightKg = Double.parseDouble(str(body, "weightKg")); } catch (Exception ignored) {}
        try { if (body.get("bodyFatPct") != null) bodyFat = Double.parseDouble(str(body, "bodyFatPct")); } catch (Exception ignored) {}
        try { if (body.get("workoutsCompleted") != null) workouts = Integer.parseInt(str(body, "workoutsCompleted")); } catch (Exception ignored) {}
        String metricsJson = str(body, "metricsJson");
        String workoutNotes = str(body, "workoutNotes");

        try {
            FitnessProgressLog log = fitnessService.logClientProgress(userId, t, LocalDate.now(), weightKg, bodyFat,
                    workouts, metricsJson, workoutNotes);
            Map<String, Object> res = new LinkedHashMap<>();
            res.put("success", true);
            res.put("message", "Progress logged");
            res.put("logId", log.getId());
            return ResponseEntity.ok(res);
        } catch (Exception ex) {
            return badRequest(ex.getMessage() == null ? "Logging progress failed" : ex.getMessage());
        }
    }

    // ==========================================
    // DYNAMIC QR ATTENDANCE (MOBILE TRAINER)
    // ==========================================

    @PostMapping("/qr-session")
    public ResponseEntity<Map<String, Object>> createQrSession(
            @RequestBody(required = false) Map<String, Object> body,
            HttpSession session) {
        FitnessTrainer t = requireTrainer(session);
        if (t == null) return unauthorized();

        try {
            Long classId = null;
            int duration = 15;
            Double lat = null;
            Double lng = null;

            if (body != null) {
                if (body.get("classId") != null && !body.get("classId").toString().isEmpty()) {
                    classId = Long.valueOf(body.get("classId").toString());
                }
                if (body.get("duration") != null && !body.get("duration").toString().isEmpty()) {
                    duration = Integer.parseInt(body.get("duration").toString());
                }
                if (body.get("latitude") != null) {
                    lat = Double.parseDouble(body.get("latitude").toString());
                }
                if (body.get("longitude") != null) {
                    lng = Double.parseDouble(body.get("longitude").toString());
                }
            }

            in.sp.main.Entities.FitnessQrAttendanceSession qrSession = fitnessQrAttendanceService.createOrRefreshSession(
                    t, classId, LocalDate.now(), duration, lat, lng);

            Map<String, Object> res = new LinkedHashMap<>();
            res.put("success", true);
            res.put("sessionId", qrSession.getId());
            res.put("token", qrSession.getToken());
            res.put("qrPayload", qrSession.getToken());
            res.put("trainerName", t.getFullName());
            res.put("sessionDate", qrSession.getSessionDate().toString());
            res.put("expiresAt", qrSession.getExpiresAt().toString());
            res.put("durationMinutes", duration);
            return ResponseEntity.ok(res);
        } catch (Exception ex) {
            return badRequest(ex.getMessage() == null ? "QR creation failed" : ex.getMessage());
        }
    }

    @PostMapping("/qr-session/{id}/close")
    public ResponseEntity<Map<String, Object>> closeQrSession(
            @PathVariable("id") Long id, HttpSession session) {
        FitnessTrainer t = requireTrainer(session);
        if (t == null) return unauthorized();

        try {
            fitnessQrAttendanceService.closeSession(id, t);
            Map<String, Object> res = new LinkedHashMap<>();
            res.put("success", true);
            res.put("message", "QR session closed");
            return ResponseEntity.ok(res);
        } catch (Exception ex) {
            return badRequest(ex.getMessage() == null ? "Failed to close QR" : ex.getMessage());
        }
    }

    @GetMapping("/qr-session/{id}/attendees")
    public ResponseEntity<Map<String, Object>> getQrAttendees(
            @PathVariable("id") Long id, HttpSession session) {
        FitnessTrainer t = requireTrainer(session);
        if (t == null) return unauthorized();

        try {
            List<Map<String, Object>> attendees = fitnessQrAttendanceService.getSessionAttendees(t, id);
            Map<String, Object> res = new LinkedHashMap<>();
            res.put("success", true);
            res.put("attendees", attendees);
            return ResponseEntity.ok(res);
        } catch (Exception ex) {
            return badRequest(ex.getMessage() == null ? "Failed to fetch attendees" : ex.getMessage());
        }
    }

    @GetMapping("/qr-session/active")
    public ResponseEntity<Map<String, Object>> getActiveQrSession(HttpSession session) {
        FitnessTrainer t = requireTrainer(session);
        if (t == null) return unauthorized();

        Optional<in.sp.main.Entities.FitnessQrAttendanceSession> active = fitnessQrAttendanceService.getActiveSession(t, LocalDate.now());
        Map<String, Object> res = new LinkedHashMap<>();
        if (active.isPresent()) {
            in.sp.main.Entities.FitnessQrAttendanceSession s = active.get();
            res.put("success", true);
            res.put("active", true);
            res.put("sessionId", s.getId());
            res.put("token", s.getToken());
            res.put("qrPayload", s.getToken());
            res.put("trainerName", t.getFullName());
            res.put("sessionDate", s.getSessionDate().toString());
            res.put("expiresAt", s.getExpiresAt().toString());
        } else {
            res.put("success", true);
            res.put("active", false);
        }
        return ResponseEntity.ok(res);
    }

    @GetMapping("/classes")
    public ResponseEntity<Map<String, Object>> getClasses(HttpSession session) {
        FitnessTrainer t = requireTrainer(session);
        if (t == null) return unauthorized();
        List<in.sp.main.Entities.FitnessClass> classes = fitnessClassRepo.findByTrainer_IdOrderByClassDateAsc(t.getId());
        List<Map<String, Object>> dtos = classes.stream().map(this::classDto).toList();
        Map<String, Object> res = new LinkedHashMap<>();
        res.put("success", true);
        res.put("classes", dtos);
        return ResponseEntity.ok(res);
    }

    @PostMapping("/classes")
    @Transactional
    public ResponseEntity<Map<String, Object>> createClass(
            @RequestBody Map<String, Object> body,
            HttpSession session) {
        FitnessTrainer t = requireTrainer(session);
        if (t == null) return unauthorized();
        if (body == null) return badRequest("Request body is required");

        String className = str(body, "className");
        if (className.isBlank()) return badRequest("Class name is required");
        String category = str(body, "category");
        if (category.isBlank()) category = "General Fitness";
        String description = str(body, "description");

        LocalDate classDate;
        try {
            classDate = LocalDate.parse(str(body, "classDate"));
            if (classDate.isBefore(LocalDate.now())) {
                return badRequest("Class date cannot be in the past");
            }
        } catch (Exception e) {
            return badRequest("Valid classDate (YYYY-MM-DD) is required");
        }

        LocalTime classTime;
        String rawTime = str(body, "classTime");
        try {
            if (rawTime.contains(":") && rawTime.split(":")[0].length() == 1) {
                rawTime = "0" + rawTime;
            }
            classTime = LocalTime.parse(rawTime);
        } catch (Exception e) {
            return badRequest("Valid classTime (HH:mm) is required");
        }

        int duration = 60;
        if (body.get("durationMinutes") != null) {
            try { duration = Integer.parseInt(body.get("durationMinutes").toString()); } catch (Exception ignored) {}
        }

        String sessionType = str(body, "sessionType");
        if (sessionType.isBlank()) sessionType = "ONLINE";

        int maxCapacity = 20;
        if (body.get("maxCapacity") != null) {
            try {
                maxCapacity = Integer.parseInt(body.get("maxCapacity").toString());
                if (maxCapacity < 1 || maxCapacity > 9999) return badRequest("Capacity must be between 1 and 9999");
            } catch (Exception e) {
                return badRequest("Invalid maxCapacity");
            }
        }

        double price = 0.0;
        if (body.get("price") != null) {
            try {
                price = Double.parseDouble(body.get("price").toString());
                if (price < 0 || price > 999999) return badRequest("Price must be between 0 and 999999");
            } catch (Exception e) {
                return badRequest("Invalid price");
            }
        }

        String meetingLinkOrLocation = str(body, "meetingLinkOrLocation");

        in.sp.main.Entities.FitnessClass fc = new in.sp.main.Entities.FitnessClass();
        fc.setTrainer(t);
        fc.setClassName(className);
        fc.setCategory(category);
        fc.setDescription(description);
        fc.setClassDate(classDate);
        fc.setClassTime(classTime);
        fc.setDurationMinutes(duration);
        fc.setSessionType(sessionType);
        fc.setMaxCapacity(maxCapacity);
        fc.setCurrentEnrollment(0);
        fc.setPrice(price);
        fc.setMeetingLinkOrLocation(meetingLinkOrLocation);
        fc.setStatus("ACTIVE");

        fitnessClassRepo.save(fc);

        Map<String, Object> res = new LinkedHashMap<>();
        res.put("success", true);
        res.put("message", "Class created successfully");
        res.put("class", classDto(fc));
        return ResponseEntity.ok(res);
    }

    @PutMapping("/classes/{id}")
    @Transactional
    public ResponseEntity<Map<String, Object>> editClass(
            @PathVariable("id") Long id,
            @RequestBody Map<String, Object> body,
            HttpSession session) {
        FitnessTrainer t = requireTrainer(session);
        if (t == null) return unauthorized();
        if (body == null) return badRequest("Request body is required");

        in.sp.main.Entities.FitnessClass fc = fitnessClassRepo.findById(id).orElse(null);
        if (fc == null || fc.getTrainer() == null || !fc.getTrainer().getId().equals(t.getId())) {
            return badRequest("Class not found or unauthorized access");
        }

        if (body.containsKey("className")) fc.setClassName(str(body, "className"));
        if (body.containsKey("category")) fc.setCategory(str(body, "category"));
        if (body.containsKey("description")) fc.setDescription(str(body, "description"));
        if (body.containsKey("classDate")) {
            try { fc.setClassDate(LocalDate.parse(str(body, "classDate"))); } catch (Exception ignored) {}
        }
        if (body.containsKey("classTime")) {
            try {
                String rawTime = str(body, "classTime");
                if (rawTime.contains(":") && rawTime.split(":")[0].length() == 1) {
                    rawTime = "0" + rawTime;
                }
                fc.setClassTime(LocalTime.parse(rawTime));
            } catch (Exception ignored) {}
        }
        if (body.containsKey("durationMinutes")) {
            try { fc.setDurationMinutes(Integer.parseInt(body.get("durationMinutes").toString())); } catch (Exception ignored) {}
        }
        if (body.containsKey("sessionType")) fc.setSessionType(str(body, "sessionType"));
        if (body.containsKey("maxCapacity")) {
            try { fc.setMaxCapacity(Integer.parseInt(body.get("maxCapacity").toString())); } catch (Exception ignored) {}
        }
        if (body.containsKey("price")) {
            try { fc.setPrice(Double.parseDouble(body.get("price").toString())); } catch (Exception ignored) {}
        }
        if (body.containsKey("meetingLinkOrLocation")) fc.setMeetingLinkOrLocation(str(body, "meetingLinkOrLocation"));
        if (body.containsKey("status")) fc.setStatus(str(body, "status"));

        fitnessClassRepo.save(fc);

        Map<String, Object> res = new LinkedHashMap<>();
        res.put("success", true);
        res.put("message", "Class updated successfully");
        res.put("class", classDto(fc));
        return ResponseEntity.ok(res);
    }

    @DeleteMapping("/classes/{id}")
    @Transactional
    public ResponseEntity<Map<String, Object>> deleteClass(
            @PathVariable("id") Long id,
            HttpSession session) {
        FitnessTrainer t = requireTrainer(session);
        if (t == null) return unauthorized();

        in.sp.main.Entities.FitnessClass fc = fitnessClassRepo.findById(id).orElse(null);
        if (fc == null || fc.getTrainer() == null || !fc.getTrainer().getId().equals(t.getId())) {
            return badRequest("Class not found or unauthorized access");
        }

        // Refund registered users and cancel bookings
        List<FitnessBooking> classBookings = bookingRepo.findByFitnessClass_Id(id);
        for (FitnessBooking booking : classBookings) {
            if ("PAID".equalsIgnoreCase(booking.getPaymentStatus())) {
                User user = booking.getUser();
                if (user != null) {
                    double refundAmount = booking.getPaymentAmount() != null ? booking.getPaymentAmount() : 0.0;
                    user.setWalletBalance((user.getWalletBalance() != null ? user.getWalletBalance() : 0.0) + refundAmount);
                    userRepo.save(user);
                }
            }
            booking.setStatus("CANCELLED");
            bookingRepo.save(booking);
        }

        fitnessClassRepo.delete(fc);

        Map<String, Object> res = new LinkedHashMap<>();
        res.put("success", true);
        res.put("message", "Class deleted and registered users refunded");
        return ResponseEntity.ok(res);
    }

    private Map<String, Object> classDto(in.sp.main.Entities.FitnessClass c) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", c.getId());
        m.put("className", c.getClassName());
        m.put("category", c.getCategory());
        m.put("description", c.getDescription());
        m.put("classDate", c.getClassDate() == null ? null : c.getClassDate().toString());
        m.put("classTime", c.getClassTime() == null ? null : c.getClassTime().toString());
        m.put("durationMinutes", c.getDurationMinutes());
        m.put("sessionType", c.getSessionType());
        m.put("maxCapacity", c.getMaxCapacity());
        m.put("currentEnrollment", c.getCurrentEnrollment());
        m.put("price", c.getPrice());
        m.put("meetingLinkOrLocation", c.getMeetingLinkOrLocation());
        m.put("status", c.getStatus());
        return m;
    }

    private FitnessTrainer requireTrainer(HttpSession session) {
        Object t = session == null ? null : session.getAttribute("loggedTrainer");
        if (t instanceof FitnessTrainer trainer) {
            return trainer;
        }
        org.springframework.security.core.Authentication auth =
                org.springframework.security.core.context.SecurityContextHolder.getContext().getAuthentication();
        if (auth != null && auth.isAuthenticated() && !"anonymousUser".equals(auth.getName())) {
            Optional<FitnessTrainer> opt = trainerRepo.findByEmailIgnoreCase(auth.getName())
                    .or(() -> trainerRepo.findByEmail(auth.getName()));
            if (opt.isPresent()) {
                FitnessTrainer trainer = opt.get();
                if (session != null) {
                    session.setAttribute("loggedTrainer", trainer);
                }
                return trainer;
            }
        }
        return null;
    }

    private ResponseEntity<Map<String, Object>> unauthorized() {
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(error("Trainer login required"));
    }

    private ResponseEntity<Map<String, Object>> badRequest(String error) {
        return ResponseEntity.badRequest().body(error(error));
    }

    private static Map<String, Object> error(String msg) {
        Map<String, Object> out = new LinkedHashMap<>();
        out.put("success", false);
        out.put("error", msg);
        return out;
    }

    private static String trim(String value) {
        return value == null ? "" : value.trim();
    }

    private static String str(Map<String, Object> body, String key) {
        if (body == null || body.get(key) == null) return "";
        return String.valueOf(body.get(key)).trim();
    }

    private Map<String, Object> trainerSummary(FitnessTrainer t) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", t.getId());
        m.put("fullName", t.getFullName());
        m.put("email", t.getEmail());
        m.put("phone", t.getPhone());
        m.put("experience", t.getExperience());
        m.put("specializations", t.getSpecializations());
        m.put("availableTimings", t.getAvailableTimings());
        m.put("sessionFees", t.getSessionFees());
        m.put("city", t.getCity());
        m.put("bio", t.getBio());
        m.put("serviceType", t.getServiceType());
        m.put("rating", t.getRating());
        m.put("verificationStatus", t.getVerificationStatus() == null ? null : t.getVerificationStatus().name());
        m.put("suspended", t.isSuspended());
        m.put("partnerProfileStatus", t.getPartnerProfileStatus() == null
                ? null : t.getPartnerProfileStatus().name());
        m.put("partnerProfileStatusLabel", FitnessTrainerProfileService.statusLabel(t.getPartnerProfileStatus()));
        m.put("profileCompletionPct", t.getProfileCompletionPct() == null ? 0 : t.getProfileCompletionPct());
        m.put("rejectionReason", t.getRejectionReason());
        m.put("changesRequestedNote", t.getChangesRequestedNote());
        m.put("onlineAvailable", t.isOnlineAvailable());
        m.put("profilePhotoPath", t.getProfilePhotoPath());
        FitnessTrainerProfileService.putExtra(m, t);
        return m;
    }
}
