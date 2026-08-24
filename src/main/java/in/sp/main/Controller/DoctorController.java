package in.sp.main.Controller;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
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
import in.sp.main.Service.DoctorAppointmentService;
import in.sp.main.Service.DoctorBookingService;
import in.sp.main.Service.DoctorProfileService;
import in.sp.main.Service.DoctorRegistrationService;
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

    @Autowired
    private in.sp.main.Service.PasswordService passwordService;
    @Autowired
    private DoctorRegistrationService doctorRegistrationService;
    @Autowired
    private DoctorProfileService doctorProfileService;
    @Autowired
    private DoctorAppointmentService doctorAppointmentService;

    @Autowired
    private DoctorBookingService doctorBookingService;

    @Autowired
    private in.sp.main.Repository.DoctorChatRepository doctorChatRepo;

    @Autowired
    private org.springframework.messaging.simp.SimpMessagingTemplate messagingTemplate;

    @Autowired
    private in.sp.main.Repository.UserRepository userRepo;

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
            d.setPassword(passwordService.encode(password));
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

            doctorRegistrationService.initializeLegacyRegisteredDoctor(d);

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
        Doctor candidate = dOpt.get();
        boolean ok = passwordService.matchesAndUpgrade(password, candidate.getPassword(), hashed -> {
            candidate.setPassword(hashed);
            doctorRepo.save(candidate);
        });
        if (!ok) {
            model.addAttribute("error", "Invalid password.");
            return "doctor/doctor-login";
        }

        Doctor d;
        try {
            d = doctorRegistrationService.requireLoginDoctor(candidate);
        } catch (org.springframework.web.server.ResponseStatusException ex) {
            model.addAttribute("error", ex.getReason() == null ? "Unable to login." : ex.getReason());
            return "doctor/doctor-login";
        }

        // Clear conflicting user session so doctor chat/calls use doctor role, not leftover user session
        session.removeAttribute("user");
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
                            @RequestParam(required = false) Long userId,
                            HttpSession session, Model model) {
        Doctor d = (Doctor) session.getAttribute("loggedDoctor");
        if (d == null) return "redirect:/doctors/login";

        d = doctorRepo.findById(d.getId()).orElse(d);
        doctorProfileService.refreshCompletion(d);
        doctorRepo.save(d);
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

        // Notification badge: unseen pending appointments (clears after viewing appointments)
        @SuppressWarnings("unchecked")
        java.util.Set<Long> seenFromSession =
                (java.util.Set<Long>) session.getAttribute("doctorSeenPendingAppointmentIds");
        final java.util.Set<Long> seenPendingIds =
                seenFromSession != null ? seenFromSession : new java.util.HashSet<>();
        java.util.List<Long> currentPendingIds = appts.stream()
                .filter(a -> a.getStatus() == DoctorAppointmentStatus.PENDING)
                .map(DoctorAppointment::getId)
                .toList();
        long appointmentNotifCount = currentPendingIds.stream()
                .filter(id -> !seenPendingIds.contains(id))
                .count();
        if ("appointments".equals(section)) {
            seenPendingIds.addAll(currentPendingIds);
            session.setAttribute("doctorSeenPendingAppointmentIds", seenPendingIds);
            appointmentNotifCount = 0;
        }
        model.addAttribute("appointmentNotifCount", appointmentNotifCount);

        // Unread chat messages from patients (build list before marking read)
        java.util.List<in.sp.main.Entities.DoctorChatMessage> unreadMsgs =
                doctorChatRepo.findByDoctorAndSenderTypeAndReadByDoctorFalse(d, "USER");
        long unreadChatCount = unreadMsgs.size();

        // Notification messages for bell dropdown
        java.util.List<java.util.Map<String, String>> notifications = new java.util.ArrayList<>();
        for (DoctorAppointment a : appts) {
            if (a.getStatus() == DoctorAppointmentStatus.PENDING
                    && a.getId() != null
                    && !seenPendingIds.contains(a.getId())) {
                java.util.Map<String, String> n = new java.util.LinkedHashMap<>();
                n.put("type", "appointment");
                n.put("icon", "bi-calendar-plus");
                n.put("title", "New appointment request");
                String patient = a.getUser() != null && a.getUser().getFullName() != null
                        ? a.getUser().getFullName() : "Patient";
                n.put("body", patient + (a.getAppointmentTime() != null ? " · " + a.getAppointmentTime() : ""));
                n.put("href", "/doctors/dashboard?section=appointments");
                notifications.add(n);
            }
        }
        java.util.LinkedHashMap<Long, in.sp.main.Entities.DoctorChatMessage> latestUnreadByUser =
                new java.util.LinkedHashMap<>();
        for (in.sp.main.Entities.DoctorChatMessage msg : unreadMsgs) {
            if (msg.getUser() != null && msg.getUser().getId() != null) {
                latestUnreadByUser.putIfAbsent(msg.getUser().getId(), msg);
            }
        }
        for (in.sp.main.Entities.DoctorChatMessage msg : latestUnreadByUser.values()) {
            java.util.Map<String, String> n = new java.util.LinkedHashMap<>();
            n.put("type", "chat");
            n.put("icon", "bi-chat-dots-fill");
            n.put("title", "New patient message");
            String patient = msg.getUser().getFullName() != null ? msg.getUser().getFullName() : "Patient";
            String preview = msg.getMessage() != null ? msg.getMessage() : "";
            if (preview.length() > 60) preview = preview.substring(0, 57) + "...";
            n.put("body", patient + (preview.isBlank() ? "" : " · " + preview));
            n.put("href", "/doctors/chat/" + d.getId() + "?userId=" + msg.getUser().getId());
            notifications.add(n);
        }
        model.addAttribute("notifications", notifications);

        if ("chats".equals(section) && unreadChatCount > 0) {
            for (in.sp.main.Entities.DoctorChatMessage msg : unreadMsgs) {
                msg.setReadByDoctor(true);
            }
            doctorChatRepo.saveAll(unreadMsgs);
            unreadChatCount = 0;
        }
        model.addAttribute("unreadChatCount", unreadChatCount);
        model.addAttribute("notificationCount", appointmentNotifCount + unreadChatCount);

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

            if (userId != null) {
                User targetUser = userRepo.findById(userId).orElse(null);
                model.addAttribute("targetUserId", userId);
                if (targetUser != null) {
                    model.addAttribute("targetUserName", targetUser.getFullName());
                    model.addAttribute("chatHistory", doctorChatRepo.findByUserAndDoctorOrderByTimestampAsc(targetUser, d));
                }
            }
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

    @PostMapping("/update-fees")
    public String updateFees(@RequestParam(required = false) Double consultationFee,
                             @RequestParam(required = false) Double chatFee,
                             @RequestParam(required = false) Double callFee,
                             @RequestParam(required = false) Double videoFee,
                             @RequestParam(required = false) String upiId,
                             @RequestParam(required = false) String bankDetails,
                             HttpSession session,
                             RedirectAttributes redirectAttributes) {
        Doctor d = (Doctor) session.getAttribute("loggedDoctor");
        if (d == null) return "redirect:/doctors/login";

        if (consultationFee != null && consultationFee < 0) {
            redirectAttributes.addFlashAttribute("error", "Consultation fee cannot be negative.");
            return "redirect:/doctors/dashboard?section=earnings";
        }
        if ((chatFee != null && chatFee < 0) || (callFee != null && callFee < 0) || (videoFee != null && videoFee < 0)) {
            redirectAttributes.addFlashAttribute("error", "Fees cannot be negative.");
            return "redirect:/doctors/dashboard?section=earnings";
        }

        d = doctorRepo.findById(d.getId()).orElse(d);
        if (consultationFee != null) d.setConsultationFee(consultationFee);
        d.setChatFee(chatFee);
        d.setCallFee(callFee);
        d.setVideoFee(videoFee);
        d.setUpiId(upiId != null ? upiId.trim() : null);
        d.setBankDetails(bankDetails != null ? bankDetails.trim() : null);

        doctorRepo.save(d);
        session.setAttribute("loggedDoctor", d);
        redirectAttributes.addFlashAttribute("message", "Fee breakdown and payment methods updated successfully!");
        return "redirect:/doctors/dashboard?section=earnings";
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

    @PostMapping("/update-earnings")
    public String updateEarnings(@RequestParam(required = false) Double consultationFee,
                                 @RequestParam(required = false) Double chatFee,
                                 @RequestParam(required = false) Double callFee,
                                 @RequestParam(required = false) Double videoFee,
                                 @RequestParam(required = false) String upiId,
                                 @RequestParam(required = false) String bankDetails,
                                 HttpSession session,
                                 RedirectAttributes redirectAttributes) {
        Doctor d = (Doctor) session.getAttribute("loggedDoctor");
        if (d == null) return "redirect:/doctors/login";

        d = doctorRepo.findById(d.getId()).orElse(d);
        if (consultationFee != null) d.setConsultationFee(consultationFee);
        if (chatFee != null) d.setChatFee(chatFee);
        if (callFee != null) d.setCallFee(callFee);
        if (videoFee != null) d.setVideoFee(videoFee);
        if (upiId != null) d.setUpiId(upiId);
        if (bankDetails != null) d.setBankDetails(bankDetails);

        doctorRepo.save(d);
        session.setAttribute("loggedDoctor", d);
        redirectAttributes.addFlashAttribute("message", "Fee breakdown updated successfully!");
        return "redirect:/doctors/dashboard?section=earnings";
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
            doctorAppointmentService.transitionByDoctor(appt, d, DoctorAppointmentStatus.valueOf(status));
            redirectAttributes.addFlashAttribute("message", "Status updated.");
        } catch (org.springframework.web.server.ResponseStatusException ex) {
            redirectAttributes.addFlashAttribute("message", ex.getReason());
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
        Doctor loggedDoctor = (Doctor) session.getAttribute("loggedDoctor");
        // Doctors browsing the directory must not be bounced to user login/dashboard
        if (u == null && loggedDoctor == null) return "redirect:/login";

        model.addAttribute("doctors", doctorRepo.findByVerificationStatus(VerificationStatus.VERIFIED));
        model.addAttribute("viewerIsDoctor", loggedDoctor != null && u == null);
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
                       @RequestParam(required = false, defaultValue = "CLINIC") String consultationType,
                       HttpSession session,
                       RedirectAttributes redirectAttributes) {
        User u = (User) session.getAttribute("user");
        if (u == null) return "redirect:/login";

        Doctor d = doctorRepo.findById(doctorId).orElse(null);
        if (d == null || d.getVerificationStatus() != VerificationStatus.VERIFIED) {
            redirectAttributes.addFlashAttribute("message", "Doctor not available.");
            return "redirect:/doctors/list";
        }




        try {
            ConsultationType cType;
            try {
                cType = ConsultationType.valueOf(consultationType.trim().toUpperCase());
            } catch (Exception ex) {
                cType = ConsultationType.CLINIC;
            }
            LocalDateTime when = LocalDateTime.parse(appointmentTime, DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
            double fee = doctorBookingService.resolveFee(d, cType);
            if (fee > 0) {
                redirectAttributes.addFlashAttribute("message",
                        "Payment required (₹" + (int) fee + "). Please book and pay from the doctor profile page.");
                return "redirect:/doctors/view/" + doctorId;
            }
            doctorBookingService.createRequestBooking(d, u, when, cType, reason, false);
            redirectAttributes.addFlashAttribute("message", "Appointment requested.");
            return "redirect:/doctors/myAppointments";
        } catch (org.springframework.web.server.ResponseStatusException ex) {
            redirectAttributes.addFlashAttribute("message",
                    ex.getReason() == null ? "Booking failed." : ex.getReason());
            return "redirect:/doctors/view/" + doctorId;
        } catch (Exception ex) {
            redirectAttributes.addFlashAttribute("message", "Invalid appointment time.");
            return "redirect:/doctors/view/" + doctorId;
        }

    }

    @GetMapping("/myAppointments")
    public String myAppointments(@RequestParam(required = false) String section,
                                 HttpSession session, Model model) {
        User u = (User) session.getAttribute("user");
        if (u == null) return "redirect:/login";

        model.addAttribute("appointments", appointmentRepo.findByUserOrderByAppointmentTimeDesc(u));
        model.addAttribute("section", section);
        return "doctor/my-appointments";
    }

    /** Authorized patient view of a prescription linked to their appointment. */
    @GetMapping("/appointments/{id}/prescription/view")
    public String viewOwnPrescription(@PathVariable Long id, HttpSession session, Model model,
                                      RedirectAttributes redirectAttributes) {
        User u = (User) session.getAttribute("user");
        if (u == null) return "redirect:/login";

        DoctorAppointment appt = appointmentRepo.findById(id).orElse(null);
        if (appt == null || appt.getUser() == null || !appt.getUser().getId().equals(u.getId())) {
            redirectAttributes.addFlashAttribute("error", "Prescription not found or access denied.");
            return "redirect:/doctors/myAppointments";
        }
        if (appt.getPrescriptionText() == null || appt.getPrescriptionText().isBlank()) {
            redirectAttributes.addFlashAttribute("error", "No prescription available for this appointment yet.");
            return "redirect:/doctors/myAppointments";
        }

        model.addAttribute("appointment", appt);
        return "doctor/prescription-view";
    }

    /** Authorized patient download of prescription as a plain-text file. */
    @GetMapping("/appointments/{id}/prescription/download")
    public ResponseEntity<byte[]> downloadOwnPrescription(@PathVariable Long id, HttpSession session) {
        User u = (User) session.getAttribute("user");
        if (u == null) {
            return ResponseEntity.status(401).build();
        }

        DoctorAppointment appt = appointmentRepo.findById(id).orElse(null);
        if (appt == null || appt.getUser() == null || !appt.getUser().getId().equals(u.getId())) {
            return ResponseEntity.status(403).build();
        }
        if (appt.getPrescriptionText() == null || appt.getPrescriptionText().isBlank()) {
            return ResponseEntity.notFound().build();
        }

        Doctor doc = appt.getDoctor();
        StringBuilder sb = new StringBuilder();
        sb.append("PRESCRIPTION\n");
        sb.append("============\n\n");
        sb.append("Doctor: ").append(doc != null ? doc.getFullName() : "—").append("\n");
        if (doc != null && doc.getSpecialization() != null) {
            sb.append("Specialization: ").append(doc.getSpecialization()).append("\n");
        }
        if (doc != null && doc.getHospitalName() != null) {
            sb.append("Hospital/Clinic: ").append(doc.getHospitalName()).append("\n");
        }
        sb.append("Patient: ").append(u.getFullName() != null ? u.getFullName() : "—").append("\n");
        sb.append("Appointment: ").append(appt.getAppointmentTime()).append("\n\n");
        sb.append("Rx:\n").append(appt.getPrescriptionText()).append("\n");

        byte[] body = sb.toString().getBytes(StandardCharsets.UTF_8);
        return ResponseEntity.ok()
                .header(HttpHeaders.CONTENT_DISPOSITION,
                        "attachment; filename=\"prescription-" + id + ".txt\"")
                .contentType(MediaType.TEXT_PLAIN)
                .body(body);
    }

    @PostMapping("/review")
    public String addReview(@RequestParam Long doctorId,
                            @RequestParam(required = false) Integer rating,
                            @RequestParam(required = false) String comment,
                            HttpSession session,
                            RedirectAttributes redirectAttributes) {
        User u = (User) session.getAttribute("user");
        if (u == null) return "redirect:/login";

        Doctor d = doctorRepo.findById(doctorId).orElse(null);
        if (d == null) return "redirect:/doctors/list";

        // No default rating — require an explicit user selection (1-5)
        if (rating == null || rating < 1 || rating > 5) {
            redirectAttributes.addFlashAttribute("error", "Please select a star rating before submitting your review.");
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
        double avg = reviews.stream()
                .map(DoctorReview::getRating)
                .filter(x -> x != null && x >= 1 && x <= 5)
                .mapToInt(Integer::intValue)
                .average()
                .orElse(0.0);
        d.setRating(avg);
        doctorRepo.save(d);

        redirectAttributes.addFlashAttribute("message", "Review submitted.");
        return "redirect:/doctors/view/" + doctorId;
    }

    // ==============================
    // Real-time: Chat, Video, Call
    // ==============================
    @GetMapping("/chat/{doctorId}")
    public String chatWithDoctor(@PathVariable Long doctorId, @RequestParam(required = false) Long userId, Model model, HttpSession session) {
        User u = (User) session.getAttribute("user");
        Doctor d = (Doctor) session.getAttribute("loggedDoctor");
        Doctor target = doctorRepo.findById(doctorId).orElse(null);
        if (target == null) return "redirect:/doctors/list";

        // Doctor owning this chat must win over a leftover user session (same browser / prior login)
        boolean doctorOwner = d != null && d.getId().equals(doctorId);

        if (doctorOwner) {
            model.addAttribute("currentUser", "Dr. " + d.getFullName());
            model.addAttribute("currentId", d.getId());
            model.addAttribute("senderType", "DOCTOR");
            if (userId != null) {
                User chatUser = userRepo.findById(userId).orElse(null);
                model.addAttribute("targetUserId", userId);
                if (chatUser != null) {
                    model.addAttribute("targetUserName", chatUser.getFullName());
                    model.addAttribute("chatHistory", doctorChatRepo.findByUserAndDoctorOrderByTimestampAsc(chatUser, target));
                    // Mark this patient's messages as read when doctor opens the chat
                    java.util.List<in.sp.main.Entities.DoctorChatMessage> unread =
                            doctorChatRepo.findByDoctorAndUserAndSenderTypeAndReadByDoctorFalse(target, chatUser, "USER");
                    if (!unread.isEmpty()) {
                        for (in.sp.main.Entities.DoctorChatMessage msg : unread) {
                            msg.setReadByDoctor(true);
                        }
                        doctorChatRepo.saveAll(unread);
                    }
                } else {
                    model.addAttribute("targetUserName", "Unknown Patient");
                    model.addAttribute("chatHistory", java.util.Collections.emptyList());
                }
            } else {
                model.addAttribute("chatHistory", java.util.Collections.emptyList());
            }
        } else if (u != null) {
            model.addAttribute("currentUser", u.getFullName());
            model.addAttribute("currentId", u.getId());
            model.addAttribute("senderType", "USER");
            model.addAttribute("targetUserId", u.getId());
            model.addAttribute("chatHistory", doctorChatRepo.findByUserAndDoctorOrderByTimestampAsc(u, target));
        } else if (d != null) {
            return "redirect:/doctors/dashboard";
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
            msg.setSenderType("USER");
            msg.setReadByDoctor(false);
        } else {
            Doctor d = (Doctor) session.getAttribute("loggedDoctor");
            if (d == null) return "NOT_LOGGED_IN";
            if (!d.getId().equals(doctorId)) return "ACCESS_DENIED";
            msg.setSenderType("DOCTOR");
            msg.setReadByDoctor(true);
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

        boolean doctorOwner = d != null && d.getId().equals(doctorId);
        String roomName = "safeher-doc-" + doctorId + "-" + System.currentTimeMillis();
        if (doctorOwner) {
            model.addAttribute("displayName", "Dr. " + d.getFullName());
            roomName = "safeher-doc-" + doctorId + "-user-" + (userId != null ? userId : 0);
        } else if (u != null) {
            model.addAttribute("displayName", u.getFullName());
            roomName = "safeher-doc-" + doctorId + "-user-" + u.getId();
        } else if (d != null) {
            return "redirect:/doctors/dashboard";
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

        boolean doctorOwner = d != null && d.getId().equals(doctorId);
        String roomName = "safeher-call-" + doctorId + "-" + System.currentTimeMillis();
        if (doctorOwner) {
            model.addAttribute("displayName", "Dr. " + d.getFullName());
            roomName = "safeher-call-" + doctorId + "-user-" + (userId != null ? userId : 0);
        } else if (u != null) {
            model.addAttribute("displayName", u.getFullName());
            roomName = "safeher-call-" + doctorId + "-user-" + u.getId();
        } else if (d != null) {
            return "redirect:/doctors/dashboard";
        } else {
            return "redirect:/login";
        }
        model.addAttribute("doctor", target);
        model.addAttribute("roomName", roomName);
        model.addAttribute("audioOnly", true);
        return "doctor/doctor-call";
    }

    private static final int PRESCRIPTION_MAX_LENGTH = 2000;

    @PostMapping("/appointments/{id}/prescription")
    public String savePrescription(@PathVariable Long id,
                                   @RequestParam String prescriptionText,
                                   HttpSession session,
                                   RedirectAttributes redirectAttributes) {
        Doctor d = (Doctor) session.getAttribute("loggedDoctor");
        if (d == null) return "redirect:/doctors/login";

        String text = prescriptionText == null ? "" : prescriptionText.trim();
        if (text.isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "Prescription text is required.");
            return "redirect:/doctors/dashboard?section=prescriptions";
        }
        if (text.length() > PRESCRIPTION_MAX_LENGTH) {
            redirectAttributes.addFlashAttribute("error",
                    "Prescription cannot exceed " + PRESCRIPTION_MAX_LENGTH + " characters.");
            return "redirect:/doctors/dashboard?section=prescriptions";
        }

        DoctorAppointment appt = appointmentRepo.findById(id).orElse(null);
        if (prescriptionText != null && prescriptionText.length() > 500) {
            redirectAttributes.addFlashAttribute("error", "Prescription cannot exceed 500 characters.");
            return "redirect:/doctors/dashboard?section=prescriptions";
        }
        if (appt != null && appt.getDoctor().getId().equals(d.getId())) {
            appt.setPrescriptionText(text);
            appointmentRepo.save(appt);
            redirectAttributes.addFlashAttribute("message", "Prescription saved successfully!");
        } else {
            redirectAttributes.addFlashAttribute("error", "Failed to save prescription.");
        }
        return "redirect:/doctors/dashboard?section=prescriptions";
    }
}
