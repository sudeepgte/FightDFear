package in.sp.main.Service;

import in.sp.main.Entities.BroadcastMessage;
import in.sp.main.Entities.CreatorNotification;
import in.sp.main.Entities.User;
import in.sp.main.Repository.BroadcastMessageRepository;
import in.sp.main.Repository.CreatorNotificationRepository;
import in.sp.main.Repository.OfferRepository;
import in.sp.main.Repository.UserRepository;
import in.sp.main.Repository.WomenEventRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

@Service
public class UserNotificationService {

    @Autowired
    private BroadcastMessageRepository broadcastRepo;
    @Autowired
    private WomenEventRepository eventRepo;
    @Autowired
    private OfferRepository offerRepo;
    @Autowired
    private CreatorNotificationRepository creatorNotificationRepo;
    @Autowired
    private UserRepository userRepo;

    @Transactional(readOnly = true)
    public Map<String, Object> buildForUser(User user) {
        List<Map<String, Object>> items = new ArrayList<>();
        List<BroadcastMessage> broadcasts = broadcastRepo.findAllByOrderBySentAtDesc();
        LocalDateTime lastRead = user != null ? user.getLastReadBroadcastTime() : null;

        for (BroadcastMessage b : broadcasts) {
            if (items.size() >= 20) break;
            boolean unread = lastRead == null
                    || (b.getSentAt() != null && b.getSentAt().isAfter(lastRead));
            items.add(notificationItem(
                    "broadcast-" + b.getId(),
                    "BROADCAST",
                    b.getType() == null ? "INFO" : b.getType(),
                    b.getTitle() != null ? b.getTitle() : "Announcement",
                    b.getMessage(),
                    b.getSentAt(),
                    inferLink(b.getTitle(), b.getMessage(), b.getType()),
                    unread));
        }

        eventRepo.findByStatusOrderByCreatedAtDesc("APPROVED").stream().limit(3).forEach(e -> {
            String where = e.getCity() != null ? e.getCity()
                    : (e.getVenue() != null ? e.getVenue() : "Open now");
            String msg = where + (e.getEventDate() == null ? "" : " · " + e.getEventDate());
            items.add(notificationItem(
                    "event-" + e.getId(),
                    "EVENT",
                    "INFO",
                    "New event: " + nullToEmpty(e.getName()),
                    msg,
                    e.getCreatedAt(),
                    "/women-events",
                    lastRead == null));
        });

        offerRepo.findByActiveTrue().stream()
                .filter(o -> o.getSalon() != null && o.getSalon().isApproved())
                .limit(3)
                .forEach(o -> {
                    String salon = o.getSalon() == null ? "Glow Space" : o.getSalon().getName();
                    String discount = o.getDiscountPercent() > 0
                            ? ((int) o.getDiscountPercent()) + "% OFF · "
                            : "";
                    items.add(notificationItem(
                            "offer-" + o.getId(),
                            "OFFER",
                            "INFO",
                            o.getTitle() == null ? "Glow offer" : o.getTitle(),
                            discount + salon,
                            null,
                            "/user/offers",
                            lastRead == null));
                });

        if (user != null) {
            items.add(0, notificationItem(
                    "system-sos",
                    "SYSTEM",
                    "TIP",
                    "Stay prepared",
                    "Keep trusted contacts updated so SOS can reach help fast.",
                    null,
                    "/trusted-contacts",
                    false));

            try {
                List<CreatorNotification> creatorNotifs =
                        creatorNotificationRepo.findByUser_IdOrderByCreatedAtDesc(user.getId());
                for (CreatorNotification n : creatorNotifs) {
                    if (items.size() >= 40) break;
                    items.add(notificationItem(
                            "creator-" + n.getId(),
                            "CREATOR",
                            n.getType() != null ? n.getType() : "INFO",
                            "Creator Hub",
                            n.getMessage(),
                            n.getCreatedAt(),
                            "/creator/notifications",
                            !n.isRead()));
                }
            } catch (Exception ignored) {
                // Creator notifications optional
            }
        }

        int unreadCount = 0;
        for (Map<String, Object> item : items) {
            if (Boolean.TRUE.equals(item.get("unread"))) {
                unreadCount++;
            }
        }

        Map<String, Object> result = new LinkedHashMap<>();
        result.put("success", true);
        result.put("unreadCount", unreadCount);
        result.put("notifications", items);
        result.put("count", items.size());
        return result;
    }

    @Transactional
    public void markAllRead(User user) {
        if (user == null) return;
        User fresh = userRepo.findById(user.getId()).orElse(user);
        fresh.setLastReadBroadcastTime(LocalDateTime.now());
        userRepo.save(fresh);

        try {
            List<CreatorNotification> creatorNotifs =
                    creatorNotificationRepo.findByUser_IdOrderByCreatedAtDesc(fresh.getId());
            boolean changed = false;
            for (CreatorNotification n : creatorNotifs) {
                if (!n.isRead()) {
                    n.setRead(true);
                    changed = true;
                }
            }
            if (changed) {
                creatorNotificationRepo.saveAll(creatorNotifs);
            }
        } catch (Exception ignored) {
            // Non-fatal
        }
    }

    private Map<String, Object> notificationItem(String id, String source, String type,
                                                  String title, String message,
                                                  LocalDateTime createdAt, String link,
                                                  boolean unread) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", id);
        m.put("source", source);
        m.put("type", type);
        m.put("title", title);
        m.put("message", message);
        m.put("createdAt", createdAt == null ? null : createdAt.toString());
        m.put("link", link);
        m.put("unread", unread);
        return m;
    }

    private String nullToEmpty(String s) {
        return s == null ? "" : s;
    }

    private String inferLink(String title, String message, String type) {
        String blob = ((title == null ? "" : title) + " " + (message == null ? "" : message)
                + " " + (type == null ? "" : type)).toLowerCase(Locale.ROOT);
        if (blob.contains("sos") || blob.contains("emergency") || blob.contains("alert")) {
            return "/";
        }
        if (blob.contains("event") || blob.contains("workshop") || blob.contains("webinar")) {
            return "/women-events";
        }
        if (blob.contains("glow") || blob.contains("salon") || blob.contains("spa") || blob.contains("offer")) {
            return "/user/offers";
        }
        if (blob.contains("martial") || blob.contains("defence") || blob.contains("defense")
                || blob.contains("training")) {
            return "/centres/allacceptedcentres";
        }
        if (blob.contains("doctor") || blob.contains("health") || blob.contains("clinic")) {
            return "/doctors";
        }
        if (blob.contains("market") || blob.contains("provider") || blob.contains("service")) {
            return "/marketplace";
        }
        if (blob.contains("community") || blob.contains("creator") || blob.contains("video")) {
            return "/video/reels";
        }
        return null;
    }
}
