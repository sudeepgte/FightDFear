package in.sp.main.Controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import in.sp.main.Entities.DangerPoint;
import in.sp.main.Entities.User;
import in.sp.main.Repository.DangerPointRepository;
import in.sp.main.Service.FileUploadService;
import jakarta.servlet.http.HttpSession;
import org.springframework.web.multipart.MultipartFile;

@Controller
@RequestMapping("/danger-points")
public class DangerPointController {

    @Autowired
    private DangerPointRepository dangerPointRepository;

    @Autowired
    private FileUploadService fileUploadService;

    @GetMapping
    @ResponseBody
    public List<Map<String, Object>> list() {
        // Purpose: return only verified fields needed by the map (avoid leaking user info).
        List<DangerPoint> points = dangerPointRepository.findTop500ByVerifiedOrderByCreatedAtDesc(true);
        List<Map<String, Object>> out = new ArrayList<>(points.size());

        for (DangerPoint p : points) {
            Map<String, Object> m = new HashMap<>();
            m.put("id", p.getId());
            m.put("lat", p.getLatitude());
            m.put("lng", p.getLongitude());
            m.put("severity", p.getSeverity());
            m.put("category", p.getCategory());
            m.put("createdAt", p.getCreatedAt());
            out.add(m);
        }
        return out;
    }

    @PostMapping
    @ResponseBody
    public ResponseEntity<Map<String, Object>> create(@RequestParam("lat") double lat,
                                                      @RequestParam("lng") double lng,
                                                      @RequestParam(value = "severity", defaultValue = "3") int severity,
                                                      @RequestParam(value = "category", defaultValue = "general") String category,
                                                      @RequestParam(value = "note", required = false) String note,
                                                      @RequestParam(value = "locationName", required = false) String locationName,
                                                      @RequestParam(value = "imageFile", required = false) MultipartFile imageFile,
                                                      HttpSession session) {
        // Purpose: ensure only registered users can mark danger locations.
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(res(false, "Login required."));
        }

        // Purpose: basic server-side validation (prevents bogus coordinates / oversized payloads).
        if (Double.isNaN(lat) || Double.isNaN(lng) || lat < -90 || lat > 90 || lng < -180 || lng > 180) {
            return ResponseEntity.badRequest().body(res(false, "Invalid latitude/longitude."));
        }
        if (severity < 1 || severity > 5) {
            return ResponseEntity.badRequest().body(res(false, "Severity must be between 1 and 5."));
        }
        String safeCategory = (category == null) ? "general" : category.trim();
        if (safeCategory.isEmpty()) safeCategory = "general";
        if (safeCategory.length() > 40) {
            return ResponseEntity.badRequest().body(res(false, "Category too long."));
        }
        String safeNote = (note == null) ? null : note.trim();
        if (safeNote != null && safeNote.length() > 200) {
            return ResponseEntity.badRequest().body(res(false, "Note too long."));
        }

        // Purpose: basic per-user rate limiting (reduces spam and accidental double submits).
        DangerPoint last = dangerPointRepository.findTop1ByUserOrderByCreatedAtDesc(user);
        if (last != null && last.getCreatedAt() != null) {
            long ageMs = System.currentTimeMillis() - last.getCreatedAt().getTime();
            if (ageMs >= 0 && ageMs < 30_000) {
                return ResponseEntity.status(HttpStatus.TOO_MANY_REQUESTS).body(res(false, "Please wait before adding another report."));
            }
        }

        DangerPoint dp = new DangerPoint();
        dp.setLatitude(lat);
        dp.setLongitude(lng);
        dp.setSeverity(severity);
        dp.setCategory(safeCategory);
        dp.setNote(safeNote);
        dp.setLocationName(locationName);
        dp.setUser(user);

        // Save evidence image if provided
        if (imageFile != null && !imageFile.isEmpty()) {
            try {
                String imagePath = fileUploadService.saveFile(imageFile);
                dp.setImagePath(imagePath);
            } catch (Exception e) {
                // Log error but continue saving the point
                e.printStackTrace();
            }
        }

        dangerPointRepository.save(dp);
        return ResponseEntity.ok(res(true, "Report submitted! It will appear on the map after admin approval."));
    }

    private static Map<String, Object> res(boolean ok, String message) {
        Map<String, Object> m = new HashMap<>();
        m.put("ok", ok);
        m.put("message", message);
        return m;
    }
}

