package in.sp.main.Controller;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
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
import org.springframework.web.server.ResponseStatusException;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import in.sp.main.Entities.ConsultationType;
import in.sp.main.Entities.Doctor;
import in.sp.main.Entities.DoctorAppointment;
import in.sp.main.Entities.DoctorAppointmentStatus;
import in.sp.main.Entities.DoctorDocumentType;
import in.sp.main.Entities.DoctorProfileStatus;
import in.sp.main.Entities.DoctorReview;
import in.sp.main.Entities.Gender;
import in.sp.main.Entities.User;
import in.sp.main.Entities.VerificationStatus;
import in.sp.main.Repository.DoctorAppointmentRepository;
import in.sp.main.Repository.DoctorRepository;
import in.sp.main.Repository.DoctorReviewRepository;
import in.sp.main.Service.DoctorAppointmentService;
import in.sp.main.Service.DoctorBookingService;
import in.sp.main.Service.DoctorDocumentService;
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

    @Autowired
    private DoctorDocumentService doctorDocumentService;

    /** One-time post-registration login autofill (server session only; never localStorage). */
    private static final String DOCTOR_PREFILL_EMAIL = "doctorRegPrefillEmail";
    private static final String DOCTOR_PREFILL_PASSWORD = "doctorRegPrefillPassword";
  private static final String DOCTOR_PREFILL_AT = "doctorRegPrefillAt";
    private static final String DOCTOR_REG_SUCCESS_NAME = "doctorRegSuccessName";
    private static final long DOCTOR_PREFILL_TTL_MS = 10L * 60L * 1000L;

    // ==============================
    // Doctor Registration + Login
    // ==============================
    @GetMapping("/register")
    public String registerPage(@RequestParam(value = "success", required = false) String success,
                               HttpSession session,
                               Model model) {
        if ("1".equals(success) || "true".equalsIgnoreCase(success)) {
            Object name = session.getAttribute(DOCTOR_REG_SUCCESS_NAME);
            if (name != null) {
                model.addAttribute("registrationSuccess", true);
                model.addAttribute("registeredName", name.toString());
                session.removeAttribute(DOCTOR_REG_SUCCESS_NAME);
                return "doctor/doctor-register";
            }
        }
        return "doctor/doctor-register";
    }

    /**
     * Web registration aligned with Mobile {@code register-quick}:
     * email OTP must already be verified; then create account via DoctorRegistrationService.
     */
    @PostMapping("/register")
    public String register(
            @RequestParam String fullName,
            @RequestParam String email,
    @RequestParam String phone,
            @RequestParam String password,
            @RequestParam String confirmPassword,
            @RequestParam(required = false) String acceptedTerms,
            HttpSession session,
            Model model) {

        boolean termsAccepted = "true".equalsIgnoreCase(acceptedTerms)
                || "on".equalsIgnoreCase(acceptedTerms)
                || "yes".equalsIgnoreCase(acceptedTerms)
                || "1".equals(acceptedTerms);

        try {
            Doctor d = doctorRegistrationService.registerQuick(
                    fullName,
                    email,
                    phone,
                    password,
                    confirmPassword,
                    null,
                    termsAccepted);

            // Short-lived server-side credential handoff for login autofill (one-time consume on login GET).
            session.setAttribute(DOCTOR_PREFILL_EMAIL, d.getEmail());
            session.setAttribute(DOCTOR_PREFILL_PASSWORD, password);
            session.setAttribute(DOCTOR_PREFILL_AT, System.currentTimeMillis());
            session.setAttribute(DOCTOR_REG_SUCCESS_NAME, d.getFullName());

            return "redirect:/doctors/register?success=1";
        } catch (ResponseStatusException ex) {
            model.addAttribute("error", ex.getReason() != null ? ex.getReason() : "Registration failed.");
            model.addAttribute("fullName", fullName);
            model.addAttribute("email", email);
            model.addAttribute("phone", phone);
            return "doctor/doctor-register";
        } catch (Exception ex) {
            model.addAttribute("error", "Registration failed. Please try again.");
            model.addAttribute("fullName", fullName);
            model.addAttribute("email", email);
            model.addAttribute("phone", phone);
            return "doctor/doctor-register";
        }
    }

    @GetMapping("/login")
    public String loginPage(HttpSession session, Model model) {
        consumeDoctorLoginPrefill(session, model);
        return "doctor/doctor-login";
    }

    @PostMapping("/login")
    public String login(@RequestParam String email,
                        @RequestParam String password,
                        HttpSession session,
                        jakarta.servlet.http.HttpServletResponse response,
                        Model model) {
        // Clear any leftover prefill so credentials are not reused after a failed attempt.
        clearDoctorLoginPrefill(session);

        Optional<Doctor> dOpt = doctorRepo.findByEmail(email.trim().toLowerCase(Locale.ROOT));
        if (dOpt.isEmpty()) {
            model.addAttribute("error", "Doctor not found.");
            model.addAttribute("prefillEmail", email);
            return "doctor/doctor-login";
        }
        Doctor candidate = dOpt.get();
        boolean ok = passwordService.matchesAndUpgrade(password, candidate.getPassword(), hashed -> {
            candidate.setPassword(hashed);
            doctorRepo.save(candidate);
        });
        if (!ok) {
            model.addAttribute("error", "Invalid password.");
            model.addAttribute("prefillEmail", email);
            return "doctor/doctor-login";
        }

        Doctor d;
        try {
            d = doctorRegistrationService.requireLoginDoctor(candidate);
        } catch (ResponseStatusException ex) {
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

        if (needsProfileCompletion(d)) {
            return "redirect:/doctors/profile-completion";
        }
        return "redirect:/doctors/dashboard";
    }


    @GetMapping("/profile-completion")
    public String profileCompletion(org.springframework.ui.Model model, HttpSession session) {

    // ==============================
    // Profile completion (onboarding)
    // ==============================
    @GetMapping("/profile-completion")
    public String profileCompletionPage(HttpSession session, Model model, RedirectAttributes redirectAttributes) {
        Doctor d = requireLoggedDoctor(session);
        if (d == null) {
            return "redirect:/doctors/login";
        }
        d = doctorRepo.findById(d.getId()).orElse(d);
        doctorProfileService.refreshCompletion(d);
        doctorRepo.save(d);
        session.setAttribute("loggedDoctor", d);

        model.addAttribute("doctor", d);
        model.addAttribute("profile", doctorProfileService.profilePayload(d));
        model.addAttribute("profileCompletionPct", d.getProfileCompletionPct() == null ? 0 : d.getProfileCompletionPct());
        model.addAttribute("missingItems", doctorProfileService.missingItems(d));
        model.addAttribute("statusLabel",
                in.sp.main.Service.DoctorVerificationService.friendlyStatusLabel(d.getDoctorProfileStatus()));
        model.addAttribute("nextStepGuidance", doctorProfileService.nextStepGuidance(d));
        return "doctor/doctor-profile-completion";
    }

    @PostMapping("/profile-completion")
    public String saveProfileCompletion(
            @RequestParam String fullName,
            @RequestParam(required = false) String phone,
            @RequestParam(required = false) String gender,
            @RequestParam(required = false) String specialization,
            @RequestParam(required = false) String qualification,
            @RequestParam(required = false) Integer experienceYears,
            @RequestParam(required = false) String medicalRegNumber,
            @RequestParam(required = false) String hospitalName,
            @RequestParam(required = false) List<String> consultationModes,
            @RequestParam(required = false) String consultationType,
            @RequestParam(required = false) List<String> availableDays,
            @RequestParam(required = false) String startTime,
            @RequestParam(required = false) String endTime,
            @RequestParam(required = false) String emergencyAvailable,
            @RequestParam(required = false) String clinicAddress,
            @RequestParam(required = false) String city,
            @RequestParam(required = false) String state,
            @RequestParam(required = false) String pincode,
            @RequestParam(required = false) String googleMapLocation,
            @RequestParam(required = false) String languages,
            @RequestParam(required = false) String services,
            @RequestParam(required = false) String bio,
            @RequestParam(required = false) Double consultationFee,
            @RequestParam(required = false) Double chatFee,
            @RequestParam(required = false) Double callFee,
            @RequestParam(required = false) Double videoFee,
            @RequestParam(required = false) String upiId,
            @RequestParam(required = false) String bankDetails,
            @RequestParam(required = false) MultipartFile profilePhoto,
            @RequestParam(required = false) MultipartFile medicalLicense,
            @RequestParam(required = false) MultipartFile idProof,
            @RequestParam(required = false) MultipartFile degreeCertificate,
            HttpSession session,
            RedirectAttributes redirectAttributes) {

        Doctor d = requireLoggedDoctor(session);
        if (d == null) {
            return "redirect:/doctors/login";
        }
        d = doctorRepo.findById(d.getId()).orElse(d);

        try {
            Map<String, Object> body = new LinkedHashMap<>();
            body.put("fullName", fullName);
            if (phone != null) body.put("phone", phone);
            if (specialization != null) body.put("specialization", specialization);
            if (qualification != null) body.put("qualification", qualification);
            if (experienceYears != null) body.put("experienceYears", experienceYears);
            if (medicalRegNumber != null) body.put("medicalRegNumber", medicalRegNumber);
            if (hospitalName != null) body.put("hospitalName", hospitalName);
            if (clinicAddress != null) body.put("clinicAddress", clinicAddress);
            if (city != null) body.put("city", city);
            if (state != null) body.put("state", state);
            if (pincode != null) body.put("pincode", pincode);
            if (googleMapLocation != null) body.put("googleMapLocation", googleMapLocation);
            if (languages != null) body.put("languages", languages);
            if (services != null) body.put("services", services);
            if (bio != null) body.put("bio", bio);
            if (consultationFee != null) body.put("consultationFee", consultationFee);
            if (chatFee != null) body.put("chatFee", chatFee);
            if (callFee != null) body.put("callFee", callFee);
            if (videoFee != null) body.put("videoFee", videoFee);
            if (upiId != null) body.put("upiId", upiId);
            if (bankDetails != null) body.put("bankDetails", bankDetails);
            body.put("emergencyAvailable", "yes".equalsIgnoreCase(emergencyAvailable) || "true".equalsIgnoreCase(emergencyAvailable) || "on".equalsIgnoreCase(emergencyAvailable));

            if (consultationModes != null && !consultationModes.isEmpty()) {
                body.put("consultationModes", consultationModes);
            } else if (consultationType != null && !consultationType.isBlank()) {
                body.put("consultationType", consultationType);
            }
            if (availableDays != null && !availableDays.isEmpty()) {
                body.put("availableDays", String.join(",", availableDays));
            }
            if (startTime != null) body.put("startTime", startTime);
            if (endTime != null) body.put("endTime", endTime);

            doctorProfileService.updateProfile(d, body);

            if (gender != null && !gender.isBlank() && d.getDoctorProfileStatus() != DoctorProfileStatus.APPROVED) {
                try {
                    d.setGender(Gender.valueOf(gender.trim().toUpperCase(Locale.ROOT)));
                } catch (IllegalArgumentException ignored) {
                    // keep existing gender
                }
            }

            uploadOptionalDoc(d, profilePhoto, DoctorDocumentType.PROFILE_PHOTO);
            uploadOptionalDoc(d, idProof, DoctorDocumentType.GOVERNMENT_ID);
            uploadOptionalDoc(d, medicalLicense, DoctorDocumentType.MEDICAL_LICENSE);
            uploadOptionalDoc(d, degreeCertificate, DoctorDocumentType.MEDICAL_REGISTRATION);

            doctorProfileService.refreshCompletion(d);
            doctorRepo.save(d);
            session.setAttribute("loggedDoctor", d);
            redirectAttributes.addFlashAttribute("message", "Profile updated successfully.");
            return "redirect:/doctors/dashboard";
        } catch (ResponseStatusException ex) {
            redirectAttributes.addFlashAttribute("error", ex.getReason() != null ? ex.getReason() : "Unable to save profile.");
            return "redirect:/doctors/profile-completion";
        } catch (Exception ex) {
            redirectAttributes.addFlashAttribute("error", "Unable to save profile. Please try again.");
            return "redirect:/doctors/profile-completion";
        }
    }

    @GetMapping("/profile-completion/skip")
    public String skipProfileCompletion(HttpSession session, RedirectAttributes redirectAttributes) {
        Doctor d = requireLoggedDoctor(session);
        if (d == null) {
            return "redirect:/doctors/login";
        }
        // Skip does not mark fields complete and does not destroy unsaved form data (nothing posted).
        redirectAttributes.addFlashAttribute("message", "You can complete your profile anytime from My Profile.");
        return "redirect:/doctors/dashboard";
    }

    private void uploadOptionalDoc(Doctor d, MultipartFile file, DoctorDocumentType type) {
        if (file == null || file.isEmpty()) {
            return;
        }
        doctorDocumentService.uploadDocument(d, type, file);
    }

    private Doctor requireLoggedDoctor(HttpSession session) {
        Object d = session == null ? null : session.getAttribute("loggedDoctor");
        return d instanceof Doctor ? (Doctor) d : null;
    }

    private static boolean needsProfileCompletion(Doctor d) {
        if (d == null) {
            return true;
        }
        DoctorProfileStatus status = d.getDoctorProfileStatus();
        if (status == null) {
            return true;
        }
        return status == DoctorProfileStatus.REGISTERED
                || status == DoctorProfileStatus.PROFILE_INCOMPLETE
                || status == DoctorProfileStatus.READY_FOR_VERIFICATION
                || status == DoctorProfileStatus.CHANGES_REQUESTED
                || status == DoctorProfileStatus.REJECTED;
    }

    private void consumeDoctorLoginPrefill(HttpSession session, Model model) {
        if (session == null) {
            return;
        }
        Object atObj = session.getAttribute(DOCTOR_PREFILL_AT);
        long at = 0L;
        if (atObj instanceof Long l) {
            at = l;
        } else if (atObj instanceof Number n) {
            at = n.longValue();
        }
        boolean expired = at <= 0L || (System.currentTimeMillis() - at) > DOCTOR_PREFILL_TTL_MS;

        Object email = session.getAttribute(DOCTOR_PREFILL_EMAIL);
        Object password = session.getAttribute(DOCTOR_PREFILL_PASSWORD);
        // Always clear after consume attempt (one-time).
        clearDoctorLoginPrefill(session);

        if (expired || email == null) {
            return;
        }
        model.addAttribute("prefillEmail", email.toString());
        if (password != null) {
            model.addAttribute("prefillPassword", password.toString());
        }
        model.addAttribute("prefillFromRegistration", true);
    }

    private void clearDoctorLoginPrefill(HttpSession session) {
        if (session == null) {
            return;
        }
        session.removeAttribute(DOCTOR_PREFILL_EMAIL);
        session.removeAttribute(DOCTOR_PREFILL_PASSWORD);
        session.removeAttribute(DOCTOR_PREFILL_AT);
    }

    @GetMapping("/dashboard")
    public String dashboard(@RequestParam(value = "section", defaultValue = "overview") String section,
                            @RequestParam(value = "userId", required = false) Long userId,
                            Model model, HttpSession session, RedirectAttributes redirectAttributes) {

        Doctor d = (Doctor) session.getAttribute("loggedDoctor");
        if (d == null) return "redirect:/doctors/login";
        d = doctorRepo.findById(d.getId()).orElse(d);

        

        session.setAttribute("loggedDoctor", d);

        // Incomplete / pending doctors may open the dashboard after Skip (Mobile-aligned).
        // Profile completion remains available via /doctors/profile-completion and My Profile.

        doctorProfileService.refreshCompletion(d);
        model.addAttribute("doctor", d);

        
        int totalFields = 15;
        int completedFields = 0;
        if (d.getFullName() != null && !d.getFullName().trim().isEmpty()) completedFields++;
        if (d.getPhone() != null && !d.getPhone().trim().isEmpty()) completedFields++;
        if (d.getGender() != null) completedFields++;
        if (d.getProfilePhotoPath() != null && !d.getProfilePhotoPath().trim().isEmpty()) completedFields++;
        if (d.getMedicalRegNumber() != null && !d.getMedicalRegNumber().trim().isEmpty()) completedFields++;
        if (d.getSpecialization() != null && !d.getSpecialization().trim().isEmpty()) completedFields++;
        if (d.getExperienceYears() != null) completedFields++;
        if (d.getIdProofPath() != null && !d.getIdProofPath().trim().isEmpty()) completedFields++;
        
        int completionPercentage = (completedFields * 100) / totalFields;
        model.addAttribute("profileCompletion", completionPercentage);
        
        return "doctor/doctor-profile-completion";

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

        // Profile Completion — same calculator as Mobile / DoctorProfileService (13 fields)
        int completionPercentage = doctorProfileService.calculateCompletionPct(d);
        model.addAttribute("profileCompletion", completionPercentage);
        model.addAttribute("missingItems", doctorProfileService.missingItems(d));

        return "doctor/doctor-dashboard";

    }

    @PostMapping("/profile-completion")
    public String submitProfileCompletion(
            @RequestParam String fullName,
            @RequestParam String phone,
            @RequestParam(required = false) String gender,
            @RequestParam(required = false) String specialization,
            @RequestParam(required = false) Integer experienceYears,
            @RequestParam(required = false) String medicalRegNumber,
            @RequestParam(required = false) String qualification,
            @RequestParam(required = false) String hospitalName,
            @RequestParam(required = false) Double consultationFee,
            @RequestParam(required = false) org.springframework.web.multipart.MultipartFile profilePhoto,
            @RequestParam(required = false) org.springframework.web.multipart.MultipartFile medicalLicense,
            @RequestParam(required = false) String action,
            HttpSession session, org.springframework.web.servlet.mvc.support.RedirectAttributes redirectAttributes) {
        
        Doctor d = (Doctor) session.getAttribute("loggedDoctor");
        if (d == null) return "redirect:/doctors/login";
        
        
        
        d = doctorRepo.findById(d.getId()).orElse(d);
        
        try {
<<<<<<< HEAD
            if (profilePhoto != null && !profilePhoto.isEmpty()) d.setProfilePhotoPath(fileUploadService.saveFile(profilePhoto));
            if (medicalLicense != null && !medicalLicense.isEmpty()) d.setMedicalLicensePath(fileUploadService.saveFile(medicalLicense));
        } catch (Exception e) {}
        
        d.setFullName(fullName);
        d.setPhone(phone);
        if (gender != null) d.setGender(in.sp.main.Entities.Gender.valueOf(gender));
        d.setSpecialization(specialization);
        d.setExperienceYears(experienceYears);
        d.setMedicalRegNumber(medicalRegNumber);
        d.setQualification(qualification);
        d.setHospitalName(hospitalName);
                if (consultationFee != null) d.setConsultationFee(consultationFee);
        
        int pct = doctorProfileService.calculateCompletionPct(d);
        d.setProfileCompletionPct(pct);
        
        if (pct == 100) {
            d.setDoctorProfileStatus(in.sp.main.Entities.DoctorProfileStatus.PENDING_ADMIN_APPROVAL);
            d.setVerificationStatus(in.sp.main.Entities.VerificationStatus.PENDING);
=======
            if (profilePhoto != null && !profilePhoto.isEmpty()) {
                doctorDocumentService.uploadDocument(d, DoctorDocumentType.PROFILE_PHOTO, profilePhoto);
            }
            if (medicalLicense != null && !medicalLicense.isEmpty()) {
                doctorDocumentService.uploadDocument(d, DoctorDocumentType.MEDICAL_LICENSE, medicalLicense);
            }
            if (idProof != null && !idProof.isEmpty()) {
                doctorDocumentService.uploadDocument(d, DoctorDocumentType.GOVERNMENT_ID, idProof);
            }
            if (degreeCertificate != null && !degreeCertificate.isEmpty()) {
                doctorDocumentService.uploadDocument(d, DoctorDocumentType.MEDICAL_REGISTRATION, degreeCertificate);
            }
        } catch (ResponseStatusException e) {
            redirectAttributes.addFlashAttribute("error", e.getReason() != null ? e.getReason() : "Error uploading files.");
            return "redirect:/doctors/dashboard?section=profile";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Error uploading files.");
            return "redirect:/doctors/dashboard?section=profile";
        }

        try {
            Map<String, Object> body = new LinkedHashMap<>();
            body.put("fullName", fullName);
            body.put("phone", phone);
            if (specialization != null) body.put("specialization", specialization);
            if (qualification != null) body.put("qualification", qualification);
            if (experienceYears != null) body.put("experienceYears", experienceYears);
            if (medicalRegNumber != null) body.put("medicalRegNumber", medicalRegNumber);
            if (hospitalName != null) body.put("hospitalName", hospitalName);
            if (consultationType != null) body.put("consultationType", consultationType);
            if (availableDays != null && !availableDays.isEmpty()) {
                body.put("availableDays", String.join(",", availableDays));
            }
            if (startTime != null) body.put("startTime", startTime);
            if (endTime != null) body.put("endTime", endTime);
            body.put("emergencyAvailable", "yes".equalsIgnoreCase(emergencyAvailable));
            if (clinicAddress != null) body.put("clinicAddress", clinicAddress);
            if (city != null) body.put("city", city);
            if (state != null) body.put("state", state);
            if (pincode != null) body.put("pincode", pincode);
            if (googleMapLocation != null) body.put("googleMapLocation", googleMapLocation);
            if (consultationFee != null) body.put("consultationFee", consultationFee);
            if (chatFee != null) body.put("chatFee", chatFee);
            if (callFee != null) body.put("callFee", callFee);
            if (videoFee != null) body.put("videoFee", videoFee);
            if (upiId != null) body.put("upiId", upiId);

            doctorProfileService.updateProfile(d, body);
            if (gender != null && !gender.isBlank() && d.getDoctorProfileStatus() != DoctorProfileStatus.APPROVED) {
                try {
                    d.setGender(Gender.valueOf(gender));
                } catch (IllegalArgumentException ignored) {
                }
            }
            doctorProfileService.refreshCompletion(d);
            doctorRepo.save(d);
            session.setAttribute("loggedDoctor", d);
            redirectAttributes.addFlashAttribute("message", "Profile updated successfully!");
            return "redirect:/doctors/dashboard?section=profile";
        } catch (ResponseStatusException e) {
            redirectAttributes.addFlashAttribute("error", e.getReason() != null ? e.getReason() : "Unable to update profile.");
            return "redirect:/doctors/dashboard?section=profile";
        }
    }

    @PostMapping("/submit-for-verification")
    public String submitForVerification(HttpSession session, RedirectAttributes redirectAttributes) {
        Doctor d = (Doctor) session.getAttribute("loggedDoctor");
        if (d == null) return "redirect:/doctors/login";

        d = doctorRepo.findById(d.getId()).orElse(d);
        try {
            doctorRegistrationService.submitForVerification(d);
            session.setAttribute("loggedDoctor", d);
            redirectAttributes.addFlashAttribute("message",
                    "Your profile has been submitted successfully. Your profile is currently being verified by the admin.");
        } catch (ResponseStatusException ex) {
            redirectAttributes.addFlashAttribute("error",
                    ex.getReason() != null ? ex.getReason() : "Unable to submit for verification.");
        }
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
>>>>>>> 16cf85ce996ab1a16542e394dc5bd4bcae6a13f5
        }
        
        doctorRepo.save(d);
        session.setAttribute("loggedDoctor", d);
        redirectAttributes.addFlashAttribute("message", "Profile details saved successfully.");
        return "redirect:/doctors/dashboard";
    }

    @PostMapping("/toggle-online")
    public String toggleOnline(HttpSession session) {
        Doctor d = (Doctor) session.getAttribute("loggedDoctor");
        if (d != null) {
            d = doctorRepo.findById(d.getId()).orElse(d);
            d.setIsOnline(d.getIsOnline() != null && d.getIsOnline() ? false : true);
            doctorRepo.save(d);
            session.setAttribute("loggedDoctor", d);
        }
        return "redirect:/doctors/dashboard";
    }

    @PostMapping("/update-availability")
    public String updateAvailability(@RequestParam String availableDays, @RequestParam String startTime, @RequestParam String endTime, HttpSession session, org.springframework.web.servlet.mvc.support.RedirectAttributes attrs) {
        Doctor d = (Doctor) session.getAttribute("loggedDoctor");
        if (d != null) {
            d = doctorRepo.findById(d.getId()).orElse(d);
            d.setAvailableDays(availableDays);
            d.setStartTime(startTime);
            d.setEndTime(endTime);
            doctorRepo.save(d);
            session.setAttribute("loggedDoctor", d);
            attrs.addFlashAttribute("message", "Availability updated successfully.");
        }
        return "redirect:/doctors/dashboard";
    }

    @GetMapping("/dashboard")
    public String dashboard(@RequestParam(value = "section", defaultValue = "overview") String section, HttpSession session, org.springframework.ui.Model model) {
        Doctor d = (Doctor) session.getAttribute("loggedDoctor");
        if (d == null) return "redirect:/doctors/login";
        
        final Doctor finalD = doctorRepo.findById(d.getId()).orElse(d);
        d = finalD;
        session.setAttribute("loggedDoctor", d);
        
        model.addAttribute("doctor", d);
        model.addAttribute("section", section);

        // Fetch all appointments for the doctor
        java.util.List<in.sp.main.Entities.DoctorAppointment> allAppts = appointmentRepo.findByDoctorOrderByAppointmentTimeDesc(d);
        
        if ("overview".equals(section)) {
            java.time.LocalDate today = java.time.LocalDate.now();
            
            // Filter today's appointments
            java.util.List<in.sp.main.Entities.DoctorAppointment> todayAppts = allAppts.stream()
                .filter(a -> a.getAppointmentTime() != null && a.getAppointmentTime().toLocalDate().equals(today))
                .collect(java.util.stream.Collectors.toList());
            
            model.addAttribute("todayAppointments", todayAppts);
            
            // Stats
            long upcomingCount = todayAppts.stream().filter(a -> a.getStatus() == in.sp.main.Entities.DoctorAppointmentStatus.PENDING || a.getStatus() == in.sp.main.Entities.DoctorAppointmentStatus.CONFIRMED).count();
            long completedCount = todayAppts.stream().filter(a -> a.getStatus() == in.sp.main.Entities.DoctorAppointmentStatus.COMPLETED).count();
            long cancelledCount = todayAppts.stream().filter(a -> a.getStatus() == in.sp.main.Entities.DoctorAppointmentStatus.CANCELLED).count();
            
            model.addAttribute("todayTotal", todayAppts.size());
            model.addAttribute("upcomingCount", upcomingCount);
            model.addAttribute("completedCount", completedCount);
            model.addAttribute("cancelledCount", cancelledCount);
            
            // Unique Patients
            long totalPatients = allAppts.stream().map(a -> a.getUser().getId()).distinct().count();
            model.addAttribute("totalPatients", totalPatients);
            
            // Consultations this month
            java.time.YearMonth currentMonth = java.time.YearMonth.now();
            long consultationsThisMonth = allAppts.stream()
                .filter(a -> a.getStatus() == in.sp.main.Entities.DoctorAppointmentStatus.COMPLETED)
                .filter(a -> a.getAppointmentTime() != null && java.time.YearMonth.from(a.getAppointmentTime()).equals(currentMonth))
                .count();
            model.addAttribute("consultationsThisMonth", consultationsThisMonth);
            
            // Earnings this month
            double earningsThisMonth = allAppts.stream()
                .filter(a -> a.getStatus() == in.sp.main.Entities.DoctorAppointmentStatus.COMPLETED)
                .filter(a -> a.getAppointmentTime() != null && java.time.YearMonth.from(a.getAppointmentTime()).equals(currentMonth))
                .mapToDouble(a -> finalD.getConsultationFee() != null ? finalD.getConsultationFee() : 0.0)
                .sum();
            model.addAttribute("earningsThisMonth", earningsThisMonth);
        } else if ("appointments".equals(section)) {
            model.addAttribute("appointments", allAppts);
        }

        return "doctor/doctor-dashboard";
    }

    @PostMapping("/upload-certificate")
    public String uploadCertificate(@RequestParam("certificate") org.springframework.web.multipart.MultipartFile file, HttpSession session, org.springframework.web.servlet.mvc.support.RedirectAttributes redirectAttributes) {
        Doctor d = (Doctor) session.getAttribute("loggedDoctor");
        if (d == null) return "redirect:/doctors/login";

        if (file != null && !file.isEmpty()) {
            try {
                String filePath = fileUploadService.saveFile(file);
                d = doctorRepo.findById(d.getId()).orElse(d);
                d.setMedicalLicensePath(filePath);
                
                // Certificate uploaded, awaiting admin review
                d.setDoctorProfileStatus(in.sp.main.Entities.DoctorProfileStatus.PENDING_ADMIN_APPROVAL);
                d.setVerificationStatus(in.sp.main.Entities.VerificationStatus.PENDING);
                
                doctorRepo.save(d);
                session.setAttribute("loggedDoctor", d);
                redirectAttributes.addFlashAttribute("message", "Certificate uploaded successfully. Your profile is now verified!");
            } catch (Exception e) {
                redirectAttributes.addFlashAttribute("message", "Failed to upload certificate.");
            }
        }
        return "redirect:/doctors/dashboard";
    }

    @PostMapping("/appointments/{id}/status")
    public String updateAppointmentStatus(@PathVariable Long id, @RequestParam String status, HttpSession session, org.springframework.web.servlet.mvc.support.RedirectAttributes redirectAttributes) {
        Doctor d = (Doctor) session.getAttribute("loggedDoctor");
        if (d == null) return "redirect:/doctors/login";

        in.sp.main.Entities.DoctorAppointment appt = appointmentRepo.findById(id).orElse(null);
        if (appt != null && appt.getDoctor() != null && appt.getDoctor().getId().equals(d.getId())) {
            appt.setStatus(in.sp.main.Entities.DoctorAppointmentStatus.valueOf(status));
            appointmentRepo.save(appt);
            redirectAttributes.addFlashAttribute("message", "Appointment status updated to " + status);
        }
        return "redirect:/doctors/dashboard";
    }

    @GetMapping("/list")
    public String listForUsers(Model model, HttpSession session) {
        User u = (User) session.getAttribute("user");
        Doctor loggedDoctor = (Doctor) session.getAttribute("loggedDoctor");
        // Doctors browsing the directory must not be bounced to user login/dashboard
        if (u == null && loggedDoctor == null) return "redirect:/login";

        List<Doctor> allVerified = doctorRepo.findByVerificationStatus(VerificationStatus.VERIFIED);
        if (loggedDoctor != null) {
            allVerified = allVerified.stream()
                    .filter(d -> !d.getId().equals(loggedDoctor.getId()))
                    .collect(java.util.stream.Collectors.toList());
        }
        
        model.addAttribute("doctors", allVerified);
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




























