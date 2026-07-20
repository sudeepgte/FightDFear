package in.sp.main.Controller;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import in.sp.main.Entities.EmergencyContact;
import in.sp.main.Entities.PanicLog;
import in.sp.main.Repository.EmergencyContactRepository;
import in.sp.main.Repository.PanicLogRepository;
import in.sp.main.Service.EmailService;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/panic")
public class PanicController {

    @Autowired
    private PanicLogRepository panicLogRepository;

    @Autowired
    private EmergencyContactRepository emergencyContactRepository;

    @Autowired
    private EmailService emailService;

    // ✅ 1. Display Panic Button Page
    @RequestMapping(method = RequestMethod.GET)
    public String showPanicPage() {
        return "panic";
    }

    @RequestMapping(value = "/timer", method = RequestMethod.GET)
    public String showPanicTimer(@RequestParam(value = "time", required = false, defaultValue = "10") int time, Model model) {
        model.addAttribute("time", time);
        return "panic-timer";
    }

    // ✅ 2. Handle Panic Button Press
    @RequestMapping(value = "/activate", method = RequestMethod.POST)
    public String activatePanicButton(@RequestParam("latitude") double latitude,
                                      @RequestParam("longitude") double longitude,
                                      HttpSession session, Model model) {
        Long userId = (Long) session.getAttribute("userId");

        if (userId == null) {
            model.addAttribute("error", "User not logged in!");
            return "panic";
        }

        String location = latitude + ", " + longitude;

        PanicLog panicLog = new PanicLog();
        panicLog.setUserId(userId);
        panicLog.setTimestamp(LocalDateTime.now());
        panicLog.setLocation(location);

        List<EmergencyContact> contacts = emergencyContactRepository.findByUserId(userId);

        if (contacts.isEmpty()) {
            model.addAttribute("warning", "No emergency contacts found!");
        }

        String notifiedContacts = contacts.stream()
                .map(EmergencyContact::getPhone)
                .reduce((a, b) -> a + ", " + b)
                .orElse("No contacts");

        panicLog.setNotifiedContacts(notifiedContacts);
        panicLogRepository.save(panicLog);

        model.addAttribute("message", "🚨 Panic Alert Sent! Contacts Notified: " + notifiedContacts);

        return "panic-button";
    }

    @RequestMapping(value = "/send-location", method = RequestMethod.POST)
    @org.springframework.web.bind.annotation.ResponseBody
    public ResponseEntity<java.util.Map<String, Object>> sendLocation(
            @RequestParam("latitude") double latitude,
            @RequestParam("longitude") double longitude,
            HttpSession session) {

        java.util.Map<String, Object> response = new java.util.HashMap<>();

        // 1. Get logged-in user
        in.sp.main.Entities.User user = (in.sp.main.Entities.User) session.getAttribute("user");
        Long userId = null;
        String userName = "Unknown User";

        if (user != null) {
            userId = user.getId();
            userName = user.getFullName();
        } else {
            userId = (Long) session.getAttribute("userId");
        }

        if (userId == null) {
            response.put("success", false);
            response.put("message", "User not logged in!");
            return ResponseEntity.status(401).body(response);
        }

        // 2. Save PanicLog to database
        String location = latitude + ", " + longitude;
        PanicLog panicLog = new PanicLog();
        panicLog.setUserId(userId);
        panicLog.setTimestamp(LocalDateTime.now());
        panicLog.setLocation(location);

        List<EmergencyContact> contacts = emergencyContactRepository.findByUserId(userId);

        String notifiedContacts = contacts.stream()
                .map(EmergencyContact::getPhone)
                .reduce((a, b) -> a + ", " + b)
                .orElse("No contacts");

        panicLog.setNotifiedContacts(notifiedContacts);
        panicLogRepository.save(panicLog);

        // 3. Send email to each emergency contact with location
        String mapsLink = "https://www.google.com/maps?q=" + latitude + "," + longitude;
        int emailsSent = 0;

        for (EmergencyContact contact : contacts) {
            if (contact.getEmail() != null && !contact.getEmail().isEmpty()) {
                try {
                    String emailBody = "🚨 PANIC ALERT 🚨\n\n"
                        + userName + " has triggered a PANIC alert!\n\n"
                        + "📍 Live Location: " + mapsLink + "\n\n"
                        + "📞 Contact: " + (user != null && user.getPhoneNumber() != null ? user.getPhoneNumber() : "N/A") + "\n\n"
                        + "⏰ Time: " + LocalDateTime.now() + "\n\n"
                        + "Please respond immediately and check on their safety.\n\n"
                        + "This is an automated emergency alert from Fight D Fear Women Safety App.";

                    emailService.sendEmail(
                        contact.getEmail(),
                        "🚨 PANIC ALERT - " + userName + " needs your help!",
                        emailBody
                    );
                    emailsSent++;
                } catch (Exception e) {
                    System.err.println("Failed to email contact: " + contact.getEmail() + " - " + e.getMessage());
                }
            }
        }

        System.out.println("🚨 PANIC ALERT: " + userName + " | Location: " + mapsLink + " | Emails sent: " + emailsSent);

        response.put("success", true);
        response.put("message", "Panic alert sent! " + emailsSent + " contact(s) notified via email.");
        response.put("emailsSent", emailsSent);
        response.put("totalContacts", contacts.size());
        return ResponseEntity.ok(response);
    }
}

