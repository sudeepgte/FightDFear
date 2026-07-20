package in.sp.main.Controller;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import in.sp.main.Entities.JourneySession;
import in.sp.main.Entities.User;
import in.sp.main.Service.JourneyService;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/journey")
public class JourneyController {

    @Autowired
    private JourneyService journeyService;

    @GetMapping
    public String page(Model model, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) return "redirect:/login";

        model.addAttribute("user", user);
        model.addAttribute("activeJourney", journeyService.active(user));
        return "journey";
    }

    @GetMapping("/active")
    @ResponseBody
    public ResponseEntity<?> active(HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(res(false, "Login required."));

        JourneySession js = journeyService.active(user);
        Map<String, Object> out = new HashMap<>();
        out.put("ok", true);
        out.put("active", js != null);
        if (js != null) {
            out.put("id", js.getId());
            out.put("destinationText", js.getDestinationText());
            out.put("startFromText", js.getStartFromText());
            out.put("expectedArrivalAt", js.getExpectedArrivalAt());
            out.put("status", js.getStatus() != null ? js.getStatus().name() : null);
        }
        return ResponseEntity.ok(out);
    }

    @PostMapping("/start")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> start(@RequestParam String destination,
                                                     @RequestParam String startFrom,
                                                     @RequestParam long expectedArrivalEpochMs,
                                                     @RequestParam(required = false) Double latitude,
                                                     @RequestParam(required = false) Double longitude,
                                                     HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(res(false, "Login required."));

        String dest = destination == null ? "" : destination.trim();
        if (dest.isEmpty() || dest.length() > 100) {
            return ResponseEntity.badRequest().body(res(false, "Please enter a destination."));
        }

        String from = startFrom == null ? "" : startFrom.trim();
        if (from.isEmpty() || from.length() > 100) {
            return ResponseEntity.badRequest().body(res(false, "Please enter where you are starting from."));
        }

        Date expected = new Date(expectedArrivalEpochMs);
        if (expected.before(new Date(System.currentTimeMillis() + 60_000))) {
            return ResponseEntity.badRequest().body(res(false, "Expected arrival must be at least 1 minute in the future."));
        }

        journeyService.start(user, dest, from, expected, latitude, longitude);
        return ResponseEntity.ok(res(true, "Journey timer started."));
    }

    @PostMapping("/safe")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> safe(HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(res(false, "Login required."));

        JourneySession js = journeyService.markSafe(user);
        if (js == null) return ResponseEntity.badRequest().body(res(false, "No active journey timer."));
        return ResponseEntity.ok(res(true, "Marked safe. Great!"));
    }

    @PostMapping("/cancel")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> cancel(HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(res(false, "Login required."));

        JourneySession js = journeyService.cancel(user);
        if (js == null) return ResponseEntity.badRequest().body(res(false, "No active journey timer."));
        return ResponseEntity.ok(res(true, "Journey timer cancelled."));
    }

    private static Map<String, Object> res(boolean ok, String message) {
        Map<String, Object> m = new HashMap<>();
        m.put("ok", ok);
        m.put("message", message);
        return m;
    }
}

