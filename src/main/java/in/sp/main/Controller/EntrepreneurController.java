package in.sp.main.Controller;

import in.sp.main.Entities.*;
import in.sp.main.Repository.*;
import in.sp.main.Service.FileUploadService;
import in.sp.main.Service.PasswordService;
import in.sp.main.Config.JwtUtil;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/entrepreneur")
public class EntrepreneurController {

    @Autowired
    private EntrepreneurRepository entrepreneurRepository;

    @Autowired
    private InvestorRepository investorRepository;

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
    private FileUploadService fileUploadService;

    @Autowired
    private PasswordService passwordService;

    @Autowired
    private JwtUtil jwtUtil;

    // --- Authentication & Onboarding ---

    @GetMapping("/register")
    public String showRegisterForm(Model model) {
        return "entrepreneur/register";
    }

    @PostMapping("/register")
    public String registerEntrepreneur(
            @RequestParam("fullName") String fullName,
            @RequestParam("email") String email,
            @RequestParam("phone") String phone,
            @RequestParam("password") String password,
            @RequestParam(value = "confirmPassword", required = false) String confirmPassword,
            RedirectAttributes redirectAttributes) {

        try {
            String normEmail = email.toLowerCase().trim();
            if (entrepreneurRepository.findByEmail(normEmail).isPresent()) {
                redirectAttributes.addFlashAttribute("error", "Email already exists. Please sign in.");
                return "redirect:/entrepreneur/login";
            }

            if (confirmPassword != null && !confirmPassword.isBlank() && !password.equals(confirmPassword)) {
                redirectAttributes.addFlashAttribute("error", "Password and Confirm Password do not match.");
                return "redirect:/entrepreneur/register";
            }

            Entrepreneur e = new Entrepreneur();
            e.setFullName(fullName);
            e.setEmail(normEmail);
            e.setPhone(phone);
            e.setPassword(passwordService.encode(password));
            e.setVerificationStatus(VerificationStatus.PENDING);
            e.setPartnerProfileStatus(PartnerProfileStatus.PROFILE_INCOMPLETE);
            e.setProfileCompletionPct(20);

            // Placeholder fields until profile completion
            e.setBusinessName("Pending Profile Completion");
            e.setBusinessCategory("Tea Shop");
            e.setBusinessLocation("Pending");
            e.setBusinessDescription("Profile pending completion by entrepreneur.");
            e.setInvestmentNeeded(0.0);
            e.setExpectedMonthlyIncome(0.0);
            e.setBusinessExperience(0);

            entrepreneurRepository.save(e);

            redirectAttributes.addFlashAttribute("message",
                    "Account created successfully! Please sign in to complete your profile and submit for verification.");
            redirectAttributes.addFlashAttribute("registeredEmail", normEmail);
            return "redirect:/entrepreneur/login";

        } catch (Exception ex) {
            redirectAttributes.addFlashAttribute("error", "Registration failed: " + ex.getMessage());
            return "redirect:/entrepreneur/register";
        }
    }

    @GetMapping("/login")
    public String showLoginForm() {
        return "entrepreneur/login";
    }

    @PostMapping("/login")
    public String loginEntrepreneur(
            @RequestParam("email") String email,
            @RequestParam("password") String password,
            HttpSession session,
            HttpServletResponse response,
            Model model) {

        Optional<Entrepreneur> opt = entrepreneurRepository.findByEmail(email.toLowerCase().trim());
        if (opt.isPresent()) {
            Entrepreneur e = opt.get();
            if (passwordService.matchesAndUpgrade(password, e.getPassword(), hashed -> {
                e.setPassword(hashed);
                entrepreneurRepository.save(e);
            })) {

                if (e.getPartnerProfileStatus() == PartnerProfileStatus.SUSPENDED) {
                    model.addAttribute("error", "Your entrepreneur account has been suspended.");
                    return "entrepreneur/login";
                }

                // Create JWT Cookie
                String token = jwtUtil.generateToken(e.getEmail(), "ENTREPRENEUR");
                Cookie cookie = new Cookie("JWT_TOKEN", token);
                cookie.setPath("/");
                cookie.setHttpOnly(true);
                cookie.setMaxAge(365 * 24 * 60 * 60);
                response.addCookie(cookie);

                session.setAttribute("loggedEntrepreneur", e);

                // Status Gating Logic
                PartnerProfileStatus status = e.getPartnerProfileStatus();
                if (status == PartnerProfileStatus.APPROVED
                        || e.getVerificationStatus() == VerificationStatus.VERIFIED) {
                    return "redirect:/entrepreneur/dashboard";
                } else {
                    return "redirect:/entrepreneur/profile-completion";
                }
            }
        }
        model.addAttribute("error", "Invalid email or password.");
        return "entrepreneur/login";
    }

    @GetMapping("/forgot-password")
    public String showForgotPasswordForm() {
        return "entrepreneur/forgotPassword";
    }

    @PostMapping("/forgot-password")
    public String handleForgotPassword(@RequestParam("email") String email, RedirectAttributes redirectAttributes) {
        Optional<Entrepreneur> opt = entrepreneurRepository.findByEmail(email.toLowerCase().trim());
        if (opt.isPresent()) {
            redirectAttributes.addFlashAttribute("success",
                    "Password reset instructions have been sent to your email!");
            return "redirect:/entrepreneur/forgot-password";
        }
        redirectAttributes.addFlashAttribute("error", "No account found with this email.");
        return "redirect:/entrepreneur/forgot-password";
    }

    @GetMapping("/logout")
    public String logoutEntrepreneur(HttpSession session, HttpServletResponse response) {
        if (session != null) {
            session.invalidate();
        }
        Cookie cookie = new Cookie("JWT_TOKEN", null);
        cookie.setPath("/");
        cookie.setHttpOnly(true);
        cookie.setMaxAge(0);
        response.addCookie(cookie);
        return "redirect:/entrepreneur/login?logout=true";
    }

    // --- Profile Completion ---

    @GetMapping("/profile-completion")
    public String showProfileCompletion(HttpSession session, Model model) {
        Entrepreneur e = getLoggedEntrepreneur(session);
        if (e == null)
            return "redirect:/entrepreneur/login";

        Entrepreneur refreshed = entrepreneurRepository.findById(e.getId()).orElse(e);
        session.setAttribute("loggedEntrepreneur", refreshed);
        model.addAttribute("entrepreneur", refreshed);
        return "entrepreneur/profile-completion";
    }

    @PostMapping("/profile-completion")
    public String saveProfileCompletion(
            @RequestParam(value = "fullName", required = false) String fullName,
            @RequestParam(value = "phone", required = false) String phone,
            @RequestParam(value = "dob", required = false) String dob,
            @RequestParam(value = "gender", required = false) String gender,
            @RequestParam(value = "profilePhotoFile", required = false) MultipartFile profilePhotoFile,
            @RequestParam(value = "aadhaarNumber", required = false) String aadhaarNumber,
            @RequestParam(value = "panNumber", required = false) String panNumber,
            @RequestParam(value = "gstNumber", required = false) String gstNumber,
            @RequestParam(value = "businessName", required = false) String businessName,
            @RequestParam(value = "businessCategory", required = false) String businessCategory,
            @RequestParam(value = "businessType", required = false) String businessType,
            @RequestParam(value = "businessLocation", required = false) String businessLocation,
            @RequestParam(value = "city", required = false) String city,
            @RequestParam(value = "state", required = false) String state,
            @RequestParam(value = "pincode", required = false) String pincode,
            @RequestParam(value = "whatsappNumber", required = false) String whatsappNumber,
            @RequestParam(value = "businessExperience", required = false) Integer businessExperience,
            @RequestParam(value = "businessDescription", required = false) String businessDescription,
            @RequestParam(value = "useOfFunds", required = false) String useOfFunds,
            @RequestParam(value = "investmentNeeded", required = false) Double investmentNeeded,
            @RequestParam(value = "expectedMonthlyIncome", required = false) Double expectedMonthlyIncome,
            @RequestParam(value = "pitchDeckFile", required = false) MultipartFile pitchDeckFile,
            @RequestParam(value = "businessPhotosFiles", required = false) MultipartFile[] businessPhotosFiles,
            @RequestParam(value = "upiId", required = false) String upiId,
            @RequestParam(value = "bankDetails", required = false) String bankDetails,
            HttpSession session,
            RedirectAttributes redirectAttributes) {

        Entrepreneur e = getLoggedEntrepreneur(session);
        if (e == null)
            return "redirect:/entrepreneur/login";

        try {
            Entrepreneur refreshed = entrepreneurRepository.findById(e.getId()).orElse(e);

            if (fullName != null)
                refreshed.setFullName(fullName);
            if (phone != null)
                refreshed.setPhone(phone);
            if (dob != null)
                refreshed.setDob(dob);
            if (gender != null && !gender.isBlank()) {
                try {
                    refreshed.setGender(Gender.valueOf(gender.toUpperCase()));
                } catch (Exception ignored) {
                }
            }
            if (aadhaarNumber != null)
                refreshed.setAadhaarNumber(aadhaarNumber);

            if (businessName != null)
                refreshed.setBusinessName(businessName);
            if (businessCategory != null)
                refreshed.setBusinessCategory(businessCategory);
            if (businessLocation != null)
                refreshed.setBusinessLocation(businessLocation);
            if (city != null)
                refreshed.setCity(city);
            if (state != null)
                refreshed.setState(state);
            if (pincode != null)
                refreshed.setPincode(pincode);
            if (whatsappNumber != null)
                refreshed.setWhatsappNumber(whatsappNumber);

            if (businessExperience != null)
                refreshed.setBusinessExperience(businessExperience);
            if (businessDescription != null)
                refreshed.setBusinessDescription(businessDescription);
            if (investmentNeeded != null)
                refreshed.setInvestmentNeeded(investmentNeeded);
            if (expectedMonthlyIncome != null)
                refreshed.setExpectedMonthlyIncome(expectedMonthlyIncome);

            if (upiId != null)
                refreshed.setUpiId(upiId);
            if (bankDetails != null)
                refreshed.setBankDetails(bankDetails);

            // Handle file uploads
            if (profilePhotoFile != null && !profilePhotoFile.isEmpty()) {
                refreshed.setProfilePhoto(fileUploadService.saveFile(profilePhotoFile));
            }
            if (pitchDeckFile != null && !pitchDeckFile.isEmpty()) {
                refreshed.setDocumentsPath(fileUploadService.saveFile(pitchDeckFile));
            }
            if (businessPhotosFiles != null && businessPhotosFiles.length > 0) {
                List<String> photoPaths = new ArrayList<>();
                for (MultipartFile photo : businessPhotosFiles) {
                    if (photo != null && !photo.isEmpty()) {
                        photoPaths.add(fileUploadService.saveFile(photo));
                    }
                }
                if (!photoPaths.isEmpty()) {
                    refreshed.setPhotosPath(String.join(",", photoPaths));
                }
            }

            refreshed.setProfileCompletionPct(calculateEntrepreneurCompletionPct(refreshed));
            entrepreneurRepository.save(refreshed);

            session.setAttribute("loggedEntrepreneur", refreshed);
            redirectAttributes.addFlashAttribute("message", "Profile details saved successfully!");
            return "redirect:/entrepreneur/profile-completion";

        } catch (Exception ex) {
            redirectAttributes.addFlashAttribute("error", "Failed to save profile: " + ex.getMessage());
            return "redirect:/entrepreneur/profile-completion";
        }
    }

    public static int calculateEntrepreneurCompletionPct(Entrepreneur e) {
        if (e == null)
            return 0;
        int pct = 0;

        if (e.getFullName() != null && !e.getFullName().isBlank()) pct += 5;
        if (e.getEmail() != null && !e.getEmail().isBlank()) pct += 5;
        if (e.getPhone() != null && !e.getPhone().isBlank()) pct += 5;

        if (e.getBusinessName() != null && !e.getBusinessName().isBlank() && !e.getBusinessName().equals("Pending Profile Completion")) pct += 5;
        if (e.getBusinessCategory() != null && !e.getBusinessCategory().isBlank()) pct += 5;
        if (e.getBusinessLocation() != null && !e.getBusinessLocation().isBlank() && !e.getBusinessLocation().equals("Pending")) pct += 5;

        if (e.getInvestmentNeeded() != null && e.getInvestmentNeeded() > 0) pct += 5;
        if (e.getExpectedMonthlyIncome() != null && e.getExpectedMonthlyIncome() > 0) pct += 5;
        if (e.getBusinessExperience() != null) pct += 5;

        if (e.getAadhaarNumber() != null && !e.getAadhaarNumber().isBlank()) pct += 10;

        if (e.getBusinessDescription() != null && !e.getBusinessDescription().isBlank() && !e.getBusinessDescription().equals("Profile pending completion by entrepreneur.")) pct += 10;

        if ((e.getUpiId() != null && !e.getUpiId().isBlank())
                || (e.getBankDetails() != null && !e.getBankDetails().isBlank())) pct += 5;

        if (e.getProfilePhoto() != null && !e.getProfilePhoto().isBlank()) pct += 10;
        if (e.getDocumentsPath() != null && !e.getDocumentsPath().isBlank()) pct += 10;
        if (e.getPhotosPath() != null && !e.getPhotosPath().isBlank()) pct += 10;

        return Math.min(100, pct);
    }

    @PostMapping("/submit-verification")
    public String submitVerification(HttpSession session, RedirectAttributes redirectAttributes) {
        Entrepreneur e = getLoggedEntrepreneur(session);
        if (e == null)
            return "redirect:/entrepreneur/login";

        try {
            Entrepreneur refreshed = entrepreneurRepository.findById(e.getId()).orElse(e);
            
            if (calculateEntrepreneurCompletionPct(refreshed) < 100) {
                redirectAttributes.addFlashAttribute("error", "Please complete all required profile fields before submitting.");
                return "redirect:/entrepreneur/profile-completion";
            }

            refreshed.setPartnerProfileStatus(PartnerProfileStatus.PENDING_ADMIN_APPROVAL);
            refreshed.setVerificationStatus(VerificationStatus.PENDING);
            refreshed.setProfileCompletionPct(100);
            entrepreneurRepository.save(refreshed);

            // Create or update default business proposal
            List<BusinessProposal> existingProposals = businessProposalRepository.findByEntrepreneur(refreshed);
            if (existingProposals.isEmpty()) {
                BusinessProposal proposal = new BusinessProposal();
                proposal.setEntrepreneur(refreshed);
                proposal.setTitle(
                        "Launch of " + (refreshed.getBusinessName() != null ? refreshed.getBusinessName() : "Venture"));
                proposal.setCategory(refreshed.getBusinessCategory());
                proposal.setLocation(refreshed.getBusinessLocation());
                proposal.setDescription(refreshed.getBusinessDescription());
                proposal.setFundingNeeded(
                        refreshed.getInvestmentNeeded() != null ? refreshed.getInvestmentNeeded() : 0.0);
                proposal.setExpectedMonthlyIncome(
                        refreshed.getExpectedMonthlyIncome() != null ? refreshed.getExpectedMonthlyIncome() : 0.0);
                proposal.setPhotos(refreshed.getPhotosPath() == null ? "mobile-pending" : refreshed.getPhotosPath());
                proposal.setDocuments(
                        refreshed.getDocumentsPath() == null ? "mobile-pending" : refreshed.getDocumentsPath());
                proposal.setStatus(VerificationStatus.PENDING);
                businessProposalRepository.save(proposal);
            }

            session.setAttribute("loggedEntrepreneur", refreshed);
            redirectAttributes.addFlashAttribute("message",
                    "Profile submitted successfully! It is now pending Admin Verification.");
            return "redirect:/entrepreneur/profile-completion";

        } catch (Exception ex) {
            redirectAttributes.addFlashAttribute("error", "Submission failed: " + ex.getMessage());
            return "redirect:/entrepreneur/profile-completion";
        }
    }

    private Entrepreneur getLoggedEntrepreneur(HttpSession session) {
        Entrepreneur e = (Entrepreneur) session.getAttribute("loggedEntrepreneur");
        if (e == null) {
            org.springframework.security.core.Authentication auth = org.springframework.security.core.context.SecurityContextHolder
                    .getContext().getAuthentication();
            if (auth != null && auth.isAuthenticated() && !auth.getName().equals("anonymousUser")) {
                Optional<Entrepreneur> opt = entrepreneurRepository.findByEmail(auth.getName());
                if (opt.isPresent()) {
                    e = opt.get();
                    session.setAttribute("loggedEntrepreneur", e);
                }
            }
        }
        return e;
    }

    // --- Dashboard ---

    @GetMapping("/dashboard")
    public String dashboard(HttpSession session, Model model) {
        Entrepreneur e = getLoggedEntrepreneur(session);
        if (e == null)
            return "redirect:/entrepreneur/login";

        // Refresh state
        final Entrepreneur refreshedEnt = entrepreneurRepository.findById(e.getId()).get();
        session.setAttribute("loggedEntrepreneur", refreshedEnt);

        // Strict Dashboard Access Gating removed to allow skipping profile completion

        List<BusinessProposal> proposals = businessProposalRepository.findByEntrepreneur(refreshedEnt);

        double totalRequested = proposals.stream().mapToDouble(BusinessProposal::getFundingNeeded).sum();
        double totalRaised = proposals.stream().mapToDouble(BusinessProposal::getAmountRaised).sum();
        double remaining = totalRequested - totalRaised;

        List<Investment> investments = investmentRepository.findByProposal_Entrepreneur_Id(refreshedEnt.getId());
        List<InvestmentMeeting> meetings = investmentMeetingRepository
                .findByProposal_Entrepreneur_Id(refreshedEnt.getId());
        List<ProposalQuestion> questions = proposalQuestionRepository
                .findByProposal_Entrepreneur_Id(refreshedEnt.getId());

        // Extract unique interested investors
        List<Investor> interestedInvestors = investments.stream()
                .map(Investment::getInvestor)
                .distinct()
                .collect(Collectors.toList());

        meetings.stream().map(InvestmentMeeting::getInvestor).forEach(inv -> {
            if (!interestedInvestors.contains(inv))
                interestedInvestors.add(inv);
        });

        questions.stream().map(ProposalQuestion::getInvestor).forEach(inv -> {
            if (inv != null && !interestedInvestors.contains(inv))
                interestedInvestors.add(inv);
        });

        List<Investor> approvedInvestors = investorRepository.findAll().stream()
                .filter(inv -> inv.getVerificationStatus() == VerificationStatus.VERIFIED || inv.getPartnerProfileStatus() == PartnerProfileStatus.APPROVED)
                .collect(Collectors.toList());

        model.addAttribute("entrepreneur", refreshedEnt);
        model.addAttribute("proposals", proposals);
        model.addAttribute("totalRequested", totalRequested);
        model.addAttribute("totalRaised", totalRaised);
        model.addAttribute("remaining", remaining);
        model.addAttribute("investments", investments);
        model.addAttribute("meetings", meetings);
        model.addAttribute("questions", questions);
        model.addAttribute("interestedInvestors", interestedInvestors);
        model.addAttribute("approvedInvestors", approvedInvestors);

        return "entrepreneur/dashboard";
    }

    // --- Create Business Proposal ---

    @GetMapping("/proposal/create")
    public String showCreateProposal(HttpSession session, RedirectAttributes redirectAttributes) {
        Entrepreneur e = (Entrepreneur) session.getAttribute("loggedEntrepreneur");
        if (e == null)
            return "redirect:/entrepreneur/login";
            
        Entrepreneur refreshedEnt = entrepreneurRepository.findById(e.getId()).get();
        if (refreshedEnt.getPartnerProfileStatus() != PartnerProfileStatus.APPROVED
                && refreshedEnt.getVerificationStatus() != VerificationStatus.VERIFIED) {
            redirectAttributes.addFlashAttribute("error", "You cannot create a proposal until your profile is verified by the admin.");
            return "redirect:/entrepreneur/dashboard";
        }
            
        return "entrepreneur/createProposal";
    }

    @PostMapping("/proposal/create")
    public String createProposal(
            @RequestParam("title") String title,
            @RequestParam("category") String category,
            @RequestParam("location") String location,
            @RequestParam("description") String description,
            @RequestParam("fundingNeeded") Double fundingNeeded,
            @RequestParam("expectedMonthlyIncome") Double expectedMonthlyIncome,
            @RequestParam("photos") MultipartFile[] photos,
            @RequestParam("documents") MultipartFile[] documents,
            @RequestParam(value = "videoPitch", required = false) MultipartFile videoPitch,
            HttpSession session,
            RedirectAttributes redirectAttributes) {

        Entrepreneur e = (Entrepreneur) session.getAttribute("loggedEntrepreneur");
        if (e == null)
            return "redirect:/entrepreneur/login";
            
        Entrepreneur refreshedEnt = entrepreneurRepository.findById(e.getId()).get();
        if (refreshedEnt.getPartnerProfileStatus() != PartnerProfileStatus.APPROVED
                && refreshedEnt.getVerificationStatus() != VerificationStatus.VERIFIED) {
            redirectAttributes.addFlashAttribute("error", "You cannot create a proposal until your profile is verified by the admin.");
            return "redirect:/entrepreneur/dashboard";
        }

        try {
            BusinessProposal p = new BusinessProposal();
            p.setEntrepreneur(e);
            p.setTitle(title);
            p.setCategory(category);
            p.setLocation(location);
            p.setDescription(description);
            p.setFundingNeeded(fundingNeeded);
            p.setExpectedMonthlyIncome(expectedMonthlyIncome);
            p.setStatus(VerificationStatus.PENDING);

            // Upload files
            List<String> photoPaths = new ArrayList<>();
            for (MultipartFile photo : photos) {
                if (photo != null && !photo.isEmpty()) {
                    photoPaths.add(fileUploadService.saveFile(photo));
                }
            }
            p.setPhotos(String.join(",", photoPaths));

            List<String> docPaths = new ArrayList<>();
            for (MultipartFile doc : documents) {
                if (doc != null && !doc.isEmpty()) {
                    docPaths.add(fileUploadService.saveFile(doc));
                }
            }
            p.setDocuments(String.join(",", docPaths));

            if (videoPitch != null && !videoPitch.isEmpty()) {
                p.setVideoPitch(fileUploadService.saveFile(videoPitch));
            }

            businessProposalRepository.save(p);
            redirectAttributes.addFlashAttribute("success", "Proposal submitted! It is now pending admin approval.");
            return "redirect:/entrepreneur/dashboard";

        } catch (Exception ex) {
            redirectAttributes.addFlashAttribute("error", "Proposal submission failed: " + ex.getMessage());
            return "redirect:/entrepreneur/proposal/create";
        }
    }

    // --- Premium Checkout Actions (Mock Payments) ---

    @PostMapping("/pay-verification")
    public String payVerification(HttpSession session, RedirectAttributes redirectAttributes) {
        Entrepreneur e = (Entrepreneur) session.getAttribute("loggedEntrepreneur");
        if (e == null)
            return "redirect:/entrepreneur/login";

        e.setVerificationFeePaid(true);
        entrepreneurRepository.save(e);

        redirectAttributes.addFlashAttribute("success",
                "Verification fee paid successfully! Admin will verify your documents shortly.");
        return "redirect:/entrepreneur/dashboard";
    }

    @PostMapping("/proposal/premium/{id}")
    public String payPremiumListing(@PathVariable("id") Long id, HttpSession session,
            RedirectAttributes redirectAttributes) {
        Entrepreneur e = (Entrepreneur) session.getAttribute("loggedEntrepreneur");
        if (e == null)
            return "redirect:/entrepreneur/login";

        Optional<BusinessProposal> opt = businessProposalRepository.findById(id);
        if (opt.isPresent()) {
            BusinessProposal p = opt.get();
            if (p.getEntrepreneur().getId().equals(e.getId())) {
                p.setPremium(true);
                businessProposalRepository.save(p);
                redirectAttributes.addFlashAttribute("success",
                        "Proposal updated to Premium! It will now stand out in the marketplace.");
            }
        }
        return "redirect:/entrepreneur/dashboard";
    }

    @PostMapping("/proposal/featured/{id}")
    public String payFeaturedListing(@PathVariable("id") Long id, HttpSession session,
            RedirectAttributes redirectAttributes) {
        Entrepreneur e = (Entrepreneur) session.getAttribute("loggedEntrepreneur");
        if (e == null)
            return "redirect:/entrepreneur/login";

        Optional<BusinessProposal> opt = businessProposalRepository.findById(id);
        if (opt.isPresent()) {
            BusinessProposal p = opt.get();
            if (p.getEntrepreneur().getId().equals(e.getId())) {
                p.setFeatured(true);
                businessProposalRepository.save(p);
                redirectAttributes.addFlashAttribute("success",
                        "Proposal featured successfully! It will be pinned to the top of the marketplace.");
            }
        }
        return "redirect:/entrepreneur/dashboard";
    }

    // --- Meeting Management ---

    @PostMapping("/meetings/{id}/accept")
    public String acceptMeeting(@PathVariable("id") Long id, HttpSession session,
            RedirectAttributes redirectAttributes) {
        Entrepreneur e = (Entrepreneur) session.getAttribute("loggedEntrepreneur");
        if (e == null)
            return "redirect:/entrepreneur/login";

        Optional<InvestmentMeeting> opt = investmentMeetingRepository.findById(id);
        if (opt.isPresent()) {
            InvestmentMeeting m = opt.get();
            if (m.getProposal().getEntrepreneur().getId().equals(e.getId())) {
                m.setStatus("ACCEPTED");
                investmentMeetingRepository.save(m);
                redirectAttributes.addFlashAttribute("success", "Meeting accepted successfully!");
            }
        }
        return "redirect:/entrepreneur/dashboard";
    }

    @PostMapping("/meetings/{id}/reject")
    public String rejectMeeting(@PathVariable("id") Long id, HttpSession session,
            RedirectAttributes redirectAttributes) {
        Entrepreneur e = (Entrepreneur) session.getAttribute("loggedEntrepreneur");
        if (e == null)
            return "redirect:/entrepreneur/login";

        Optional<InvestmentMeeting> opt = investmentMeetingRepository.findById(id);
        if (opt.isPresent()) {
            InvestmentMeeting m = opt.get();
            if (m.getProposal().getEntrepreneur().getId().equals(e.getId())) {
                m.setStatus("REJECTED");
                investmentMeetingRepository.save(m);
                redirectAttributes.addFlashAttribute("success", "Meeting rejected.");
            }
        }
        return "redirect:/entrepreneur/dashboard";
    }

    // --- Q&A Management ---

    @PostMapping("/questions/{id}/answer")
    public String answerQuestion(
            @PathVariable("id") Long id,
            @RequestParam("answer") String answer,
            HttpSession session,
            RedirectAttributes redirectAttributes) {

        Entrepreneur e = (Entrepreneur) session.getAttribute("loggedEntrepreneur");
        if (e == null)
            return "redirect:/entrepreneur/login";

        Optional<ProposalQuestion> opt = proposalQuestionRepository.findById(id);
        if (opt.isPresent()) {
            ProposalQuestion q = opt.get();
            if (q.getProposal().getEntrepreneur().getId().equals(e.getId())) {
                q.setAnswer(answer);
                proposalQuestionRepository.save(q);
                redirectAttributes.addFlashAttribute("success", "Answer posted successfully.");
            }
        }
        return "redirect:/entrepreneur/dashboard";
    }

    // --- Chat Room ---

    @GetMapping("/chat/{investorId}")
    public String viewChatRoom(
            @PathVariable("investorId") Long investorId,
            @RequestParam(value = "proposalId", required = false) Long proposalId,
            HttpSession session,
            Model model) {

        Entrepreneur e = getLoggedEntrepreneur(session);
        if (e == null)
            return "redirect:/entrepreneur/login";

        Optional<Investor> optI = investorRepository.findById(investorId);
        if (optI.isEmpty()) {
            List<Investor> allInvestors = investorRepository.findAll();
            if (!allInvestors.isEmpty()) {
                optI = Optional.of(allInvestors.get(0));
            }
        }

        BusinessProposal proposal = null;
        if (proposalId != null) {
            Optional<BusinessProposal> optP = businessProposalRepository.findById(proposalId);
            if (optP.isPresent())
                proposal = optP.get();
        }

        if (proposal == null) {
            List<BusinessProposal> proposals = businessProposalRepository.findByEntrepreneur(e);
            if (!proposals.isEmpty()) {
                proposal = proposals.get(0);
            }
        }

        if (optI.isPresent() && proposal != null) {
            Investor investor = optI.get();

            List<ProposalChatMessage> chatHistory = proposalChatMessageRepository
                    .findByProposalAndInvestorOrderByTimestampAsc(proposal, investor);

            model.addAttribute("proposal", proposal);
            model.addAttribute("investor", investor);
            model.addAttribute("chatHistory", chatHistory);
            model.addAttribute("senderRole", "ENTREPRENEUR");

            return "entrepreneur/chat";
        }
        return "redirect:/entrepreneur/dashboard";
    }

    @PostMapping("/chat/{investorId}")
    public String sendChatMessage(
            @PathVariable("investorId") Long investorId,
            @RequestParam("proposalId") Long proposalId,
            @RequestParam("message") String message,
            HttpSession session) {

        Entrepreneur e = (Entrepreneur) session.getAttribute("loggedEntrepreneur");
        if (e == null)
            return "redirect:/entrepreneur/login";

        Optional<Investor> optI = investorRepository.findById(investorId);
        Optional<BusinessProposal> optP = businessProposalRepository.findById(proposalId);

        if (optI.isPresent() && optP.isPresent() && !message.trim().isEmpty()) {
            ProposalChatMessage msg = new ProposalChatMessage();
            msg.setProposal(optP.get());
            msg.setInvestor(optI.get());
            msg.setSenderRole("ENTREPRENEUR");
            msg.setMessage(message);
            proposalChatMessageRepository.save(msg);
        }

        return "redirect:/entrepreneur/chat/" + investorId + "?proposalId=" + proposalId;
    }

    // --- Revenue tracking: pay commission ---
    @PostMapping("/commission/pay/{id}")
    public String payPlatformCommission(@PathVariable("id") Long id, HttpSession session,
            RedirectAttributes redirectAttributes) {
        Entrepreneur e = (Entrepreneur) session.getAttribute("loggedEntrepreneur");
        if (e == null)
            return "redirect:/entrepreneur/login";

        Optional<Investment> opt = investmentRepository.findById(id);
        if (opt.isPresent()) {
            Investment inv = opt.get();
            if (inv.getProposal().getEntrepreneur().getId().equals(e.getId())) {
                inv.setCommissionPaid(true);
                investmentRepository.save(inv);
                redirectAttributes.addFlashAttribute("success",
                        "Commission of 2% paid successfully to FightDFire Platform!");
            }
        }
        return "redirect:/entrepreneur/dashboard";
    }

    // --- Wallet & Bookings placeholders ---
    @GetMapping("/wallet")
    public String viewWallet(HttpSession session, Model model) {
        Entrepreneur e = getLoggedEntrepreneur(session);
        if (e == null)
            return "redirect:/entrepreneur/login";
        // Refresh Entrepreneur data
        Optional<Entrepreneur> opt = entrepreneurRepository.findById(e.getId());
        if (opt.isPresent()) {
            session.setAttribute("loggedEntrepreneur", opt.get());
        }
        return "entrepreneur/wallet";
    }

    @GetMapping("/bookings")
    public String viewBookings(HttpSession session, Model model) {
        Entrepreneur e = getLoggedEntrepreneur(session);
        if (e == null)
            return "redirect:/entrepreneur/login";

        Entrepreneur refreshed = entrepreneurRepository.findById(e.getId()).orElse(e);
        List<InvestmentMeeting> meetings = investmentMeetingRepository
                .findByProposal_Entrepreneur_Id(refreshed.getId());

        model.addAttribute("entrepreneur", refreshed);
        model.addAttribute("loggedEntrepreneur", refreshed);
        model.addAttribute("meetings", meetings);

        return "entrepreneur/bookings";
    }

    // --- Admin Verification & Profile Review Actions ---

    @GetMapping({ "/about/{id}", "/entrepreneurs/about/{id}", "/entrepreneur/about/{id}" })
    public String viewEntrepreneurAboutPage(@PathVariable("id") Long id, Model model, HttpSession session) {
        Optional<Entrepreneur> opt = entrepreneurRepository.findById(id);
        if (opt.isEmpty()) {
            Optional<BusinessProposal> propOpt = businessProposalRepository.findById(id);
            if (propOpt.isPresent() && propOpt.get().getEntrepreneur() != null) {
                opt = Optional.of(propOpt.get().getEntrepreneur());
            }
        }
        if (opt.isEmpty()) {
            List<Entrepreneur> allEnts = entrepreneurRepository.findAll();
            if (!allEnts.isEmpty()) {
                opt = Optional.of(allEnts.get(0));
            }
        }
        if (opt.isEmpty()) {
            return "redirect:/admin/pending-proposals";
        }
        Entrepreneur e = opt.get();
        e.setProfileCompletionPct(calculateEntrepreneurCompletionPct(e));
        model.addAttribute("entrepreneur", e);

        // Fetch associated business proposals
        List<BusinessProposal> proposals = null;
        try {
            proposals = businessProposalRepository.findByEntrepreneur(e);
        } catch (Exception ex) {
            proposals = new ArrayList<>();
        }
        model.addAttribute("proposals", proposals != null ? proposals : new ArrayList<>());

        return "aboutEntrepreneur";
    }

    @GetMapping({ "/admin/pending-entrepreneurs", "/admin/entrepreneurManagement" })
    public String viewPendingEntrepreneurs(Model model, HttpSession session) {
        if (session.getAttribute("admin") == null)
            return "redirect:/admin/loginAdmin";

        List<Entrepreneur> allEntrepreneurs = entrepreneurRepository.findAll();
        List<Entrepreneur> pendingEntrepreneurs = new ArrayList<>();

        for (Entrepreneur e : allEntrepreneurs) {
            e.setProfileCompletionPct(calculateEntrepreneurCompletionPct(e));
            if (e.getPartnerProfileStatus() == PartnerProfileStatus.PENDING_ADMIN_APPROVAL
                    || e.getVerificationStatus() == VerificationStatus.PENDING) {
                pendingEntrepreneurs.add(e);
            }
        }

        model.addAttribute("pendingEntrepreneurs", pendingEntrepreneurs);
        model.addAttribute("allEntrepreneurs", allEntrepreneurs);
        model.addAttribute("pendingCount", pendingEntrepreneurs.size());

        return "adminPendingEntrepreneurs";
    }

    @PostMapping({ "/admin/approve/{id}", "/admin/entrepreneurs/{id}/approve" })
    public String adminApproveEntrepreneur(@PathVariable("id") Long id, HttpSession session,
            RedirectAttributes redirectAttributes) {
        if (session.getAttribute("admin") == null)
            return "redirect:/admin/loginAdmin";

        Optional<Entrepreneur> opt = entrepreneurRepository.findById(id);
        if (opt.isPresent()) {
            Entrepreneur e = opt.get();
            e.setPartnerProfileStatus(PartnerProfileStatus.APPROVED);
            e.setVerificationStatus(VerificationStatus.VERIFIED);
            e.setRejectionReason(null);
            e.setChangesRequestedNote(null);
            e.setProfileCompletionPct(100);
            entrepreneurRepository.save(e);
            redirectAttributes.addFlashAttribute("message",
                    "Entrepreneur " + e.getFullName() + " approved successfully!");
        } else {
            redirectAttributes.addFlashAttribute("error", "Entrepreneur not found.");
        }
        return "redirect:/admin/pending-entrepreneurs";
    }

    @PostMapping({ "/admin/reject/{id}", "/admin/entrepreneurs/{id}/reject" })
    public String adminRejectEntrepreneur(
            @PathVariable("id") Long id,
            @RequestParam(value = "reason", required = false) String reason,
            HttpSession session,
            RedirectAttributes redirectAttributes) {
        if (session.getAttribute("admin") == null)
            return "redirect:/admin/loginAdmin";

        Optional<Entrepreneur> opt = entrepreneurRepository.findById(id);
        if (opt.isPresent()) {
            Entrepreneur e = opt.get();
            e.setPartnerProfileStatus(PartnerProfileStatus.REJECTED);
            e.setVerificationStatus(VerificationStatus.REJECTED);
            if (reason != null && !reason.isBlank()) {
                e.setRejectionReason(reason.trim());
            }
            entrepreneurRepository.save(e);
            redirectAttributes.addFlashAttribute("message",
                    "Entrepreneur " + e.getFullName() + " application rejected.");
        } else {
            redirectAttributes.addFlashAttribute("error", "Entrepreneur not found.");
        }
        return "redirect:/admin/pending-entrepreneurs";
    }

    @PostMapping("/admin/entrepreneurs/{id}/request-changes")
    public String adminRequestEntrepreneurChanges(
            @PathVariable("id") Long id,
            @RequestParam(value = "note", required = false) String note,
            HttpSession session,
            RedirectAttributes redirectAttributes) {
        if (session.getAttribute("admin") == null)
            return "redirect:/admin/loginAdmin";

        Optional<Entrepreneur> opt = entrepreneurRepository.findById(id);
        if (opt.isPresent()) {
            Entrepreneur e = opt.get();
            e.setPartnerProfileStatus(PartnerProfileStatus.CHANGES_REQUESTED);
            if (note != null && !note.isBlank()) {
                e.setChangesRequestedNote(note.trim());
            }
            entrepreneurRepository.save(e);
            redirectAttributes.addFlashAttribute("message", "Requested profile changes from " + e.getFullName() + ".");
        } else {
            redirectAttributes.addFlashAttribute("error", "Entrepreneur not found.");
        }
        return "redirect:/admin/pending-entrepreneurs";
    }
}
