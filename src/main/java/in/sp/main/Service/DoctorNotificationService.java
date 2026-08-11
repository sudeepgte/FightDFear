package in.sp.main.Service;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import in.sp.main.Entities.Doctor;
import in.sp.main.Entities.DoctorNotification;
import in.sp.main.Repository.DoctorNotificationRepository;

@Service
public class DoctorNotificationService {

    @Autowired
    private DoctorNotificationRepository notificationRepository;

    @Autowired
    private EmailService emailService;

    @Transactional
    public void notifyDoctor(Doctor doctor, String type, String title, String message, boolean sendEmail) {
        if (doctor == null || doctor.getId() == null) {
            return;
        }
        DoctorNotification n = new DoctorNotification();
        n.setDoctorId(doctor.getId());
        n.setType(type);
        n.setTitle(title);
        n.setMessage(message);
        n.setReadFlag(false);
        notificationRepository.save(n);

        if (sendEmail && doctor.getEmail() != null && !doctor.getEmail().isBlank()) {
            emailService.sendEmail(doctor.getEmail(), title, message);
        }
    }

    public List<Map<String, Object>> listForDoctor(Long doctorId) {
        List<Map<String, Object>> out = new ArrayList<>();
        if (doctorId == null) {
            return out;
        }
        for (DoctorNotification n : notificationRepository.findByDoctorIdOrderByCreatedAtDesc(doctorId)) {
            Map<String, Object> row = new LinkedHashMap<>();
            row.put("id", n.getId());
            row.put("type", n.getType());
            row.put("title", n.getTitle());
            row.put("message", n.getMessage());
            row.put("read", n.isReadFlag());
            row.put("createdAt", n.getCreatedAt() == null ? null : n.getCreatedAt().toString());
            out.add(row);
        }
        return out;
    }

    public long unreadCount(Long doctorId) {
        if (doctorId == null) {
            return 0;
        }
        return notificationRepository.countByDoctorIdAndReadFlagFalse(doctorId);
    }

    @Transactional
    public void markAllRead(Long doctorId) {
        if (doctorId == null) {
            return;
        }
        List<DoctorNotification> list = notificationRepository.findByDoctorIdOrderByCreatedAtDesc(doctorId);
        for (DoctorNotification n : list) {
            if (!n.isReadFlag()) {
                n.setReadFlag(true);
            }
        }
        notificationRepository.saveAll(list);
    }
}
