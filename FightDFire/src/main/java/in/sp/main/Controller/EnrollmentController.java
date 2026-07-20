package in.sp.main.Controller;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.FileSystemResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import in.sp.main.Entities.*;
import in.sp.main.Repository.*;
import in.sp.main.Repository.MartialArtsTypeRepository;
import in.sp.main.Repository.MartialArtsBatchRepository;
import in.sp.main.Service.*;
import jakarta.servlet.http.HttpSession;

import static org.springframework.web.bind.annotation.RequestMethod.*;

@Controller
@RequestMapping("/enrollment")
public class EnrollmentController {

    @Autowired
    private EnrollmentService enrollservice;
    @Autowired
    private EnrollmentRepository enrollmentRepository;
    
    @Autowired
    private SlotRepository slotRepository;
    @Autowired
    private CertificateService certificateService;
    @Autowired
    private UserService userservice;
    @Autowired
    private MartialArtsTypeRepository martialArtTypeRepository;
    @Autowired
    private MartialArtsCenterService centreService;
    @Autowired
    private MartialArtsBatchRepository batchRepository;
    
    @Autowired
    private AttendanceRepository attendanceRepository;

    @RequestMapping(value = "/listEnrollments/{userId}", method = GET)
    public String listEnrollments(@PathVariable Long userId, Model model) {
        List<Enrollment> enrollments = enrollservice.getUserEnrollments(userId);

        if (enrollments.isEmpty()) {
            model.addAttribute("message", "No enrollments found.");
        } else {
            model.addAttribute("enrollments", enrollments);
            model.addAttribute("Training_Completed", TrainingStatus.COMPLETED);
            model.addAttribute("Training_Progress", TrainingStatus.IN_PROGRESS);
            model.addAttribute("Training_Pending", TrainingStatus.PENDING);
        }

        return "enrollmentList";
    }

    // Lightweight endpoint for near real-time refresh checks
    @GetMapping("/listEnrollments/{userId}.meta")
    @ResponseBody
    public java.util.Map<String, Object> enrollmentsMeta(@PathVariable Long userId, HttpSession session) {
        java.util.Map<String, Object> res = new java.util.HashMap<>();

        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null || !currentUser.getId().equals(userId)) {
            res.put("error", "LOGIN_REQUIRED");
            res.put("count", 0);
            res.put("signature", "");
            return res;
        }

        List<Enrollment> enrollments = enrollservice.getUserEnrollments(userId);
        StringBuilder sb = new StringBuilder();
        for (Enrollment e : enrollments) {
            sb.append(e.getId()).append('|');
            if (e.getStatus() != null) sb.append(e.getStatus().name());
            sb.append('|');
            String cert = e.getCertificateDetails();
            sb.append(cert == null ? "" : cert);
            sb.append(';');
        }

        res.put("count", enrollments.size());
        res.put("signature", sb.toString());
        return res;
    }

    @RequestMapping(value = "/enrollForm/{centreId}", method = GET)
    public String showEnrollmentForm(@PathVariable Long centreId,
                                     @RequestParam(value = "batchId", required = false) Long batchId,
                                     Model model, HttpSession session,
                                     RedirectAttributes redirectAttributes) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            redirectAttributes.addFlashAttribute("message", "Please login to enroll in a training centre.");
            return "redirect:/login?redirect=/enrollment/enrollForm/" + centreId
                    + (batchId != null ? "?batchId=" + batchId : "");
        }
        try {
            MartialArtsCenter center = centreService.getApprovedCenterById(centreId);
            model.addAttribute("center", center);
            model.addAttribute("batches", center.getBatches());
            model.addAttribute("user", user);
            model.addAttribute("preselectedBatchId", batchId);
            return "enrollmentForm";
        } catch (IllegalStateException ex) {
            redirectAttributes.addFlashAttribute("message", ex.getMessage());
            return "redirect:/centres/allacceptedcentres";
        }
    }

    @PostMapping("/api/enrollments")
    @ResponseBody
    public ResponseEntity<?> submitEnrollment(@RequestBody in.sp.main.dto.EnrollmentRequest request, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) return ResponseEntity.status(401).body("Please login first");

        try {
            MartialArtsCenter center = centreService.getApprovedCenterById(request.getCenterId());
            MartialArtsBatch batch = batchRepository.findById(request.getBatchId()).orElse(null);
            boolean batchBelongsToCentre = batchRepository.findByCenterId(center.getId()).stream()
                    .anyMatch(b -> b.getId().equals(request.getBatchId()));
            if (batch == null || !batchBelongsToCentre) {
                return ResponseEntity.badRequest().body("Invalid batch for this centre.");
            }

            boolean alreadyEnrolled = enrollmentRepository.findByUser(user).stream()
                    .anyMatch(e -> e.getBatch() != null && e.getBatch().getId().equals(batch.getId()));
            if (alreadyEnrolled) {
                return ResponseEntity.badRequest().body("You are already enrolled in this batch.");
            }

            // --- CAPACITY ENFORCEMENT ---
            if (batch.getCapacity() != null && batch.getCapacity() > 0) {
                long currentCount = enrollmentRepository.countPaidByBatchId(batch.getId());
                if (currentCount >= batch.getCapacity()) {
                    return ResponseEntity.status(409).body("This batch is full. No seats available.");
                }
            }

            Enrollment enrollment = new Enrollment();
            enrollment.setUser(user);
            enrollment.setCenter(center);
            enrollment.setBatch(batch);
            enrollment.setStatus(TrainingStatus.PENDING);
            enrollment.setPaymentStatus("PENDING");

            if (batch.getStyle() != null && center.getMartialArtsTypes() != null) {
                center.getMartialArtsTypes().stream()
                        .filter(t -> batch.getStyle().equalsIgnoreCase(t.getName()))
                        .findFirst()
                        .ifPresent(enrollment::setMartialArtsType);
            }
            
            // Personal Details
            enrollment.setFullName(request.getFullName());
            enrollment.setDob(request.getDob());
            enrollment.setAge(request.getAge());
            enrollment.setGender(request.getGender());
            enrollment.setPhoneNumber(request.getPhoneNumber());
            enrollment.setEmail(request.getEmail());
            enrollment.setResidentialAddress(request.getAddress());

            // Emergency
            enrollment.setEmergencyContactName(request.getEmergencyName());

            // Training Preference
            enrollment.setSkillLevel(request.getSkillLevel());
            enrollment.setTrainingGoal(request.getGoal());
            enrollment.setMotivation(request.getMotivation());
            if (request.getPreferredDays() != null) {
                Set<DayAvailable> days = request.getPreferredDays().stream()
                        .map(day -> DayAvailable.valueOf(day.toUpperCase()))
                        .collect(Collectors.toSet());
                enrollment.setPreferredDays(days);
            }

            // Health
            enrollment.setMedicalConditions(request.getMedicalConditions());
            enrollment.setAllergies(request.getAllergies());
            enrollment.setFitnessNotes(request.getFitnessNotes());

            // Details
            enrollment.setProposedStartDate(request.getStartDate());
            enrollment.setTrainerPreference(request.getTrainerPreference());
            enrollment.setAmountPaid(request.getMonthlyFee());

            // Consent
            enrollment.setConsentAccuracy(request.isConsentAccuracy());
            enrollment.setConsentRules(request.isConsentRules());

            Enrollment saved = enrollmentRepository.save(enrollment);

            // --- FREE BATCH: auto-approve immediately ---
            boolean isFree = (batch.getFee() == null || batch.getFee() <= 0);
            if (isFree) {
                saved.setPaymentStatus("PAID");
                saved.setStatus(TrainingStatus.APPROVED);
                saved.setAmountPaid(0.0);
                enrollmentRepository.save(saved);
                // Mark batch as Full if capacity reached
                if (batch.getCapacity() != null && batch.getCapacity() > 0) {
                    long newCount = enrollmentRepository.countPaidByBatchId(batch.getId());
                    if (newCount >= batch.getCapacity()) {
                        batch.setStatus("Full");
                        batchRepository.save(batch);
                    }
                }
            }

            java.util.Map<String, Object> response = new java.util.HashMap<>();
            response.put("message", isFree ? "Enrolled successfully!" : "Enrollment saved successfully");
            response.put("enrollmentId", saved.getId());
            response.put("free", isFree);
            return ResponseEntity.ok(response);
            
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.badRequest().body("Error saving enrollment: " + e.getMessage());
        }
    }

    @RequestMapping(value = "/enroll", method = POST)
    public String enroll(@RequestParam("userId") Long userId,
                         @RequestParam("centerId") Long centerId,
                         @RequestParam("batchId") Long batchId,
                         @RequestParam(value = "preferredDays", required = false) String[] preferredDays,
                         Model model) {

        MartialArtsBatch batch = batchRepository.findById(batchId)
                .orElseThrow(() -> new RuntimeException("Batch not found"));

        Enrollment enrollment = new Enrollment();
        enrollment.setUser(userservice.getUserById(userId));
        enrollment.setCenter(centreService.getCenterById(centerId));
        enrollment.setBatch(batch);
        enrollment.setStatus(TrainingStatus.PENDING);
        
        // Map batch details to enrollment for legacy compatibility
        // If your system needs these fields populated:
        // enrollment.setMartialArtsType(...); 
        // enrollment.setSelectedSlot(...);

        enrollmentRepository.save(enrollment);
        User user = userservice.getUserById(userId);
        user.setMartialArtsCenter(centreService.getCenterById(centerId));
        userservice.updateUser(userId, user);
        model.addAttribute("message", "Enrolled successfully!");
        return "enrollmentSuccess";
    }

    @RequestMapping(value = "/enrollmentSuccess", method = GET)
    public String enrollmentSuccess(Model model) {
        return "enrollmentSuccess";
    }

    @RequestMapping(value = "/updateStatus/{enrollmentId}", method = GET)
    public String showUpdateStatusForm(@PathVariable Long enrollmentId, Model model) {
        Enrollment enrollment = enrollmentRepository.findById(enrollmentId)
                .orElseThrow(() -> new RuntimeException("Enrollment not found"));
        model.addAttribute("enrollment", enrollment);
        return "updateStatus";
    }

    @RequestMapping(value = "/updateStatus", method = POST)
    public String updateStatus(@RequestParam("enrollmentId") Long enrollmentId,
                               @RequestParam("trainingStatus") TrainingStatus status, Model model) {
        Enrollment enrollment = enrollmentRepository.findById(enrollmentId)
                .orElseThrow(() -> new RuntimeException("Enrollment not found"));
        enrollment.setStatus(status);

        if (status == TrainingStatus.COMPLETED) {
            String artName = "Martial Arts";
            if (enrollment.getMartialArtsType() != null) {
                artName = enrollment.getMartialArtsType().getName();
            } else if (enrollment.getBatch() != null) {
                artName = enrollment.getBatch().getStyle();
            }
            
            String certificatePath = certificateService.generateCertificate(
                    enrollment.getUser().getFullName(),
                    artName
            );
            enrollment.setCertificateDetails(certificatePath);
        }

        enrollmentRepository.save(enrollment);
        model.addAttribute("message", "Status updated successfully!");
        return "redirect:/centres/dashboard1";
    }

    @RequestMapping(value = "/downloadCertificate/{enrollmentId}", method = GET)
    public ResponseEntity<FileSystemResource> downloadCertificate(@PathVariable Long enrollmentId, HttpSession session) {
        Enrollment enrollment = enrollmentRepository.findById(enrollmentId)
                .orElseThrow(() -> new RuntimeException("Enrollment not found"));
        String certificatePath = enrollment.getCertificateDetails();

        if (certificatePath == null || certificatePath.isEmpty()) {
            throw new RuntimeException("Certificate not available for download");
        }

        FileSystemResource resource = new FileSystemResource(certificatePath);

        if (!resource.exists()) {
            throw new RuntimeException("Certificate file does not exist at the specified path");
        }

        HttpHeaders headers = new HttpHeaders();
        headers.add(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=" + resource.getFilename());
        headers.add(HttpHeaders.CONTENT_TYPE, MediaType.APPLICATION_OCTET_STREAM_VALUE);

        return ResponseEntity.ok()
                .headers(headers)
                .body(resource);
    }

    @RequestMapping(value = "/searchEnrollments", method = GET)
    public String searchEnrollments(@RequestParam("userName") String userName, Model model) {
        User user = userservice.findByUsername(userName);
        if (user != null) {
            List<Enrollment> enrollments = enrollservice.getUserEnrollments(user.getId());
            model.addAttribute("enrollments", enrollments);
        } else {
            model.addAttribute("message", "No user found with this name.");
        }
        return "enrollment_dashboard";
    }

    @GetMapping("/getSlotsByType/{typeId}")
    @ResponseBody
    public List<Slot> getSlotsByType(@PathVariable Long typeId) {
        return slotRepository.findByMartialArtsTypeId(typeId);
    }

    @Autowired
    private OnlineClassRepository onlineClassRepository;
    
    @Autowired
    private TrainingSessionRepository sessionRepository;

    @GetMapping("/getUserEnrollmentsJson/{userId}")
    @ResponseBody
    public java.util.List<java.util.Map<String, Object>> getUserEnrollmentsJson(@PathVariable Long userId) {
        List<Enrollment> list = enrollservice.getUserEnrollments(userId);
        java.util.List<java.util.Map<String, Object>> result = new ArrayList<>();
        java.time.LocalDateTime now = java.time.LocalDateTime.now();
        
        for (Enrollment e : list) {
            // Paid-only enrollment validation
            String pStatus = e.getPaymentStatus();
            if ((pStatus == null || "PENDING".equalsIgnoreCase(pStatus)) && e.getAmountPaid() != null && e.getAmountPaid() > 0) {
                pStatus = "PAID";
            }
            if (!"PAID".equalsIgnoreCase(pStatus)) {
                continue;
            }

            java.util.Map<String, Object> map = new java.util.HashMap<>();
            map.put("id", e.getId());
            map.put("centerName", e.getCenter() != null ? e.getCenter().getName() : "N/A");
            
            // Mode and Batch details
            String mode = (e.getBatch() != null && e.getBatch().getBatchType() != null) ? e.getBatch().getBatchType().toUpperCase() : "OFFLINE";
            
            // SEPARATION: Only return OFFLINE (Physical) sessions for the main dashboard overview
            if ("ONLINE".equals(mode)) continue;
            
            map.put("mode", mode);
            
            // Status
            map.put("status", e.getStatus() != null ? e.getStatus().name() : "PENDING");
            map.put("progress", e.getProgressPercentage() != null ? e.getProgressPercentage() : 0);

            // Determine Martial Arts Type / Style
            String typeName = "N/A";
            if (e.getMartialArtsType() != null) {
                typeName = e.getMartialArtsType().getName();
            } else if (e.getBatch() != null && e.getBatch().getStyle() != null) {
                typeName = e.getBatch().getStyle();
            }
            map.put("martialArtsType", typeName);

            // Online Class Logic
            if ("ONLINE".equals(mode)) {
                // Find next/current session
                List<TrainingSession> sessions = sessionRepository.findByBatch(e.getBatch());
                TrainingSession activeSession = sessions.stream()
                    .filter(s -> !s.getDate().isBefore(java.time.LocalDate.now()))
                    .sorted(java.util.Comparator.comparing(TrainingSession::getDate))
                    .findFirst().orElse(null);
                
                if (activeSession != null) {
                    map.put("sessionDate", activeSession.getDate().toString());
                    map.put("startTime", activeSession.getStartTime());
                    map.put("endTime", activeSession.getEndTime());
                    
                    // Meeting link only if APPROVED or IN_PROGRESS
                    if (e.getStatus() == TrainingStatus.APPROVED || e.getStatus() == TrainingStatus.IN_PROGRESS) {
                        OnlineClass oc = onlineClassRepository.findFirstByBatchAndDate(e.getBatch(), activeSession.getDate()).orElse(null);
                        if (oc != null) {
                            map.put("onlineClassId", oc.getId());
                            map.put("meetingLink", oc.getMeetingLink());
                        } else if (e.getBatch().getMeetingLink() != null) {
                            // Fallback to batch-level link if session-specific is missing
                            map.put("meetingLink", e.getBatch().getMeetingLink());
                        }
                    }
                }
            }

            // Slot fallback for display
            String slotTime = "N/A";
            if (e.getBatch() != null && e.getBatch().getTimeSlot() != null) {
                slotTime = e.getBatch().getTimeSlot();
            }
            map.put("slot", slotTime);

            result.add(map);
        }
        return result;
    }
    @GetMapping("/trainee/my-trainings")
    @ResponseBody
    public java.util.List<java.util.Map<String, Object>> getMyTrainings(HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) return new ArrayList<>();

        List<Enrollment> list = enrollservice.getUserEnrollments(user.getId());
        java.util.List<java.util.Map<String, Object>> result = new ArrayList<>();
        
        for (Enrollment e : list) {
            // Paid-only enrollment validation
            String pStatus = e.getPaymentStatus();
            if ((pStatus == null || "PENDING".equalsIgnoreCase(pStatus)) && e.getAmountPaid() != null && e.getAmountPaid() > 0) {
                pStatus = "PAID";
            }
            if (!"PAID".equalsIgnoreCase(pStatus)) {
                continue;
            }

            java.util.Map<String, Object> map = new java.util.HashMap<>();
            map.put("enrollmentId", e.getId());
            map.put("centreId", e.getCenter() != null ? e.getCenter().getId() : "N/A");
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

            String mode = (e.getBatch() != null && e.getBatch().getBatchType() != null) ? e.getBatch().getBatchType() : "Offline";
            map.put("mode", mode);
            map.put("batchName", e.getBatch() != null ? e.getBatch().getName() : "N/A");
            map.put("slot", e.getBatch() != null ? e.getBatch().getTimeSlot() : "N/A");
            map.put("enrollmentDate", e.getProposedStartDate() != null ? e.getProposedStartDate().toString() : "TBD");
            map.put("status", e.getStatus() != null ? e.getStatus().name() : "PENDING");
            map.put("paymentStatus", pStatus);
            
            // Attendance and Progress Percentage (Dynamic calculations)
            List<Attendance> userAttendances = attendanceRepository.findByUser(user);
            
            long attendedCount = 0;
            long totalSessionsHeld = 0;

            if (e.getBatch() != null) {
                Long batchId = e.getBatch().getId();
                
                // Count attended sessions for this specific batch/class
                attendedCount = userAttendances.stream()
                    .filter(a -> a.getStatus() == AttendanceStatus.PRESENT || a.getStatus() == AttendanceStatus.LATE)
                    .filter(a -> (a.getSession() != null && a.getSession().getBatch() != null && a.getSession().getBatch().getId().equals(batchId)) ||
                                 (a.getOnlineClass() != null && a.getOnlineClass().getTitle().equalsIgnoreCase(e.getBatch().getName())) ||
                                 (a.getBatch() != null && a.getBatch().getId().equals(batchId)))
                    .count();
                
                // For attendance rate, we compare with total sessions held for this batch
                totalSessionsHeld = userAttendances.stream()
                    .filter(a -> (a.getSession() != null && a.getSession().getBatch() != null && a.getSession().getBatch().getId().equals(batchId)) ||
                                 (a.getOnlineClass() != null && a.getOnlineClass().getTitle().equalsIgnoreCase(e.getBatch().getName())) ||
                                 (a.getBatch() != null && a.getBatch().getId().equals(batchId)))
                    .count();

                if (totalSessionsHeld > 0) {
                    map.put("attendancePercentage", (int) ((attendedCount * 100) / totalSessionsHeld));
                } else {
                    map.put("attendancePercentage", 0);
                }

                map.put("progress", e.getProgressPercentage() != null ? e.getProgressPercentage() : 0);
                map.put("nextClassDate", java.time.LocalDate.now().plusDays(1).toString());
            } else {
                map.put("attendancePercentage", 0);
                map.put("progress", e.getProgressPercentage() != null ? e.getProgressPercentage() : 0);
                map.put("nextClassDate", "TBD");
            }

            result.add(map);
        }
        return result;
    }
}
