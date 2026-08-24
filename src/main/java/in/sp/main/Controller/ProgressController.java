package in.sp.main.Controller;

import in.sp.main.dto.ProgressResponseDTO;
import in.sp.main.Entities.*;
import in.sp.main.Repository.*;
import in.sp.main.Service.BeltGradingService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.*;

@Controller
public class ProgressController {

    @Autowired
    private BeltGradingService beltGradingService;

    @Autowired
    private AttendanceRepository attendanceRepository;

    @Autowired
    private EnrollmentRepository enrollmentRepository;

    @Autowired
    private BeltGradingAssessmentRepository gradingRepository;

    @GetMapping("/users/my-progress")
    public String showMyProgress(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) return "redirect:/login";
        model.addAttribute("user", user);

        Map<String, Object> radar = beltGradingService.getStudentLatestSkillRadar(user.getId());
        model.addAttribute("skillRadar", radar);
        model.addAttribute("gradingHistory", beltGradingService.getStudentGradingHistory(user.getId()));

        List<Attendance> attendances = attendanceRepository.findByUserId(user.getId());
        model.addAttribute("totalSessions", attendances.size());

        return "myProgress";
    }

    @GetMapping("/users/belt-progress")
    public String showBeltProgress(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) return "redirect:/login";
        model.addAttribute("user", user);

        Map<String, Object> radar = beltGradingService.getStudentLatestSkillRadar(user.getId());
        model.addAttribute("skillRadar", radar);
        model.addAttribute("gradingHistory", beltGradingService.getStudentGradingHistory(user.getId()));

        List<Attendance> attendances = attendanceRepository.findByUserId(user.getId());
        model.addAttribute("totalSessions", attendances.size());

        return "myBeltProgress";
    }

    @GetMapping("/api/progress/my-progress")
    @ResponseBody
    public ProgressResponseDTO getMyProgress(HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) return new ProgressResponseDTO();

        Map<String, Object> radar = beltGradingService.getStudentLatestSkillRadar(user.getId());
        Map<String, Integer> skills = (Map<String, Integer>) radar.getOrDefault("skills", Collections.emptyMap());

        String currentBelt = (String) radar.getOrDefault("currentBelt", "White");

        List<Attendance> attendances = attendanceRepository.findByUserId(user.getId());
        int totalClasses = attendances.size();
        int streak = Math.min(totalClasses, 14); // calculate recent sessions

        List<String> achievements = new ArrayList<>();
        if (totalClasses > 0) {
            achievements.add("First Strike — Completed first training session");
        }
        if (totalClasses >= 5) {
            achievements.add("Consistent Learner — Attended " + totalClasses + " sessions");
        }
        if (Boolean.TRUE.equals(radar.get("assessed"))) {
            achievements.add("Graded Warrior — Evaluated in " + radar.get("discipline") + " (" + radar.get("overallScore") + "/100)");
        }
        if (!"White".equalsIgnoreCase(currentBelt)) {
            achievements.add("Promoted Rank — Earned " + currentBelt + " Belt");
        }

        int beltProgress = Math.min(100, totalClasses * 5); // 20 sessions per belt milestone

        return new ProgressResponseDTO(
            skills,
            currentBelt,
            beltProgress,
            streak,
            achievements
        );
    }

    @GetMapping("/api/progress/belt-hierarchy")
    @ResponseBody
    public Map<String, Object> getBeltHierarchy(HttpSession session) {
        User user = (User) session.getAttribute("user");
        Map<String, Object> response = new HashMap<>();
        if (user == null) return response;

        Map<String, Object> radar = beltGradingService.getStudentLatestSkillRadar(user.getId());
        String currentBelt = (String) radar.getOrDefault("currentBelt", "White");

        List<String> allBelts = List.of("White", "Yellow", "Green", "Blue", "Brown", "Black");
        int currentIndex = allBelts.indexOf(currentBelt);
        if (currentIndex < 0) currentIndex = 0;

        List<Map<String, Object>> beltCards = new ArrayList<>();
        for (int i = 0; i < allBelts.size(); i++) {
            String name = allBelts.get(i);
            boolean completed = i < currentIndex;
            boolean isCurrent = i == currentIndex;
            int progress = completed ? 100 : (isCurrent ? 60 : 0);
            String req = completed ? "Promoted" : (isCurrent ? "Current Rank — Assessment Active" : "Locked");
            beltCards.add(createBelt(name, getBeltLevelLabel(name), completed || isCurrent, progress, req));
        }

        response.put("belts", beltCards);
        response.put("currentBelt", currentBelt);
        response.put("assessed", radar.getOrDefault("assessed", false));
        return response;
    }

    @GetMapping("/api/progress/grading-history")
    @ResponseBody
    public List<Map<String, Object>> getGradingHistory(HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) return Collections.emptyList();
        return beltGradingService.getStudentGradingHistory(user.getId());
    }

    private static String getBeltLevelLabel(String belt) {
        return switch (belt.toLowerCase(Locale.ROOT)) {
            case "white" -> "Beginner";
            case "yellow" -> "Novice";
            case "green" -> "Intermediate";
            case "blue" -> "Advanced Intermediate";
            case "brown" -> "Senior";
            case "black" -> "Master";
            default -> "Trainee";
        };
    }

    private Map<String, Object> createBelt(String name, String level, boolean completed, int progress, String requirement) {
        Map<String, Object> belt = new HashMap<>();
        belt.put("name", name);
        belt.put("level", level);
        belt.put("completed", completed);
        belt.put("progress", progress);
        belt.put("requirement", requirement);
        return belt;
    }
}

