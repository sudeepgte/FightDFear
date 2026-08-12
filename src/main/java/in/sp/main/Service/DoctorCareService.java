package in.sp.main.Service;

import java.io.ByteArrayOutputStream;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import net.javacrumbs.shedlock.spring.annotation.SchedulerLock;

import com.itextpdf.text.Document;
import com.itextpdf.text.Font;
import com.itextpdf.text.FontFactory;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.pdf.PdfWriter;

import in.sp.main.Entities.Doctor;
import in.sp.main.Entities.DoctorAppointment;
import in.sp.main.Entities.DoctorAppointmentStatus;
import in.sp.main.Entities.DoctorFavorite;
import in.sp.main.Entities.User;
import in.sp.main.Repository.DoctorAppointmentRepository;
import in.sp.main.Repository.DoctorFavoriteRepository;
import in.sp.main.Repository.DoctorRepository;

@Service
public class DoctorCareService {

    @Autowired
    private DoctorAppointmentRepository appointmentRepository;
    @Autowired
    private DoctorFavoriteRepository favoriteRepository;
    @Autowired
    private DoctorRepository doctorRepository;
    @Autowired
    private PushNotificationService pushNotificationService;
    @Autowired
    private DoctorNotificationService notificationService;

    @Scheduled(fixedDelay = 300000)
    @SchedulerLock(name = "DoctorCareService_sendAppointmentReminders", lockAtLeastFor = "4m", lockAtMostFor = "10m")
    @Transactional
    public void sendAppointmentReminders() {
        LocalDateTime now = LocalDateTime.now();
        List<DoctorAppointmentStatus> statuses = List.of(
                DoctorAppointmentStatus.CONFIRMED, DoctorAppointmentStatus.PENDING);
        List<DoctorAppointment> upcoming24h = appointmentRepository.findByStatusInAndAppointmentTimeBetween(
                statuses, now.plusHours(20), now.plusHours(26));
        for (DoctorAppointment a : upcoming24h) {
            if (!Boolean.TRUE.equals(a.getReminder24hSent()) && a.getAppointmentTime() != null) {
                ping(a, "Appointment tomorrow", "You have a consultation at " + a.getAppointmentTime());
                a.setReminder24hSent(true);
                appointmentRepository.save(a);
            }
        }
        List<DoctorAppointment> upcoming1h = appointmentRepository.findByStatusInAndAppointmentTimeBetween(
                statuses, now.plusMinutes(45), now.plusMinutes(75));
        for (DoctorAppointment a : upcoming1h) {
            if (!Boolean.TRUE.equals(a.getReminder1hSent()) && a.getAppointmentTime() != null) {
                ping(a, "Appointment in 1 hour", "Your consultation starts at " + a.getAppointmentTime().toLocalTime());
                a.setReminder1hSent(true);
                appointmentRepository.save(a);
            }
        }
    }

    public void pingDoctorWaiting(DoctorAppointment appointment) {
        if (appointment.getUser() == null) {
            return;
        }
        pushNotificationService.notifyUser(
                appointment.getUser().getId(),
                "Doctor is waiting on video",
                "Join your consultation now",
                Map.of("type", "DOCTOR_WAITING", "appointmentId", String.valueOf(appointment.getId())));
        notificationService.notifyDoctor(
                appointment.getDoctor(),
                "WAITING_PING",
                "Waiting ping sent",
                "Patient was notified to join appointment #" + appointment.getId(),
                false);
    }

    public byte[] prescriptionPdf(DoctorAppointment appointment) {
        try {
            ByteArrayOutputStream out = new ByteArrayOutputStream();
            Document doc = new Document();
            PdfWriter.getInstance(doc, out);
            doc.open();
            Font h = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 16);
            Font b = FontFactory.getFont(FontFactory.HELVETICA, 12);
            Doctor doctor = appointment.getDoctor();
            User user = appointment.getUser();
            doc.add(new Paragraph("Prescription", h));
            doc.add(new Paragraph("Doctor: " + (doctor == null ? "-" : doctor.getFullName()), b));
            doc.add(new Paragraph("Patient: " + (user == null ? "-" : user.getFullName()), b));
            doc.add(new Paragraph("Date: " + appointment.getAppointmentTime(), b));
            doc.add(new Paragraph(" "));
            if (appointment.getPrescriptionJson() != null && !appointment.getPrescriptionJson().isBlank()) {
                doc.add(new Paragraph(appointment.getPrescriptionJson(), b));
            } else if (appointment.getPrescriptionText() != null) {
                doc.add(new Paragraph(appointment.getPrescriptionText(), b));
            } else {
                doc.add(new Paragraph("No medicines recorded.", b));
            }
            doc.close();
            return out.toByteArray();
        } catch (Exception ex) {
            throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, "Failed to build prescription PDF");
        }
    }

    @Transactional
    public void addFavorite(Long userId, Long doctorId) {
        if (favoriteRepository.existsByUserIdAndDoctorId(userId, doctorId)) {
            return;
        }
        if (!doctorRepository.existsById(doctorId)) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Doctor not found");
        }
        DoctorFavorite fav = new DoctorFavorite();
        fav.setUserId(userId);
        fav.setDoctorId(doctorId);
        favoriteRepository.save(fav);
    }

    @Transactional
    public void removeFavorite(Long userId, Long doctorId) {
        favoriteRepository.deleteByUserIdAndDoctorId(userId, doctorId);
    }

    public List<DoctorFavorite> favorites(Long userId) {
        return favoriteRepository.findByUserIdOrderByCreatedAtDesc(userId);
    }

    public boolean isFavorite(Long userId, Long doctorId) {
        return favoriteRepository.existsByUserIdAndDoctorId(userId, doctorId);
    }

    private void ping(DoctorAppointment a, String title, String body) {
        if (a.getUser() != null) {
            pushNotificationService.notifyUser(
                    a.getUser().getId(), title, body,
                    Map.of("type", "APPOINTMENT_REMINDER", "appointmentId", String.valueOf(a.getId())));
        }
        if (a.getDoctor() != null) {
            pushNotificationService.notifyDoctor(a.getDoctor(), title, body,
                    Map.of("type", "APPOINTMENT_REMINDER", "appointmentId", String.valueOf(a.getId())));
            notificationService.notifyDoctor(a.getDoctor(), "REMINDER", title, body, false);
        }
    }
}
