package in.sp.main.Service;

import java.time.LocalDateTime;
import java.util.Comparator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import in.sp.main.Entities.ConsultationType;
import in.sp.main.Entities.Doctor;
import in.sp.main.Entities.DoctorAppointment;
import in.sp.main.Entities.DoctorInstantRequest;
import in.sp.main.Entities.User;
import in.sp.main.Entities.VerificationStatus;
import in.sp.main.Repository.DoctorInstantRequestRepository;
import in.sp.main.Repository.DoctorRepository;

@Service
public class DoctorInstantConsultService {

    private static final int OFFER_TTL_MINUTES = 5;

    @Autowired
    private DoctorRepository doctorRepository;

    @Autowired
    private DoctorInstantRequestRepository instantRequestRepository;

    @Autowired
    private DoctorBookingService bookingService;

    @Autowired
    private DoctorNotificationService notificationService;

    @Autowired
    private PushNotificationService pushNotificationService;

    @Autowired
    private in.sp.main.Repository.UserRepository userRepository;

    @Autowired
    private in.sp.main.Repository.DoctorAppointmentRepository appointmentRepository;

    @Transactional
    public Map<String, Object> requestInstant(User user, String consultationType, String reason) {
        expireStale();
        List<Doctor> online = doctorRepository.findByVerificationStatus(VerificationStatus.VERIFIED).stream()
                .filter(d -> Boolean.TRUE.equals(d.getIsOnline()) && Boolean.TRUE.equals(d.getEmergencyAvailable()))
                .sorted(Comparator.comparing(d -> d.getLastSeenAt() == null ? LocalDateTime.MIN : d.getLastSeenAt(),
                        Comparator.reverseOrder()))
                .toList();
        if (online.isEmpty()) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "No doctors available for instant consult right now");
        }

        DoctorInstantRequest req = new DoctorInstantRequest();
        req.setUserId(user.getId());
        req.setStatus("QUEUED");
        req.setConsultationType(consultationType == null || consultationType.isBlank() ? "VIDEO" : consultationType);
        req.setReason(reason);
        req.setCreatedAt(LocalDateTime.now());
        req.setExpiresAt(LocalDateTime.now().plusMinutes(OFFER_TTL_MINUTES));
        req = instantRequestRepository.save(req);

        // Offer to first available doctor
        Doctor doctor = online.get(0);
        req.setDoctorId(doctor.getId());
        req.setStatus("OFFERED");
        req = instantRequestRepository.save(req);

        notificationService.notifyDoctor(
                doctor,
                "INSTANT_CONSULT",
                "Instant consult request",
                (user.getFullName() == null ? "A patient" : user.getFullName())
                        + " needs an instant consult (#" + req.getId() + ").",
                true);
        pushNotificationService.notifyDoctor(
                doctor,
                "Instant consult",
                "New instant consult request #" + req.getId(),
                Map.of("type", "INSTANT_CONSULT", "requestId", String.valueOf(req.getId())));

        Map<String, Object> out = new LinkedHashMap<>();
        out.put("requestId", req.getId());
        out.put("status", req.getStatus());
        out.put("doctorId", doctor.getId());
        out.put("doctorName", doctor.getFullName());
        out.put("expiresAt", req.getExpiresAt().toString());
        ConsultationType cType;
        try {
            cType = ConsultationType.valueOf(
                    (req.getConsultationType() == null ? "VIDEO" : req.getConsultationType()).trim().toUpperCase());
        } catch (Exception ex) {
            cType = ConsultationType.VIDEO;
        }
        out.put("fee", bookingService.resolveFee(doctor, cType));
        return out;
    }

    @Transactional
    public DoctorAppointment accept(Doctor doctor, Long requestId) {
        expireStale();
        DoctorInstantRequest req = instantRequestRepository.findById(requestId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Request not found"));
        if (!doctor.getId().equals(req.getDoctorId())) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "Not your request");
        }
        if (!"OFFERED".equals(req.getStatus())) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Request is not offerable");
        }
        User patient = userRepository.findById(req.getUserId())
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Patient not found"));

        ConsultationType cType;
        try {
            cType = ConsultationType.valueOf(
                    (req.getConsultationType() == null ? "VIDEO" : req.getConsultationType()).trim().toUpperCase());
        } catch (Exception ex) {
            cType = ConsultationType.VIDEO;
        }

        // Hold a near-term slot (≥15 min so payment create-order validation still passes)
        LocalDateTime when = LocalDateTime.now().plusMinutes(20)
                .withSecond(0).withNano(0);
        DoctorAppointment appt = bookingService.createRequestBooking(
                doctor, patient, when, cType, req.getReason(), true);
        double fee = bookingService.resolveFee(doctor, cType);
        appt.setPaymentStatus(fee > 0 ? "PENDING_PAYMENT" : "NOT_REQUIRED");
        appt = appointmentRepository.save(appt);

        req.setStatus("ACCEPTED");
        req.setRespondedAt(LocalDateTime.now());
        req.setAppointmentId(appt.getId());
        instantRequestRepository.save(req);

        pushNotificationService.notifyUser(
                patient.getId(),
                "Doctor accepted your instant consult",
                "Appointment #" + appt.getId() + " is ready"
                        + (fee > 0 ? ". Please complete payment." : "."),
                Map.of("type", "INSTANT_ACCEPTED", "appointmentId", String.valueOf(appt.getId())));
        return appt;
    }

    @Transactional
    public void decline(Doctor doctor, Long requestId) {
        DoctorInstantRequest req = instantRequestRepository.findById(requestId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Request not found"));
        if (!doctor.getId().equals(req.getDoctorId())) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "Not your request");
        }
        req.setStatus("DECLINED");
        req.setRespondedAt(LocalDateTime.now());
        instantRequestRepository.save(req);
    }

    public List<DoctorInstantRequest> pendingForDoctor(Doctor doctor) {
        expireStale();
        return instantRequestRepository.findByDoctorIdAndStatusOrderByCreatedAtAsc(doctor.getId(), "OFFERED");
    }

    private void expireStale() {
        LocalDateTime now = LocalDateTime.now();
        for (DoctorInstantRequest r : instantRequestRepository.findByStatusOrderByCreatedAtAsc("OFFERED")) {
            if (r.getExpiresAt() != null && r.getExpiresAt().isBefore(now)) {
                r.setStatus("EXPIRED");
                instantRequestRepository.save(r);
            }
        }
        for (DoctorInstantRequest r : instantRequestRepository.findByStatusOrderByCreatedAtAsc("QUEUED")) {
            if (r.getExpiresAt() != null && r.getExpiresAt().isBefore(now)) {
                r.setStatus("EXPIRED");
                instantRequestRepository.save(r);
            }
        }
    }
}
