package in.sp.main.Controller;

import in.sp.main.Entities.User;
import in.sp.main.Entities.WomenEvent;
import in.sp.main.Entities.WomenEventRegistration;
import in.sp.main.Repository.WomenEventRegistrationRepository;
import in.sp.main.Repository.WomenEventRepository;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/women-events")
public class MobileWomenEventController {

    @Autowired
    private WomenEventRepository eventRepo;
    @Autowired
    private WomenEventRegistrationRepository registrationRepo;

    @GetMapping
    public ResponseEntity<Map<String, Object>> list(HttpSession session) {
        if (requireUser(session) == null) return unauthorized();
        List<Map<String, Object>> items = eventRepo.findByStatusOrderByCreatedAtDesc("APPROVED").stream()
                .map(this::eventDto).toList();
        return ResponseEntity.ok(ok(Map.of("events", items, "count", items.size())));
    }

    @GetMapping("/{id}")
    public ResponseEntity<Map<String, Object>> detail(@PathVariable Long id, HttpSession session) {
        if (requireUser(session) == null) return unauthorized();
        WomenEvent e = eventRepo.findById(id).orElse(null);
        if (e == null || !"APPROVED".equals(e.getStatus())) return badRequest("Event not found");
        return ResponseEntity.ok(ok(Map.of("event", eventDto(e))));
    }

    @PostMapping("/{id}/register")
    @Transactional
    public ResponseEntity<Map<String, Object>> register(@PathVariable Long id, HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        WomenEvent e = eventRepo.findById(id).orElse(null);
        if (e == null || !"APPROVED".equals(e.getStatus())) return badRequest("Event not found");
        if (registrationRepo.existsByEventAndUser(e, user)) return badRequest("Already registered");
        WomenEventRegistration reg = new WomenEventRegistration();
        reg.setEvent(e);
        reg.setUser(user);
        reg.setStatus("REGISTERED");
        registrationRepo.save(reg);
        return ResponseEntity.ok(ok(Map.of("message", "Registered", "ticketCode", reg.getTicketCode())));
    }

    @GetMapping("/registrations/me")
    public ResponseEntity<Map<String, Object>> myRegistrations(HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        List<Map<String, Object>> items = registrationRepo.findByUserOrderByRegisteredAtDesc(user).stream().map(r -> {
            Map<String, Object> m = new LinkedHashMap<>();
            m.put("id", r.getId());
            m.put("status", r.getStatus());
            m.put("ticketCode", r.getTicketCode());
            m.put("registeredAt", r.getRegisteredAt() == null ? null : r.getRegisteredAt().toString());
            if (r.getEvent() != null) m.put("event", eventDto(r.getEvent()));
            return m;
        }).toList();
        return ResponseEntity.ok(ok(Map.of("registrations", items)));
    }

    private Map<String, Object> eventDto(WomenEvent e) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", e.getId());
        m.put("name", e.getName());
        m.put("category", e.getCategory() == null ? null : e.getCategory().name());
        m.put("description", e.getDescription());
        m.put("eventDate", e.getEventDate() == null ? null : e.getEventDate().toString());
        m.put("eventTime", e.getEventTime() == null ? null : e.getEventTime().toString());
        m.put("venue", e.getVenue());
        m.put("city", e.getCity());
        m.put("entryFee", e.getEntryFee());
        m.put("free", e.isFree());
        m.put("bannerImage", e.getBannerImage());
        m.put("featured", e.isFeatured());
        return m;
    }

    private User requireUser(HttpSession session) {
        Object u = session == null ? null : session.getAttribute("user");
        return u instanceof User ? (User) u : null;
    }

    private ResponseEntity<Map<String, Object>> unauthorized() {
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(Map.of("success", false, "error", "Login required"));
    }

    private ResponseEntity<Map<String, Object>> badRequest(String error) {
        return ResponseEntity.badRequest().body(Map.of("success", false, "error", error));
    }

    private static Map<String, Object> ok(Map<String, Object> data) {
        Map<String, Object> out = new LinkedHashMap<>();
        out.put("success", true);
        out.putAll(data);
        return out;
    }
}
