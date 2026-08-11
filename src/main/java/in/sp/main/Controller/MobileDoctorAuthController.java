package in.sp.main.Controller;

import in.sp.main.Config.JwtUtil;
import in.sp.main.Entities.ConsultationType;
import in.sp.main.Entities.Doctor;
import in.sp.main.Entities.DoctorAppointment;
import in.sp.main.Entities.DoctorAppointmentStatus;
import in.sp.main.Entities.DoctorDocumentType;
import in.sp.main.Entities.DoctorProfileStatus;
import in.sp.main.Entities.Gender;
import in.sp.main.Entities.User;
import in.sp.main.Repository.DoctorAppointmentRepository;
import in.sp.main.Repository.DoctorRepository;
import in.sp.main.Service.DoctorAppointmentService;
import in.sp.main.Service.DoctorDocumentService;
import in.sp.main.Service.DoctorNotificationService;
import in.sp.main.Service.DoctorProfileService;
import in.sp.main.Service.DoctorRegistrationService;
import in.sp.main.Service.DoctorVerificationService;
import in.sp.main.Service.PasswordService;
import in.sp.main.Util.MobileValidation;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/api/doctors/provider")
public class MobileDoctorAuthController {

    @Autowired
    private DoctorRepository doctorRepo;
    @Autowired
    private DoctorAppointmentRepository appointmentRepo;
    @Autowired
    private PasswordService passwordService;
    @Autowired
    private JwtUtil jwtUtil;
    @Autowired
    private DoctorRegistrationService doctorRegistrationService;
    @Autowired
    private DoctorProfileService doctorProfileService;
    @Autowired
    private DoctorDocumentService doctorDocumentService;
    @Autowired
    private DoctorNotificationService doctorNotificationService;
    @Autowired
    private DoctorVerificationService doctorVerificationService;
    @Autowired
    private DoctorAppointmentService doctorAppointmentService;
    @Autowired
    private in.sp.main.Service.DoctorInstantConsultService instantConsultService;
    @Autowired
    private in.sp.main.Service.PushNotificationService pushNotificationService;
    @Autowired
    private in.sp.main.Repository.DoctorReviewRepository doctorReviewRepo;

    @PostMapping("/otp/send-email")
    public ResponseEntity<Map<String, Object>> sendEmailOtp(@RequestBody Map<String, String> body) {
        String email = trim(body == null ? null : body.get("email"));
        try {
            doctorRegistrationService.sendRegistrationOtp(email);
            Map<String, Object> res = new LinkedHashMap<>();
            res.put("success", true);
            res.put("message", "Verification code sent to your email");
            res.put("channel", "EMAIL");
            return ResponseEntity.ok(res);
        } catch (org.springframework.web.server.ResponseStatusException ex) {
            return ResponseEntity.status(ex.getStatusCode()).body(error(ex.getReason()));
        }
    }

    @PostMapping("/otp/verify-email")
    public ResponseEntity<Map<String, Object>> verifyEmailOtp(@RequestBody Map<String, String> body) {
        String email = trim(body == null ? null : body.get("email"));
        String otp = trim(body == null ? null : body.get("otp"));
        try {
            doctorRegistrationService.verifyRegistrationOtp(email, otp);
            Map<String, Object> res = new LinkedHashMap<>();
            res.put("success", true);
            res.put("message", "Email verified successfully");
            return ResponseEntity.ok(res);
        } catch (org.springframework.web.server.ResponseStatusException ex) {
            return ResponseEntity.status(ex.getStatusCode()).body(error(ex.getReason()));
        }
    }

    @PostMapping("/register-quick")
    public ResponseEntity<Map<String, Object>> registerQuick(@RequestBody Map<String, String> body) {
        try {
            Doctor d = doctorRegistrationService.registerQuick(
                    trim(body == null ? null : body.get("fullName")),
                    trim(body == null ? null : body.get("email")),
                    trim(body == null ? null : body.get("phone")),
                    body == null ? "" : body.getOrDefault("password", ""),
                    body == null ? "" : body.getOrDefault("confirmPassword", ""),
                    trim(body == null ? null : body.get("emailOtp")),
                    Boolean.parseBoolean(String.valueOf(body == null ? null : body.get("acceptedTerms"))));
            Map<String, Object> res = new LinkedHashMap<>();
            res.put("success", true);
            res.put("message", "Account created successfully. Complete your profile to continue.");
            res.put("doctorId", d.getId());
            res.put("doctorProfileStatus", d.getDoctorProfileStatus().name());
            res.put("profileCompletionPct", d.getProfileCompletionPct());
            return ResponseEntity.status(HttpStatus.CREATED).body(res);
        } catch (org.springframework.web.server.ResponseStatusException ex) {
            return ResponseEntity.status(ex.getStatusCode()).body(error(ex.getReason()));
        }
    }

    /**
     * @deprecated Use {@link #registerQuick(Map)} for new mobile registrations.
     */
    @PostMapping("/register")
    public ResponseEntity<Map<String, Object>> register(@RequestBody Map<String, String> body) {
        String fullName = trim(body == null ? null : body.get("fullName"));
        String email = MobileValidation.normalizeEmail(body == null ? null : body.get("email"));
        String phone = trim(body == null ? null : body.get("phone"));
        String password = body == null ? "" : body.getOrDefault("password", "");
        String confirmPassword = body == null ? "" : body.getOrDefault("confirmPassword", "");
        String specialization = trim(body == null ? null : body.get("specialization"));
        String qualification = trim(body == null ? null : body.get("qualification"));
        String city = trim(body == null ? null : body.get("city"));
        String feeRaw = trim(body == null ? null : body.get("consultationFee"));
        String medicalRegNumber = trim(body == null ? null : body.get("medicalRegNumber"));
        String medicalCouncil = trim(body == null ? null : body.get("medicalCouncil"));
        String hospitalName = trim(body == null ? null : body.get("hospitalName"));
        String clinicAddress = trim(body == null ? null : body.get("clinicAddress"));
        String googleMapLocation = trim(body == null ? null : body.get("googleMapLocation"));
        String locationText = trim(body == null ? null : body.get("locationText"));
        String experienceRaw = trim(body == null ? null : body.get("experienceYears"));
        String genderRaw = trim(body == null ? null : body.get("gender"));
        String consultationTypeRaw = trim(body == null ? null : body.get("consultationType"));
        String availableDays = trim(body == null ? null : body.get("availableDays"));
        String startTime = trim(body == null ? null : body.get("startTime"));
        String endTime = trim(body == null ? null : body.get("endTime"));
        String timeSlots = trim(body == null ? null : body.get("timeSlots"));
        String profilePhotoPath = trim(body == null ? null : body.get("profilePhotoPath"));
        String identityDocumentPath = trim(body == null ? null : body.get("identityDocumentPath"));
        String medicalLicensePath = trim(body == null ? null : body.get("medicalLicensePath"));
        String degreeCertificatePath = trim(body == null ? null : body.get("degreeCertificatePath"));

        if (fullName.isBlank() || specialization.isBlank() || qualification.isBlank()) {
            return badRequest("fullName, specialization and qualification are required");
        }
        if (medicalRegNumber.isBlank()) {
            return badRequest("Medical registration number is required");
        }
        String emailErr = MobileValidation.requireEmail(email);
        if (emailErr != null) return badRequest(emailErr);
        String phoneErr = MobileValidation.requirePhone(phone, true);
        if (phoneErr != null) return badRequest(phoneErr);
        String passErr = MobileValidation.requirePassword(password);
        if (passErr != null) return badRequest(passErr);
        String confirmErr = MobileValidation.requireConfirm(password, confirmPassword);
        if (confirmErr != null) return badRequest(confirmErr);
        if (doctorRepo.findByEmail(email).isPresent()) {
            return ResponseEntity.status(HttpStatus.CONFLICT).body(error("Email already registered"));
        }
        if (doctorRepo.findByPhone(phone).isPresent()) {
            return ResponseEntity.status(HttpStatus.CONFLICT).body(error("Phone number already registered"));
        }
        if (doctorRepo.findByMedicalRegNumber(medicalRegNumber).isPresent()) {
            return ResponseEntity.status(HttpStatus.CONFLICT)
                    .body(error("Medical registration number already registered"));
        }

        Doctor d = new Doctor();
        d.setFullName(fullName);
        d.setEmail(email);
        d.setPhone(phone);
        d.setPassword(passwordService.encode(password));
        d.setMedicalRegNumber(medicalRegNumber);
        d.setSpecialization(specialization);
        d.setQualification(qualification);
        d.setHospitalName(hospitalName.isBlank() ? null : hospitalName);
        d.setClinicAddress(clinicAddress.isBlank() ? null : clinicAddress);
        d.setCity(city.isBlank() ? null : city);
        d.setGoogleMapLocation(googleMapLocation.isBlank() ? null : googleMapLocation);
        d.setLocationText(locationText.isBlank()
                ? (city.isBlank() ? null : city)
                : (locationText.length() > 4000 ? locationText.substring(0, 4000) : locationText));
        if (!availableDays.isBlank()) {
            d.setAvailableDays(availableDays);
        }
        if (!timeSlots.isBlank()) {
            d.setStartTime(startTime.isBlank() ? timeSlots : startTime);
            d.setEndTime(endTime.isBlank() ? timeSlots : endTime);
        } else {
            d.setStartTime(startTime.isBlank() ? null : startTime);
            d.setEndTime(endTime.isBlank() ? null : endTime);
        }
        if (!medicalCouncil.isBlank()) {
            d.setBankDetails("Council: " + medicalCouncil); // lightweight metadata until dedicated column
        }
        d.setIdentityDocumentPath(identityDocumentPath.isBlank() ? "mobile-pending" : identityDocumentPath);
        d.setMedicalLicensePath(medicalLicensePath.isBlank() ? "mobile-pending" : medicalLicensePath);
        d.setDegreeCertificatePath(degreeCertificatePath.isBlank() ? "mobile-pending" : degreeCertificatePath);
        d.setProfilePhotoPath(profilePhotoPath.isBlank() ? null : profilePhotoPath);
        doctorRegistrationService.initializeLegacyRegisteredDoctor(d);

        try {
            if (!genderRaw.isBlank()) {
                d.setGender(Gender.valueOf(genderRaw.toUpperCase(Locale.ROOT)));
            } else {
                d.setGender(Gender.FEMALE);
            }
        } catch (Exception e) {
            d.setGender(Gender.FEMALE);
        }

        ConsultationType ctype = ConsultationType.CLINIC;
        if (!consultationTypeRaw.isBlank()) {
            try {
                ctype = ConsultationType.valueOf(consultationTypeRaw.toUpperCase(Locale.ROOT));
            } catch (Exception ignored) {
                ctype = ConsultationType.CLINIC;
            }
        }
        d.setConsultationType(ctype);

        if (!experienceRaw.isBlank()) {
            try {
                d.setExperienceYears(Integer.parseInt(experienceRaw));
            } catch (NumberFormatException e) {
                return badRequest("Invalid experienceYears");
            }
        }
        if (!feeRaw.isBlank()) {
            try {
                d.setConsultationFee(Double.parseDouble(feeRaw));
            } catch (NumberFormatException e) {
                return badRequest("Invalid consultationFee");
            }
        }

        doctorRepo.save(d);
        doctorProfileService.refreshCompletion(d);
        doctorRepo.save(d);

        Map<String, Object> res = new LinkedHashMap<>();
        res.put("success", true);
        res.put("message",
                "Doctor registration submitted successfully. Your profile and medical documents are under verification. You will be notified once your account is approved.");
        res.put("doctorId", d.getId());
        res.put("status", "PENDING");
        return ResponseEntity.status(HttpStatus.CREATED).body(res);
    }

    @PostMapping("/login")
    public ResponseEntity<Map<String, Object>> login(@RequestBody Map<String, String> body, HttpSession session) {
        String email = trim(body == null ? null : body.get("email")).toLowerCase(Locale.ROOT);
        String password = body == null ? "" : body.getOrDefault("password", "");
        if (email.isBlank() || password.isBlank()) return badRequest("Email and password are required");

        Optional<Doctor> opt = doctorRepo.findByEmail(email);
        if (opt.isEmpty()) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(error("Doctor not found"));
        }
        Doctor doctor = opt.get();
        boolean ok = passwordService.matchesAndUpgrade(password, doctor.getPassword(), hashed -> {
            doctor.setPassword(hashed);
            doctorRepo.save(doctor);
        });
        if (!ok) return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(error("Invalid password"));
        Doctor d;
        try {
            d = doctorRegistrationService.requireLoginDoctor(doctor);
        } catch (org.springframework.web.server.ResponseStatusException ex) {
            return ResponseEntity.status(ex.getStatusCode()).body(error(ex.getReason()));
        }

        session.setAttribute("loggedDoctor", d);
        String token = jwtUtil.generateToken(d.getEmail(), "DOCTOR");
        Map<String, Object> res = new LinkedHashMap<>();
        res.put("success", true);
        res.put("token", token);
        res.put("tokenType", "Bearer");
        res.put("role", "DOCTOR");
        res.put("doctor", doctorSummary(d));
        res.put("doctorProfileStatus", d.getDoctorProfileStatus() == null ? null : d.getDoctorProfileStatus().name());
        res.put("profileCompletionPct", d.getProfileCompletionPct());
        return ResponseEntity.ok(res);
    }

    @PostMapping("/logout")
    public ResponseEntity<Map<String, Object>> logout(HttpSession session) {
        if (session != null) {
            session.removeAttribute("loggedDoctor");
            try {
                session.invalidate();
            } catch (IllegalStateException ignored) {
            }
        }
        Map<String, Object> res = new LinkedHashMap<>();
        res.put("success", true);
        res.put("message", "Logged out successfully");
        return ResponseEntity.ok(res);
    }

    @GetMapping("/profile")
    public ResponseEntity<Map<String, Object>> profile(HttpSession session) {
        Doctor d = requireDoctor(session);
        if (d == null) return unauthorized();
        d = doctorRepo.findById(d.getId()).orElse(d);
        doctorProfileService.refreshCompletion(d);
        doctorRepo.save(d);
        Map<String, Object> res = new LinkedHashMap<>();
        res.put("success", true);
        res.put("profile", doctorProfileService.profilePayload(d));
        return ResponseEntity.ok(res);
    }

    @PutMapping("/profile")
    @Transactional
    public ResponseEntity<Map<String, Object>> updateProfile(
            @RequestBody Map<String, Object> body,
            HttpSession session) {
        Doctor d = requireDoctor(session);
        if (d == null) return unauthorized();
        d = doctorRepo.findById(d.getId()).orElse(d);
        try {
            doctorProfileService.updateProfile(d, body);
            doctorRepo.save(d);
            Map<String, Object> res = new LinkedHashMap<>();
            res.put("success", true);
            res.put("message", "Profile updated successfully");
            res.put("profile", doctorProfileService.profilePayload(d));
            return ResponseEntity.ok(res);
        } catch (org.springframework.web.server.ResponseStatusException ex) {
            return ResponseEntity.status(ex.getStatusCode()).body(error(ex.getReason()));
        }
    }

    @PostMapping("/documents/{type}")
    @Transactional
    public ResponseEntity<Map<String, Object>> uploadDocument(
            @PathVariable String type,
            @RequestParam("file") MultipartFile file,
            HttpSession session) {
        Doctor d = requireDoctor(session);
        if (d == null) return unauthorized();
        d = doctorRepo.findById(d.getId()).orElse(d);
        try {
            DoctorDocumentType docType = doctorDocumentService.parseType(type);
            String path = doctorDocumentService.uploadDocument(d, docType, file);
            doctorRepo.save(d);
            Map<String, Object> res = new LinkedHashMap<>();
            res.put("success", true);
            res.put("message", "Document uploaded successfully");
            res.put("documentType", docType.name());
            res.put("path", path);
            res.put("profileCompletionPct", d.getProfileCompletionPct());
            res.put("doctorProfileStatus", d.getDoctorProfileStatus() == null ? null : d.getDoctorProfileStatus().name());
            res.put("missingItems", doctorProfileService.missingItems(d));
            res.put("canSubmitForVerification", doctorProfileService.isReadyForVerification(d)
                    && d.getDoctorProfileStatus() != DoctorProfileStatus.PENDING_ADMIN_APPROVAL
                    && d.getDoctorProfileStatus() != DoctorProfileStatus.APPROVED
                    && d.getDoctorProfileStatus() != DoctorProfileStatus.SUSPENDED);
            res.put("profile", doctorProfileService.profilePayload(d));
            return ResponseEntity.ok(res);
        } catch (org.springframework.web.server.ResponseStatusException ex) {
            return ResponseEntity.status(ex.getStatusCode()).body(error(ex.getReason()));
        }
    }

    @DeleteMapping("/documents/{type}")
    @Transactional
    public ResponseEntity<Map<String, Object>> deleteDocument(
            @PathVariable String type,
            HttpSession session) {
        Doctor d = requireDoctor(session);
        if (d == null) return unauthorized();
        d = doctorRepo.findById(d.getId()).orElse(d);
        try {
            DoctorDocumentType docType = doctorDocumentService.parseType(type);
            doctorDocumentService.deleteDocument(d, docType);
            doctorRepo.save(d);
            Map<String, Object> res = new LinkedHashMap<>();
            res.put("success", true);
            res.put("message", "Document removed");
            res.put("profileCompletionPct", d.getProfileCompletionPct());
            res.put("doctorProfileStatus", d.getDoctorProfileStatus() == null ? null : d.getDoctorProfileStatus().name());
            res.put("missingItems", doctorProfileService.missingItems(d));
            res.put("profile", doctorProfileService.profilePayload(d));
            return ResponseEntity.ok(res);
        } catch (org.springframework.web.server.ResponseStatusException ex) {
            return ResponseEntity.status(ex.getStatusCode()).body(error(ex.getReason()));
        }
    }

    @PostMapping("/submit-verification")
    @Transactional
    public ResponseEntity<Map<String, Object>> submitForVerification(HttpSession session) {
        Doctor d = requireDoctor(session);
        if (d == null) return unauthorized();
        d = doctorRepo.findById(d.getId()).orElse(d);
        try {
            doctorRegistrationService.submitForVerification(d);
            Map<String, Object> res = new LinkedHashMap<>();
            res.put("success", true);
            res.put("message", d.getDoctorProfileStatus() == DoctorProfileStatus.APPROVED
                    ? "Profile changes submitted for admin re-verification"
                    : "Profile submitted for admin verification");
            res.put("doctorProfileStatus", d.getDoctorProfileStatus().name());
            res.put("doctorProfileStatusLabel", DoctorVerificationService.friendlyStatusLabel(d.getDoctorProfileStatus()));
            res.put("profile", doctorProfileService.profilePayload(d));
            return ResponseEntity.ok(res);
        } catch (org.springframework.web.server.ResponseStatusException ex) {
            return ResponseEntity.status(ex.getStatusCode()).body(error(ex.getReason()));
        }
    }

    @GetMapping("/notifications")
    public ResponseEntity<Map<String, Object>> notifications(HttpSession session) {
        Doctor d = requireDoctor(session);
        if (d == null) return unauthorized();
        Map<String, Object> res = new LinkedHashMap<>();
        res.put("success", true);
        res.put("notifications", doctorNotificationService.listForDoctor(d.getId()));
        res.put("unreadCount", doctorNotificationService.unreadCount(d.getId()));
        return ResponseEntity.ok(res);
    }

    @PostMapping("/notifications/read-all")
    @Transactional
    public ResponseEntity<Map<String, Object>> markNotificationsRead(HttpSession session) {
        Doctor d = requireDoctor(session);
        if (d == null) return unauthorized();
        doctorNotificationService.markAllRead(d.getId());
        Map<String, Object> res = new LinkedHashMap<>();
        res.put("success", true);
        res.put("message", "Notifications marked as read");
        return ResponseEntity.ok(res);
    }

    @GetMapping("/verification-history")
    public ResponseEntity<Map<String, Object>> verificationHistory(HttpSession session) {
        Doctor d = requireDoctor(session);
        if (d == null) return unauthorized();
        Map<String, Object> res = new LinkedHashMap<>();
        res.put("success", true);
        res.put("history", doctorVerificationService.history(d.getId()));
        return ResponseEntity.ok(res);
    }

    @GetMapping("/me")
    public ResponseEntity<Map<String, Object>> dashboard(HttpSession session) {
        Doctor d = requireDoctor(session);
        if (d == null) return unauthorized();
        d = doctorRepo.findById(d.getId()).orElse(d);
        doctorProfileService.refreshCompletion(d);
        doctorRepo.save(d);

        var appointments = appointmentRepo.findByDoctorOrderByAppointmentTimeDesc(d);
        java.time.LocalDate today = java.time.LocalDate.now();
        java.time.YearMonth thisMonth = java.time.YearMonth.now();

        var appointmentDtos = appointments.stream().map(a -> {
            Map<String, Object> m = new LinkedHashMap<>();
            m.put("id", a.getId());
            m.put("status", a.getStatus() == null ? null : a.getStatus().name());
            m.put("appointmentTime", a.getAppointmentTime() == null ? null : a.getAppointmentTime().toString());
            m.put("reason", a.getReason());
            m.put("consultationType", a.getConsultationType() == null ? null : a.getConsultationType().name());
            m.put("amountPaid", a.getAmountPaid());
            m.put("meetingRoomId", a.getMeetingRoomId());
            m.put("prescriptionText", a.getPrescriptionText());
            if (a.getUser() != null) {
                User u = a.getUser();
                m.put("userId", u.getId());
                m.put("clientName", u.getFullName());
                m.put("clientPhone", u.getPhoneNumber());
                m.put("patientId", "PAT" + u.getId());
                m.put("patientAge", u.getAge());
                m.put("patientGender", u.getGender() == null ? null : u.getGender().name());
            }
            return m;
        }).toList();

        long pendingCount = appointments.stream()
                .filter(a -> a.getStatus() == DoctorAppointmentStatus.PENDING).count();
        long confirmedCount = appointments.stream()
                .filter(a -> a.getStatus() == DoctorAppointmentStatus.CONFIRMED).count();
        long completedCount = appointments.stream()
                .filter(a -> a.getStatus() == DoctorAppointmentStatus.COMPLETED).count();
        long cancelledCount = appointments.stream()
                .filter(a -> a.getStatus() == DoctorAppointmentStatus.CANCELLED).count();

        long todayAppointments = appointments.stream()
                .filter(a -> a.getAppointmentTime() != null
                        && a.getAppointmentTime().toLocalDate().equals(today)
                        && a.getStatus() != DoctorAppointmentStatus.CANCELLED)
                .count();
        long todayPending = appointments.stream()
                .filter(a -> a.getAppointmentTime() != null
                        && a.getAppointmentTime().toLocalDate().equals(today)
                        && a.getStatus() == DoctorAppointmentStatus.PENDING)
                .count();
        long todayCompleted = appointments.stream()
                .filter(a -> a.getAppointmentTime() != null
                        && a.getAppointmentTime().toLocalDate().equals(today)
                        && a.getStatus() == DoctorAppointmentStatus.COMPLETED)
                .count();

        double totalEarnings = appointments.stream()
                .filter(a -> a.getAmountPaid() != null && a.getAmountPaid() > 0)
                .mapToDouble(DoctorAppointment::getAmountPaid)
                .sum();
        double todayEarnings = appointments.stream()
                .filter(a -> a.getAmountPaid() != null && a.getAmountPaid() > 0
                        && a.getAppointmentTime() != null
                        && a.getAppointmentTime().toLocalDate().equals(today))
                .mapToDouble(DoctorAppointment::getAmountPaid)
                .sum();
        double monthEarnings = appointments.stream()
                .filter(a -> a.getAmountPaid() != null && a.getAmountPaid() > 0
                        && a.getAppointmentTime() != null
                        && java.time.YearMonth.from(a.getAppointmentTime()).equals(thisMonth))
                .mapToDouble(DoctorAppointment::getAmountPaid)
                .sum();

        // Lightweight activity feed for the notifications sheet.
        List<Map<String, Object>> notifications = new java.util.ArrayList<>();
        for (Map<String, Object> n : doctorNotificationService.listForDoctor(d.getId())) {
            if (notifications.size() >= 12) break;
            notifications.add(n);
        }
        for (DoctorAppointment a : appointments) {
            if (notifications.size() >= 12) break;
            Map<String, Object> n = new LinkedHashMap<>();
            String patient = a.getUser() != null && a.getUser().getFullName() != null
                    ? a.getUser().getFullName() : "Patient";
            n.put("type", "APPOINTMENT");
            n.put("title", "Appointment update");
            n.put("message", patient + " — " + (a.getStatus() == null ? "updated" : a.getStatus().name()));
            n.put("createdAt", a.getAppointmentTime() == null ? null : a.getAppointmentTime().toString());
            n.put("read", true);
            notifications.add(n);
        }

        Map<String, Object> data = new LinkedHashMap<>();
        data.put("success", true);
        data.put("doctor", doctorSummary(d));
        data.put("appointments", appointmentDtos);
        data.put("appointmentCount", appointments.size());
        data.put("pendingCount", pendingCount);
        data.put("confirmedCount", confirmedCount);
        data.put("completedCount", completedCount);
        data.put("cancelledCount", cancelledCount);
        data.put("todayAppointments", todayAppointments);
        data.put("todayPending", todayPending);
        data.put("todayCompleted", todayCompleted);
        data.put("totalEarnings", totalEarnings);
        data.put("todayEarnings", todayEarnings);
        data.put("monthEarnings", monthEarnings);
        data.put("notifications", notifications);
        data.put("online", Boolean.TRUE.equals(d.getIsOnline()));
        data.put("doctorProfileStatus", d.getDoctorProfileStatus() == null ? null : d.getDoctorProfileStatus().name());
        data.put("doctorProfileStatusLabel", DoctorVerificationService.friendlyStatusLabel(d.getDoctorProfileStatus()));
        data.put("profileCompletionPct", d.getProfileCompletionPct() == null ? 0 : d.getProfileCompletionPct());
        data.put("missingItems", doctorProfileService.missingItems(d));
        data.put("canSubmitForVerification", doctorProfileService.canSubmitForVerification(d));
        data.put("hasPendingReverification", Boolean.TRUE.equals(d.getHasPendingReverification()));
        data.put("nextStepGuidance", doctorProfileService.nextStepGuidance(d));
        data.put("changesRequestedNote", d.getChangesRequestedNote());
        data.put("rejectionReason", d.getRejectionReason());
        data.put("unreadNotificationCount", doctorNotificationService.unreadCount(d.getId()));
        return ResponseEntity.ok(data);
    }

    @PostMapping("/online")
    @Transactional
    public ResponseEntity<Map<String, Object>> setOnline(
            @RequestBody Map<String, Object> body,
            HttpSession session) {
        Doctor d = requireDoctor(session);
        if (d == null) return unauthorized();
        d = doctorRepo.findById(d.getId()).orElse(d);
        boolean online = body != null && Boolean.parseBoolean(String.valueOf(body.getOrDefault("online", false)));
        d.setIsOnline(online);
        d.setLastSeenAt(java.time.LocalDateTime.now());
        doctorRepo.save(d);
        Map<String, Object> res = new LinkedHashMap<>();
        res.put("success", true);
        res.put("online", online);
        res.put("lastSeenAt", d.getLastSeenAt().toString());
        res.put("message", online ? "You are now online" : "You are now offline");
        return ResponseEntity.ok(res);
    }

    @GetMapping("/instant/pending")
    public ResponseEntity<Map<String, Object>> instantPending(HttpSession session) {
        Doctor d = requireDoctor(session);
        if (d == null) return unauthorized();
        var list = instantConsultService.pendingForDoctor(d).stream().map(r -> {
            Map<String, Object> m = new LinkedHashMap<>();
            m.put("id", r.getId());
            m.put("userId", r.getUserId());
            m.put("status", r.getStatus());
            m.put("consultationType", r.getConsultationType());
            m.put("reason", r.getReason());
            m.put("expiresAt", r.getExpiresAt() == null ? null : r.getExpiresAt().toString());
            return m;
        }).toList();
        Map<String, Object> res = new LinkedHashMap<>();
        res.put("success", true);
        res.put("requests", list);
        return ResponseEntity.ok(res);
    }

    @PostMapping("/instant/{id}/accept")
    public ResponseEntity<Map<String, Object>> instantAccept(@PathVariable Long id, HttpSession session) {
        Doctor d = requireDoctor(session);
        if (d == null) return unauthorized();
        try {
            DoctorAppointment appt = instantConsultService.accept(d, id);
            Map<String, Object> res = new LinkedHashMap<>();
            res.put("success", true);
            res.put("message", "Instant consult accepted");
            if (appt != null) {
                res.put("appointmentId", appt.getId());
                res.put("status", appt.getStatus() == null ? null : appt.getStatus().name());
                res.put("appointmentTime", appt.getAppointmentTime() == null ? null : appt.getAppointmentTime().toString());
                res.put("paymentStatus", appt.getPaymentStatus());
                res.put("paymentRequired", "PENDING_PAYMENT".equals(appt.getPaymentStatus()));
            }
            return ResponseEntity.ok(res);
        } catch (org.springframework.web.server.ResponseStatusException ex) {
            return ResponseEntity.status(ex.getStatusCode())
                    .body(Map.of("success", false, "error", ex.getReason() == null ? "Failed" : ex.getReason()));
        }
    }

    @PostMapping("/instant/{id}/decline")
    public ResponseEntity<Map<String, Object>> instantDecline(@PathVariable Long id, HttpSession session) {
        Doctor d = requireDoctor(session);
        if (d == null) return unauthorized();
        try {
            instantConsultService.decline(d, id);
            return ResponseEntity.ok(Map.of("success", true, "message", "Request declined"));
        } catch (org.springframework.web.server.ResponseStatusException ex) {
            return ResponseEntity.status(ex.getStatusCode())
                    .body(Map.of("success", false, "error", ex.getReason() == null ? "Failed" : ex.getReason()));
        }
    }

    @PostMapping("/device-token")
    public ResponseEntity<Map<String, Object>> doctorDeviceToken(
            @RequestBody Map<String, String> body,
            HttpSession session) {
        Doctor d = requireDoctor(session);
        if (d == null) return unauthorized();
        pushNotificationService.registerDoctorToken(d, body == null ? null : body.get("token"));
        return ResponseEntity.ok(Map.of("success", true, "message", "Device token registered"));
    }

    @GetMapping("/analytics")
    public ResponseEntity<Map<String, Object>> analytics(HttpSession session) {
        Doctor d = requireDoctor(session);
        if (d == null) return unauthorized();
        d = doctorRepo.findById(d.getId()).orElse(d);
        var appointments = appointmentRepo.findByDoctorOrderByAppointmentTimeDesc(d);
        java.time.LocalDate today = java.time.LocalDate.now();
        java.time.YearMonth thisMonth = java.time.YearMonth.now();

        long completed = appointments.stream().filter(a -> a.getStatus() == DoctorAppointmentStatus.COMPLETED).count();
        long cancelled = appointments.stream().filter(a -> a.getStatus() == DoctorAppointmentStatus.CANCELLED).count();
        long pending = appointments.stream().filter(a -> a.getStatus() == DoctorAppointmentStatus.PENDING).count();
        long confirmed = appointments.stream().filter(a -> a.getStatus() == DoctorAppointmentStatus.CONFIRMED).count();
        double totalEarnings = appointments.stream()
                .filter(a -> a.getAmountPaid() != null && a.getAmountPaid() > 0)
                .mapToDouble(DoctorAppointment::getAmountPaid).sum();
        double monthEarnings = appointments.stream()
                .filter(a -> a.getAmountPaid() != null && a.getAmountPaid() > 0
                        && a.getAppointmentTime() != null
                        && java.time.YearMonth.from(a.getAppointmentTime()).equals(thisMonth))
                .mapToDouble(DoctorAppointment::getAmountPaid).sum();
        double todayEarnings = appointments.stream()
                .filter(a -> a.getAmountPaid() != null && a.getAmountPaid() > 0
                        && a.getAppointmentTime() != null
                        && a.getAppointmentTime().toLocalDate().equals(today))
                .mapToDouble(DoctorAppointment::getAmountPaid).sum();

        Map<String, Object> res = new LinkedHashMap<>();
        res.put("success", true);
        res.put("totalAppointments", appointments.size());
        res.put("pendingCount", pending);
        res.put("confirmedCount", confirmed);
        res.put("completedCount", completed);
        res.put("cancelledCount", cancelled);
        res.put("completionRate", appointments.isEmpty() ? 0
                : Math.round(100.0 * completed / appointments.size()));
        res.put("totalEarnings", totalEarnings);
        res.put("monthEarnings", monthEarnings);
        res.put("todayEarnings", todayEarnings);
        res.put("rating", d.getRating() == null ? 0 : d.getRating());
        res.put("online", Boolean.TRUE.equals(d.getIsOnline()));
        return ResponseEntity.ok(res);
    }

    @GetMapping("/reviews")
    public ResponseEntity<Map<String, Object>> myReviews(HttpSession session) {
        Doctor d = requireDoctor(session);
        if (d == null) return unauthorized();
        List<Map<String, Object>> reviews = doctorReviewRepo.findByDoctorIdOrderByCreatedAtDesc(d.getId()).stream()
                .map(r -> {
                    Map<String, Object> m = new LinkedHashMap<>();
                    m.put("id", r.getId());
                    m.put("rating", r.getRating());
                    m.put("comment", r.getComment());
                    m.put("createdAt", r.getCreatedAt() == null ? null : r.getCreatedAt().toString());
                    if (r.getUser() != null) m.put("userName", r.getUser().getFullName());
                    return m;
                })
                .toList();
        Map<String, Object> res = new LinkedHashMap<>();
        res.put("success", true);
        res.put("reviews", reviews);
        res.put("count", reviews.size());
        res.put("rating", d.getRating() == null ? 0 : d.getRating());
        return ResponseEntity.ok(res);
    }

    @PostMapping("/appointments/{id}/status")
    @Transactional
    public ResponseEntity<Map<String, Object>> updateAppointmentStatus(
            @PathVariable Long id,
            @RequestBody Map<String, String> body,
            HttpSession session) {
        Doctor d = requireDoctor(session);
        if (d == null) return unauthorized();
        DoctorAppointment a = appointmentRepo.findById(id).orElse(null);
        if (a == null) {
            return badRequest("Appointment not found");
        }
        String statusRaw = trim(body == null ? null : body.get("status")).toUpperCase(Locale.ROOT);
        DoctorAppointmentStatus status;
        try {
            status = DoctorAppointmentStatus.valueOf(statusRaw);
        } catch (Exception e) {
            return badRequest("Invalid appointment status");
        }
        try {
            a = doctorAppointmentService.transitionByDoctor(a, d, status);
        } catch (org.springframework.web.server.ResponseStatusException ex) {
            return ResponseEntity.status(ex.getStatusCode()).body(error(ex.getReason()));
        }
        Map<String, Object> res = new LinkedHashMap<>();
        res.put("success", true);
        res.put("message", "Appointment updated");
        res.put("status", a.getStatus().name());
        return ResponseEntity.ok(res);
    }

    @PostMapping("/appointments/{id}/prescription")
    @Transactional
    public ResponseEntity<Map<String, Object>> savePrescription(
            @PathVariable Long id,
            @RequestBody Map<String, String> body,
            HttpSession session) {
        Doctor d = requireDoctor(session);
        if (d == null) return unauthorized();
        DoctorAppointment a = appointmentRepo.findById(id).orElse(null);
        if (a == null || a.getDoctor() == null || !a.getDoctor().getId().equals(d.getId())) {
            return badRequest("Appointment not found");
        }
        String text = trim(body == null ? null : body.get("prescriptionText"));
        if (text.isBlank()) return badRequest("prescriptionText is required");
        a.setPrescriptionText(text);
        appointmentRepo.save(a);
        Map<String, Object> res = new LinkedHashMap<>();
        res.put("success", true);
        res.put("message", "Prescription saved");
        return ResponseEntity.ok(res);
    }

    private Doctor requireDoctor(HttpSession session) {
        Object d = session == null ? null : session.getAttribute("loggedDoctor");
        return d instanceof Doctor ? (Doctor) d : null;
    }

    private ResponseEntity<Map<String, Object>> unauthorized() {
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(error("Doctor login required"));
    }

    private ResponseEntity<Map<String, Object>> badRequest(String error) {
        return ResponseEntity.badRequest().body(error(error));
    }

    private static Map<String, Object> error(String msg) {
        Map<String, Object> out = new LinkedHashMap<>();
        out.put("success", false);
        out.put("error", msg);
        return out;
    }

    private static String trim(String value) {
        return value == null ? "" : value.trim();
    }

    private Map<String, Object> doctorSummary(Doctor d) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", d.getId());
        m.put("fullName", d.getFullName());
        m.put("email", d.getEmail());
        m.put("phone", d.getPhone());
        m.put("specialization", d.getSpecialization());
        m.put("qualification", d.getQualification());
        m.put("city", d.getCity());
        m.put("consultationFee", d.getConsultationFee());
        m.put("consultationType", d.getConsultationType() == null ? null : d.getConsultationType().name());
        m.put("rating", d.getRating() != null ? d.getRating() : 0.0);
        m.put("verificationStatus", d.getVerificationStatus() == null ? null : d.getVerificationStatus().name());
        m.put("doctorProfileStatus", d.getDoctorProfileStatus() == null ? null : d.getDoctorProfileStatus().name());
        m.put("profileCompletionPct", d.getProfileCompletionPct() == null ? 0 : d.getProfileCompletionPct());
        m.put("profilePhotoPath", d.getProfilePhotoPath());
        m.put("experienceYears", d.getExperienceYears());
        m.put("hospitalName", d.getHospitalName());
        m.put("isOnline", Boolean.TRUE.equals(d.getIsOnline()));
        m.put("lastSeenAt", d.getLastSeenAt() == null ? null : d.getLastSeenAt().toString());
        m.put("emergencyAvailable", Boolean.TRUE.equals(d.getEmergencyAvailable()));
        return m;
    }
}
