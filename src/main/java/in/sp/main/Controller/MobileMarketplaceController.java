package in.sp.main.Controller;

import in.sp.main.Entities.*;
import in.sp.main.Repository.*;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;

import java.time.Duration;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/marketplace")
public class MobileMarketplaceController {

    @Autowired
    private ServiceProviderRepository providerRepo;
    @Autowired
    private ProviderBookingRepository bookingRepo;
    @Autowired
    private ProviderReviewRepository reviewRepo;
    @Autowired
    private ProviderClassRepository classRepo;
    @Autowired
    private MarketplaceEnrollmentRepository enrollmentRepo;
    @Autowired
    private JobApplicationRepository jobAppRepo;
    @Autowired
    private WorkerBookingRepository workerBookingRepo;

    @GetMapping("/categories")
    public ResponseEntity<Map<String, Object>> categories(HttpSession session) {
        if (requireUser(session) == null) return unauthorized();
        List<Map<String, Object>> providerCategories = Arrays.stream(ProviderCategory.values())
                .map(c -> Map.<String, Object>of("value", c.name(), "label", toTitle(c.name())))
                .collect(Collectors.toList());
        List<Map<String, Object>> workerCategories = jobAppRepo
                .findDistinctJobCategoriesByStatus(VerificationStatus.VERIFIED)
                .stream()
                .filter(s -> s != null && !s.isBlank())
                .map(s -> Map.<String, Object>of("value", s, "label", s))
                .collect(Collectors.toList());
        return ResponseEntity.ok(ok(Map.of(
                "providerCategories", providerCategories,
                "workerCategories", workerCategories
        )));
    }

    @GetMapping("/providers")
    public ResponseEntity<Map<String, Object>> providers(
            @RequestParam(required = false) String category,
            HttpSession session) {
        if (requireUser(session) == null) return unauthorized();
        List<ServiceProvider> list;
        if (category != null && !category.isBlank()) {
            try {
                ProviderCategory cat = ProviderCategory.valueOf(category.trim().toUpperCase(Locale.ROOT));
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
        User user = requireUser(session);
        if (user == null) return unauthorized();
        ServiceProvider p = providerRepo.findById(id).orElse(null);
        if (p == null || p.getVerificationStatus() != VerificationStatus.VERIFIED) return badRequest("Provider not found");

<<<<<<< HEAD
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
=======
        List<Map<String, Object>> classes = classRepo.findByProvider_Id(id).stream()
                .map(this::classDto)
                .toList();
        List<Map<String, Object>> reviews = reviewRepo.findByProviderIdOrderByCreatedAtDesc(id).stream()
                .map(this::reviewDto)
                .toList();

        return ResponseEntity.ok(ok(Map.of(
                "provider", providerDto(p),
                "classes", classes,
                "reviews", reviews,
                "canReview", !reviewRepo.existsByUserIdAndProviderId(user.getId(), id)
        )));
    }

    @PostMapping("/providers/{id}/bookings")
    @Transactional
    public ResponseEntity<Map<String, Object>> book(
            @PathVariable Long id,
            @RequestBody Map<String, Object> body,
            HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        ServiceProvider p = providerRepo.findById(id).orElse(null);
        if (p == null || p.getVerificationStatus() != VerificationStatus.VERIFIED) return badRequest("Provider not found");

        String requestedTimeRaw = trim(Objects.toString(body.get("requestedTime"), ""));
        LocalDateTime requestedTime = parseRequestedTime(requestedTimeRaw);
        if (requestedTime == null) {
            requestedTime = LocalDateTime.now().plusDays(1);
        }
        if (requestedTime.isBefore(LocalDateTime.now())) return badRequest("Booking time cannot be in the past");
>>>>>>> 8352e3bb110978a162e9806fdb76d26e94301265

        ProviderBooking b = new ProviderBooking();
        b.setUser(user);
        b.setProvider(p);
<<<<<<< HEAD
        b.setRequestedTime(slotTime);
        b.setNote(trim(body != null ? body.get("note") : null));
=======
        b.setRequestedTime(requestedTime);
        b.setNote(trim(Objects.toString(body.get("note"), "")));
>>>>>>> 8352e3bb110978a162e9806fdb76d26e94301265
        b.setStatus(ProviderBookingStatus.PENDING);
        bookingRepo.save(b);
        return ResponseEntity.ok(ok(Map.of("message", "Booking requested", "bookingId", b.getId(),
                "requestedTime", b.getRequestedTime().toString())));
    }

    @GetMapping("/classes/{classId}")
    public ResponseEntity<Map<String, Object>> classDetail(@PathVariable Long classId, HttpSession session) {
        if (requireUser(session) == null) return unauthorized();
        ProviderClass pc = classRepo.findById(classId).orElse(null);
        if (pc == null) return badRequest("Class not found");
        return ResponseEntity.ok(ok(Map.of("classItem", classDto(pc))));
    }

    @PostMapping("/classes/{classId}/enroll")
    @Transactional
    public ResponseEntity<Map<String, Object>> enrollClass(@PathVariable Long classId, HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();

        ProviderClass pc = classRepo.findById(classId).orElse(null);
        if (pc == null || pc.getAvailableSeats() == null || pc.getAvailableSeats() <= 0) {
            return badRequest("Class not available or full");
        }
        if (enrollmentRepo.existsByUser_IdAndProviderClass_Id(user.getId(), classId)) {
            return badRequest("Already enrolled in this class");
        }

        MarketplaceEnrollment enrollment = new MarketplaceEnrollment();
        enrollment.setUser(user);
        enrollment.setProviderClass(pc);
        enrollment.setStatus("ENROLLED");
        double price = pc.getPrice() == null ? 0.0 : pc.getPrice();
        enrollment.setPaymentStatus(price > 0 ? "PENDING" : "PAID");
        enrollment.setEnrollmentTime(LocalDateTime.now());
        if (price <= 0) {
            enrollment.setAmountPaid(0.0);
        }
        enrollmentRepo.save(enrollment);

        pc.setAvailableSeats(pc.getAvailableSeats() - 1);
        classRepo.save(pc);

        return ResponseEntity.ok(ok(Map.of(
                "message", price > 0 ? "Enrollment created. Complete payment to confirm." : "Enrollment confirmed",
                "enrollmentId", enrollment.getId(),
                "paymentRequired", price > 0,
                "amount", price
        )));
    }

    @GetMapping("/enrollments/me")
    public ResponseEntity<Map<String, Object>> myEnrollments(HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        List<Map<String, Object>> items = enrollmentRepo.findByUser_Id(user.getId()).stream()
                .map(this::enrollmentDto)
                .toList();
        return ResponseEntity.ok(ok(Map.of("enrollments", items, "count", items.size())));
    }

    @GetMapping("/bookings/me")
    public ResponseEntity<Map<String, Object>> myBookings(HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();

        List<Map<String, Object>> providerItems = bookingRepo.findByUserOrderByRequestedTimeDesc(user).stream().map(b -> {
            Map<String, Object> m = new LinkedHashMap<>();
            m.put("id", b.getId());
            m.put("kind", "PROVIDER");
            m.put("status", b.getStatus() == null ? null : b.getStatus().name());
            m.put("requestedTime", b.getRequestedTime() == null ? null : b.getRequestedTime().toString());
            m.put("note", b.getNote());
            if (b.getProvider() != null) m.put("provider", providerDto(b.getProvider()));
            return m;
        }).toList();

        List<Map<String, Object>> workerItems = workerBookingRepo.findByClient_Id(user.getId()).stream().map(this::workerBookingDto).toList();

        List<Map<String, Object>> all = new ArrayList<>();
        all.addAll(providerItems);
        all.addAll(workerItems);
        all.sort((a, b) -> Objects.toString(
                        b.getOrDefault("requestedTime", b.getOrDefault("bookingDate", "")))
                .compareTo(Objects.toString(a.getOrDefault("requestedTime", a.getOrDefault("bookingDate", "")))));

        return ResponseEntity.ok(ok(Map.of(
                "bookings", providerItems,
                "workerBookings", workerItems,
                "allBookings", all
        )));
    }

    @PostMapping("/jobs/apply")
    @Transactional
    public ResponseEntity<Map<String, Object>> applyForJob(
            @RequestBody Map<String, Object> body,
            HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        if (body == null) return badRequest("Request body is required");

        String category = trim(Objects.toString(body.get("category"), ""));
        if (category.isBlank()) category = trim(Objects.toString(body.get("jobCategory"), ""));
        String subCategory = trim(Objects.toString(body.get("subCategory"), ""));
        if (subCategory.isBlank()) subCategory = trim(Objects.toString(body.get("jobSubCategory"), ""));
        Double hourlyRate = parseDoubleOrNull(body.get("hourlyRate"));

        if (category.isBlank() || subCategory.isBlank()) {
            return badRequest("category and subCategory are required");
        }
        if (hourlyRate == null || hourlyRate < 0) {
            return badRequest("hourlyRate is required");
        }

        JobApplication application = new JobApplication();
        application.setUser(user);
        application.setJobCategory(category);
        application.setJobSubCategory(subCategory);
        application.setHourlyRate(hourlyRate);
        application.setDocumentPath("mobile-pending");
        application.setStatus(VerificationStatus.PENDING);
        jobAppRepo.save(application);

        Map<String, Object> item = new LinkedHashMap<>();
        item.put("id", application.getId());
        item.put("jobCategory", application.getJobCategory());
        item.put("jobSubCategory", application.getJobSubCategory());
        item.put("hourlyRate", application.getHourlyRate());
        item.put("documentPath", application.getDocumentPath());
        item.put("status", application.getStatus().name());
        item.put("appliedAt", application.getAppliedAt() == null ? null : application.getAppliedAt().toString());

        return ResponseEntity.status(HttpStatus.CREATED).body(ok(Map.of(
                "message", "Job application submitted",
                "application", item
        )));
    }

    @GetMapping("/workers")
    public ResponseEntity<Map<String, Object>> workers(@RequestParam String category, HttpSession session) {
        if (requireUser(session) == null) return unauthorized();
        if (category == null || category.isBlank()) return badRequest("category is required");
        List<Map<String, Object>> items = jobAppRepo.findByJobCategoryAndStatus(category, VerificationStatus.VERIFIED)
                .stream()
                .map(this::workerDto)
                .toList();
        return ResponseEntity.ok(ok(Map.of("workers", items, "count", items.size())));
    }

    @GetMapping("/workers/{id}")
    public ResponseEntity<Map<String, Object>> workerDetail(@PathVariable Long id, HttpSession session) {
        if (requireUser(session) == null) return unauthorized();
        JobApplication app = jobAppRepo.findById(id).orElse(null);
        if (app == null || app.getStatus() != VerificationStatus.VERIFIED) return badRequest("Worker not found");

        List<String> bookedTimes = workerBookingRepo.findByJobApplication_Id(id).stream()
                .filter(b -> !"REJECTED".equalsIgnoreCase(b.getStatus()))
                .map(b -> b.getBookingDate().format(DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm")))
                .toList();

        return ResponseEntity.ok(ok(Map.of(
                "worker", workerDto(app),
                "bookedTimes", bookedTimes
        )));
    }

    @PostMapping("/workers/{id}/book")
    @Transactional
    public ResponseEntity<Map<String, Object>> bookWorker(
            @PathVariable Long id,
            @RequestBody Map<String, Object> body,
            HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();

        JobApplication app = jobAppRepo.findById(id).orElse(null);
        if (app == null || app.getStatus() != VerificationStatus.VERIFIED) return badRequest("Worker not found");
        if (app.getUser() != null && app.getUser().getId().equals(user.getId())) {
            return badRequest("You cannot book your own services");
        }

        String bookingDateRaw = trim(Objects.toString(body.get("bookingDate"), ""));
        LocalDateTime reqTime = parseRequestedTime(bookingDateRaw);
        if (reqTime == null) return badRequest("bookingDate is required in yyyy-MM-dd'T'HH:mm format");
        if (reqTime.isBefore(LocalDateTime.now())) return badRequest("Booking time cannot be in the past");
        if (reqTime.isAfter(LocalDateTime.now().plusDays(2))) return badRequest("Bookings allowed only up to 2 days ahead");

        boolean isBooked = workerBookingRepo.findByJobApplication_Id(id).stream()
                .filter(b -> !"REJECTED".equalsIgnoreCase(b.getStatus()))
                .anyMatch(b -> Duration.between(b.getBookingDate(), reqTime).abs().toMinutes() < 60);
        if (isBooked) return badRequest("This time slot is already booked");

        double amount = parseDouble(body.get("totalAmount"), 0.0);
        WorkerBooking booking = new WorkerBooking();
        booking.setClient(user);
        booking.setJobApplication(app);
        booking.setBookingDate(reqTime);
        booking.setTotalAmount(Math.max(amount, 0.0));
        booking.setNote(trim(Objects.toString(body.get("note"), "")));
        booking.setStatus("PENDING");
        booking.setHours(parseInt(body.get("hours"), null));
        workerBookingRepo.save(booking);

        return ResponseEntity.ok(ok(Map.of(
                "message", "Worker booking request sent",
                "bookingId", booking.getId(),
                "status", booking.getStatus(),
                "amount", booking.getTotalAmount()
        )));
    }

    private Map<String, Object> providerDto(ServiceProvider p) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", p.getId());
        m.put("fullName", p.getFullName());
        m.put("category", p.getCategory() == null ? null : p.getCategory().name());
        m.put("description", p.getDescription());
        m.put("locationText", p.getLocationText() != null && !p.getLocationText().isBlank()
                ? p.getLocationText() : "Location not set");
        m.put("rating", p.getRating() != null ? p.getRating() : 0.0);
        m.put("phone", p.getPhone());
        m.put("email", p.getEmail());
        return m;
    }

    private Map<String, Object> classDto(ProviderClass pc) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", pc.getId());
        m.put("className", pc.getClassName());
        m.put("description", pc.getDescription());
        m.put("duration", pc.getDuration());
        m.put("dateTime", pc.getDateTime() == null ? null : pc.getDateTime().toString());
        m.put("mode", pc.getMode());
        m.put("price", pc.getPrice());
        m.put("availableSeats", pc.getAvailableSeats());
        m.put("meetingLink", pc.getMeetingLink());
        m.put("category", pc.getCategory() == null ? null : pc.getCategory().name());
        if (pc.getProvider() != null) {
            m.put("provider", providerDto(pc.getProvider()));
        }
        return m;
    }

    private Map<String, Object> reviewDto(ProviderReview review) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", review.getId());
        m.put("rating", review.getRating());
        m.put("comment", review.getComment());
        m.put("createdAt", review.getCreatedAt() == null ? null : review.getCreatedAt().toString());
        if (review.getUser() != null) {
            m.put("userName", review.getUser().getFullName());
            m.put("userId", review.getUser().getId());
        }
        return m;
    }

    private Map<String, Object> enrollmentDto(MarketplaceEnrollment e) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", e.getId());
        m.put("status", e.getStatus());
        m.put("paymentStatus", e.getPaymentStatus());
        m.put("enrollmentTime", e.getEnrollmentTime() == null ? null : e.getEnrollmentTime().toString());
        m.put("amountPaid", e.getAmountPaid());
        if (e.getProviderClass() != null) {
            m.put("classItem", classDto(e.getProviderClass()));
        }
        return m;
    }

    private Map<String, Object> workerDto(JobApplication app) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", app.getId());
        m.put("jobCategory", app.getJobCategory());
        m.put("jobSubCategory", app.getJobSubCategory());
        m.put("hourlyRate", app.getHourlyRate());
        m.put("status", app.getStatus() == null ? null : app.getStatus().name());
        if (app.getUser() != null) {
            m.put("workerName", app.getUser().getFullName());
            m.put("workerId", app.getUser().getId());
            m.put("phone", app.getUser().getPhoneNumber());
            m.put("location", app.getUser().getHomeAddress());
        }
        return m;
    }

    private Map<String, Object> workerBookingDto(WorkerBooking b) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", b.getId());
        m.put("kind", "WORKER");
        m.put("status", b.getStatus());
        m.put("bookingDate", b.getBookingDate() == null ? null : b.getBookingDate().toString());
        m.put("note", b.getNote());
        m.put("hours", b.getHours());
        m.put("totalAmount", b.getTotalAmount());
        if (b.getJobApplication() != null) {
            m.put("worker", workerDto(b.getJobApplication()));
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

    private static String trim(String v) {
        return v == null ? "" : v.trim();
    }

    private static String toTitle(String raw) {
        if (raw == null || raw.isBlank()) return "";
        return Arrays.stream(raw.split("_"))
                .filter(s -> !s.isBlank())
                .map(s -> Character.toUpperCase(s.charAt(0)) + s.substring(1).toLowerCase(Locale.ROOT))
                .collect(Collectors.joining(" "));
    }

    private static double parseDouble(Object raw, double fallback) {
        Double parsed = parseDoubleOrNull(raw);
        return parsed == null ? fallback : parsed;
    }

    private static Double parseDoubleOrNull(Object raw) {
        if (raw == null || raw.toString().isBlank()) return null;
        try {
            return Double.parseDouble(raw.toString());
        } catch (Exception ignored) {
            return null;
        }
    }

    private static Integer parseInt(Object raw, Integer fallback) {
        if (raw == null) return fallback;
        try {
            return Integer.parseInt(raw.toString());
        } catch (Exception ignored) {
            return fallback;
        }
    }

    private static LocalDateTime parseRequestedTime(String raw) {
        if (raw == null || raw.isBlank()) return null;
        List<DateTimeFormatter> fmts = List.of(
                DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm"),
                DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"),
                DateTimeFormatter.ISO_LOCAL_DATE_TIME
        );
        for (DateTimeFormatter fmt : fmts) {
            try {
                return LocalDateTime.parse(raw, fmt);
            } catch (Exception ignored) {
            }
        }
        return null;
    }
}
