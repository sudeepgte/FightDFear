package in.sp.main.Controller;

import in.sp.main.Config.JwtUtil;
import in.sp.main.Entities.*;
import in.sp.main.Repository.BusinessProposalRepository;
import in.sp.main.Repository.EntrepreneurRepository;
import in.sp.main.Service.PasswordService;
import in.sp.main.Util.MobileValidation;
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
import java.util.Objects;
import java.util.Optional;

@RestController
@RequestMapping("/api/entrepreneur")
public class MobileEntrepreneurAuthController {

    @Autowired
    private EntrepreneurRepository entrepreneurRepository;
    @Autowired
    private BusinessProposalRepository businessProposalRepository;
    @Autowired
    private PasswordService passwordService;
    @Autowired
    private JwtUtil jwtUtil;

    @PostMapping("/register")
    @Transactional
    public ResponseEntity<Map<String, Object>> register(@RequestBody Map<String, Object> body) {
        String fullName = trim(str(body, "fullName"));
        String email = MobileValidation.normalizeEmail(str(body, "email"));
        String phone = trim(str(body, "phone"));
        String password = str(body, "password");
        String confirmPassword = str(body, "confirmPassword");
        String businessName = trim(str(body, "businessName"));
        String businessCategory = trim(str(body, "businessCategory"));
        String businessLocation = trim(str(body, "businessLocation"));
        String businessDescription = sanitize(trim(str(body, "businessDescription")));
        Double investmentNeeded = parseDouble(body == null ? null : body.get("investmentNeeded"), null);
        if (investmentNeeded == null) {
            investmentNeeded = parseDouble(body == null ? null : body.get("fundingRequirement"), null);
        }
        Double expectedMonthlyIncome = parseDouble(body == null ? null : body.get("expectedMonthlyIncome"), null);
        Integer businessExperience = parseInt(body == null ? null : body.get("businessExperience"), null);
        if (businessExperience == null) {
            businessExperience = parseInt(body == null ? null : body.get("yearsInBusiness"), 0);
        }
        String logoPath = trim(str(body, "logoPath"));
        String pitchDeckPath = trim(str(body, "pitchDeckPath"));
        String verificationDocuments = trim(str(body, "verificationDocuments"));
        String govId = trim(str(body, "govId"));
        if (verificationDocuments.isBlank()) verificationDocuments = govId;

        if (fullName.isBlank() || businessName.isBlank()) {
            return badRequest("fullName and businessName are required");
        }
        String emailErr = MobileValidation.requireEmail(email);
        if (emailErr != null) return badRequest(emailErr);
        String phoneErr = MobileValidation.requirePhone(phone, true);
        if (phoneErr != null) return badRequest(phoneErr);
        String passErr = MobileValidation.requirePassword(password);
        if (passErr != null) return badRequest(passErr);
        String confirmErr = MobileValidation.requireConfirm(password, confirmPassword);
        if (confirmErr != null) return badRequest(confirmErr);
        if (entrepreneurRepository.findByEmail(email).isPresent()) {
            return ResponseEntity.status(HttpStatus.CONFLICT).body(error("Email already registered"));
        }

        Entrepreneur e = new Entrepreneur();
        e.setFullName(fullName);
        e.setEmail(email);
        e.setPhone(phone.isBlank() ? null : phone);
        e.setPassword(passwordService.encode(password));
        e.setBusinessName(businessName);
        e.setBusinessCategory(businessCategory.isBlank() ? null : businessCategory);
        e.setBusinessLocation(businessLocation.isBlank() ? null : businessLocation);
        e.setBusinessDescription(businessDescription.isBlank() ? null : businessDescription);
        e.setInvestmentNeeded(investmentNeeded == null ? 0.0 : investmentNeeded);
        e.setExpectedMonthlyIncome(expectedMonthlyIncome == null ? 0.0 : expectedMonthlyIncome);
        e.setBusinessExperience(businessExperience == null ? 0 : businessExperience);
        e.setAadhaarDocPath(verificationDocuments.isBlank() ? "mobile-pending" : verificationDocuments);
        e.setDocumentsPath(pitchDeckPath.isBlank() ? "mobile-pending" : pitchDeckPath);
        e.setPhotosPath(logoPath.isBlank() ? "mobile-pending" : logoPath);
        e.setVerificationStatus(VerificationStatus.PENDING);

        String genderRaw = trim(str(body, "gender"));
        if (!genderRaw.isBlank()) {
            try {
                e.setGender(Gender.valueOf(genderRaw.toUpperCase(Locale.ROOT)));
            } catch (Exception ignored) {
            }
        }
        String dob = trim(str(body, "dob"));
        if (!dob.isBlank()) e.setDob(dob);
        String aadhaar = trim(str(body, "aadhaarNumber"));
        if (!aadhaar.isBlank()) e.setAadhaarNumber(aadhaar);

        entrepreneurRepository.save(e);

        BusinessProposal proposal = new BusinessProposal();
        proposal.setEntrepreneur(e);
        proposal.setTitle("Launch of " + businessName);
        proposal.setCategory(e.getBusinessCategory());
        proposal.setLocation(e.getBusinessLocation());
        proposal.setDescription(e.getBusinessDescription());
        proposal.setFundingNeeded(e.getInvestmentNeeded());
        proposal.setExpectedMonthlyIncome(e.getExpectedMonthlyIncome());
        proposal.setPhotos(logoPath.isBlank() ? "mobile-pending" : logoPath);
        proposal.setDocuments(pitchDeckPath.isBlank() ? "mobile-pending" : pitchDeckPath);
        proposal.setStatus(VerificationStatus.PENDING);
        businessProposalRepository.save(proposal);

        Map<String, Object> res = new LinkedHashMap<>();
        res.put("success", true);
        res.put("message", "Registration submitted. Await admin verification.");
        res.put("entrepreneurId", e.getId());
        res.put("proposalId", proposal.getId());
        res.put("status", "PENDING");
        return ResponseEntity.status(HttpStatus.CREATED).body(res);
    }

    @PostMapping("/login")
    public ResponseEntity<Map<String, Object>> login(@RequestBody Map<String, String> body, HttpSession session) {
        String email = trim(body == null ? null : body.get("email")).toLowerCase(Locale.ROOT);
        String password = body == null ? "" : body.getOrDefault("password", "");
        if (email.isBlank() || password.isBlank()) return badRequest("Email and password are required");

        Optional<Entrepreneur> opt = entrepreneurRepository.findByEmail(email);
        if (opt.isEmpty()) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(error("Entrepreneur not found"));
        }
        Entrepreneur e = opt.get();
        boolean ok = passwordService.matchesAndUpgrade(password, e.getPassword(), hashed -> {
            e.setPassword(hashed);
            entrepreneurRepository.save(e);
        });
        if (!ok) return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(error("Invalid password"));
        if (e.getVerificationStatus() == VerificationStatus.PENDING) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(error("Your profile is pending admin approval"));
        }
        if (e.getVerificationStatus() == VerificationStatus.REJECTED) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(error("Your registration has been rejected"));
        }

        session.setAttribute("loggedEntrepreneur", e);
        String token = jwtUtil.generateToken(e.getEmail(), "ENTREPRENEUR");
        Map<String, Object> res = new LinkedHashMap<>();
        res.put("success", true);
        res.put("token", token);
        res.put("tokenType", "Bearer");
        res.put("role", "ENTREPRENEUR");
        res.put("entrepreneur", entrepreneurSummary(e));
        return ResponseEntity.ok(res);
    }

    @GetMapping("/me")
    public ResponseEntity<Map<String, Object>> me(HttpSession session) {
        Entrepreneur e = requireEntrepreneur(session);
        if (e == null) return unauthorized();
        e = entrepreneurRepository.findById(e.getId()).orElse(e);
        session.setAttribute("loggedEntrepreneur", e);

        List<BusinessProposal> proposals = businessProposalRepository.findByEntrepreneur(e);
        double totalRequested = proposals.stream()
                .mapToDouble(p -> p.getFundingNeeded() == null ? 0.0 : p.getFundingNeeded())
                .sum();
        double totalRaised = proposals.stream()
                .mapToDouble(p -> p.getAmountRaised() == null ? 0.0 : p.getAmountRaised())
                .sum();

        List<Map<String, Object>> proposalDtos = proposals.stream().map(this::proposalDto).toList();

        return ResponseEntity.ok(ok(Map.of(
                "entrepreneur", entrepreneurSummary(e),
                "proposals", proposalDtos,
                "funding", Map.of(
                        "totalRequested", totalRequested,
                        "totalRaised", totalRaised,
                        "remaining", totalRequested - totalRaised
                )
        )));
    }

    @PostMapping("/proposals")
    @Transactional
    public ResponseEntity<Map<String, Object>> createProposal(
            @RequestBody Map<String, Object> body,
            HttpSession session) {
        Entrepreneur e = requireEntrepreneur(session);
        if (e == null) return unauthorized();

        String title = trim(str(body, "title"));
        String category = trim(str(body, "category"));
        String location = trim(str(body, "location"));
        String description = trim(str(body, "description"));
        Double fundingNeeded = parseDouble(body == null ? null : body.get("fundingNeeded"), null);
        Double expectedMonthlyIncome = parseDouble(body == null ? null : body.get("expectedMonthlyIncome"), 0.0);

        if (title.isBlank() || fundingNeeded == null || fundingNeeded <= 0) {
            return badRequest("title and fundingNeeded are required");
        }

        BusinessProposal p = new BusinessProposal();
        p.setEntrepreneur(e);
        p.setTitle(title);
        p.setCategory(category.isBlank() ? e.getBusinessCategory() : category);
        p.setLocation(location.isBlank() ? e.getBusinessLocation() : location);
        p.setDescription(description.isBlank() ? null : description);
        p.setFundingNeeded(fundingNeeded);
        p.setExpectedMonthlyIncome(expectedMonthlyIncome == null ? 0.0 : expectedMonthlyIncome);
        p.setPhotos("mobile-pending");
        p.setDocuments("mobile-pending");
        p.setStatus(VerificationStatus.PENDING);
        businessProposalRepository.save(p);

        return ResponseEntity.status(HttpStatus.CREATED).body(ok(Map.of(
                "message", "Proposal submitted. Pending admin approval.",
                "proposal", proposalDto(p)
        )));
    }

    private Entrepreneur requireEntrepreneur(HttpSession session) {
        Object e = session == null ? null : session.getAttribute("loggedEntrepreneur");
        return e instanceof Entrepreneur ? (Entrepreneur) e : null;
    }

    private ResponseEntity<Map<String, Object>> unauthorized() {
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(error("Entrepreneur login required"));
    }

    private ResponseEntity<Map<String, Object>> badRequest(String msg) {
        return ResponseEntity.badRequest().body(error(msg));
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

    private static String trim(String v) {
        return v == null ? "" : v.trim();
    }

    private static String str(Map<String, Object> body, String key) {
        if (body == null || body.get(key) == null) return "";
        return Objects.toString(body.get(key), "");
    }

    private static Double parseDouble(Object value, Double fallback) {
        if (value == null || value.toString().isBlank()) return fallback;
        try {
            return Double.parseDouble(value.toString());
        } catch (Exception e) {
            return fallback;
        }
    }

    private static Integer parseInt(Object value, Integer fallback) {
        if (value == null || value.toString().isBlank()) return fallback;
        try {
            return Integer.parseInt(value.toString().replaceAll("[^0-9-]", ""));
        } catch (Exception e) {
            return fallback;
        }
    }

    private static String sanitize(String v) {
        if (v == null) return "";
        return v.replace("₹", "Rs ").replace("\u20B9", "Rs ");
    }

    private Map<String, Object> entrepreneurSummary(Entrepreneur e) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", e.getId());
        m.put("fullName", e.getFullName());
        m.put("email", e.getEmail());
        m.put("phone", e.getPhone());
        m.put("businessName", e.getBusinessName());
        m.put("businessCategory", e.getBusinessCategory());
        m.put("businessLocation", e.getBusinessLocation());
        m.put("businessDescription", e.getBusinessDescription());
        m.put("investmentNeeded", e.getInvestmentNeeded());
        m.put("expectedMonthlyIncome", e.getExpectedMonthlyIncome());
        m.put("businessExperience", e.getBusinessExperience());
        m.put("verificationStatus", e.getVerificationStatus() == null ? null : e.getVerificationStatus().name());
        m.put("verificationFeePaid", e.isVerificationFeePaid());
        return m;
    }

    private Map<String, Object> proposalDto(BusinessProposal p) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", p.getId());
        m.put("title", p.getTitle());
        m.put("category", p.getCategory());
        m.put("location", p.getLocation());
        m.put("description", p.getDescription());
        m.put("fundingNeeded", p.getFundingNeeded());
        m.put("expectedMonthlyIncome", p.getExpectedMonthlyIncome());
        m.put("amountRaised", p.getAmountRaised() == null ? 0.0 : p.getAmountRaised());
        m.put("status", p.getStatus() == null ? null : p.getStatus().name());
        m.put("featured", p.isFeatured());
        m.put("premium", p.isPremium());
        return m;
    }
}
