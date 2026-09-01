package in.sp.main.Controller;

import in.sp.main.Entities.EventFavorite;
import in.sp.main.Entities.User;
import in.sp.main.Entities.WomenEvent;
import in.sp.main.Entities.WomenEventCategory;
import in.sp.main.Entities.WomenEventRegistration;
import in.sp.main.Repository.EventAgendaItemRepository;
import in.sp.main.Repository.EventFavoriteRepository;
import in.sp.main.Repository.EventSpeakerRepository;
import in.sp.main.Repository.EventTicketTypeRepository;
import in.sp.main.Repository.WomenEventRegistrationRepository;
import in.sp.main.Repository.WomenEventRepository;
import in.sp.main.Repository.WomenEventReviewRepository;
import in.sp.main.Service.EventHostProfileService;
import in.sp.main.Service.EventsCareService;
import in.sp.main.Service.WomenEventBookingService;
import in.sp.main.Service.WomenEventSupport;
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
    @Autowired
    private WomenEventBookingService bookingService;
    @Autowired
    private EventFavoriteRepository favoriteRepo;
    @Autowired
    private EventTicketTypeRepository ticketTypeRepo;
    @Autowired
    private EventSpeakerRepository speakerRepo;
    @Autowired
    private EventAgendaItemRepository agendaRepo;

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
        List<WomenEvent> filtered = eventRepo.findListedEvents().stream()
                .filter(WomenEventSupport::isPubliclyListed)
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
        if (e == null || !WomenEventSupport.isPubliclyListed(e)) return badRequest("Event not found");
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
    public ResponseEntity<Map<String, Object>> register(
            @PathVariable Long id,
            @RequestBody(required = false) Map<String, Object> body,
            HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        Long ticketTypeId = null;
        int quantity = 1;
        int coins = 0;
        if (body != null) {
            if (body.get("ticketTypeId") != null) {
                try { ticketTypeId = Long.parseLong(String.valueOf(body.get("ticketTypeId"))); } catch (Exception ignored) {}
            }
            if (body.get("quantity") != null) {
                try { quantity = Integer.parseInt(String.valueOf(body.get("quantity"))); } catch (Exception ignored) {}
            }
            if (body.get("coins") != null || body.get("coinsApplied") != null) {
                Object c = body.get("coins") != null ? body.get("coins") : body.get("coinsApplied");
                try { coins = Integer.parseInt(String.valueOf(c)); } catch (Exception ignored) {}
            }
        }
        try {
            WomenEventRegistration reg = bookingService.book(user, id, ticketTypeId, quantity, coins);
            session.setAttribute("user", user);
            double fee = bookingService.payableOf(reg);
            Map<String, Object> data = new LinkedHashMap<>();
            data.put("message", fee > 0 ? "Registered — complete payment to confirm ticket" : "Registered");
            data.put("registrationId", reg.getId());
            data.put("ticketCode", reg.getTicketCode());
            data.put("qrToken", reg.getQrToken());
            data.put("amount", fee);
            data.put("coinsUsed", reg.getCoinsUsed());
            data.put("paymentRequired", fee > 0 && !reg.isPaid());
            data.put("paid", reg.isPaid());
            return ResponseEntity.ok(ok(data));
        } catch (org.springframework.web.server.ResponseStatusException ex) {
            return ResponseEntity.status(ex.getStatusCode()).body(Map.of("success", false, "error", ex.getReason()));
        }
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
            m.put("qrToken", r.getQrToken());
            m.put("coinsUsed", r.getCoinsUsed());
            m.put("payableAmount", bookingService.payableOf(r));
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
        m.put("eventFormat", e.getEventFormat() == null ? null : e.getEventFormat().name());
        m.put("shortDescription", e.getShortDescription());
        boolean eligible = false;
        if (user != null) {
            eligible = registrationRepo.findActiveByEventAndUser(e, user)
                    .map(r -> r.isPaid() || e.isFree() || bookingService.payableOf(r) <= 0)
                    .orElse(false);
        }
        m.put("streamLink", WomenEventSupport.hideAccessIfUnauthorized(e, eligible));
        m.put("meetingPlatform", eligible ? e.getMeetingPlatform() : null);
        m.put("accessInstructions", eligible ? e.getAccessInstructions() : null);
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
        } else {
            m.put("seatsRemaining", null);
        }
        m.put("full", bookingService.isSoldOut(e));
        m.put("soldOut", bookingService.isSoldOut(e));
        m.put("registrationOpen", WomenEventSupport.registrationWindowOpen(e, java.time.LocalDateTime.now()));
        m.put("startsAt", e.getStartsAt() == null ? null : e.getStartsAt().toString());
        m.put("endsAt", e.getEndsAt() == null ? null : e.getEndsAt().toString());
        m.put("cancellationPolicy", e.getCancellationPolicy() != null ? e.getCancellationPolicy() : EventsCareService.CANCEL_POLICY);
        m.put("saved", user != null && favoriteRepo.existsByEventAndUser(e, user));
        m.put("ticketTypes", ticketTypeRepo.findByEventOrderByIdAsc(e).stream().map(t -> {
            Map<String, Object> tm = new LinkedHashMap<>();
            tm.put("id", t.getId());
            tm.put("name", t.getName());
            tm.put("description", t.getDescription());
            tm.put("price", t.getPrice());
            tm.put("remaining", t.remaining());
            tm.put("maxPerUser", t.getMaxPerUser());
            return tm;
        }).toList());
        m.put("speakers", speakerRepo.findByEventOrderBySortOrderAscIdAsc(e).stream().map(s -> {
            Map<String, Object> sm = new LinkedHashMap<>();
            sm.put("name", s.getName());
            sm.put("designation", s.getDesignation());
            sm.put("organization", s.getOrganization());
            sm.put("topic", s.getTopic());
            sm.put("bio", s.getBio());
            return sm;
        }).toList());
        m.put("agenda", agendaRepo.findByEventOrderBySortOrderAscStartTimeAsc(e).stream().map(a -> {
            Map<String, Object> am = new LinkedHashMap<>();
            am.put("title", a.getTitle());
            am.put("description", a.getDescription());
            am.put("startTime", a.getStartTime() == null ? null : a.getStartTime().toString());
            am.put("endTime", a.getEndTime() == null ? null : a.getEndTime().toString());
            am.put("speaker", a.getSpeakerName());
            return am;
        }).toList());

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

    @GetMapping("/{id}/coins-quote")
    public ResponseEntity<Map<String, Object>> coinsQuote(
            @PathVariable Long id,
            @RequestParam(defaultValue = "0") int coins,
            @RequestParam(required = false) Long ticketTypeId,
            @RequestParam(defaultValue = "1") int quantity,
            HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        WomenEvent e = eventRepo.findById(id).orElse(null);
        if (e == null) return badRequest("Event not found");
        double unit = e.getEntryFee() == null ? 0 : e.getEntryFee();
        if (ticketTypeId != null) {
            unit = ticketTypeRepo.findById(ticketTypeId).map(t -> t.getPrice()).orElse(unit);
        }
        if (quantity < 1) quantity = 1;
        return ResponseEntity.ok(ok(bookingService.quoteCoins(user, unit * quantity, coins)));
    }

    @PostMapping("/{id}/save")
    public ResponseEntity<Map<String, Object>> saveEvent(@PathVariable Long id, HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        WomenEvent e = eventRepo.findById(id).orElse(null);
        if (e == null) return badRequest("Event not found");
        boolean saved;
        var existing = favoriteRepo.findByEventAndUser(e, user);
        if (existing.isPresent()) {
            favoriteRepo.delete(existing.get());
            saved = false;
        } else {
            EventFavorite fav = new EventFavorite();
            fav.setEvent(e);
            fav.setUser(user);
            favoriteRepo.save(fav);
            saved = true;
        }
        return ResponseEntity.ok(ok(Map.of("saved", saved)));
    }

    @GetMapping("/saved")
    public ResponseEntity<Map<String, Object>> savedEvents(HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        List<Map<String, Object>> items = favoriteRepo.findByUserOrderByCreatedAtDesc(user).stream()
                .map(f -> eventDto(f.getEvent(), user))
                .toList();
        return ResponseEntity.ok(ok(Map.of("events", items)));
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
