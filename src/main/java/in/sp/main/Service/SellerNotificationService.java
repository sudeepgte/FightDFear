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

import in.sp.main.Entities.SellerNotification;
import in.sp.main.Entities.WomenProductSeller;
import in.sp.main.Repository.SellerNotificationRepository;

@Service
public class SellerNotificationService {

    private static final Logger log = LoggerFactory.getLogger(SellerNotificationService.class);

    @Autowired
    private SellerNotificationRepository notificationRepository;

    @Autowired
    private EmailService emailService;

    @Transactional
    public void notifySeller(WomenProductSeller seller, String type, String title, String message, Long orderId, boolean sendEmail) {
        if (seller == null || seller.getId() == null) {
            return;
        }
        try {
            SellerNotification n = new SellerNotification();
            n.setSeller(seller);
            n.setType(type == null ? "INFO" : type);
            n.setTitle(title == null ? "Notification" : title);
            n.setMessage(message == null ? "" : message);
            n.setOrderId(orderId);
            n.setReadFlag(false);
            notificationRepository.save(n);
        } catch (Exception ex) {
            log.warn("Could not save SellerNotification: {}", ex.getMessage());
        }

        if (sendEmail && seller.getEmail() != null && !seller.getEmail().isBlank()) {
            try {
                emailService.sendEmail(seller.getEmail(), title, message);
            } catch (Exception ex) {
                log.info("Email could not be delivered to seller {}: {}", seller.getEmail(), ex.getMessage());
            }
        }
    }

    public List<Map<String, Object>> listForSeller(Long sellerId) {
        List<Map<String, Object>> out = new ArrayList<>();
        if (sellerId == null) {
            return out;
        }
        for (SellerNotification n : notificationRepository.findBySeller_IdOrderByCreatedAtDesc(sellerId)) {
            Map<String, Object> m = new LinkedHashMap<>();
            m.put("id", n.getId());
            m.put("type", n.getType());
            m.put("title", n.getTitle());
            m.put("message", n.getMessage());
            m.put("orderId", n.getOrderId());
            m.put("read", n.isReadFlag());
            m.put("createdAt", n.getCreatedAt() == null ? null : n.getCreatedAt().toString());
            out.add(m);
        }
        return out;
    }

    public List<Map<String, Object>> listForSeller(WomenProductSeller seller) {
        if (seller == null || seller.getId() == null) return List.of();
        return listForSeller(seller.getId());
    }

    public int countUnreadForSeller(WomenProductSeller seller) {
        if (seller == null || seller.getId() == null) return 0;
        return (int) notificationRepository.countBySeller_IdAndReadFlagFalse(seller.getId());
    }

    @Transactional
    public void markAllRead(Long sellerId) {
        if (sellerId != null) {
            notificationRepository.markAllAsRead(sellerId);
        }
    }
}
