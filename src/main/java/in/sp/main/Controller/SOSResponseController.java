package in.sp.main.Controller;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import in.sp.main.Service.SosService;

/**
 * Webhook controller for handling SOS responses from contacts
 * Contacts click accept/reject links in SMS/Email
 */
@Controller
@RequestMapping("/sos")
public class SOSResponseController {

    @Autowired
    private SosService sosService;

    /**
     * Handle accept/reject response from SMS/Email link
     * URL: /sos/respond?token=xxx&action=accept
     */
    @GetMapping("/respond")
    public String handleResponse(
            @RequestParam String token,
            @RequestParam String action,
            @RequestParam(required = false, defaultValue = "") String message,
            Model model) {
        
        Map<String, Object> result = sosService.handleContactResponse(token, action, message);
        
        model.addAttribute("success", result.get("success"));
        model.addAttribute("message", result.get("message"));
        model.addAttribute("contactName", result.get("contactName"));
        model.addAttribute("action", result.get("action"));
        
        return "sos-response-page";
    }

    /**
     * REST API: Get SOS status (for real-time polling)
     */
    @GetMapping("/status/{sosId}")
    @ResponseBody
    public Map<String, Object> getSOSStatus(@PathVariable Long sosId) {
        return sosService.getSOSStatus(sosId);
    }

    /**
     * REST API: Cancel SOS
     */
    @PostMapping("/cancel/{sosId}")
    @ResponseBody
    public Map<String, Object> cancelSOS(
            @PathVariable Long sosId,
            @RequestParam Long userId) {
        
        boolean cancelled = sosService.cancelSOS(sosId, userId);
        
        Map<String, Object> response = new java.util.HashMap<>();
        response.put("success", cancelled);
        response.put("message", cancelled ? "SOS cancelled successfully" : "Could not cancel SOS");
        return response;
    }

    /**
     * REST API: Get user's SOS history
     */
    @GetMapping("/history")
    @ResponseBody
    public Map<String, Object> getSOSHistory(@RequestParam Long userId) {
        Map<String, Object> response = new java.util.HashMap<>();
        response.put("history", sosService.getUserSOSHistory(userId));
        return response;
    }
}
