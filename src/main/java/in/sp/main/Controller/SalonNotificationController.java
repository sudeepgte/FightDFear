package in.sp.main.Controller;

import in.sp.main.Entities.Salon;
import in.sp.main.Entities.SalonNotification;
import in.sp.main.Repository.SalonNotificationRepository;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

@Controller
@RequestMapping("/salon/notifications")
public class SalonNotificationController {

    @Autowired
    private SalonNotificationRepository notificationRepository;

    @GetMapping
    public String viewNotifications(HttpSession session, Model model) {
        Salon loggedSalon = (Salon) session.getAttribute("loggedSalon");
        if (loggedSalon == null) return "redirect:/salons/login";

        List<SalonNotification> notifications = notificationRepository.findBySalonIdOrderByTimestampDesc(loggedSalon.getId());
        
        // Mark all unread as read when viewed
        boolean changed = false;
        for (SalonNotification n : notifications) {
            if (!n.isRead()) {
                n.setRead(true);
                changed = true;
            }
        }
        if (changed) {
            notificationRepository.saveAll(notifications);
        }

        model.addAttribute("notifications", notifications);

        return "salon/salon-notifications";
    }
}
