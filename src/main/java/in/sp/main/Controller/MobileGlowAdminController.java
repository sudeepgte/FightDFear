package in.sp.main.Controller;

import in.sp.main.Entities.Admin;
import in.sp.main.Entities.PartnerProfileStatus;
import in.sp.main.Entities.Salon;
import in.sp.main.Entities.Stylist;
import in.sp.main.Repository.SalonRepository;
import in.sp.main.Repository.StylistRepository;
import in.sp.main.Service.PartnerLifecycleSupport;
import in.sp.main.Service.SalonProfileService;
import in.sp.main.Service.StylistProfileService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;

import java.util.*;
import java.util.stream.Collectors;

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
    @Autowired
    private SalonProfileService salonProfileService;
    @Autowired
    private StylistProfileService stylistProfileService;

    @GetMapping("/salons")
    @Transactional(readOnly = true)
    public ResponseEntity<Map<String, Object>> listSalons(
            @RequestParam(defaultValue = "pending") String status,
            HttpSession session) {
        if (requireAdmin(session) == null) return unauthorized();
        List<Map<String, Object>> items;
        if ("approved".equalsIgnoreCase(status)) {
            items = salonRepository.findByPartnerProfileStatus(PartnerProfileStatus.APPROVED).stream()
                    .map(this::salonDto)
                    .toList();
            if (items.isEmpty()) {
                items = salonRepository.findByApproved(true).stream().map(this::salonDto).toList();
            }
        } else {
            List<Salon> queue = new ArrayList<>(
                    salonRepository.findByPartnerProfileStatusIn(PartnerLifecycleSupport.pendingQueueStatuses()));
            queue.addAll(salonRepository.findByPartnerProfileStatusIsNull().stream()
                    .filter(s -> !s.isApproved())
                    .toList());
            items = queue.stream()
                    .sorted(Comparator.comparingInt(
                            (Salon s) -> PartnerLifecycleSupport.pendingPriority(s.getPartnerProfileStatus())))
                    .map(this::salonDto)
                    .collect(Collectors.toList());
        }
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
        salonProfileService.setLifecycleStatus(salon, PartnerProfileStatus.APPROVED);
        salon.setProfileCompletionPct(100);
        salon.setRejectionReason(null);
        salon.setChangesRequestedNote(null);
        salonRepository.save(salon);
        return ResponseEntity.ok(Map.of(
                "success", true,
                "message", "Salon approved",
                "partnerProfileStatus", PartnerProfileStatus.APPROVED.name(),
                "approved", true));
    }

    @PostMapping("/salons/{id}/reject")
    @Transactional
    public ResponseEntity<Map<String, Object>> rejectSalon(@PathVariable Long id, HttpSession session) {
        if (requireAdmin(session) == null) return unauthorized();
        Salon salon = salonRepository.findById(id).orElse(null);
        if (salon == null) return badRequest("Salon not found");
        salonProfileService.setLifecycleStatus(salon, PartnerProfileStatus.REJECTED);
        salon.setRejectionReason("Rejected by admin");
        salonRepository.save(salon);
        return ResponseEntity.ok(Map.of("success", true, "message", "Salon rejected"));
    }

    @GetMapping("/stylists")
    @Transactional(readOnly = true)
    public ResponseEntity<Map<String, Object>> listStylists(
            @RequestParam(defaultValue = "pending") String status,
            HttpSession session) {
        if (requireAdmin(session) == null) return unauthorized();
        List<Map<String, Object>> items;
        if ("approved".equalsIgnoreCase(status)) {
            items = stylistRepository.findByPartnerProfileStatus(PartnerProfileStatus.APPROVED).stream()
                    .map(this::stylistDto)
                    .toList();
            if (items.isEmpty()) {
                items = stylistRepository.findByApproved(true).stream().map(this::stylistDto).toList();
            }
        } else {
            List<Stylist> queue = new ArrayList<>(
                    stylistRepository.findByPartnerProfileStatusIn(PartnerLifecycleSupport.pendingQueueStatuses()));
            queue.addAll(stylistRepository.findByPartnerProfileStatusIsNull().stream()
                    .filter(s -> !s.isApproved())
                    .toList());
            items = queue.stream()
                    .sorted(Comparator.comparingInt(
                            (Stylist s) -> PartnerLifecycleSupport.pendingPriority(s.getPartnerProfileStatus())))
                    .map(this::stylistDto)
                    .collect(Collectors.toList());
        }
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
        stylistProfileService.setLifecycleStatus(stylist, PartnerProfileStatus.APPROVED);
        stylist.setProfileCompletionPct(100);
        stylist.setRejectionReason(null);
        stylist.setChangesRequestedNote(null);
        stylistRepository.save(stylist);
        return ResponseEntity.ok(Map.of(
                "success", true,
                "message", "Stylist approved",
                "partnerProfileStatus", PartnerProfileStatus.APPROVED.name(),
                "approved", true));
    }

    @PostMapping("/stylists/{id}/reject")
    @Transactional
    public ResponseEntity<Map<String, Object>> rejectStylist(@PathVariable Long id, HttpSession session) {
        if (requireAdmin(session) == null) return unauthorized();
        Stylist stylist = stylistRepository.findById(id).orElse(null);
        if (stylist == null) return badRequest("Stylist not found");
        stylistProfileService.setLifecycleStatus(stylist, PartnerProfileStatus.REJECTED);
        stylist.setRejectionReason("Rejected by admin");
        stylistRepository.save(stylist);
        return ResponseEntity.ok(Map.of("success", true, "message", "Stylist rejected"));
    }

    private Map<String, Object> salonDto(Salon s) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", s.getId());
        m.put("name", s.getName());
        m.put("username", s.getUsername());
        m.put("phone", s.getPhone());
        m.put("city", s.getCity());
        m.put("address", s.getAddress());
        m.put("bio", s.getBio());
        m.put("approved", s.isApproved());
        m.put("partnerProfileStatus", s.getPartnerProfileStatus() == null
                ? null : s.getPartnerProfileStatus().name());
        m.put("partnerProfileStatusLabel", PartnerLifecycleSupport.statusLabel(s.getPartnerProfileStatus()));
        m.put("profileCompletionPct", s.getProfileCompletionPct());
        return m;
    }

    private Map<String, Object> stylistDto(Stylist s) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", s.getId());
        m.put("firstName", s.getFirstName());
        m.put("lastName", s.getLastName());
        m.put("email", s.getEmail());
        m.put("specialization", s.getSpecialization());
        m.put("bio", s.getBio());
        m.put("approved", s.isApproved());
        m.put("partnerProfileStatus", s.getPartnerProfileStatus() == null
                ? null : s.getPartnerProfileStatus().name());
        m.put("partnerProfileStatusLabel", PartnerLifecycleSupport.statusLabel(s.getPartnerProfileStatus()));
        m.put("profileCompletionPct", s.getProfileCompletionPct());
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
