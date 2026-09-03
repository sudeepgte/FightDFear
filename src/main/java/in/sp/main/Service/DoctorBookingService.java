package in.sp.main.Service;

import java.time.DayOfWeek;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import in.sp.main.Entities.ConsultationType;
import in.sp.main.Entities.Doctor;
import in.sp.main.Entities.DoctorAppointment;
import in.sp.main.Entities.DoctorAppointmentStatus;
import in.sp.main.Entities.DoctorProfileStatus;
import in.sp.main.Entities.User;
import in.sp.main.Entities.VerificationStatus;
import in.sp.main.Repository.DoctorAppointmentRepository;

@Service
public class DoctorBookingService {

    private static final DateTimeFormatter TIME_FMT = DateTimeFormatter.ofPattern("HH:mm");
    private static final ObjectMapper MAPPER = new ObjectMapper();

    @Autowired
    private DoctorAppointmentRepository appointmentRepository;

    @Autowired
    private DoctorAppointmentService appointmentService;

    @Autowired
    private DoctorNotificationService notificationService;

    @Autowired
    private DoctorPaymentService doctorPaymentService;

    @Autowired
    private PushNotificationService pushNotificationService;

    public void requireBookableDoctor(Doctor doctor) {
        if (doctor == null) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Doctor not found");
        }
        if (doctor.getDoctorProfileStatus() == DoctorProfileStatus.SUSPENDED) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Doctor is not available for booking");
        }
        if (doctor.getVerificationStatus() != VerificationStatus.VERIFIED
                && doctor.getDoctorProfileStatus() != DoctorProfileStatus.APPROVED) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Doctor is not available for booking");
        }
    }

    public double resolveFee(Doctor doctor, ConsultationType type) {
        if (doctor == null) {
            return 0;
        }
        ConsultationType mode = type == null ? ConsultationType.CLINIC : type;
        Double fee = switch (mode) {
            case VIDEO -> doctor.getVideoFee() != null ? doctor.getVideoFee()
                    : (doctor.getCallFee() != null ? doctor.getCallFee() : doctor.getConsultationFee());
            case ONLINE -> doctor.getChatFee() != null ? doctor.getChatFee() : doctor.getConsultationFee();
            case OFFLINE, CLINIC, BOTH -> doctor.getConsultationFee();
        };
        return fee == null ? 0 : Math.max(0, fee);
    }

    public void validateAppointmentSlot(Doctor doctor, LocalDateTime appointmentTime) {
        if (appointmentTime == null) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Appointment time is required");
        }
        if (appointmentTime.isBefore(LocalDateTime.now().plusMinutes(15))) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Appointment time must be at least 15 minutes from now");
        }

        DayOfWeek dow = appointmentTime.getDayOfWeek();
        LocalTime slot = appointmentTime.toLocalTime();
        List<Map<String, String>> daySlots = matchingDaySlots(doctor, dow);
        if (!daySlots.isEmpty()) {
            boolean inside = daySlots.stream().anyMatch(s -> {
                LocalTime start = parseTime(s.get("start"));
                LocalTime end = parseTime(s.get("end"));
                return start != null && end != null && !slot.isBefore(start) && slot.isBefore(end);
            });
            if (!inside) {
                throw new ResponseStatusException(HttpStatus.BAD_REQUEST,
                        "Selected time is outside doctor working hours on " + dow.name());
            }
        } else {
            String availableDays = doctor.getAvailableDays();
            if (availableDays != null && !availableDays.isBlank()) {
                Set<String> days = Arrays.stream(availableDays.split(","))
                        .map(s -> s.trim().toUpperCase(Locale.ROOT))
                        .filter(s -> !s.isEmpty())
                        .collect(Collectors.toSet());
                if (!days.isEmpty() && !days.contains(dow.name())) {
                    throw new ResponseStatusException(HttpStatus.BAD_REQUEST,
                            "Doctor is not available on " + dow.name());
                }
            }
            LocalTime start = parseTime(doctor.getStartTime());
            LocalTime end = parseTime(doctor.getEndTime());
            if (start != null && end != null) {
                if (slot.isBefore(start) || !slot.isBefore(end)) {
                    throw new ResponseStatusException(HttpStatus.BAD_REQUEST,
                            "Selected time is outside doctor working hours ("
                                    + doctor.getStartTime() + " - " + doctor.getEndTime() + ")");
                }
            }
        }

        String blocked = doctor.getBlockedDates();
        if (blocked != null && !blocked.isBlank()) {
            String dayKey = appointmentTime.toLocalDate().toString();
            boolean off = Arrays.stream(blocked.split("[,|]"))
                    .map(s -> s.trim())
                    .anyMatch(dayKey::equals);
            if (off) {
                throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Doctor is on leave on " + dayKey);
            }
        }

        LocalTime breakStart = parseTime(doctor.getBreakStart());
        LocalTime breakEnd = parseTime(doctor.getBreakEnd());
        if (breakStart != null && breakEnd != null && !slot.isBefore(breakStart) && slot.isBefore(breakEnd)) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Selected time falls in the doctor's break");
        }

        int duration = slotDuration(doctor);
        LocalDateTime windowEnd = appointmentTime.plusMinutes(duration);
        boolean overlap = appointmentRepository.findByDoctorOrderByAppointmentTimeDesc(doctor).stream()
                .anyMatch(a -> {
                    if (a.getAppointmentTime() == null || a.getStatus() == DoctorAppointmentStatus.CANCELLED) {
                        return false;
                    }
                    LocalDateTime existingEnd = a.getAppointmentTime().plusMinutes(duration);
                    return appointmentTime.isBefore(existingEnd) && windowEnd.isAfter(a.getAppointmentTime());
                });
        if (overlap) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "This time slot is already booked");
        }
    }

    public static int slotDuration(Doctor doctor) {
        if (doctor == null || doctor.getSlotDurationMinutes() == null || doctor.getSlotDurationMinutes() < 10) {
            return 30;
        }
        return doctor.getSlotDurationMinutes();
    }

    public static int bufferMinutes(Doctor doctor) {
        if (doctor == null || doctor.getBufferMinutes() == null || doctor.getBufferMinutes() < 0) {
            return 0;
        }
        return doctor.getBufferMinutes();
    }

    /** Slot check that ignores the current user's own unpaid hold at the same time. */
    public void validateAppointmentSlotForPayment(Doctor doctor, User user, LocalDateTime appointmentTime) {
        requireBookableDoctor(doctor);
        if (appointmentTime == null) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Appointment time is required");
        }
        if (appointmentTime.isBefore(LocalDateTime.now().minusMinutes(1))) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Appointment time must be in the future");
        }
        // reuse day/hours checks via validate, but allow own unpaid hold
        try {
            validateAppointmentSlot(doctor, appointmentTime);
        } catch (ResponseStatusException ex) {
            if (ex.getStatusCode() != HttpStatus.CONFLICT) {
                throw ex;
            }
            boolean ownUnpaid = appointmentRepository.findByUserOrderByAppointmentTimeDesc(user).stream()
                    .anyMatch(a -> a.getDoctor() != null
                            && doctor.getId().equals(a.getDoctor().getId())
                            && a.getAppointmentTime() != null
                            && a.getAppointmentTime().equals(appointmentTime)
                            && a.getStatus() != DoctorAppointmentStatus.CANCELLED
                            && (a.getAmountPaid() == null
                                    || a.getAmountPaid() <= 0
                                    || "PENDING_PAYMENT".equalsIgnoreCase(a.getPaymentStatus())));
            if (!ownUnpaid) {
                throw ex;
            }
        }
    }

    @Transactional
    public DoctorAppointment createRequestBooking(
            Doctor doctor,
            User user,
            LocalDateTime appointmentTime,
            ConsultationType consultationType,
            String reason,
            boolean allowUnpaid) {
        return createRequestBooking(doctor, user, appointmentTime, consultationType, reason, allowUnpaid, null);
    }

    @Transactional
    public DoctorAppointment createRequestBooking(
            Doctor doctor,
            User user,
            LocalDateTime appointmentTime,
            ConsultationType consultationType,
            String reason,
            boolean allowUnpaid,
            Long followUpOfId) {
        requireBookableDoctor(doctor);
        validateConsultationMode(doctor, consultationType);
        validateAppointmentSlot(doctor, appointmentTime);

        double fee = resolveFee(doctor, consultationType);
        if (followUpOfId != null) {
            fee = Math.round(fee * 0.5);
        }
        if (!allowUnpaid && fee > 0) {
            throw new ResponseStatusException(HttpStatus.PAYMENT_REQUIRED,
                    "Payment required for this doctor. Use the payment flow to complete booking.");
        }

        DoctorAppointment appt = new DoctorAppointment();
        appt.setUser(user);
        appt.setDoctor(doctor);
        appt.setAppointmentTime(appointmentTime);
        boolean auto = Boolean.TRUE.equals(doctor.getAutoConfirm());
        appt.setStatus(auto ? DoctorAppointmentStatus.CONFIRMED : DoctorAppointmentStatus.PENDING);
        appt.setFollowUpOfId(followUpOfId);
        appt.setReason(reason == null || reason.isBlank() ? null : reason.trim());
        appt.setConsultationType(consultationType == null ? ConsultationType.CLINIC : consultationType);
        if (appt.getConsultationType() == ConsultationType.VIDEO
                || appt.getConsultationType() == ConsultationType.ONLINE) {
            appt.setMeetingRoomId(doctorPaymentService.generatePrivateRoomId(null));
            appt.setMeetingPassword(doctorPaymentService.generateMeetingPassword());
        }
        DoctorAppointment saved = appointmentRepository.save(appt);
        try {
            notificationService.notifyDoctor(
                    doctor,
                    "NEW_BOOKING",
                    "New appointment request",
                    (user.getFullName() != null ? user.getFullName() : "A patient")
                            + " requested an appointment (#" + saved.getId() + ").",
                    true);
            pushNotificationService.notifyDoctor(
                    doctor,
                    "New appointment request",
                    "A patient requested appointment #" + saved.getId(),
                    Map.of("type", "NEW_BOOKING", "appointmentId", String.valueOf(saved.getId())));
        } catch (Exception ignored) {
        }
        return saved;
    }

    @Transactional
    public DoctorAppointment createPaidBooking(
            Doctor doctor,
            User user,
            LocalDateTime appointmentTime,
            ConsultationType consultationType,
            String reason,
            double amountPaid,
            String orderId,
            String paymentId,
            String signature) {
        requireBookableDoctor(doctor);

        // Idempotent: same Razorpay payment must not create duplicate appointments
        if (paymentId != null && !paymentId.isBlank()) {
            var existing = appointmentRepository.findByUserOrderByAppointmentTimeDesc(user).stream()
                    .filter(a -> paymentId.equals(a.getRazorpayPaymentId()))
                    .findFirst();
            if (existing.isPresent()) {
                return existing.get();
            }
        }

        double expected = resolveFee(doctor, consultationType == null ? ConsultationType.CLINIC : consultationType);
        if (expected > 0 && Math.abs(expected - amountPaid) > 1.0) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST,
                    "Payment amount does not match doctor fee (expected ₹" + (int) expected + ")");
        }

        // Upgrade an existing unpaid hold (instant consult / pending payment) instead of duplicating
        var unpaidHold = appointmentRepository.findByUserOrderByAppointmentTimeDesc(user).stream()
                .filter(a -> a.getDoctor() != null && doctor.getId().equals(a.getDoctor().getId()))
                .filter(a -> a.getAppointmentTime() != null && a.getAppointmentTime().equals(appointmentTime))
                .filter(a -> a.getStatus() != DoctorAppointmentStatus.CANCELLED)
                .filter(a -> a.getAmountPaid() == null
                        || a.getAmountPaid() <= 0
                        || "PENDING_PAYMENT".equalsIgnoreCase(a.getPaymentStatus()))
                .findFirst();
        if (unpaidHold.isPresent()) {
            DoctorAppointment appt = unpaidHold.get();
            if (consultationType != null) {
                appt.setConsultationType(consultationType);
            }
            if (reason != null && !reason.isBlank() && (appt.getReason() == null || appt.getReason().isBlank())) {
                appt.setReason(reason.trim());
            }
            appt.setRazorpayOrderId(orderId);
            appt.setRazorpayPaymentId(paymentId);
            appt.setRazorpaySignature(signature);
            if ((appt.getConsultationType() == ConsultationType.VIDEO
                    || appt.getConsultationType() == ConsultationType.ONLINE)
                    && (appt.getMeetingRoomId() == null || appt.getMeetingRoomId().isBlank())) {
                appt.setMeetingRoomId(doctorPaymentService.generatePrivateRoomId(appt.getId()));
                appt.setMeetingPassword(doctorPaymentService.generateMeetingPassword());
            }
            doctorPaymentService.applyPaidSettlement(appt, amountPaid);
            DoctorAppointment saved = appointmentRepository.save(appt);
            return appointmentService.markConfirmedAfterPayment(saved);
        }

        validateConsultationMode(doctor, consultationType);
        validateAppointmentSlot(doctor, appointmentTime);

        DoctorAppointment appt = new DoctorAppointment();
        appt.setUser(user);
        appt.setDoctor(doctor);
        appt.setAppointmentTime(appointmentTime);
        appt.setReason(reason == null || reason.isBlank() ? null : reason.trim());
        appt.setConsultationType(consultationType == null ? ConsultationType.CLINIC : consultationType);
        appt.setRazorpayOrderId(orderId);
        appt.setRazorpayPaymentId(paymentId);
        appt.setRazorpaySignature(signature);
        if (appt.getConsultationType() == ConsultationType.VIDEO
                || appt.getConsultationType() == ConsultationType.ONLINE) {
            appt.setMeetingRoomId(doctorPaymentService.generatePrivateRoomId(null));
            appt.setMeetingPassword(doctorPaymentService.generateMeetingPassword());
        }
        appt.setStatus(DoctorAppointmentStatus.PENDING);
        doctorPaymentService.applyPaidSettlement(appt, amountPaid);
        DoctorAppointment saved = appointmentRepository.save(appt);
        // Stabilize room id with appointment id
        if (saved.getMeetingRoomId() != null && saved.getMeetingRoomId().contains("-NEW-")) {
            saved.setMeetingRoomId(doctorPaymentService.generatePrivateRoomId(saved.getId()));
            saved = appointmentRepository.save(saved);
        }
        return appointmentService.markConfirmedAfterPayment(saved);
    }

    public void validateConsultationMode(Doctor doctor, ConsultationType type) {
        if (doctor == null || type == null || type == ConsultationType.BOTH) {
            return;
        }
        String modes = doctor.getConsultationModes();
        if (modes == null || modes.isBlank()) {
            return;
        }
        Set<String> allowed = Arrays.stream(modes.split("[,|]"))
                .map(s -> s.trim().toUpperCase(Locale.ROOT))
                .filter(s -> !s.isEmpty())
                .collect(Collectors.toSet());
        if (!allowed.isEmpty() && !allowed.contains(type.name())) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST,
                    "This doctor does not offer " + type.name() + " consultations");
        }
    }

    private static List<Map<String, String>> matchingDaySlots(Doctor doctor, DayOfWeek dow) {
        if (doctor == null || doctor.getAvailabilitySlots() == null || doctor.getAvailabilitySlots().isBlank()) {
            return List.of();
        }
        try {
            List<Map<String, String>> slots = MAPPER.readValue(
                    doctor.getAvailabilitySlots(), new TypeReference<List<Map<String, String>>>() {});
            if (slots == null) {
                return List.of();
            }
            List<Map<String, String>> match = new ArrayList<>();
            for (Map<String, String> s : slots) {
                if (s == null) continue;
                String day = s.get("day");
                if (day != null && dow.name().equalsIgnoreCase(day.trim())) {
                    match.add(s);
                }
            }
            return match;
        } catch (Exception ex) {
            return List.of();
        }
    }

    private static LocalTime parseTime(String raw) {
        if (raw == null || raw.isBlank()) {
            return null;
        }
        try {
            String v = raw.trim();
            if (v.length() == 5) {
                return LocalTime.parse(v, TIME_FMT);
            }
            return LocalTime.parse(v);
        } catch (Exception ex) {
            return null;
        }
    }
}

