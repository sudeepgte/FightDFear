package in.sp.main.Service;

import java.util.EnumMap;
import java.util.EnumSet;
import java.util.Map;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import in.sp.main.Entities.Doctor;
import in.sp.main.Entities.DoctorAppointment;
import in.sp.main.Entities.DoctorAppointmentStatus;
import in.sp.main.Entities.User;
import in.sp.main.Repository.DoctorAppointmentRepository;

@Service
public class DoctorAppointmentService {

    private static final Map<DoctorAppointmentStatus, Set<DoctorAppointmentStatus>> DOCTOR_TRANSITIONS =
            new EnumMap<>(DoctorAppointmentStatus.class);
    private static final Map<DoctorAppointmentStatus, Set<DoctorAppointmentStatus>> PATIENT_TRANSITIONS =
            new EnumMap<>(DoctorAppointmentStatus.class);

    static {
        DOCTOR_TRANSITIONS.put(DoctorAppointmentStatus.PENDING,
                EnumSet.of(DoctorAppointmentStatus.CONFIRMED, DoctorAppointmentStatus.CANCELLED));
        DOCTOR_TRANSITIONS.put(DoctorAppointmentStatus.CONFIRMED,
                EnumSet.of(DoctorAppointmentStatus.COMPLETED, DoctorAppointmentStatus.CANCELLED));
        DOCTOR_TRANSITIONS.put(DoctorAppointmentStatus.COMPLETED, EnumSet.noneOf(DoctorAppointmentStatus.class));
        DOCTOR_TRANSITIONS.put(DoctorAppointmentStatus.CANCELLED, EnumSet.noneOf(DoctorAppointmentStatus.class));

        PATIENT_TRANSITIONS.put(DoctorAppointmentStatus.PENDING,
                EnumSet.of(DoctorAppointmentStatus.CANCELLED));
        PATIENT_TRANSITIONS.put(DoctorAppointmentStatus.CONFIRMED,
                EnumSet.of(DoctorAppointmentStatus.CANCELLED));
        PATIENT_TRANSITIONS.put(DoctorAppointmentStatus.COMPLETED, EnumSet.noneOf(DoctorAppointmentStatus.class));
        PATIENT_TRANSITIONS.put(DoctorAppointmentStatus.CANCELLED, EnumSet.noneOf(DoctorAppointmentStatus.class));
    }

    @Autowired
    private DoctorAppointmentRepository appointmentRepository;

    @Autowired
    private DoctorNotificationService notificationService;

    @Transactional
    public DoctorAppointment transitionByDoctor(DoctorAppointment appointment, Doctor doctor, DoctorAppointmentStatus target) {
        requireOwnedByDoctor(appointment, doctor);
        applyTransition(appointment, target, DOCTOR_TRANSITIONS, "doctor");
        DoctorAppointment saved = appointmentRepository.save(appointment);
        notifyPatientStatusChange(saved);
        return saved;
    }

    @Transactional
    public DoctorAppointment cancelByPatient(DoctorAppointment appointment, User user) {
        requireOwnedByPatient(appointment, user);
        applyTransition(appointment, DoctorAppointmentStatus.CANCELLED, PATIENT_TRANSITIONS, "patient");
        DoctorAppointment saved = appointmentRepository.save(appointment);
        notifyDoctorCancelled(saved);
        return saved;
    }

    @Transactional
    public DoctorAppointment markConfirmedAfterPayment(DoctorAppointment appointment) {
        if (appointment.getStatus() == DoctorAppointmentStatus.PENDING) {
            appointment.setStatus(DoctorAppointmentStatus.CONFIRMED);
            DoctorAppointment saved = appointmentRepository.save(appointment);
            notifyDoctorNewBooking(saved);
            return saved;
        }
        return appointment;
    }

    public boolean canDoctorTransition(DoctorAppointmentStatus from, DoctorAppointmentStatus to) {
        return DOCTOR_TRANSITIONS.getOrDefault(from, EnumSet.noneOf(DoctorAppointmentStatus.class)).contains(to);
    }

    public boolean canJoinVideo(DoctorAppointment appointment) {
        if (appointment == null || appointment.getStatus() != DoctorAppointmentStatus.CONFIRMED) {
            return false;
        }
        var type = appointment.getConsultationType();
        return type == in.sp.main.Entities.ConsultationType.VIDEO
                || type == in.sp.main.Entities.ConsultationType.ONLINE
                || type == in.sp.main.Entities.ConsultationType.BOTH;
    }

    public boolean hasActiveRelationship(Doctor doctor, User user) {
        if (doctor == null || user == null) {
            return false;
        }
        return appointmentRepository.findByDoctorOrderByAppointmentTimeDesc(doctor).stream()
                .anyMatch(a -> a.getUser() != null
                        && a.getUser().getId().equals(user.getId())
                        && (a.getStatus() == DoctorAppointmentStatus.PENDING
                        || a.getStatus() == DoctorAppointmentStatus.CONFIRMED
                        || a.getStatus() == DoctorAppointmentStatus.COMPLETED));
    }

    private void applyTransition(
            DoctorAppointment appointment,
            DoctorAppointmentStatus target,
            Map<DoctorAppointmentStatus, Set<DoctorAppointmentStatus>> rules,
            String actor) {
        DoctorAppointmentStatus from = appointment.getStatus() == null
                ? DoctorAppointmentStatus.PENDING
                : appointment.getStatus();
        if (from == target) {
            return;
        }
        Set<DoctorAppointmentStatus> allowed = rules.getOrDefault(from, EnumSet.noneOf(DoctorAppointmentStatus.class));
        if (!allowed.contains(target)) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST,
                    "Invalid " + actor + " status change from " + from + " to " + target);
        }
        appointment.setStatus(target);
    }

    private void requireOwnedByDoctor(DoctorAppointment appointment, Doctor doctor) {
        if (appointment == null || doctor == null || appointment.getDoctor() == null
                || !appointment.getDoctor().getId().equals(doctor.getId())) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Appointment not found");
        }
    }

    private void requireOwnedByPatient(DoctorAppointment appointment, User user) {
        if (appointment == null || user == null || appointment.getUser() == null
                || !appointment.getUser().getId().equals(user.getId())) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Appointment not found");
        }
    }

    private void notifyPatientStatusChange(DoctorAppointment appointment) {
        // Patient in-app notifications are not persisted yet; doctor-side notifications cover provider.
        if (appointment.getDoctor() == null) {
            return;
        }
        String patient = appointment.getUser() != null && appointment.getUser().getFullName() != null
                ? appointment.getUser().getFullName() : "Patient";
        notificationService.notifyDoctor(
                appointment.getDoctor(),
                "APPOINTMENT_STATUS",
                "Appointment " + appointment.getStatus().name().toLowerCase(),
                "Appointment #" + appointment.getId() + " with " + patient
                        + " is now " + appointment.getStatus().name() + ".",
                false);
    }

    private void notifyDoctorNewBooking(DoctorAppointment appointment) {
        if (appointment.getDoctor() == null) {
            return;
        }
        String patient = appointment.getUser() != null && appointment.getUser().getFullName() != null
                ? appointment.getUser().getFullName() : "A patient";
        notificationService.notifyDoctor(
                appointment.getDoctor(),
                "NEW_BOOKING",
                "New appointment booked",
                patient + " booked an appointment (#" + appointment.getId() + ").",
                true);
    }

    private void notifyDoctorCancelled(DoctorAppointment appointment) {
        if (appointment.getDoctor() == null) {
            return;
        }
        String patient = appointment.getUser() != null && appointment.getUser().getFullName() != null
                ? appointment.getUser().getFullName() : "A patient";
        notificationService.notifyDoctor(
                appointment.getDoctor(),
                "APPOINTMENT_CANCELLED",
                "Appointment cancelled",
                patient + " cancelled appointment #" + appointment.getId() + ".",
                true);
    }
}
