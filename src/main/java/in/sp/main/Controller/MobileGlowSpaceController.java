package in.sp.main.Controller;

import in.sp.main.Entities.*;
import in.sp.main.Repository.*;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.*;

/**
 * Mobile JSON APIs for Glow Space browse + booking flow.
 */
@RestController
@RequestMapping("/api/glow")
public class MobileGlowSpaceController {

    @Autowired
    private SalonRepository salonRepo;
    @Autowired
    private ServiceRepository serviceRepo;
    @Autowired
    private TreatmentRepository treatmentRepo;
    @Autowired
    private OfferRepository offerRepo;
    @Autowired
    private StylistRepository stylistRepo;
    @Autowired
    private Booking1Repository bookingRepo;

    @GetMapping("/salons")
    public ResponseEntity<Map<String, Object>> salons(HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();

        List<Map<String, Object>> items = salonRepo.findByApproved(true).stream()
                .map(this::salonDto)
                .toList();
        return ResponseEntity.ok(ok(Map.of("salons", items, "count", items.size())));
    }

    @GetMapping("/salons/{id}")
    public ResponseEntity<Map<String, Object>> salonDetail(@PathVariable Long id, HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();

        Salon s = salonRepo.findById(id).orElse(null);
        if (s == null || !s.isApproved()) return badRequest("Salon not found.");

        List<Map<String, Object>> services = serviceRepo.findBySalonId(id).stream()
                .map(this::serviceDto)
                .toList();
        List<Map<String, Object>> treatments = treatmentRepo.findBySalonId(id).stream()
                .map(this::treatmentDto)
                .toList();
        List<Map<String, Object>> offers = offerRepo.findBySalonId(id).stream()
                .filter(Offer::isActive)
                .map(this::offerDto)
                .toList();
        List<Map<String, Object>> stylists = stylistRepo.findBySalonId(id).stream()
                .filter(Stylist::isApproved)
                .map(this::stylistDto)
                .toList();

        Map<String, Object> out = new LinkedHashMap<>();
        out.put("success", true);
        out.put("salon", salonDto(s));
        out.put("services", services);
        out.put("treatments", treatments);
        out.put("offers", offers);
        out.put("stylists", stylists);
        return ResponseEntity.ok(out);
    }

    @GetMapping("/treatments")
    public ResponseEntity<Map<String, Object>> treatments(HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        List<Map<String, Object>> items = treatmentRepo.findAll().stream()
                .filter(t -> t.getSalon() != null && t.getSalon().isApproved())
                .map(this::treatmentDto)
                .toList();
        return ResponseEntity.ok(ok(Map.of("treatments", items, "count", items.size())));
    }

    @GetMapping("/stylists")
    public ResponseEntity<Map<String, Object>> stylists(HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        List<Map<String, Object>> items = stylistRepo.findByApproved(true).stream()
                .map(this::stylistDto)
                .toList();
        return ResponseEntity.ok(ok(Map.of("stylists", items, "count", items.size())));
    }

    @GetMapping("/offers")
    public ResponseEntity<Map<String, Object>> offers(HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        List<Map<String, Object>> items = offerRepo.findByActiveTrue().stream()
                .filter(o -> o.getSalon() != null && o.getSalon().isApproved())
                .map(this::offerDto)
                .toList();
        return ResponseEntity.ok(ok(Map.of("offers", items, "count", items.size())));
    }

    @PostMapping("/bookings")
    @Transactional
    public ResponseEntity<Map<String, Object>> createBooking(
            @RequestBody Map<String, Object> body,
            HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();

        String itemType = str(body.get("itemType")).toUpperCase(Locale.ROOT);
        Long itemId = asLong(body.get("itemId"));
        String bookingType = str(body.get("bookingType")).isBlank()
                ? "ONLINE"
                : str(body.get("bookingType")).toUpperCase(Locale.ROOT);
        String address = str(body.get("address"));
        String notes = str(body.get("notes"));
        String emergencyContact = str(body.get("emergencyContact"));
        String allergyInfo = str(body.get("allergyInfo"));
        String dateRaw = str(body.get("bookingDate"));
        String timeRaw = str(body.get("preferredTime"));

        if (itemId == null || itemType.isBlank()) {
            return badRequest("itemType and itemId are required.");
        }
        if ("DOOR".equals(bookingType) && address.isBlank()) {
            return badRequest("Address is required for door booking.");
        }

        LocalDate bookingDate;
        LocalTime preferredTime;
        try {
            bookingDate = dateRaw.isBlank() ? LocalDate.now().plusDays(1) : LocalDate.parse(dateRaw);
            preferredTime = timeRaw.isBlank() ? LocalTime.of(11, 0) : LocalTime.parse(timeRaw);
        } catch (Exception e) {
            return badRequest("Invalid bookingDate or preferredTime format.");
        }

        Booking1 booking = new Booking1();
        booking.setUser(user);
        booking.setBookingDate(bookingDate);
        booking.setPreferredTime(preferredTime);
        booking.setBookingType(bookingType);
        booking.setAddress(address);
        booking.setNotes(notes);
        booking.setEmergencyContact(emergencyContact);
        booking.setAllergyInfo(allergyInfo);
        booking.setStatus("PENDING");

        double price;
        Salon salon;
        if ("SERVICE".equals(itemType)) {
            Service1 s = serviceRepo.findById(itemId).orElse(null);
            if (s == null || s.getSalon() == null || !s.getSalon().isApproved()) return badRequest("Service not found.");
            salon = s.getSalon();
            price = s.getPrice() == null ? 0 : s.getPrice();
            booking.setService(s);
        } else if ("TREATMENT".equals(itemType)) {
            Treatment t = treatmentRepo.findById(itemId).orElse(null);
            if (t == null || t.getSalon() == null || !t.getSalon().isApproved()) return badRequest("Treatment not found.");
            salon = t.getSalon();
            price = t.getPrice();
            booking.setTreatment(t);
        } else if ("OFFER".equals(itemType)) {
            Offer o = offerRepo.findById(itemId).orElse(null);
            if (o == null || o.getSalon() == null || !o.getSalon().isApproved() || !o.isActive()) return badRequest("Offer not found.");
            salon = o.getSalon();
            price = o.getDiscountedPrice() > 0 ? o.getDiscountedPrice() : o.getOfferPrice();
            booking.setOffer(o);
        } else {
            return badRequest("itemType must be SERVICE, TREATMENT, or OFFER.");
        }

        booking.setSalon(salon);
        booking.setPrice(price);
        bookingRepo.save(booking);

        return ResponseEntity.ok(ok(Map.of(
                "message", "Booking created.",
                "bookingId", booking.getId()
        )));
    }

    @GetMapping("/bookings/me")
    public ResponseEntity<Map<String, Object>> myBookings(HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();

        List<Map<String, Object>> items = bookingRepo.findByUser(user).stream()
                .sorted((a, b) -> Long.compare(
                        b.getId() == null ? 0 : b.getId(),
                        a.getId() == null ? 0 : a.getId()))
                .map(this::bookingDto)
                .toList();
        return ResponseEntity.ok(ok(Map.of("bookings", items, "count", items.size())));
    }

    private Map<String, Object> salonDto(Salon s) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", s.getId());
        m.put("name", s.getName());
        m.put("address", s.getAddress());
        m.put("city", s.getCity());
        m.put("state", s.getState());
        m.put("phone", s.getPhone());
        m.put("website", s.getWebsite());
        m.put("profileImageUrl", s.getProfileImageUrl());
        m.put("bio", s.getBio());
        m.put("availabilityHours", s.getAvailabilityHours());
        m.put("rating", s.getRating());
        m.put("ecoFriendly", s.getIsEcoFriendly());
        m.put("certified", s.getIsCertified());
        return m;
    }

    private Map<String, Object> serviceDto(Service1 s) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", s.getId());
        m.put("name", s.getName());
        m.put("category", s.getCategory() == null ? null : s.getCategory().name());
        m.put("price", s.getPrice());
        m.put("durationMinutes", s.getDurationMinutes());
        m.put("ingredients", s.getIngredients());
        m.put("allergenInfo", s.getAllergenInfo());
        m.put("photoUrl", s.getPhotoUrl());
        m.put("salonId", s.getSalon() == null ? null : s.getSalon().getId());
        m.put("salonName", s.getSalon() == null ? null : s.getSalon().getName());
        return m;
    }

    private Map<String, Object> treatmentDto(Treatment t) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", t.getId());
        m.put("serviceName", t.getServiceName());
        m.put("category", t.getCategory());
        m.put("description", t.getDescription());
        m.put("price", t.getPrice());
        m.put("duration", t.getDuration());
        m.put("imageUrl", t.getImageUrl());
        m.put("treatmentType", t.getTreatmentType() == null ? null : t.getTreatmentType().name());
        m.put("skinType", t.getSkinType() == null ? null : t.getSkinType().name());
        m.put("salonId", t.getSalon() == null ? null : t.getSalon().getId());
        m.put("salonName", t.getSalon() == null ? null : t.getSalon().getName());
        return m;
    }

    private Map<String, Object> offerDto(Offer o) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", o.getId());
        m.put("title", o.getTitle());
        m.put("description", o.getDescription());
        m.put("discountPercent", o.getDiscountPercent());
        m.put("originalPrice", o.getOriginalPrice());
        m.put("discountedPrice", o.getDiscountedPrice());
        m.put("offerPrice", o.getOfferPrice());
        m.put("startDate", o.getStartDate() == null ? null : o.getStartDate().toString());
        m.put("endDate", o.getEndDate() == null ? null : o.getEndDate().toString());
        m.put("salonId", o.getSalon() == null ? null : o.getSalon().getId());
        m.put("salonName", o.getSalon() == null ? null : o.getSalon().getName());
        return m;
    }

    private Map<String, Object> stylistDto(Stylist s) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", s.getId());
        m.put("firstName", s.getFirstName());
        m.put("lastName", s.getLastName());
        m.put("specialization", s.getSpecialization());
        m.put("experienceInYears", s.getExperienceInYears());
        m.put("rating", s.getRating());
        m.put("available", s.getAvailable());
        m.put("profileImage", s.getProfileImage());
        m.put("contactNumber", s.getContactNumber());
        m.put("bio", s.getBio());
        m.put("availabilityHours", s.getAvailabilityHours());
        m.put("salonId", s.getSalon() == null ? null : s.getSalon().getId());
        m.put("salonName", s.getSalon() == null ? null : s.getSalon().getName());
        return m;
    }

    private Map<String, Object> bookingDto(Booking1 b) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", b.getId());
        m.put("status", b.getStatus());
        m.put("bookingDate", b.getBookingDate() == null ? null : b.getBookingDate().toString());
        m.put("preferredTime", b.getPreferredTime() == null ? null : b.getPreferredTime().toString());
        m.put("bookingType", b.getBookingType());
        m.put("address", b.getAddress());
        m.put("price", b.getPrice());
        m.put("notes", b.getNotes());
        m.put("emergencyContact", b.getEmergencyContact());
        m.put("allergyInfo", b.getAllergyInfo());
        m.put("salon", b.getSalon() == null ? null : salonDto(b.getSalon()));
        if (b.getService() != null) {
            m.put("itemType", "SERVICE");
            m.put("item", serviceDto(b.getService()));
        } else if (b.getTreatment() != null) {
            m.put("itemType", "TREATMENT");
            m.put("item", treatmentDto(b.getTreatment()));
        } else if (b.getOffer() != null) {
            m.put("itemType", "OFFER");
            m.put("item", offerDto(b.getOffer()));
        }
        return m;
    }

    private User requireUser(HttpSession session) {
        if (session == null) return null;
        Object u = session.getAttribute("user");
        return u instanceof User ? (User) u : null;
    }

    private ResponseEntity<Map<String, Object>> unauthorized() {
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(Map.of(
                "success", false,
                "error", "Login required"
        ));
    }

    private ResponseEntity<Map<String, Object>> badRequest(String error) {
        return ResponseEntity.badRequest().body(Map.of(
                "success", false,
                "error", error
        ));
    }

    private static Map<String, Object> ok(Map<String, Object> data) {
        Map<String, Object> out = new LinkedHashMap<>();
        out.put("success", true);
        out.putAll(data);
        return out;
    }

    private static Long asLong(Object v) {
        if (v == null) return null;
        if (v instanceof Number n) return n.longValue();
        try { return Long.parseLong(v.toString().trim()); } catch (Exception e) { return null; }
    }

    private static String str(Object v) {
        return v == null ? "" : v.toString().trim();
    }
}
