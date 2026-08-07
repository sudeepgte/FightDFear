package in.sp.main.Controller;

import in.sp.main.Entities.*;
import in.sp.main.Repository.*;
import in.sp.main.Service.DoctorAppointmentService;
import in.sp.main.Service.DoctorBookingService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

@RestController
@RequestMapping("/api/doctors")
public class MobileDoctorController {

    private static final DateTimeFormatter FMT_SPACE = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
    private static final DateTimeFormatter FMT_T = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");

    @Autowired
    private DoctorRepository doctorRepo;
    @Autowired
    private DoctorAppointmentRepository appointmentRepo;
    @Autowired
    private DoctorReviewRepository reviewRepo;
    @Autowired
    private DoctorChatRepository chatRepo;
    @Autowired
    private UserRepository userRepo;
    @Autowired
    private DoctorBookingService bookingService;
    @Autowired
    private DoctorAppointmentService appointmentService;

    @GetMapping
    public ResponseEntity<Map<String, Object>> list(
            @RequestParam(required = false) String q,
            @RequestParam(required = false) String city,
            @RequestParam(required = false) String specialization,
            @RequestParam(required = false) Double minFee,
            @RequestParam(required = false) Double maxFee,
            @RequestParam(required = false) Boolean online,
            @RequestParam(required = false) Boolean emergency,
            @RequestParam(required = false) Boolean instant,
            HttpSession session) {
        if (requireUser(session) == null) return unauthorized();
        String qLower = q == null ? "" : q.trim().toLowerCase(Locale.ROOT);
        String cityLower = city == null ? "" : city.trim().toLowerCase(Locale.ROOT);
        String specLower = specialization == null ? "" : specialization.trim().toLowerCase(Locale.ROOT);

        List<Map<String, Object>> items = doctorRepo.findByVerificationStatus(VerificationStatus.VERIFIED).stream()
                .filter(d -> {
                    if (!qLower.isEmpty()) {
                        String hay = ((d.getFullName() == null ? "" : d.getFullName()) + " "
                                + (d.getSpecialization() == null ? "" : d.getSpecialization()) + " "
                                + (d.getCity() == null ? "" : d.getCity()) + " "
                                + (d.getLocationText() == null ? "" : d.getLocationText())).toLowerCase(Locale.ROOT);
                        if (!hay.contains(qLower)) return false;
                    }
                    if (!cityLower.isEmpty()) {
                        String c = (d.getCity() == null ? "" : d.getCity()).toLowerCase(Locale.ROOT);
                        if (!c.contains(cityLower)) return false;
                    }
                    if (!specLower.isEmpty()) {
                        String s = (d.getSpecialization() == null ? "" : d.getSpecialization()).toLowerCase(Locale.ROOT);
                        if (!s.contains(specLower)) return false;
                    }
                    double fee = d.getConsultationFee() == null ? 0 : d.getConsultationFee();
                    if (minFee != null && fee < minFee) return false;
                    if (maxFee != null && fee > maxFee) return false;
                    if (Boolean.TRUE.equals(online) && !Boolean.TRUE.equals(d.getIsOnline())) return false;
                    if (Boolean.TRUE.equals(emergency) && !Boolean.TRUE.equals(d.getEmergencyAvailable())) return false;
                    if (Boolean.TRUE.equals(instant)
                            && !(Boolean.TRUE.equals(d.getIsOnline()) && Boolean.TRUE.equals(d.getEmergencyAvailable()))) {
                        return false;
                    }
                    return true;
                })
                .map(d -> doctorDto(d, null))
                .toList();
        return ResponseEntity.ok(ok(Map.of("doctors", items, "count", items.size())));
    }

    @GetMapping("/{id}")
    public ResponseEntity<Map<String, Object>> detail(@PathVariable Long id, HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        Doctor d = doctorRepo.findById(id).orElse(null);
        if (d == null || d.getVerificationStatus() != VerificationStatus.VERIFIED) return badRequest("Doctor not found");
        Map<String, Object> dto = doctorDto(d, user);
        List<Map<String, Object>> reviews = reviewRepo.findByDoctorIdOrderByCreatedAtDesc(id).stream()
                .map(this::reviewDto)
                .toList();
        dto.put("reviews", reviews);
        return ResponseEntity.ok(ok(Map.of("doctor", dto)));
    }

    @PostMapping("/{id}/appointments")
    @Transactional
    public ResponseEntity<Map<String, Object>> book(
            @PathVariable Long id,
            @RequestBody Map<String, String> body,
            HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        Doctor d = doctorRepo.findById(id).orElse(null);
        try {
            String reason = trim(body == null ? null : body.get("reason"));
            if (reason.isBlank()) reason = trim(body == null ? null : body.get("notes"));
            ConsultationType cType = parseConsultationType(body == null ? null : body.get("consultationType"));
            LocalDateTime apptTime = parseAppointmentTime(body == null ? null : body.get("appointmentTime"));
            if (apptTime == null) {
                return badRequest("Appointment time is required");
            }
            DoctorAppointment appt = bookingService.createRequestBooking(d, user, apptTime, cType, reason, false);
            Map<String, Object> data = new LinkedHashMap<>();
            data.put("message", "Appointment requested");
            data.put("appointmentId", appt.getId());
            data.put("status", appt.getStatus().name());
            data.put("meetingRoomId", appt.getMeetingRoomId());
            return ResponseEntity.ok(ok(data));
        } catch (org.springframework.web.server.ResponseStatusException ex) {
            return ResponseEntity.status(ex.getStatusCode())
                    .body(Map.of("success", false, "error", ex.getReason() == null ? "Booking failed" : ex.getReason()));
        }
    }

    @GetMapping("/appointments/me")
    public ResponseEntity<Map<String, Object>> myAppointments(HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        List<Map<String, Object>> items = appointmentRepo.findByUserOrderByAppointmentTimeDesc(user).stream()
                .map(a -> appointmentDto(a, user))
                .toList();
        return ResponseEntity.ok(ok(Map.of("appointments", items)));
    }

    @PostMapping("/appointments/{id}/cancel")
    @Transactional
    public ResponseEntity<Map<String, Object>> cancelAppointment(@PathVariable Long id, HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        DoctorAppointment a = appointmentRepo.findById(id).orElse(null);
        try {
            a = appointmentService.cancelByPatient(a, user);
            return ResponseEntity.ok(ok(Map.of("message", "Appointment cancelled", "status", a.getStatus().name())));
        } catch (org.springframework.web.server.ResponseStatusException ex) {
            return ResponseEntity.status(ex.getStatusCode())
                    .body(Map.of("success", false, "error", ex.getReason() == null ? "Cancel failed" : ex.getReason()));
        }
    }

    @GetMapping("/appointments/{id}/join")
    public ResponseEntity<Map<String, Object>> joinAppointment(
            @PathVariable Long id,
            @RequestParam(defaultValue = "false") boolean audioOnly,
            HttpSession session) {
        User user = requireUser(session);
        Doctor doctor = requireDoctor(session);
        if (user == null && doctor == null) return unauthorized();

        DoctorAppointment a = appointmentRepo.findById(id).orElse(null);
        if (a == null) return badRequest("Appointment not found");

        boolean allowed = false;
        String displayName = "Guest";
        if (user != null && a.getUser() != null && a.getUser().getId().equals(user.getId())) {
            allowed = true;
            displayName = user.getFullName() != null ? user.getFullName() : "Patient";
        }
        if (doctor != null && a.getDoctor() != null && a.getDoctor().getId().equals(doctor.getId())) {
            allowed = true;
            displayName = "Dr. " + (doctor.getFullName() != null ? doctor.getFullName() : "Doctor");
        }
        if (!allowed) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(Map.of("success", false, "error", "Access denied"));
        }
        if (!appointmentService.canJoinVideo(a)) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(Map.of(
                    "success", false,
                    "error", "Video join is only allowed for confirmed video/online appointments"));
        }

        String room = a.getMeetingRoomId();
        if (room == null || room.isBlank()) {
            Long docId = a.getDoctor() != null ? a.getDoctor().getId() : 0L;
            Long userId = a.getUser() != null ? a.getUser().getId() : 0L;
            room = audioOnly
                    ? ("safeher-call-" + docId + "-user-" + userId)
                    : ("safeher-doc-" + docId + "-user-" + userId);
            a.setMeetingRoomId(room);
            appointmentRepo.save(a);
        }

        Map<String, Object> data = new LinkedHashMap<>();
        data.put("roomName", room);
        data.put("displayName", displayName);
        data.put("audioOnly", audioOnly);
        data.put("jitsiUrl", "https://meet.jit.si/" + room.replace(" ", ""));
        data.put("status", a.getStatus().name());
        return ResponseEntity.ok(ok(data));
    }

    @GetMapping("/{id}/reviews")
    public ResponseEntity<Map<String, Object>> listReviews(@PathVariable Long id, HttpSession session) {
        if (requireUser(session) == null && requireDoctor(session) == null) return unauthorized();
        Doctor d = doctorRepo.findById(id).orElse(null);
        if (d == null || d.getVerificationStatus() != VerificationStatus.VERIFIED) return badRequest("Doctor not found");
        List<Map<String, Object>> reviews = reviewRepo.findByDoctorIdOrderByCreatedAtDesc(id).stream()
                .map(this::reviewDto)
                .toList();
        return ResponseEntity.ok(ok(Map.of("reviews", reviews)));
    }

    @PostMapping("/{id}/reviews")
    @Transactional
    public ResponseEntity<Map<String, Object>> addReview(
            @PathVariable Long id,
            @RequestBody Map<String, Object> body,
            HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        Doctor d = doctorRepo.findById(id).orElse(null);
        if (d == null || d.getVerificationStatus() != VerificationStatus.VERIFIED) {
            return badRequest("Doctor not found");
        }
        boolean completed = appointmentRepo.findByUserOrderByAppointmentTimeDesc(user).stream()
                .anyMatch(a -> a.getDoctor() != null
                        && a.getDoctor().getId().equals(id)
                        && a.getStatus() == DoctorAppointmentStatus.COMPLETED);
        if (!completed) {
            return badRequest("You can only review doctors after a completed appointment");
        }
        int rating;
        try {
            rating = Integer.parseInt(String.valueOf(body.get("rating")));
        } catch (Exception e) {
            return badRequest("Rating must be 1-5");
        }
        if (rating < 1 || rating > 5) return badRequest("Rating must be 1-5");
        if (reviewRepo.existsByUserIdAndDoctorId(user.getId(), id)) {
            return ResponseEntity.status(HttpStatus.CONFLICT)
                    .body(Map.of("success", false, "error", "You already reviewed this doctor"));
        }

        DoctorReview r = new DoctorReview();
        r.setUser(user);
        r.setDoctor(d);
        r.setRating(rating);
        r.setComment(body.get("comment") == null ? null : String.valueOf(body.get("comment")).trim());
        reviewRepo.save(r);

        List<DoctorReview> reviews = reviewRepo.findByDoctorIdOrderByCreatedAtDesc(id);
        double avg = reviews.stream().mapToInt(x -> x.getRating() == null ? 0 : x.getRating()).average().orElse(0.0);
        d.setRating(avg);
        doctorRepo.save(d);

        return ResponseEntity.status(HttpStatus.CREATED)
                .body(ok(Map.of("message", "Review submitted", "rating", avg)));
    }

    @GetMapping("/{id}/chat")
    public ResponseEntity<Map<String, Object>> chatHistory(
            @PathVariable Long id,
            @RequestParam(required = false) Long userId,
            HttpSession session) {
        User user = requireUser(session);
        Doctor doctor = requireDoctor(session);
        Doctor target = doctorRepo.findById(id).orElse(null);
        if (target == null) return badRequest("Doctor not found");

        User chatUser;
        if (user != null) {
            chatUser = user;
            if (!appointmentService.hasActiveRelationship(target, chatUser)) {
                return ResponseEntity.status(HttpStatus.FORBIDDEN).body(Map.of(
                        "success", false,
                        "error", "Chat is available only after booking an appointment with this doctor"));
            }
        } else if (doctor != null) {
            if (!doctor.getId().equals(id)) {
                return ResponseEntity.status(HttpStatus.FORBIDDEN)
                        .body(Map.of("success", false, "error", "Access denied"));
            }
            if (userId == null) return badRequest("userId is required for doctor chat");
            chatUser = userRepo.findById(userId).orElse(null);
            if (chatUser == null) return badRequest("Patient not found");
            if (!appointmentService.hasActiveRelationship(doctor, chatUser)) {
                return ResponseEntity.status(HttpStatus.FORBIDDEN).body(Map.of(
                        "success", false,
                        "error", "Chat is available only with patients who have booked you"));
            }
        } else {
            return unauthorized();
        }

        List<Map<String, Object>> messages = chatRepo.findByUserAndDoctorOrderByTimestampAsc(chatUser, target)
                .stream()
                .map(this::chatDto)
                .toList();
        Map<String, Object> data = new LinkedHashMap<>();
        data.put("messages", messages);
        data.put("doctorId", id);
        data.put("userId", chatUser.getId());
        return ResponseEntity.ok(ok(data));
    }

    @PostMapping("/{id}/chat")
    @Transactional
    public ResponseEntity<Map<String, Object>> sendChat(
            @PathVariable Long id,
            @RequestBody Map<String, Object> body,
            HttpSession session) {
        User user = requireUser(session);
        Doctor doctor = requireDoctor(session);
        Doctor target = doctorRepo.findById(id).orElse(null);
        if (target == null) return badRequest("Doctor not found");

        String message = body == null || body.get("message") == null ? "" : String.valueOf(body.get("message")).trim();
        if (message.isBlank()) return badRequest("Message is required");

        DoctorChatMessage msg = new DoctorChatMessage();
        msg.setDoctor(target);
        msg.setMessage(message);

        if (user != null) {
            if (!appointmentService.hasActiveRelationship(target, user)) {
                return ResponseEntity.status(HttpStatus.FORBIDDEN).body(Map.of(
                        "success", false,
                        "error", "Chat is available only after booking an appointment with this doctor"));
            }
            msg.setUser(user);
            msg.setSenderType("USER");
        } else if (doctor != null) {
            if (!doctor.getId().equals(id)) {
                return ResponseEntity.status(HttpStatus.FORBIDDEN)
                        .body(Map.of("success", false, "error", "Access denied"));
            }
            Object uidObj = body.get("userId");
            if (uidObj == null) return badRequest("userId is required");
            Long uid;
            try {
                uid = Long.parseLong(uidObj.toString());
            } catch (Exception e) {
                return badRequest("Invalid userId");
            }
            User chatUser = userRepo.findById(uid).orElse(null);
            if (chatUser == null) return badRequest("Patient not found");
            if (!appointmentService.hasActiveRelationship(doctor, chatUser)) {
                return ResponseEntity.status(HttpStatus.FORBIDDEN).body(Map.of(
                        "success", false,
                        "error", "Chat is available only with patients who have booked you"));
            }
            msg.setUser(chatUser);
            msg.setSenderType("DOCTOR");
        } else {
            return unauthorized();
        }

        chatRepo.save(msg);
        return ResponseEntity.status(HttpStatus.CREATED).body(ok(Map.of("message", chatDto(msg))));
    }

    // ── helpers ──

    static ConsultationType parseConsultationType(String raw) {
        String v = raw == null ? "" : raw.trim().toUpperCase(Locale.ROOT);
        if (v.isBlank()) return ConsultationType.CLINIC;
        if ("HOME".equals(v) || "HOME_VISIT".equals(v)) return ConsultationType.OFFLINE;
        try {
            return ConsultationType.valueOf(v);
        } catch (Exception e) {
            return ConsultationType.CLINIC;
        }
    }

    static LocalDateTime parseAppointmentTime(String raw) {
        if (raw == null || raw.isBlank()) return null;
        String v = raw.trim();
        try {
            return LocalDateTime.parse(v, FMT_SPACE);
        } catch (Exception ignored) {
        }
        try {
            return LocalDateTime.parse(v, FMT_T);
        } catch (Exception ignored) {
        }
        try {
            return LocalDateTime.parse(v);
        } catch (Exception ignored) {
            return null;
        }
    }

    private Map<String, Object> appointmentDto(DoctorAppointment a, User viewer) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", a.getId());
        m.put("status", a.getStatus() == null ? null : a.getStatus().name());
        m.put("appointmentTime", a.getAppointmentTime() == null ? null : a.getAppointmentTime().toString());
        m.put("reason", a.getReason());
        m.put("consultationType", a.getConsultationType() == null ? null : a.getConsultationType().name());
        m.put("meetingRoomId", a.getMeetingRoomId());
        m.put("prescriptionText", a.getPrescriptionText());
        m.put("amountPaid", a.getAmountPaid());
        boolean canCancel = a.getStatus() == DoctorAppointmentStatus.PENDING
                || a.getStatus() == DoctorAppointmentStatus.CONFIRMED;
        m.put("canCancel", canCancel);
        boolean canReview = false;
        if (viewer != null && a.getDoctor() != null && a.getStatus() == DoctorAppointmentStatus.COMPLETED) {
            canReview = !reviewRepo.existsByUserIdAndDoctorId(viewer.getId(), a.getDoctor().getId());
        }
        m.put("canReview", canReview);
        if (a.getDoctor() != null) m.put("doctor", doctorDto(a.getDoctor(), viewer));
        if (a.getUser() != null) {
            m.put("userId", a.getUser().getId());
            m.put("clientName", a.getUser().getFullName());
        }
        return m;
    }

    private Map<String, Object> doctorDto(Doctor d, User viewer) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", d.getId());
        m.put("fullName", d.getFullName());
        m.put("specialization", d.getSpecialization());
        m.put("city", d.getCity());
        m.put("locationText", d.getLocationText() != null && !d.getLocationText().isBlank()
                ? d.getLocationText()
                : (d.getCity() != null ? d.getCity() : "Location not set"));
        m.put("consultationFee", d.getConsultationFee());
        m.put("rating", d.getRating() != null ? d.getRating() : 0.0);
        m.put("profilePhotoPath", d.getProfilePhotoPath());
        m.put("consultationType", d.getConsultationType() == null ? null : d.getConsultationType().name());
        m.put("qualification", d.getQualification());
        m.put("experienceYears", d.getExperienceYears());
        m.put("emergencyAvailable", Boolean.TRUE.equals(d.getEmergencyAvailable()));
        m.put("isOnline", Boolean.TRUE.equals(d.getIsOnline()));
        m.put("lastSeenAt", d.getLastSeenAt() == null ? null : d.getLastSeenAt().toString());
        m.put("instantAvailable", Boolean.TRUE.equals(d.getIsOnline()) && Boolean.TRUE.equals(d.getEmergencyAvailable()));
        m.put("phone", d.getPhone());
        m.put("email", d.getEmail());
        m.put("availableDays", d.getAvailableDays());
        m.put("startTime", d.getStartTime());
        m.put("endTime", d.getEndTime());
        m.put("bio", d.getBio());
        m.put("languages", d.getLanguages());
        m.put("services", d.getServices());
        m.put("reviewCount", reviewRepo.findByDoctorIdOrderByCreatedAtDesc(d.getId()).size());
        if (viewer != null) {
            boolean completed = appointmentRepo.findByUserOrderByAppointmentTimeDesc(viewer).stream()
                    .anyMatch(a -> a.getDoctor() != null
                            && a.getDoctor().getId().equals(d.getId())
                            && a.getStatus() == DoctorAppointmentStatus.COMPLETED);
            m.put("canReview", completed && !reviewRepo.existsByUserIdAndDoctorId(viewer.getId(), d.getId()));
        }
        return m;
    }

    private Map<String, Object> reviewDto(DoctorReview r) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", r.getId());
        m.put("rating", r.getRating());
        m.put("comment", r.getComment());
        m.put("createdAt", r.getCreatedAt() == null ? null : r.getCreatedAt().toString());
        if (r.getUser() != null) m.put("userName", r.getUser().getFullName());
        return m;
    }

    private Map<String, Object> chatDto(DoctorChatMessage msg) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", msg.getId());
        m.put("message", msg.getMessage());
        m.put("senderType", msg.getSenderType());
        m.put("timestamp", msg.getTimestamp() == null ? null : msg.getTimestamp().toString());
        if (msg.getUser() != null) m.put("userId", msg.getUser().getId());
        return m;
    }

    private User requireUser(HttpSession session) {
        Object u = session == null ? null : session.getAttribute("user");
        return u instanceof User ? (User) u : null;
    }

    private Doctor requireDoctor(HttpSession session) {
        Object d = session == null ? null : session.getAttribute("loggedDoctor");
        return d instanceof Doctor ? (Doctor) d : null;
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

    private static String trim(String v) {
        return v == null ? "" : v.trim();
    }
}
