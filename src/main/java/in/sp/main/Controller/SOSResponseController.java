package in.sp.main.Controller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import in.sp.main.Entities.User;
import in.sp.main.Service.SosService;
import jakarta.servlet.http.HttpSession;

/**
 * Contact response links (token) + authenticated SOS status/cancel/history APIs.
 */
@Controller
@RequestMapping("/sos")
public class SOSResponseController {

    @Autowired
    private SosService sosService;

    /**
     * Public tokenized link from SMS/Email — must stay unauthenticated.
     * URL: /sos/respond?token=xxx&action=accept
     */
    @GetMapping("/respond")
    public String handleResponse(
            @RequestParam String token,
            @RequestParam String action,
            @RequestParam(required = false, defaultValue = "") String message,
            Model model) {

        if (!"accept".equalsIgnoreCase(action) && !"reject".equalsIgnoreCase(action)) {
            model.addAttribute("success", false);
            model.addAttribute("message", "Invalid action");
            return "sos-response-page";
        }

        Map<String, Object> result = sosService.handleContactResponse(token, action.toLowerCase(), message);

        model.addAttribute("success", result.get("success"));
        model.addAttribute("message", result.get("message"));
        model.addAttribute("contactName", result.get("contactName"));
        model.addAttribute("action", result.get("action"));

        return "sos-response-page";
    }

    @GetMapping("/status/{sosId}")
    @ResponseBody
    public Map<String, Object> getSOSStatus(@PathVariable Long sosId, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            Map<String, Object> error = new HashMap<>();
            error.put("error", "Login required");
            return error;
        }
        return sosService.getSOSStatusForUser(sosId, user.getId());
    }

    @PostMapping("/cancel/{sosId}")
    @ResponseBody
    public Map<String, Object> cancelSOS(@PathVariable Long sosId, HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.put("success", false);
            response.put("message", "Login required");
            return response;
        }

        boolean cancelled = sosService.cancelSOS(sosId, user.getId());
        response.put("success", cancelled);
        response.put("message", cancelled ? "SOS cancelled successfully" : "Could not cancel SOS");
        return response;
    }

    @GetMapping("/history")
    @ResponseBody
    public Map<String, Object> getSOSHistory(HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.put("error", "Login required");
            return response;
        }
        response.put("history", sosService.getUserSOSHistory(user.getId()));
        return response;
    }
}
