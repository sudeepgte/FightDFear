package in.sp.main.Controller;

import in.sp.main.Entities.SOSRequest;
import in.sp.main.Entities.User;
import in.sp.main.Service.SosService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.Optional;

/**
 * REST SOS APIs for native / Flutter clients (Bearer JWT via session hydration).
 */
@RestController
@RequestMapping("/api/sos")
public class SOSRestController {

    @Autowired
    private SosService sosService;

    @PostMapping("/trigger")
    public ResponseEntity<Map<String, Object>> triggerSOS(
            @RequestBody Map<String, String> payload,
            HttpSession session) {
        Map<String, Object> response = new LinkedHashMap<>();
        User loggedInUser = (User) session.getAttribute("user");
        if (loggedInUser == null) {
            response.put("success", false);
            response.put("error", "Login required to trigger SOS");
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(response);
        }

        try {
            if (payload == null || payload.get("latitude") == null || payload.get("longitude") == null) {
                response.put("success", false);
                response.put("error", "latitude and longitude are required");
                return ResponseEntity.badRequest().body(response);
            }

            double lat = Double.parseDouble(payload.get("latitude"));
            double lng = Double.parseDouble(payload.get("longitude"));
            if (lat < -90 || lat > 90 || lng < -180 || lng > 180) {
                response.put("success", false);
                response.put("error", "Invalid coordinates");
                return ResponseEntity.badRequest().body(response);
            }

            Map<String, Object> result = sosService.triggerSOS(loggedInUser.getId(), lat, lng);
            if (result.containsKey("error")) {
                response.put("success", false);
                response.put("error", result.get("error"));
                response.putAll(result);
                return ResponseEntity.badRequest().body(response);
            }

            response.put("success", true);
            response.putAll(triggerFields(result));
            return ResponseEntity.ok(response);
        } catch (NumberFormatException e) {
            response.put("success", false);
            response.put("error", "Invalid latitude/longitude");
            return ResponseEntity.badRequest().body(response);
        } catch (Exception e) {
            response.put("success", false);
            response.put("error", e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    @GetMapping("/active")
    public ResponseEntity<Map<String, Object>> activeSOS(HttpSession session) {
        Map<String, Object> response = new LinkedHashMap<>();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.put("success", false);
            response.put("error", "Login required");
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(response);
        }

        Optional<SOSRequest> active = sosService.getActiveSOSForUser(user.getId());
        response.put("success", true);
        response.put("active", active.isPresent());
        if (active.isPresent()) {
            SOSRequest sos = active.get();
            response.put("sosId", sos.getId());
            response.put("status", sos.getStatus().toString());
            response.put("autoCallPhone", sos.getAutoCallPhone());
            response.put("mapsLink", sos.getGoogleMapsLink());
            response.put("contactsNotified", sos.getTotalContactsNotified());
            response.put("volunteersAlerted", sos.getVolunteersAlerted());
        }
        return ResponseEntity.ok(response);
    }

    @GetMapping("/status/{sosId}")
    public ResponseEntity<Map<String, Object>> status(
            @PathVariable Long sosId,
            HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body(Map.of("success", false, "error", "Login required"));
        }

        Map<String, Object> status = sosService.getSOSStatusForUser(sosId, user.getId());
        if (status.containsKey("error")) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(status);
        }
        status.put("success", true);
        return ResponseEntity.ok(status);
    }

    @PostMapping("/cancel/{sosId}")
    public ResponseEntity<Map<String, Object>> cancel(
            @PathVariable Long sosId,
            HttpSession session) {
        Map<String, Object> response = new LinkedHashMap<>();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.put("success", false);
            response.put("error", "Login required");
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(response);
        }

        boolean cancelled = sosService.cancelSOS(sosId, user.getId());
        response.put("success", cancelled);
        response.put("message", cancelled ? "SOS cancelled successfully" : "Could not cancel SOS");
        return cancelled ? ResponseEntity.ok(response)
                : ResponseEntity.badRequest().body(response);
    }

    @GetMapping("/history")
    public ResponseEntity<Map<String, Object>> history(HttpSession session) {
        Map<String, Object> response = new LinkedHashMap<>();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.put("success", false);
            response.put("error", "Login required");
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(response);
        }

        response.put("success", true);
        response.put("history", sosService.getUserSOSHistory(user.getId()));
        return ResponseEntity.ok(response);
    }

    private Map<String, Object> triggerFields(Map<String, Object> result) {
        Map<String, Object> fields = new HashMap<>();
        fields.put("message", result.getOrDefault("message", "SOS activated"));
        fields.put("sosId", result.get("sosId"));
        fields.put("alertId", result.get("sosId"));
        fields.put("status", result.getOrDefault("status", "ACTIVE"));
        fields.put("contactsNotified", result.getOrDefault("contactsNotified", 0));
        fields.put("volunteersAlerted", result.getOrDefault("volunteersAlerted", 0));
        fields.put("autoCallPhone", result.get("autoCallPhone"));
        fields.put("mapsLink", result.get("mapsLink"));
        fields.put("smsConfigured", result.get("smsConfigured"));
        fields.put("alreadyActive", result.getOrDefault("alreadyActive", false));
        if (result.get("whatsappShares") != null) {
            fields.put("whatsappShares", result.get("whatsappShares"));
        }
        return fields;
    }
}
