package in.sp.main.Controller;

import in.sp.main.Config.JwtUtil;
import in.sp.main.Entities.ConsultationType;
import in.sp.main.Entities.Doctor;
import in.sp.main.Entities.DoctorAppointment;
import in.sp.main.Entities.DoctorAppointmentStatus;
import in.sp.main.Entities.Gender;
import in.sp.main.Entities.User;
import in.sp.main.Entities.VerificationStatus;
import in.sp.main.Repository.DoctorAppointmentRepository;
import in.sp.main.Repository.DoctorRepository;
import in.sp.main.Service.PasswordService;
import in.sp.main.Util.MobileValidation;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;

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
        d.setVerificationStatus(VerificationStatus.PENDING);
        d.setRating(0.0);
        d.setEmergencyAvailable(false);

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
        Doctor d = opt.get();
        boolean ok = passwordService.matchesAndUpgrade(password, d.getPassword(), hashed -> {
            d.setPassword(hashed);
            doctorRepo.save(d);
        });
        if (!ok) return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(error("Invalid password"));
        if (d.getVerificationStatus() != VerificationStatus.VERIFIED) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(error("Your account is pending admin verification"));
        }

        session.setAttribute("loggedDoctor", d);
        String token = jwtUtil.generateToken(d.getEmail(), "DOCTOR");
        Map<String, Object> res = new LinkedHashMap<>();
        res.put("success", true);
        res.put("token", token);
        res.put("tokenType", "Bearer");
        res.put("role", "DOCTOR");
        res.put("doctor", doctorSummary(d));
        return ResponseEntity.ok(res);
    }

    @GetMapping("/me")
    public ResponseEntity<Map<String, Object>> dashboard(HttpSession session) {
        Doctor d = requireDoctor(session);
        if (d == null) return unauthorized();
        d = doctorRepo.findById(d.getId()).orElse(d);

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
        for (DoctorAppointment a : appointments) {
            if (notifications.size() >= 12) break;
            Map<String, Object> n = new LinkedHashMap<>();
            String patient = a.getUser() != null && a.getUser().getFullName() != null
                    ? a.getUser().getFullName() : "Patient";
            if (a.getStatus() == DoctorAppointmentStatus.PENDING) {
                n.put("title", "New appointment booked");
                n.put("body", patient + " requested a consultation");
            } else if (a.getAmountPaid() != null && a.getAmountPaid() > 0) {
                n.put("title", "Payment received");
                n.put("body", "₹" + a.getAmountPaid().intValue() + " from " + patient);
            } else if (a.getPrescriptionText() != null && !a.getPrescriptionText().isBlank()) {
                n.put("title", "Prescription on file");
                n.put("body", "Rx saved for " + patient);
            } else {
                continue;
            }
            n.put("time", a.getAppointmentTime() == null ? null : a.getAppointmentTime().toString());
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
        data.put("online", d.getVerificationStatus() == VerificationStatus.VERIFIED);
        return ResponseEntity.ok(data);
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
        if (a == null || a.getDoctor() == null || !a.getDoctor().getId().equals(d.getId())) {
            return badRequest("Appointment not found");
        }
        String statusRaw = trim(body == null ? null : body.get("status")).toUpperCase(Locale.ROOT);
        DoctorAppointmentStatus status;
        try {
            status = DoctorAppointmentStatus.valueOf(statusRaw);
        } catch (Exception e) {
            return badRequest("Invalid appointment status");
        }
        a.setStatus(status);
        appointmentRepo.save(a);
        Map<String, Object> res = new LinkedHashMap<>();
        res.put("success", true);
        res.put("message", "Appointment updated");
        res.put("status", status.name());
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
        m.put("profilePhotoPath", d.getProfilePhotoPath());
        m.put("experienceYears", d.getExperienceYears());
        m.put("hospitalName", d.getHospitalName());
        return m;
    }
}
