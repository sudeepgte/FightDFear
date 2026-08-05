package in.sp.main.Controller;

import in.sp.main.Entities.Admin;
import in.sp.main.Entities.Salon;
import in.sp.main.Entities.Stylist;
import in.sp.main.Repository.SalonRepository;
import in.sp.main.Repository.StylistRepository;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;

import java.util.*;

/**
 * Admin Glow Space (salon/stylist) approval APIs for Flutter.
 * Reuses admin JWT from /api/martial-arts/admin/login.
 */
@RestController
@RequestMapping("/api/glow/admin")
public class MobileGlowAdminController {

    @Autowired
    private SalonRepository salonRepository;
    @Autowired
    private StylistRepository stylistRepository;

    @GetMapping("/salons")
    @Transactional(readOnly = true)
    public ResponseEntity<Map<String, Object>> listSalons(
            @RequestParam(defaultValue = "pending") String status,
            HttpSession session) {
        if (requireAdmin(session) == null) return unauthorized();
        boolean approved = "approved".equalsIgnoreCase(status);
        List<Map<String, Object>> items = salonRepository.findByApproved(approved).stream()
                .map(this::salonDto)
                .toList();
        Map<String, Object> body = new LinkedHashMap<>();
        body.put("success", true);
        body.put("status", status);
        body.put("salons", items);
        body.put("count", items.size());
        return ResponseEntity.ok(body);
    }

    @PostMapping("/salons/{id}/approve")
    @Transactional
    public ResponseEntity<Map<String, Object>> approveSalon(@PathVariable Long id, HttpSession session) {
        if (requireAdmin(session) == null) return unauthorized();
        Salon salon = salonRepository.findById(id).orElse(null);
        if (salon == null) return badRequest("Salon not found");
        salon.setApproved(true);
        salonRepository.save(salon);
        return ResponseEntity.ok(Map.of("success", true, "message", "Salon approved"));
    }

    @PostMapping("/salons/{id}/reject")
    @Transactional
    public ResponseEntity<Map<String, Object>> rejectSalon(@PathVariable Long id, HttpSession session) {
        if (requireAdmin(session) == null) return unauthorized();
        if (!salonRepository.existsById(id)) return badRequest("Salon not found");
        salonRepository.deleteById(id);
        return ResponseEntity.ok(Map.of("success", true, "message", "Salon rejected and removed"));
    }

    @GetMapping("/stylists")
    @Transactional(readOnly = true)
    public ResponseEntity<Map<String, Object>> listStylists(
            @RequestParam(defaultValue = "pending") String status,
            HttpSession session) {
        if (requireAdmin(session) == null) return unauthorized();
        boolean approved = "approved".equalsIgnoreCase(status);
        List<Map<String, Object>> items = stylistRepository.findByApproved(approved).stream()
                .map(this::stylistDto)
                .toList();
        Map<String, Object> body = new LinkedHashMap<>();
        body.put("success", true);
        body.put("status", status);
        body.put("stylists", items);
        body.put("count", items.size());
        return ResponseEntity.ok(body);
    }

    @PostMapping("/stylists/{id}/approve")
    @Transactional
    public ResponseEntity<Map<String, Object>> approveStylist(@PathVariable Long id, HttpSession session) {
        if (requireAdmin(session) == null) return unauthorized();
        Stylist stylist = stylistRepository.findById(id).orElse(null);
        if (stylist == null) return badRequest("Stylist not found");
        stylist.setApproved(true);
        stylistRepository.save(stylist);
        return ResponseEntity.ok(Map.of("success", true, "message", "Stylist approved"));
    }

    @PostMapping("/stylists/{id}/reject")
    @Transactional
    public ResponseEntity<Map<String, Object>> rejectStylist(@PathVariable Long id, HttpSession session) {
        if (requireAdmin(session) == null) return unauthorized();
        if (!stylistRepository.existsById(id)) return badRequest("Stylist not found");
        stylistRepository.deleteById(id);
        return ResponseEntity.ok(Map.of("success", true, "message", "Stylist rejected and removed"));
    }

    private Map<String, Object> salonDto(Salon s) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", s.getId());
        m.put("name", s.getName());
        m.put("username", s.getUsername());
        m.put("phone", s.getPhone());
        m.put("city", s.getCity());
        m.put("address", s.getAddress());
        m.put("approved", s.isApproved());
        return m;
    }

    private Map<String, Object> stylistDto(Stylist s) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", s.getId());
        m.put("firstName", s.getFirstName());
        m.put("lastName", s.getLastName());
        m.put("email", s.getEmail());
        m.put("specialization", s.getSpecialization());
        m.put("approved", s.isApproved());
        return m;
    }

    private Admin requireAdmin(HttpSession session) {
        if (session == null) return null;
        Object a = session.getAttribute("admin");
        return a instanceof Admin ? (Admin) a : null;
    }

    private ResponseEntity<Map<String, Object>> unauthorized() {
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                .body(Map.of("success", false, "error", "Admin login required"));
    }

    private ResponseEntity<Map<String, Object>> badRequest(String error) {
        return ResponseEntity.badRequest().body(Map.of("success", false, "error", error));
    }
}
