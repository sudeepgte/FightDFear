package in.sp.main.Controller;

import in.sp.main.Entities.*;
import in.sp.main.Repository.*;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/online-class")
public class OnlineClassController {

    @Autowired
    private OnlineClassRepository onlineClassRepository;

    @Autowired
    private AttendanceRepository attendanceRepository;

    @Autowired
    private EnrollmentRepository enrollmentRepository;

    @Autowired
    private MartialArtsBatchRepository batchRepository;

    @Autowired
    private OnlineClassEnrollmentRepository onlineClassEnrollmentRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private OnlineClassInvitationRepository invitationRepository;

    // --- VIEW MAPPINGS ---

    @GetMapping("/management")
    public String showManagementPage(Model model, HttpSession session) {
        User user = (User) session.getAttribute("user");
        MartialArtsCenter center = (MartialArtsCenter) session.getAttribute("loggedCentre");
        
        if (user == null && center == null) return "redirect:/login";

        List<OnlineClass> classes;
        List<MartialArtsBatch> batches;

        if (center != null) {
            classes = onlineClassRepository.findByCenter_Id(center.getId());
            batches = batchRepository.findByCenterId(center.getId());
        } else {
            classes = onlineClassRepository.findByTrainer(user);
            // Fallback for independent trainers if needed
            batches = batchRepository.findAll(); 
        }
        
        model.addAttribute("classes", classes);
        model.addAttribute("batches", batches);
        return "onlineClassManagement";
    }

    // --- TRAINER ACTIONS ---

    @PostMapping("/create")
    @ResponseBody
    public ResponseEntity<?> createClass(@RequestBody Map<String, Object> payload, HttpSession session) {
        User user = (User) session.getAttribute("user");
        MartialArtsCenter center = (MartialArtsCenter) session.getAttribute("loggedCentre");
        
        if (user == null && center == null) return ResponseEntity.status(401).body(Map.of("message", "Unauthorized"));

        try {
            OnlineClass oc = new OnlineClass();
            oc.setTitle((String) payload.get("title"));
            oc.setMartialArtType((String) payload.get("martialArtType"));
            oc.setDate(LocalDate.parse((String) payload.get("date")));
            oc.setStartTime((String) payload.get("startTime"));
            oc.setEndTime((String) payload.get("endTime"));
            oc.setMeetingLink((String) payload.get("meetingLink"));
            oc.setMaxStudents(Integer.parseInt(payload.get("maxStudents").toString()));
            oc.setDescription((String) payload.get("description"));
            oc.setStatus(OnlineClassStatus.UPCOMING);
            oc.setSessionType((String) payload.get("sessionType"));
            oc.setNotes((String) payload.get("notes"));
            
            if (center != null) oc.setCenter(center);
            else oc.setTrainer(user);

            Long batchId = Long.parseLong(payload.get("batchId").toString());
            MartialArtsBatch batch = batchRepository.findById(batchId).orElse(null);
            oc.setBatch(batch);

            onlineClassRepository.save(oc);

            // Auto-enroll trainees from batch
            if (batch != null) {
                List<Enrollment> batchEnrollments = enrollmentRepository.findByBatch(batch);
                for (Enrollment be : batchEnrollments) {
                    OnlineClassEnrollment oce = new OnlineClassEnrollment();
                    oce.setTrainee(be.getUser());
                    oce.setOnlineClass(oc);
                    // Initial status same as batch status
                    oce.setStatus(be.getStatus());
                    onlineClassEnrollmentRepository.save(oce);
                }
            }

            return ResponseEntity.ok(Map.of("message", "Class created and trainees enrolled successfully"));
        } catch (Exception e) {
            return ResponseEntity.status(500).body(Map.of("message", "Error: " + e.getMessage()));
        }
    }

    @PostMapping("/start/{id}")
    @ResponseBody
    public ResponseEntity<?> startClass(@PathVariable Long id, HttpSession session) {
        OnlineClass oc = onlineClassRepository.findById(id).orElse(null);
        if (oc == null) return ResponseEntity.status(404).body(Map.of("message", "Not found"));

        oc.setStatus(OnlineClassStatus.LIVE);
        onlineClassRepository.save(oc);
        return ResponseEntity.ok(Map.of("meetingLink", oc.getMeetingLink()));
    }

    @PostMapping("/end/{id}")
    @ResponseBody
    public ResponseEntity<?> endClass(@PathVariable Long id, HttpSession session) {
        OnlineClass oc = onlineClassRepository.findById(id).orElse(null);
        if (oc == null) return ResponseEntity.status(404).body(Map.of("message", "Not found"));

        oc.setStatus(OnlineClassStatus.COMPLETED);
        onlineClassRepository.save(oc);

        // Mark absent for approved trainees who didn't join
        List<OnlineClassEnrollment> enrollments = onlineClassEnrollmentRepository.findByOnlineClass(oc);
        List<Attendance> attendances = attendanceRepository.findByOnlineClass(oc);
        Set<Long> joinedUserIds = attendances.stream().map(a -> a.getUser().getId()).collect(Collectors.toSet());

        for (OnlineClassEnrollment e : enrollments) {
            if (e.getStatus() == TrainingStatus.APPROVED || e.getStatus() == TrainingStatus.IN_PROGRESS) {
                if (!joinedUserIds.contains(e.getTrainee().getId())) {
                    Attendance absent = new Attendance();
                    absent.setUser(e.getTrainee());
                    absent.setOnlineClass(oc);
                    absent.setCenter(oc.getCenter());
                    absent.setAttendanceDate(oc.getDate());
                    absent.setMode("ONLINE");
                    absent.setStatus(AttendanceStatus.ABSENT);
                    absent.setNotes("Auto-marked ABSENT: Did not join live session.");
                    attendanceRepository.save(absent);
                }
            }
        }

        return ResponseEntity.ok(Map.of("message", "Class ended. Attendance finalized."));
    }

    @DeleteMapping("/delete/{id}")
    @ResponseBody
    public ResponseEntity<?> deleteClass(@PathVariable Long id, HttpSession session) {
        User user = (User) session.getAttribute("user");
        MartialArtsCenter center = (MartialArtsCenter) session.getAttribute("loggedCentre");
        if (user == null && center == null) return ResponseEntity.status(401).body(Map.of("message", "Unauthorized"));

        OnlineClass oc = onlineClassRepository.findById(id).orElse(null);
        if (oc == null) return ResponseEntity.status(404).body(Map.of("message", "Class not found"));

        // Ownership check
        if (center != null && (oc.getCenter() == null || !oc.getCenter().getId().equals(center.getId()))) {
            return ResponseEntity.status(403).body(Map.of("message", "Forbidden: You do not own this class."));
        }
        if (user != null && (oc.getTrainer() == null || !oc.getTrainer().getId().equals(user.getId()))) {
            return ResponseEntity.status(403).body(Map.of("message", "Forbidden: You do not own this class."));
        }

        onlineClassRepository.deleteById(id);
        return ResponseEntity.ok(Map.of("message", "Class deleted successfully"));
    }

    @PostMapping("/upload-recording/{id}")
    @ResponseBody
    public ResponseEntity<?> uploadRecording(@PathVariable Long id, @RequestBody Map<String, String> payload) {
        OnlineClass oc = onlineClassRepository.findById(id).orElse(null);
        if (oc == null) return ResponseEntity.status(404).body(Map.of("message", "Not found"));

        oc.setRecordingLink(payload.get("recordingLink"));
        onlineClassRepository.save(oc);
        return ResponseEntity.ok(Map.of("message", "Recording link updated."));
    }

    // --- TRAINEE ACTIONS ---

    @Transactional(readOnly = true)
    @GetMapping("/my-classes")
    @ResponseBody
    public ResponseEntity<?> getMyOnlineClasses(HttpSession session) {
        User sessionUser = (User) session.getAttribute("user");
        if (sessionUser == null) return ResponseEntity.status(401).body(Map.of("message", "Unauthorized"));

        User trainee = userRepository.findById(sessionUser.getId()).orElse(null);
        if (trainee == null) return ResponseEntity.status(401).body(Map.of("message", "User session invalid"));

        Map<String, List<Map<String, Object>>> sections = new HashMap<>();
        sections.put("invitations", new ArrayList<>());
        sections.put("upcoming", new ArrayList<>());
        sections.put("live", new ArrayList<>());
        sections.put("completed", new ArrayList<>());

        // 1. Invitations (Pending)
        List<OnlineClassInvitation> invites = invitationRepository.findByTraineeAndStatus(trainee, OnlineClassInvitation.InviteStatus.PENDING);
        for (OnlineClassInvitation inv : invites) {
            OnlineClass oc = inv.getOnlineClass();
            if (oc == null) continue;

            Map<String, Object> map = new HashMap<>();
            map.put("invitationId", inv.getId());
            map.put("id", oc.getId());
            map.put("title", oc.getTitle());
            map.put("trainerName", inv.getTrainer() != null ? inv.getTrainer().getFullName() : "Trainer");
            map.put("centerName", oc.getCenter() != null ? oc.getCenter().getName() : "Dojo");
            map.put("date", oc.getDate() != null ? oc.getDate().toString() : "TBD");
            map.put("startTime", oc.getStartTime());
            map.put("endTime", oc.getEndTime());
            sections.get("invitations").add(map);
        }

        // 2 & 3. Upcoming and Live (Accepted/Approved)
        List<OnlineClassEnrollment> enrollments = onlineClassEnrollmentRepository.findByTrainee(trainee);
        for (OnlineClassEnrollment oce : enrollments) {
            // Show APPROVED, IN_PROGRESS, or PENDING
            if (oce.getStatus() != TrainingStatus.APPROVED && oce.getStatus() != TrainingStatus.IN_PROGRESS && oce.getStatus() != TrainingStatus.PENDING) continue;

            OnlineClass oc = oce.getOnlineClass();
            if (oc == null) continue;
            
            Map<String, Object> map = new HashMap<>();
            map.put("id", oc.getId());
            map.put("title", oc.getTitle());
            map.put("martialArtType", oc.getMartialArtType());
            map.put("date", oc.getDate() != null ? oc.getDate().toString() : "TBD");
            map.put("startTime", oc.getStartTime());
            map.put("endTime", oc.getEndTime());
            map.put("classStatus", oc.getStatus() != null ? oc.getStatus().name() : "UPCOMING");
            map.put("enrollmentStatus", oce.getStatus() != null ? oce.getStatus().name() : "PENDING");
            map.put("recordingLink", oc.getRecordingLink());

            if (oc.getStatus() == OnlineClassStatus.LIVE) {
                map.put("meetingLink", oc.getMeetingLink());
                sections.get("live").add(map);
            } else if (oc.getStatus() == OnlineClassStatus.COMPLETED) {
                sections.get("completed").add(map);
            } else {
                sections.get("upcoming").add(map);
            }
        }

        // 4. Physical Enrollments with Online Batches
        List<Enrollment> physicalEnrollments = enrollmentRepository.findByUser(trainee);
        for (Enrollment e : physicalEnrollments) {
            if (e.getBatch() != null && "Online".equalsIgnoreCase(e.getBatch().getBatchType())) {
                // Include PENDING batches as well
                if (e.getStatus() != TrainingStatus.APPROVED && e.getStatus() != TrainingStatus.IN_PROGRESS && e.getStatus() != TrainingStatus.PENDING) continue;

                MartialArtsBatch b = e.getBatch();
                Map<String, Object> map = new HashMap<>();
                map.put("id", "batch-" + b.getId());
                map.put("title", b.getName());
                map.put("martialArtType", b.getStyle());
                map.put("date", b.getStartDate() != null ? b.getStartDate().toString() : "TBD");
                map.put("startTime", b.getTimeSlot());
                map.put("enrollmentStatus", e.getStatus() != null ? e.getStatus().name() : "PENDING");
                map.put("meetingLink", b.getMeetingLink());
                
                // For now, these go to upcoming unless we have a way to check 'live' status for batches
                // But we can check if it has a meeting link
                if (b.getMeetingLink() != null && !b.getMeetingLink().isEmpty()) {
                    sections.get("live").add(map);
                } else {
                    sections.get("upcoming").add(map);
                }
            }
        }

        return ResponseEntity.ok(sections);
    }

    @Transactional
    @PostMapping("/invitation/respond")
    @ResponseBody
    public ResponseEntity<?> respondToInvitation(@RequestBody Map<String, Object> payload, HttpSession session) {
        Long invitationId = Long.valueOf(payload.get("invitationId").toString());
        String action = payload.get("action").toString(); // ACCEPT or REJECT

        OnlineClassInvitation inv = invitationRepository.findById(invitationId).orElse(null);
        if (inv == null) return ResponseEntity.status(404).body(Map.of("message", "Invitation not found"));

        if ("ACCEPT".equalsIgnoreCase(action)) {
            inv.setStatus(OnlineClassInvitation.InviteStatus.ACCEPTED);
            
            // Create OnlineClassEnrollment if not exists
            OnlineClassEnrollment oce = onlineClassEnrollmentRepository.findFirstByTraineeAndOnlineClassOrderByIdDesc(inv.getTrainee(), inv.getOnlineClass())
                    .orElse(new OnlineClassEnrollment());
            oce.setTrainee(inv.getTrainee());
            oce.setOnlineClass(inv.getOnlineClass());
            oce.setStatus(TrainingStatus.APPROVED);
            onlineClassEnrollmentRepository.save(oce);
        } else {
            inv.setStatus(OnlineClassInvitation.InviteStatus.REJECTED);
        }
        
        invitationRepository.save(inv);
        return ResponseEntity.ok(Map.of("message", "Response saved successfully"));
    }

    @Transactional
    @PostMapping("/{id}/update-status")
    @ResponseBody
    public ResponseEntity<?> updateStatus(@PathVariable Long id, @RequestParam OnlineClassStatus status, HttpSession session) {
        User user = (User) session.getAttribute("user");
        MartialArtsCenter center = (MartialArtsCenter) session.getAttribute("loggedCentre");
        if (user == null && center == null) return ResponseEntity.status(401).body(Map.of("message", "Unauthorized"));

        OnlineClass oc = onlineClassRepository.findById(id).orElse(null);
        if (oc == null) return ResponseEntity.status(404).body(Map.of("message", "Class not found"));

        oc.setStatus(status);
        onlineClassRepository.save(oc);
        return ResponseEntity.ok(Map.of("message", "Class status updated to " + status));
    }

    @Transactional(readOnly = true)
    @GetMapping("/{id}/joined-trainees")
    @ResponseBody
    public ResponseEntity<?> getJoinedTrainees(@PathVariable Long id, HttpSession session) {
        // Find attendance records for this class
        OnlineClass oc = onlineClassRepository.findById(id).orElse(null);
        if (oc == null) return ResponseEntity.status(404).body(Map.of("message", "Class not found"));

        List<Attendance> attendanceList = attendanceRepository.findByOnlineClass(oc);
        List<Map<String, Object>> result = attendanceList.stream().map(a -> {
            Map<String, Object> map = new HashMap<>();
            map.put("traineeId", a.getUser().getId());
            map.put("fullName", a.getUser().getFullName());
            map.put("status", a.getStatus().name());
            map.put("joinedAt", a.getCreatedAt());
            return map;
        }).collect(Collectors.toList());

        return ResponseEntity.ok(result);
    }

    @Transactional
    @PostMapping("/trainee-join/{id}")
    @ResponseBody
    public ResponseEntity<?> traineeJoin(@PathVariable String id, HttpSession session) {
        User sessionUser = (User) session.getAttribute("user");
        if (sessionUser == null) return ResponseEntity.status(401).body(Map.of("message", "Unauthorized"));

        User user = userRepository.findById(sessionUser.getId()).orElse(null);
        if (user == null) return ResponseEntity.status(401).body(Map.of("message", "User session invalid"));

        String meetingLink = null;

        if (id.startsWith("batch-")) {
            Long batchId = Long.parseLong(id.substring(6));
            MartialArtsBatch batch = batchRepository.findById(batchId).orElse(null);
            if (batch == null) return ResponseEntity.status(404).body(Map.of("message", "Batch not found"));

            // Verify enrollment in physical enrollment table
            Enrollment enrollment = enrollmentRepository.findByUser(user).stream()
                .filter(e -> e.getBatch() != null && e.getBatch().getId().equals(batchId))
                .findFirst().orElse(null);

            // Allow APPROVED, IN_PROGRESS, or PENDING
            if (enrollment == null || (enrollment.getStatus() != TrainingStatus.APPROVED && enrollment.getStatus() != TrainingStatus.IN_PROGRESS && enrollment.getStatus() != TrainingStatus.PENDING)) {
                return ResponseEntity.status(403).body(Map.of("message", "You are not authorized to join this batch."));
            }
            meetingLink = batch.getMeetingLink();
        } else {
            Long classId = Long.parseLong(id);
            OnlineClass oc = onlineClassRepository.findById(classId).orElse(null);
            if (oc == null) return ResponseEntity.status(404).body(Map.of("message", "Class not found"));

            // Verify enrollment using OnlineClassEnrollment
            OnlineClassEnrollment enrollment = onlineClassEnrollmentRepository.findFirstByTraineeAndOnlineClassOrderByIdDesc(user, oc).orElse(null);
            
            // Allow APPROVED, IN_PROGRESS, or PENDING
            if (enrollment == null || (enrollment.getStatus() != TrainingStatus.APPROVED && enrollment.getStatus() != TrainingStatus.IN_PROGRESS && enrollment.getStatus() != TrainingStatus.PENDING)) {
                return ResponseEntity.status(403).body(Map.of("message", "You are not authorized to join this class. Enrollment status: " + (enrollment != null ? enrollment.getStatus() : "NONE")));
            }

            if (oc.getStatus() != OnlineClassStatus.LIVE) {
                return ResponseEntity.status(400).body(Map.of("message", "Class is not live yet."));
            }
            meetingLink = oc.getMeetingLink();

            // Mark attendance for scheduled classes
            Attendance attendance = new Attendance();
            attendance.setUser(user);
            attendance.setOnlineClass(oc);
            attendance.setCenter(oc.getCenter());
            attendance.setAttendanceDate(oc.getDate());
            attendance.setMode("ONLINE");
            attendance.setStatus(AttendanceStatus.PRESENT);
            attendance.setNotes("Joined live session at " + LocalDateTime.now());
            attendanceRepository.save(attendance);
        }

        if (meetingLink == null || meetingLink.isEmpty()) {
            return ResponseEntity.status(400).body(Map.of("message", "Meeting link not available."));
        }

        return ResponseEntity.ok(Map.of("meetingLink", meetingLink));
    }

    @Transactional(readOnly = true)
    @GetMapping("/{id}/batch-details-trainees")
    @ResponseBody
    public ResponseEntity<?> getEnrolledTrainees(@PathVariable Long id, HttpSession session) {
        User user = (User) session.getAttribute("user");
        MartialArtsCenter center = (MartialArtsCenter) session.getAttribute("loggedCentre");
        
        if (user == null && center == null) return ResponseEntity.status(401).body(Map.of("message", "Unauthorized"));

        OnlineClass oc = onlineClassRepository.findById(id).orElse(null);
        if (oc == null) return ResponseEntity.status(404).body(Map.of("message", "Class not found"));

        // Security check: Trainer/Center must own the class
        if (center != null && (oc.getCenter() == null || !oc.getCenter().getId().equals(center.getId()))) {
            return ResponseEntity.status(403).body(Map.of("message", "Access denied"));
        }
        if (user != null && (oc.getTrainer() == null || !oc.getTrainer().getId().equals(user.getId()))) {
             return ResponseEntity.status(403).body(Map.of("message", "Access denied"));
        }

        if (oc.getBatch() == null) return ResponseEntity.ok(Collections.emptyList());

        List<Enrollment> batchEnrollments = enrollmentRepository.findByBatch(oc.getBatch());
        List<Map<String, Object>> result = new ArrayList<>();

        for (Enrollment be : batchEnrollments) {
            User trainee = be.getUser();
            if (trainee == null) continue;
            
            Map<String, Object> map = new HashMap<>();
            map.put("id", trainee.getId());
            map.put("fullName", trainee.getFullName());
            map.put("email", trainee.getEmail());
            
            // Online Class Enrollment Status
            OnlineClassEnrollment oce = onlineClassEnrollmentRepository.findFirstByTraineeAndOnlineClassOrderByIdDesc(trainee, oc).orElse(null);
            map.put("enrollmentStatus", oce != null ? oce.getStatus().name() : "NOT_INVITED");
            
            // Attendance Status (if class is live or completed)
            Attendance attendance = attendanceRepository.findByUserAndOnlineClass(trainee, oc).stream().findFirst().orElse(null);
            map.put("attendanceStatus", attendance != null ? attendance.getStatus().name() : "ABSENT");
            
            // Payment Status (from batch enrollment)
            map.put("paymentStatus", be.getPaymentStatus() != null ? be.getPaymentStatus() : "PAID"); // Assuming PAID if enrolled in batch
            
            result.add(map);
        }

        return ResponseEntity.ok(result);
    }

    @Transactional(readOnly = true)
    @GetMapping("/{classId}/session-trainees")
    @ResponseBody
    public ResponseEntity<?> getSessionTrainees(@PathVariable Long classId, HttpSession session) {
        // Security check
        if (session.getAttribute("user") == null && session.getAttribute("loggedCentre") == null) {
            return ResponseEntity.status(401).body(Map.of("message", "Unauthorized"));
        }

        OnlineClass oc = onlineClassRepository.findById(classId).orElse(null);
        if (oc == null) return ResponseEntity.status(404).body(Map.of("message", "Class not found"));

        MartialArtsCenter center = oc.getCenter();
        if (center == null && oc.getTrainer() != null) {
            center = oc.getTrainer().getMartialArtsCenter();
        }
        
        if (center == null) return ResponseEntity.ok(Collections.emptyList());

        // Get all approved or in-progress trainees in this center
        List<Enrollment> centerEnrollments = enrollmentRepository.findByCenter(center);
        
        List<Map<String, Object>> result = new ArrayList<>();
        
        for (Enrollment e : centerEnrollments) {
            if ((e.getStatus() != TrainingStatus.APPROVED && e.getStatus() != TrainingStatus.IN_PROGRESS) || e.getUser() == null) continue;
            
            User trainee = e.getUser();
            
            // Check status
            String status = "NOT_INVITED";
            Optional<OnlineClassInvitation> inv = invitationRepository.findFirstByTraineeAndOnlineClassOrderByIdDesc(trainee, oc);
            if (inv.isPresent()) {
                status = inv.get().getStatus().toString(); // PENDING, ACCEPTED, REJECTED
            }
            
            Optional<OnlineClassEnrollment> enr = onlineClassEnrollmentRepository.findFirstByTraineeAndOnlineClassOrderByIdDesc(trainee, oc);
            if (enr.isPresent()) {
                status = "ENROLLED";
            }

            Map<String, Object> map = new HashMap<>();
            map.put("id", trainee.getId());
            map.put("fullName", trainee.getFullName());
            map.put("email", trainee.getEmail());
            map.put("profilePhoto", trainee.getProfilePhoto());
            map.put("status", status);
            
            // Avoid duplicates
            if (result.stream().noneMatch(m -> m.get("id").equals(trainee.getId()))) {
                result.add(map);
            }
        }

        return ResponseEntity.ok(result);
    }

    @Transactional(readOnly = true)
    @GetMapping("/{classId}/eligible-trainees")
    @ResponseBody
    public ResponseEntity<?> getEligibleTrainees(@PathVariable Long classId, HttpSession session) {
        // Keeping this for backward compatibility if needed, but the /trainees is better now
        return getSessionTrainees(classId, session);
    }

    @Transactional
    @PostMapping("/{id}/invite-trainees")
    @ResponseBody
    public ResponseEntity<?> inviteTrainees(@PathVariable Long id, @RequestBody Map<String, List<Long>> payload, HttpSession session) {
        User sessionUser = (User) session.getAttribute("user");
        if (sessionUser == null && session.getAttribute("loggedCentre") == null) {
            return ResponseEntity.status(401).body(Map.of("message", "Unauthorized"));
        }

        OnlineClass oc = onlineClassRepository.findById(id).orElse(null);
        if (oc == null) return ResponseEntity.status(404).body(Map.of("message", "Class not found"));

        List<Long> traineeIds = payload.get("traineeIds");
        if (traineeIds == null || traineeIds.isEmpty()) return ResponseEntity.badRequest().body(Map.of("message", "No trainees selected"));

        User trainer = sessionUser;

        int count = 0;
        for (Long tId : traineeIds) {
            User trainee = userRepository.findById(tId).orElse(null);
            if (trainee == null) continue;
            
            Optional<OnlineClassInvitation> existing = invitationRepository.findFirstByTraineeAndOnlineClassOrderByIdDesc(trainee, oc);
            if (existing.isPresent()) continue;

            OnlineClassInvitation invitation = new OnlineClassInvitation();
            invitation.setTrainee(trainee);
            invitation.setOnlineClass(oc);
            invitation.setTrainer(trainer);
            invitation.setStatus(OnlineClassInvitation.InviteStatus.PENDING);
            invitationRepository.save(invitation);
            count++;
        }

        return ResponseEntity.ok(Map.of("message", count + " Invitations sent successfully!"));
    }
}
