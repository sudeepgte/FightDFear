package in.sp.main.Controller;

import in.sp.main.Config.JwtUtil;
import in.sp.main.Entities.*;
import in.sp.main.Repository.BusinessProposalRepository;
import in.sp.main.Repository.InvestmentRepository;
import in.sp.main.Repository.InvestorRepository;
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
@RequestMapping("/api/investor")
public class MobileInvestorAuthController {

    @Autowired
    private InvestorRepository investorRepository;
    @Autowired
    private InvestmentRepository investmentRepository;
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
        String companyName = trim(str(body, "companyName"));
        String investmentInterests = sanitize(trim(str(body, "investmentInterests")));
        String budgetRange = sanitize(trim(str(body, "budgetRange")));
        String preferredLocations = sanitize(trim(str(body, "preferredLocations")));
        String preferredCategories = sanitize(trim(str(body, "preferredCategories")));
        String photoPath = trim(str(body, "photoPath"));
        if (photoPath.isBlank()) photoPath = trim(str(body, "photo"));
        String verificationDocuments = trim(str(body, "verificationDocuments"));
        if (verificationDocuments.isBlank()) verificationDocuments = trim(str(body, "govId"));

        if (fullName.isBlank()) return badRequest("fullName is required");
        String emailErr = MobileValidation.requireEmail(email);
        if (emailErr != null) return badRequest(emailErr);
        String phoneErr = MobileValidation.requirePhone(phone, true);
        if (phoneErr != null) return badRequest(phoneErr);
        String passErr = MobileValidation.requirePassword(password);
        if (passErr != null) return badRequest(passErr);
        String confirmErr = MobileValidation.requireConfirm(password, confirmPassword);
        if (confirmErr != null) return badRequest(confirmErr);
        if (investorRepository.findByEmail(email).isPresent()) {
            return ResponseEntity.status(HttpStatus.CONFLICT).body(error("Email already registered"));
        }

        Investor inv = new Investor();
        inv.setFullName(fullName);
        inv.setEmail(email);
        inv.setPhone(phone.isBlank() ? null : phone);
        inv.setPassword(passwordService.encode(password));
        inv.setCompanyName(companyName.isBlank() ? null : companyName);
        inv.setInvestmentInterests(investmentInterests.isBlank() ? null : investmentInterests);
        inv.setBudgetRange(budgetRange.isBlank() ? null : budgetRange);
        inv.setPreferredLocations(preferredLocations.isBlank() ? null : preferredLocations);
        inv.setPreferredCategories(preferredCategories.isBlank() ? null : preferredCategories);
        inv.setProfilePhoto(photoPath.isBlank() ? null : photoPath);
        inv.setVerificationDocuments(verificationDocuments.isBlank() ? "mobile-pending" : verificationDocuments);
        inv.setVerificationStatus(VerificationStatus.PENDING);
        inv.setSubscribed(false);
        investorRepository.save(inv);

        Map<String, Object> res = new LinkedHashMap<>();
        res.put("success", true);
        res.put("message", "Registration submitted. Await admin verification.");
        res.put("investorId", inv.getId());
        res.put("status", "PENDING");
        return ResponseEntity.status(HttpStatus.CREATED).body(res);
    }

    @PostMapping("/login")
    public ResponseEntity<Map<String, Object>> login(@RequestBody Map<String, String> body, HttpSession session) {
        String email = trim(body == null ? null : body.get("email")).toLowerCase(Locale.ROOT);
        String password = body == null ? "" : body.getOrDefault("password", "");
        if (email.isBlank() || password.isBlank()) return badRequest("Email and password are required");

        Optional<Investor> opt = investorRepository.findByEmail(email);
        if (opt.isEmpty()) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(error("Investor not found"));
        }
        Investor inv = opt.get();
        boolean ok = passwordService.matchesAndUpgrade(password, inv.getPassword(), hashed -> {
            inv.setPassword(hashed);
            investorRepository.save(inv);
        });
        if (!ok) return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(error("Invalid password"));
        if (inv.getVerificationStatus() == VerificationStatus.PENDING) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(error("Your profile is pending admin approval"));
        }
        if (inv.getVerificationStatus() == VerificationStatus.REJECTED) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(error("Your registration has been rejected"));
        }

        session.setAttribute("loggedInvestor", inv);
        String token = jwtUtil.generateToken(inv.getEmail(), "INVESTOR");
        Map<String, Object> res = new LinkedHashMap<>();
        res.put("success", true);
        res.put("token", token);
        res.put("tokenType", "Bearer");
        res.put("role", "INVESTOR");
        res.put("investor", investorSummary(inv));
        return ResponseEntity.ok(res);
    }

    @GetMapping("/me")
    public ResponseEntity<Map<String, Object>> me(HttpSession session) {
        Investor inv = requireInvestor(session);
        if (inv == null) return unauthorized();
        inv = investorRepository.findById(inv.getId()).orElse(inv);
        session.setAttribute("loggedInvestor", inv);

        List<Investment> investments = investmentRepository.findByInvestor(inv);
        double totalInvested = investments.stream()
                .mapToDouble(i -> i.getAmount() == null ? 0.0 : i.getAmount())
                .sum();

        List<Map<String, Object>> portfolio = investments.stream().map(this::investmentDto).toList();
        List<Map<String, Object>> proposals = investments.stream()
                .map(Investment::getProposal)
                .filter(Objects::nonNull)
                .distinct()
                .map(this::proposalDto)
                .toList();

        List<Map<String, Object>> marketplace = businessProposalRepository
                .findByStatus(VerificationStatus.VERIFIED)
                .stream()
                .map(this::proposalDto)
                .toList();

        return ResponseEntity.ok(ok(Map.of(
                "investor", investorSummary(inv),
                "portfolio", portfolio,
                "investments", portfolio,
                "proposals", proposals,
                "marketplace", marketplace,
                "totalInvested", totalInvested
        )));
    }

    @GetMapping("/marketplace")
    public ResponseEntity<Map<String, Object>> marketplace(HttpSession session) {
        Investor inv = requireInvestor(session);
        if (inv == null) return unauthorized();
        List<Map<String, Object>> marketplace = businessProposalRepository
                .findByStatus(VerificationStatus.VERIFIED)
                .stream()
                .map(this::proposalDto)
                .toList();
        return ResponseEntity.ok(ok(Map.of("marketplace", marketplace)));
    }

    @PostMapping("/interest")
    @Transactional
    public ResponseEntity<Map<String, Object>> expressInterest(
            @RequestBody Map<String, Object> body,
            HttpSession session) {
        return createInvestment(body, session);
    }

    @PostMapping("/invest")
    @Transactional
    public ResponseEntity<Map<String, Object>> invest(
            @RequestBody Map<String, Object> body,
            HttpSession session) {
        return createInvestment(body, session);
    }

    private ResponseEntity<Map<String, Object>> createInvestment(Map<String, Object> body, HttpSession session) {
        Investor inv = requireInvestor(session);
        if (inv == null) return unauthorized();
        inv = investorRepository.findById(inv.getId()).orElse(inv);

        Long proposalId = parseLong(body == null ? null : body.get("proposalId"));
        Double amount = parseDouble(body == null ? null : body.get("amount"), null);
        if (proposalId == null) return badRequest("proposalId is required");
        if (amount == null || amount <= 0) return badRequest("amount must be greater than 0");

        BusinessProposal proposal = businessProposalRepository.findById(proposalId).orElse(null);
        if (proposal == null) return badRequest("Proposal not found");
        if (proposal.getStatus() != VerificationStatus.VERIFIED) {
            return badRequest("Proposal is not available for investment");
        }

        double pendingAmount = investmentRepository.findByProposal(proposal).stream()
                .filter(i -> "PENDING".equals(i.getStatus()))
                .mapToDouble(i -> i.getAmount() == null ? 0.0 : i.getAmount())
                .sum();
        double fundingNeeded = proposal.getFundingNeeded() == null ? 0.0 : proposal.getFundingNeeded();
        double amountRaised = proposal.getAmountRaised() == null ? 0.0 : proposal.getAmountRaised();
        double openRemaining = fundingNeeded - amountRaised - pendingAmount;
        if (openRemaining < 0) openRemaining = 0.0;
        if (amount > openRemaining) {
            return badRequest("Amount exceeds remaining funding of " + openRemaining);
        }

        Investment investment = new Investment();
        investment.setProposal(proposal);
        investment.setInvestor(inv);
        investment.setAmount(amount);
        investment.setStatus("PENDING");
        investmentRepository.save(investment);

        return ResponseEntity.status(HttpStatus.CREATED).body(ok(Map.of(
                "message", "Investment interest submitted",
                "investment", investmentDto(investment)
        )));
    }

    private Investor requireInvestor(HttpSession session) {
        Object i = session == null ? null : session.getAttribute("loggedInvestor");
        return i instanceof Investor ? (Investor) i : null;
    }

    private ResponseEntity<Map<String, Object>> unauthorized() {
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(error("Investor login required"));
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

    private static String sanitize(String v) {
        if (v == null) return "";
        return v.replace("₹", "Rs ").replace("\u20B9", "Rs ");
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

    private static Long parseLong(Object value) {
        if (value == null || value.toString().isBlank()) return null;
        try {
            return Long.parseLong(value.toString());
        } catch (Exception e) {
            return null;
        }
    }

    private Map<String, Object> investorSummary(Investor inv) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", inv.getId());
        m.put("fullName", inv.getFullName());
        m.put("email", inv.getEmail());
        m.put("phone", inv.getPhone());
        m.put("companyName", inv.getCompanyName());
        m.put("investmentInterests", inv.getInvestmentInterests());
        m.put("budgetRange", inv.getBudgetRange());
        m.put("preferredLocations", inv.getPreferredLocations());
        m.put("preferredCategories", inv.getPreferredCategories());
        m.put("verificationStatus", inv.getVerificationStatus() == null ? null : inv.getVerificationStatus().name());
        m.put("subscribed", inv.isSubscribed());
        return m;
    }

    private Map<String, Object> investmentDto(Investment i) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", i.getId());
        m.put("amount", i.getAmount());
        m.put("status", i.getStatus());
        m.put("createdAt", i.getCreatedAt() == null ? null : i.getCreatedAt().toString());
        if (i.getProposal() != null) {
            m.put("proposalId", i.getProposal().getId());
            m.put("proposalTitle", i.getProposal().getTitle());
            m.put("proposal", proposalDto(i.getProposal()));
        }
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
        if (p.getEntrepreneur() != null) {
            m.put("entrepreneurName", p.getEntrepreneur().getFullName());
            m.put("entrepreneurId", p.getEntrepreneur().getId());
            m.put("businessName", p.getEntrepreneur().getBusinessName());
        }
        return m;
    }
}
