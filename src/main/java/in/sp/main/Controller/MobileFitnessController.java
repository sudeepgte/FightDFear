package in.sp.main.Controller;

import in.sp.main.Entities.*;
import in.sp.main.Util.FitnessCategories;
import in.sp.main.Repository.*;
import in.sp.main.Service.FitnessCareService;
import in.sp.main.Service.FitnessTrainerProfileService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

@RestController
@RequestMapping("/api/fitness")
public class MobileFitnessController {

    @Autowired
    private FitnessTrainerRepository trainerRepo;
    @Autowired
    private FitnessBookingRepository bookingRepo;
    @Autowired
    private FitnessReviewRepository reviewRepo;
    @Autowired
    private FitnessCareService fitnessCareService;
    @Autowired
    private in.sp.main.Service.FitnessService fitnessService;
    @Autowired
    private in.sp.main.Repository.FitnessPackageRepository fitnessPackageRepo;
    @Autowired
    private in.sp.main.Repository.UserRepository userRepo;


    @GetMapping("/categories")
    public ResponseEntity<Map<String, Object>> categories() {
        return ResponseEntity.ok(ok(Map.of(
                "categories", FitnessCategories.asList(),
                "browseFilters", FitnessCategories.BROWSE_FILTERS
        )));
    }

    @GetMapping("/trainers")
    public ResponseEntity<Map<String, Object>> trainers(
            @RequestParam(required = false) String city,
            @RequestParam(required = false) String sort,
            HttpSession session) {
        if (requireUser(session) == null) return unauthorized();
        String cityQ = city == null ? "" : city.trim().toLowerCase(Locale.ROOT);
        List<FitnessTrainer> trainers = trainerRepo.findAll().stream()
                .filter(FitnessTrainerProfileService::isApproved)
                .filter(t -> cityQ.isBlank() || (t.getCity() != null
                        && t.getCity().toLowerCase(Locale.ROOT).contains(cityQ)))
                .toList();
        List<FitnessTrainer> sorted = new java.util.ArrayList<>(trainers);
        String s = sort == null ? "rating" : sort.trim().toLowerCase(Locale.ROOT);
        sorted.sort((a, b) -> {
            return switch (s) {
                case "price_low" -> Double.compare(
                        a.getSessionFees() == null ? 0 : a.getSessionFees(),
                        b.getSessionFees() == null ? 0 : b.getSessionFees());
                case "price_high" -> Double.compare(
                        b.getSessionFees() == null ? 0 : b.getSessionFees(),
                        a.getSessionFees() == null ? 0 : a.getSessionFees());
                case "experience" -> Integer.compare(
                        b.getExperience() == null ? 0 : b.getExperience(),
                        a.getExperience() == null ? 0 : a.getExperience());
                default -> Double.compare(
                        b.getRating() == null ? 0 : b.getRating(),
                        a.getRating() == null ? 0 : a.getRating());
            };
        });
        List<Map<String, Object>> items = sorted.stream().map(this::trainerDto).toList();
        return ResponseEntity.ok(ok(Map.of("trainers", items, "count", items.size())));
    }

    @GetMapping("/trainers/{id}")
    public ResponseEntity<Map<String, Object>> trainerDetail(@PathVariable Long id, HttpSession session) {
        if (requireUser(session) == null) return unauthorized();
        FitnessTrainer t = trainerRepo.findById(id).orElse(null);
        if (t == null || !FitnessTrainerProfileService.isApproved(t)) {
            return badRequest("Trainer not found");
        }
        Map<String, Object> dto = trainerDto(t);
        dto.put("bio", t.getBio());
        dto.put("serviceType", t.getServiceType());
        dto.put("city", t.getCity());
        dto.put("onlineAvailable", t.isOnlineAvailable());
        dto.put("packages", packageOptions(t.getSessionFees()));
        dto.put("timeSlots", defaultTimeSlots());
        return ResponseEntity.ok(ok(Map.of("trainer", dto)));
    }

    @PostMapping("/trainers/{id}/bookings")
    @Transactional
    public ResponseEntity<Map<String, Object>> book(@PathVariable Long id, @RequestBody Map<String, String> body, HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        FitnessTrainer t = trainerRepo.findById(id).orElse(null);
        if (t == null || !FitnessTrainerProfileService.isApproved(t)) {
            return badRequest("Trainer not found");
        }
        if (!t.isOnlineAvailable()) {
            return badRequest("Trainer is currently unavailable for new bookings");
        }

        String category = trim(body == null ? null : body.get("category"));
        if (category.isBlank()) {
            category = firstSpecialization(t.getSpecializations());
        }
        String sessionType = trim(body == null ? null : body.get("sessionType")).toUpperCase(Locale.ROOT);
        if (sessionType.isBlank()) sessionType = "ONLINE";
        String duration = trim(body == null ? null : body.get("duration")).toUpperCase(Locale.ROOT);
        if (duration.isBlank()) duration = "SINGLE";

        LocalDate bookingDate;
        try {
            String dateRaw = trim(body == null ? null : body.get("bookingDate"));
            bookingDate = dateRaw.isBlank() ? LocalDate.now().plusDays(1) : LocalDate.parse(dateRaw);
        } catch (Exception e) {
            return badRequest("Invalid bookingDate");
        }
        if (bookingDate.isBefore(LocalDate.now())) {
            return badRequest("Booking date must be today or later");
        }

        String bookingTime = trim(body == null ? null : body.get("bookingTime"));
        if (bookingTime.isBlank()) bookingTime = "10:00 - 11:00";

        double baseFees = t.getSessionFees() == null ? 0.0 : Math.max(0, t.getSessionFees());
        PackagePricing pricing = resolvePackagePricing(baseFees, duration);

        FitnessBooking b = new FitnessBooking();
        b.setUser(user);
        b.setTrainer(t);
        b.setCategory(category);
        b.setBookingDate(bookingDate);
        b.setStartDate(bookingDate);
        b.setEndDate(pricing.endDate(bookingDate));
        b.setBookingTime(bookingTime);
        b.setSessionType(sessionType);
        b.setStatus("PENDING");
        b.setPaymentStatus("PENDING");
        b.setPaymentAmount(pricing.fees());
        b.setDuration(duration);
        b.setTotalSessions(pricing.totalSessions());
        b.setCompletedSessions(0);
        bookingRepo.save(b);
        fitnessCareService.notifyBooked(b);

        double fee = pricing.fees();
        if (fee <= 0) {
            b.setPaymentStatus("NOT_REQUIRED");
            bookingRepo.save(b);
        }

        Map<String, Object> data = new LinkedHashMap<>();
        data.put("message", "Booking requested. Complete payment if required; trainer will confirm your session.");
        data.put("bookingId", b.getId());
        data.put("amount", fee);
        data.put("paymentRequired", fee > 0);
        data.put("paymentStatus", b.getPaymentStatus());
        data.put("status", b.getStatus());
        data.put("duration", duration);
        data.put("totalSessions", b.getTotalSessions());
        data.put("bookingDate", b.getBookingDate().toString());
        data.put("bookingTime", b.getBookingTime());
        data.put("sessionType", b.getSessionType());
        data.put("category", b.getCategory());
        return ResponseEntity.ok(ok(data));
    }

    @GetMapping("/bookings/me")
    public ResponseEntity<Map<String, Object>> myBookings(HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        List<Map<String, Object>> items = bookingRepo.findByUser_Id(user.getId()).stream().map(b -> {
            Map<String, Object> m = new LinkedHashMap<>();
            m.put("id", b.getId());
            m.put("status", b.getStatus());
            m.put("bookingDate", b.getBookingDate() == null ? null : b.getBookingDate().toString());
            m.put("bookingTime", b.getBookingTime());
            m.put("sessionType", b.getSessionType());
            m.put("category", b.getCategory());
            m.put("duration", b.getDuration());
            m.put("totalSessions", b.getTotalSessions());
            m.put("completedSessions", b.getCompletedSessions());
            m.put("paymentStatus", b.getPaymentStatus());
            m.put("paymentAmount", b.getPaymentAmount());
            double amt = b.getPaymentAmount() == null ? 0 : Math.max(0, b.getPaymentAmount());
            m.put("amount", amt);
            m.put("paymentRequired", amt > 0 && !"PAID".equalsIgnoreCase(b.getPaymentStatus()));
            m.put("canReview", "COMPLETED".equalsIgnoreCase(b.getStatus())
                    && !reviewRepo.existsByBooking_Id(b.getId()));
            m.put("canCancel", fitnessCareService.canCancel(b));
            m.put("cancelPolicy", FitnessCareService.CANCEL_POLICY);
            if (b.getTrainer() != null) m.put("trainer", trainerDto(b.getTrainer()));
            return m;
        }).toList();
        return ResponseEntity.ok(ok(Map.of("bookings", items, "cancelPolicy", FitnessCareService.CANCEL_POLICY)));
    }

    @PostMapping("/bookings/{id}/cancel")
    @Transactional
    public ResponseEntity<Map<String, Object>> cancel(@PathVariable Long id, HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        FitnessBooking booking = bookingRepo.findById(id).orElse(null);
        if (booking == null || booking.getUser() == null || !booking.getUser().getId().equals(user.getId())) {
            return badRequest("Booking not found");
        }
        try {
            fitnessCareService.cancel(booking);
            Map<String, Object> res = new LinkedHashMap<>();
            res.put("success", true);
            res.put("message", "Booking cancelled");
            res.put("status", "CANCELLED");
            return ResponseEntity.ok(res);
        } catch (org.springframework.web.server.ResponseStatusException ex) {
            return ResponseEntity.status(ex.getStatusCode()).body(Map.of("success", false, "error", ex.getReason()));
        }
    }

    @PostMapping("/bookings/{id}/review")
    @Transactional
    public ResponseEntity<Map<String, Object>> submitReview(
            @PathVariable Long id,
            @RequestBody Map<String, Object> body,
            HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        FitnessBooking booking = bookingRepo.findById(id).orElse(null);
        if (booking == null || booking.getUser() == null || !booking.getUser().getId().equals(user.getId())) {
            return badRequest("Booking not found");
        }
        if (!"COMPLETED".equalsIgnoreCase(booking.getStatus())) {
            return badRequest("You can review only after the session is completed");
        }
        if (reviewRepo.existsByBooking_Id(id)) {
            return badRequest("Review already submitted");
        }
        int rating;
        try {
            rating = Integer.parseInt(String.valueOf(body.get("rating")).trim());
        } catch (Exception e) {
            return badRequest("Rating is required (1-5)");
        }
        if (rating < 1 || rating > 5) return badRequest("Rating must be between 1 and 5");
        String comment = trim(body == null ? null : String.valueOf(body.get("comment")));

        FitnessReview review = new FitnessReview();
        review.setBooking(booking);
        review.setRating(rating);
        review.setComment(comment.isBlank() ? null : comment);
        reviewRepo.save(review);

        FitnessTrainer trainer = booking.getTrainer();
        if (trainer != null) {
            var reviews = reviewRepo.findByBooking_Trainer_Id(trainer.getId());
            double avg = reviews.stream().mapToInt(FitnessReview::getRating).average().orElse(rating);
            trainer.setRating(Math.round(avg * 10.0) / 10.0);
            trainer.setReviewCount(reviews.size());
            trainerRepo.save(trainer);
        }

        Map<String, Object> res = new LinkedHashMap<>();
        res.put("success", true);
        res.put("message", "Thank you for your review");
        return ResponseEntity.ok(res);
    }

    @GetMapping("/trainers/{id}/packages")
    public ResponseEntity<Map<String, Object>> getTrainerPackages(@PathVariable Long id) {
        List<FitnessPackage> packages = fitnessPackageRepo.findByTrainer_IdAndActiveTrue(id);
        List<Map<String, Object>> dtos = packages.stream().map(p -> {
            Map<String, Object> m = new LinkedHashMap<>();
            m.put("id", p.getId());
            m.put("packageName", p.getPackageName());
            m.put("category", p.getCategory());
            m.put("description", p.getDescription());
            m.put("sessionCount", p.getSessionCount());
            m.put("durationDays", p.getDurationDays());
            m.put("price", p.getPrice());
            m.put("sessionType", p.getSessionType());
            m.put("active", p.isActive());
            return m;
        }).toList();
        Map<String, Object> res = new LinkedHashMap<>();
        res.put("success", true);
        res.put("packages", dtos);
        return ResponseEntity.ok(res);
    }

    @PostMapping("/book-package")
    @Transactional
    public ResponseEntity<Map<String, Object>> bookPackage(
            @RequestBody Map<String, Object> body,
            HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();

        Long packageId;
        try {
            packageId = Long.parseLong(String.valueOf(body.get("packageId")).trim());
        } catch (Exception e) {
            return badRequest("Valid packageId is required");
        }

        FitnessPackage pkg = fitnessPackageRepo.findById(packageId).orElse(null);
        if (pkg == null || !pkg.isActive()) {
            return badRequest("Package is unavailable");
        }

        Double walletBalance = user.getWalletBalance() != null ? user.getWalletBalance() : 0.0;
        user.setWalletBalance(walletBalance - pkg.getPrice());
        userRepo.save(user);
        session.setAttribute("user", user);

        FitnessBooking booking = new FitnessBooking();
        booking.setUser(user);
        booking.setTrainer(pkg.getTrainer());
        booking.setFitnessPackage(pkg);
        booking.setCategory(pkg.getCategory());
        booking.setBookingDate(LocalDate.now());
        booking.setBookingTime("Package Membership");
        booking.setSessionType(pkg.getSessionType());
        booking.setStatus("APPROVED");
        booking.setPaymentAmount(pkg.getPrice());
        booking.setPaymentStatus("PAID");
        booking.setTotalSessions(pkg.getSessionCount());
        booking.setRemainingSessions(pkg.getSessionCount());
        booking.setCompletedSessions(0);
        booking.setStartDate(LocalDate.now());
        booking.setValidUntil(LocalDate.now().plusDays(pkg.getDurationDays()));
        booking.setEndDate(LocalDate.now().plusDays(pkg.getDurationDays()));

        bookingRepo.save(booking);

        Map<String, Object> res = new LinkedHashMap<>();
        res.put("success", true);
        res.put("message", "Subscribed to " + pkg.getPackageName());
        res.put("bookingId", booking.getId());
        res.put("totalSessions", booking.getTotalSessions());
        res.put("validUntil", booking.getValidUntil().toString());
        return ResponseEntity.ok(res);
    }

    @GetMapping("/my-progress")
    public ResponseEntity<Map<String, Object>> getMyProgress(HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        Map<String, Object> summary = fitnessService.getUserFitnessProgressSummary(user.getId());
        Map<String, Object> res = new LinkedHashMap<>();
        res.put("success", true);
        res.putAll(summary);
        return ResponseEntity.ok(res);
    }

    private Map<String, Object> trainerDto(FitnessTrainer t) {

        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", t.getId());
        m.put("fullName", t.getFullName());
        m.put("specializations", t.getSpecializations());
        m.put("sessionFees", t.getSessionFees());
        m.put("rating", t.getRating() != null ? t.getRating() : 0.0);
        m.put("profilePhotoPath", t.getProfilePhotoPath());
        m.put("availableTimings", t.getAvailableTimings());
        m.put("experienceYears", t.getExperience());
        m.put("phone", t.getPhone());
        m.put("email", t.getEmail());
        m.put("city", t.getCity());
        m.put("bio", t.getBio());
        m.put("serviceType", t.getServiceType());
        m.put("onlineAvailable", t.isOnlineAvailable());
        m.put("reviewCount", t.getReviewCount());
        m.put("designation", t.getDesignation());
        m.put("sessionMode", t.getSessionMode());
        m.put("typicalPrice", t.getTypicalPrice() != null ? t.getTypicalPrice() : t.getSessionFees());
        FitnessTrainerProfileService.putExtra(m, t);
        return m;
    }

    private static List<Map<String, Object>> packageOptions(Double baseFees) {
        double base = baseFees == null ? 0 : Math.max(0, baseFees);
        return List.of(
                packageRow("SINGLE", "Single session", 1, base),
                packageRow("MONTHLY", "Monthly (12 sessions)", 12, base * 10),
                packageRow("QUARTERLY", "Quarterly (36 sessions)", 36, base * 25),
                packageRow("HALF_YEAR", "6 months (72 sessions)", 72, base * 45),
                packageRow("YEAR", "1 year (144 sessions)", 144, base * 80)
        );
    }

    private static Map<String, Object> packageRow(String id, String label, int sessions, double fees) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", id);
        m.put("label", label);
        m.put("totalSessions", sessions);
        m.put("fees", fees);
        return m;
    }

    private static List<String> defaultTimeSlots() {
        return List.of(
                "06:00 - 08:00",
                "08:00 - 10:00",
                "10:00 - 12:00",
                "12:00 - 14:00",
                "14:00 - 16:00",
                "16:00 - 18:00",
                "18:00 - 20:00",
                "20:00 - 21:00"
        );
    }

    private static String firstSpecialization(String raw) {
        if (raw == null || raw.isBlank()) return "General Fitness";
        String[] parts = raw.split(",");
        return parts[0].trim().isBlank() ? "General Fitness" : parts[0].trim();
    }

    private static PackagePricing resolvePackagePricing(double baseFees, String duration) {
        return switch (duration) {
            case "MONTHLY" -> new PackagePricing(baseFees * 10, 12, 1);
            case "QUARTERLY" -> new PackagePricing(baseFees * 25, 36, 3);
            case "HALF_YEAR" -> new PackagePricing(baseFees * 45, 72, 6);
            case "YEAR" -> new PackagePricing(baseFees * 80, 144, 12);
            default -> new PackagePricing(baseFees, 1, 0);
        };
    }

    private record PackagePricing(double fees, int totalSessions, int monthsToAdd) {
        LocalDate endDate(LocalDate start) {
            if (monthsToAdd <= 0) return start;
            if (monthsToAdd == 12) return start.plusYears(1);
            return start.plusMonths(monthsToAdd);
        }
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
