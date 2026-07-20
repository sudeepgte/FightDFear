package in.sp.main.Controller;

import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import in.sp.main.Entities.User;
import in.sp.main.Entities.SOSRequest;
import in.sp.main.Service.SosService;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/sos")
public class SosActivationController {

    @Autowired
    private SosService sosService;

    /**
     * Serve the Volunteer Help Dashboard
     */
    @GetMapping("/help-dashboard")
    public String showHelpDashboard(@RequestParam("sosId") Long sosId, HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }
        
        Map<String, Object> sosDetails = sosService.getSOSRequestDetails(sosId);
        if (sosDetails == null) {
            return "redirect:/users/dashboard";
        }
        
        model.addAttribute("sos", sosDetails);
        model.addAttribute("user", user);
        return "volunteer-help-dashboard";
    }

    /**
     * Serve the SOS Dashboard page
     */
    @GetMapping("/dashboard")
    public String showSosDashboard(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }
        
        // Check for active SOS to restore state on refresh
        Optional<SOSRequest> activeSos = sosService.getActiveSOSForUser(user.getId());
        if (activeSos.isPresent()) {
            model.addAttribute("activeSosId", activeSos.get().getId());
            model.addAttribute("isSosActive", true);
        } else {
            model.addAttribute("isSosActive", false);
        }
        
        model.addAttribute("userId", user.getId());
        model.addAttribute("user", user);
        return "sos-dashboard";
    }

    /**
     * REST API: Trigger SOS emergency
     * Called by frontend after countdown expires
     */
    @PostMapping("/trigger")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> triggerSos(
            @RequestParam("latitude") double latitude,
            @RequestParam("longitude") double longitude,
            HttpSession session) {

        User user = (User) session.getAttribute("user");
        if (user == null) {
            Map<String, Object> error = new HashMap<>();
            error.put("error", "User not logged in");
            return ResponseEntity.status(401).body(error);
        }

        Map<String, Object> result = sosService.triggerSOS(user.getId(), latitude, longitude);
        return ResponseEntity.ok(result);
    }

    /**
     * REST API: Check for nearby active SOS alerts (Polling endpoint for volunteers)
     */
    @GetMapping("/alerts")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> checkAlerts(HttpSession session) {
        User user = (User) session.getAttribute("user");
        Map<String, Object> response = new HashMap<>();
        
        if (user == null) {
            response.put("sosActive", false);
            return ResponseEntity.ok(response);
        }
        
        Long sosId = sosService.getActiveNearbySosId(user.getId());
        response.put("sosActive", sosId != null);
        response.put("sosId", sosId);
        return ResponseEntity.ok(response);
    }

    /**
     * REST API: Volunteer responds to SOS (Accept/Decline)
     */
    @PostMapping("/volunteer/respond")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> volunteerRespond(
            @RequestParam("sosId") Long sosId,
            @RequestParam("action") String action,
            HttpSession session) {
        
        User volunteer = (User) session.getAttribute("user");
        if (volunteer == null) {
            Map<String, Object> error = new HashMap<>();
            error.put("error", "Not logged in");
            return ResponseEntity.status(401).body(error);
        }

        Map<String, Object> result = sosService.handleVolunteerResponse(sosId, volunteer.getId(), action);
        return ResponseEntity.ok(result);
    }
}
