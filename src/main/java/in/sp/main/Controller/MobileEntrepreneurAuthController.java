package in.sp.main.Controller;

import in.sp.main.Config.JwtUtil;
import in.sp.main.Entities.*;
import in.sp.main.Repository.BusinessProposalRepository;
import in.sp.main.Repository.EntrepreneurRepository;
import in.sp.main.Repository.InvestmentRepository;
import in.sp.main.Service.EntrepreneurProfileService;
import in.sp.main.Service.EntrepreneurRegistrationService;
import in.sp.main.Service.PartnerLifecycleSupport;
import in.sp.main.Service.PasswordService;
import in.sp.main.Util.FundingCatalog;
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
    private InvestmentRepository investmentRepository;
    @Autowired
    private PasswordService passwordService;
    @Autowired
    private JwtUtil jwtUtil;
    @Autowired
    private EntrepreneurRegistrationService entrepreneurRegistrationService;
    @Autowired
    private EntrepreneurProfileService entrepreneurProfileService;
    @Autowired
    private in.sp.main.Service.FundingCareService fundingCareService;
    @Autowired
    private in.sp.main.Service.FileUploadService fileUploadService;

    @PostMapping("/otp/send-email")
    public ResponseEntity<Map<String, Object>> sendEmailOtp(@RequestBody Map<String, String> body) {
        try {
            entrepreneurRegistrationService.sendRegistrationOtp(body == null ? null : body.get("email"));
            Map<String, Object> res = new LinkedHashMap<>();
            res.put("success", true);
            res.put("message", "OTP sent to your email");
            return ResponseEntity.ok(res);
        } catch (org.springframework.web.server.ResponseStatusException ex) {
            return ResponseEntity.status(ex.getStatusCode()).body(error(ex.getReason()));
        }
    }

    @PostMapping("/otp/verify-email")
    public ResponseEntity<Map<String, Object>> verifyEmailOtp(@RequestBody Map<String, String> body) {
        try {
            entrepreneurRegistrationService.verifyRegistrationOtp(
                    body == null ? null : body.get("email"),
                    body == null ? null : body.get("otp"));
            Map<String, Object> res = new LinkedHashMap<>();
            res.put("success", true);
            res.put("message", "Email verified");
            return ResponseEntity.ok(res);
        } catch (org.springframework.web.server.ResponseStatusException ex) {
            return ResponseEntity.status(ex.getStatusCode()).body(error(ex.getReason()));
        }
    }

    @PostMapping("/register-quick")
    public ResponseEntity<Map<String, Object>> registerQuick(@RequestBody Map<String, Object> body) {
        try {
            boolean accepted = body != null && (
                    Boolean.TRUE.equals(body.get("acceptedTerms"))
                            || "true".equalsIgnoreCase(String.valueOf(body.get("acceptedTerms"))));
            Entrepreneur e = entrepreneurRegistrationService.registerQuick(
                    str(body, "fullName"),
                    str(body, "email"),
                    str(body, "phone"),
                    str(body, "password"),
                    str(body, "confirmPassword"),
                    str(body, "emailOtp"),
                    accepted);
            Map<String, Object> res = new LinkedHashMap<>();
            res.put("success", true);
            res.put("message", "Account created. Login and complete your profile to submit for verification.");
            res.put("entrepreneurId", e.getId());
            res.put("partnerProfileStatus", e.getPartnerProfileStatus() == null
                    ? null : e.getPartnerProfileStatus().name());
            res.put("profileCompletionPct", e.getProfileCompletionPct());
            return ResponseEntity.status(HttpStatus.CREATED).body(res);
        } catch (org.springframework.web.server.ResponseStatusException ex) {
            return ResponseEntity.status(ex.getStatusCode()).body(error(ex.getReason()));
        }
    }

    /**
     * Legacy full registration — kept for older clients.
     */
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

        entrepreneurProfileService.setLifecycleStatus(e, PartnerProfileStatus.REGISTERED);
        entrepreneurRepository.save(e);
        entrepreneurProfileService.setLifecycleStatus(e, PartnerProfileStatus.PROFILE_INCOMPLETE);
        entrepreneurProfileService.refreshCompletion(e);

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
        res.put("message", "Registration submitted. Complete your profile and await admin verification.");
        res.put("entrepreneurId", e.getId());
        res.put("proposalId", proposal.getId());
        res.put("status", "PENDING");
        res.put("partnerProfileStatus", e.getPartnerProfileStatus() == null
                ? null : e.getPartnerProfileStatus().name());
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

        if (e.getPartnerProfileStatus() == PartnerProfileStatus.SUSPENDED) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN)
                    .body(error("Your entrepreneur account has been suspended"));
        }

        PartnerProfileStatus status = e.getPartnerProfileStatus();
        if (status == null) {
            if (e.getVerificationStatus() == VerificationStatus.VERIFIED) {
                entrepreneurProfileService.setLifecycleStatus(e, PartnerProfileStatus.APPROVED);
            } else if (e.getVerificationStatus() == VerificationStatus.REJECTED) {
                entrepreneurProfileService.setLifecycleStatus(e, PartnerProfileStatus.REJECTED);
            } else {
                entrepreneurProfileService.setLifecycleStatus(e, PartnerProfileStatus.PROFILE_INCOMPLETE);
            }
            entrepreneurProfileService.refreshCompletion(e);
        } else {
            entrepreneurProfileService.refreshCompletion(e);
        }

        session.setAttribute("loggedEntrepreneur", e);
        String token = jwtUtil.generateToken(e.getEmail(), "ENTREPRENEUR");
        Map<String, Object> res = new LinkedHashMap<>();
        res.put("success", true);
        res.put("token", token);
        res.put("tokenType", "Bearer");
        res.put("role", "ENTREPRENEUR");
        res.put("entrepreneur", entrepreneurSummary(e));
        res.put("needsProfileCompletion",
                PartnerLifecycleSupport.needsProfileCompletion(e.getPartnerProfileStatus()));
        res.put("canSubmitForVerification",
                entrepreneurProfileService.isReadyForVerification(e)
                        && e.getPartnerProfileStatus() != PartnerProfileStatus.PENDING_ADMIN_APPROVAL);
        return ResponseEntity.ok(res);
    }

    @GetMapping("/profile")
    public ResponseEntity<Map<String, Object>> getProfile(HttpSession session) {
        Entrepreneur e = requireEntrepreneur(session);
        if (e == null) return unauthorized();
        e = entrepreneurRepository.findById(e.getId()).orElse(e);
        Map<String, Object> res = new LinkedHashMap<>();
        res.put("success", true);
        res.putAll(entrepreneurProfileService.profilePayload(e));
        return ResponseEntity.ok(res);
    }

    @PutMapping("/profile")
    @Transactional
    public ResponseEntity<Map<String, Object>> updateProfile(
            @RequestBody Map<String, Object> body,
            HttpSession session) {
        Entrepreneur e = requireEntrepreneur(session);
        if (e == null) return unauthorized();
        e = entrepreneurRepository.findById(e.getId()).orElse(e);
        entrepreneurProfileService.applyExtraFields(e, body);
        entrepreneurProfileService.refreshCompletion(e);
        Map<String, Object> res = new LinkedHashMap<>();
        res.put("success", true);
        res.put("message", "Profile saved");
        res.putAll(entrepreneurProfileService.profilePayload(e));
        return ResponseEntity.ok(res);
    }

    @PostMapping("/submit-verification")
    public ResponseEntity<Map<String, Object>> submitVerification(HttpSession session) {
        Entrepreneur e = requireEntrepreneur(session);
        if (e == null) return unauthorized();
        try {
            Entrepreneur entrepreneur = entrepreneurRepository.findById(e.getId()).orElse(e);
            entrepreneurRegistrationService.submitForVerification(entrepreneur);
            Map<String, Object> res = new LinkedHashMap<>();
            res.put("success", true);
            res.put("message", "Submitted for admin verification");
            res.putAll(entrepreneurProfileService.profilePayload(entrepreneur));
            return ResponseEntity.ok(res);
        } catch (org.springframework.web.server.ResponseStatusException ex) {
            return ResponseEntity.status(ex.getStatusCode()).body(error(ex.getReason()));
        }
    }

    @GetMapping("/proposal-categories")
    public ResponseEntity<Map<String, Object>> proposalCategories() {
        return ResponseEntity.ok(ok(Map.of(
                "categories", FundingCatalog.asCatalog(),
                "labels", FundingCatalog.categories()
        )));
    }

    @GetMapping("/me")
    public ResponseEntity<Map<String, Object>> me(HttpSession session) {
        Entrepreneur e = requireEntrepreneur(session);
        if (e == null) return unauthorized();
        e = entrepreneurRepository.findById(e.getId()).orElse(e);
        session.setAttribute("loggedEntrepreneur", e);

        List<BusinessProposal> proposals = businessProposalRepository.findByEntrepreneur(e);
        double totalRequested = proposals.stream()
                .filter(p -> p.getStatus() != VerificationStatus.CANCELLED)
                .mapToDouble(p -> p.getFundingNeeded() == null ? 0.0 : p.getFundingNeeded())
                .sum();
        double totalRaised = proposals.stream()
                .mapToDouble(p -> p.getAmountRaised() == null ? 0.0 : p.getAmountRaised())
                .sum();

        List<Investment> interests = investmentRepository.findByProposal_Entrepreneur_Id(e.getId());
        long pendingInterestCount = interests.stream()
                .filter(i -> "PENDING".equalsIgnoreCase(i.getStatus()))
                .count();
        double pendingInterestAmount = interests.stream()
                .filter(i -> "PENDING".equalsIgnoreCase(i.getStatus()))
                .mapToDouble(i -> i.getAmount() == null ? 0.0 : i.getAmount())
                .sum();

        List<Map<String, Object>> proposalDtos = proposals.stream().map(this::proposalDto).toList();
        List<Map<String, Object>> interestDtos = interests.stream().map(this::interestDto).toList();

        boolean approved = e.getPartnerProfileStatus() == PartnerProfileStatus.APPROVED;
        Map<String, Object> data = new LinkedHashMap<>();
        data.put("entrepreneur", entrepreneurSummary(e));
        data.put("proposals", proposalDtos);
        data.put("interests", interestDtos);
        data.put("funding", Map.of(
                "totalRequested", totalRequested,
                "totalRaised", totalRaised,
                "remaining", Math.max(0, totalRequested - totalRaised),
                "pendingInterestCount", pendingInterestCount,
                "pendingInterestAmount", pendingInterestAmount,
                "interestedInvestors", pendingInterestCount
        ));
        data.put("canCreateProposal", approved);
        data.put("needsProfileCompletion",
                PartnerLifecycleSupport.needsProfileCompletion(e.getPartnerProfileStatus()));
        data.put("payoutBalance", e.getPayoutBalance());
        data.put("upiId", e.getUpiId() == null ? "" : e.getUpiId());
        data.put("cancelPolicy", in.sp.main.Service.FundingCareService.CANCEL_POLICY);
        return ResponseEntity.ok(ok(data));
    }

    @GetMapping("/interests")
    public ResponseEntity<Map<String, Object>> interests(HttpSession session) {
        Entrepreneur e = requireEntrepreneur(session);
        if (e == null) return unauthorized();
        List<Map<String, Object>> items = investmentRepository.findByProposal_Entrepreneur_Id(e.getId())
                .stream().map(this::interestDto).toList();
        return ResponseEntity.ok(ok(Map.of("interests", items, "count", items.size())));
    }

    @PostMapping("/proposals")
    @Transactional
    public ResponseEntity<Map<String, Object>> createProposal(
            @RequestBody Map<String, Object> body,
            HttpSession session) {
        Entrepreneur e = requireEntrepreneur(session);
        if (e == null) return unauthorized();
        e = entrepreneurRepository.findById(e.getId()).orElse(e);
        if (e.getPartnerProfileStatus() != PartnerProfileStatus.APPROVED) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN)
                    .body(error("Entrepreneur must be verified before creating proposals"));
        }

        String title = trim(str(body, "title"));
        String category = FundingCatalog.normalize(trim(str(body, "category")));
        String location = trim(str(body, "location"));
        String description = trim(str(body, "description"));
        Double fundingNeeded = parseDouble(body == null ? null : body.get("fundingNeeded"), null);
        Double expectedMonthlyIncome = parseDouble(body == null ? null : body.get("expectedMonthlyIncome"), 0.0);

        if (title.isBlank() || fundingNeeded == null || fundingNeeded <= 0) {
            return badRequest("title and fundingNeeded (> 0) are required");
        }
        if (expectedMonthlyIncome != null && expectedMonthlyIncome < 0) {
            return badRequest("expectedMonthlyIncome must be 0 or greater");
        }

        BusinessProposal p = new BusinessProposal();
        p.setEntrepreneur(e);
        p.setTitle(title);
        p.setCategory(category == null || category.isBlank()
                ? FundingCatalog.normalize(e.getBusinessCategory())
                : category);
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

    @PutMapping("/proposals/{id}")
    @Transactional
    public ResponseEntity<Map<String, Object>> updateProposal(
            @PathVariable Long id,
            @RequestBody Map<String, Object> body,
            HttpSession session) {
        Entrepreneur e = requireEntrepreneur(session);
        if (e == null) return unauthorized();
        e = entrepreneurRepository.findById(e.getId()).orElse(e);
        if (e.getPartnerProfileStatus() != PartnerProfileStatus.APPROVED) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN)
                    .body(error("Entrepreneur must be verified"));
        }
        BusinessProposal p = businessProposalRepository.findById(id).orElse(null);
        if (p == null || p.getEntrepreneur() == null || !p.getEntrepreneur().getId().equals(e.getId())) {
            return badRequest("Proposal not found");
        }
        if (p.getStatus() == VerificationStatus.CANCELLED) {
            return badRequest("Cancelled proposals cannot be edited");
        }

        if (body.containsKey("title")) {
            String title = trim(str(body, "title"));
            if (title.isBlank()) return badRequest("title is required");
            p.setTitle(title);
        }
        if (body.containsKey("category")) {
            p.setCategory(FundingCatalog.normalize(trim(str(body, "category"))));
        }
        if (body.containsKey("location")) {
            String location = trim(str(body, "location"));
            p.setLocation(location.isBlank() ? e.getBusinessLocation() : location);
        }
        if (body.containsKey("description")) {
            String description = trim(str(body, "description"));
            p.setDescription(description.isBlank() ? null : description);
        }
        if (body.containsKey("fundingNeeded")) {
            Double fundingNeeded = parseDouble(body.get("fundingNeeded"), null);
            if (fundingNeeded == null || fundingNeeded <= 0) {
                return badRequest("fundingNeeded must be greater than 0");
            }
            p.setFundingNeeded(fundingNeeded);
        }
        if (body.containsKey("expectedMonthlyIncome")) {
            Double income = parseDouble(body.get("expectedMonthlyIncome"), 0.0);
            if (income != null && income < 0) return badRequest("expectedMonthlyIncome must be 0 or greater");
            p.setExpectedMonthlyIncome(income == null ? 0.0 : income);
        }

        if (p.getStatus() == VerificationStatus.VERIFIED) {
            p.setStatus(VerificationStatus.PENDING);
        }
        businessProposalRepository.save(p);
        return ResponseEntity.ok(ok(Map.of(
                "message", p.getStatus() == VerificationStatus.PENDING
                        ? "Proposal updated and sent for re-approval"
                        : "Proposal updated",
                "proposal", proposalDto(p)
        )));
    }

    @PostMapping("/proposals/{id}/cancel")
    @Transactional
    public ResponseEntity<Map<String, Object>> cancelProposal(@PathVariable Long id, HttpSession session) {
        Entrepreneur e = requireEntrepreneur(session);
        if (e == null) return unauthorized();
        BusinessProposal p = businessProposalRepository.findById(id).orElse(null);
        if (p == null || p.getEntrepreneur() == null || !p.getEntrepreneur().getId().equals(e.getId())) {
            return badRequest("Proposal not found");
        }
        if (p.getStatus() == VerificationStatus.CANCELLED) {
            return badRequest("Proposal already cancelled");
        }
        p.setStatus(VerificationStatus.CANCELLED);
        businessProposalRepository.save(p);
        return ResponseEntity.ok(ok(Map.of(
                "message", "Proposal cancelled",
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
        m.put("partnerProfileStatus", e.getPartnerProfileStatus() == null
                ? null : e.getPartnerProfileStatus().name());
        m.put("partnerProfileStatusLabel", EntrepreneurProfileService.statusLabel(e.getPartnerProfileStatus()));
        m.put("profileCompletionPct", e.getProfileCompletionPct() == null ? 0 : e.getProfileCompletionPct());
        m.put("rejectionReason", e.getRejectionReason());
        m.put("changesRequestedNote", e.getChangesRequestedNote());
        m.put("documentsPath", e.getDocumentsPath());
        m.put("videoPitchPath", e.getVideoPitchPath());
        m.put("bankName", e.getBankName());
        m.put("canCreateProposal", e.getPartnerProfileStatus() == PartnerProfileStatus.APPROVED);
        m.put("verified", e.getPartnerProfileStatus() == PartnerProfileStatus.APPROVED);
        EntrepreneurProfileService.putExtra(m, e);
        m.put("cancelPolicy", in.sp.main.Service.FundingCareService.CANCEL_POLICY);
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
        double raised = p.getAmountRaised() == null ? 0.0 : p.getAmountRaised();
        m.put("amountRaised", raised);
        m.put("status", p.getStatus() == null ? null : p.getStatus().name());
        m.put("featured", p.isFeatured());
        m.put("premium", p.isPremium());
        m.put("documents", p.getDocuments());
        m.put("videoPitch", p.getVideoPitch());
        m.put("canEdit", p.getStatus() != VerificationStatus.CANCELLED);
        m.put("canCancel", p.getStatus() != VerificationStatus.CANCELLED);

        List<Investment> invs = investmentRepository.findByProposal(p);
        long pendingCount = invs.stream().filter(i -> "PENDING".equalsIgnoreCase(i.getStatus())).count();
        double pendingAmount = invs.stream()
                .filter(i -> "PENDING".equalsIgnoreCase(i.getStatus()))
                .mapToDouble(i -> i.getAmount() == null ? 0.0 : i.getAmount())
                .sum();
        m.put("interestCount", invs.size());
        m.put("pendingInterestCount", pendingCount);
        m.put("pendingInterestAmount", pendingAmount);
        double needed = p.getFundingNeeded() == null ? 0.0 : p.getFundingNeeded();
        m.put("remaining", Math.max(0, needed - raised));
        m.put("openRemaining", Math.max(0, needed - raised - pendingAmount));
        return m;
    }

    private Map<String, Object> interestDto(Investment i) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", i.getId());
        m.put("investmentId", i.getId());
        m.put("amount", i.getAmount());
        m.put("status", i.getStatus());
        m.put("createdAt", i.getCreatedAt() == null ? null : i.getCreatedAt().toString());
        if (i.getInvestor() != null) {
            m.put("investorId", i.getInvestor().getId());
            m.put("investorName", i.getInvestor().getFullName());
            m.put("investorCompany", i.getInvestor().getCompanyName());
            m.put("investorEmail", i.getInvestor().getEmail());
        }
        if (i.getProposal() != null) {
            m.put("proposalId", i.getProposal().getId());
            m.put("proposalTitle", i.getProposal().getTitle());
            m.put("proposalStatus", i.getProposal().getStatus() == null
                    ? null : i.getProposal().getStatus().name());
        }
        m.put("coachNotes", i.getCoachNotes());
        m.put("rating", i.getRating());
        m.put("review", i.getReview());
        m.put("commissionPaid", i.isCommissionPaid());
        m.put("commissionDue", fundingCareService.commissionOf(i));
        m.put("canReview", "COMPLETED".equalsIgnoreCase(i.getStatus()) && i.getRating() == null);
        m.put("cancelPolicy", in.sp.main.Service.FundingCareService.CANCEL_POLICY);
        return m;
    }

    @PostMapping("/payout/request")
    @Transactional
    public ResponseEntity<Map<String, Object>> requestPayout(HttpSession session) {
        Entrepreneur e = requireEntrepreneur(session);
        if (e == null) return unauthorized();
        try {
            return ResponseEntity.ok(fundingCareService.requestPayout(
                    entrepreneurRepository.findById(e.getId()).orElse(e)));
        } catch (org.springframework.web.server.ResponseStatusException ex) {
            return ResponseEntity.status(ex.getStatusCode()).body(error(ex.getReason()));
        }
    }

    @PostMapping("/investments/{id}/notes")
    @Transactional
    public ResponseEntity<Map<String, Object>> updateNotes(
            @PathVariable Long id, @RequestBody Map<String, Object> body, HttpSession session) {
        Entrepreneur e = requireEntrepreneur(session);
        if (e == null) return unauthorized();
        Investment i = investmentRepository.findById(id).orElse(null);
        if (i == null || i.getProposal() == null || i.getProposal().getEntrepreneur() == null
                || !i.getProposal().getEntrepreneur().getId().equals(e.getId())) {
            return badRequest("Investment not found");
        }
        i.setCoachNotes(body == null || body.get("coachNotes") == null ? "" : String.valueOf(body.get("coachNotes")));
        investmentRepository.save(i);
        return ResponseEntity.ok(ok(Map.of("message", "Notes saved", "investment", interestDto(i))));
    }

    @PostMapping(value = "/photos", consumes = org.springframework.http.MediaType.MULTIPART_FORM_DATA_VALUE)
    @Transactional
    public ResponseEntity<Map<String, Object>> uploadPhotos(
            @RequestParam(value = "profileImage", required = false) org.springframework.web.multipart.MultipartFile profileImage,
            @RequestParam(value = "galleryPhotos", required = false) org.springframework.web.multipart.MultipartFile galleryPhotos,
            HttpSession session) {
        Entrepreneur e = requireEntrepreneur(session);
        if (e == null) return unauthorized();
        e = entrepreneurRepository.findById(e.getId()).orElse(e);
        try {
            if (profileImage != null && !profileImage.isEmpty()) {
                e.setProfilePhoto(fileUploadService.saveFile(profileImage));
            }
            if (galleryPhotos != null && !galleryPhotos.isEmpty()) {
                String path = fileUploadService.saveFile(galleryPhotos);
                String existing = e.getGalleryPhotos();
                e.setGalleryPhotos(existing == null || existing.isBlank() ? path : existing + "," + path);
                e.setPhotosPath(e.getGalleryPhotos());
            }
            entrepreneurRepository.save(e);
            Map<String, Object> res = new LinkedHashMap<>();
            res.put("success", true);
            res.put("message", "Photos saved");
            res.putAll(entrepreneurProfileService.profilePayload(e));
            return ResponseEntity.ok(res);
        } catch (Exception ex) {
            return badRequest(ex.getMessage() == null ? "Upload failed" : ex.getMessage());
        }
    }
}
