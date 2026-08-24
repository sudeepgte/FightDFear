package in.sp.main.Controller;

import in.sp.main.Entities.ContactMessage;
import in.sp.main.Entities.Salon;
import in.sp.main.Repository.ContactMessageRepository;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
@RequestMapping("/salon/support")
public class SalonSupportController {

    @Autowired
    private ContactMessageRepository contactMessageRepository;

    @GetMapping
    public String viewSupportDashboard(HttpSession session, Model model) {
        Salon loggedSalon = (Salon) session.getAttribute("loggedSalon");
        if (loggedSalon == null) return "redirect:/salons/login";

        String successMsg = (String) session.getAttribute("successMsg");
        if (successMsg != null) {
            model.addAttribute("message", successMsg);
            session.removeAttribute("successMsg");
        }

        return "salon/salon-support";
    }

    @PostMapping("/submit")
    public String submitSupportTicket(@RequestParam("subject") String subject,
                                      @RequestParam("message") String message,
                                      HttpSession session) {
        Salon loggedSalon = (Salon) session.getAttribute("loggedSalon");
        if (loggedSalon == null) return "redirect:/salons/login";

        ContactMessage ticket = new ContactMessage();
        ticket.setName(loggedSalon.getName() + " (Salon)");
        ticket.setEmail(loggedSalon.getEmail());
        ticket.setSubject(subject);
        ticket.setMessage(message);
        ticket.setReadByAdmin(false);

        contactMessageRepository.save(ticket);
        
        session.setAttribute("successMsg", "Your support ticket has been submitted. Our team will contact you shortly.");

        return "redirect:/salon/support";
    }
}
