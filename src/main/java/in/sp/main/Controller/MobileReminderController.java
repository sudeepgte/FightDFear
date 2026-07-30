package in.sp.main.Controller;

import in.sp.main.Entities.DayAvailable;
import in.sp.main.Entities.RoutineReminder;
import in.sp.main.Entities.User;
import in.sp.main.Service.RoutineReminderService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/reminders")
public class MobileReminderController {

    @Autowired
    private RoutineReminderService reminderService;

    @GetMapping
    public ResponseEntity<Map<String, Object>> list(HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        List<Map<String, Object>> items = reminderService.list(user).stream().map(this::dto).toList();
        return ResponseEntity.ok(ok(Map.of("reminders", items, "count", items.size())));
    }

    @PostMapping
    public ResponseEntity<Map<String, Object>> add(@RequestBody Map<String, String> body, HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        String title = trim(body.get("title"));
        String message = trim(body.get("message"));
        String timeOfDay = trim(body.get("timeOfDay"));
        String dayOfWeek = trim(body.get("dayOfWeek"));
        String reminderDate = trim(body.get("reminderDate"));
        if (title.isBlank() || timeOfDay.isBlank()) {
            return badRequest("title and timeOfDay are required");
        }
        try {
            DayAvailable day = dayOfWeek.isBlank() ? null : DayAvailable.valueOf(dayOfWeek);
            LocalDate date = reminderDate.isBlank() ? null : LocalDate.parse(reminderDate);
            if (day == null && date == null) return badRequest("dayOfWeek or reminderDate is required");
            RoutineReminder saved = reminderService.add(user, title, message, day, date, LocalTime.parse(timeOfDay));
            return ResponseEntity.status(HttpStatus.CREATED).body(ok(Map.of("reminder", dto(saved))));
        } catch (Exception e) {
            return badRequest("Invalid reminder input");
        }
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Map<String, Object>> delete(@PathVariable Long id, HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        reminderService.delete(user, id);
        return ResponseEntity.ok(ok(Map.of("message", "Reminder deleted")));
    }

    @PatchMapping("/{id}/toggle")
    public ResponseEntity<Map<String, Object>> toggle(@PathVariable Long id, HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        reminderService.toggle(user, id);
        return ResponseEntity.ok(ok(Map.of("message", "Reminder toggled")));
    }

    @GetMapping("/triggered")
    public ResponseEntity<Map<String, Object>> triggered(HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        List<Map<String, Object>> items = reminderService.triggeredNow(user).stream().map(this::dto).toList();
        return ResponseEntity.ok(ok(Map.of("reminders", items)));
    }

    @PostMapping("/{id}/shown")
    public ResponseEntity<Map<String, Object>> shown(@PathVariable Long id, HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        reminderService.markShown(id);
        return ResponseEntity.ok(ok(Map.of("message", "OK")));
    }

    private Map<String, Object> dto(RoutineReminder r) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", r.getId());
        m.put("title", r.getTitle());
        m.put("message", r.getMessage());
        m.put("dayOfWeek", r.getDayOfWeek() == null ? null : r.getDayOfWeek().name());
        m.put("reminderDate", r.getReminderDate() == null ? null : r.getReminderDate().toString());
        m.put("timeOfDay", r.getTimeOfDay() == null ? null : r.getTimeOfDay().toString());
        m.put("enabled", r.isEnabled());
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

    private static String trim(String v) { return v == null ? "" : v.trim(); }
}
