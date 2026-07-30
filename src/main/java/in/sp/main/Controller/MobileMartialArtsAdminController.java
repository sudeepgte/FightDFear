package in.sp.main.Controller;

import in.sp.main.Config.JwtUtil;
import in.sp.main.Entities.*;
import in.sp.main.Repository.*;
import in.sp.main.Service.AdminService;
import in.sp.main.Service.EmailService;
import in.sp.main.Service.MartialArtsCenterService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;

import java.util.*;

/**
 * Admin Martial Arts centre approval APIs for Flutter (Bearer JWT role ADMIN).
 */
@RestController
@RequestMapping("/api/martial-arts/admin")
public class MobileMartialArtsAdminController {

    @Autowired
    private MartialArtsCenterService centreService;

    @Autowired
    private AdminService adminService;

    @Autowired
    private EmailService emailService;

    @Autowired
    private JwtUtil jwtUtil;

    @PostMapping("/login")
    public ResponseEntity<Map<String, Object>> login(@RequestBody Map<String, String> body, HttpSession session) {
        String email = body == null ? "" : str(body.get("email")).toLowerCase(Locale.ROOT);
        String password = body == null ? "" : str(body.get("password"));
        if (email.isBlank() || password.isBlank()) {
            return badRequest("Email and password are required.");
        }
        Admin admin = adminService.loginAdmin(email, password);
        if (admin == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body(errorMap("Invalid admin credentials."));
        }
        session.setAttribute("admin", admin);
        session.setAttribute("userRole", "ADMIN");
        String token = jwtUtil.generateToken(admin.getEmail(), "ADMIN");

        Map<String, Object> res = new LinkedHashMap<>();
        res.put("success", true);
        res.put("token", token);
        res.put("tokenType", "Bearer");
        res.put("role", "ADMIN");
        res.put("admin", Map.of("id", admin.getId(), "name", admin.getName(), "email", admin.getEmail()));
        return ResponseEntity.ok(res);
    }

    @GetMapping("/centres")
    @Transactional(readOnly = true)
    public ResponseEntity<Map<String, Object>> listCentres(
            @RequestParam(value = "status", defaultValue = "pending") String status,
            HttpSession session) {
        if (requireAdmin(session) == null) return unauthorized();

        List<MartialArtsCenter> centres = "approved".equalsIgnoreCase(status)
                ? centreService.getCentresByApprovalStatus(true)
                : centreService.getCentresByApprovalStatus(false);

        List<Map<String, Object>> items = new ArrayList<>();
        for (MartialArtsCenter c : centres) {
            Map<String, Object> m = new LinkedHashMap<>();
            m.put("id", c.getId());
            m.put("name", c.getName());
            m.put("email", c.getEmail());
            m.put("phoneNumber", c.getPhoneNumber());
            m.put("location", c.getLocation());
            m.put("about", c.getAbout());
            m.put("profilePhoto", c.getProfilePhoto());
            m.put("approved", c.isApproved());
            items.add(m);
        }

        Map<String, Object> body = new LinkedHashMap<>();
        body.put("success", true);
        body.put("status", status);
        body.put("centres", items);
        body.put("count", items.size());
        return ResponseEntity.ok(body);
    }

    @PostMapping("/centres/{id}/approve")
    @Transactional
    public ResponseEntity<Map<String, Object>> approveCentre(@PathVariable Long id, HttpSession session) {
        if (requireAdmin(session) == null) return unauthorized();

        try {
            centreService.approveCenter(id);
            MartialArtsCenter centre = centreService.getCenterById(id);
            String subject = "Your Martial Arts Center is Now Approved!";
            String text = "Dear " + centre.getName() + ",\n\n"
                    + "Your registration as a Martial Arts Training Center has been approved.\n\n"
                    + "Best Regards,\nFight D Fear\n";
            emailService.sendEmail(centre.getEmail(), subject, text);

            Map<String, Object> body = new LinkedHashMap<>();
            body.put("success", true);
            body.put("message", "Centre approved successfully.");
            return ResponseEntity.ok(body);
        } catch (Exception ex) {
            return badRequest(ex.getMessage());
        }
    }

    @PostMapping("/centres/{id}/reject")
    @Transactional
    public ResponseEntity<Map<String, Object>> rejectCentre(@PathVariable Long id, HttpSession session) {
        if (requireAdmin(session) == null) return unauthorized();

        boolean deleted = centreService.rejectCenter(id);
        Map<String, Object> body = new LinkedHashMap<>();
        body.put("success", deleted);
        body.put("message", deleted ? "Centre rejected and removed." : "Centre not found.");
        return ResponseEntity.ok(body);
    }

    private Admin requireAdmin(HttpSession session) {
        if (session == null) return null;
        Object a = session.getAttribute("admin");
        return a instanceof Admin ? (Admin) a : null;
    }

    private ResponseEntity<Map<String, Object>> unauthorized() {
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(errorMap("Admin login required"));
    }

    private ResponseEntity<Map<String, Object>> badRequest(String error) {
        return ResponseEntity.badRequest().body(errorMap(error));
    }

    private static Map<String, Object> errorMap(String error) {
        Map<String, Object> body = new LinkedHashMap<>();
        body.put("success", false);
        body.put("error", error);
        return body;
    }

    private static String str(String v) {
        return v == null ? "" : v.trim();
    }
}
