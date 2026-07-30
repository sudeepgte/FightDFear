package in.sp.main.Controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import in.sp.main.Entities.TrustedContact;
import in.sp.main.Entities.User;
import in.sp.main.Service.TrustedContactService;
import jakarta.servlet.http.HttpSession;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class TrustedContactController {

    @Autowired
    private TrustedContactService trustedContactService;

    private boolean owns(HttpSession session, Long userId) {
        User user = (User) session.getAttribute("user");
        return user != null && user.getId().equals(userId);
    }

    private boolean ownsContact(HttpSession session, TrustedContact contact) {
        User user = (User) session.getAttribute("user");
        return user != null && contact != null && contact.getUser() != null
                && contact.getUser().getId().equals(user.getId());
    }

    @GetMapping("/users/{userId}/trusted-contacts")
    public String getTrustedContacts(@PathVariable Long userId, Model model, HttpSession session) {
        if (!owns(session, userId)) return "redirect:/login";
        List<TrustedContact> contacts = trustedContactService.getTrustedContactsByUserId(userId);
        model.addAttribute("contacts", contacts);
        model.addAttribute("userId", userId);
        return "trusted-contacts";
    }

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
            @RequestParam(required = false, defaultValue = "true") boolean canReceiveCall,
            HttpSession session) {
        if (!owns(session, userId)) return "redirect:/login";

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

    @DeleteMapping("/users/trusted-contacts/{contactId}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> deleteTrustedContactAjax(
            @PathVariable Long contactId,
            HttpSession session) {

        Map<String, Object> response = new HashMap<>();
        try {
            TrustedContact contact = trustedContactService.getTrustedContactById(contactId);
            if (!ownsContact(session, contact)) {
                response.put("success", false);
                response.put("message", "Access denied");
                return ResponseEntity.status(403).body(response);
            }
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

    @GetMapping("/users/{userId}/trusted-contacts/delete/{contactId}")
    public String deleteTrustedContact(@PathVariable Long contactId, @PathVariable Long userId,
                                       HttpSession session) {
        if (!owns(session, userId)) return "redirect:/login";
        TrustedContact contact = trustedContactService.getTrustedContactById(contactId);
        if (ownsContact(session, contact) && contact.getUser().getId().equals(userId)) {
            trustedContactService.deleteTrustedContact(contactId);
        }
        return "redirect:/users/" + userId + "/trusted-contacts";
    }

    @GetMapping("/users/{userId}/trusted-contacts/update/{contactId}")
    public String showUpdateForm(@PathVariable Long userId, @PathVariable Long contactId,
                                 Model model, HttpSession session) {
        if (!owns(session, userId)) return "redirect:/login";
        TrustedContact contact = trustedContactService.getTrustedContactById(contactId);
        if (!ownsContact(session, contact) || !contact.getUser().getId().equals(userId)) {
            return "redirect:/users/" + userId + "/trusted-contacts";
        }
        model.addAttribute("contact", contact);
        model.addAttribute("userId", userId);
        return "trusted-contact-update";
    }

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
            @RequestParam(required = false, defaultValue = "true") boolean canReceiveCall,
            HttpSession session) {
        if (!owns(session, userId)) return "redirect:/login";
        TrustedContact contact = trustedContactService.getTrustedContactById(contactId);
        if (!ownsContact(session, contact) || !contact.getUser().getId().equals(userId)) {
            return "redirect:/users/" + userId + "/trusted-contacts";
        }

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
