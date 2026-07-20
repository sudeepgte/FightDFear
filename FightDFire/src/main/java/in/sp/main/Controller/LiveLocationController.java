package in.sp.main.Controller;

import java.util.List;
import java.util.Map;
import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import in.sp.main.Entities.LiveLocation;
import in.sp.main.Entities.User;
import in.sp.main.Service.LiveLocationService;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/livelocation")
public class LiveLocationController {

    @Autowired
    private LiveLocationService liveLocationService;

    // Load Live Location Page
    @RequestMapping(method = RequestMethod.GET)
    public String showLiveLocationPage(Model model, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }
        model.addAttribute("user", user);
        return "livelocation/livelocation";
    }

    // Save Live Location (accepts JSON body)
    @RequestMapping(value = "/save", method = RequestMethod.POST)
    @ResponseBody
    public ResponseEntity<Map<String, Object>> saveLocation(
            @RequestBody Map<String, Object> payload,
            HttpSession session) {

        Map<String, Object> response = new HashMap<>();

        User user = (User) session.getAttribute("user");
        Long userId;

        if (user != null) {
            userId = user.getId();
        } else if (payload.containsKey("userId")) {
            userId = Long.parseLong(payload.get("userId").toString());
        } else {
            response.put("success", false);
            response.put("message", "Not logged in");
            return ResponseEntity.status(401).body(response);
        }

        Double latitude = Double.parseDouble(payload.get("latitude").toString());
        Double longitude = Double.parseDouble(payload.get("longitude").toString());

        LiveLocation saved = liveLocationService.saveLocation(latitude, longitude, userId);

        response.put("success", true);
        response.put("id", saved.getId());
        response.put("message", "Location saved");
        return ResponseEntity.ok(response);
    }

    // Get recent locations for current user (JSON API)
    @GetMapping("/recent")
    @ResponseBody
    public ResponseEntity<List<LiveLocation>> getRecentLocations(HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return ResponseEntity.status(401).body(null);
        }
        List<LiveLocation> locations = liveLocationService.getActiveTracking(user.getId());
        return ResponseEntity.ok(locations);
    }
}

