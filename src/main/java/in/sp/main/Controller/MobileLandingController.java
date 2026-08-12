package in.sp.main.Controller;

import in.sp.main.Entities.*;
import in.sp.main.Repository.*;
import in.sp.main.Service.MartialArtsCenterService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;

import java.util.*;
import java.util.stream.Collectors;

/**
 * Public landing-page feed for Flutter (no login required).
 * Optional JWT still hydrates session for personalized notification extras.
 */
@RestController
@RequestMapping("/api/landing")
public class MobileLandingController {

    private static final int LIMIT = 8;

    @Autowired private WomenEventRepository eventRepo;
    @Autowired private OfferRepository offerRepo;
    @Autowired private SalonRepository salonRepo;
    @Autowired private MartialArtsCenterService martialArtsCenterService;
    @Autowired private ServiceProviderRepository providerRepo;
    @Autowired private WomenProductRepository productRepo;
    @Autowired private DoctorRepository doctorRepo;
    @Autowired private BroadcastMessageRepository broadcastRepo;
    @Autowired private VideoUploadRepository videoUploadRepo;
    @Autowired private CreatorNotificationRepository creatorNotificationRepo;
    @Autowired private UserRepository userRepo;
    @Autowired private MartialArtsCenterRepository centreRepo;

    @GetMapping("/feed")
    @Transactional(readOnly = true)
    public ResponseEntity<Map<String, Object>> feed() {
        List<Map<String, Object>> events = eventRepo.findByStatusOrderByCreatedAtDesc("APPROVED").stream()
                .limit(LIMIT)
                .map(this::eventDto)
                .collect(Collectors.toList());

        List<Map<String, Object>> offers = offerRepo.findByActiveTrue().stream()
                .filter(o -> o.getSalon() != null && o.getSalon().isApproved())
                .limit(LIMIT)
                .map(this::offerDto)
                .collect(Collectors.toList());

        List<Map<String, Object>> salons = salonRepo.findByApproved(true).stream()
                .limit(LIMIT)
                .map(this::salonDto)
                .collect(Collectors.toList());

        List<Map<String, Object>> centres = martialArtsCenterService.getApprovedCentersForDiscovery().stream()
                .limit(LIMIT)
                .map(this::centreDto)
                .collect(Collectors.toList());

        List<Map<String, Object>> providers = providerRepo.findByVerificationStatus(VerificationStatus.VERIFIED).stream()
                .limit(LIMIT)
                .map(this::providerDto)
                .collect(Collectors.toList());

        List<Map<String, Object>> products = productRepo.findByActiveTrueAndDeletedFalseOrderByCreatedAtDesc().stream()
                .limit(LIMIT)
                .map(this::productDto)
                .collect(Collectors.toList());

        List<Map<String, Object>> doctors = doctorRepo.findByVerificationStatus(VerificationStatus.VERIFIED).stream()
                .limit(LIMIT)
                .map(this::doctorDto)
                .collect(Collectors.toList());

        List<Map<String, Object>> community = videoUploadRepo
                .findTop8ByIsBlockedFalseAndIsDraftFalseAndStatusOrderByUploadTimeDesc("APPROVED")
                .stream()
                .map(this::communityDto)
                .collect(Collectors.toList());

        Map<String, Object> stats = new LinkedHashMap<>();
        stats.put("events", eventRepo.countByStatus("APPROVED"));
        stats.put("salons", salonRepo.countByApproved(true));
        stats.put("centres", centreRepo.countByApproved(true));
        stats.put("providers", providerRepo.countByVerificationStatus(VerificationStatus.VERIFIED));
        stats.put("doctors", doctorRepo.countByVerificationStatus(VerificationStatus.VERIFIED));
        stats.put("products", productRepo.countByActiveTrueAndDeletedFalse());

        // What's New = mix of latest events, offers, centres
        List<Map<String, Object>> whatsNew = new ArrayList<>();
        for (Map<String, Object> e : events) {
            Map<String, Object> card = new LinkedHashMap<>();
            card.put("kind", "EVENT");
            card.put("id", e.get("id"));
            card.put("badge", "Event");
            card.put("title", e.get("name"));
            card.put("subtitle", e.get("city") != null ? e.get("city") : e.get("category"));
            card.put("cta", "Register");
            card.put("route", "events");
            whatsNew.add(card);
            if (whatsNew.size() >= 3) break;
        }
        for (Map<String, Object> o : offers) {
            if (whatsNew.size() >= 6) break;
            Map<String, Object> card = new LinkedHashMap<>();
            card.put("kind", "OFFER");
            card.put("id", o.get("id"));
            card.put("badge", o.get("discountLabel") != null ? o.get("discountLabel") : "Offer");
            card.put("title", o.get("title"));
            card.put("subtitle", o.get("salonName"));
            card.put("cta", "Grab Now");
            card.put("route", "glow");
            whatsNew.add(card);
        }
        for (Map<String, Object> c : centres) {
            if (whatsNew.size() >= 8) break;
            Map<String, Object> card = new LinkedHashMap<>();
            card.put("kind", "CENTRE");
            card.put("id", c.get("id"));
            card.put("badge", "Self Defence");
            card.put("title", c.get("name"));
            card.put("subtitle", c.get("city") != null ? c.get("city") : "Training centre");
            card.put("cta", "Book Now");
            card.put("route", "martial_arts");
            whatsNew.add(card);
        }

        // Nearby-style listings (no geo yet — curated verified services)
        List<Map<String, Object>> nearby = new ArrayList<>();
        for (Map<String, Object> d : doctors) {
            nearby.add(nearbyItem("DOCTOR", d.get("id"), d.get("fullName"), d.get("specialization"), d.get("rating"), "doctors", "local_hospital"));
            if (nearby.size() >= 2) break;
        }
        for (Map<String, Object> s : salons) {
            nearby.add(nearbyItem("SALON", s.get("id"), s.get("name"), s.get("city"), s.get("rating"), "glow", "spa"));
            if (nearby.size() >= 4) break;
        }
        for (Map<String, Object> c : centres) {
            nearby.add(nearbyItem("CENTRE", c.get("id"), c.get("name"), c.get("city"), c.get("rating"), "martial_arts", "sports_martial_arts"));
            if (nearby.size() >= 6) break;
        }
        for (Map<String, Object> p : providers) {
            nearby.add(nearbyItem("PROVIDER", p.get("id"), p.get("fullName"), p.get("category"), p.get("rating"), "marketplace", "storefront"));
            if (nearby.size() >= 8) break;
        }

        Map<String, Object> data = new LinkedHashMap<>();
        data.put("success", true);
        data.put("stats", stats);
        data.put("whatsNew", whatsNew);
        data.put("nearby", nearby);
        data.put("offers", offers);
        data.put("community", community);
        data.put("events", events);
        data.put("salons", salons);
        data.put("centres", centres);
        data.put("providers", providers);
        data.put("products", products);
        data.put("doctors", doctors);
        return ResponseEntity.ok(data);
    }

    @GetMapping("/notifications")
    @Transactional(readOnly = true)
    public ResponseEntity<Map<String, Object>> notifications(HttpSession session) {
        List<Map<String, Object>> items = new ArrayList<>();
        List<BroadcastMessage> broadcasts = broadcastRepo.findAllByOrderBySentAtDesc();

        // Platform broadcasts (always available)
        for (BroadcastMessage b : broadcasts) {
            Map<String, Object> m = new LinkedHashMap<>();
            m.put("id", "broadcast-" + b.getId());
            m.put("source", "BROADCAST");
            m.put("type", b.getType() == null ? "INFO" : b.getType());
            m.put("title", b.getTitle());
            m.put("message", b.getMessage());
            m.put("createdAt", b.getSentAt() == null ? null : b.getSentAt().toString());
            m.put("route", inferRoute(b.getTitle(), b.getMessage(), b.getType()));
            items.add(m);
            if (items.size() >= 20) break;
        }

        // Live module highlights so the inbox is never empty when DB has content
        eventRepo.findByStatusOrderByCreatedAtDesc("APPROVED").stream().limit(3).forEach(e -> {
            Map<String, Object> m = new LinkedHashMap<>();
            m.put("id", "event-" + e.getId());
            m.put("source", "EVENT");
            m.put("type", "INFO");
            m.put("title", "New event: " + nullToEmpty(e.getName()));
            String where = e.getCity() != null ? e.getCity() : (e.getVenue() != null ? e.getVenue() : "Open now");
            m.put("message", where + (e.getEventDate() == null ? "" : " · " + e.getEventDate()));
            m.put("createdAt", e.getCreatedAt() == null ? null : e.getCreatedAt().toString());
            m.put("route", "events");
            items.add(m);
        });

        offerRepo.findByActiveTrue().stream()
                .filter(o -> o.getSalon() != null && o.getSalon().isApproved())
                .limit(3)
                .forEach(o -> {
                    Map<String, Object> m = new LinkedHashMap<>();
                    m.put("id", "offer-" + o.getId());
                    m.put("source", "OFFER");
                    m.put("type", "INFO");
                    m.put("title", o.getTitle() == null ? "Glow offer" : o.getTitle());
                    String salon = o.getSalon() == null ? "Glow Space" : o.getSalon().getName();
                    String discount = o.getDiscountPercent() > 0
                            ? ((int) o.getDiscountPercent()) + "% OFF · "
                            : "";
                    m.put("message", discount + salon);
                    m.put("createdAt", null);
                    m.put("route", "glow");
                    items.add(m);
                });

        // Personalized extras when logged in as USER
        User user = sessionUser(session);
        int unread = 0;
        if (user != null) {
            if (user.getLastReadBroadcastTime() == null) {
                unread = broadcasts.size();
            } else {
                unread = (int) broadcasts.stream()
                        .filter(b -> b.getSentAt() != null && b.getSentAt().isAfter(user.getLastReadBroadcastTime()))
                        .count();
            }
            // Count fresh event/offer highlights as unread when user never opened inbox
            if (user.getLastReadBroadcastTime() == null) {
                unread = Math.max(unread, Math.min(items.size(), 8));
            }

            try {
                List<CreatorNotification> creatorNotifs =
                        creatorNotificationRepo.findByUser_IdOrderByCreatedAtDesc(user.getId());
                for (CreatorNotification n : creatorNotifs) {
                    Map<String, Object> m = new LinkedHashMap<>();
                    m.put("id", "creator-" + n.getId());
                    m.put("source", "CREATOR");
                    m.put("type", n.getType());
                    m.put("title", "Creator Hub");
                    m.put("message", n.getMessage());
                    m.put("createdAt", n.getCreatedAt() == null ? null : n.getCreatedAt().toString());
                    m.put("route", "community");
                    items.add(m);
                    if (items.size() >= 40) break;
                }
            } catch (Exception ignored) {
                // Creator notifications table/method may vary — broadcasts still work.
            }

            Map<String, Object> tip = new LinkedHashMap<>();
            tip.put("id", "system-sos");
            tip.put("source", "SYSTEM");
            tip.put("type", "TIP");
            tip.put("title", "Stay prepared");
            tip.put("message", "Keep trusted contacts updated so SOS can reach help fast.");
            tip.put("createdAt", null);
            tip.put("route", "sos");
            items.add(0, tip);
        } else {
            Map<String, Object> tip = new LinkedHashMap<>();
            tip.put("id", "system-login");
            tip.put("source", "SYSTEM");
            tip.put("type", "INFO");
            tip.put("title", "Welcome to Fight D Fear");
            tip.put("message", "Sign in to get personalized alerts, SOS, events and bookings.");
            tip.put("createdAt", null);
            tip.put("route", "login");
            items.add(0, tip);
            unread = Math.min(items.size(), 9);
        }

        Map<String, Object> res = new LinkedHashMap<>();
        res.put("success", true);
        res.put("unreadCount", unread);
        res.put("notifications", items);
        res.put("count", items.size());
        return ResponseEntity.ok(res);
    }

    @PostMapping("/notifications/read")
    public ResponseEntity<Map<String, Object>> markNotificationsRead(HttpSession session) {
        User user = sessionUser(session);
        if (user == null) {
            return ResponseEntity.ok(Map.of("success", true, "message", "Not logged in"));
        }
        User fresh = userRepo.findById(user.getId()).orElse(user);
        fresh.setLastReadBroadcastTime(java.time.LocalDateTime.now());
        userRepo.save(fresh);
        session.setAttribute("user", fresh);
        return ResponseEntity.ok(Map.of("success", true, "message", "Marked as read"));
    }

    private User sessionUser(HttpSession session) {
        if (session == null) return null;
        Object u = session.getAttribute("user");
        return u instanceof User ? (User) u : null;
    }

    private String nullToEmpty(String s) {
        return s == null ? "" : s;
    }

    /** Map admin broadcast text to a landing module route when possible. */
    private String inferRoute(String title, String message, String type) {
        String blob = ((title == null ? "" : title) + " " + (message == null ? "" : message)
                + " " + (type == null ? "" : type)).toLowerCase(Locale.ROOT);
        if (blob.contains("sos") || blob.contains("emergency") || blob.contains("alert")) return "sos";
        if (blob.contains("event") || blob.contains("workshop") || blob.contains("webinar")) return "events";
        if (blob.contains("glow") || blob.contains("salon") || blob.contains("spa") || blob.contains("offer")) return "glow";
        if (blob.contains("martial") || blob.contains("defence") || blob.contains("defense") || blob.contains("training")) return "martial_arts";
        if (blob.contains("doctor") || blob.contains("health") || blob.contains("clinic")) return "doctors";
        if (blob.contains("market") || blob.contains("provider") || blob.contains("service")) return "marketplace";
        if (blob.contains("community") || blob.contains("creator") || blob.contains("video")) return "community";
        return "events";
    }

    private Map<String, Object> nearbyItem(String kind, Object id, Object title, Object subtitle,
                                           Object rating, String route, String icon) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("kind", kind);
        m.put("id", id);
        m.put("title", title);
        m.put("subtitle", subtitle);
        m.put("rating", rating);
        m.put("route", route);
        m.put("icon", icon);
        return m;
    }

    private Map<String, Object> eventDto(WomenEvent e) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", e.getId());
        m.put("name", e.getName());
        m.put("category", e.getCategory() == null ? null : e.getCategory().name());
        m.put("city", e.getCity());
        m.put("eventDate", e.getEventDate() == null ? null : e.getEventDate().toString());
        m.put("venue", e.getVenue());
        return m;
    }

    private Map<String, Object> offerDto(Offer o) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", o.getId());
        m.put("title", o.getTitle());
        m.put("description", o.getDescription());
        String discount = null;
        if (o.getDiscountPercent() > 0) {
            discount = ((int) o.getDiscountPercent()) + "% OFF";
        }
        m.put("discountLabel", discount);
        m.put("salonName", o.getSalon() == null ? null : o.getSalon().getName());
        m.put("salonId", o.getSalon() == null ? null : o.getSalon().getId());
        return m;
    }

    private Map<String, Object> salonDto(Salon s) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", s.getId());
        m.put("name", s.getName());
        m.put("city", s.getCity());
        m.put("rating", s.getRating());
        m.put("address", s.getAddress());
        return m;
    }

    private Map<String, Object> centreDto(MartialArtsCenter c) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", c.getId());
        m.put("name", c.getName());
        m.put("city", c.getLocation());
        m.put("rating", null);
        m.put("address", c.getLocation());
        return m;
    }

    private Map<String, Object> providerDto(ServiceProvider p) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", p.getId());
        m.put("fullName", p.getFullName());
        m.put("category", p.getCategory() == null ? null : p.getCategory().name());
        m.put("city", p.getLocationText());
        m.put("rating", p.getRating());
        return m;
    }

    private Map<String, Object> productDto(WomenProduct p) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", p.getId());
        m.put("name", p.getName());
        m.put("price", p.getPrice());
        m.put("category", p.getCategory());
        m.put("brand", p.getBrand());
        return m;
    }

    private Map<String, Object> doctorDto(Doctor d) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", d.getId());
        m.put("fullName", d.getFullName());
        m.put("specialization", d.getSpecialization());
        m.put("rating", d.getRating());
        m.put("hospitalName", d.getHospitalName());
        return m;
    }

    private int safeCommentCount(Videoupload v) {
        try {
            return v.getComments() == null ? 0 : v.getComments().size();
        } catch (Exception ignored) {
            return 0;
        }
    }

    private Map<String, Object> communityDto(Videoupload v) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", v.getId());
        m.put("title", v.getTitle());
        m.put("description", v.getDescription());
        m.put("category", v.getCategory());
        m.put("likes", v.getLikeCount());
        m.put("comments", safeCommentCount(v));
        m.put("createdAt", v.getUploadTime() == null ? null : v.getUploadTime().toString());
        if (v.getUser() != null) {
            m.put("author", v.getUser().getFullName());
        }
        return m;
    }
}
