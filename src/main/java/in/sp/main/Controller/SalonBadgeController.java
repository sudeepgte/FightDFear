package in.sp.main.Controller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import in.sp.main.Entities.Salon;
import in.sp.main.Repository.SalonChatMessageRepository;
import in.sp.main.Repository.SalonNotificationRepository;
import jakarta.servlet.http.HttpSession;

@RestController
@RequestMapping("/api/salon/badges")
public class SalonBadgeController {

    @Autowired
    private SalonNotificationRepository notificationRepository;

    @Autowired
    private SalonChatMessageRepository chatMessageRepository;

    @GetMapping("/counts")
    public Map<String, Long> getBadgeCounts(HttpSession session) {
        Map<String, Long> counts = new HashMap<>();
        Salon loggedSalon = (Salon) session.getAttribute("loggedSalon");
        
        if (loggedSalon != null) {
            long notificationsCount = notificationRepository.countBySalonIdAndIsReadFalse(loggedSalon.getId());
            long messagesCount = chatMessageRepository.countBySalonIdAndIsReadFalseAndSenderRoleNot(loggedSalon.getId(), "SALON");
            
            counts.put("notifications", notificationsCount);
            counts.put("messages", messagesCount);
        } else {
            counts.put("notifications", 0L);
            counts.put("messages", 0L);
        }
        
        return counts;
    }
}
