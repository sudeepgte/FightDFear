package in.sp.main.Controller;

import java.time.LocalDateTime;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import in.sp.main.Entities.FinancialEnrollment;
import in.sp.main.Entities.FinancialLiveSession;
import in.sp.main.Entities.FinancialVideo;
import in.sp.main.Entities.FinancialWorkshop;
import in.sp.main.Entities.LoanApplication;
import in.sp.main.Entities.User;
import in.sp.main.Repository.FinancialEnrollmentRepository;
import in.sp.main.Repository.LoanApplicationRepository;
import in.sp.main.Repository.UserRepository;
import in.sp.main.Service.FinancialLiteracyCatalogService;
import jakarta.servlet.http.HttpSession;

@RestController
@RequestMapping("/api/financial-literacy")
public class MobileFinancialLiteracyController {

    @Autowired private FinancialLiteracyCatalogService catalog;
    @Autowired private FinancialEnrollmentRepository enrollmentRepo;
    @Autowired private LoanApplicationRepository loanRepo;
    @Autowired private UserRepository userRepository;
    @Autowired private in.sp.main.Service.FinancialLiteracyCareService careService;

    @GetMapping
    public ResponseEntity<Map<String, Object>> home(
            @RequestParam(required = false) String category,
            @RequestParam(required = false) String city,
            @RequestParam(required = false) String sort,
            HttpSession session) {
        if (requireUser(session) == null) return unauthorized();
        String cat = category == null ? "" : category.trim().toLowerCase();
        String cityQ = city == null ? "" : city.trim().toLowerCase();
        java.util.function.Predicate<Map<String, Object>> match = m -> {
            String c = String.valueOf(m.getOrDefault("category", "")).toLowerCase();
            String hostCity = String.valueOf(m.getOrDefault("city", "")).toLowerCase();
            if (!cat.isBlank() && !c.contains(cat)) return false;
            if (!cityQ.isBlank() && !hostCity.contains(cityQ)) return false;
            return true;
        };
        List<Map<String, Object>> videos = catalog.publicVideos().stream().filter(match).collect(java.util.stream.Collectors.toList());
        List<Map<String, Object>> live = catalog.publicLiveSessions().stream().filter(match).collect(java.util.stream.Collectors.toList());
        List<Map<String, Object>> workshops = catalog.publicWorkshops().stream().filter(match).collect(java.util.stream.Collectors.toList());
        java.util.Comparator<Map<String, Object>> cmp;
        String sortKey = sort == null ? "newest" : sort.trim().toLowerCase();
        if ("fee".equals(sortKey) || "price".equals(sortKey)) {
            cmp = java.util.Comparator.comparingDouble(m -> m.get("fee") instanceof Number n ? n.doubleValue() : 0);
        } else if ("rating".equals(sortKey)) {
            cmp = java.util.Comparator.<Map<String, Object>>comparingDouble(m -> m.get("rating") instanceof Number n ? n.doubleValue() : 0).reversed();
        } else {
            cmp = (a, b) -> 0;
        }
        if (!"newest".equals(sortKey)) {
            videos.sort(cmp);
            live.sort(cmp);
            workshops.sort(cmp);
        }
        Map<String, Object> data = new LinkedHashMap<>();
        data.put("videos", videos);
        data.put("liveSessions", live);
        data.put("workshops", workshops);
        data.put("categories", List.of("Saving", "Investing", "Loans", "Banking", "Insurance", "Government Schemes"));
        data.put("cancelPolicy", in.sp.main.Service.FinancialLiteracyCareService.CANCEL_POLICY);
        return ok(data);
    }

    @GetMapping("/videos/{id}")
    public ResponseEntity<Map<String, Object>> video(@PathVariable Long id, HttpSession session) {
        if (requireUser(session) == null) return unauthorized();
        FinancialVideo v = catalog.findVideo(String.valueOf(id));
        if (!catalog.isPublicVideo(v)) return notFound("Video not found");
        return ok(Map.of("video", catalog.videoMap(v, true)));
    }

    @GetMapping("/live-sessions/{id}")
    public ResponseEntity<Map<String, Object>> live(@PathVariable Long id, HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        FinancialLiveSession s = catalog.findLive(String.valueOf(id));
        if (!catalog.isPublicLive(s)) return notFound("Live session not found");
        Map<String, Object> data = new LinkedHashMap<>();
        data.put("session", catalog.liveMap(s));
        enrollmentRepo.findByLiveSession_IdOrderByCreatedAtDesc(id).stream()
                .filter(e -> e.getUser() != null && e.getUser().getId().equals(user.getId())
                        && !"cancelled".equalsIgnoreCase(e.getStatus()))
                .findFirst()
                .ifPresent(e -> data.put("registration", catalog.enrollmentMap(e)));
        return ok(data);
    }

    @GetMapping("/workshops/{id}")
    public ResponseEntity<Map<String, Object>> workshop(@PathVariable Long id, HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        FinancialWorkshop w = catalog.findWorkshop(String.valueOf(id));
        if (!catalog.isPublicWorkshop(w)) return notFound("Workshop not found");
        Map<String, Object> data = new LinkedHashMap<>();
        data.put("workshop", catalog.workshopMap(w));
        enrollmentRepo.findByWorkshop_IdOrderByCreatedAtDesc(id).stream()
                .filter(e -> e.getUser() != null && e.getUser().getId().equals(user.getId())
                        && !"cancelled".equalsIgnoreCase(e.getStatus()))
                .findFirst()
                .ifPresent(e -> data.put("registration", catalog.enrollmentMap(e)));
        return ok(data);
    }

    @PostMapping("/live-sessions/{id}/register")
    public ResponseEntity<Map<String, Object>> registerLive(@PathVariable Long id, HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        try {
            FinancialEnrollment e = catalog.registerLive(String.valueOf(id), user,
                    user.getFullName(), user.getPhoneNumber(), user.getEmail(), null);
                Map<String, Object> data = new LinkedHashMap<>();
            data.put("message", e.getAmount() != null && e.getAmount() > 0
                    ? "Registered. Pay to confirm your seat."
                    : "Registered. Waiting for confirmation.");
            data.put("registration", catalog.enrollmentMap(e));
            data.put("paymentRequired", e.getAmount() != null && e.getAmount() > 0);
            data.put("amount", e.getAmount());
            data.put("cancelPolicy", in.sp.main.Service.FinancialLiteracyCareService.CANCEL_POLICY);
            return ok(data);
        } catch (org.springframework.web.server.ResponseStatusException ex) {
            return ResponseEntity.status(ex.getStatusCode()).body(error(ex.getReason()));
        }
    }

    @PostMapping("/workshops/{id}/register")
    public ResponseEntity<Map<String, Object>> registerWorkshop(@PathVariable Long id, HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        try {
            FinancialEnrollment e = catalog.registerWorkshop(String.valueOf(id), user,
                    user.getFullName(), user.getPhoneNumber(), user.getEmail(), null, null);
            Map<String, Object> data = new LinkedHashMap<>();
            data.put("message", e.getAmount() != null && e.getAmount() > 0
                    ? "Registered. Pay to confirm your seat."
                    : "Registered. Waiting for confirmation.");
            data.put("registration", catalog.enrollmentMap(e));
            data.put("paymentRequired", e.getAmount() != null && e.getAmount() > 0);
            data.put("amount", e.getAmount());
            data.put("cancelPolicy", in.sp.main.Service.FinancialLiteracyCareService.CANCEL_POLICY);
            return ok(data);
        } catch (org.springframework.web.server.ResponseStatusException ex) {
            return ResponseEntity.status(ex.getStatusCode()).body(error(ex.getReason()));
        }
    }

    @PostMapping("/enrollments/{id}/cancel")
    public ResponseEntity<Map<String, Object>> cancel(@PathVariable Long id, HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        try {
            FinancialEnrollment e = catalog.cancel(id, user);
            return ok(Map.of("message", "Registration cancelled", "registration", catalog.enrollmentMap(e)));
        } catch (org.springframework.web.server.ResponseStatusException ex) {
            return ResponseEntity.status(ex.getStatusCode()).body(error(ex.getReason()));
        }
    }

    @GetMapping("/my-enrollments")
    public ResponseEntity<Map<String, Object>> myEnrollments(HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        List<Map<String, Object>> items = enrollmentRepo.findByUser_IdOrderByCreatedAtDesc(user.getId())
                .stream().map(catalog::enrollmentMap).toList();
        return ok(Map.of("enrollments", items, "cancelPolicy", in.sp.main.Service.FinancialLiteracyCareService.CANCEL_POLICY));
    }

    @PostMapping("/enrollments/{id}/rate")
    public ResponseEntity<Map<String, Object>> rate(
            @PathVariable Long id, @RequestBody Map<String, Object> body, HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        FinancialEnrollment e = enrollmentRepo.findById(id).orElse(null);
        if (e == null || e.getUser() == null || !e.getUser().getId().equals(user.getId())) {
            return badRequest("Registration not found");
        }
        int rating = body.get("rating") instanceof Number n ? n.intValue() : 5;
        String review = body.get("review") == null ? "" : String.valueOf(body.get("review"));
        try {
            careService.rate(e, rating, review);
            return ok(Map.of("message", "Thanks for the review", "registration", catalog.enrollmentMap(e)));
        } catch (org.springframework.web.server.ResponseStatusException ex) {
            return ResponseEntity.status(ex.getStatusCode()).body(error(ex.getReason()));
        }
    }

    @GetMapping("/loans")
    public ResponseEntity<Map<String, Object>> loans(HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        List<Map<String, Object>> items = loanRepo.findByUserOrderBySubmittedAtDesc(user).stream().map(this::loanMap).toList();
        return ok(Map.of("loans", items, "loanTypes", List.of("Personal", "Education", "Business", "Home", "Gold")));
    }

    @PostMapping("/loans")
    public ResponseEntity<Map<String, Object>> applyLoan(@RequestBody Map<String, Object> body, HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        String fullName = str(body, "fullName");
        String email = str(body, "email");
        String loanType = str(body, "loanType");
        Double amount = body.get("loanAmount") instanceof Number n ? n.doubleValue() : null;
        if (fullName.isBlank()) fullName = user.getFullName() == null ? "" : user.getFullName();
        if (email.isBlank()) email = user.getEmail() == null ? "" : user.getEmail();
        if (fullName.isBlank() || email.isBlank() || loanType.isBlank() || amount == null || amount <= 0) {
            return badRequest("Name, email, loan type and a valid amount are required");
        }
        LoanApplication app = new LoanApplication();
        app.setUser(user);
        app.setFullName(fullName.trim());
        app.setEmail(email.trim());
        app.setPhoneNumber(nz(str(body, "phoneNumber"), user.getPhoneNumber()));
        app.setAddress(str(body, "address"));
        app.setAadhaarNumber(str(body, "aadhaarNumber"));
        app.setPanNumber(str(body, "panNumber"));
        app.setLoanType(loanType.trim());
        app.setOccupation(str(body, "occupation"));
        if (body.get("annualIncome") instanceof Number n) app.setAnnualIncome(n.doubleValue());
        app.setLoanAmount(amount);
        app.setPurpose(str(body, "purpose"));
        app.setStatus("SUBMITTED");
        app.setSubmittedAt(LocalDateTime.now());
        loanRepo.save(app);
        return ok(Map.of("message", "Loan application submitted", "loan", loanMap(app)));
    }

    private Map<String, Object> loanMap(LoanApplication a) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", a.getId());
        m.put("loanType", a.getLoanType());
        m.put("loanAmount", a.getLoanAmount());
        m.put("status", a.getStatus());
        m.put("purpose", a.getPurpose());
        m.put("submittedAt", a.getSubmittedAt() == null ? null : a.getSubmittedAt().toString());
        return m;
    }

    private User requireUser(HttpSession session) {
        Object u = session == null ? null : session.getAttribute("user");
        if (!(u instanceof User user)) return null;
        return userRepository.findById(user.getId()).orElse(user);
    }

    private static String str(Map<String, Object> body, String key) {
        if (body == null || body.get(key) == null) return "";
        return String.valueOf(body.get(key)).trim();
    }

    private static String nz(String a, String b) {
        return a == null || a.isBlank() ? b : a;
    }

    private ResponseEntity<Map<String, Object>> unauthorized() {
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(error("Login required"));
    }

    private ResponseEntity<Map<String, Object>> notFound(String msg) {
        return ResponseEntity.status(HttpStatus.NOT_FOUND).body(error(msg));
    }

    private ResponseEntity<Map<String, Object>> badRequest(String msg) {
        return ResponseEntity.badRequest().body(error(msg));
    }

    private static Map<String, Object> error(String msg) {
        return Map.of("success", false, "error", msg == null ? "Request failed" : msg);
    }

    private static ResponseEntity<Map<String, Object>> ok(Map<String, Object> data) {
        Map<String, Object> out = new LinkedHashMap<>();
        out.put("success", true);
        out.putAll(data);
        return ResponseEntity.ok(out);
    }
}
