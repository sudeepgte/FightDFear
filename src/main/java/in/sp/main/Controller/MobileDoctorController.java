package in.sp.main.Controller;

import in.sp.main.Entities.*;
import in.sp.main.Repository.*;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/doctors")
public class MobileDoctorController {

    @Autowired
    private DoctorRepository doctorRepo;
    @Autowired
    private DoctorAppointmentRepository appointmentRepo;

    @GetMapping
    public ResponseEntity<Map<String, Object>> list(HttpSession session) {
        if (requireUser(session) == null) return unauthorized();
        List<Map<String, Object>> items = doctorRepo.findByVerificationStatus(VerificationStatus.VERIFIED).stream()
                .map(this::doctorDto).toList();
        return ResponseEntity.ok(ok(Map.of("doctors", items, "count", items.size())));
    }

    @GetMapping("/{id}")
    public ResponseEntity<Map<String, Object>> detail(@PathVariable Long id, HttpSession session) {
        if (requireUser(session) == null) return unauthorized();
        Doctor d = doctorRepo.findById(id).orElse(null);
        if (d == null || d.getVerificationStatus() != VerificationStatus.VERIFIED) return badRequest("Doctor not found");
        return ResponseEntity.ok(ok(Map.of("doctor", doctorDto(d))));
    }

    @PostMapping("/{id}/appointments")
    @Transactional
    public ResponseEntity<Map<String, Object>> book(@PathVariable Long id, @RequestBody Map<String, String> body, HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        Doctor d = doctorRepo.findById(id).orElse(null);
        if (d == null || d.getVerificationStatus() != VerificationStatus.VERIFIED) return badRequest("Doctor not found");
        DoctorAppointment appt = new DoctorAppointment();
        appt.setUser(user);
        appt.setDoctor(d);
        appt.setAppointmentTime(LocalDateTime.now().plusDays(1));
        appt.setStatus(DoctorAppointmentStatus.PENDING);
        appt.setReason(trim(body.get("notes")));
        appointmentRepo.save(appt);
        return ResponseEntity.ok(ok(Map.of("message", "Appointment requested", "appointmentId", appt.getId())));
    }

    @GetMapping("/appointments/me")
    public ResponseEntity<Map<String, Object>> myAppointments(HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        List<Map<String, Object>> items = appointmentRepo.findByUserOrderByAppointmentTimeDesc(user).stream().map(a -> {
            Map<String, Object> m = new LinkedHashMap<>();
            m.put("id", a.getId());
            m.put("status", a.getStatus() == null ? null : a.getStatus().name());
            m.put("appointmentTime", a.getAppointmentTime() == null ? null : a.getAppointmentTime().toString());
            m.put("reason", a.getReason());
            if (a.getDoctor() != null) m.put("doctor", doctorDto(a.getDoctor()));
            return m;
        }).toList();
        return ResponseEntity.ok(ok(Map.of("appointments", items)));
    }

    private Map<String, Object> doctorDto(Doctor d) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", d.getId());
        m.put("fullName", d.getFullName());
        m.put("specialization", d.getSpecialization());
        m.put("city", d.getCity());
        m.put("locationText", d.getLocationText());
        m.put("consultationFee", d.getConsultationFee());
        m.put("rating", d.getRating());
        m.put("profilePhotoPath", d.getProfilePhotoPath());
        m.put("consultationType", d.getConsultationType() == null ? null : d.getConsultationType().name());
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
