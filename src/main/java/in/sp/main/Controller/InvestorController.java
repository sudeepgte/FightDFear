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
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
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

            redirectAttributes.addFlashAttribute("success", "Registration successful! You will be able to log in once verified by Admin.");
            return "redirect:/admin/pending-proposals";

        } catch (org.springframework.web.server.ResponseStatusException ex) {
            redirectAttributes.addFlashAttribute("error", ex.getReason());
            return "redirect:/investor/register";
        } catch (Exception ex) {
            redirectAttributes.addFlashAttribute("error", "Registration failed: " + ex.getMessage());
            return "redirect:/investor/register";
        }
    }

    @GetMapping("/login")
    public String showLoginForm() {
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
            @RequestParam("email") String email,
            @RequestParam("password") String password,
            HttpSession session,
            HttpServletResponse response,
            Model model) {

        Optional<Investor> opt = investorRepository.findByEmail(email.toLowerCase().trim());
        if (opt.isPresent()) {
            Investor inv = opt.get();
            if (passwordService.matchesAndUpgrade(password, inv.getPassword(), hashed -> {
                inv.setPassword(hashed);
                investorRepository.save(inv);
            })) {
                if (inv.getVerificationStatus() == VerificationStatus.PENDING) {
                    model.addAttribute("error", "Your profile is pending admin approval and verification.");
                    return "investor/login";
                }
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

                session.setAttribute("loggedInvestor", inv);
                return "redirect:/investor/dashboard";
            }
        }
        model.addAttribute("error", "Invalid credentials.");
        return "investor/login";
    }

    @GetMapping("/complete-profile")
    public String showCompleteProfileForm(HttpSession session, Model model) {
        Investor inv = (Investor) session.getAttribute("loggedInvestor");
        if (inv == null) return "redirect:/investor/login";

        // Refresh state
        Investor refreshedInv = investorRepository.findById(inv.getId()).orElse(inv);
        session.setAttribute("loggedInvestor", refreshedInv);

        model.addAttribute("investor", refreshedInv);
        return "investor/completeProfile";
    }

    @PostMapping("/complete-profile")
    public String saveProfileCompletion(
            @RequestParam(value = "fullName", required = false) String fullName,
            @RequestParam(value = "phone", required = false) String phone,
            @RequestParam(value = "designation", required = false) String designation,
            @RequestParam(value = "companyName", required = false) String companyName,
            @RequestParam(value = "credentialNumber", required = false) String credentialNumber,
            @RequestParam(value = "address", required = false) String address,
            @RequestParam(value = "city", required = false) String city,
            @RequestParam(value = "state", required = false) String state,
            @RequestParam(value = "pincode", required = false) String pincode,
            @RequestParam(value = "categoriesOffered", required = false) String categoriesOffered,
            @RequestParam(value = "audience", required = false) String audience,
            @RequestParam(value = "openDays", required = false) String openDays,
            @RequestParam(value = "openTime", required = false) String openTime,
            @RequestParam(value = "closeTime", required = false) String closeTime,
            @RequestParam(value = "bio", required = false) String bio,
            @RequestParam(value = "ticketMode", required = false) String ticketMode,
            @RequestParam(value = "typicalPrice", required = false) Double typicalPrice,
            @RequestParam(value = "upiId", required = false) String upiId,
            @RequestParam(value = "bankDetails", required = false) String bankDetails,
            HttpSession session,
            RedirectAttributes redirectAttributes) {

        Investor inv = (Investor) session.getAttribute("loggedInvestor");
        if (inv == null) return "redirect:/investor/login";

        try {
            Investor refreshed = investorRepository.findById(inv.getId()).orElse(inv);

            java.util.Map<String, Object> body = new java.util.HashMap<>();
            if (fullName != null) body.put("fullName", fullName);
            if (phone != null) body.put("phone", phone);
            if (designation != null) body.put("designation", designation);
            if (companyName != null) body.put("companyName", companyName);
            if (credentialNumber != null) body.put("credentialNumber", credentialNumber);
            if (address != null) body.put("address", address);
            if (city != null) body.put("city", city);
            if (state != null) body.put("state", state);
            if (pincode != null) body.put("pincode", pincode);
            if (categoriesOffered != null) body.put("categoriesOffered", categoriesOffered);
            if (audience != null) body.put("audience", audience);
            if (openDays != null) body.put("openDays", openDays);
            if (openTime != null) body.put("openTime", openTime);
            if (closeTime != null) body.put("closeTime", closeTime);
            if (bio != null) body.put("bio", bio);
            if (ticketMode != null) body.put("ticketMode", ticketMode);
            if (typicalPrice != null) body.put("typicalPrice", typicalPrice);
            if (upiId != null) body.put("upiId", upiId);
            if (bankDetails != null) body.put("bankDetails", bankDetails);

            investorProfileService.applyExtraFields(refreshed, body);
            investorProfileService.refreshCompletion(refreshed);

            session.setAttribute("loggedInvestor", refreshed);
            redirectAttributes.addFlashAttribute("success", "Profile details saved successfully!");
            return "redirect:/investor/complete-profile";

        } catch (Exception ex) {
            redirectAttributes.addFlashAttribute("error", "Failed to save profile: " + ex.getMessage());
            return "redirect:/investor/complete-profile";
        }
    }

    @PostMapping("/submit-verification")
    public String submitVerification(HttpSession session, RedirectAttributes redirectAttributes) {
        Investor inv = (Investor) session.getAttribute("loggedInvestor");
        if (inv == null) return "redirect:/investor/login";

        try {
            Investor refreshed = investorRepository.findById(inv.getId()).orElse(inv);
            investorProfileService.setLifecycleStatus(refreshed, PartnerProfileStatus.PENDING_ADMIN_APPROVAL);
            refreshed.setProfileCompletionPct(100);
            investorRepository.save(refreshed);

            session.setAttribute("loggedInvestor", refreshed);
            redirectAttributes.addFlashAttribute("success", "Profile submitted successfully! It is now pending Admin Verification.");
            return "redirect:/investor/complete-profile";

        } catch (Exception ex) {
            redirectAttributes.addFlashAttribute("error", "Submission failed: " + ex.getMessage());
            return "redirect:/investor/complete-profile";
        }
    }

    // --- Dashboard & Portfolio ---

    @GetMapping("/dashboard")
    public String dashboard(HttpSession session, Model model) {
        Investor inv = (Investor) session.getAttribute("loggedInvestor");
        if (inv == null) return "redirect:/investor/login";

        // Refresh state
        final Investor refreshedInv = investorRepository.findById(inv.getId()).get();
        session.setAttribute("loggedInvestor", refreshedInv);

        if (refreshedInv.getPartnerProfileStatus() == PartnerProfileStatus.PROFILE_INCOMPLETE) {
            return "redirect:/investor/complete-profile";
        }

        List<Investment> investments = investmentRepository.findByInvestor(refreshedInv);
        List<InvestmentMeeting> meetings = investmentMeetingRepository.findByInvestor(refreshedInv);
        
        // Query proposal questions asked by this investor
        List<ProposalQuestion> questionsAsked = proposalQuestionRepository.findAll().stream()
                .filter(q -> q.getInvestor().getId().equals(refreshedInv.getId()))
                .collect(Collectors.toList());

        double totalInvested = investments.stream().mapToDouble(Investment::getAmount).sum();

        // Calculate ROI / Portfolio
        // Mocking Portfolio ROI data (e.g. 8% - 15% ROI for funded businesses)
        double estimatedMonthlyROI = investments.stream()
                .mapToDouble(i -> (i.getAmount() / i.getProposal().getFundingNeeded()) * i.getProposal().getExpectedMonthlyIncome() * 0.1) // Assume 10% profit distribution to this investor
                .sum();

        model.addAttribute("investor", refreshedInv);
        model.addAttribute("investments", investments);
        model.addAttribute("meetings", meetings);
        model.addAttribute("questions", questionsAsked);
        model.addAttribute("totalInvested", totalInvested);
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
        final Investor refreshedInv = investorRepository.findById(inv.getId()).get();
        session.setAttribute("loggedInvestor", refreshedInv);

        if (refreshedInv.getPartnerProfileStatus() == PartnerProfileStatus.PROFILE_INCOMPLETE) {
            return "redirect:/investor/complete-profile";
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
        Investor inv = (Investor) session.getAttribute("loggedInvestor");
        if (inv == null) return "redirect:/investor/login";

        // Refresh state
        final Investor refreshedInv = investorRepository.findById(inv.getId()).get();
        session.setAttribute("loggedInvestor", refreshedInv);

        if (refreshedInv.getPartnerProfileStatus() == PartnerProfileStatus.PROFILE_INCOMPLETE) {
            return "redirect:/investor/complete-profile";
        }

        Optional<BusinessProposal> opt = businessProposalRepository.findById(id);
        if (opt.isPresent()) {
            BusinessProposal proposal = opt.get();

            List<ProposalQuestion> qna = proposalQuestionRepository.findByProposal(proposal);
            List<InvestmentMeeting> meetings = investmentMeetingRepository.findByProposal(proposal).stream()
                    .filter(m -> m.getInvestor().getId().equals(refreshedInv.getId()))
                    .collect(Collectors.toList());

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
            model.addAttribute("meetings", meetings);
            model.addAttribute("myInvestments", myInvestments);
            model.addAttribute("pendingAmount", pendingAmount);
            model.addAttribute("openRemaining", openRemaining);

            return "investor/proposalDetails";
        }
        return "redirect:/investor/marketplace";
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

        // Check subscription
        if (!inv.isSubscribed()) {
            redirectAttributes.addFlashAttribute("error", "Please purchase the Investor Subscription to unlock investments.");
            return "redirect:/investor/proposal/" + id;
        }

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

        Investor inv = (Investor) session.getAttribute("loggedInvestor");
        if (inv == null) return "redirect:/investor/login";

        Optional<Investment> opt = investmentRepository.findById(id);
        if (opt.isPresent()) {
            Investment investment = opt.get();
            if (investment.getInvestor().getId().equals(inv.getId()) && "PENDING".equals(investment.getStatus())) {
                investment.setStatus("COMPLETED");
                BusinessProposal proposal = investment.getProposal();
                double currentRaised = proposal.getAmountRaised() != null ? proposal.getAmountRaised() : 0.0;
                proposal.setAmountRaised(currentRaised + investment.getAmount());
                businessProposalRepository.save(proposal);
                investmentRepository.save(investment);
                redirectAttributes.addFlashAttribute("success", "Fund transfer confirmed! Deal completed successfully.");
            }
        }
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

    // --- Schedule Meeting ---

    @PostMapping("/proposal/{id}/meeting")
    public String requestMeeting(
            @PathVariable("id") Long id,
            @RequestParam("meetingTime") String meetingTimeStr,
            @RequestParam("location") String location,
            @RequestParam("notes") String notes,
            HttpSession session,
            RedirectAttributes redirectAttributes) {

        Investor inv = (Investor) session.getAttribute("loggedInvestor");
        if (inv == null) return "redirect:/investor/login";

        if (!inv.isSubscribed()) {
            redirectAttributes.addFlashAttribute("error", "Please purchase the Investor Subscription to request meetings.");
            return "redirect:/investor/proposal/" + id;
        }

        Optional<BusinessProposal> opt = businessProposalRepository.findById(id);
        if (opt.isPresent()) {
            InvestmentMeeting m = new InvestmentMeeting();
            m.setProposal(opt.get());
            m.setInvestor(inv);
            m.setMeetingTime(LocalDateTime.parse(meetingTimeStr));
            m.setLocation(location);
            m.setNotes(notes);
            m.setStatus("PENDING");
            investmentMeetingRepository.save(m);

            redirectAttributes.addFlashAttribute("success", "Meeting requested successfully! Entrepreneur will review and accept/decline.");
        }
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

        if (!inv.isSubscribed()) {
            redirectAttributes.addFlashAttribute("error", "Please purchase the Investor Subscription to ask questions.");
            return "redirect:/investor/proposal/" + id;
        }

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

    // --- Chat Room ---

    @GetMapping("/chat/{entrepreneurId}")
    public String viewChatRoom(
            @PathVariable("entrepreneurId") Long entrepreneurId,
            @RequestParam("proposalId") Long proposalId,
            HttpSession session,
            Model model) {

        Investor inv = (Investor) session.getAttribute("loggedInvestor");
        if (inv == null) return "redirect:/investor/login";

        // Refresh state
        final Investor refreshedInv = investorRepository.findById(inv.getId()).get();
        session.setAttribute("loggedInvestor", refreshedInv);

        if (refreshedInv.getPartnerProfileStatus() == PartnerProfileStatus.PROFILE_INCOMPLETE) {
            return "redirect:/investor/complete-profile";
        }

        Optional<Entrepreneur> optE = entrepreneurRepository.findById(entrepreneurId);
        Optional<BusinessProposal> optP = businessProposalRepository.findById(proposalId);

        if (optE.isPresent() && optP.isPresent()) {
            BusinessProposal proposal = optP.get();
            Entrepreneur entrepreneur = optE.get();

            List<ProposalChatMessage> chatHistory = proposalChatMessageRepository
                    .findByProposalAndInvestorOrderByTimestampAsc(proposal, inv);

            model.addAttribute("proposal", proposal);
            model.addAttribute("entrepreneur", entrepreneur);
            model.addAttribute("chatHistory", chatHistory);
            model.addAttribute("senderRole", "INVESTOR");

            return "investor/chat";
        }
        return "redirect:/investor/dashboard";
    }

    @PostMapping("/chat/{entrepreneurId}")
    public String sendChatMessage(
            @PathVariable("entrepreneurId") Long entrepreneurId,
            @RequestParam("proposalId") Long proposalId,
            @RequestParam("message") String message,
            HttpSession session) {

        Investor inv = (Investor) session.getAttribute("loggedInvestor");
        if (inv == null) return "redirect:/investor/login";

        Optional<Entrepreneur> optE = entrepreneurRepository.findById(entrepreneurId);
        Optional<BusinessProposal> optP = businessProposalRepository.findById(proposalId);

        if (optE.isPresent() && optP.isPresent() && !message.trim().isEmpty()) {
            ProposalChatMessage msg = new ProposalChatMessage();
            msg.setProposal(optP.get());
            msg.setInvestor(inv);
            msg.setSenderRole("INVESTOR");
            msg.setMessage(message);
            proposalChatMessageRepository.save(msg);
        }

        return "redirect:/investor/chat/" + entrepreneurId + "?proposalId=" + proposalId;
    }
}
