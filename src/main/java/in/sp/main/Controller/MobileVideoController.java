package in.sp.main.Controller;

import in.sp.main.Entities.User;
import in.sp.main.Entities.Videoupload;
import in.sp.main.Repository.VideoUploadRepository;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/videos")
public class MobileVideoController {

    @Autowired
    private VideoUploadRepository videoRepo;

    @GetMapping
    public ResponseEntity<Map<String, Object>> videos(HttpSession session) {
        if (requireUser(session) == null) return unauthorized();
        List<Map<String, Object>> items = videoRepo.findByIsReel(false).stream()
                .filter(v -> !v.isBlocked() && !v.isPrivate() && !v.isDraft())
                .map(this::videoDto).toList();
        return ResponseEntity.ok(ok(Map.of("videos", items, "count", items.size())));
    }

    @GetMapping("/reels")
    public ResponseEntity<Map<String, Object>> reels(HttpSession session) {
        if (requireUser(session) == null) return unauthorized();
        List<Map<String, Object>> items = videoRepo.findByIsReel(true).stream()
                .filter(v -> !v.isBlocked() && !v.isPrivate() && !v.isDraft())
                .map(this::videoDto).toList();
        return ResponseEntity.ok(ok(Map.of("reels", items, "count", items.size())));
    }

    private Map<String, Object> videoDto(Videoupload v) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", v.getId());
        m.put("title", v.getTitle());
        m.put("description", v.getDescription());
        m.put("videoPath", v.getVideoPath());
        m.put("thumbnailPath", v.getThumbnailPath());
        m.put("category", v.getCategory());
        m.put("likeCount", v.getLikeCount());
        m.put("viewCount", v.getViewCount());
        m.put("uploadTime", v.getUploadTime() == null ? null : v.getUploadTime().toString());
        m.put("isReel", v.isReel());
        return m;
    }

    private User requireUser(HttpSession session) {
        Object u = session == null ? null : session.getAttribute("user");
        return u instanceof User ? (User) u : null;
    }

    private ResponseEntity<Map<String, Object>> unauthorized() {
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(Map.of("success", false, "error", "Login required"));
    }

    private static Map<String, Object> ok(Map<String, Object> data) {
        Map<String, Object> out = new LinkedHashMap<>();
        out.put("success", true);
        out.putAll(data);
        return out;
    }
}
