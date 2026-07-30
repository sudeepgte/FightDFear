package in.sp.main.Controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import in.sp.main.Entities.EmergencyContact;
import in.sp.main.Entities.User;
import in.sp.main.Service.EmergencyContactService;
import jakarta.servlet.http.HttpSession;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import static org.springframework.web.bind.annotation.RequestMethod.*;

@Controller
@RequestMapping("/users/{userId}/emergency-contacts")
public class EmergencyContactController {

    @Autowired
    private EmergencyContactService emergencyContactService;

    private boolean owns(HttpSession session, Long userId) {
        User user = (User) session.getAttribute("user");
        return user != null && user.getId().equals(userId);
    }

    @RequestMapping(method = GET)
    public String getEmergencyContacts(@PathVariable Long userId, Model model, HttpSession session,
                                       @ModelAttribute("error") String error,
                                       @ModelAttribute("success") String success) {
        if (!owns(session, userId)) return "redirect:/login";
        List<EmergencyContact> contacts = emergencyContactService.getEmergencyContactsByUserId(userId);
        model.addAttribute("contacts", contacts);
        model.addAttribute("userId", userId);
        model.addAttribute("personalContactCount", emergencyContactService.countPersonalContacts(userId));
        model.addAttribute("maxPersonalContacts", 5);
        model.addAttribute("canAddContact", emergencyContactService.canAddPersonalContact(userId));
        model.addAttribute("error", error);
        model.addAttribute("success", success);
        return "emergency-contact";
    }

    @RequestMapping(method = POST)
    public String addEmergencyContact(@PathVariable Long userId,
                                      @ModelAttribute EmergencyContact contact,
                                      HttpSession session,
                                      RedirectAttributes redirectAttributes) {
        if (!owns(session, userId)) return "redirect:/login";
        try {
            emergencyContactService.createEmergencyContact(userId, contact);
            redirectAttributes.addFlashAttribute("success", "Emergency contact added.");
        } catch (IllegalArgumentException ex) {
            redirectAttributes.addFlashAttribute("error", ex.getMessage());
        }
        return "redirect:/users/" + userId + "/emergency-contacts";
    }

    @RequestMapping(value = "/update/{contactId}", method = GET)
    public String showUpdateForm(@PathVariable Long contactId, @PathVariable Long userId,
                                 Model model, HttpSession session) {
        if (!owns(session, userId)) return "redirect:/login";
        EmergencyContact contact = emergencyContactService.getEmergencyContactById(contactId)
                .orElseThrow(() -> new RuntimeException("Emergency contact not found"));
        if (contact.getUser() == null || !contact.getUser().getId().equals(userId)) {
            return "redirect:/users/" + userId + "/emergency-contacts";
        }
        model.addAttribute("contact", contact);
        model.addAttribute("userId", userId);
        return "update-emergency-contact";
    }

    @RequestMapping(value = "/update/{contactId}", method = POST)
    public String updateEmergencyContact(@PathVariable Long contactId,
                                         @ModelAttribute EmergencyContact contact,
                                         @PathVariable Long userId,
                                         HttpSession session) {
        if (!owns(session, userId)) return "redirect:/login";
        EmergencyContact existing = emergencyContactService.getEmergencyContactById(contactId).orElse(null);
        if (existing == null || existing.getUser() == null || !existing.getUser().getId().equals(userId)) {
            return "redirect:/users/" + userId + "/emergency-contacts";
        }
        emergencyContactService.updateEmergencyContact(contactId, contact);
        return "redirect:/users/" + userId + "/emergency-contacts";
    }

    @RequestMapping(value = "/delete/{contactId}", method = GET)
    public String deleteEmergencyContact(@PathVariable Long contactId, @PathVariable Long userId,
                                         HttpSession session) {
        if (!owns(session, userId)) return "redirect:/login";
        EmergencyContact existing = emergencyContactService.getEmergencyContactById(contactId).orElse(null);
        if (existing != null && existing.getUser() != null && existing.getUser().getId().equals(userId)) {
            emergencyContactService.deleteEmergencyContact(contactId);
        }
        return "redirect:/users/" + userId + "/emergency-contacts";
    }
}
