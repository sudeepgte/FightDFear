package in.sp.main.Config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;

import in.sp.main.Entities.User;
import jakarta.servlet.http.HttpSession;

@ControllerAdvice
public class GlobalModelAttributes {

    @Autowired
    private in.sp.main.Repository.SalonNotificationRepository salonNotificationRepository;

    @Autowired
    private in.sp.main.Repository.BroadcastMessageRepository broadcastRepo;

    @Autowired
    private in.sp.main.Repository.ContactMessageRepository contactMessageRepo;

    @Autowired
    private in.sp.main.Repository.CreatorNotificationRepository creatorNotificationRepo;

    @ModelAttribute("user")
    public User currentUser(HttpSession session) {
        Object u = session.getAttribute("user");
        return (u instanceof User) ? (User) u : null;
    }

    @ModelAttribute("unreadBroadcastCount")
    public long unreadBroadcastCount(HttpSession session) {
        Object u = session.getAttribute("user");
        if (u instanceof User user) {
            long unreadBroadcasts = 0;
            try {
                java.util.List<in.sp.main.Entities.BroadcastMessage> broadcasts = broadcastRepo.findAllByOrderBySentAtDesc();
                if (user.getLastReadBroadcastTime() == null) {
                    unreadBroadcasts = broadcasts.size();
                } else {
                    unreadBroadcasts = broadcasts.stream()
                            .filter(b -> b.getSentAt() != null && b.getSentAt().isAfter(user.getLastReadBroadcastTime()))
                            .count();
                }
            } catch (Exception ignored) {}

            long unreadReplies = 0;
            if (user.getEmail() != null) {
                try {
                    unreadReplies = contactMessageRepo
                            .countByEmailIgnoreCaseAndAdminReplyIsNotNullAndReplyReadByUserFalse(user.getEmail().trim());
                } catch (Exception ignored) {}
            }

            long unreadCreatorNotifs = 0;
            try {
                unreadCreatorNotifs = creatorNotificationRepo.countByUser_IdAndIsReadFalse(user.getId());
            } catch (Exception ignored) {}

            return unreadBroadcasts + unreadReplies + unreadCreatorNotifs;
        }
        return 0;
    }

    @ModelAttribute("userFollowNotifications")
    public java.util.List<in.sp.main.Entities.CreatorNotification> userFollowNotifications(HttpSession session) {
        Object u = session.getAttribute("user");
        if (u instanceof User user) {
            try {
                return creatorNotificationRepo.findByUser_IdOrderByCreatedAtDesc(user.getId())
                        .stream().limit(20).collect(java.util.stream.Collectors.toList());
            } catch (Exception ignored) {}
        }
        return java.util.Collections.emptyList();
    }

    @ModelAttribute("userContactReplies")
    public java.util.List<in.sp.main.Entities.ContactMessage> userContactReplies(HttpSession session) {
        Object u = session.getAttribute("user");
        if (u instanceof User user && user.getEmail() != null) {
            try {
                return contactMessageRepo.findByEmailIgnoreCaseAndAdminReplyIsNotNullOrderByRepliedAtDesc(user.getEmail().trim());
            } catch (Exception ignored) {}
        }
        return java.util.Collections.emptyList();
    }

    @ModelAttribute("recentBroadcasts")
    public java.util.List<in.sp.main.Entities.BroadcastMessage> recentBroadcasts(HttpSession session) {
        try {
            return broadcastRepo.findTop5ByOrderBySentAtDesc();
        } catch (Exception ignored) {
            return java.util.Collections.emptyList();
        }
    }

    @ModelAttribute("unreadNotifCount")
    public long unreadNotifCount(HttpSession session) {
        in.sp.main.Entities.Salon salon = (in.sp.main.Entities.Salon) session.getAttribute("loggedSalon");
        if (salon != null) {
            return salonNotificationRepository.countBySalonIdAndIsReadFalse(salon.getId());
        }
        return 0;
    }

    @ModelAttribute("recentNotifications")
    public java.util.List<in.sp.main.Entities.SalonNotification> recentNotifications(HttpSession session) {
        in.sp.main.Entities.Salon salon = (in.sp.main.Entities.Salon) session.getAttribute("loggedSalon");
        if (salon != null) {
            return salonNotificationRepository.findBySalonIdOrderByTimestampDesc(salon.getId());
        }
        return java.util.Collections.emptyList();
    }
}

