package in.sp.main.Controller;

import in.sp.main.Config.JwtUtil;
import in.sp.main.Entities.FitnessBooking;
import in.sp.main.Entities.FitnessTrainer;
import in.sp.main.Entities.VerificationStatus;
import in.sp.main.Repository.FitnessBookingRepository;
import in.sp.main.Repository.FitnessTrainerRepository;
import in.sp.main.Service.PasswordService;
import in.sp.main.Util.MobileValidation;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;

import java.util.LinkedHashMap;
import java.util.Locale;
import java.util.Map;
import java.util.Optional;
import java.util.Set;

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

    @PostMapping("/register")
    public ResponseEntity<Map<String, Object>> register(@RequestBody Map<String, String> body) {
        String fullName = trim(body == null ? null : body.get("fullName"));
        String email = MobileValidation.normalizeEmail(body == null ? null : body.get("email"));
        String phone = trim(body == null ? null : body.get("phone"));
        String password = body == null ? "" : body.getOrDefault("password", "");
        String confirmPassword = body == null ? "" : body.getOrDefault("confirmPassword", "");
        String specializations = trim(body == null ? null : body.get("specializations"));
        String availableTimings = trim(body == null ? null : body.get("availableTimings"));
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
        t.setCertificationsPath("mobile-pending");
        t.setVerificationStatus(VerificationStatus.PENDING);
        t.setSuspended(false);
        t.setRating(0.0);

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

        trainerRepo.save(t);

        Map<String, Object> res = new LinkedHashMap<>();
        res.put("success", true);
        res.put("message", "Registration submitted. Await admin verification.");
        res.put("trainerId", t.getId());
        res.put("status", "PENDING");
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
        if (t.getVerificationStatus() != VerificationStatus.VERIFIED) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(error("Your account is pending admin verification"));
        }
        if (t.isSuspended()) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(error("Your trainer account has been suspended"));
        }

        session.setAttribute("loggedTrainer", t);
        String token = jwtUtil.generateToken(t.getEmail(), "TRAINER");
        Map<String, Object> res = new LinkedHashMap<>();
        res.put("success", true);
        res.put("token", token);
        res.put("tokenType", "Bearer");
        res.put("role", "TRAINER");
        res.put("trainer", trainerSummary(t));
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
        data.put("trainer", trainerSummary(t));
        data.put("bookings", bookingDtos);
        data.put("bookingCount", bookings.size());
        data.put("pendingCount", pendingCount);
        data.put("approvedCount", approvedCount);
        data.put("completedCount", completedCount);
        data.put("totalEarnings", totalEarnings);
        return ResponseEntity.ok(data);
    }

    @PostMapping("/bookings/{id}/status")
    @Transactional
    public ResponseEntity<Map<String, Object>> updateBookingStatus(
            @PathVariable Long id,
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
        b.setStatus(statusRaw);
        bookingRepo.save(b);
        Map<String, Object> res = new LinkedHashMap<>();
        res.put("success", true);
        res.put("message", "Booking updated");
        res.put("status", statusRaw);
        return ResponseEntity.ok(res);
    }

    private FitnessTrainer requireTrainer(HttpSession session) {
        Object t = session == null ? null : session.getAttribute("loggedTrainer");
        return t instanceof FitnessTrainer ? (FitnessTrainer) t : null;
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
        m.put("rating", t.getRating());
        m.put("verificationStatus", t.getVerificationStatus() == null ? null : t.getVerificationStatus().name());
        m.put("suspended", t.isSuspended());
        return m;
    }
}
