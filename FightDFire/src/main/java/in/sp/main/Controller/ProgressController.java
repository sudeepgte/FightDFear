package in.sp.main.Controller;

import in.sp.main.dto.ProgressResponseDTO;
import in.sp.main.Entities.User;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class ProgressController {

    @GetMapping("/users/my-progress")
    public String showMyProgress(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) return "redirect:/login";
        model.addAttribute("user", user);
        return "myProgress";
    }

    @GetMapping("/users/belt-progress")
    public String showBeltProgress(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) return "redirect:/login";
        model.addAttribute("user", user);
        return "myBeltProgress";
    }

    @GetMapping("/api/progress/my-progress")
    @ResponseBody
    public ProgressResponseDTO getMyProgress(HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) return new ProgressResponseDTO();

        // Populate with realistic training data
        Map<String, Integer> skills = new HashMap<>();
        skills.put("Footwork", 65);
        skills.put("Striking", 45);
        skills.put("Blocking", 55);
        skills.put("Stamina", 80);
        skills.put("Grappling", 30);
        skills.put("Agility", 70);

        List<String> achievements = List.of(
            "First Strike - Completed 1st session",
            "Consistent Learner - 7-day training streak",
            "Power Puncher - Reached 40% Striking power",
            "Swift Defender - Unlocked Advanced Blocking"
        );

        return new ProgressResponseDTO(
            skills,
            "Yellow Belt",
            40,
            12,
            achievements
        );
    }

    @GetMapping("/api/progress/belt-hierarchy")
    @ResponseBody
    public Map<String, Object> getBeltHierarchy(HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) return new HashMap<>();

        List<Map<String, Object>> belts = List.of(
            createBelt("White", "Beginner", true, 100, "Completed Orientation"),
            createBelt("Yellow", "Novice", true, 100, "Mastered Basic Stances"),
            createBelt("Green", "Intermediate", false, 40, "In Progress - Need 12 more sessions"),
            createBelt("Blue", "Advanced Intermediate", false, 0, "Locked"),
            createBelt("Red", "Advanced", false, 0, "Locked"),
            createBelt("Brown", "Senior", false, 0, "Locked"),
            createBelt("Black", "Expert", false, 0, "Locked")
        );

        Map<String, Object> response = new HashMap<>();
        response.put("belts", belts);
        response.put("currentBelt", "Yellow");
        return response;
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
