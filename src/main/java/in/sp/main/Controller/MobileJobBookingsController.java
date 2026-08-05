package in.sp.main.Controller;

import in.sp.main.Entities.JobApplication;
import in.sp.main.Entities.User;
import in.sp.main.Entities.VerificationStatus;
import in.sp.main.Entities.WorkerBooking;
import in.sp.main.Repository.JobApplicationRepository;
import in.sp.main.Repository.WorkerBookingRepository;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/job-bookings")
public class MobileJobBookingsController {

    @Autowired
    private WorkerBookingRepository workerBookingRepo;
    @Autowired
    private JobApplicationRepository jobApplicationRepo;

    @GetMapping("/worker/me")
    public ResponseEntity<Map<String, Object>> workerBookings(HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        boolean isWorker = jobApplicationRepo.findByStatus(VerificationStatus.VERIFIED).stream()
                .anyMatch(a -> a.getUser() != null && a.getUser().getId().equals(user.getId()));
        if (!isWorker) return badRequest("Verified worker profile required");
        List<Map<String, Object>> items = workerBookingRepo.findByJobApplication_User_Id(user.getId()).stream().map(b -> {
            Map<String, Object> m = new LinkedHashMap<>();
            m.put("id", b.getId());
            m.put("status", b.getStatus());
            m.put("bookingDate", b.getBookingDate() == null ? null : b.getBookingDate().toString());
            m.put("note", b.getNote());
            m.put("hours", b.getHours());
            m.put("totalAmount", b.getTotalAmount());
            m.put("serviceType", b.getJobApplication() == null ? null : b.getJobApplication().getJobCategory());
            if (b.getClient() != null) {
                m.put("clientName", b.getClient().getFullName());
                m.put("clientPhone", b.getClient().getPhoneNumber());
            }
            return m;
        }).toList();
        return ResponseEntity.ok(ok(Map.of("bookings", items)));
    }

    @GetMapping("/client/me")
    public ResponseEntity<Map<String, Object>> clientBookings(HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        List<Map<String, Object>> items = workerBookingRepo.findByClient_Id(user.getId()).stream().map(b -> {
            Map<String, Object> m = new LinkedHashMap<>();
            m.put("id", b.getId());
            m.put("status", b.getStatus());
            m.put("bookingDate", b.getBookingDate() == null ? null : b.getBookingDate().toString());
            m.put("note", b.getNote());
            m.put("hours", b.getHours());
            m.put("totalAmount", b.getTotalAmount());
            if (b.getJobApplication() != null && b.getJobApplication().getUser() != null) {
                m.put("workerName", b.getJobApplication().getUser().getFullName());
                m.put("serviceType", b.getJobApplication().getJobCategory());
                m.put("workerPhone", b.getJobApplication().getUser().getPhoneNumber());
            }
            return m;
        }).toList();
        return ResponseEntity.ok(ok(Map.of("bookings", items)));
    }

    @PatchMapping("/{id}/status")
    public ResponseEntity<Map<String, Object>> updateStatus(
            @PathVariable Long id,
            @RequestBody Map<String, String> body,
            HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        WorkerBooking booking = workerBookingRepo.findById(id).orElse(null);
        if (booking == null) return badRequest("Booking not found");
        if (booking.getJobApplication() == null || booking.getJobApplication().getUser() == null
                || !booking.getJobApplication().getUser().getId().equals(user.getId())) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN)
                    .body(Map.of("success", false, "error", "Only assigned worker can update this booking"));
        }
        String next = body == null ? "" : body.getOrDefault("status", "").trim().toUpperCase();
        if (!"ACCEPTED".equals(next) && !"REJECTED".equals(next) && !"COMPLETED".equals(next)) {
            return badRequest("status must be ACCEPTED, REJECTED, or COMPLETED");
        }
        booking.setStatus(next);
        workerBookingRepo.save(booking);
        return ResponseEntity.ok(ok(Map.of("message", "Booking status updated", "status", next)));
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
}
