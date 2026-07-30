package in.sp.main.Controller;

import in.sp.main.Entities.JourneySession;
import in.sp.main.Entities.User;
import in.sp.main.Service.JourneyService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Date;
import java.util.LinkedHashMap;
import java.util.Map;

/**
 * JSON Journey Safety Tracker APIs for Flutter / native clients (Bearer JWT).
 */
@RestController
@RequestMapping("/api/journey")
public class MobileJourneyController {

    @Autowired
    private JourneyService journeyService;

    @GetMapping("/active")
    public ResponseEntity<Map<String, Object>> active(HttpSession session) {
        User user = requireUser(session);
        if (user == null) {
            return unauthorized();
        }

        JourneySession js = journeyService.activeOrAlerted(user);
        Map<String, Object> response = new LinkedHashMap<>();
        response.put("success", true);
        response.put("active", js != null && js.getStatus() != null
                && ("ACTIVE".equals(js.getStatus().name()) || "ALERTED".equals(js.getStatus().name())));
        if (js != null) {
            response.putAll(sessionDto(js));
        }
        return ResponseEntity.ok(response);
    }

    @PostMapping("/start")
    public ResponseEntity<Map<String, Object>> start(
            @RequestBody Map<String, Object> body,
            HttpSession session) {
        User user = requireUser(session);
        if (user == null) {
            return unauthorized();
        }
        if (body == null) {
            return badRequest("Request body is required");
        }

        String destination = str(body.get("destination"));
        String startFrom = str(body.get("startFrom"));
        if (destination.isEmpty() || destination.length() > 100) {
            return badRequest("Please enter a destination (max 100 characters).");
        }
        if (startFrom.isEmpty() || startFrom.length() > 100) {
            return badRequest("Please enter where you are starting from (max 100 characters).");
        }

        Long epochMs = asLong(body.get("expectedArrivalEpochMs"));
        if (epochMs == null) {
            return badRequest("expectedArrivalEpochMs is required");
        }
        Date expected = new Date(epochMs);
        if (expected.before(new Date(System.currentTimeMillis() + 60_000))) {
            return badRequest("Expected arrival must be at least 1 minute in the future.");
        }

        Double lat = asDouble(body.get("latitude"));
        Double lng = asDouble(body.get("longitude"));

        JourneySession js = journeyService.start(user, destination, startFrom, expected, lat, lng);
        Map<String, Object> response = new LinkedHashMap<>();
        response.put("success", true);
        response.put("message", "Journey timer started.");
        response.put("active", true);
        response.putAll(sessionDto(js));
        return ResponseEntity.ok(response);
    }

    @PostMapping("/safe")
    public ResponseEntity<Map<String, Object>> safe(HttpSession session) {
        User user = requireUser(session);
        if (user == null) {
            return unauthorized();
        }

        JourneySession js = journeyService.markSafe(user);
        if (js == null) {
            return badRequest("No active journey timer.");
        }
        Map<String, Object> response = new LinkedHashMap<>();
        response.put("success", true);
        response.put("message", "Marked safe. Great!");
        response.put("active", false);
        response.putAll(sessionDto(js));
        return ResponseEntity.ok(response);
    }

    @PostMapping("/cancel")
    public ResponseEntity<Map<String, Object>> cancel(HttpSession session) {
        User user = requireUser(session);
        if (user == null) {
            return unauthorized();
        }

        JourneySession js = journeyService.cancel(user);
        if (js == null) {
            return badRequest("No active journey timer.");
        }
        Map<String, Object> response = new LinkedHashMap<>();
        response.put("success", true);
        response.put("message", "Journey timer cancelled.");
        response.put("active", false);
        response.putAll(sessionDto(js));
        return ResponseEntity.ok(response);
    }

    private Map<String, Object> sessionDto(JourneySession js) {
        Map<String, Object> dto = new LinkedHashMap<>();
        dto.put("id", js.getId());
        dto.put("destinationText", js.getDestinationText());
        dto.put("startFromText", js.getStartFromText());
        dto.put("status", js.getStatus() == null ? null : js.getStatus().name());
        dto.put("expectedArrivalAt", js.getExpectedArrivalAt() == null
                ? null
                : js.getExpectedArrivalAt().toInstant().toString());
        dto.put("expectedArrivalEpochMs", js.getExpectedArrivalAt() == null
                ? null
                : js.getExpectedArrivalAt().getTime());
        dto.put("createdAt", js.getCreatedAt() == null ? null : js.getCreatedAt().toInstant().toString());
        dto.put("startLat", js.getStartLat());
        dto.put("startLng", js.getStartLng());
        dto.put("alertedAt", js.getAlertedAt() == null ? null : js.getAlertedAt().toInstant().toString());
        return dto;
    }

    private User requireUser(HttpSession session) {
        if (session == null) return null;
        Object u = session.getAttribute("user");
        return u instanceof User ? (User) u : null;
    }

    private ResponseEntity<Map<String, Object>> unauthorized() {
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                .body(Map.of("success", false, "error", "Login required"));
    }

    private ResponseEntity<Map<String, Object>> badRequest(String error) {
        Map<String, Object> body = new LinkedHashMap<>();
        body.put("success", false);
        body.put("error", error);
        return ResponseEntity.badRequest().body(body);
    }

    private static String str(Object v) {
        return v == null ? "" : v.toString().trim();
    }

    private static Long asLong(Object v) {
        if (v == null) return null;
        if (v instanceof Number) return ((Number) v).longValue();
        try {
            return Long.parseLong(v.toString().trim());
        } catch (NumberFormatException e) {
            return null;
        }
    }

    private static Double asDouble(Object v) {
        if (v == null) return null;
        if (v instanceof Number) return ((Number) v).doubleValue();
        try {
            return Double.parseDouble(v.toString().trim());
        } catch (NumberFormatException e) {
            return null;
        }
    }
}
