package in.sp.main.Controller;

import in.sp.main.Entities.*;
import in.sp.main.Repository.*;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/fitness")
public class MobileFitnessController {

    @Autowired
    private FitnessTrainerRepository trainerRepo;
    @Autowired
    private FitnessBookingRepository bookingRepo;

    @GetMapping("/trainers")
    public ResponseEntity<Map<String, Object>> trainers(HttpSession session) {
        if (requireUser(session) == null) return unauthorized();
        List<Map<String, Object>> items = trainerRepo.findByVerificationStatusAndSuspended(VerificationStatus.VERIFIED, false)
                .stream().map(this::trainerDto).toList();
        return ResponseEntity.ok(ok(Map.of("trainers", items, "count", items.size())));
    }

    @GetMapping("/trainers/{id}")
    public ResponseEntity<Map<String, Object>> trainerDetail(@PathVariable Long id, HttpSession session) {
        if (requireUser(session) == null) return unauthorized();
        FitnessTrainer t = trainerRepo.findById(id).orElse(null);
        if (t == null || t.getVerificationStatus() != VerificationStatus.VERIFIED || t.isSuspended()) {
            return badRequest("Trainer not found");
        }
        return ResponseEntity.ok(ok(Map.of("trainer", trainerDto(t))));
    }

    @PostMapping("/trainers/{id}/bookings")
    @Transactional
    public ResponseEntity<Map<String, Object>> book(@PathVariable Long id, @RequestBody Map<String, String> body, HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        FitnessTrainer t = trainerRepo.findById(id).orElse(null);
        if (t == null || t.getVerificationStatus() != VerificationStatus.VERIFIED) return badRequest("Trainer not found");
        FitnessBooking b = new FitnessBooking();
        b.setUser(user);
        b.setTrainer(t);
        b.setBookingDate(LocalDate.now().plusDays(1));
        b.setBookingTime(trim(body.get("bookingTime")).isBlank() ? "10:00 - 11:00" : trim(body.get("bookingTime")));
        b.setSessionType(trim(body.get("sessionType")).isBlank() ? "ONLINE" : trim(body.get("sessionType")));
        b.setCategory(trim(body.get("category")));
        b.setStatus("PENDING");
        b.setPaymentStatus("PENDING");
        b.setPaymentAmount(t.getSessionFees());
        bookingRepo.save(b);
        return ResponseEntity.ok(ok(Map.of("message", "Booking requested", "bookingId", b.getId())));
    }

    @GetMapping("/bookings/me")
    public ResponseEntity<Map<String, Object>> myBookings(HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        List<Map<String, Object>> items = bookingRepo.findByUser_Id(user.getId()).stream().map(b -> {
            Map<String, Object> m = new LinkedHashMap<>();
            m.put("id", b.getId());
            m.put("status", b.getStatus());
            m.put("bookingDate", b.getBookingDate() == null ? null : b.getBookingDate().toString());
            m.put("bookingTime", b.getBookingTime());
            if (b.getTrainer() != null) m.put("trainer", trainerDto(b.getTrainer()));
            return m;
        }).toList();
        return ResponseEntity.ok(ok(Map.of("bookings", items)));
    }

    private Map<String, Object> trainerDto(FitnessTrainer t) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", t.getId());
        m.put("fullName", t.getFullName());
        m.put("specializations", t.getSpecializations());
        m.put("sessionFees", t.getSessionFees());
        m.put("rating", t.getRating() != null ? t.getRating() : 0.0);
        m.put("profilePhotoPath", t.getProfilePhotoPath());
        m.put("availableTimings", t.getAvailableTimings());
        m.put("experienceYears", t.getExperience());
        m.put("phone", t.getPhone());
        m.put("email", t.getEmail());
        return m;
    }

    private User requireUser(HttpSession session) {
        Object u = session == null ? null : session.getAttribute("user");
        return u instanceof User ? (User) u : null;
    }

    private ResponseEntity<Map<String, Object>> unauthorized() {
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(Map.of("success", false, "error", "Login required"));
    }

    private ResponseEntity<Map<String, Object>> badRequest(String error) {
        return ResponseEntity.badRequest().body(Map.of("success", false, "error", error));
    }

    private static Map<String, Object> ok(Map<String, Object> data) {
        Map<String, Object> out = new LinkedHashMap<>();
        out.put("success", true);
        out.putAll(data);
        return out;
    }

    private static String trim(String v) { return v == null ? "" : v.trim(); }
}
