package in.sp.main.Controller;

import in.sp.main.Entities.User;
import in.sp.main.Entities.WomenEvent;
import in.sp.main.Entities.WomenEventCategory;
import in.sp.main.Entities.WomenEventRegistration;
import in.sp.main.Repository.WomenEventRegistrationRepository;
import in.sp.main.Repository.WomenEventRepository;
import in.sp.main.Repository.WomenEventReviewRepository;
import in.sp.main.Service.EventHostProfileService;
import in.sp.main.Service.EventsCareService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

@RestController
@RequestMapping("/api/women-events")
public class MobileWomenEventController {

    @Autowired
    private WomenEventRepository eventRepo;
    @Autowired
    private WomenEventRegistrationRepository registrationRepo;
    @Autowired
    private WomenEventReviewRepository reviewRepo;
    @Autowired
    private EventsCareService eventsCareService;

    @GetMapping("/categories")
    public ResponseEntity<Map<String, Object>> categories() {
        return ResponseEntity.ok(ok(Map.of("categories", WomenEventCategory.asCatalog())));
    }

    @GetMapping
    public ResponseEntity<Map<String, Object>> list(
            @RequestParam(required = false) String category,
            @RequestParam(required = false) String city,
            @RequestParam(required = false) String sort,
            HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        WomenEventCategory filterCat = WomenEventCategory.fromFlexible(category);
        String cityFilter = city == null ? "" : city.trim().toLowerCase(Locale.ROOT);
        String sortKey = sort == null ? "newest" : sort.trim().toLowerCase(Locale.ROOT);
        List<WomenEvent> filtered = eventRepo.findByStatusOrderByCreatedAtDesc("APPROVED").stream()
                .filter(e -> e.getOrganizer() == null || EventHostProfileService.isApproved(e.getOrganizer()))
                .filter(e -> filterCat == null || filterCat.equals(e.getCategory()))
                .filter(e -> cityFilter.isBlank()
                        || (e.getCity() != null && e.getCity().toLowerCase(Locale.ROOT).contains(cityFilter)))
                .sorted((a, b) -> {
                    if ("rating".equals(sortKey)) {
                        double ra = a.getOrganizer() == null ? 0 : a.getOrganizer().getRating();
                        double rb = b.getOrganizer() == null ? 0 : b.getOrganizer().getRating();
                        int cmp = Double.compare(rb, ra);
                        if (cmp != 0) return cmp;
                    }
                    if (a.getCreatedAt() == null && b.getCreatedAt() == null) return 0;
                    if (a.getCreatedAt() == null) return 1;
                    if (b.getCreatedAt() == null) return -1;
                    return b.getCreatedAt().compareTo(a.getCreatedAt());
                })
                .toList();
        List<Map<String, Object>> items = filtered.stream().map(e -> eventDto(e, user)).toList();
        return ResponseEntity.ok(ok(Map.of(
                "events", items,
                "count", items.size(),
                "cancelPolicy", EventsCareService.CANCEL_POLICY
        )));
    }

    @GetMapping("/{id}")
    public ResponseEntity<Map<String, Object>> detail(@PathVariable Long id, HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        WomenEvent e = eventRepo.findById(id).orElse(null);
        if (e == null || !"APPROVED".equals(e.getStatus())) return badRequest("Event not found");
        if (e.getOrganizer() != null && !EventHostProfileService.isApproved(e.getOrganizer())) {
            return badRequest("Event not found");
        }
        return ResponseEntity.ok(ok(Map.of(
                "event", eventDto(e, user),
                "cancelPolicy", EventsCareService.CANCEL_POLICY
        )));
    }

    @PostMapping("/{id}/register")
    @Transactional
    public ResponseEntity<Map<String, Object>> register(@PathVariable Long id, HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        WomenEvent e = eventRepo.findById(id).orElse(null);
        if (e == null || !"APPROVED".equalsIgnoreCase(e.getStatus())) {
            return badRequest("Event not found");
        }
        if (e.getOrganizer() != null && !EventHostProfileService.isApproved(e.getOrganizer())) {
            return badRequest("Event not found");
        }
        if (registrationRepo.existsActiveByEventAndUser(e, user)) {
            return badRequest("Already registered");
        }
        Integer max = e.getMaxParticipants();
        if (max != null && max > 0) {
            long taken = registrationRepo.countActiveByEvent(e);
            if (taken >= max) {
                return badRequest("Event is full");
            }
        }
        double fee = e.getEntryFee() == null ? 0 : Math.max(0, e.getEntryFee());
        WomenEventRegistration reg = registrationRepo.findByEventAndUser(e, user).orElse(null);
        if (reg != null && "CANCELLED".equalsIgnoreCase(reg.getStatus())) {
            reg.setStatus("REGISTERED");
            reg.setCheckedIn(false);
            reg.setPaid(fee <= 0);
            reg.setAmountPaid(0.0);
            reg.setRegisteredAt(java.time.LocalDateTime.now());
        } else {
            reg = new WomenEventRegistration();
            reg.setEvent(e);
            reg.setUser(user);
            reg.setStatus("REGISTERED");
            reg.setPaid(fee <= 0);
            reg.setAmountPaid(0.0);
        }
        registrationRepo.save(reg);
        try { eventsCareService.notifyRegistered(reg); } catch (Exception ignored) {}
        Map<String, Object> data = new LinkedHashMap<>();
        data.put("message", fee > 0 ? "Registered — complete payment to confirm ticket" : "Registered");
        data.put("registrationId", reg.getId());
        data.put("ticketCode", reg.getTicketCode());
        data.put("amount", fee);
        data.put("paymentRequired", fee > 0 && !reg.isPaid());
        data.put("paid", reg.isPaid());
        return ResponseEntity.ok(ok(data));
    }

    @PostMapping("/registrations/{id}/cancel")
    @Transactional
    public ResponseEntity<Map<String, Object>> cancelRegistration(@PathVariable Long id, HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        WomenEventRegistration reg = registrationRepo.findById(id).orElse(null);
        if (reg == null || reg.getUser() == null || !reg.getUser().getId().equals(user.getId())) {
            return badRequest("Registration not found");
        }
        if ("CANCELLED".equalsIgnoreCase(reg.getStatus())) {
            return badRequest("Registration already cancelled");
        }
        try {
            eventsCareService.cancel(reg);
        } catch (org.springframework.web.server.ResponseStatusException ex) {
            return ResponseEntity.status(ex.getStatusCode()).body(Map.of("success", false, "error", ex.getReason()));
        }
        return ResponseEntity.ok(ok(Map.of(
                "message", "Registration cancelled",
                "registrationId", reg.getId(),
                "status", "CANCELLED",
                "cancelPolicy", EventsCareService.CANCEL_POLICY
        )));
    }

    @PostMapping("/registrations/{id}/rate")
    @Transactional
    public ResponseEntity<Map<String, Object>> rateRegistration(
            @PathVariable Long id,
            @RequestBody Map<String, Object> body,
            HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        WomenEventRegistration reg = registrationRepo.findById(id).orElse(null);
        if (reg == null || reg.getUser() == null || !reg.getUser().getId().equals(user.getId())) {
            return badRequest("Registration not found");
        }
        int stars = 5;
        try {
            if (body != null && body.get("rating") != null) {
                stars = Integer.parseInt(String.valueOf(body.get("rating")));
            }
        } catch (Exception ignored) {}
        String text = body == null || body.get("review") == null ? "" : String.valueOf(body.get("review"));
        try {
            eventsCareService.rate(reg, stars, text);
        } catch (org.springframework.web.server.ResponseStatusException ex) {
            return ResponseEntity.status(ex.getStatusCode()).body(Map.of("success", false, "error", ex.getReason()));
        }
        return ResponseEntity.ok(ok(Map.of("message", "Thanks for your review")));
    }

    @GetMapping("/registrations/me")
    public ResponseEntity<Map<String, Object>> myRegistrations(HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        List<Map<String, Object>> items = registrationRepo.findByUserOrderByRegisteredAtDesc(user).stream().map(r -> {
            Map<String, Object> m = new LinkedHashMap<>();
            m.put("id", r.getId());
            m.put("registrationId", r.getId());
            m.put("status", r.getStatus());
            m.put("ticketCode", r.getTicketCode());
            m.put("checkedIn", r.isCheckedIn());
            m.put("registeredAt", r.getRegisteredAt() == null ? null : r.getRegisteredAt().toString());
            m.put("paid", r.isPaid());
            m.put("amountPaid", r.getAmountPaid());
            double fee = r.getEvent() != null && r.getEvent().getEntryFee() != null
                    ? Math.max(0, r.getEvent().getEntryFee()) : 0;
            m.put("amount", fee);
            boolean cancelled = "CANCELLED".equalsIgnoreCase(r.getStatus());
            m.put("paymentRequired", !cancelled && !r.isPaid() && fee > 0);
            m.put("canCancel", eventsCareService.canCancel(r));
            m.put("canReview", eventsCareService.canReview(r));
            m.put("cancelPolicy", EventsCareService.CANCEL_POLICY);
            if (r.getEvent() != null) m.put("event", eventDto(r.getEvent(), user));
            return m;
        }).toList();
        return ResponseEntity.ok(ok(Map.of("registrations", items)));
    }

    private Map<String, Object> eventDto(WomenEvent e, User user) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", e.getId());
        m.put("name", e.getName());
        m.put("category", e.getCategory() == null ? null : e.getCategory().name());
        m.put("categoryLabel", e.getCategory() == null ? null : e.getCategory().getDisplayName());
        m.put("description", e.getDescription());
        m.put("eventDate", e.getEventDate() == null ? null : e.getEventDate().toString());
        m.put("eventTime", e.getEventTime() == null ? null : e.getEventTime().toString());
        m.put("venue", e.getVenue());
        m.put("city", e.getCity());
        m.put("mapsLocation", e.getMapsLocation());
        m.put("entryFee", e.getEntryFee());
        m.put("free", e.isFree());
        m.put("maxParticipants", e.getMaxParticipants());
        m.put("capacity", e.getMaxParticipants());
        m.put("bannerImage", e.getBannerImage());
        m.put("imagePath", e.getBannerImage());
        m.put("bannerUrl", e.getBannerImage());
        m.put("featured", e.isFeatured());
        m.put("status", e.getStatus());
        m.put("organizerName", e.getOrganizerName());
        m.put("organizerType", e.getOrganizerType());
        m.put("contactInfo", e.getContactInfo());
        m.put("virtual", e.isVirtual());
        m.put("streamLink", e.getStreamLink());
        if (e.getOrganizer() != null) {
            m.put("hostRating", e.getOrganizer().getRating());
            m.put("hostReviewCount", e.getOrganizer().getReviewCount());
            m.put("rating", e.getOrganizer().getRating());
        } else {
            Double avg = reviewRepo.getAverageRating(e);
            m.put("hostRating", avg == null ? 0 : avg);
            m.put("rating", avg == null ? 0 : avg);
        }

        long seatsTaken = registrationRepo.countActiveByEvent(e);
        m.put("registrationCount", seatsTaken);
        m.put("seatsTaken", seatsTaken);
        Integer max = e.getMaxParticipants();
        if (max != null && max > 0) {
            m.put("seatsRemaining", Math.max(0, max - seatsTaken));
            m.put("full", seatsTaken >= max);
        } else {
            m.put("seatsRemaining", null);
            m.put("full", false);
        }

        boolean already = user != null && registrationRepo.existsActiveByEventAndUser(e, user);
        m.put("alreadyRegistered", already);
        if (already && user != null) {
            registrationRepo.findActiveByEventAndUser(e, user).ifPresent(reg -> {
                m.put("myRegistrationId", reg.getId());
                m.put("myPaid", reg.isPaid());
                m.put("myTicketCode", reg.getTicketCode());
                m.put("myStatus", reg.getStatus());
            });
        }
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
