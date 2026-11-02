package in.sp.main.Controller;

import in.sp.main.Config.JwtUtil;
import in.sp.main.Entities.*;
import in.sp.main.Repository.BusinessProposalRepository;
import in.sp.main.Repository.InvestmentRepository;
import in.sp.main.Repository.InvestorRepository;
import in.sp.main.Service.InvestorProfileService;
import in.sp.main.Service.InvestorRegistrationService;
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
    @Autowired
    private InvestorRegistrationService investorRegistrationService;
    @Autowired
    private InvestorProfileService investorProfileService;
    @Autowired
    private in.sp.main.Service.FundingCareService fundingCareService;
    @Autowired
    private in.sp.main.Service.FileUploadService fileUploadService;
    @Autowired
    private in.sp.main.Repository.ProposalQuestionRepository proposalQuestionRepository;
    @Autowired
    private in.sp.main.Repository.ProposalChatMessageRepository proposalChatMessageRepository;
    @Autowired
    private in.sp.main.Service.PushNotificationService pushNotificationService;
    @Autowired
    private in.sp.main.Service.EmailService emailService;

    @org.springframework.beans.factory.annotation.Value("${razorpay.key.id:rzp_test_RIlD5bEKRjyn3h}")
    private String razorpayKeyId;

    @org.springframework.beans.factory.annotation.Value("${razorpay.key.secret:Ltg6uo9vI8TiFMVfj2cGm4I8}")
    private String razorpayKeySecret;

    @PostMapping("/otp/send-email")
    public ResponseEntity<Map<String, Object>> sendEmailOtp(@RequestBody Map<String, String> body) {
        try {
            investorRegistrationService.sendRegistrationOtp(body == null ? null : body.get("email"));
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
            investorRegistrationService.verifyRegistrationOtp(
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
            Investor inv = investorRegistrationService.registerQuick(
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
            res.put("investorId", inv.getId());
            res.put("partnerProfileStatus", inv.getPartnerProfileStatus() == null
                    ? null : inv.getPartnerProfileStatus().name());
            res.put("profileCompletionPct", inv.getProfileCompletionPct());
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
        inv.setSubscribed(false);

        investorProfileService.setLifecycleStatus(inv, PartnerProfileStatus.REGISTERED);
        investorRepository.save(inv);
        investorProfileService.setLifecycleStatus(inv, PartnerProfileStatus.PROFILE_INCOMPLETE);
        investorProfileService.refreshCompletion(inv);

        Map<String, Object> res = new LinkedHashMap<>();
        res.put("success", true);
        res.put("message", "Registration submitted. Complete your profile and await admin verification.");
        res.put("investorId", inv.getId());
        res.put("status", "PENDING");
        res.put("partnerProfileStatus", inv.getPartnerProfileStatus() == null
                ? null : inv.getPartnerProfileStatus().name());
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
        final Investor authInv = inv;
        boolean ok = passwordService.matchesAndUpgrade(password, authInv.getPassword(), hashed -> {
            authInv.setPassword(hashed);
            investorRepository.save(authInv);
        });
        if (!ok) return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(error("Invalid password"));

        if (inv.getPartnerProfileStatus() == PartnerProfileStatus.SUSPENDED) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN)
                    .body(error("Your investor account has been suspended"));
        }

        PartnerProfileStatus status = inv.getPartnerProfileStatus();
        if (status == null) {
            if (inv.getVerificationStatus() == VerificationStatus.VERIFIED) {
                investorProfileService.setLifecycleStatus(inv, PartnerProfileStatus.APPROVED);
            } else if (inv.getVerificationStatus() == VerificationStatus.REJECTED) {
                investorProfileService.setLifecycleStatus(inv, PartnerProfileStatus.REJECTED);
            } else {
                investorProfileService.setLifecycleStatus(inv, PartnerProfileStatus.PROFILE_INCOMPLETE);
            }
            investorProfileService.refreshCompletion(inv);
        } else {
            investorProfileService.refreshCompletion(inv);
        }
        inv = investorProfileService.healApproval(inv);

        session.setAttribute("loggedInvestor", inv);
        String token = jwtUtil.generateToken(inv.getEmail(), "INVESTOR");
        boolean isApproved = InvestorProfileService.isApproved(inv);
        Map<String, Object> res = new LinkedHashMap<>();
        res.put("success", true);
        res.put("token", token);
        res.put("tokenType", "Bearer");
        res.put("role", "INVESTOR");
        res.put("approved", isApproved);
        res.put("status", isApproved ? "APPROVED" : (inv.getPartnerProfileStatus() != null ? inv.getPartnerProfileStatus().name() : "PROFILE_INCOMPLETE"));
        res.put("partnerProfileStatus", isApproved ? "APPROVED" : (inv.getPartnerProfileStatus() != null ? inv.getPartnerProfileStatus().name() : "PROFILE_INCOMPLETE"));
        res.put("investor", investorSummary(inv));
        res.put("needsProfileCompletion", !isApproved && InvestorProfileService.shouldForceProfileCompletion(inv));
        res.put("canSubmitForVerification", !isApproved && investorProfileService.isReadyForVerification(inv)
                        && inv.getPartnerProfileStatus() != PartnerProfileStatus.PENDING_ADMIN_APPROVAL);
        return ResponseEntity.ok(res);
    }

    @GetMapping("/profile")
    public ResponseEntity<Map<String, Object>> getProfile(HttpSession session) {
        Investor inv = requireInvestor(session);
        if (inv == null) return unauthorized();
        inv = investorRepository.findById(inv.getId()).orElse(inv);
        Map<String, Object> res = new LinkedHashMap<>();
        res.put("success", true);
        res.putAll(investorProfileService.profilePayload(inv));
        return ResponseEntity.ok(res);
    }

    @PutMapping("/profile")
    @Transactional
    public ResponseEntity<Map<String, Object>> updateProfile(
            @RequestBody Map<String, Object> body,
            HttpSession session) {
        Investor inv = requireInvestor(session);
        if (inv == null) return unauthorized();
        inv = investorRepository.findById(inv.getId()).orElse(inv);
        investorProfileService.applyExtraFields(inv, body);
        investorProfileService.refreshCompletion(inv);
        Map<String, Object> res = new LinkedHashMap<>();
        res.put("success", true);
        res.put("message", "Profile saved");
        res.putAll(investorProfileService.profilePayload(inv));
        return ResponseEntity.ok(res);
    }

    @PostMapping("/submit-verification")
    public ResponseEntity<Map<String, Object>> submitVerification(HttpSession session) {
        Investor inv = requireInvestor(session);
        if (inv == null) return unauthorized();
        try {
            Investor investor = investorRepository.findById(inv.getId()).orElse(inv);
            investorRegistrationService.submitForVerification(investor);
            Map<String, Object> res = new LinkedHashMap<>();
            res.put("success", true);
            res.put("message", "Submitted for admin verification");
            res.putAll(investorProfileService.profilePayload(investor));
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
        Investor inv = requireInvestor(session);
        if (inv == null) return unauthorized();
        inv = investorRepository.findById(inv.getId()).orElse(inv);
        inv = investorProfileService.healApproval(inv);
        session.setAttribute("loggedInvestor", inv);
        final Investor investor = inv;

        List<Investment> investments = investmentRepository.findByInvestor(investor).stream()
                .filter(i -> !"WITHDRAWN".equalsIgnoreCase(i.getStatus()))
                .toList();
        double totalInvested = investments.stream()
                .filter(i -> "COMPLETED".equalsIgnoreCase(i.getStatus()))
                .mapToDouble(i -> i.getAmount() == null ? 0.0 : i.getAmount())
                .sum();
        double pendingAmount = investments.stream()
                .filter(i -> "PENDING".equalsIgnoreCase(i.getStatus()))
                .mapToDouble(i -> i.getAmount() == null ? 0.0 : i.getAmount())
                .sum();
        long pendingCount = investments.stream()
                .filter(i -> "PENDING".equalsIgnoreCase(i.getStatus()))
                .count();
        long completedCount = investments.stream()
                .filter(i -> "COMPLETED".equalsIgnoreCase(i.getStatus()))
                .count();

        List<Map<String, Object>> portfolio = investments.stream().map(this::investmentDto).toList();
        List<Map<String, Object>> proposals = investments.stream()
                .map(Investment::getProposal)
                .filter(Objects::nonNull)
                .distinct()
                .map(p -> proposalDto(p, investor))
                .toList();

        List<Map<String, Object>> marketplace = publicMarketplace(investor, null, null, "newest");
        boolean approved = InvestorProfileService.isApproved(investor);
        boolean isLocked = !approved;

        double escrowHeld = pendingAmount;
        double estimatedMonthlyROI = investments.stream()
                .filter(i -> i.getProposal() != null && i.getProposal().getFundingNeeded() != null && i.getProposal().getFundingNeeded() > 0)
                .mapToDouble(i -> ((i.getAmount() == null ? 0.0 : i.getAmount()) / i.getProposal().getFundingNeeded()) * (i.getProposal().getExpectedMonthlyIncome() == null ? 0.0 : i.getProposal().getExpectedMonthlyIncome()) * 0.1)
                .sum();

        final Long currentInvestorId = investor.getId();
        List<ProposalQuestion> questionsAsked = proposalQuestionRepository.findAll().stream()
                .filter(q -> q.getInvestor() != null && currentInvestorId.equals(q.getInvestor().getId()))
                .toList();
        List<Map<String, Object>> questionDtos = questionsAsked.stream().map(this::questionDto).toList();

        Map<String, Object> data = new LinkedHashMap<>();
        data.put("investor", investorSummary(investor));
        data.put("isApproved", approved);
        data.put("isLocked", isLocked);
        data.put("portfolio", portfolio);
        data.put("investments", portfolio);
        data.put("proposals", proposals);
        data.put("marketplace", marketplace);
        data.put("questions", questionDtos);
        data.put("totalInvested", totalInvested);
        data.put("escrowHeld", escrowHeld);
        data.put("estimatedMonthlyROI", estimatedMonthlyROI);
        data.put("pendingInterestAmount", pendingAmount);
        data.put("pendingDeals", pendingCount);
        data.put("completedDeals", completedCount);
        data.put("canInvest", approved);
        data.put("needsProfileCompletion", InvestorProfileService.shouldForceProfileCompletion(investor));
        data.put("cancelPolicy", in.sp.main.Service.FundingCareService.CANCEL_POLICY);
        data.put("categories", FundingCatalog.categories());
        return ResponseEntity.ok(ok(data));
    }

    @GetMapping("/questions")
    public ResponseEntity<Map<String, Object>> questions(HttpSession session) {
        Investor inv = requireInvestor(session);
        if (inv == null) return unauthorized();
        final Long currentInvestorId = inv.getId();
        List<Map<String, Object>> items = proposalQuestionRepository.findAll().stream()
                .filter(q -> q.getInvestor() != null && currentInvestorId.equals(q.getInvestor().getId()))
                .map(this::questionDto).toList();
        return ResponseEntity.ok(ok(Map.of("questions", items, "count", items.size())));
    }

    @PostMapping("/proposals/{id}/ask")
    @Transactional
    public ResponseEntity<Map<String, Object>> askQuestion(
            @PathVariable("id") Long id,
            @RequestBody(required = false) Map<String, Object> body,
            @RequestParam(value = "question", required = false) String paramQuestion,
            HttpSession session) {
        Investor inv = requireInvestor(session);
        if (inv == null) return unauthorized();
        inv = investorRepository.findById(inv.getId()).orElse(inv);
        BusinessProposal proposal = businessProposalRepository.findById(id).orElse(null);
        if (proposal == null) {
            return badRequest("Proposal not found");
        }
        String question = trim(body != null && body.containsKey("question") ? str(body, "question") : paramQuestion);
        if (question.isBlank()) {
            return badRequest("question cannot be blank");
        }
        ProposalQuestion q = new ProposalQuestion();
        q.setProposal(proposal);
        q.setInvestor(inv);
        q.setQuestion(question);
        proposalQuestionRepository.save(q);
        return ResponseEntity.status(HttpStatus.CREATED).body(ok(Map.of(
                "message", "Question submitted successfully. The entrepreneur will answer shortly.",
                "question", questionDto(q)
        )));
    }

    @GetMapping("/proposals/{id}")
    public ResponseEntity<Map<String, Object>> getProposalDetails(@PathVariable("id") Long id, HttpSession session) {
        Investor inv = requireInvestor(session);
        if (inv == null) return unauthorized();
        inv = investorRepository.findById(inv.getId()).orElse(inv);
        BusinessProposal p = businessProposalRepository.findById(id).orElse(null);
        if (p == null) {
            return badRequest("Proposal not found");
        }
        Map<String, Object> dto = proposalDto(p, inv);
        List<Map<String, Object>> qna = proposalQuestionRepository.findByProposal(p).stream()
                .map(this::questionDto).toList();
        dto.put("questions", qna);
        return ResponseEntity.ok(ok(Map.of("proposal", dto)));
    }

    @GetMapping("/marketplace")
    public ResponseEntity<Map<String, Object>> marketplace(
            @RequestParam(value = "category", required = false) String category,
            @RequestParam(value = "city", required = false) String city,
            @RequestParam(value = "sort", required = false) String sort,
            HttpSession session) {
        Investor inv = requireInvestor(session);
        if (inv == null) return unauthorized();
        List<Map<String, Object>> marketplace = publicMarketplace(inv, category, city, sort);
        return ResponseEntity.ok(ok(Map.of(
                "marketplace", marketplace,
                "cancelPolicy", in.sp.main.Service.FundingCareService.CANCEL_POLICY,
                "categories", FundingCatalog.categories()
        )));
    }

    @PostMapping({"/proposal/{id}/create-order", "/proposals/{id}/create-order"})
    public ResponseEntity<Map<String, Object>> createOrder(
            @PathVariable("id") Long id,
            @RequestBody(required = false) Map<String, Object> body,
            HttpSession session) {
        Investor inv = requireInvestor(session);
        if (inv == null) return unauthorized();
        inv = investorRepository.findById(inv.getId()).orElse(inv);
        if (!InvestorProfileService.isApproved(inv)) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN)
                    .body(error("Investor must be verified before expressing interest"));
        }
        BusinessProposal proposal = businessProposalRepository.findById(id).orElse(null);
        if (proposal == null) return badRequest("Proposal not found");
        if (!in.sp.main.Service.FundingCareService.isPublicProposal(proposal)) {
            return badRequest("Proposal is not available for investment");
        }

        double amount = parseDouble(body == null ? null : body.get("amount"), 0.0);
        if (amount <= 0) return badRequest("amount must be greater than 0");

        double pendingAmount = investmentRepository.findByProposal(proposal).stream()
                .filter(i -> "PENDING".equalsIgnoreCase(i.getStatus()))
                .mapToDouble(i -> i.getAmount() == null ? 0.0 : i.getAmount())
                .sum();
        double fundingNeeded = proposal.getFundingNeeded() == null ? 0.0 : proposal.getFundingNeeded();
        double amountRaised = proposal.getAmountRaised() == null ? 0.0 : proposal.getAmountRaised();
        double openRemaining = fundingNeeded - amountRaised - pendingAmount;
        if (openRemaining < 0) openRemaining = 0.0;

        Investment existingPending = investmentRepository.findByInvestorAndProposal(inv, proposal).stream()
                .filter(i -> "PENDING".equalsIgnoreCase(i.getStatus()))
                .findFirst()
                .orElse(null);
        if (existingPending != null) {
            double othersPending = pendingAmount - (existingPending.getAmount() == null ? 0.0 : existingPending.getAmount());
            double remainingForUpdate = fundingNeeded - amountRaised - othersPending;
            if (amount > remainingForUpdate) {
                return badRequest("Amount exceeds remaining funding of " + Math.max(0, remainingForUpdate));
            }
        } else if (amount > openRemaining) {
            return badRequest("Amount exceeds remaining funding of " + openRemaining);
        }

        Map<String, Object> result = new LinkedHashMap<>();
        try {
            com.razorpay.RazorpayClient client = new com.razorpay.RazorpayClient(razorpayKeyId, razorpayKeySecret);
            org.json.JSONObject options = new org.json.JSONObject();
            options.put("amount", (int) (amount * 100)); // in paise
            options.put("currency", "INR");
            options.put("receipt", "inv_" + id + "_" + System.currentTimeMillis());
            com.razorpay.Order order = client.orders.create(options);

            result.put("success", true);
            result.put("orderId", order.get("id"));
            result.put("amount", order.get("amount"));
            result.put("currency", "INR");
            result.put("keyId", razorpayKeyId);
            result.put("isMock", false);
            return ResponseEntity.ok(result);
        } catch (Exception ex) {
            String mockOrderId = "order_mock_" + System.currentTimeMillis();
            result.put("success", true);
            result.put("orderId", mockOrderId);
            result.put("amount", (int) (amount * 100));
            result.put("currency", "INR");
            result.put("keyId", razorpayKeyId);
            result.put("isMock", true);
            return ResponseEntity.ok(result);
        }
    }

    @PostMapping({"/proposal/{id}/verify-payment", "/proposals/{id}/verify-payment"})
    @Transactional
    public ResponseEntity<Map<String, Object>> verifyPayment(
            @PathVariable("id") Long id,
            @RequestBody Map<String, Object> body,
            HttpSession session) {
        Investor inv = requireInvestor(session);
        if (inv == null) return unauthorized();
        inv = investorRepository.findById(inv.getId()).orElse(inv);
        if (!InvestorProfileService.isApproved(inv)) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN)
                    .body(error("Investor must be verified before expressing interest"));
        }

        String razorpayPaymentId = str(body, "razorpay_payment_id");
        String razorpayOrderId = str(body, "razorpay_order_id");
        String razorpaySignature = str(body, "razorpay_signature");
        double amount = parseDouble(body == null ? null : body.get("amount"), 0.0);

        if (amount <= 0) return badRequest("Invalid amount");

        boolean isMock = razorpayOrderId != null && razorpayOrderId.startsWith("order_mock_");
        if (!isMock && !razorpaySignature.isBlank()) {
            try {
                String message = razorpayOrderId + "|" + razorpayPaymentId;
                javax.crypto.Mac mac = javax.crypto.Mac.getInstance("HmacSHA256");
                mac.init(new javax.crypto.spec.SecretKeySpec(razorpayKeySecret.getBytes(java.nio.charset.StandardCharsets.UTF_8), "HmacSHA256"));
                byte[] hashBytes = mac.doFinal(message.getBytes(java.nio.charset.StandardCharsets.UTF_8));
                StringBuilder sb = new StringBuilder();
                for (byte b : hashBytes) sb.append(String.format("%02x", b));
                String generatedSig = sb.toString();

                if (!generatedSig.equals(razorpaySignature)) {
                    return ResponseEntity.status(400).body(error("Payment signature mismatch – possible fraud"));
                }
            } catch (Exception e) {
                return ResponseEntity.status(500).body(error("Payment verification failed: " + e.getMessage()));
            }
        }

        BusinessProposal proposal = businessProposalRepository.findById(id).orElse(null);
        if (proposal == null) return badRequest("Proposal not found");

        Investment investment = investmentRepository.findByInvestorAndProposal(inv, proposal).stream()
                .filter(i -> "PENDING".equalsIgnoreCase(i.getStatus()))
                .findFirst()
                .orElse(null);

        if (investment == null) {
            investment = new Investment();
            investment.setProposal(proposal);
            investment.setInvestor(inv);
        }

        investment.setAmount(amount);
        investment.setStatus("PENDING");
        investment.setReleasedAmount(0.0);
        investment.setAdminAmount(amount);
        investment.setRazorpayPaymentId(razorpayPaymentId);
        investment.setRazorpayOrderId(razorpayOrderId);
        investmentRepository.save(investment);

        // Milestone message in chat
        try {
            if (proposalChatMessageRepository != null) {
                ProposalChatMessage sysMsg = new ProposalChatMessage();
                sysMsg.setProposal(proposal);
                sysMsg.setInvestor(inv);
                sysMsg.setSenderRole("INVESTOR");
                sysMsg.setMessage("💰 INVESTOR PAYMENT: ₹" + String.format("%.2f", amount)
                        + " committed and transferred to Admin Escrow via Razorpay [Payment ID: " + razorpayPaymentId
                        + "]. Admin will verify and disburse funds to entrepreneur.");
                proposalChatMessageRepository.save(sysMsg);
            }
        } catch (Exception ignored) {}

        // Notify Entrepreneur
        try {
            if (proposal.getEntrepreneur() != null) {
                Entrepreneur ent = proposal.getEntrepreneur();
                if (ent.getEmail() != null && !ent.getEmail().isBlank()) {
                    emailService.sendEmail(
                            ent.getEmail(),
                            "Investment Interest: " + proposal.getTitle(),
                            "Hello " + (ent.getFullName() != null ? ent.getFullName() : "Entrepreneur")
                                    + ",\n\nGreat news! Investor " + inv.getFullName()
                                    + " has committed ₹" + String.format("%.2f", amount) + " to your proposal '" + proposal.getTitle()
                                    + "' through Razorpay Admin Escrow.\n\nOpen your Entrepreneur portal to view the details.\n\nFight D Fear Team"
                    );
                }
            }
        } catch (Exception ignored) {}

        // Notify Investor
        try {
            if (inv.getEmail() != null && !inv.getEmail().isBlank()) {
                emailService.sendEmail(
                        inv.getEmail(),
                        "Investment Held in Escrow: " + proposal.getTitle(),
                        "Hello " + inv.getFullName() + ",\n\nYour payment of ₹" + String.format("%.2f", amount)
                                + " for '" + proposal.getTitle() + "' has been successfully received and placed in Admin Escrow (Payment ID: " + razorpayPaymentId + ").\n\nThank you for supporting women entrepreneurs!\nFight D Fear"
                );
            }
        } catch (Exception ignored) {}

        Map<String, Object> out = new LinkedHashMap<>();
        out.put("success", true);
        out.put("message", "Payment of ₹" + amount + " received and held in Admin Escrow.");
        out.put("investment", investmentDto(investment));
        return ResponseEntity.ok(out);
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

    @PostMapping("/investments/{id}/withdraw")
    @Transactional
    public ResponseEntity<Map<String, Object>> withdrawInterest(@PathVariable("id") Long id, HttpSession session) {
        Investor inv = requireInvestor(session);
        if (inv == null) return unauthorized();
        Investment investment = investmentRepository.findById(id).orElse(null);
        if (investment == null || investment.getInvestor() == null
                || !investment.getInvestor().getId().equals(inv.getId())) {
            return badRequest("Investment not found");
        }
        try {
            fundingCareService.withdrawInterest(investment);
            return ResponseEntity.ok(ok(Map.of(
                    "message", "Interest withdrawn",
                    "investment", investmentDto(investment)
            )));
        } catch (org.springframework.web.server.ResponseStatusException ex) {
            return ResponseEntity.status(ex.getStatusCode()).body(error(ex.getReason()));
        }
    }

    private ResponseEntity<Map<String, Object>> createInvestment(Map<String, Object> body, HttpSession session) {
        Investor inv = requireInvestor(session);
        if (inv == null) return unauthorized();
        inv = investorRepository.findById(inv.getId()).orElse(inv);
        if (!InvestorProfileService.isApproved(inv)) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN)
                    .body(error("Investor must be verified before expressing interest"));
        }

        Long proposalId = parseLong(body == null ? null : body.get("proposalId"));
        Double amount = parseDouble(body == null ? null : body.get("amount"), null);
        if (proposalId == null) return badRequest("proposalId is required");
        if (amount == null || amount <= 0) return badRequest("amount must be greater than 0");

        BusinessProposal proposal = businessProposalRepository.findById(proposalId).orElse(null);
        if (proposal == null) return badRequest("Proposal not found");
        if (!in.sp.main.Service.FundingCareService.isPublicProposal(proposal)) {
            return badRequest("Proposal is not available for investment");
        }

        double pendingAmount = investmentRepository.findByProposal(proposal).stream()
                .filter(i -> "PENDING".equalsIgnoreCase(i.getStatus()))
                .mapToDouble(i -> i.getAmount() == null ? 0.0 : i.getAmount())
                .sum();
        double fundingNeeded = proposal.getFundingNeeded() == null ? 0.0 : proposal.getFundingNeeded();
        double amountRaised = proposal.getAmountRaised() == null ? 0.0 : proposal.getAmountRaised();
        double openRemaining = fundingNeeded - amountRaised - pendingAmount;
        if (openRemaining < 0) openRemaining = 0.0;

        Investment existingPending = investmentRepository.findByInvestorAndProposal(inv, proposal).stream()
                .filter(i -> "PENDING".equalsIgnoreCase(i.getStatus()))
                .findFirst()
                .orElse(null);
        if (existingPending != null) {
            double othersPending = pendingAmount - (existingPending.getAmount() == null ? 0.0 : existingPending.getAmount());
            double remainingForUpdate = fundingNeeded - amountRaised - othersPending;
            if (amount > remainingForUpdate) {
                return badRequest("Amount exceeds remaining funding of " + Math.max(0, remainingForUpdate));
            }
            existingPending.setAmount(amount);
            investmentRepository.save(existingPending);
            return ResponseEntity.ok(ok(Map.of(
                    "message", "Updated pending interest amount",
                    "investment", investmentDto(existingPending)
            )));
        }

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
        m.put("partnerProfileStatus", inv.getPartnerProfileStatus() == null
                ? null : inv.getPartnerProfileStatus().name());
        m.put("partnerProfileStatusLabel", InvestorProfileService.statusLabel(inv.getPartnerProfileStatus()));
        m.put("profileCompletionPct", inv.getProfileCompletionPct() == null ? 0 : inv.getProfileCompletionPct());
        m.put("rejectionReason", inv.getRejectionReason());
        m.put("changesRequestedNote", inv.getChangesRequestedNote());
        m.put("canInvest", InvestorProfileService.isApproved(inv));
        m.put("verified", InvestorProfileService.isApproved(inv));
        InvestorProfileService.putExtra(m, inv);
        m.put("cancelPolicy", in.sp.main.Service.FundingCareService.CANCEL_POLICY);
        return m;
    }

    private Map<String, Object> questionDto(ProposalQuestion q) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", q.getId());
        m.put("question", q.getQuestion());
        m.put("answer", q.getAnswer());
        m.put("createdAt", q.getCreatedAt() == null ? null : q.getCreatedAt().toString());
        if (q.getInvestor() != null) {
            m.put("investorId", q.getInvestor().getId());
            m.put("investorName", q.getInvestor().getFullName());
            m.put("investorCompany", q.getInvestor().getCompanyName());
            m.put("investorPhoto", q.getInvestor().getProfilePhoto());
        }
        if (q.getProposal() != null) {
            m.put("proposalId", q.getProposal().getId());
            m.put("proposalTitle", q.getProposal().getTitle());
        }
        return m;
    }

    private Map<String, Object> investmentDto(Investment i) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", i.getId());
        m.put("investmentId", i.getId());
        m.put("amount", i.getAmount());
        m.put("status", i.getStatus());
        m.put("createdAt", i.getCreatedAt() == null ? null : i.getCreatedAt().toString());
        m.put("canWithdraw", fundingCareService.canWithdrawInterest(i));
        m.put("canReview", "COMPLETED".equalsIgnoreCase(i.getStatus()) && i.getRating() == null);
        m.put("rating", i.getRating());
        m.put("review", i.getReview());
        m.put("cancelPolicy", in.sp.main.Service.FundingCareService.CANCEL_POLICY);
        if (i.getProposal() != null) {
            m.put("proposalId", i.getProposal().getId());
            m.put("proposalTitle", i.getProposal().getTitle());
            m.put("proposal", proposalDto(i.getProposal(), i.getInvestor()));
        }
        return m;
    }

    private Map<String, Object> proposalDto(BusinessProposal p) {
        return proposalDto(p, null);
    }

    private Map<String, Object> proposalDto(BusinessProposal p, Investor viewer) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", p.getId());
        m.put("title", p.getTitle());
        m.put("category", p.getCategory());
        m.put("location", p.getLocation());
        String city = p.getLocation();
        if (p.getEntrepreneur() != null && p.getEntrepreneur().getCity() != null) {
            city = p.getEntrepreneur().getCity();
        }
        m.put("city", city);
        m.put("description", p.getDescription());
        m.put("cancelPolicy", in.sp.main.Service.FundingCareService.CANCEL_POLICY);
        m.put("fundingNeeded", p.getFundingNeeded());
        m.put("expectedMonthlyIncome", p.getExpectedMonthlyIncome());
        double raised = p.getAmountRaised() == null ? 0.0 : p.getAmountRaised();
        m.put("amountRaised", raised);
        m.put("status", p.getStatus() == null ? null : p.getStatus().name());
        if (p.getEntrepreneur() != null) {
            m.put("entrepreneurName", p.getEntrepreneur().getFullName());
            m.put("entrepreneurId", p.getEntrepreneur().getId());
            m.put("businessName", p.getEntrepreneur().getBusinessName());
            m.put("rating", p.getEntrepreneur().getRating());
            m.put("reviewCount", p.getEntrepreneur().getReviewCount());
            m.put("galleryPhotos", p.getEntrepreneur().getGalleryPhotos());
            m.put("profileImageUrl", p.getEntrepreneur().getProfilePhoto());
        }
        double needed = p.getFundingNeeded() == null ? 0.0 : p.getFundingNeeded();
        double pendingAmount = investmentRepository.findByProposal(p).stream()
                .filter(i -> "PENDING".equalsIgnoreCase(i.getStatus()))
                .mapToDouble(i -> i.getAmount() == null ? 0.0 : i.getAmount())
                .sum();
        m.put("remaining", Math.max(0, needed - raised));
        m.put("openRemaining", Math.max(0, needed - raised - pendingAmount));
        m.put("pendingInterestAmount", pendingAmount);
        if (viewer != null) {
            investmentRepository.findByInvestorAndProposal(viewer, p).stream()
                    .filter(i -> "PENDING".equalsIgnoreCase(i.getStatus())
                            || "COMPLETED".equalsIgnoreCase(i.getStatus()))
                    .findFirst()
                    .ifPresent(i -> {
                        m.put("alreadyInterested", true);
                        m.put("myInvestmentId", i.getId());
                        m.put("myAmount", i.getAmount());
                        m.put("myStatus", i.getStatus());
                    });
            if (!m.containsKey("alreadyInterested")) {
                m.put("alreadyInterested", false);
            }
        }
        return m;
    }

    private List<Map<String, Object>> publicMarketplace(Investor viewer, String category, String city, String sort) {
        String cat = category == null ? "" : category.trim().toLowerCase(Locale.ROOT);
        String cityQ = city == null ? "" : city.trim().toLowerCase(Locale.ROOT);
        List<Map<String, Object>> items = businessProposalRepository
                .findByStatus(VerificationStatus.VERIFIED)
                .stream()
                .filter(in.sp.main.Service.FundingCareService::isPublicProposal)
                .filter(p -> FundingCatalog.matchesFilter(p.getCategory(), category))
                .map(p -> proposalDto(p, viewer))
                .filter(m -> {
                    if (!cat.isBlank() && !String.valueOf(m.getOrDefault("category", "")).toLowerCase(Locale.ROOT).contains(cat)) {
                        return false;
                    }
                    if (!cityQ.isBlank() && !String.valueOf(m.getOrDefault("city", "")).toLowerCase(Locale.ROOT).contains(cityQ)) {
                        return false;
                    }
                    return true;
                })
                .collect(java.util.stream.Collectors.toList());
        String sortKey = sort == null ? "newest" : sort.trim().toLowerCase(Locale.ROOT);
        if ("funding".equals(sortKey) || "fee".equals(sortKey) || "price".equals(sortKey)) {
            items.sort(java.util.Comparator.comparingDouble(m -> m.get("fundingNeeded") instanceof Number n ? n.doubleValue() : 0));
        } else if ("rating".equals(sortKey)) {
            items.sort(java.util.Comparator.<Map<String, Object>>comparingDouble(
                    m -> m.get("rating") instanceof Number n ? n.doubleValue() : 0).reversed());
        }
        return items;
    }

    @PostMapping("/investments/{id}/rate")
    @Transactional
    public ResponseEntity<Map<String, Object>> rate(
            @PathVariable("id") Long id, @RequestBody Map<String, Object> body, HttpSession session) {
        Investor inv = requireInvestor(session);
        if (inv == null) return unauthorized();
        Investment i = investmentRepository.findById(id).orElse(null);
        if (i == null || i.getInvestor() == null || !i.getInvestor().getId().equals(inv.getId())) {
            return badRequest("Investment not found");
        }
        int rating = body != null && body.get("rating") instanceof Number n ? n.intValue() : 5;
        String review = body == null || body.get("review") == null ? "" : String.valueOf(body.get("review"));
        try {
            fundingCareService.rate(i, rating, review);
            return ResponseEntity.ok(ok(Map.of("message", "Thanks for the review", "investment", investmentDto(i))));
        } catch (org.springframework.web.server.ResponseStatusException ex) {
            return ResponseEntity.status(ex.getStatusCode()).body(error(ex.getReason()));
        }
    }

    @PostMapping(value = "/photos", consumes = org.springframework.http.MediaType.MULTIPART_FORM_DATA_VALUE)
    @Transactional
    public ResponseEntity<Map<String, Object>> uploadPhotos(
            @RequestParam(value = "profileImage", required = false) org.springframework.web.multipart.MultipartFile profileImage,
            @RequestParam(value = "galleryPhotos", required = false) org.springframework.web.multipart.MultipartFile galleryPhotos,
            HttpSession session) {
        Investor inv = requireInvestor(session);
        if (inv == null) return unauthorized();
        inv = investorRepository.findById(inv.getId()).orElse(inv);
        try {
            if (profileImage != null && !profileImage.isEmpty()) {
                inv.setProfilePhoto(fileUploadService.saveFile(profileImage));
            }
            if (galleryPhotos != null && !galleryPhotos.isEmpty()) {
                String path = fileUploadService.saveFile(galleryPhotos);
                String existing = inv.getGalleryPhotos();
                inv.setGalleryPhotos(existing == null || existing.isBlank() ? path : existing + "," + path);
            }
            investorRepository.save(inv);
            Map<String, Object> res = new LinkedHashMap<>();
            res.put("success", true);
            res.put("message", "Photos saved");
            res.putAll(investorProfileService.profilePayload(inv));
            return ResponseEntity.ok(res);
        } catch (Exception ex) {
            return badRequest(ex.getMessage() == null ? "Upload failed" : ex.getMessage());
        }
    }
}
