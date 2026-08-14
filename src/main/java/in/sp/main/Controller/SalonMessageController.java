package in.sp.main.Controller;

import in.sp.main.Entities.Salon;
import in.sp.main.Entities.SalonChatMessage;
import in.sp.main.Repository.SalonChatMessageRepository;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;

@Controller
@RequestMapping("/salon/messages")
public class SalonMessageController {

    @Autowired
    private SalonChatMessageRepository chatMessageRepository;

    @GetMapping
    public String viewMessages(HttpSession session, Model model) {
        Salon loggedSalon = (Salon) session.getAttribute("loggedSalon");
        if (loggedSalon == null) return "redirect:/salons/login";

        List<SalonChatMessage> messages = chatMessageRepository.findBySalonIdOrderByTimestampAsc(loggedSalon.getId());
        
        // Mark incoming messages as read
        boolean changed = false;
        for (SalonChatMessage m : messages) {
            if (!m.isRead() && !"SALON".equals(m.getSenderRole())) {
                m.setRead(true);
                changed = true;
            }
        }
        if (changed) {
            chatMessageRepository.saveAll(messages);
        }

        model.addAttribute("messages", messages);

        return "salon/salon-messages";
    }
}
