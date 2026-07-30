package in.sp.main.Controller;

import in.sp.main.Entities.BuddyRequest;
import in.sp.main.Entities.User;
import in.sp.main.Service.BuddyService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/buddy")
public class MobileBuddyController {

    @Autowired
    private BuddyService buddyService;

    @GetMapping("/state")
    public ResponseEntity<Map<String, Object>> state(HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        Map<String, Object> out = new LinkedHashMap<>();
        out.put("success", true);
        out.put("activeAvailability", buddyService.getActiveAvailability(user) != null);
        out.putAll(buddyService.pendingRequestsPayload(user));
        return ResponseEntity.ok(out);
    }

    @GetMapping("/matches")
    public ResponseEntity<Map<String, Object>> matches(
            @RequestParam double latitude,
            @RequestParam double longitude,
            @RequestParam String destination,
            @RequestParam(defaultValue = "3") double radiusKm,
            HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        try {
            List<Map<String, Object>> matches = buddyService.findMatches(user, latitude, longitude, destination, radiusKm);
            return ResponseEntity.ok(ok(Map.of("matches", matches, "count", matches.size())));
        } catch (IllegalStateException e) {
            return ResponseEntity.badRequest().body(fail(e.getMessage()));
        }
    }

    @PostMapping("/availability/start")
    public ResponseEntity<Map<String, Object>> start(@RequestBody Map<String, Object> body, HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        try {
            buddyService.startAvailability(
                    user,
                    dbl(body.get("latitude")),
                    dbl(body.get("longitude")),
                    str(body.get("destination")),
                    body.get("windowMinutes") == null ? 60 : intVal(body.get("windowMinutes"), 60));
            return ResponseEntity.ok(ok(Map.of("message", "Buddy Mode started.")));
        } catch (IllegalStateException e) {
            return ResponseEntity.badRequest().body(fail(e.getMessage()));
        }
    }

    @PostMapping("/availability/stop")
    public ResponseEntity<Map<String, Object>> stop(HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        buddyService.stopAvailability(user);
        return ResponseEntity.ok(ok(Map.of("message", "Buddy Mode stopped.")));
    }

    @PostMapping("/request")
    public ResponseEntity<Map<String, Object>> send(@RequestBody Map<String, Object> body, HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        Long availabilityId = longVal(body.get("availabilityId"));
        if (availabilityId == null) return badRequest("availabilityId is required");
        try {
            BuddyRequest r = buddyService.sendRequest(user, availabilityId);
            return ResponseEntity.ok(ok(Map.of("message", "Request sent.", "requestId", r.getId())));
        } catch (IllegalStateException e) {
            return ResponseEntity.badRequest().body(fail(e.getMessage()));
        }
    }

    @PostMapping("/request/{id}/accept")
    public ResponseEntity<Map<String, Object>> accept(@PathVariable Long id, HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        try {
            buddyService.accept(user, id);
            return ResponseEntity.ok(ok(Map.of("message", "Request accepted.")));
        } catch (IllegalStateException e) {
            return ResponseEntity.badRequest().body(fail(e.getMessage()));
        }
    }

    @PostMapping("/request/{id}/reject")
    public ResponseEntity<Map<String, Object>> reject(@PathVariable Long id, HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        try {
            buddyService.reject(user, id);
            return ResponseEntity.ok(ok(Map.of("message", "Request rejected.")));
        } catch (IllegalStateException e) {
            return ResponseEntity.badRequest().body(fail(e.getMessage()));
        }
    }

    private User requireUser(HttpSession session) {
        Object u = session == null ? null : session.getAttribute("user");
        return u instanceof User ? (User) u : null;
    }

    private ResponseEntity<Map<String, Object>> unauthorized() {
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(fail("Login required"));
    }

    private ResponseEntity<Map<String, Object>> badRequest(String error) {
        return ResponseEntity.badRequest().body(fail(error));
    }

    private static Map<String, Object> ok(Map<String, Object> data) {
        Map<String, Object> out = new LinkedHashMap<>();
        out.put("success", true);
        out.putAll(data);
        return out;
    }

    private static Map<String, Object> fail(String error) {
        return Map.of("success", false, "error", error);
    }

    private static String str(Object v) { return v == null ? "" : v.toString().trim(); }
    private static double dbl(Object v) { return v instanceof Number n ? n.doubleValue() : Double.parseDouble(v.toString()); }
    private static int intVal(Object v, int def) {
        if (v instanceof Number n) return n.intValue();
        try { return Integer.parseInt(v.toString()); } catch (Exception e) { return def; }
    }
    private static Long longVal(Object v) {
        if (v instanceof Number n) return n.longValue();
        try { return Long.parseLong(v.toString()); } catch (Exception e) { return null; }
    }
}
