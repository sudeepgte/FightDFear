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
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

@RestController
@RequestMapping("/api/doctors")
public class MobileDoctorController {

    private static final DateTimeFormatter FMT_SPACE = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
    private static final DateTimeFormatter FMT_T = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");
    private static final ObjectMapper MAPPER = new ObjectMapper();

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
    @Autowired
    private in.sp.main.Service.DoctorPaymentService doctorPaymentService;
    @Autowired
    private in.sp.main.Service.DoctorInstantConsultService instantConsultService;
    @Autowired
    private in.sp.main.Service.PushNotificationService pushNotificationService;
    @Autowired
    private in.sp.main.Service.DoctorCareService doctorCareService;
    @Autowired
    private in.sp.main.Service.FileUploadService fileUploadService;
    @Autowired
    private in.sp.main.Repository.DoctorInstantRequestRepository instantRequestRepository;

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
            @RequestParam(required = false) String language,
            @RequestParam(required = false) String sort,
            @RequestParam(required = false, defaultValue = "0") int page,
            @RequestParam(required = false, defaultValue = "50") int size,
            HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        String qLower = q == null ? "" : q.trim().toLowerCase(Locale.ROOT);
        String cityLower = city == null ? "" : city.trim().toLowerCase(Locale.ROOT);
        String specLower = specialization == null ? "" : specialization.trim().toLowerCase(Locale.ROOT);
        String langLower = language == null ? "" : language.trim().toLowerCase(Locale.ROOT);
        String sortKey = sort == null ? "rating" : sort.trim().toLowerCase(Locale.ROOT);
        int safePage = Math.max(0, page);
        int safeSize = Math.min(50, Math.max(1, size));

        List<Doctor> filtered = doctorRepo.findByVerificationStatus(VerificationStatus.VERIFIED).stream()
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
                    if (!langLower.isEmpty()) {
                        String langs = (d.getLanguages() == null ? "" : d.getLanguages()).toLowerCase(Locale.ROOT);
                        if (!langs.contains(langLower)) return false;
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
                .sorted((a, b) -> {
                    if ("fee".equals(sortKey)) {
                        double fa = a.getConsultationFee() == null ? 0 : a.getConsultationFee();
                        double fb = b.getConsultationFee() == null ? 0 : b.getConsultationFee();
                        return Double.compare(fa, fb);
                    }
                    if ("experience".equals(sortKey)) {
                        int ea = a.getExperienceYears() == null ? 0 : a.getExperienceYears();
                        int eb = b.getExperienceYears() == null ? 0 : b.getExperienceYears();
                        return Integer.compare(eb, ea);
                    }
                    double ra = a.getRating() == null ? 0 : a.getRating();
                    double rb = b.getRating() == null ? 0 : b.getRating();
                    return Double.compare(rb, ra);
                })
                .toList();
        int total = filtered.size();
        int from = Math.min(safePage * safeSize, total);
        int to = Math.min(from + safeSize, total);
        List<Map<String, Object>> items = filtered.subList(from, to).stream()
                .map(d -> doctorDto(d, user))
                .toList();
        Map<String, Object> payload = new LinkedHashMap<>();
        payload.put("doctors", items);
        payload.put("count", items.size());
        payload.put("total", total);
        payload.put("page", safePage);
        payload.put("size", safeSize);
        payload.put("hasMore", to < total);
        return ResponseEntity.ok(ok(payload));
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
            Long followUpOf = null;
            if (body != null && body.get("followUpOfId") != null && !body.get("followUpOfId").isBlank()) {
                try {
                    followUpOf = Long.parseLong(body.get("followUpOfId").trim());
                } catch (Exception ignored) {
                }
            }
            DoctorAppointment appt = bookingService.createRequestBooking(d, user, apptTime, cType, reason, false, followUpOf);
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
            Map<String, Object> data = new LinkedHashMap<>();
            data.put("message", "Appointment cancelled");
            data.put("status", a.getStatus().name());
            data.put("paymentStatus", a.getPaymentStatus());
            data.put("refundId", a.getRefundId());
            data.put("refundAmount", a.getRefundAmount());
            return ResponseEntity.ok(ok(data));
        } catch (org.springframework.web.server.ResponseStatusException ex) {
            return ResponseEntity.status(ex.getStatusCode())
                    .body(Map.of("success", false, "error", ex.getReason() == null ? "Cancel failed" : ex.getReason()));
        }
    }

    @PostMapping("/appointments/{id}/reschedule")
    @Transactional
    public ResponseEntity<Map<String, Object>> rescheduleAppointment(
            @PathVariable Long id,
            @RequestBody Map<String, String> body,
            HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        DoctorAppointment a = appointmentRepo.findById(id).orElse(null);
        LocalDateTime newTime = parseAppointmentTime(body == null ? null : body.get("appointmentTime"));
        if (newTime == null) return badRequest("appointmentTime is required");
        try {
            a = appointmentService.rescheduleByPatient(a, user, newTime, bookingService);
            Map<String, Object> data = new LinkedHashMap<>();
            data.put("message", "Appointment rescheduled");
            data.put("appointmentId", a.getId());
            data.put("appointmentTime", a.getAppointmentTime().toString());
            data.put("status", a.getStatus().name());
            return ResponseEntity.ok(ok(data));
        } catch (org.springframework.web.server.ResponseStatusException ex) {
            return ResponseEntity.status(ex.getStatusCode())
                    .body(Map.of("success", false, "error", ex.getReason() == null ? "Reschedule failed" : ex.getReason()));
        }
    }

    @GetMapping("/appointments/{id}/receipt")
    public ResponseEntity<Map<String, Object>> appointmentReceipt(@PathVariable Long id, HttpSession session) {
        User user = requireUser(session);
        Doctor doctor = requireDoctor(session);
        if (user == null && doctor == null) return unauthorized();
        DoctorAppointment a = appointmentRepo.findById(id).orElse(null);
        if (a == null) return badRequest("Appointment not found");
        boolean okAccess = (user != null && a.getUser() != null && a.getUser().getId().equals(user.getId()))
                || (doctor != null && a.getDoctor() != null && a.getDoctor().getId().equals(doctor.getId()));
        if (!okAccess) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(Map.of("success", false, "error", "Access denied"));
        }
        return ResponseEntity.ok(ok(Map.of("receipt", doctorPaymentService.receiptPayload(a))));
    }

    @PostMapping("/instant/request")
    @Transactional
    public ResponseEntity<Map<String, Object>> instantRequest(@RequestBody Map<String, String> body, HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        try {
            Map<String, Object> result = instantConsultService.requestInstant(
                    user,
                    body == null ? null : body.get("consultationType"),
                    body == null ? null : body.get("reason"));
            return ResponseEntity.ok(ok(result));
        } catch (org.springframework.web.server.ResponseStatusException ex) {
            return ResponseEntity.status(ex.getStatusCode())
                    .body(Map.of("success", false, "error", ex.getReason() == null ? "Instant consult unavailable" : ex.getReason()));
        }
    }

    @GetMapping("/instant/mine")
    public ResponseEntity<Map<String, Object>> myInstant(HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        List<Map<String, Object>> items = instantRequestRepository.findAll().stream()
                .filter(r -> user.getId().equals(r.getUserId()))
                .sorted((a, b) -> b.getCreatedAt().compareTo(a.getCreatedAt()))
                .limit(5)
                .map(r -> {
                    Map<String, Object> m = new LinkedHashMap<>();
                    m.put("requestId", r.getId());
                    m.put("status", r.getStatus());
                    m.put("doctorId", r.getDoctorId());
                    m.put("appointmentId", r.getAppointmentId());
                    m.put("expiresAt", r.getExpiresAt() == null ? null : r.getExpiresAt().toString());
                    m.put("consultationType", r.getConsultationType());
                    if (r.getDoctorId() != null) {
                        doctorRepo.findById(r.getDoctorId()).ifPresent(doc -> {
                            m.put("doctorName", doc.getFullName());
                            m.put("fee", doc.getVideoFee() != null ? doc.getVideoFee() : doc.getConsultationFee());
                        });
                    }
                    return m;
                })
                .toList();
        return ResponseEntity.ok(ok(Map.of("requests", items)));
    }

    @PostMapping("/favorites/{doctorId}")
    @Transactional
    public ResponseEntity<Map<String, Object>> addFavorite(@PathVariable Long doctorId, HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        doctorCareService.addFavorite(user.getId(), doctorId);
        return ResponseEntity.ok(ok(Map.of("favourite", true)));
    }

    @DeleteMapping("/favorites/{doctorId}")
    @Transactional
    public ResponseEntity<Map<String, Object>> removeFavorite(@PathVariable Long doctorId, HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        doctorCareService.removeFavorite(user.getId(), doctorId);
        return ResponseEntity.ok(ok(Map.of("favourite", false)));
    }

    @GetMapping("/appointments/{id}/prescription.pdf")
    public ResponseEntity<byte[]> prescriptionPdf(@PathVariable Long id, HttpSession session) {
        User user = requireUser(session);
        Doctor doctor = requireDoctor(session);
        if (user == null && doctor == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }
        DoctorAppointment a = appointmentRepo.findById(id).orElse(null);
        if (a == null) return ResponseEntity.notFound().build();
        boolean okUser = user != null && a.getUser() != null && a.getUser().getId().equals(user.getId());
        boolean okDoc = doctor != null && a.getDoctor() != null && a.getDoctor().getId().equals(doctor.getId());
        if (!okUser && !okDoc) return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
        byte[] pdf = doctorCareService.prescriptionPdf(a);
        return ResponseEntity.ok()
                .header("Content-Disposition", "attachment; filename=prescription-" + id + ".pdf")
                .contentType(org.springframework.http.MediaType.APPLICATION_PDF)
                .body(pdf);
    }

    @PostMapping("/appointments/{id}/reports")
    @Transactional
    public ResponseEntity<Map<String, Object>> uploadReport(
            @PathVariable Long id,
            @RequestParam("file") org.springframework.web.multipart.MultipartFile file,
            HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        DoctorAppointment a = appointmentRepo.findById(id).orElse(null);
        if (a == null || a.getUser() == null || !a.getUser().getId().equals(user.getId())) {
            return badRequest("Appointment not found");
        }
        try {
            String path = fileUploadService.saveFile(file);
            String existing = a.getReportPaths() == null ? "" : a.getReportPaths();
            a.setReportPaths(existing.isBlank() ? path : existing + "," + path);
            appointmentRepo.save(a);
            return ResponseEntity.ok(ok(Map.of("reportPaths", a.getReportPaths(), "path", path)));
        } catch (Exception ex) {
            return badRequest("Upload failed");
        }
    }

    @PostMapping("/device-token")
    public ResponseEntity<Map<String, Object>> registerDeviceToken(@RequestBody Map<String, String> body, HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        pushNotificationService.registerUserToken(
                user.getId(),
                body == null ? null : body.get("token"),
                body == null ? null : body.get("platform"));
        return ResponseEntity.ok(ok(Map.of("message", "Device token registered")));
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
        if (room == null || room.isBlank() || room.startsWith("safeher-")) {
            room = doctorPaymentService.generatePrivateRoomId(a.getId());
            a.setMeetingRoomId(room);
            if (a.getMeetingPassword() == null || a.getMeetingPassword().isBlank()) {
                a.setMeetingPassword(doctorPaymentService.generateMeetingPassword());
            }
            appointmentRepo.save(a);
        }

        Map<String, Object> data = new LinkedHashMap<>();
        data.put("roomName", room);
        data.put("meetingRoomId", room);
        data.put("meetingPassword", a.getMeetingPassword());
        data.put("displayName", displayName);
        data.put("audioOnly", audioOnly);
        data.put("jitsiUrl", "https://meet.jit.si/" + room.replace(" ", ""));
        data.put("status", a.getStatus().name());
        data.put("note", "Appointment-scoped room with password. Prefer a private SFU for production.");
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
        String attachment = body == null || body.get("attachmentPath") == null
                ? ""
                : String.valueOf(body.get("attachmentPath")).trim();
        if (message.isBlank() && attachment.isBlank()) return badRequest("Message is required");
        if (message.isBlank()) message = "📎 Attachment";

        DoctorChatMessage msg = new DoctorChatMessage();
        msg.setDoctor(target);
        msg.setMessage(message);
        if (!attachment.isBlank()) {
            msg.setAttachmentPath(attachment);
        }

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

    @PostMapping("/{id}/chat-file")
    @Transactional
    public ResponseEntity<Map<String, Object>> chatFile(
            @PathVariable Long id,
            @RequestParam("file") org.springframework.web.multipart.MultipartFile file,
            @RequestParam(value = "userId", required = false) Long userId,
            HttpSession session) {
        User user = requireUser(session);
        Doctor doctor = requireDoctor(session);
        Doctor target = doctorRepo.findById(id).orElse(null);
        if (target == null) return badRequest("Doctor not found");
        try {
            String path = fileUploadService.saveFile(file);
            Map<String, Object> body = new LinkedHashMap<>();
            body.put("message", "📎 " + (file.getOriginalFilename() == null ? "Attachment" : file.getOriginalFilename()));
            body.put("attachmentPath", path);
            if (userId != null) body.put("userId", userId);
            return sendChat(id, body, session);
        } catch (Exception ex) {
            return badRequest("Upload failed");
        }
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
        m.put("meetingPassword", a.getMeetingPassword());
        m.put("prescriptionText", a.getPrescriptionText());
        m.put("prescriptionJson", a.getPrescriptionJson());
        m.put("doctorNotes", a.getDoctorNotes());
        m.put("reportPaths", a.getReportPaths());
        m.put("followUpOfId", a.getFollowUpOfId());
        m.put("canJoin", appointmentService.canJoinVideo(a));
        boolean freeCancel = a.getAppointmentTime() == null
                || a.getAppointmentTime().isAfter(java.time.LocalDateTime.now().plusHours(2));
        m.put("freeCancellation", freeCancel);
        m.put("cancelPolicy", "Free cancellation until 2 hours before the appointment. After that, the fee is not refunded.");
        m.put("canFollowUp", a.getStatus() == DoctorAppointmentStatus.COMPLETED);
        m.put("amountPaid", a.getAmountPaid());
        m.put("paymentStatus", a.getPaymentStatus());
        m.put("receiptNumber", a.getReceiptNumber());
        m.put("refundId", a.getRefundId());
        m.put("refundAmount", a.getRefundAmount());
        m.put("platformFee", a.getPlatformFee());
        m.put("doctorEarning", a.getDoctorEarning());
        m.put("rescheduledFrom", a.getRescheduledFrom() == null ? null : a.getRescheduledFrom().toString());
        boolean canCancel = a.getStatus() == DoctorAppointmentStatus.PENDING
                || a.getStatus() == DoctorAppointmentStatus.CONFIRMED;
        m.put("canCancel", canCancel);
        boolean canReschedule = canCancel;
        m.put("canReschedule", canReschedule);
        boolean needsPayment = "PENDING_PAYMENT".equalsIgnoreCase(a.getPaymentStatus())
                || (a.getAmountPaid() == null && canCancel && a.getDoctor() != null);
        // Only flag needsPayment when explicitly pending payment (instant hold)
        needsPayment = "PENDING_PAYMENT".equalsIgnoreCase(a.getPaymentStatus());
        m.put("needsPayment", needsPayment);
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
        m.put("chatFee", d.getChatFee());
        m.put("callFee", d.getCallFee());
        m.put("videoFee", d.getVideoFee());
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
        m.put("availabilitySlots", parseAvailabilitySlotsSafe(d.getAvailabilitySlots()));
        m.put("consultationModes", splitModes(d.getConsultationModes()));
        m.put("hospitalName", d.getHospitalName());
        m.put("clinicAddress", d.getClinicAddress());
        m.put("state", d.getState());
        m.put("pincode", d.getPincode());
        m.put("googleMapLocation", d.getGoogleMapLocation());
        m.put("slotDurationMinutes", d.getSlotDurationMinutes() == null ? 30 : d.getSlotDurationMinutes());
        m.put("bufferMinutes", d.getBufferMinutes() == null ? 0 : d.getBufferMinutes());
        m.put("breakStart", d.getBreakStart());
        m.put("breakEnd", d.getBreakEnd());
        m.put("blockedDates", d.getBlockedDates());
        m.put("clinicPhotos", d.getClinicPhotos());
        m.put("clinicLat", d.getClinicLat());
        m.put("clinicLng", d.getClinicLng());
        m.put("languages", d.getLanguages());
        m.put("autoConfirm", Boolean.TRUE.equals(d.getAutoConfirm()));
        if (viewer != null) {
            m.put("favourite", doctorCareService.isFavorite(viewer.getId(), d.getId()));
        }
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
        m.put("attachmentPath", msg.getAttachmentPath());
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

    private static List<String> splitModes(String raw) {
        if (raw == null || raw.isBlank()) {
            return List.of();
        }
        List<String> out = new ArrayList<>();
        for (String part : raw.split("[,|]")) {
            String m = part.trim().toUpperCase(Locale.ROOT);
            if (!m.isEmpty()) {
                out.add(m);
            }
        }
        return out;
    }

    private static List<Map<String, String>> parseAvailabilitySlotsSafe(String raw) {
        if (raw == null || raw.isBlank()) {
            return List.of();
        }
        try {
            List<Map<String, String>> slots = MAPPER.readValue(raw, new TypeReference<List<Map<String, String>>>() {});
            return slots == null ? List.of() : slots;
        } catch (Exception ex) {
            return List.of();
        }
    }
}
