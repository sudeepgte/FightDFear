package in.sp.main.Service;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import in.sp.main.Entities.ProviderNotification;
import in.sp.main.Entities.ServiceProvider;
import in.sp.main.Repository.ProviderNotificationRepository;

@Service
public class ProviderNotificationService {

    private static final Logger log = LoggerFactory.getLogger(ProviderNotificationService.class);

    @Autowired
    private ProviderNotificationRepository notificationRepository;

    @Autowired
    private EmailService emailService;

    @Transactional
    public void notifyProvider(ServiceProvider provider, String type, String title, String message, Long bookingId, boolean sendEmail) {
        if (provider == null || provider.getId() == null) {
            return;
        }
        try {
            ProviderNotification n = new ProviderNotification();
            n.setProvider(provider);
            n.setType(type == null ? "INFO" : type);
            n.setTitle(title == null ? "Notification" : title);
            n.setMessage(message == null ? "" : message);
            n.setBookingId(bookingId);
            n.setReadFlag(false);
            notificationRepository.save(n);
        } catch (Exception ex) {
            log.warn("Could not save ProviderNotification: {}", ex.getMessage());
        }

        if (sendEmail && provider.getEmail() != null && !provider.getEmail().isBlank()) {
            try {
                emailService.sendEmail(provider.getEmail(), title, message);
            } catch (Exception ex) {
                log.info("Email could not be delivered to provider {}: {}", provider.getEmail(), ex.getMessage());
            }
        }
    }

    public List<Map<String, Object>> listForProvider(Long providerId) {
        List<Map<String, Object>> out = new ArrayList<>();
        if (providerId == null) {
            return out;
        }
        for (ProviderNotification n : notificationRepository.findByProvider_IdOrderByCreatedAtDesc(providerId)) {
            Map<String, Object> row = new LinkedHashMap<>();
            row.put("id", n.getId());
            row.put("type", n.getType());
            row.put("title", n.getTitle());
            row.put("message", n.getMessage());
            row.put("bookingId", n.getBookingId());
            row.put("read", n.isReadFlag());
            row.put("createdAt", n.getCreatedAt() == null ? null : n.getCreatedAt().toString());
            out.add(row);
        }
        return out;
    }

    public long unreadCount(Long providerId) {
        if (providerId == null) {
            return 0;
        }
        return notificationRepository.countByProvider_IdAndReadFlagFalse(providerId);
    }

    @Transactional
    public void markAllRead(Long providerId) {
        if (providerId == null) {
            return;
        }
        List<ProviderNotification> list = notificationRepository.findByProvider_IdOrderByCreatedAtDesc(providerId);
        for (ProviderNotification n : list) {
            if (!n.isReadFlag()) {
                n.setReadFlag(true);
            }
        }
        notificationRepository.saveAll(list);
    }
}
