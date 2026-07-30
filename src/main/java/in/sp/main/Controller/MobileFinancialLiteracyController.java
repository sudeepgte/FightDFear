package in.sp.main.Controller;

import jakarta.servlet.ServletContext;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/financial-literacy")
public class MobileFinancialLiteracyController {

    @GetMapping
    public ResponseEntity<Map<String, Object>> home(HttpServletRequest request, HttpSession session) {
        if (session.getAttribute("user") == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(Map.of("success", false, "error", "Login required"));
        }
        ServletContext ctx = request.getServletContext();
        List<Map<String, Object>> videos = castList(ctx.getAttribute("flVideos"));
        List<Map<String, Object>> liveSessions = castList(ctx.getAttribute("flLiveSessions"));
        List<Map<String, Object>> workshops = castList(ctx.getAttribute("flWorkshops"));
        return ResponseEntity.ok(ok(Map.of(
                "videos", videos,
                "liveSessions", liveSessions,
                "workshops", workshops
        )));
    }

    @SuppressWarnings("unchecked")
    private List<Map<String, Object>> castList(Object raw) {
        if (raw instanceof List<?> list) {
            List<Map<String, Object>> out = new ArrayList<>();
            for (Object o : list) {
                if (o instanceof Map<?, ?> m) out.add(new LinkedHashMap<>((Map<String, Object>) m));
            }
            return out;
        }
        return List.of();
    }

    private static Map<String, Object> ok(Map<String, Object> data) {
        Map<String, Object> out = new LinkedHashMap<>();
        out.put("success", true);
        out.putAll(data);
        return out;
    }
}
