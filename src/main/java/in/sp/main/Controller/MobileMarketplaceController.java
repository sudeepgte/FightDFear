package in.sp.main.Controller;

import in.sp.main.Entities.*;
import in.sp.main.Repository.*;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/marketplace")
public class MobileMarketplaceController {

    @Autowired
    private ServiceProviderRepository providerRepo;
    @Autowired
    private ProviderBookingRepository bookingRepo;

    @GetMapping("/providers")
    public ResponseEntity<Map<String, Object>> providers(
            @RequestParam(required = false) String category,
            HttpSession session) {
        if (requireUser(session) == null) return unauthorized();
        List<ServiceProvider> list;
        if (category != null && !category.isBlank()) {
            try {
                ProviderCategory cat = ProviderCategory.valueOf(category.toUpperCase());
                list = providerRepo.findByCategoryAndVerificationStatus(cat, VerificationStatus.VERIFIED);
            } catch (Exception e) {
                list = providerRepo.findByVerificationStatus(VerificationStatus.VERIFIED);
            }
        } else {
            list = providerRepo.findByVerificationStatus(VerificationStatus.VERIFIED);
        }
        List<Map<String, Object>> items = list.stream().map(this::providerDto).toList();
        return ResponseEntity.ok(ok(Map.of("providers", items, "count", items.size())));
    }

    @GetMapping("/providers/{id}")
    public ResponseEntity<Map<String, Object>> providerDetail(@PathVariable Long id, HttpSession session) {
        if (requireUser(session) == null) return unauthorized();
        ServiceProvider p = providerRepo.findById(id).orElse(null);
        if (p == null || p.getVerificationStatus() != VerificationStatus.VERIFIED) return badRequest("Provider not found");
        return ResponseEntity.ok(ok(Map.of("provider", providerDto(p))));
    }

    @PostMapping("/providers/{id}/bookings")
    @Transactional
    public ResponseEntity<Map<String, Object>> book(@PathVariable Long id, @RequestBody Map<String, String> body, HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        ServiceProvider p = providerRepo.findById(id).orElse(null);
        if (p == null || p.getVerificationStatus() != VerificationStatus.VERIFIED) return badRequest("Provider not found");

        LocalDateTime requestedTime = LocalDateTime.now().plusDays(1);
        String requestedRaw = body != null ? trim(body.get("requestedTime")) : "";
        if (!requestedRaw.isEmpty()) {
            try {
                if (requestedRaw.length() >= 16) {
                    requestedTime = LocalDateTime.parse(requestedRaw.substring(0, 16),
                            java.time.format.DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm"));
                } else {
                    requestedTime = LocalDateTime.parse(requestedRaw);
                }
            } catch (Exception e) {
                return badRequest("Invalid requestedTime. Use yyyy-MM-dd'T'HH:mm");
            }
            if (requestedTime.isBefore(LocalDateTime.now())) {
                return badRequest("Booking date/time cannot be in the past.");
            }
        }

        final LocalDateTime slotTime = requestedTime;
        boolean slotTaken = bookingRepo.findByProviderOrderByRequestedTimeDesc(p).stream()
                .filter(b -> b.getStatus() != ProviderBookingStatus.CANCELLED)
                .anyMatch(b -> b.getRequestedTime() != null
                        && java.time.Duration.between(b.getRequestedTime(), slotTime).abs().toMinutes() < 60);
        if (slotTaken) {
            return badRequest("This time slot is already booked.");
        }

        ProviderBooking b = new ProviderBooking();
        b.setUser(user);
        b.setProvider(p);
        b.setRequestedTime(slotTime);
        b.setNote(trim(body != null ? body.get("note") : null));
        b.setStatus(ProviderBookingStatus.PENDING);
        bookingRepo.save(b);
        return ResponseEntity.ok(ok(Map.of("message", "Booking requested", "bookingId", b.getId(),
                "requestedTime", b.getRequestedTime().toString())));
    }

    @GetMapping("/bookings/me")
    public ResponseEntity<Map<String, Object>> myBookings(HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        List<Map<String, Object>> items = bookingRepo.findByUserOrderByRequestedTimeDesc(user).stream().map(b -> {
            Map<String, Object> m = new LinkedHashMap<>();
            m.put("id", b.getId());
            m.put("status", b.getStatus() == null ? null : b.getStatus().name());
            m.put("requestedTime", b.getRequestedTime() == null ? null : b.getRequestedTime().toString());
            m.put("note", b.getNote());
            if (b.getProvider() != null) m.put("provider", providerDto(b.getProvider()));
            return m;
        }).toList();
        return ResponseEntity.ok(ok(Map.of("bookings", items)));
    }

    private Map<String, Object> providerDto(ServiceProvider p) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", p.getId());
        m.put("fullName", p.getFullName());
        m.put("category", p.getCategory() == null ? null : p.getCategory().name());
        m.put("description", p.getDescription());
        m.put("locationText", p.getLocationText());
        m.put("rating", p.getRating());
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
