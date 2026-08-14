package in.sp.main.Controller;

import in.sp.main.Entities.*;
import in.sp.main.Repository.*;
import in.sp.main.Service.EnrollmentService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.FileSystemResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;

import java.util.*;
import java.util.stream.Collectors;

/**
 * Extended Martial Arts user APIs for Flutter — training journey, attendance,
 * online classes, certificate download.
 */
@RestController
@RequestMapping("/api/martial-arts")
public class MobileMartialArtsExtrasController {

    @Autowired
    private EnrollmentService enrollmentService;

    @Autowired
    private EnrollmentRepository enrollmentRepository;

    @Autowired
    private AttendanceRepository attendanceRepository;

    @Autowired
    private OnlineClassRepository onlineClassRepository;

    @Autowired
    private OnlineClassEnrollmentRepository onlineClassEnrollmentRepository;

    @Autowired
    private OnlineClassInvitationRepository invitationRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private in.sp.main.Service.MartialArtsCareService martialArtsCareService;

    @GetMapping("/training-journey")
    @Transactional(readOnly = true)
    public ResponseEntity<Map<String, Object>> trainingJourney(HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();

        List<Map<String, Object>> trainings = new ArrayList<>();
        for (Enrollment e : enrollmentService.getUserEnrollments(user.getId())) {
            String pStatus = e.getPaymentStatus();
            if ((pStatus == null || "PENDING".equalsIgnoreCase(pStatus))
                    && e.getAmountPaid() != null && e.getAmountPaid() > 0) {
                pStatus = "PAID";
            }
            if (!"PAID".equalsIgnoreCase(pStatus)) continue;

            Map<String, Object> map = new LinkedHashMap<>();
            map.put("enrollmentId", e.getId());
            map.put("centreId", e.getCenter() != null ? e.getCenter().getId() : null);
            map.put("centreName", e.getCenter() != null ? e.getCenter().getName() : "N/A");

            String trainerName = "N/A";
            if (e.getBatch() != null && e.getBatch().getInstructor() != null) {
                trainerName = e.getBatch().getInstructor();
            } else if (e.getTrainerPreference() != null) {
                trainerName = e.getTrainerPreference();
            }
            map.put("trainerName", trainerName);

            String martialArtType = "N/A";
            if (e.getMartialArtsType() != null) {
                martialArtType = e.getMartialArtsType().getName();
            } else if (e.getBatch() != null) {
                martialArtType = e.getBatch().getStyle();
            }
            map.put("martialArtType", martialArtType);
            map.put("mode", e.getBatch() != null && e.getBatch().getBatchType() != null
                    ? e.getBatch().getBatchType() : "Offline");
            map.put("batchName", e.getBatch() != null ? e.getBatch().getName() : "N/A");
            map.put("slot", e.getBatch() != null ? e.getBatch().getTimeSlot() : "N/A");
            map.put("enrollmentDate", e.getProposedStartDate() != null
                    ? e.getProposedStartDate().toString() : "TBD");
            map.put("status", e.getStatus() != null ? e.getStatus().name() : "PENDING");
            map.put("paymentStatus", pStatus);
            map.put("progress", e.getProgressPercentage() != null ? e.getProgressPercentage() : 0);

            List<Attendance> userAttendances = attendanceRepository.findByUser(user);
            if (e.getBatch() != null) {
                Long batchId = e.getBatch().getId();
                long attendedCount = userAttendances.stream()
                        .filter(a -> a.getStatus() == AttendanceStatus.PRESENT
                                || a.getStatus() == AttendanceStatus.LATE)
                        .filter(a -> (a.getBatch() != null && a.getBatch().getId().equals(batchId))
                                || (a.getSession() != null && a.getSession().getBatch() != null
                                && a.getSession().getBatch().getId().equals(batchId)))
                        .count();
                long totalSessionsHeld = userAttendances.stream()
                        .filter(a -> (a.getBatch() != null && a.getBatch().getId().equals(batchId))
                                || (a.getSession() != null && a.getSession().getBatch() != null
                                && a.getSession().getBatch().getId().equals(batchId)))
                        .count();
                map.put("attendancePercentage", totalSessionsHeld == 0 ? 0
                        : (int) ((attendedCount * 100) / totalSessionsHeld));
            } else {
                map.put("attendancePercentage", 0);
            }

            String cert = e.getCertificateDetails();
            map.put("certificateAvailable", cert != null && !cert.isBlank());
            map.put("certificateUrl", cert != null && !cert.isBlank()
                    ? "/api/martial-arts/enrollments/" + e.getId() + "/certificate" : null);
            trainings.add(map);
        }

        Map<String, Object> body = new LinkedHashMap<>();
        body.put("success", true);
        body.put("trainings", trainings);
        body.put("count", trainings.size());
        return ResponseEntity.ok(body);
    }

    @GetMapping("/my-attendance")
    @Transactional(readOnly = true)
    public ResponseEntity<Map<String, Object>> myAttendance(HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();

        List<Attendance> attendances = attendanceRepository.findByUser(user);
        long total = attendances.size();
        long present = attendances.stream().filter(a -> a.getStatus() == AttendanceStatus.PRESENT).count();
        long absent = attendances.stream().filter(a -> a.getStatus() == AttendanceStatus.ABSENT).count();
        long late = attendances.stream().filter(a -> a.getStatus() == AttendanceStatus.LATE).count();
        double percentage = total == 0 ? 0 : (double) (present + late) / total * 100;

        List<Map<String, Object>> records = attendances.stream().map(a -> {
            Map<String, Object> map = new LinkedHashMap<>();
            if (a.getBatch() != null) {
                map.put("date", a.getAttendanceDate() != null ? a.getAttendanceDate().toString() : "N/A");
                map.put("batchName", a.getBatch().getName());
                map.put("timeSlot", a.getBatch().getTimeSlot());
                map.put("mode", "OFFLINE");
            } else if (a.getOnlineClass() != null) {
                map.put("date", a.getOnlineClass().getDate() != null
                        ? a.getOnlineClass().getDate().toString() : "N/A");
                map.put("batchName", a.getOnlineClass().getTitle());
                map.put("timeSlot", a.getOnlineClass().getStartTime() + " - " + a.getOnlineClass().getEndTime());
                map.put("mode", "ONLINE");
            }
            map.put("status", a.getStatus() != null ? a.getStatus().name() : "UNKNOWN");
            map.put("notes", a.getNotes());
            return map;
        }).collect(Collectors.toList());

        Map<String, Object> body = new LinkedHashMap<>();
        body.put("success", true);
        body.put("totalClasses", total);
        body.put("presentCount", present);
        body.put("absentCount", absent);
        body.put("lateCount", late);
        body.put("attendancePercentage", String.format(Locale.ROOT, "%.1f", percentage));
        body.put("records", records);
        return ResponseEntity.ok(body);
    }

    @GetMapping("/online-classes")
    @Transactional(readOnly = true)
    public ResponseEntity<Map<String, Object>> myOnlineClasses(HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();

        User trainee = userRepository.findById(user.getId()).orElse(user);
        Map<String, List<Map<String, Object>>> sections = new LinkedHashMap<>();
        sections.put("invitations", new ArrayList<>());
        sections.put("upcoming", new ArrayList<>());
        sections.put("live", new ArrayList<>());
        sections.put("completed", new ArrayList<>());

        List<OnlineClassInvitation> invites = invitationRepository
                .findByTraineeAndStatus(trainee, OnlineClassInvitation.InviteStatus.PENDING);
        for (OnlineClassInvitation inv : invites) {
            OnlineClass oc = inv.getOnlineClass();
            if (oc == null) continue;
            Map<String, Object> map = onlineClassMap(oc);
            map.put("invitationId", inv.getId());
            sections.get("invitations").add(map);
        }

        List<OnlineClassEnrollment> enrollments = onlineClassEnrollmentRepository.findByTrainee(trainee);
        for (OnlineClassEnrollment oce : enrollments) {
            if (oce.getStatus() != TrainingStatus.APPROVED
                    && oce.getStatus() != TrainingStatus.IN_PROGRESS
                    && oce.getStatus() != TrainingStatus.PENDING) continue;
            OnlineClass oc = oce.getOnlineClass();
            if (oc == null) continue;
            Map<String, Object> map = onlineClassMap(oc);
            map.put("enrollmentStatus", oce.getStatus() != null ? oce.getStatus().name() : "PENDING");
            if (oc.getStatus() == OnlineClassStatus.LIVE) {
                map.put("meetingLink", oc.getMeetingLink());
                sections.get("live").add(map);
            } else if (oc.getStatus() == OnlineClassStatus.COMPLETED) {
                sections.get("completed").add(map);
            } else {
                sections.get("upcoming").add(map);
            }
        }

        for (Enrollment e : enrollmentRepository.findByUser(trainee)) {
            if (e.getBatch() == null || !"Online".equalsIgnoreCase(e.getBatch().getBatchType())) continue;
            if (e.getStatus() != TrainingStatus.APPROVED
                    && e.getStatus() != TrainingStatus.IN_PROGRESS
                    && e.getStatus() != TrainingStatus.PENDING) continue;
            MartialArtsBatch b = e.getBatch();
            Map<String, Object> map = new LinkedHashMap<>();
            map.put("id", "batch-" + b.getId());
            map.put("title", b.getName());
            map.put("martialArtType", b.getStyle());
            map.put("date", b.getStartDate() != null ? b.getStartDate().toString() : "TBD");
            map.put("startTime", b.getTimeSlot());
            map.put("enrollmentStatus", e.getStatus() != null ? e.getStatus().name() : "PENDING");
            map.put("meetingLink", b.getMeetingLink());
            map.put("classStatus", b.getMeetingLink() != null && !b.getMeetingLink().isBlank()
                    ? "LIVE" : "UPCOMING");
            if (b.getMeetingLink() != null && !b.getMeetingLink().isBlank()) {
                sections.get("live").add(map);
            } else {
                sections.get("upcoming").add(map);
            }
        }

        Map<String, Object> body = new LinkedHashMap<>();
        body.put("success", true);
        body.put("sections", sections);
        return ResponseEntity.ok(body);
    }

    @PostMapping("/online-classes/checkin")
    @Transactional
    public ResponseEntity<Map<String, Object>> onlineCheckIn(
            @RequestBody Map<String, Object> data,
            HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();

        try {
            Long onlineClassId = Long.parseLong(data.get("onlineClassId").toString());
            java.time.LocalDate date = java.time.LocalDate.parse(data.get("date").toString());
            OnlineClass oc = onlineClassRepository.findById(onlineClassId).orElse(null);
            if (oc == null) return badRequest("Online class not found");

            if (oc.getBatch() != null) {
                List<Enrollment> enrollments = enrollmentRepository.findByBatchId(oc.getBatch().getId());
                boolean isEnrolled = enrollments.stream().anyMatch(e ->
                        e.getUser() != null && e.getUser().getId().equals(user.getId())
                                && "PAID".equalsIgnoreCase(e.getPaymentStatus())
                                && (e.getStatus() == TrainingStatus.APPROVED
                                || e.getStatus() == TrainingStatus.IN_PROGRESS));
                if (!isEnrolled) {
                    return ResponseEntity.status(HttpStatus.FORBIDDEN)
                            .body(errorMap("You are not enrolled in this class"));
                }
            }

            List<Attendance> existing = attendanceRepository.findByOnlineClassAndAttendanceDate(oc, date);
            Attendance att = existing.stream()
                    .filter(a -> a.getUser() != null && a.getUser().getId().equals(user.getId()))
                    .findFirst()
                    .orElse(new Attendance());

            att.setUser(user);
            att.setOnlineClass(oc);
            att.setAttendanceDate(date);
            att.setStatus(AttendanceStatus.PRESENT);
            att.setMode("ONLINE");
            if (oc.getCenter() != null) att.setCenter(oc.getCenter());
            attendanceRepository.save(att);

            Map<String, Object> body = new LinkedHashMap<>();
            body.put("success", true);
            body.put("message", "Checked in successfully!");
            return ResponseEntity.ok(body);
        } catch (Exception ex) {
            return badRequest("Check-in failed: " + ex.getMessage());
        }
    }

    @PostMapping("/online-classes/invitation/respond")
    @Transactional
    public ResponseEntity<Map<String, Object>> respondInvitation(
            @RequestBody Map<String, Object> payload,
            HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();

        Long invitationId = Long.valueOf(payload.get("invitationId").toString());
        String action = payload.get("action").toString();
        OnlineClassInvitation inv = invitationRepository.findById(invitationId).orElse(null);
        if (inv == null) return badRequest("Invitation not found");
        if (inv.getTrainee() == null || !inv.getTrainee().getId().equals(user.getId())) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(errorMap("Not your invitation"));
        }

        if ("ACCEPT".equalsIgnoreCase(action)) {
            inv.setStatus(OnlineClassInvitation.InviteStatus.ACCEPTED);
            OnlineClassEnrollment oce = onlineClassEnrollmentRepository
                    .findFirstByTraineeAndOnlineClassOrderByIdDesc(user, inv.getOnlineClass())
                    .orElse(new OnlineClassEnrollment());
            oce.setTrainee(user);
            oce.setOnlineClass(inv.getOnlineClass());
            oce.setStatus(TrainingStatus.APPROVED);
            onlineClassEnrollmentRepository.save(oce);
        } else {
            inv.setStatus(OnlineClassInvitation.InviteStatus.REJECTED);
        }
        invitationRepository.save(inv);

        Map<String, Object> body = new LinkedHashMap<>();
        body.put("success", true);
        body.put("message", "Response saved");
        return ResponseEntity.ok(body);
    }

    @GetMapping("/enrollments/{enrollmentId}/certificate")
    public ResponseEntity<FileSystemResource> downloadCertificate(
            @PathVariable Long enrollmentId,
            HttpSession session) {
        User user = requireUser(session);
        if (user == null) return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();

        Enrollment enrollment = enrollmentRepository.findById(enrollmentId).orElse(null);
        if (enrollment == null) return ResponseEntity.notFound().build();
        if (enrollment.getUser() == null || !enrollment.getUser().getId().equals(user.getId())) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
        }
        String certificatePath = enrollment.getCertificateDetails();
        if (certificatePath == null || certificatePath.isBlank()) {
            return ResponseEntity.notFound().build();
        }
        FileSystemResource resource = new FileSystemResource(certificatePath);
        if (!resource.exists()) return ResponseEntity.notFound().build();

        HttpHeaders headers = new HttpHeaders();
        headers.add(HttpHeaders.CONTENT_DISPOSITION,
                "attachment; filename=" + resource.getFilename());
        headers.add(HttpHeaders.CONTENT_TYPE, MediaType.APPLICATION_OCTET_STREAM_VALUE);
        return ResponseEntity.ok().headers(headers).body(resource);
    }

    private Map<String, Object> onlineClassMap(OnlineClass oc) {
        Map<String, Object> map = new LinkedHashMap<>();
        map.put("id", oc.getId());
        map.put("title", oc.getTitle());
        map.put("martialArtType", oc.getMartialArtType());
        map.put("date", oc.getDate() != null ? oc.getDate().toString() : "TBD");
        map.put("startTime", oc.getStartTime());
        map.put("endTime", oc.getEndTime());
        map.put("classStatus", oc.getStatus() != null ? oc.getStatus().name() : "UPCOMING");
        map.put("recordingLink", oc.getRecordingLink());
        map.put("centerName", oc.getCenter() != null ? oc.getCenter().getName() : "Dojo");
        boolean canJoin = martialArtsCareService.canJoin(oc);
        map.put("canJoin", canJoin);
        map.put("joinHint", martialArtsCareService.joinWindowHint(oc));
        if (canJoin) {
            map.put("meetingLink", oc.getMeetingLink());
        }
        return map;
    }

    private User requireUser(HttpSession session) {
        if (session == null) return null;
        Object u = session.getAttribute("user");
        return u instanceof User ? (User) u : null;
    }

    private ResponseEntity<Map<String, Object>> unauthorized() {
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(errorMap("Login required"));
    }

    private ResponseEntity<Map<String, Object>> badRequest(String error) {
        return ResponseEntity.badRequest().body(errorMap(error));
    }

    private static Map<String, Object> errorMap(String error) {
        Map<String, Object> body = new LinkedHashMap<>();
        body.put("success", false);
        body.put("error", error);
        return body;
    }
}
