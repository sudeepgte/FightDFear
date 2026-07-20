package in.sp.main.Controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import in.sp.main.Entities.BuddyRequest;
import in.sp.main.Entities.User;
import in.sp.main.Service.BuddyService;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/buddy")
public class BuddyController {

    @Autowired
    private BuddyService buddyService;

    @GetMapping
    public String buddyPage(Model model, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) return "redirect:/login";

        // Purpose: show current state + pending requests in the UI.
        model.addAttribute("user", user);
        model.addAttribute("activeAvailability", buddyService.getActiveAvailability(user));
        model.addAttribute("incoming", buddyService.incomingPending(user));
        model.addAttribute("outgoing", buddyService.outgoingPending(user));
        return "buddy";
    }

    @PostMapping("/availability/start")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> start(@RequestParam double latitude,
                                                     @RequestParam double longitude,
                                                     @RequestParam String destination,
                                                     @RequestParam(defaultValue = "60") int windowMinutes,
                                                     HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(res(false, "Login required."));

        try {
            buddyService.startAvailability(user, latitude, longitude, destination, windowMinutes);
            return ResponseEntity.ok(res(true, "Buddy Mode started."));
        } catch (IllegalStateException e) {
            return ResponseEntity.status(mapCode(e.getMessage())).body(res(false, msgFor(e.getMessage())));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(res(false, "Failed to start Buddy Mode."));
        }
    }

    @PostMapping("/availability/stop")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> stop(HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(res(false, "Login required."));

        buddyService.stopAvailability(user);
        return ResponseEntity.ok(res(true, "Buddy Mode stopped."));
    }

    @GetMapping("/requests")
    @ResponseBody
    public ResponseEntity<?> pendingRequests(HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(res(false, "Login required."));

        Map<String, Object> out = buddyService.pendingRequestsPayload(user);
        out.put("ok", true);
        return ResponseEntity.ok(out);
    }

    @GetMapping("/matches")
    @ResponseBody
    public ResponseEntity<?> matches(@RequestParam double latitude,
                                     @RequestParam double longitude,
                                     @RequestParam String destination,
                                     @RequestParam(defaultValue = "3") double radiusKm,
                                     HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(res(false, "Login required."));

        try {
            List<Map<String, Object>> matches = buddyService.findMatches(user, latitude, longitude, destination, radiusKm);
            Map<String, Object> out = new HashMap<>();
            out.put("ok", true);
            out.put("matches", matches);
            return ResponseEntity.ok(out);
        } catch (IllegalStateException e) {
            return ResponseEntity.status(mapCode(e.getMessage())).body(res(false, msgFor(e.getMessage())));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(res(false, "Failed to fetch matches."));
        }
    }

    @PostMapping("/request")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> send(@RequestParam Long availabilityId, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(res(false, "Login required."));

        try {
            BuddyRequest r = buddyService.sendRequest(user, availabilityId);
            Map<String, Object> out = res(true, "Request sent.");
            out.put("requestId", r.getId());
            return ResponseEntity.ok(out);
        } catch (IllegalStateException e) {
            return ResponseEntity.status(mapCode(e.getMessage())).body(res(false, msgFor(e.getMessage())));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(res(false, "Failed to send request."));
        }
    }

    @PostMapping("/request/{id}/accept")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> accept(@PathVariable Long id, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(res(false, "Login required."));

        try {
            BuddyRequest r = buddyService.accept(user, id);
            // Purpose: handoff to existing in-app chat window after acceptance.
            Long otherId = (r.getFromUser() != null) ? r.getFromUser().getId() : null;
            Map<String, Object> out = res(true, "Accepted.");
            if (otherId != null) {
                out.put("chatUrl", "/chat/window/" + otherId);
                out.put("buddyId", otherId);
            }
            return ResponseEntity.ok(out);
        } catch (IllegalStateException e) {
            return ResponseEntity.status(mapCode(e.getMessage())).body(res(false, msgFor(e.getMessage())));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(res(false, "Failed to accept request."));
        }
    }

    @PostMapping("/request/{id}/reject")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> reject(@PathVariable Long id, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(res(false, "Login required."));

        try {
            buddyService.reject(user, id);
            return ResponseEntity.ok(res(true, "Rejected."));
        } catch (IllegalStateException e) {
            return ResponseEntity.status(mapCode(e.getMessage())).body(res(false, msgFor(e.getMessage())));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(res(false, "Failed to reject request."));
        }
    }

    private static Map<String, Object> res(boolean ok, String message) {
        Map<String, Object> m = new HashMap<>();
        m.put("ok", ok);
        m.put("message", message);
        return m;
    }

    private static HttpStatus mapCode(String code) {
        // Purpose: map service error codes to HTTP codes for the frontend.
        if ("USER_NOT_VERIFIED".equals(code)) return HttpStatus.FORBIDDEN;
        if ("RATE_LIMIT".equals(code)) return HttpStatus.TOO_MANY_REQUESTS;
        if ("AVAILABILITY_NOT_ACTIVE".equals(code)) return HttpStatus.BAD_REQUEST;
        if ("CANNOT_REQUEST_SELF".equals(code)) return HttpStatus.BAD_REQUEST;
        if ("TARGET_NOT_VERIFIED".equals(code)) return HttpStatus.BAD_REQUEST;
        if ("FORBIDDEN".equals(code)) return HttpStatus.FORBIDDEN;
        if ("NOT_FOUND".equals(code)) return HttpStatus.NOT_FOUND;
        if ("NOT_PENDING".equals(code)) return HttpStatus.BAD_REQUEST;
        return HttpStatus.BAD_REQUEST;
    }

    private static String msgFor(String code) {
        // Purpose: keep user-facing messages friendly and non-technical.
        if ("USER_NOT_VERIFIED".equals(code)) return "Your account is pending admin verification.";
        if ("RATE_LIMIT".equals(code)) return "Please wait before sending another request.";
        if ("AVAILABILITY_NOT_ACTIVE".equals(code)) return "That buddy listing is no longer active.";
        if ("CANNOT_REQUEST_SELF".equals(code)) return "You cannot request yourself.";
        if ("TARGET_NOT_VERIFIED".equals(code)) return "That user is not verified.";
        if ("FORBIDDEN".equals(code)) return "Not allowed.";
        if ("NOT_FOUND".equals(code)) return "Request not found.";
        if ("NOT_PENDING".equals(code)) return "Request is no longer pending.";
        return "Request failed.";
    }
}

