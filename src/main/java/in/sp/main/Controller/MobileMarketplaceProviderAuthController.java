package in.sp.main.Controller;

import in.sp.main.Config.JwtUtil;
import in.sp.main.Entities.*;
import in.sp.main.Repository.*;
import in.sp.main.Service.PasswordService;
import in.sp.main.Util.MobileValidation;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.LinkedHashMap;
import java.util.Locale;
import java.util.Map;
import java.util.Objects;
import java.util.Optional;

@RestController
@RequestMapping("/api/marketplace/provider")
public class MobileMarketplaceProviderAuthController {

    @Autowired
    private ServiceProviderRepository providerRepo;
    @Autowired
    private ProviderBookingRepository bookingRepo;
    @Autowired
    private ProviderClassRepository classRepo;
    @Autowired
    private MarketplaceEnrollmentRepository enrollmentRepo;
    @Autowired
    private PasswordService passwordService;
    @Autowired
    private JwtUtil jwtUtil;

    @PostMapping("/register")
    public ResponseEntity<Map<String, Object>> register(@RequestBody Map<String, String> body) {
        String fullName = trim(body == null ? null : body.get("fullName"));
        String email = MobileValidation.normalizeEmail(body == null ? null : body.get("email"));
        String phone = trim(body == null ? null : body.get("phone"));
        String password = body == null ? "" : body.getOrDefault("password", "");
        String confirmPassword = body == null ? "" : body.getOrDefault("confirmPassword", "");
        String categoryRaw = trim(body == null ? null : body.get("category"));
        String description = trim(body == null ? null : body.get("description"))
                .replace("₹", "Rs ")
                .replace("\u20B9", "Rs ");
        String locationText = trim(body == null ? null : body.get("locationText"))
                .replace("₹", "Rs ")
                .replace("\u20B9", "Rs ");

        if (fullName.isBlank() || categoryRaw.isBlank()) {
            return badRequest("fullName and category are required");
        }
        String emailErr = MobileValidation.requireEmail(email);
        if (emailErr != null) return badRequest(emailErr);
        String phoneErr = MobileValidation.requirePhone(phone, true);
        if (phoneErr != null) return badRequest(phoneErr);
        String passErr = MobileValidation.requirePassword(password);
        if (passErr != null) return badRequest(passErr);
        String confirmErr = MobileValidation.requireConfirm(password, confirmPassword);
        if (confirmErr != null) return badRequest(confirmErr);
        if (locationText.isBlank()) return badRequest("locationText is required");
        if (providerRepo.findByEmail(email).isPresent()) {
            return ResponseEntity.status(HttpStatus.CONFLICT).body(error("Email already registered"));
        }

        ProviderCategory category = ProviderCategory.fromFlexible(categoryRaw);
        if (category == null) {
            return badRequest("Invalid category: " + categoryRaw
                    + ". Pick a Service Partner category from the app list.");
        }

        ServiceProvider p = new ServiceProvider();
        p.setFullName(fullName);
        p.setEmail(email);
        p.setPhone(phone);
        p.setPassword(passwordService.encode(password));
        p.setCategory(category);
        p.setDescription(description.isBlank() ? null : description);
        p.setLocationText(locationText.isBlank() ? null : locationText);
        p.setIdentityDocumentPath("mobile-pending");
        p.setVerificationStatus(VerificationStatus.PENDING);
        p.setRating(0.0);
        try {
            providerRepo.save(p);
        } catch (Exception ex) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(error("Could not save service partner: " + ex.getMessage()));
        }

        Map<String, Object> res = new LinkedHashMap<>();
        res.put("success", true);
        res.put("message", "Registration submitted. Await admin verification at Marketplace Providers.");
        res.put("providerId", p.getId());
        res.put("status", "PENDING");
        res.put("category", category.name());
        return ResponseEntity.status(HttpStatus.CREATED).body(res);
    }

    @PostMapping("/login")
    public ResponseEntity<Map<String, Object>> login(@RequestBody Map<String, String> body, HttpSession session) {
        String email = trim(body == null ? null : body.get("email")).toLowerCase(Locale.ROOT);
        String password = body == null ? "" : body.getOrDefault("password", "");
        if (email.isBlank() || password.isBlank()) return badRequest("Email and password are required");

        Optional<ServiceProvider> opt = providerRepo.findByEmail(email);
        if (opt.isEmpty()) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(error("Provider not found"));
        }
        ServiceProvider p = opt.get();
        boolean ok = passwordService.matchesAndUpgrade(password, p.getPassword(), hashed -> {
            p.setPassword(hashed);
            providerRepo.save(p);
        });
        if (!ok) return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(error("Invalid password"));
        if (p.getVerificationStatus() != VerificationStatus.VERIFIED) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(error("Your account is pending admin verification"));
        }

        session.setAttribute("loggedProvider", p);
        String token = jwtUtil.generateToken(p.getEmail(), "PROVIDER");
        Map<String, Object> res = new LinkedHashMap<>();
        res.put("success", true);
        res.put("token", token);
        res.put("tokenType", "Bearer");
        res.put("role", "PROVIDER");
        res.put("provider", providerSummary(p));
        return ResponseEntity.ok(res);
    }

    @GetMapping("/me")
    public ResponseEntity<Map<String, Object>> dashboard(HttpSession session) {
        ServiceProvider p = requireProvider(session);
        if (p == null) return unauthorized();
        p = providerRepo.findById(p.getId()).orElse(p);

        var bookings = bookingRepo.findByProviderOrderByRequestedTimeDesc(p).stream().map(b -> {
            Map<String, Object> m = new LinkedHashMap<>();
            m.put("id", b.getId());
            m.put("status", b.getStatus() == null ? null : b.getStatus().name());
            m.put("requestedTime", b.getRequestedTime() == null ? null : b.getRequestedTime().toString());
            m.put("note", b.getNote());
            if (b.getUser() != null) {
                m.put("clientName", b.getUser().getFullName());
                m.put("clientPhone", b.getUser().getPhoneNumber());
            }
            return m;
        }).toList();

        var classes = classRepo.findByProvider_Id(p.getId()).stream().map(this::classDto).toList();
        var enrollments = enrollmentRepo.findByProviderId(p.getId()).stream().map(e -> {
            Map<String, Object> m = new LinkedHashMap<>();
            m.put("id", e.getId());
            m.put("status", e.getStatus());
            m.put("paymentStatus", e.getPaymentStatus());
            m.put("amountPaid", e.getAmountPaid());
            m.put("enrollmentTime", e.getEnrollmentTime() == null ? null : e.getEnrollmentTime().toString());
            if (e.getUser() != null) m.put("userName", e.getUser().getFullName());
            if (e.getProviderClass() != null) {
                m.put("className", e.getProviderClass().getClassName());
                m.put("classId", e.getProviderClass().getId());
            }
            return m;
        }).toList();

        double totalEarnings = enrollmentRepo.findByProviderId(p.getId()).stream()
                .filter(e -> "PAID".equalsIgnoreCase(e.getPaymentStatus()))
                .mapToDouble(e -> e.getAmountPaid() == null ? 0.0 : e.getAmountPaid())
                .sum();

        return ResponseEntity.ok(ok(Map.of(
                "provider", providerSummary(p),
                "bookings", bookings,
                "classes", classes,
                "enrollments", enrollments,
                "totalEarnings", totalEarnings
        )));
    }

    @PostMapping("/bookings/{id}/status")
    @Transactional
    public ResponseEntity<Map<String, Object>> updateBookingStatus(
            @PathVariable Long id,
            @RequestBody Map<String, String> body,
            HttpSession session) {
        ServiceProvider p = requireProvider(session);
        if (p == null) return unauthorized();
        ProviderBooking b = bookingRepo.findById(id).orElse(null);
        if (b == null || b.getProvider() == null || !b.getProvider().getId().equals(p.getId())) {
            return badRequest("Booking not found");
        }
        String statusRaw = trim(body == null ? null : body.get("status")).toUpperCase(Locale.ROOT);
        ProviderBookingStatus status;
        try {
            status = ProviderBookingStatus.valueOf(statusRaw);
        } catch (Exception e) {
            return badRequest("Invalid booking status");
        }
        b.setStatus(status);
        bookingRepo.save(b);
        return ResponseEntity.ok(ok(Map.of("message", "Booking updated", "status", status.name())));
    }

    @PostMapping("/classes")
    @Transactional
    public ResponseEntity<Map<String, Object>> addClass(@RequestBody Map<String, Object> body, HttpSession session) {
        ServiceProvider p = requireProvider(session);
        if (p == null) return unauthorized();

        String className = trim(Objects.toString(body.get("className"), ""));
        String dateTimeRaw = trim(Objects.toString(body.get("dateTime"), ""));
        if (className.isBlank() || dateTimeRaw.isBlank()) {
            return badRequest("className and dateTime are required");
        }

        ProviderClass pc = new ProviderClass();
        pc.setProvider(p);
        pc.setClassName(className);
        pc.setDescription(trim(Objects.toString(body.get("description"), "")));
        pc.setDuration(trim(Objects.toString(body.get("duration"), "")));
        LocalDateTime dt = parseDateTime(dateTimeRaw);
        if (dt == null) return badRequest("Invalid dateTime format");
        pc.setDateTime(dt);
        pc.setMode(trim(Objects.toString(body.get("mode"), "Live")));
        pc.setPrice(parseDouble(body.get("price"), 0.0));
        pc.setAvailableSeats(Math.max(parseInt(body.get("availableSeats"), 0), 0));
        pc.setMeetingLink(trim(Objects.toString(body.get("meetingLink"), "")));
        ProviderCategory cat = p.getCategory();
        String categoryRaw = trim(Objects.toString(body.get("category"), ""));
        if (!categoryRaw.isBlank()) {
            ProviderCategory parsed = ProviderCategory.fromFlexible(categoryRaw);
            if (parsed != null) cat = parsed;
        }
        pc.setCategory(cat);
        classRepo.save(pc);

        return ResponseEntity.status(HttpStatus.CREATED).body(ok(Map.of(
                "message", "Class added",
                "classItem", classDto(pc)
        )));
    }

    private ServiceProvider requireProvider(HttpSession session) {
        Object p = session == null ? null : session.getAttribute("loggedProvider");
        return p instanceof ServiceProvider ? (ServiceProvider) p : null;
    }

    private ResponseEntity<Map<String, Object>> unauthorized() {
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(error("Provider login required"));
    }

    private ResponseEntity<Map<String, Object>> badRequest(String error) {
        return ResponseEntity.badRequest().body(error(error));
    }

    private static Map<String, Object> error(String msg) {
        Map<String, Object> out = new LinkedHashMap<>();
        out.put("success", false);
        out.put("error", msg);
        return out;
    }

    private static Map<String, Object> ok(Map<String, Object> data) {
        Map<String, Object> out = new LinkedHashMap<>();
        out.put("success", true);
        out.putAll(data);
        return out;
    }

    private static String trim(String value) {
        return value == null ? "" : value.trim();
    }

    private static double parseDouble(Object value, double fallback) {
        if (value == null) return fallback;
        try {
            return Double.parseDouble(value.toString());
        } catch (Exception e) {
            return fallback;
        }
    }

    private static int parseInt(Object value, int fallback) {
        if (value == null) return fallback;
        try {
            return Integer.parseInt(value.toString());
        } catch (Exception e) {
            return fallback;
        }
    }

    private static LocalDateTime parseDateTime(String raw) {
        if (raw == null || raw.isBlank()) return null;
        try {
            return LocalDateTime.parse(raw, DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm"));
        } catch (Exception ignored) {
        }
        try {
            return LocalDateTime.parse(raw);
        } catch (Exception ignored) {
        }
        return null;
    }

    private Map<String, Object> providerSummary(ServiceProvider p) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", p.getId());
        m.put("fullName", p.getFullName());
        m.put("email", p.getEmail());
        m.put("phone", p.getPhone());
        m.put("category", p.getCategory() == null ? null : p.getCategory().name());
        m.put("description", p.getDescription());
        m.put("locationText", p.getLocationText());
        m.put("rating", p.getRating());
        m.put("verificationStatus", p.getVerificationStatus() == null ? null : p.getVerificationStatus().name());
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
        return m;
    }
}

