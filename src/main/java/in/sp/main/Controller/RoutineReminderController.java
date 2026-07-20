package in.sp.main.Controller;

import java.time.LocalTime;
import java.util.HashMap;
import java.util.List;
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
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import in.sp.main.Entities.DayAvailable;
import in.sp.main.Entities.RoutineReminder;
import in.sp.main.Entities.User;
import in.sp.main.Service.RoutineReminderService;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/reminders")
public class RoutineReminderController {

    @Autowired
    private RoutineReminderService reminderService;

    @GetMapping
    public String page(Model model, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) return "redirect:/login";

        model.addAttribute("user", user);
        model.addAttribute("reminders", reminderService.list(user));
        model.addAttribute("days", DayAvailable.values());
        return "reminders";
    }

    @PostMapping("/add")
    public String add(@RequestParam String title,
                      @RequestParam String message,
                      @RequestParam(required = false) String dayOfWeek,
                      @RequestParam(required = false) String reminderDate,
                      @RequestParam String timeOfDay,
                      HttpSession session,
                      RedirectAttributes redirectAttributes) {
        User user = (User) session.getAttribute("user");
        if (user == null) return "redirect:/login";

        try {
            DayAvailable day = (dayOfWeek == null || dayOfWeek.isEmpty()) ? null : DayAvailable.valueOf(dayOfWeek);
            java.time.LocalDate date = (reminderDate == null || reminderDate.isEmpty()) ? null : java.time.LocalDate.parse(reminderDate);
            LocalTime t = LocalTime.parse(timeOfDay);
            
            if (day == null && date == null) {
                redirectAttributes.addFlashAttribute("message", "Please select either a day or a specific date.");
                return "redirect:/reminders";
            }

            reminderService.add(user, title, message, day, date, t);
            redirectAttributes.addFlashAttribute("message", "Reminder added.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("message", "Invalid reminder input: " + e.getMessage());
        }
        return "redirect:/reminders";
    }

    @PostMapping("/delete")
    public String delete(@RequestParam Long id, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) return "redirect:/login";
        reminderService.delete(user, id);
        return "redirect:/reminders";
    }

    @PostMapping("/toggle")
    public String toggle(@RequestParam Long id, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) return "redirect:/login";
        reminderService.toggle(user, id);
        return "redirect:/reminders";
    }

    @GetMapping("/triggered")
    @ResponseBody
    public ResponseEntity<?> triggered(HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(res(false, "Login required."));

        List<RoutineReminder> list = reminderService.triggeredNow(user);
        Map<String, Object> out = new HashMap<>();
        out.put("ok", true);
        out.put("reminders", list.stream().map(r -> {
            Map<String, Object> m = new HashMap<>();
            m.put("id", r.getId());
            m.put("title", r.getTitle());
            m.put("message", r.getMessage());
            return m;
        }).toList());
        return ResponseEntity.ok(out);
    }

    @PostMapping("/shown")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> shown(@RequestParam Long id, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(res(false, "Login required."));
        reminderService.markShown(id);
        return ResponseEntity.ok(res(true, "OK"));
    }

    private static Map<String, Object> res(boolean ok, String message) {
        Map<String, Object> m = new HashMap<>();
        m.put("ok", ok);
        m.put("message", message);
        return m;
    }
}

