package in.sp.main.Controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import in.sp.main.Entities.EmergencyContact;
import in.sp.main.Service.EmergencyContactService;

import static org.springframework.web.bind.annotation.RequestMethod.*;

@Controller
@RequestMapping("/users/{userId}/emergency-contacts")
public class EmergencyContactController {

    @Autowired
    private EmergencyContactService emergencyContactService;

    // GET all Emergency Contacts
    @RequestMapping(method = GET)
    public String getEmergencyContacts(@PathVariable Long userId, Model model) {
        List<EmergencyContact> contacts = emergencyContactService.getEmergencyContactsByUserId(userId);
        model.addAttribute("contacts", contacts);
        model.addAttribute("userId", userId);
        return "emergency-contact";
    }

    // POST to add a new Emergency Contact
    @RequestMapping(method = POST)
    public String addEmergencyContact(@PathVariable Long userId, @ModelAttribute EmergencyContact contact) {
        emergencyContactService.createEmergencyContact(userId, contact);
        return "redirect:/users/" + userId + "/emergency-contacts";
    }

    // GET to show the update form
    @RequestMapping(value = "/update/{contactId}", method = GET)
    public String showUpdateForm(@PathVariable Long contactId, @PathVariable Long userId, Model model) {
        EmergencyContact contact = emergencyContactService.getEmergencyContactById(contactId)
                .orElseThrow(() -> new RuntimeException("Emergency contact not found"));
        model.addAttribute("contact", contact);
        model.addAttribute("userId", userId);
        return "update-emergency-contact";
    }

    // POST to update Emergency Contact
    @RequestMapping(value = "/update/{contactId}", method = POST)
    public String updateEmergencyContact(@PathVariable Long contactId,
                                         @ModelAttribute EmergencyContact contact,
                                         @PathVariable Long userId) {
        emergencyContactService.updateEmergencyContact(contactId, contact);
        return "redirect:/users/" + userId + "/emergency-contacts";
    }

    // GET to delete Emergency Contact
    @RequestMapping(value = "/delete/{contactId}", method = GET)
    public String deleteEmergencyContact(@PathVariable Long contactId, @PathVariable Long userId) {
        emergencyContactService.deleteEmergencyContact(contactId);
        return "redirect:/users/" + userId + "/emergency-contacts";
    }
}
