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

    @ModelAttribute("user")
    public User currentUser(HttpSession session) {
        Object u = session.getAttribute("user");
        return (u instanceof User) ? (User) u : null;
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

