package in.sp.main.Controller;

import in.sp.main.Config.JwtUtil;
import in.sp.main.Entities.*;
import in.sp.main.Repository.MartialArtsBatchRepository;
import in.sp.main.Service.AdminService;
import in.sp.main.Service.CentreProfileService;
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
 * Pending queue mirrors doctor verification (CentreProfileStatus lifecycle).
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

    @Autowired
    private MartialArtsBatchRepository batchRepository;

    @Autowired
    private CentreProfileService centreProfileService;

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
            items.add(centreAdminDto(c));
        }

        Map<String, Object> body = new LinkedHashMap<>();
        body.put("success", true);
        body.put("status", status);
        body.put("centres", items);
        body.put("count", items.size());
        return ResponseEntity.ok(body);
    }

    @GetMapping("/centres/{id}")
    @Transactional(readOnly = true)
    public ResponseEntity<Map<String, Object>> centreDetail(@PathVariable Long id, HttpSession session) {
        if (requireAdmin(session) == null) return unauthorized();
        try {
            MartialArtsCenter c = centreService.getCenterById(id);
            Map<String, Object> body = new LinkedHashMap<>();
            body.put("success", true);
            body.put("centre", centreAdminDto(c));
            body.putAll(centreProfileService.profilePayload(c));
            return ResponseEntity.ok(body);
        } catch (Exception ex) {
            return badRequest(ex.getMessage());
        }
    }

    @PostMapping("/centres/{id}/approve")
    @Transactional
    public ResponseEntity<Map<String, Object>> approveCentre(@PathVariable Long id, HttpSession session) {
        if (requireAdmin(session) == null) return unauthorized();

        try {
            centreService.approveCenter(id);
            MartialArtsCenter centre = centreService.getCenterById(id);
            String subject = "Your Self-Defense Training Centre is Approved!";
            String text = "Dear " + centre.getName() + ",\n\n"
                    + "Your registration as a Self-Defense / Martial Arts Training Centre has been approved.\n"
                    + "You can now appear to students on Fight D Fear.\n\n"
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
    public ResponseEntity<Map<String, Object>> rejectCentre(
            @PathVariable Long id,
            @RequestBody(required = false) Map<String, String> body,
            HttpSession session) {
        if (requireAdmin(session) == null) return unauthorized();

        String reason = body == null ? null : body.get("reason");
        boolean ok = centreService.rejectCenter(id, reason);
        MartialArtsCenter centre = null;
        try {
            centre = centreService.getCenterById(id);
            if (ok && centre.getEmail() != null) {
                emailService.sendEmail(
                        centre.getEmail(),
                        "Registration update — Fight D Fear",
                        "Dear " + centre.getName() + ",\n\n"
                                + "Your centre registration was not approved.\n"
                                + (reason == null || reason.isBlank() ? "" : "Reason: " + reason.trim() + "\n")
                                + "You may update your profile and contact support if needed.\n\n"
                                + "Fight D Fear\n");
            }
        } catch (Exception ignored) {}

        Map<String, Object> res = new LinkedHashMap<>();
        res.put("success", ok);
        res.put("message", ok ? "Centre rejected." : "Centre not found.");
        return ResponseEntity.ok(res);
    }

    @PostMapping("/centres/{id}/request-changes")
    @Transactional
    public ResponseEntity<Map<String, Object>> requestChanges(
            @PathVariable Long id,
            @RequestBody(required = false) Map<String, String> body,
            HttpSession session) {
        if (requireAdmin(session) == null) return unauthorized();
        String note = body == null ? null : body.get("note");
        boolean ok = centreService.requestChanges(id, note);
        Map<String, Object> res = new LinkedHashMap<>();
        res.put("success", ok);
        res.put("message", ok ? "Changes requested." : "Centre not found.");
        return ResponseEntity.ok(res);
    }

    private Map<String, Object> centreAdminDto(MartialArtsCenter c) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", c.getId());
        m.put("name", c.getName());
        m.put("email", c.getEmail());
        m.put("phoneNumber", c.getPhoneNumber());
        m.put("contactPerson", c.getContactPerson());
        m.put("location", c.getLocation());
        m.put("about", c.getAbout());
        m.put("howWeTeach", c.getHowWeTeach());
        m.put("whatWeOffer", c.getWhatWeOffer());
        m.put("profilePhoto", c.getProfilePhoto());
        m.put("certificatePath", c.getTrainerCertificatePath());
        m.put("approved", c.isApproved());
        m.put("centreProfileStatus", c.getCentreProfileStatus() == null ? null : c.getCentreProfileStatus().name());
        m.put("centreProfileStatusLabel", CentreProfileService.statusLabel(c.getCentreProfileStatus()));
        m.put("profileCompletionPct", c.getProfileCompletionPct() == null ? 0 : c.getProfileCompletionPct());
        m.put("submittedForVerificationAt",
                c.getSubmittedForVerificationAt() == null ? null : c.getSubmittedForVerificationAt().toString());
        m.put("rejectionReason", c.getRejectionReason());
        m.put("changesRequestedNote", c.getChangesRequestedNote());
        List<MartialArtsBatch> batches = batchRepository.findByCenterId(c.getId());
        m.put("batchCount", batches == null ? 0 : batches.size());
        m.put("programs", batches == null ? List.of() : batches.stream().map(b -> {
            Map<String, Object> p = new LinkedHashMap<>();
            p.put("name", b.getName());
            p.put("style", b.getStyle());
            p.put("fee", b.getFee());
            p.put("timeSlot", b.getTimeSlot());
            return p;
        }).toList());
        if (c.getMartialArtsTypes() != null && !c.getMartialArtsTypes().isEmpty()) {
            m.put("martialArtsTypes", c.getMartialArtsTypes().stream().map(t -> {
                Map<String, Object> tMap = new LinkedHashMap<>();
                tMap.put("name", t.getName());
                tMap.put("cost", t.getCost());
                return tMap;
            }).toList());
        } else {
            m.put("martialArtsTypes", List.of());
        }
        return m;
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
