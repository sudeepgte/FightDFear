package in.sp.main.Controller;

import in.sp.main.Entities.*;
import in.sp.main.Repository.*;
import in.sp.main.Service.GlowCareService;
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
    @Autowired
    private GlowCareService glowCareService;

    @GetMapping("/salons")
    public ResponseEntity<Map<String, Object>> salons(
            @RequestParam(required = false) String city,
            @RequestParam(required = false) String q,
            @RequestParam(required = false) String category,
            @RequestParam(required = false) Double minFee,
            @RequestParam(required = false) Double maxFee,
            @RequestParam(required = false) Boolean availableToday,
            @RequestParam(required = false) Boolean doorService,
            @RequestParam(required = false) String sort,
            @RequestParam(required = false) Double lat,
            @RequestParam(required = false) Double lng,
            HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();

        String cityQ = city == null ? "" : city.trim().toLowerCase(Locale.ROOT);
        String searchQ = q == null ? "" : q.trim();
        ServiceCategory catFilter = ServiceCategory.fromFlexible(category);
        List<Salon> approved = salonRepo.findByApproved(true);
        List<Map<String, Object>> items = new ArrayList<>();
        for (Salon s : approved) {
            if (!cityQ.isBlank() && (s.getCity() == null || !s.getCity().toLowerCase(Locale.ROOT).contains(cityQ))) {
                continue;
            }
            if (Boolean.TRUE.equals(doorService) && !Boolean.TRUE.equals(s.getDoorService())) {
                continue;
            }
            List<Service1> services = serviceRepo.findBySalonId(s.getId());
            if (catFilter != null) {
                boolean match = services.stream().anyMatch(sv -> sv.getCategory() != null
                        && sv.getCategory().normalized() == catFilter.normalized());
                String offered = s.getCategoriesOffered() == null ? "" : s.getCategoriesOffered().toUpperCase(Locale.ROOT);
                if (!match && !offered.contains(catFilter.name())) continue;
            }
            int fee = glowCareService.startingFee(s, services);
            if (minFee != null && fee < minFee) continue;
            if (maxFee != null && (fee == 0 || fee > maxFee)) continue;
            if (Boolean.TRUE.equals(availableToday) && !glowCareService.availableToday(s)) continue;
            if (!searchQ.isBlank()) {
                boolean textMatch = glowCareService.salonMatchesSearch(s, services, searchQ);
                if (!textMatch) {
                    textMatch = treatmentRepo.findBySalonId(s.getId()).stream()
                            .anyMatch(t -> matchesText(t.getServiceName(), searchQ) || matchesText(t.getDescription(), searchQ));
                }
                if (!textMatch) {
                    textMatch = offerRepo.findBySalonId(s.getId()).stream()
                            .anyMatch(o -> matchesText(o.getTitle(), searchQ) || matchesText(o.getDescription(), searchQ));
                }
                if (!textMatch) continue;
            }
            items.add(salonCard(s, user, services, lat, lng));
        }
        String sortKey = sort == null ? "rating" : sort.trim().toLowerCase(Locale.ROOT);
        items.sort((a, b) -> {
            if ("fee".equals(sortKey) || "price".equals(sortKey)) {
                return Double.compare(asDouble(a.get("startingFee")), asDouble(b.get("startingFee")));
            }
            if ("nearest".equals(sortKey)) {
                return Double.compare(asDouble(a.get("distanceKm")), asDouble(b.get("distanceKm")));
            }
            return Double.compare(asDouble(b.get("rating")), asDouble(a.get("rating")));
        });
        return ResponseEntity.ok(ok(Map.of("salons", items, "count", items.size(), "cancelPolicy", GlowCareService.CANCEL_POLICY)));
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
        List<Service1> serviceEntities = serviceRepo.findBySalonId(id);
        int duration = serviceEntities.stream()
                .map(sv -> sv.getDurationMinutes() == null ? 30 : sv.getDurationMinutes())
                .min(Integer::compareTo).orElse(30);
        List<String> slotsToday = glowCareService.slotsFor(s, LocalDate.now(), duration);
        Map<String, Object> next = glowCareService.nextSlot(s);
        List<Map<String, Object>> reviews = glowCareService.reviewsFor(id).stream()
                .map(glowCareService::reviewDto)
                .toList();

        Map<String, Object> out = new LinkedHashMap<>();
        out.put("success", true);
        out.put("salon", salonCard(s, user, serviceEntities, null, null));
        out.put("services", services);
        out.put("treatments", treatments);
        out.put("offers", offers);
        out.put("stylists", stylists);
        out.put("reviews", reviews);
        out.put("slotsToday", slotsToday);
        out.put("nextSlot", next);
        out.put("noSlotsToday", slotsToday.isEmpty());
        out.put("favorite", glowCareService.isFavorite(user, id));
        out.put("canReview", glowCareService.canReviewSalon(user, s));
        out.put("cancelPolicy", GlowCareService.CANCEL_POLICY);
        return ResponseEntity.ok(out);
    }

    @GetMapping("/salons/{id}/slots")
    public ResponseEntity<Map<String, Object>> salonSlots(
            @PathVariable Long id,
            @RequestParam(required = false) String date,
            @RequestParam(required = false) Integer durationMinutes,
            HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        Salon s = salonRepo.findById(id).orElse(null);
        if (s == null || !s.isApproved()) return badRequest("Salon not found.");
        LocalDate day;
        try {
            day = (date == null || date.isBlank()) ? LocalDate.now() : LocalDate.parse(date);
        } catch (Exception e) {
            return badRequest("Invalid date");
        }
        int dur = durationMinutes == null ? 30 : durationMinutes;
        List<String> slots = glowCareService.slotsFor(s, day, dur);
        Map<String, Object> out = new LinkedHashMap<>();
        out.put("success", true);
        out.put("date", day.toString());
        out.put("slots", slots);
        out.put("open", glowCareService.isOpenOn(s, day));
        out.put("nextSlot", glowCareService.nextSlot(s));
        return ResponseEntity.ok(out);
    }

    @PostMapping("/salons/{id}/reviews")
    @Transactional
    public ResponseEntity<Map<String, Object>> addReview(
            @PathVariable Long id,
            @RequestBody Map<String, Object> body,
            HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        Salon s = salonRepo.findById(id).orElse(null);
        if (s == null || !s.isApproved()) return badRequest("Salon not found.");
        int rating = 5;
        try {
            if (body != null && body.get("rating") != null) rating = Integer.parseInt(body.get("rating").toString());
        } catch (Exception ignored) {}
        String comment = body == null ? "" : str(body.get("comment"));
        try {
            var review = glowCareService.addReview(user, s, rating, comment);
            return ResponseEntity.ok(ok(Map.of("review", glowCareService.reviewDto(review), "message", "Review saved")));
        } catch (org.springframework.web.server.ResponseStatusException ex) {
            return ResponseEntity.status(ex.getStatusCode()).body(Map.of("success", false, "error", ex.getReason()));
        }
    }

    @PostMapping("/salons/{id}/favorite")
    @Transactional
    public ResponseEntity<Map<String, Object>> toggleFavorite(@PathVariable Long id, HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        Salon s = salonRepo.findById(id).orElse(null);
        if (s == null || !s.isApproved()) return badRequest("Salon not found.");
        boolean fav = glowCareService.toggleFavorite(user, id);
        return ResponseEntity.ok(ok(Map.of("favorite", fav, "message", fav ? "Added to favourites" : "Removed from favourites")));
    }

    @GetMapping("/favorites")
    public ResponseEntity<Map<String, Object>> myFavorites(HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        List<Map<String, Object>> items = new ArrayList<>();
        for (var fav : glowCareService.favoritesFor(user)) {
            salonRepo.findById(fav.getSalonId()).ifPresent(s -> {
                if (s.isApproved()) {
                    items.add(salonCard(s, user, serviceRepo.findBySalonId(s.getId()), null, null));
                }
            });
        }
        return ResponseEntity.ok(ok(Map.of("salons", items, "count", items.size())));
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

    @GetMapping("/categories")
    public ResponseEntity<Map<String, Object>> categories(HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();

        List<ServiceCategory> taxonomy = List.of(
                ServiceCategory.HAIR,
                ServiceCategory.SKIN_CARE,
                ServiceCategory.MAKEUP,
                ServiceCategory.NAIL_CARE,
                ServiceCategory.SPA_MASSAGE,
                ServiceCategory.WAXING,
                ServiceCategory.THREADING,
                ServiceCategory.EYE_BROW,
                ServiceCategory.BRIDAL,
                ServiceCategory.MEHENDI,
                ServiceCategory.WELLNESS,
                ServiceCategory.COSMETIC,
                ServiceCategory.PACKAGES,
                ServiceCategory.TRAINING
        );

        List<Service1> approvedServices = serviceRepo.findAll().stream()
                .filter(s -> s.getSalon() != null && s.getSalon().isApproved())
                .toList();

        List<Map<String, Object>> items = taxonomy.stream().map(cat -> {
            Map<String, Object> m = new LinkedHashMap<>();
            m.put("code", cat.name());
            m.put("label", cat.displayLabel());
            long count = approvedServices.stream()
                    .filter(s -> s.getCategory() != null && s.getCategory().normalized() == cat)
                    .count();
            m.put("serviceCount", count);
            return m;
        }).toList();

        return ResponseEntity.ok(ok(Map.of("categories", items, "count", items.size())));
    }

    @GetMapping("/services")
    public ResponseEntity<Map<String, Object>> services(
            @RequestParam(required = false) String category,
            HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();

        ServiceCategory filter = ServiceCategory.fromFlexible(category);
        List<Map<String, Object>> items = serviceRepo.findAll().stream()
                .filter(s -> s.getSalon() != null && s.getSalon().isApproved())
                .filter(s -> {
                    if (filter == null) return true;
                    if (s.getCategory() == null) return false;
                    return s.getCategory().normalized() == filter.normalized();
                })
                .map(this::serviceDto)
                .toList();
        return ResponseEntity.ok(ok(Map.of("services", items, "count", items.size())));
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
        booking.setConsentPolicy(true);
        booking.setCreatedAt(java.time.LocalDateTime.now());
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
        if (!glowCareService.isOpenOn(salon, bookingDate)) {
            return badRequest("Salon is closed on " + bookingDate + ".");
        }
        if (glowCareService.slotTaken(salon, bookingDate, preferredTime, null)) {
            return badRequest("That slot is already booked. Please pick another time.");
        }

        boolean isFree = price <= 0;
        if (isFree) {
            booking.setStatus("CONFIRMED");
        }

        bookingRepo.save(booking);

        Map<String, Object> payload = new LinkedHashMap<>();
        payload.put("message", isFree ? "Booking confirmed." : "Booking created. Complete payment to confirm.");
        payload.put("bookingId", booking.getId());
        payload.put("free", isFree);
        payload.put("paymentRequired", !isFree);
        payload.put("amount", price);
        payload.put("status", booking.getStatus());
        return ResponseEntity.ok(ok(payload));
    }

    @PostMapping("/bookings/{id}/cancel")
    @Transactional
    public ResponseEntity<Map<String, Object>> cancelBooking(@PathVariable Long id, HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        Booking1 b = bookingRepo.findById(id).orElse(null);
        if (b == null || b.getUser() == null || !b.getUser().getId().equals(user.getId())) {
            return badRequest("Booking not found.");
        }
        String status = b.getStatus() == null ? "" : b.getStatus().toUpperCase(Locale.ROOT);
        if (status.equals("COMPLETED") || status.equals("CANCELLED") || status.equals("REJECTED")) {
            return badRequest("This booking cannot be cancelled.");
        }
        if (!glowCareService.canCancelFree(b) && (status.equals("CONFIRMED") || status.equals("PAID"))) {
            return badRequest(GlowCareService.CANCEL_POLICY);
        }
        b.setStatus("CANCELLED");
        bookingRepo.save(b);
        return ResponseEntity.ok(ok(Map.of(
                "message", "Booking cancelled",
                "status", "CANCELLED",
                "cancelPolicy", GlowCareService.CANCEL_POLICY)));
    }

    @PostMapping("/bookings/{id}/reschedule")
    @Transactional
    public ResponseEntity<Map<String, Object>> rescheduleBooking(
            @PathVariable Long id,
            @RequestBody Map<String, Object> body,
            HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();

        Booking1 booking = bookingRepo.findById(id).orElse(null);
        if (booking == null || booking.getUser() == null || !booking.getUser().getId().equals(user.getId())) {
            return badRequest("Booking not found.");
        }
        if (!glowCareService.canReschedule(booking)) {
            return badRequest("This booking cannot be rescheduled.");
        }

        String dateRaw = str(body.get("bookingDate"));
        String timeRaw = str(body.get("preferredTime"));
        if (dateRaw.isBlank() || timeRaw.isBlank()) {
            return badRequest("bookingDate and preferredTime are required.");
        }

        LocalDate bookingDate;
        LocalTime preferredTime;
        try {
            bookingDate = LocalDate.parse(dateRaw);
            preferredTime = LocalTime.parse(timeRaw);
        } catch (Exception e) {
            return badRequest("Invalid bookingDate or preferredTime format.");
        }
        if (bookingDate.isBefore(LocalDate.now())) {
            return badRequest("Cannot reschedule to a past date.");
        }

        Salon salon = booking.getSalon();
        if (salon == null || !salon.isApproved()) {
            return badRequest("Salon not found.");
        }
        if (!glowCareService.isOpenOn(salon, bookingDate)) {
            return badRequest("Salon is closed on " + bookingDate + ".");
        }
        if (glowCareService.slotTaken(salon, bookingDate, preferredTime, booking.getId())) {
            return badRequest("That slot is already booked. Please pick another time.");
        }

        booking.setBookingDate(bookingDate);
        booking.setPreferredTime(preferredTime);
        bookingRepo.save(booking);

        return ResponseEntity.ok(ok(Map.of(
                "message", "Booking rescheduled",
                "booking", bookingDto(booking, user))));
    }

    @GetMapping("/bookings/{id}/confirmation")
    public ResponseEntity<Map<String, Object>> bookingConfirmation(@PathVariable Long id, HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();

        Booking1 booking = bookingRepo.findById(id).orElse(null);
        if (booking == null || booking.getUser() == null || !booking.getUser().getId().equals(user.getId())) {
            return badRequest("Booking not found.");
        }
        return ResponseEntity.ok(ok(Map.of("booking", confirmationDto(booking, user))));
    }

    @GetMapping("/bookings/me")
    public ResponseEntity<Map<String, Object>> myBookings(HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();

        List<Map<String, Object>> items = bookingRepo.findByUser(user).stream()
                .sorted((a, b) -> Long.compare(
                        b.getId() == null ? 0 : b.getId(),
                        a.getId() == null ? 0 : a.getId()))
                .map(b -> bookingDto(b, user))
                .toList();
        return ResponseEntity.ok(ok(Map.of("bookings", items, "count", items.size())));
    }

    private Map<String, Object> salonDto(Salon s) {
        return salonCard(s, null, List.of(), null, null);
    }

    private Map<String, Object> salonCard(Salon s, User user, List<Service1> services, Double lat, Double lng) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", s.getId());
        m.put("name", s.getName());
        m.put("address", s.getAddress());
        m.put("city", s.getCity());
        m.put("state", s.getState());
        m.put("pincode", s.getPincode());
        m.put("phone", s.getPhone());
        m.put("website", s.getWebsite());
        m.put("profileImageUrl", s.getProfileImageUrl());
        m.put("galleryPhotos", s.getGalleryPhotos() == null || s.getGalleryPhotos().isBlank()
                ? List.of()
                : Arrays.stream(s.getGalleryPhotos().split(",")).map(String::trim).filter(v -> !v.isEmpty()).toList());
        m.put("bio", s.getBio());
        m.put("availabilityHours", s.getAvailabilityHours());
        m.put("openDays", s.getOpenDays());
        m.put("openTime", s.getOpenTime() == null ? null : s.getOpenTime().toString());
        m.put("closeTime", s.getCloseTime() == null ? null : s.getCloseTime().toString());
        m.put("rating", s.getRating());
        m.put("ecoFriendly", s.getIsEcoFriendly());
        m.put("certified", s.getIsCertified());
        m.put("hygieneCertified", s.getHygieneCertificateUrl() != null && !s.getHygieneCertificateUrl().isBlank());
        m.put("doorService", Boolean.TRUE.equals(s.getDoorService()));
        m.put("femaleStaff", Boolean.TRUE.equals(s.getFemaleStaff()));
        m.put("audience", s.getAudience());
        m.put("categoriesOffered", s.getCategoriesOffered());
        m.put("facilities", s.getFacilities());
        m.put("latitude", s.getLatitude());
        m.put("longitude", s.getLongitude());
        m.put("startingFee", glowCareService.startingFee(s, services));
        Map<String, Object> next = glowCareService.nextSlot(s);
        m.put("nextSlot", next);
        m.put("availableToday", glowCareService.availableToday(s));
        m.put("slotsTodayCount", glowCareService.slotsFor(s, LocalDate.now(), 30).size());
        m.put("favorite", glowCareService.isFavorite(user, s.getId()));
        m.put("cancelPolicy", GlowCareService.CANCEL_POLICY);
        double distance = 9999;
        if (lat != null && lng != null && s.getLatitude() != null && s.getLongitude() != null) {
            distance = haversineKm(lat, lng, s.getLatitude(), s.getLongitude());
        }
        m.put("distanceKm", Math.round(distance * 10.0) / 10.0);
        return m;
    }

    private Map<String, Object> serviceDto(Service1 s) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", s.getId());
        m.put("name", s.getName());
        ServiceCategory cat = s.getCategory() == null ? null : s.getCategory().normalized();
        m.put("category", cat == null ? null : cat.name());
        m.put("categoryLabel", cat == null ? null : cat.displayLabel());
        m.put("price", s.getPrice());
        m.put("durationMinutes", s.getDurationMinutes());
        m.put("ingredients", s.getIngredients());
        m.put("allergenInfo", s.getAllergenInfo());
        m.put("bufferMinutes", s.getBufferMinutes());
        m.put("serviceMode", s.getServiceMode());
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
        return bookingDto(b, null);
    }

    private Map<String, Object> bookingDto(Booking1 b, User user) {
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
        m.put("paymentRequired", glowCareService.isPaymentPending(b));
        m.put("paymentStatus", paymentStatusLabel(b));
        m.put("canCancel", glowCareService.canCancelFree(b)
                || "PENDING".equalsIgnoreCase(b.getStatus()));
        m.put("canCancelFree", glowCareService.canCancelFree(b));
        m.put("canReschedule", glowCareService.canReschedule(b));
        m.put("canReview", user != null && glowCareService.canReviewBooking(user, b));
        m.put("joinWindowOpen", glowCareService.joinWindowOpen(b));
        m.put("cancelPolicy", GlowCareService.CANCEL_POLICY);
        m.put("coachNotes", b.getCoachNotes());
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

    private Map<String, Object> confirmationDto(Booking1 b, User user) {
        Map<String, Object> m = bookingDto(b, user);
        m.put("bookingId", b.getId());
        m.put("salonName", b.getSalon() == null ? null : b.getSalon().getName());
        m.put("bookingStatus", b.getStatus());
        m.put("amount", b.getPrice());
        m.put("free", b.getPrice() <= 0);
        if (b.getService() != null) {
            m.put("itemName", b.getService().getName());
        } else if (b.getTreatment() != null) {
            m.put("itemName", b.getTreatment().getServiceName());
        } else if (b.getOffer() != null) {
            m.put("itemName", b.getOffer().getTitle());
        }
        return m;
    }

    private static String paymentStatusLabel(Booking1 b) {
        if (b == null) return "UNKNOWN";
        String st = GlowCareService.normBookingStatus(b.getStatus());
        if (b.getPrice() <= 0) return "FREE";
        if ("PENDING".equals(st)) return "PAYMENT_PENDING";
        if ("CONFIRMED".equals(st) || "PAID".equals(st) || "COMPLETED".equals(st)) return "PAID";
        if ("CANCELLED".equals(st) || "REJECTED".equals(st)) return st;
        return st;
    }

    private static boolean matchesText(String value, String needle) {
        if (needle == null || needle.isBlank()) return true;
        return value != null && value.toLowerCase(Locale.ROOT).contains(needle.trim().toLowerCase(Locale.ROOT));
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

    private static double asDouble(Object v) {
        if (v instanceof Number n) return n.doubleValue();
        try { return Double.parseDouble(String.valueOf(v)); } catch (Exception e) { return 0; }
    }

    private static double haversineKm(double lat1, double lon1, double lat2, double lon2) {
        double r = 6371;
        double dLat = Math.toRadians(lat2 - lat1);
        double dLon = Math.toRadians(lon2 - lon1);
        double a = Math.sin(dLat / 2) * Math.sin(dLat / 2)
                + Math.cos(Math.toRadians(lat1)) * Math.cos(Math.toRadians(lat2))
                * Math.sin(dLon / 2) * Math.sin(dLon / 2);
        return r * 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
    }
}
