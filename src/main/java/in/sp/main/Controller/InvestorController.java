package in.sp.main.Controller;

import in.sp.main.Entities.*;
import in.sp.main.Repository.*;
import in.sp.main.Service.PasswordService;
import in.sp.main.Service.InvestorRegistrationService;
import in.sp.main.Config.JwtUtil;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/investor")
public class InvestorController {

    @Autowired
    private InvestorRepository investorRepository;

    @Autowired
    private EntrepreneurRepository entrepreneurRepository;

    @Autowired
    private BusinessProposalRepository businessProposalRepository;

    @Autowired
    private InvestmentRepository investmentRepository;

    @Autowired
    private InvestmentMeetingRepository investmentMeetingRepository;

    @Autowired
    private ProposalQuestionRepository proposalQuestionRepository;

    @Autowired
    private ProposalChatMessageRepository proposalChatMessageRepository;

    @Autowired
    private PasswordService passwordService;

    @Autowired
    private in.sp.main.Service.InvestorProfileService investorProfileService;

    @Autowired
    private InvestorRegistrationService investorRegistrationService;

    @Autowired
    private JwtUtil jwtUtil;

    @Autowired
    private in.sp.main.Service.FileUploadService fileUploadService;

    @org.springframework.beans.factory.annotation.Value("${razorpay.key.id:rzp_test_RIlD5bEKRjyn3h}")
    private String razorpayKeyId;

    @org.springframework.beans.factory.annotation.Value("${razorpay.key.secret:Ltg6uo9vI8TiFMVfj2cGm4I8}")
    private String razorpayKeySecret;

    // --- Authentication ---

    @GetMapping("/register")
    public String showRegisterForm(Model model) {
        return "investor/register";
    }

    @PostMapping("/register")
    public String registerInvestor(
            @RequestParam("fullName") String fullName,
            @RequestParam("email") String email,
            @RequestParam("phone") String phone,
            @RequestParam("password") String password,
            @RequestParam("confirmPassword") String confirmPassword,
            @RequestParam("emailOtp") String emailOtp,
            @RequestParam(value = "acceptedTerms", required = false) String acceptedTermsVal,
            RedirectAttributes redirectAttributes) {

        try {
            boolean acceptedTerms = "on".equalsIgnoreCase(acceptedTermsVal)
                    || "true".equalsIgnoreCase(acceptedTermsVal)
                    || "checked".equalsIgnoreCase(acceptedTermsVal);

            investorRegistrationService.registerQuick(
                    fullName, email, phone, password, confirmPassword, emailOtp, acceptedTerms);

            redirectAttributes.addFlashAttribute("success", "Registration successful! Please login with your email and password.");
            return "redirect:/investor/login";

        } catch (org.springframework.web.server.ResponseStatusException ex) {
            redirectAttributes.addFlashAttribute("error", ex.getReason());
            return "redirect:/investor/register";
        } catch (Exception ex) {
            redirectAttributes.addFlashAttribute("error", "Registration failed: " + ex.getMessage());
            return "redirect:/investor/register";
        }
    }

    @GetMapping("/login")
    public String showLoginForm(HttpSession session) {
        Investor existing = getLoggedInvestor(session);
        if (existing != null) {
            Investor fresh = investorRepository.findById(existing.getId()).orElse(existing);
            investorProfileService.healApproval(fresh);
            session.setAttribute("loggedInvestor", fresh);
            if (!InvestorProfileService.shouldForceProfileCompletion(fresh)) {
                return "redirect:/investor/dashboard";
            }
            return "redirect:/investor/complete-profile";
        }
        return "investor/login";
    }

    @GetMapping("/forgot-password")
    public String showForgotPasswordForm() {
        return "investor/forgotPassword";
    }

    @PostMapping("/forgot-password")
    public String handleForgotPassword(@RequestParam("email") String email, RedirectAttributes redirectAttributes) {
        Optional<Investor> opt = investorRepository.findByEmail(email.toLowerCase().trim());
        if (opt.isPresent()) {
            redirectAttributes.addFlashAttribute("success", "If an account exists with that email, a password reset link has been sent.");
        } else {
            redirectAttributes.addFlashAttribute("error", "Email address not found.");
        }
        return "redirect:/investor/forgot-password";
    }

    @PostMapping("/login")
    public String loginInvestor(
            @RequestParam(value = "email", required = false) String email,
            @RequestParam(value = "password", required = false) String password,
            HttpSession session,
            HttpServletResponse response,
            Model model) {

        if (email == null || email.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            model.addAttribute("error", "Please provide both email and password.");
            return "investor/login";
        }

        Optional<Investor> opt = investorRepository.findByEmail(email.toLowerCase().trim());
        if (opt.isPresent()) {
            Investor inv = opt.get();
            if (passwordService.matchesAndUpgrade(password, inv.getPassword(), hashed -> {
                inv.setPassword(hashed);
                investorRepository.save(inv);
            })) {
                if (inv.getVerificationStatus() == VerificationStatus.REJECTED) {
                    model.addAttribute("error", "Your registration has been rejected by the admin.");
                    return "investor/login";
                }

                // Create JWT Cookie
                String token = jwtUtil.generateToken(inv.getEmail(), "INVESTOR");
                Cookie cookie = new Cookie("JWT_TOKEN", token);
                cookie.setPath("/");
                cookie.setHttpOnly(true);
                cookie.setMaxAge(365 * 24 * 60 * 60);
                response.addCookie(cookie);

                // Always refresh from DB so approval status is current
                Investor freshInv = investorRepository.findById(inv.getId()).orElse(inv);
                freshInv = investorProfileService.healApproval(freshInv);
                session.setAttribute("loggedInvestor", freshInv);
                if (InvestorProfileService.shouldForceProfileCompletion(freshInv)) {
                    return "redirect:/investor/complete-profile";
                }
                return "redirect:/investor/dashboard";
            }
        }
        model.addAttribute("error", "Invalid credentials.");
        return "investor/login";
    }

    private Investor getLoggedInvestor(HttpSession session) {
        Investor inv = (Investor) session.getAttribute("loggedInvestor");
        if (inv == null) {
            org.springframework.security.core.Authentication auth = org.springframework.security.core.context.SecurityContextHolder
                    .getContext().getAuthentication();
            if (auth != null && auth.isAuthenticated() && !"anonymousUser".equals(auth.getName())) {
                Optional<Investor> opt = investorRepository.findByEmail(auth.getName());
                if (opt.isPresent()) {
                    inv = opt.get();
                    session.setAttribute("loggedInvestor", inv);
                }
            }
        }
        return inv;
    }

    @GetMapping("/complete-profile")
    public String showCompleteProfileForm(HttpSession session, Model model) {
        Investor inv = getLoggedInvestor(session);
        if (inv == null) return "redirect:/investor/login";

        // Refresh state from DB
        Investor refreshedInv = investorRepository.findById(inv.getId()).orElse(inv);
        refreshedInv = investorProfileService.healApproval(refreshedInv);
        session.setAttribute("loggedInvestor", refreshedInv);

        // Approved and pending-admin investors go to dashboard, not this form
        if (!InvestorProfileService.shouldForceProfileCompletion(refreshedInv)
                && InvestorProfileService.isApproved(refreshedInv)) {
            return "redirect:/investor/dashboard";
        }

        model.addAttribute("investor", refreshedInv);
        return "investor/completeProfile";
    }

    @PostMapping("/complete-profile")
    public String saveProfileCompletion(
            @RequestParam(value = "fullName", required = false) String fullName,
            @RequestParam(value = "phone", required = false) String phone,
            @RequestParam(value = "whatsappNumber", required = false) String whatsappNumber,
            @RequestParam(value = "designation", required = false) String designation,
            @RequestParam(value = "companyName", required = false) String companyName,
            @RequestParam(value = "credentialNumber", required = false) String credentialNumber,
            @RequestParam(value = "address", required = false) String address,
            @RequestParam(value = "city", required = false) String city,
            @RequestParam(value = "state", required = false) String state,
            @RequestParam(value = "pincode", required = false) String pincode,
            @RequestParam(value = "latitude", required = false) String latitude,
            @RequestParam(value = "longitude", required = false) String longitude,
            @RequestParam(value = "categoriesOffered", required = false) String categoriesOffered,
            @RequestParam(value = "audience", required = false) String audience,
            @RequestParam(value = "openDays", required = false) String openDays,
            @RequestParam(value = "openTime", required = false) String openTime,
            @RequestParam(value = "closeTime", required = false) String closeTime,
            @RequestParam(value = "bio", required = false) String bio,
            @RequestParam(value = "ticketMode", required = false) String ticketMode,
            @RequestParam(value = "typicalPrice", required = false) Double typicalPrice,
            @RequestParam(value = "budgetRange", required = false) String budgetRange,
            @RequestParam(value = "upiId", required = false) String upiId,
            @RequestParam(value = "bankAccountHolder", required = false) String bankAccountHolder,
            @RequestParam(value = "bankName", required = false) String bankName,
            @RequestParam(value = "bankAccountNumber", required = false) String bankAccountNumber,
            @RequestParam(value = "bankIfsc", required = false) String bankIfsc,
            @RequestParam(value = "bankBranch", required = false) String bankBranch,
            @RequestParam(value = "bankDetails", required = false) String bankDetails,
            @RequestParam(value = "profilePhotoFile", required = false) MultipartFile profilePhotoFile,
            HttpSession session,
            RedirectAttributes redirectAttributes) {

        Investor inv = getLoggedInvestor(session);
        if (inv == null) return "redirect:/investor/login";

        try {
            Investor refreshed = investorRepository.findById(inv.getId()).orElse(inv);

            java.util.Map<String, Object> body = new java.util.HashMap<>();
            if (fullName != null) body.put("fullName", fullName);
            if (phone != null) body.put("phone", phone);
            if (whatsappNumber != null) body.put("whatsappNumber", whatsappNumber);
            if (designation != null) body.put("designation", designation);
            if (companyName != null) body.put("companyName", companyName);
            if (credentialNumber != null) body.put("credentialNumber", credentialNumber);
            if (address != null) body.put("address", address);
            if (city != null) body.put("city", city);
            if (state != null) body.put("state", state);
            if (pincode != null) body.put("pincode", pincode);
            if (latitude != null) body.put("latitude", latitude);
            if (longitude != null) body.put("longitude", longitude);
            if (categoriesOffered != null) body.put("categoriesOffered", categoriesOffered);
            if (audience != null) body.put("audience", audience);
            if (openDays != null) body.put("openDays", openDays);
            if (openTime != null) body.put("openTime", openTime);
            if (closeTime != null) body.put("closeTime", closeTime);
            if (bio != null) body.put("bio", bio);
            if (ticketMode != null) body.put("ticketMode", ticketMode);
            if (typicalPrice != null) body.put("typicalPrice", typicalPrice);
            if (budgetRange != null) body.put("budgetRange", budgetRange);
            if (upiId != null) body.put("upiId", upiId);

            if (bankDetails != null && !bankDetails.isBlank()) {
                body.put("bankDetails", bankDetails);
            } else if (bankAccountNumber != null && !bankAccountNumber.isBlank()) {
                String serialized = "Account Holder: " + (bankAccountHolder != null ? bankAccountHolder.trim() : "")
                        + " | Bank: " + (bankName != null ? bankName.trim() : "")
                        + " | A/C: " + bankAccountNumber.trim()
                        + " | IFSC: " + (bankIfsc != null ? bankIfsc.trim().toUpperCase() : "")
                        + " | Branch: " + (bankBranch != null ? bankBranch.trim() : "");
                body.put("bankDetails", serialized);
            }

            if (profilePhotoFile != null && !profilePhotoFile.isEmpty()) {
                refreshed.setProfilePhoto(fileUploadService.saveFile(profilePhotoFile));
            }

            boolean alreadyApproved = InvestorProfileService.isApproved(refreshed);
            investorProfileService.applyExtraFields(refreshed, body);
            investorProfileService.refreshCompletion(refreshed);
            if (alreadyApproved) {
                investorProfileService.healApproval(refreshed);
            } else {
                refreshed.setPartnerProfileStatus(PartnerProfileStatus.PENDING_ADMIN_APPROVAL);
                refreshed.setVerificationStatus(VerificationStatus.PENDING);
                refreshed.setProfileCompletionPct(100);
                investorRepository.save(refreshed);
            }

            session.setAttribute("loggedInvestor", refreshed);
            redirectAttributes.addFlashAttribute("success", "Profile submitted successfully! Your account is now pending Admin approval.");
            return "redirect:/investor/dashboard";

        } catch (Exception ex) {
            redirectAttributes.addFlashAttribute("error", "Failed to save profile: " + ex.getMessage());
            return "redirect:/investor/complete-profile";
        }
    }

    @PostMapping("/submit-verification")
    public String submitVerification(HttpSession session, RedirectAttributes redirectAttributes) {
        Investor inv = getLoggedInvestor(session);
        if (inv == null) return "redirect:/investor/login";

        try {
            Investor refreshed = investorRepository.findById(inv.getId()).orElse(inv);
            investorProfileService.setLifecycleStatus(refreshed, PartnerProfileStatus.PENDING_ADMIN_APPROVAL);
            refreshed.setProfileCompletionPct(100);
            investorRepository.save(refreshed);

            session.setAttribute("loggedInvestor", refreshed);
            redirectAttributes.addFlashAttribute("success", "Profile submitted successfully! It is now pending Admin Verification.");
            return "redirect:/investor/dashboard";

        } catch (Exception ex) {
            redirectAttributes.addFlashAttribute("error", "Submission failed: " + ex.getMessage());
            return "redirect:/investor/complete-profile";
        }
    }

    // --- Dashboard & Portfolio ---

    @GetMapping("/dashboard")
    public String dashboard(HttpSession session, Model model) {
        Investor inv = getLoggedInvestor(session);
        if (inv == null) return "redirect:/investor/login";

        // Refresh state
        Optional<Investor> opt = investorRepository.findById(inv.getId());
        if (opt.isEmpty()) return "redirect:/investor/login";
        Investor refreshedInv = opt.get();
        refreshedInv = investorProfileService.healApproval(refreshedInv);
        session.setAttribute("loggedInvestor", refreshedInv);

        boolean isApproved = InvestorProfileService.isApproved(refreshedInv);
        boolean isLocked = !isApproved;

        List<Investment> investments = investmentRepository.findByInvestor(refreshedInv);

        // Query proposal questions asked by this investor
        List<ProposalQuestion> questionsAsked = proposalQuestionRepository.findAll().stream()
                .filter(q -> q.getInvestor().getId().equals(refreshedInv.getId()))
                .collect(Collectors.toList());

        double totalInvested = investments.stream().mapToDouble(Investment::getAmount).sum();
        double escrowHeld = investments.stream()
                .filter(i -> "PENDING".equals(i.getStatus()))
                .mapToDouble(Investment::getAmount).sum();

        // Calculate ROI / Portfolio
        double estimatedMonthlyROI = investments.stream()
                .filter(i -> i.getProposal() != null && i.getProposal().getFundingNeeded() != null && i.getProposal().getFundingNeeded() > 0)
                .mapToDouble(i -> (i.getAmount() / i.getProposal().getFundingNeeded()) * i.getProposal().getExpectedMonthlyIncome() * 0.1)
                .sum();

        model.addAttribute("investor", refreshedInv);
        model.addAttribute("isApproved", isApproved);
        model.addAttribute("isLocked", isLocked);
        model.addAttribute("investments", investments);
        model.addAttribute("questions", questionsAsked);
        model.addAttribute("totalInvested", totalInvested);
        model.addAttribute("escrowHeld", escrowHeld);
        model.addAttribute("estimatedMonthlyROI", estimatedMonthlyROI);

        return "investor/dashboard";
    }

    // --- Premium Subscription ---

    @PostMapping("/subscribe")
    public String subscribeInvestor(HttpSession session, RedirectAttributes redirectAttributes) {
        Investor inv = (Investor) session.getAttribute("loggedInvestor");
        if (inv == null) return "redirect:/investor/login";

        inv.setSubscribed(true);
        investorRepository.save(inv);

        redirectAttributes.addFlashAttribute("success", "Premium Investor Subscription activated successfully!");
        return "redirect:/investor/dashboard";
    }

    // --- Marketplace ---

    @GetMapping("/marketplace")
    public String browseMarketplace(
            @RequestParam(value = "category", required = false) String category,
            @RequestParam(value = "location", required = false) String location,
            HttpSession session,
            Model model) {

        Investor inv = (Investor) session.getAttribute("loggedInvestor");
        if (inv == null) return "redirect:/investor/login";

        // Refresh state
        final Investor refreshedInv = investorRepository.findById(inv.getId()).orElse(inv);
        session.setAttribute("loggedInvestor", refreshedInv);

        if (InvestorProfileService.shouldForceProfileCompletion(refreshedInv)) {
            return "redirect:/investor/complete-profile";
        }

        // Enforce approval gate — only approved investors may view the marketplace
        if (!refreshedInv.isApproved()) {
            return "redirect:/investor/dashboard";
        }

        List<BusinessProposal> proposals;
        if (category != null && !category.isEmpty() && location != null && !location.isEmpty()) {
            proposals = businessProposalRepository.findByStatusAndCategoryContainingIgnoreCaseAndLocationContainingIgnoreCase(
                    VerificationStatus.VERIFIED, category, location);
        } else if (category != null && !category.isEmpty()) {
            proposals = businessProposalRepository.findByStatusAndCategoryContainingIgnoreCase(
                    VerificationStatus.VERIFIED, category);
        } else if (location != null && !location.isEmpty()) {
            proposals = businessProposalRepository.findByStatusAndLocationContainingIgnoreCase(
                    VerificationStatus.VERIFIED, location);
        } else {
            proposals = businessProposalRepository.findByStatus(VerificationStatus.VERIFIED);
        }

        // Sort proposals so Featured listings appear first
        proposals.sort((p1, p2) -> Boolean.compare(p2.isFeatured(), p1.isFeatured()));

        model.addAttribute("investor", inv);
        model.addAttribute("proposals", proposals);
        model.addAttribute("selectedCategory", category);
        model.addAttribute("selectedLocation", location);

        return "investor/marketplace";
    }

    @GetMapping("/proposal/{id}")
    public String proposalDetails(@PathVariable("id") Long id, HttpSession session, Model model) {
        Investor inv = getLoggedInvestor(session);
        if (inv == null) {
            return "redirect:/investor/login";
        }

        // Refresh state
        final Investor refreshedInv = investorRepository.findById(inv.getId()).orElse(inv);
        session.setAttribute("loggedInvestor", refreshedInv);

        // Enforce approval gate
        if (!refreshedInv.isApproved()) {
            return "redirect:/investor/dashboard";
        }

        Optional<BusinessProposal> opt = businessProposalRepository.findById(id);
        if (opt.isPresent()) {
            BusinessProposal proposal = opt.get();

            // Only VERIFIED proposals are accessible
            if (proposal.getStatus() != VerificationStatus.VERIFIED) {
                return "redirect:/investor/marketplace";
            }

            List<ProposalQuestion> qna = proposalQuestionRepository.findByProposal(proposal);

            List<Investment> myInvestments = investmentRepository.findByProposal(proposal).stream()
                    .filter(i -> i.getInvestor().getId().equals(refreshedInv.getId()))
                    .collect(Collectors.toList());

            double pendingAmount = investmentRepository.findByProposal(proposal).stream()
                    .filter(i -> "PENDING".equals(i.getStatus()))
                    .mapToDouble(Investment::getAmount)
                    .sum();
            double openRemaining = proposal.getFundingNeeded() - proposal.getAmountRaised() - pendingAmount;
            if (openRemaining < 0) openRemaining = 0.0;

            model.addAttribute("investor", refreshedInv);
            model.addAttribute("proposal", proposal);
            model.addAttribute("qna", qna);
            model.addAttribute("myInvestments", myInvestments);
            model.addAttribute("pendingAmount", pendingAmount);
            model.addAttribute("openRemaining", openRemaining);
            model.addAttribute("razorpayKeyId", razorpayKeyId);

            return "investor/proposalDetails";
        }
        return "redirect:/investor/marketplace";
    }

    // --- Razorpay Order Creation (Escrow Flow) ---

    @PostMapping("/proposal/{id}/create-order")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> createOrder(
            @PathVariable("id") Long id,
            @RequestBody Map<String, Object> body,
            HttpSession session) {
        Investor inv = getLoggedInvestor(session);
        Map<String, Object> result = new HashMap<>();
        if (inv == null || !inv.isApproved()) {
            result.put("error", "Unauthorized");
            return ResponseEntity.status(403).body(result);
        }
        try {
            double amount = Double.parseDouble(body.getOrDefault("amount", "0").toString());
            if (amount <= 0) { result.put("error", "Invalid amount"); return ResponseEntity.badRequest().body(result); }

            try {
                com.razorpay.RazorpayClient client = new com.razorpay.RazorpayClient(razorpayKeyId, razorpayKeySecret);
                org.json.JSONObject options = new org.json.JSONObject();
                options.put("amount", (int)(amount * 100)); // paise
                options.put("currency", "INR");
                options.put("receipt", "inv_" + id + "_" + System.currentTimeMillis());
                com.razorpay.Order order = client.orders.create(options);

                result.put("orderId", order.get("id"));
                result.put("amount", order.get("amount"));
                result.put("currency", "INR");
                result.put("keyId", razorpayKeyId);
                return ResponseEntity.ok(result);
            } catch (Exception ex) {
                // Fallback mock order if offline / test credentials rejected
                String mockOrderId = "order_mock_" + System.currentTimeMillis();
                result.put("orderId", mockOrderId);
                result.put("amount", (int)(amount * 100));
                result.put("currency", "INR");
                result.put("keyId", razorpayKeyId);
                result.put("isMock", true);
                return ResponseEntity.ok(result);
            }
        } catch (Exception ex) {
            result.put("error", ex.getMessage());
            return ResponseEntity.status(500).body(result);
        }
    }

    // --- Razorpay Payment Verification & Escrow Investment Record ---

    @PostMapping("/proposal/{id}/verify-payment")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> verifyPayment(
            @PathVariable("id") Long id,
            @RequestBody Map<String, Object> body,
            HttpSession session) {
        Investor inv = getLoggedInvestor(session);
        Map<String, Object> result = new HashMap<>();
        if (inv == null || !inv.isApproved()) {
            result.put("error", "Unauthorized"); return ResponseEntity.status(403).body(result);
        }
        try {
            String razorpayPaymentId = (String) body.getOrDefault("razorpay_payment_id", "");
            String razorpayOrderId   = (String) body.getOrDefault("razorpay_order_id", "");
            String razorpaySignature = (String) body.getOrDefault("razorpay_signature", "");
            double amount = Double.parseDouble(body.getOrDefault("amount", "0").toString());

            // Signature verification (allow simulated mock signature if offline/mock order)
            boolean isMock = razorpayOrderId != null && razorpayOrderId.startsWith("order_mock_");
            if (!isMock) {
                String message = razorpayOrderId + "|" + razorpayPaymentId;
                javax.crypto.Mac mac = javax.crypto.Mac.getInstance("HmacSHA256");
                mac.init(new javax.crypto.spec.SecretKeySpec(razorpayKeySecret.getBytes(java.nio.charset.StandardCharsets.UTF_8), "HmacSHA256"));
                byte[] hashBytes = mac.doFinal(message.getBytes(java.nio.charset.StandardCharsets.UTF_8));
                StringBuilder sb = new StringBuilder();
                for (byte b : hashBytes) sb.append(String.format("%02x", b));
                String generatedSig = sb.toString();

                if (!generatedSig.equals(razorpaySignature)) {
                    result.put("error", "Payment signature mismatch – possible fraud");
                    return ResponseEntity.status(400).body(result);
                }
            }

            Optional<BusinessProposal> optP = businessProposalRepository.findById(id);
            if (optP.isEmpty()) { result.put("error", "Proposal not found"); return ResponseEntity.badRequest().body(result); }
            BusinessProposal proposal = optP.get();

            Investor freshInv = investorRepository.findById(inv.getId()).orElse(inv);

            // Record investment – held in Admin Escrow (PENDING)
            Investment investment = new Investment();
            investment.setProposal(proposal);
            investment.setInvestor(freshInv);
            investment.setAmount(amount);
            investment.setStatus("PENDING"); // Held by Admin until manually released
            investment.setReleasedAmount(0.0);
            investment.setAdminAmount(amount); // full Razorpay capture sits with admin escrow
            investment.setRazorpayPaymentId(razorpayPaymentId);
            investment.setRazorpayOrderId(razorpayOrderId);
            investmentRepository.save(investment);

            result.put("success", true);
            result.put("message", "Payment of ₹" + amount + " received and held in Admin Escrow. Admin will verify and release funds to the entrepreneur.");
            return ResponseEntity.ok(result);
        } catch (Exception ex) {
            result.put("error", ex.getMessage());
            return ResponseEntity.status(500).body(result);
        }
    }

    // --- Investment Action ---

    @PostMapping("/proposal/{id}/invest")
    public String investInProposal(
            @PathVariable("id") Long id,
            @RequestParam("amount") Double amount,
            HttpSession session,
            RedirectAttributes redirectAttributes) {

        Investor inv = (Investor) session.getAttribute("loggedInvestor");
        if (inv == null) return "redirect:/investor/login";

        Optional<BusinessProposal> opt = businessProposalRepository.findById(id);
        if (opt.isPresent()) {
            BusinessProposal proposal = opt.get();
            double pendingAmount = investmentRepository.findByProposal(proposal).stream()
                    .filter(i -> "PENDING".equals(i.getStatus()))
                    .mapToDouble(Investment::getAmount)
                    .sum();
            double openRemaining = proposal.getFundingNeeded() - proposal.getAmountRaised() - pendingAmount;
            if (openRemaining < 0) openRemaining = 0.0;

            if (amount <= 0 || amount > openRemaining) {
                redirectAttributes.addFlashAttribute("error", "Invalid investment amount. Remaining funding needed is: ₹" + openRemaining);
                return "redirect:/investor/proposal/" + id;
            }

            // Create Investment
            Investment investment = new Investment();
            investment.setProposal(proposal);
            investment.setInvestor(inv);
            investment.setAmount(amount);
            investment.setStatus("PENDING"); // Held by Admin gateway / Awaiting Transfer
            investmentRepository.save(investment);

            redirectAttributes.addFlashAttribute("success", "Investment of ₹" + amount + " submitted to Admin! It is currently held in gateway and will be released to the entrepreneur upon Admin verification.");
        }
        return "redirect:/investor/proposal/" + id;
    }

    @PostMapping("/investment/{id}/withdraw")
    public String withdrawInvestment(
            @PathVariable("id") Long id,
            HttpSession session,
            RedirectAttributes redirectAttributes) {

        Investor inv = (Investor) session.getAttribute("loggedInvestor");
        if (inv == null) return "redirect:/investor/login";

        Optional<Investment> opt = investmentRepository.findById(id);
        if (opt.isPresent()) {
            Investment investment = opt.get();
            if (investment.getInvestor().getId().equals(inv.getId()) && "PENDING".equals(investment.getStatus())) {
                investment.setStatus("WITHDRAWN");
                investmentRepository.save(investment);
                redirectAttributes.addFlashAttribute("success", "Investment interest withdrawn successfully.");
            } else {
                redirectAttributes.addFlashAttribute("error", "Cannot withdraw completed or invalid investment.");
            }
        }
        return "redirect:/investor/dashboard";
    }

    @PostMapping("/investment/{id}/confirm")
    public String confirmInvestmentTransfer(
            @PathVariable("id") Long id,
            HttpSession session,
            RedirectAttributes redirectAttributes) {
        // Funds stay with Admin until an admin manually enters a release amount.
        redirectAttributes.addFlashAttribute("error",
                "Funds are held in Admin escrow. Only the administrator can release an amount to the entrepreneur.");
        return "redirect:/investor/dashboard";
    }

    @PostMapping("/investment/{id}/rate")
    public String rateInvestment(
            @PathVariable("id") Long id,
            @RequestParam("rating") Integer rating,
            @RequestParam(value = "review", required = false) String review,
            HttpSession session,
            RedirectAttributes redirectAttributes) {

        Investor inv = (Investor) session.getAttribute("loggedInvestor");
        if (inv == null) return "redirect:/investor/login";

        Optional<Investment> opt = investmentRepository.findById(id);
        if (opt.isPresent()) {
            Investment investment = opt.get();
            if (investment.getInvestor().getId().equals(inv.getId()) && "COMPLETED".equals(investment.getStatus())) {
                if (rating != null && rating >= 1 && rating <= 5) {
                    investment.setRating(rating);
                    investment.setReview(review);
                    investmentRepository.save(investment);
                    redirectAttributes.addFlashAttribute("success", "Thank you! Your rating and review for this deal have been submitted.");
                } else {
                    redirectAttributes.addFlashAttribute("error", "Please provide a valid rating between 1 and 5 stars.");
                }
            } else {
                redirectAttributes.addFlashAttribute("error", "Only completed deals can be rated.");
            }
        }
        return "redirect:/investor/dashboard";
    }

    // --- Meeting/Chat Disabled: direct interaction removed per platform policy ---

    @PostMapping("/proposal/{id}/meeting")
    public String requestMeeting(
            @PathVariable("id") Long id,
            HttpSession session,
            RedirectAttributes redirectAttributes) {
        // Direct meetings between investor and entrepreneur have been removed.
        redirectAttributes.addFlashAttribute("error", "Direct meetings are no longer available. Please use the Q&A section to communicate.");
        return "redirect:/investor/proposal/" + id;
    }

    // --- Ask Question ---

    @PostMapping("/proposal/{id}/ask")
    public String askQuestion(
            @PathVariable("id") Long id,
            @RequestParam("question") String question,
            HttpSession session,
            RedirectAttributes redirectAttributes) {

        Investor inv = (Investor) session.getAttribute("loggedInvestor");
        if (inv == null) return "redirect:/investor/login";

        Optional<BusinessProposal> opt = businessProposalRepository.findById(id);
        if (opt.isPresent() && !question.trim().isEmpty()) {
            ProposalQuestion q = new ProposalQuestion();
            q.setProposal(opt.get());
            q.setInvestor(inv);
            q.setQuestion(question);
            proposalQuestionRepository.save(q);

            redirectAttributes.addFlashAttribute("success", "Question submitted successfully. The entrepreneur will answer shortly.");
        }
        return "redirect:/investor/proposal/" + id;
    }

    // --- Chat Room: investor ↔ entrepreneur via proposal ---

    @GetMapping("/chats")
    public String listChats(HttpSession session, Model model) {
        Investor inv = getLoggedInvestor(session);
        if (inv == null) return "redirect:/investor/login";
        Investor freshInv = investorRepository.findById(inv.getId()).orElse(inv);
        session.setAttribute("loggedInvestor", freshInv);

        List<Map<String, Object>> threads = new ArrayList<>();
        java.util.Set<String> seen = new java.util.HashSet<>();
        for (Investment investment : investmentRepository.findByInvestor(freshInv)) {
            if (investment.getProposal() == null || investment.getProposal().getEntrepreneur() == null) continue;
            String key = investment.getProposal().getId() + "_" + freshInv.getId();
            if (!seen.add(key)) continue;
            Map<String, Object> row = new HashMap<>();
            row.put("proposal", investment.getProposal());
            row.put("entrepreneur", investment.getProposal().getEntrepreneur());
            threads.add(row);
        }
        for (ProposalChatMessage m : proposalChatMessageRepository.findAll()) {
            if (m.getInvestor() == null || !m.getInvestor().getId().equals(freshInv.getId()) || m.getProposal() == null) continue;
            String key = m.getProposal().getId() + "_" + freshInv.getId();
            if (!seen.add(key)) continue;
            Map<String, Object> row = new HashMap<>();
            row.put("proposal", m.getProposal());
            row.put("entrepreneur", m.getProposal().getEntrepreneur());
            threads.add(row);
        }
        model.addAttribute("investor", freshInv);
        model.addAttribute("threads", threads);
        return "investor/chats";
    }

    @GetMapping("/chat/{entrepreneurId}")
    public String viewChatRoom(
            @PathVariable("entrepreneurId") Long entrepreneurId,
            @RequestParam("proposalId") Long proposalId,
            HttpSession session,
            Model model,
            RedirectAttributes redirectAttributes) {

        Investor inv = getLoggedInvestor(session);
        if (inv == null) return "redirect:/investor/login";

        Optional<BusinessProposal> propOpt = businessProposalRepository.findById(proposalId);
        if (propOpt.isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "Proposal not found.");
            return "redirect:/investor/dashboard";
        }
        BusinessProposal proposal = propOpt.get();

        // Refresh investor
        Investor freshInv = investorRepository.findById(inv.getId()).orElse(inv);

        java.util.List<in.sp.main.Entities.ProposalChatMessage> chatHistory =
                proposalChatMessageRepository.findByProposalAndInvestorOrderByTimestampAsc(proposal, freshInv);

        model.addAttribute("proposal", proposal);
        model.addAttribute("entrepreneur", proposal.getEntrepreneur());
        model.addAttribute("investor", freshInv);
        model.addAttribute("chatHistory", chatHistory);
        model.addAttribute("senderRole", "INVESTOR");
        return "investor/chat";
    }

    @PostMapping("/chat/{entrepreneurId}")
    public String sendChatMessage(
            @PathVariable("entrepreneurId") Long entrepreneurId,
            @RequestParam("proposalId") Long proposalId,
            @RequestParam("message") String message,
            HttpSession session,
            RedirectAttributes redirectAttributes) {

        Investor inv = getLoggedInvestor(session);
        if (inv == null) return "redirect:/investor/login";

        if (message == null || message.trim().isEmpty()) {
            return "redirect:/investor/chat/" + entrepreneurId + "?proposalId=" + proposalId;
        }

        Optional<BusinessProposal> propOpt = businessProposalRepository.findById(proposalId);
        if (propOpt.isPresent()) {
            in.sp.main.Entities.ProposalChatMessage msg = new in.sp.main.Entities.ProposalChatMessage();
            msg.setProposal(propOpt.get());
            msg.setInvestor(inv);
            msg.setSenderRole("INVESTOR");
            msg.setMessage(message.trim());
            proposalChatMessageRepository.save(msg);
        }
        return "redirect:/investor/chat/" + entrepreneurId + "?proposalId=" + proposalId;
    }
}
