package in.sp.main.Controller;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import in.sp.main.Entities.ConsultationType;
import in.sp.main.Entities.Doctor;
import in.sp.main.Entities.DoctorAppointment;
import in.sp.main.Entities.DoctorAppointmentStatus;
import in.sp.main.Entities.DoctorReview;
import in.sp.main.Entities.Gender;
import in.sp.main.Entities.User;
import in.sp.main.Entities.VerificationStatus;
import in.sp.main.Repository.DoctorAppointmentRepository;
import in.sp.main.Repository.DoctorRepository;
import in.sp.main.Repository.DoctorReviewRepository;
import in.sp.main.Service.FileUploadService;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/doctors")
public class DoctorController {

    @Autowired
    private DoctorRepository doctorRepo;

    @Autowired
    private DoctorAppointmentRepository appointmentRepo;

    @Autowired
    private DoctorReviewRepository reviewRepo;

    @Autowired
    private FileUploadService fileUploadService;
    
    @Autowired
    private in.sp.main.Config.JwtUtil jwtUtil;

    // ==============================
    // Doctor Registration + Login
    // ==============================
    @GetMapping("/register")
    public String registerPage() {
        return "doctor/doctor-register";
    }

    @PostMapping("/register")
    public String register(
            // ── Step 1: Basic Details ──
            @RequestParam String fullName,
            @RequestParam String email,
            @RequestParam String phone,
            @RequestParam String password,
            @RequestParam String gender,
            @RequestParam("profilePhoto") MultipartFile profilePhoto,

            // ── Step 2: Professional Details ──
            @RequestParam String medicalRegNumber,
            @RequestParam String specialization,
            @RequestParam Integer experienceYears,
            @RequestParam String qualification,
            @RequestParam(required = false) String hospitalName,
            @RequestParam String consultationType,

            // ── Step 3: Location Details ──
            @RequestParam String clinicAddress,
            @RequestParam String city,
            @RequestParam String state,
            @RequestParam String pincode,
            @RequestParam(required = false) String googleMapLocation,

            // ── Step 4: Availability ──
            @RequestParam(required = false) List<String> availableDays,
            @RequestParam String startTime,
            @RequestParam String endTime,
            @RequestParam(required = false) String emergencyAvailable,

            // ── Step 5: Verification Documents ──
            @RequestParam("medicalLicense") MultipartFile medicalLicense,
            @RequestParam("idProof") MultipartFile idProof,
            @RequestParam("degreeCertificate") MultipartFile degreeCertificate,

            // ── Step 6: Earnings Setup ──
            @RequestParam Double consultationFee,
            @RequestParam(required = false) Double chatFee,
            @RequestParam(required = false) Double callFee,
            @RequestParam(required = false) Double videoFee,
            @RequestParam(required = false) String upiId,
            @RequestParam(required = false) String bankDetails,

            Model model) {

        if (doctorRepo.findByEmail(email.trim().toLowerCase()).isPresent()) {
            model.addAttribute("error", "Email already registered.");
            return "doctor/doctor-register";
        }

        if (phone == null || !phone.trim().matches("^\\d{10}$")) {
            model.addAttribute("error", "Phone number must be exactly 10 digits.");
            return "doctor/doctor-register";
        }

        try {
            // Save uploaded files
            String profilePhotoPath = fileUploadService.saveFile(profilePhoto);
            String medicalLicensePath = fileUploadService.saveFile(medicalLicense);
            String idProofPath = fileUploadService.saveFile(idProof);
            String degreeCertificatePath = fileUploadService.saveFile(degreeCertificate);

            Doctor d = new Doctor();

            // Step 1
            d.setFullName(fullName);
            d.setEmail(email.trim().toLowerCase());
            d.setPhone(phone);
            d.setPassword(password);
            d.setGender(Gender.valueOf(gender));
            d.setProfilePhotoPath(profilePhotoPath);

            // Step 2
            d.setMedicalRegNumber(medicalRegNumber);
            d.setSpecialization(specialization);
            d.setExperienceYears(experienceYears);
            d.setQualification(qualification);
            d.setHospitalName(hospitalName);
            d.setConsultationType(ConsultationType.valueOf(consultationType));

            // Step 3
            d.setClinicAddress(clinicAddress);
            d.setCity(city);
            d.setState(state);
            d.setPincode(pincode);
            d.setLocationText(city + ", " + state);
            d.setGoogleMapLocation(googleMapLocation);

            // Step 4
            if (availableDays != null && !availableDays.isEmpty()) {
                d.setAvailableDays(String.join(",", availableDays));
            }
            d.setStartTime(startTime);
            d.setEndTime(endTime);
            d.setEmergencyAvailable("yes".equalsIgnoreCase(emergencyAvailable));

            // Step 5
            d.setMedicalLicensePath(medicalLicensePath);
            d.setIdProofPath(idProofPath);
            d.setDegreeCertificatePath(degreeCertificatePath);
            d.setIdentityDocumentPath(idProofPath);

            // Step 6
            d.setConsultationFee(consultationFee);
            d.setChatFee(chatFee);
            d.setCallFee(callFee);
            d.setVideoFee(videoFee);
            d.setUpiId(upiId);
            d.setBankDetails(bankDetails);

            d.setVerificationStatus(VerificationStatus.PENDING);
            d.setRating(0.0);

            doctorRepo.save(d);
            model.addAttribute("message", "Registration successful! Await admin verification.");
            return "redirect:/doctors/login";
        } catch (IOException e) {
            model.addAttribute("error", "Failed to upload documents. Please try again.");
            return "doctor/doctor-register";
        }
    }

    @GetMapping("/login")
    public String loginPage() {
        return "doctor/doctor-login";
    }

    @PostMapping("/login")
    public String login(@RequestParam String email,
                        @RequestParam String password,
                        HttpSession session,
                        jakarta.servlet.http.HttpServletResponse response,
                        Model model) {
        Optional<Doctor> dOpt = doctorRepo.findByEmail(email.trim().toLowerCase());
        if (dOpt.isEmpty()) {
            model.addAttribute("error", "Doctor not found.");
            return "doctor/doctor-login";
        }
        Doctor d = dOpt.get();
        if (!d.getPassword().equals(password)) {
            model.addAttribute("error", "Invalid password.");
            return "doctor/doctor-login";
        }

        if (d.getVerificationStatus() == VerificationStatus.PENDING) {
            model.addAttribute("error", "Your account is pending admin verification. Access denied.");
            return "doctor/doctor-login";
        }
        if (d.getVerificationStatus() == VerificationStatus.REJECTED) {
            model.addAttribute("error", "Your account has been rejected by admin.");
            return "doctor/doctor-login";
        }

        session.setAttribute("loggedDoctor", d);
        
        // Generate JWT and add to response
        String token = jwtUtil.generateToken(d.getEmail(), "DOCTOR");
        jakarta.servlet.http.Cookie cookie = new jakarta.servlet.http.Cookie("JWT_TOKEN", token);
        cookie.setPath("/");
        cookie.setHttpOnly(true);
        cookie.setMaxAge(365 * 24 * 60 * 60); // 1 year
        response.addCookie(cookie);
        
        return "redirect:/doctors/dashboard";
    }

    @GetMapping("/dashboard")
    public String dashboard(@RequestParam(required = false, defaultValue = "overview") String section,
                            HttpSession session, Model model) {
        Doctor d = (Doctor) session.getAttribute("loggedDoctor");
        if (d == null) return "redirect:/doctors/login";

        d = doctorRepo.findById(d.getId()).orElse(d);
        List<DoctorAppointment> appts = appointmentRepo.findByDoctorOrderByAppointmentTimeDesc(d);
        model.addAttribute("doctor", d);
        model.addAttribute("appointments", appts);
        model.addAttribute("appointmentCount", appts.size());
        model.addAttribute("section", section);

        // Count statuses for stats
        long pending = appts.stream().filter(a -> a.getStatus() == DoctorAppointmentStatus.PENDING).count();
        long confirmed = appts.stream().filter(a -> a.getStatus() == DoctorAppointmentStatus.CONFIRMED).count();
        long completed = appts.stream().filter(a -> a.getStatus() == DoctorAppointmentStatus.COMPLETED).count();
        model.addAttribute("pendingCount", pending);
        model.addAttribute("confirmedCount", confirmed);
        model.addAttribute("completedCount", completed);

        // Calculate total earnings from paid appointments
        double totalEarnings = appts.stream()
                .filter(a -> a.getAmountPaid() != null && a.getAmountPaid() > 0)
                .mapToDouble(DoctorAppointment::getAmountPaid)
                .sum();
        long paidCount = appts.stream()
                .filter(a -> a.getAmountPaid() != null && a.getAmountPaid() > 0)
                .count();
        model.addAttribute("totalEarnings", totalEarnings);
        model.addAttribute("paidCount", paidCount);

        if ("chats".equals(section)) {
            List<in.sp.main.Entities.DoctorChatMessage> chats = doctorChatRepo.findByDoctorOrderByTimestampDesc(d);
            java.util.Set<User> chatUsers = new java.util.LinkedHashSet<>();
            for (in.sp.main.Entities.DoctorChatMessage msg : chats) {
                if (msg.getUser() != null) {
                    chatUsers.add(msg.getUser());
                }
            }
            model.addAttribute("chatUsers", chatUsers);
        }

        return "doctor/doctor-dashboard";
    }

    @PostMapping("/update-profile")
    public String updateProfile(@RequestParam String fullName,
                                @RequestParam String phone,
                                @RequestParam(required = false) String gender,
                                @RequestParam(required = false) String specialization,
                                @RequestParam(required = false) String qualification,
                                @RequestParam(required = false) Integer experienceYears,
                                @RequestParam(required = false) String medicalRegNumber,
                                @RequestParam(required = false) String hospitalName,
                                @RequestParam(required = false) String consultationType,
                                HttpSession session,
                                RedirectAttributes redirectAttributes) {
        Doctor d = (Doctor) session.getAttribute("loggedDoctor");
        if (d == null) return "redirect:/doctors/login";

        if (phone == null || !phone.trim().matches("^\\d{10}$")) {
            redirectAttributes.addFlashAttribute("error", "Phone number must be exactly 10 digits.");
            return "redirect:/doctors/dashboard?section=profile";
        }

        d = doctorRepo.findById(d.getId()).orElse(d);
        d.setFullName(fullName);
        d.setPhone(phone);
        if (gender != null) d.setGender(Gender.valueOf(gender));
        d.setSpecialization(specialization);
        d.setQualification(qualification);
        d.setExperienceYears(experienceYears);
        d.setMedicalRegNumber(medicalRegNumber);
        d.setHospitalName(hospitalName);
        if (consultationType != null) d.setConsultationType(ConsultationType.valueOf(consultationType));

        doctorRepo.save(d);
        session.setAttribute("loggedDoctor", d);
        redirectAttributes.addFlashAttribute("message", "Profile updated successfully!");
        return "redirect:/doctors/dashboard?section=profile";
    }

    @PostMapping("/update-schedule")
    public String updateSchedule(@RequestParam(required = false) List<String> availableDays,
                                 @RequestParam(required = false) String startTime,
                                 @RequestParam(required = false) String endTime,
                                 @RequestParam(required = false) String emergencyAvailable,
                                 @RequestParam(required = false) String clinicAddress,
                                 @RequestParam(required = false) String city,
                                 @RequestParam(required = false) String state,
                                 @RequestParam(required = false) String pincode,
                                 @RequestParam(required = false) String googleMapLocation,
                                 HttpSession session,
                                 RedirectAttributes redirectAttributes) {
        Doctor d = (Doctor) session.getAttribute("loggedDoctor");
        if (d == null) return "redirect:/doctors/login";

        d = doctorRepo.findById(d.getId()).orElse(d);
        if (availableDays != null && !availableDays.isEmpty()) {
            d.setAvailableDays(String.join(",", availableDays));
        } else {
            d.setAvailableDays(null);
        }
        d.setStartTime(startTime);
        d.setEndTime(endTime);
        d.setEmergencyAvailable("yes".equalsIgnoreCase(emergencyAvailable));
        d.setClinicAddress(clinicAddress);
        d.setCity(city);
        d.setState(state);
        d.setPincode(pincode);
        d.setLocationText((city != null ? city : "") + ", " + (state != null ? state : ""));
        d.setGoogleMapLocation(googleMapLocation);

        doctorRepo.save(d);
        session.setAttribute("loggedDoctor", d);
        redirectAttributes.addFlashAttribute("message", "Schedule updated successfully!");
        return "redirect:/doctors/dashboard?section=schedule";
    }

    @PostMapping("/appointments/{id}/status")
    public String updateAppointmentStatus(@PathVariable Long id,
                                          @RequestParam String status,
                                          HttpSession session,
                                          RedirectAttributes redirectAttributes) {
        Doctor d = (Doctor) session.getAttribute("loggedDoctor");
        if (d == null) return "redirect:/doctors/login";

        DoctorAppointment appt = appointmentRepo.findById(id).orElse(null);
        if (appt == null || appt.getDoctor() == null || !appt.getDoctor().getId().equals(d.getId())) {
            redirectAttributes.addFlashAttribute("message", "Appointment not found.");
            return "redirect:/doctors/dashboard";
        }

        try {
            appt.setStatus(DoctorAppointmentStatus.valueOf(status));
            appointmentRepo.save(appt);
            redirectAttributes.addFlashAttribute("message", "Status updated.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("message", "Invalid status.");
        }
        return "redirect:/doctors/dashboard";
    }

    // ==============================
    // User: Search + Book + Review
    // ==============================
    @GetMapping("/list")
    public String listForUsers(Model model, HttpSession session) {
        User u = (User) session.getAttribute("user");
        if (u == null) return "redirect:/login";

        model.addAttribute("doctors", doctorRepo.findByVerificationStatus(VerificationStatus.VERIFIED));
        return "doctor/doctor-list";
    }

    @GetMapping("/view/{id}")
    public String viewDoctor(@PathVariable Long id, Model model, HttpSession session) {
        User u = (User) session.getAttribute("user");
        if (u == null) return "redirect:/login";

        Doctor d = doctorRepo.findById(id).orElse(null);
        if (d == null || d.getVerificationStatus() != VerificationStatus.VERIFIED) {
            return "redirect:/doctors/list";
        }

        List<DoctorReview> reviews = reviewRepo.findByDoctorIdOrderByCreatedAtDesc(id);
        model.addAttribute("doctor", d);
        model.addAttribute("reviews", reviews);
        model.addAttribute("canReview", !reviewRepo.existsByUserIdAndDoctorId(u.getId(), id));
        return "doctor/doctor-view";
    }

    @PostMapping("/book")
    public String book(@RequestParam Long doctorId,
                       @RequestParam String appointmentTime,
                       @RequestParam(required = false) String reason,
                       HttpSession session,
                       RedirectAttributes redirectAttributes) {
        User u = (User) session.getAttribute("user");
        if (u == null) return "redirect:/login";

        Doctor d = doctorRepo.findById(doctorId).orElse(null);
        if (d == null || d.getVerificationStatus() != VerificationStatus.VERIFIED) {
            redirectAttributes.addFlashAttribute("message", "Doctor not available.");
            return "redirect:/doctors/list";
        }

        DoctorAppointment appt = new DoctorAppointment();
        appt.setUser(u);
        appt.setDoctor(d);
        // Purpose: parse date+time from booking form (yyyy-MM-dd HH:mm:ss).
        appt.setAppointmentTime(LocalDateTime.parse(appointmentTime, DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")));
        appt.setReason(reason);
        appt.setStatus(DoctorAppointmentStatus.PENDING);
        appointmentRepo.save(appt);

        redirectAttributes.addFlashAttribute("message", "Appointment requested.");
        return "redirect:/doctors/myAppointments";
    }

    @GetMapping("/myAppointments")
    public String myAppointments(HttpSession session, Model model) {
        User u = (User) session.getAttribute("user");
        if (u == null) return "redirect:/login";

        model.addAttribute("appointments", appointmentRepo.findByUserOrderByAppointmentTimeDesc(u));
        return "doctor/my-appointments";
    }

    @PostMapping("/review")
    public String addReview(@RequestParam Long doctorId,
                            @RequestParam Integer rating,
                            @RequestParam(required = false) String comment,
                            HttpSession session,
                            RedirectAttributes redirectAttributes) {
        User u = (User) session.getAttribute("user");
        if (u == null) return "redirect:/login";

        Doctor d = doctorRepo.findById(doctorId).orElse(null);
        if (d == null) return "redirect:/doctors/list";

        if (rating == null || rating < 1 || rating > 5) {
            redirectAttributes.addFlashAttribute("message", "Rating must be 1-5.");
            return "redirect:/doctors/view/" + doctorId;
        }

        if (reviewRepo.existsByUserIdAndDoctorId(u.getId(), doctorId)) {
            redirectAttributes.addFlashAttribute("message", "You already reviewed this doctor.");
            return "redirect:/doctors/view/" + doctorId;
        }

        DoctorReview r = new DoctorReview();
        r.setUser(u);
        r.setDoctor(d);
        r.setRating(rating);
        r.setComment(comment);
        reviewRepo.save(r);

        // Purpose: update average rating for display (simple recalculation).
        List<DoctorReview> reviews = reviewRepo.findByDoctorIdOrderByCreatedAtDesc(doctorId);
        double avg = reviews.stream().mapToInt(x -> x.getRating() == null ? 0 : x.getRating()).average().orElse(0.0);
        d.setRating(avg);
        doctorRepo.save(d);

        redirectAttributes.addFlashAttribute("message", "Review submitted.");
        return "redirect:/doctors/view/" + doctorId;
    }

    // ==============================
    // Real-time: Chat, Video, Call
    // ==============================
    @Autowired
    private in.sp.main.Repository.DoctorChatRepository doctorChatRepo;

    @Autowired
    private org.springframework.messaging.simp.SimpMessagingTemplate messagingTemplate;

    @Autowired
    private in.sp.main.Repository.UserRepository userRepo;

    @GetMapping("/chat/{doctorId}")
    public String chatWithDoctor(@PathVariable Long doctorId, @RequestParam(required = false) Long userId, Model model, HttpSession session) {
        User u = (User) session.getAttribute("user");
        Doctor d = (Doctor) session.getAttribute("loggedDoctor");
        Doctor target = doctorRepo.findById(doctorId).orElse(null);
        if (target == null) return "redirect:/doctors/list";

        if (u != null) {
            model.addAttribute("currentUser", u.getFullName());
            model.addAttribute("currentId", u.getId());
            model.addAttribute("senderType", "USER");
            model.addAttribute("targetUserId", u.getId());
            model.addAttribute("chatHistory", doctorChatRepo.findByUserAndDoctorOrderByTimestampAsc(u, target));
        } else if (d != null) {
            model.addAttribute("currentUser", "Dr. " + d.getFullName());
            model.addAttribute("currentId", d.getId());
            model.addAttribute("senderType", "DOCTOR");
            if (userId != null) {
                User chatUser = userRepo.findById(userId).orElse(null);
                model.addAttribute("targetUserId", userId);
                if (chatUser != null) {
                    model.addAttribute("targetUserName", chatUser.getFullName());
                    model.addAttribute("chatHistory", doctorChatRepo.findByUserAndDoctorOrderByTimestampAsc(chatUser, target));
                } else {
                    model.addAttribute("targetUserName", "Unknown Patient");
                    model.addAttribute("chatHistory", java.util.Collections.emptyList());
                }
            } else {
                model.addAttribute("chatHistory", java.util.Collections.emptyList());
            }
        } else {
            return "redirect:/login";
        }
        model.addAttribute("doctor", target);
        return "doctor/doctor-chat";
    }

    @PostMapping("/chat/send")
    @org.springframework.web.bind.annotation.ResponseBody
    public String sendDoctorChat(@RequestParam Long doctorId,
                                 @RequestParam String message,
                                 @RequestParam String senderType,
                                 @RequestParam(required = false) Long userId,
                                 HttpSession session) {
        Doctor doc = doctorRepo.findById(doctorId).orElse(null);
        if (doc == null) return "ERROR";

        in.sp.main.Entities.DoctorChatMessage msg = new in.sp.main.Entities.DoctorChatMessage();
        msg.setDoctor(doc);
        msg.setMessage(message);
        msg.setSenderType(senderType);

        if ("USER".equals(senderType)) {
            User u = (User) session.getAttribute("user");
            if (u == null) return "NOT_LOGGED_IN";
            msg.setUser(u);
        } else {
            Doctor d = (Doctor) session.getAttribute("loggedDoctor");
            if (d == null) return "NOT_LOGGED_IN";
            if (userId != null) {
                User targetUser = userRepo.findById(userId).orElse(null);
                msg.setUser(targetUser);
            }
        }

        doctorChatRepo.save(msg);
        // Broadcast via WebSocket using Map to avoid serialization recursion
        java.util.Map<String, Object> payload = new java.util.HashMap<>();
        payload.put("id", msg.getId());
        payload.put("message", msg.getMessage());
        payload.put("senderType", msg.getSenderType());
        if (msg.getUser() != null) {
            payload.put("userId", msg.getUser().getId());
        }
        messagingTemplate.convertAndSend("/topic/doctor-chat/" + doctorId, payload);
        return "OK";
    }

    @GetMapping("/video-call/{doctorId}")
    public String videoCallDoctor(@PathVariable Long doctorId, @RequestParam(required = false) Long userId, Model model, HttpSession session) {
        User u = (User) session.getAttribute("user");
        Doctor d = (Doctor) session.getAttribute("loggedDoctor");
        Doctor target = doctorRepo.findById(doctorId).orElse(null);
        if (target == null) return "redirect:/doctors/list";

        String roomName = "safeher-doc-" + doctorId + "-" + System.currentTimeMillis();
        if (u != null) {
            model.addAttribute("displayName", u.getFullName());
            roomName = "safeher-doc-" + doctorId + "-user-" + u.getId();
        } else if (d != null) {
            model.addAttribute("displayName", "Dr. " + d.getFullName());
            roomName = "safeher-doc-" + doctorId + "-user-" + (userId != null ? userId : 0);
        } else {
            return "redirect:/login";
        }
        model.addAttribute("doctor", target);
        model.addAttribute("roomName", roomName);
        model.addAttribute("audioOnly", false);
        return "doctor/doctor-call";
    }

    @GetMapping("/voice-call/{doctorId}")
    public String voiceCallDoctor(@PathVariable Long doctorId, @RequestParam(required = false) Long userId, Model model, HttpSession session) {
        User u = (User) session.getAttribute("user");
        Doctor d = (Doctor) session.getAttribute("loggedDoctor");
        Doctor target = doctorRepo.findById(doctorId).orElse(null);
        if (target == null) return "redirect:/doctors/list";

        String roomName = "safeher-call-" + doctorId + "-" + System.currentTimeMillis();
        if (u != null) {
            model.addAttribute("displayName", u.getFullName());
            roomName = "safeher-call-" + doctorId + "-user-" + u.getId();
        } else if (d != null) {
            model.addAttribute("displayName", "Dr. " + d.getFullName());
            roomName = "safeher-call-" + doctorId + "-user-" + (userId != null ? userId : 0);
        } else {
            return "redirect:/login";
        }
        model.addAttribute("doctor", target);
        model.addAttribute("roomName", roomName);
        model.addAttribute("audioOnly", true);
        return "doctor/doctor-call";
    }

    @PostMapping("/appointments/{id}/prescription")
    public String savePrescription(@PathVariable Long id, @RequestParam String prescriptionText, HttpSession session, RedirectAttributes redirectAttributes) {
        Doctor d = (Doctor) session.getAttribute("loggedDoctor");
        if (d == null) return "redirect:/doctors/login";
        
        DoctorAppointment appt = appointmentRepo.findById(id).orElse(null);
        if (appt != null && appt.getDoctor().getId().equals(d.getId())) {
            appt.setPrescriptionText(prescriptionText);
            appointmentRepo.save(appt);
            redirectAttributes.addFlashAttribute("message", "Prescription saved successfully!");
        } else {
            redirectAttributes.addFlashAttribute("error", "Failed to save prescription.");
        }
        return "redirect:/doctors/dashboard?section=prescriptions";
    }
}
