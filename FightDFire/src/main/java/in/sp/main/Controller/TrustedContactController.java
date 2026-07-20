package in.sp.main.Controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import in.sp.main.Entities.TrustedContact;
import in.sp.main.Entities.User;
import in.sp.main.Repository.UserRepository;
import in.sp.main.Service.TrustedContactService;
import jakarta.servlet.http.HttpSession;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class TrustedContactController {

    @Autowired
    private TrustedContactService trustedContactService;

    @Autowired
    private UserRepository userRepository;

    // READ - View all trusted contacts for a specific user
    @GetMapping("/users/{userId}/trusted-contacts")
    public String getTrustedContacts(@PathVariable Long userId, Model model) {
        List<TrustedContact> contacts = trustedContactService.getTrustedContactsByUserId(userId);
        model.addAttribute("contacts", contacts);
        model.addAttribute("userId", userId);
        return "trusted-contacts"; // returns trusted-contacts.jsp (our new page)
    }

    // CREATE - Add a new trusted contact
    @PostMapping("/users/{userId}/trusted-contacts")
    public String addTrustedContact(
            @PathVariable Long userId,
            @RequestParam String name,
            @RequestParam String phone,
            @RequestParam(required = false) String email,
            @RequestParam String relation,
            @RequestParam(required = false, defaultValue = "false") boolean isPrimary,
            @RequestParam(required = false, defaultValue = "true") boolean canReceiveSMS,
            @RequestParam(required = false, defaultValue = "true") boolean canReceiveEmail,
            @RequestParam(required = false, defaultValue = "true") boolean canReceiveCall) {
        
        TrustedContact contact = new TrustedContact();
        contact.setName(name);
        contact.setPhone(phone);
        contact.setEmail(email);
        contact.setRelation(relation);
        contact.setPrimary(isPrimary);
        contact.setCanReceiveSMS(canReceiveSMS);
        contact.setCanReceiveEmail(canReceiveEmail);
        contact.setCanReceiveCall(canReceiveCall);
        
        trustedContactService.createTrustedContact(userId, contact);
        return "redirect:/users/" + userId + "/trusted-contacts";
    }

    // DELETE - Delete a trusted contact (AJAX)
    @DeleteMapping("/users/trusted-contacts/{contactId}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> deleteTrustedContactAjax(
            @PathVariable Long contactId,
            HttpSession session) {
        
        Map<String, Object> response = new HashMap<>();
        try {
            trustedContactService.deleteTrustedContact(contactId);
            response.put("success", true);
            response.put("message", "Contact deleted successfully");
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Failed to delete contact: " + e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }

    // DELETE - Delete a trusted contact (Traditional)
    @GetMapping("/users/{userId}/trusted-contacts/delete/{contactId}")
    public String deleteTrustedContact(@PathVariable Long contactId, @PathVariable Long userId) {
        trustedContactService.deleteTrustedContact(contactId);
        return "redirect:/users/" + userId + "/trusted-contacts";
    }

    // UPDATE - Show form to update a trusted contact
    @GetMapping("/users/{userId}/trusted-contacts/update/{contactId}")
    public String showUpdateForm(@PathVariable Long userId, @PathVariable Long contactId, Model model) {
        TrustedContact contact = trustedContactService.getTrustedContactById(contactId);
        model.addAttribute("contact", contact);
        model.addAttribute("userId", userId);
        return "trusted-contact-update";
    }

    // UPDATE - Update the trusted contact
    @PostMapping("/users/{userId}/trusted-contacts/update/{contactId}")
    public String updateTrustedContact(
            @PathVariable Long userId,
            @PathVariable Long contactId,
            @RequestParam String name,
            @RequestParam String phone,
            @RequestParam(required = false) String email,
            @RequestParam String relation,
            @RequestParam(required = false, defaultValue = "false") boolean isPrimary,
            @RequestParam(required = false, defaultValue = "true") boolean canReceiveSMS,
            @RequestParam(required = false, defaultValue = "true") boolean canReceiveEmail,
            @RequestParam(required = false, defaultValue = "true") boolean canReceiveCall) {
        
        TrustedContact contact = trustedContactService.getTrustedContactById(contactId);
        contact.setName(name);
        contact.setPhone(phone);
        contact.setEmail(email);
        contact.setRelation(relation);
        contact.setPrimary(isPrimary);
        contact.setCanReceiveSMS(canReceiveSMS);
        contact.setCanReceiveEmail(canReceiveEmail);
        contact.setCanReceiveCall(canReceiveCall);
        
        trustedContactService.updateTrustedContact(contactId, contact);
        return "redirect:/users/" + userId + "/trusted-contacts";
    }
}
