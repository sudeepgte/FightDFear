package in.sp.main.Controller;

import in.sp.main.Entities.*;
import in.sp.main.Repository.*;
import in.sp.main.Service.FileUploadService;
import in.sp.main.Config.JwtUtil;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.io.IOException;
import java.time.LocalDateTime;
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
    private PasswordEncoder passwordEncoder;

    @Autowired
    private JwtUtil jwtUtil;

    // --- Authentication ---

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
            @RequestParam("profilePhoto") MultipartFile profilePhoto,
            @RequestParam("dob") String dob,
            @RequestParam("gender") String gender,
            @RequestParam("aadhaarNumber") String aadhaarNumber,
            @RequestParam("aadhaarDoc") MultipartFile aadhaarDoc,
            @RequestParam("businessName") String businessName,
            @RequestParam("businessCategory") String businessCategory,
            @RequestParam("businessLocation") String businessLocation,
            @RequestParam("businessDescription") String businessDescription,
            @RequestParam("investmentNeeded") Double investmentNeeded,
            @RequestParam("expectedMonthlyIncome") Double expectedMonthlyIncome,
            @RequestParam("businessExperience") Integer businessExperience,
            @RequestParam("photos") MultipartFile[] photos,
            @RequestParam("documents") MultipartFile[] documents,
            @RequestParam(value = "videoPitch", required = false) MultipartFile videoPitch,
            @RequestParam("bankName") String bankName,
            @RequestParam("accountNumber") String accountNumber,
            @RequestParam("ifscCode") String ifscCode,
            @RequestParam("upiId") String upiId,
            RedirectAttributes redirectAttributes) {

        try {
            if (entrepreneurRepository.findByEmail(email.toLowerCase().trim()).isPresent()) {
                redirectAttributes.addFlashAttribute("error", "Email already exists. Please login.");
                return "redirect:/entrepreneur/login";
            }

            Entrepreneur e = new Entrepreneur();
            e.setFullName(fullName);
            e.setEmail(email.toLowerCase().trim());
            e.setPhone(phone);
            e.setPassword(passwordEncoder.encode(password));
            e.setDob(dob);
            e.setGender(Gender.valueOf(gender.toUpperCase()));
            e.setAadhaarNumber(aadhaarNumber);
            e.setBusinessName(businessName);
            e.setBusinessCategory(businessCategory);
            e.setBusinessLocation(businessLocation);
            e.setBusinessDescription(businessDescription);
            e.setInvestmentNeeded(investmentNeeded);
            e.setExpectedMonthlyIncome(expectedMonthlyIncome);
            e.setBusinessExperience(businessExperience);
            e.setBankName(bankName);
            e.setAccountNumber(accountNumber);
            e.setIfscCode(ifscCode);
            e.setUpiId(upiId);
            e.setVerificationStatus(VerificationStatus.PENDING);

            // Save single uploads
            if (profilePhoto != null && !profilePhoto.isEmpty()) {
                e.setProfilePhoto(fileUploadService.saveFile(profilePhoto));
            }
            if (aadhaarDoc != null && !aadhaarDoc.isEmpty()) {
                e.setAadhaarDocPath(fileUploadService.saveFile(aadhaarDoc));
            }
            if (videoPitch != null && !videoPitch.isEmpty()) {
                e.setVideoPitchPath(fileUploadService.saveFile(videoPitch));
            }

            // Save multi-uploads
            List<String> photoPaths = new ArrayList<>();
            for (MultipartFile photo : photos) {
                if (photo != null && !photo.isEmpty()) {
                    photoPaths.add(fileUploadService.saveFile(photo));
                }
            }
            e.setPhotosPath(String.join(",", photoPaths));

            List<String> docPaths = new ArrayList<>();
            for (MultipartFile doc : documents) {
                if (doc != null && !doc.isEmpty()) {
                    docPaths.add(fileUploadService.saveFile(doc));
                }
            }
            e.setDocumentsPath(String.join(",", docPaths));

            entrepreneurRepository.save(e);

            // Auto-create a default Business Proposal matching their initial details
            BusinessProposal proposal = new BusinessProposal();
            proposal.setEntrepreneur(e);
            proposal.setTitle("Launch of " + businessName);
            proposal.setCategory(businessCategory);
            proposal.setLocation(businessLocation);
            proposal.setDescription(businessDescription);
            proposal.setFundingNeeded(investmentNeeded);
            proposal.setExpectedMonthlyIncome(expectedMonthlyIncome);
            proposal.setPhotos(e.getPhotosPath());
            proposal.setDocuments(e.getDocumentsPath());
            proposal.setVideoPitch(e.getVideoPitchPath());
            proposal.setStatus(VerificationStatus.PENDING);
            businessProposalRepository.save(proposal);

            redirectAttributes.addFlashAttribute("success", "Registration successful! You will be able to log in after Admin verifies your Aadhaar/documents.");
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
            if (passwordEncoder.matches(password, e.getPassword()) || e.getPassword().equals(password)) {
                if (e.getVerificationStatus() == VerificationStatus.PENDING) {
                    model.addAttribute("error", "Your profile is pending admin approval and verification.");
                    return "entrepreneur/login";
                }
                if (e.getVerificationStatus() == VerificationStatus.REJECTED) {
                    model.addAttribute("error", "Your registration has been rejected by the admin.");
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
                return "redirect:/entrepreneur/dashboard";
            }
        }
        model.addAttribute("error", "Invalid credentials.");
        return "entrepreneur/login";
    }

    // --- Dashboard ---

    @GetMapping("/dashboard")
    public String dashboard(HttpSession session, Model model) {
        Entrepreneur e = (Entrepreneur) session.getAttribute("loggedEntrepreneur");
        if (e == null) return "redirect:/entrepreneur/login";

        // Refresh state
        final Entrepreneur refreshedEnt = entrepreneurRepository.findById(e.getId()).get();
        session.setAttribute("loggedEntrepreneur", refreshedEnt);

        List<BusinessProposal> proposals = businessProposalRepository.findByEntrepreneur(refreshedEnt);

        double totalRequested = proposals.stream().mapToDouble(BusinessProposal::getFundingNeeded).sum();
        double totalRaised = proposals.stream().mapToDouble(BusinessProposal::getAmountRaised).sum();
        double remaining = totalRequested - totalRaised;

        List<Investment> investments = investmentRepository.findByProposal_Entrepreneur_Id(refreshedEnt.getId());
        List<InvestmentMeeting> meetings = investmentMeetingRepository.findByProposal_Entrepreneur_Id(refreshedEnt.getId());
        List<ProposalQuestion> questions = proposalQuestionRepository.findByProposal_Entrepreneur_Id(refreshedEnt.getId());

        // Extract unique interested investors
        List<Investor> interestedInvestors = investments.stream()
                .map(Investment::getInvestor)
                .distinct()
                .collect(Collectors.toList());

        meetings.stream().map(InvestmentMeeting::getInvestor).forEach(inv -> {
            if (!interestedInvestors.contains(inv)) interestedInvestors.add(inv);
        });

        model.addAttribute("entrepreneur", refreshedEnt);
        model.addAttribute("proposals", proposals);
        model.addAttribute("totalRequested", totalRequested);
        model.addAttribute("totalRaised", totalRaised);
        model.addAttribute("remaining", remaining);
        model.addAttribute("investments", investments);
        model.addAttribute("meetings", meetings);
        model.addAttribute("questions", questions);
        model.addAttribute("interestedInvestors", interestedInvestors);

        return "entrepreneur/dashboard";
    }

    // --- Create Business Proposal ---

    @GetMapping("/proposal/create")
    public String showCreateProposal(HttpSession session) {
        Entrepreneur e = (Entrepreneur) session.getAttribute("loggedEntrepreneur");
        if (e == null) return "redirect:/entrepreneur/login";
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
        if (e == null) return "redirect:/entrepreneur/login";

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
        if (e == null) return "redirect:/entrepreneur/login";

        e.setVerificationFeePaid(true);
        entrepreneurRepository.save(e);

        redirectAttributes.addFlashAttribute("success", "Verification fee paid successfully! Admin will verify your documents shortly.");
        return "redirect:/entrepreneur/dashboard";
    }

    @PostMapping("/proposal/premium/{id}")
    public String payPremiumListing(@PathVariable("id") Long id, HttpSession session, RedirectAttributes redirectAttributes) {
        Entrepreneur e = (Entrepreneur) session.getAttribute("loggedEntrepreneur");
        if (e == null) return "redirect:/entrepreneur/login";

        Optional<BusinessProposal> opt = businessProposalRepository.findById(id);
        if (opt.isPresent()) {
            BusinessProposal p = opt.get();
            if (p.getEntrepreneur().getId().equals(e.getId())) {
                p.setPremium(true);
                businessProposalRepository.save(p);
                redirectAttributes.addFlashAttribute("success", "Proposal updated to Premium! It will now stand out in the marketplace.");
            }
        }
        return "redirect:/entrepreneur/dashboard";
    }

    @PostMapping("/proposal/featured/{id}")
    public String payFeaturedListing(@PathVariable("id") Long id, HttpSession session, RedirectAttributes redirectAttributes) {
        Entrepreneur e = (Entrepreneur) session.getAttribute("loggedEntrepreneur");
        if (e == null) return "redirect:/entrepreneur/login";

        Optional<BusinessProposal> opt = businessProposalRepository.findById(id);
        if (opt.isPresent()) {
            BusinessProposal p = opt.get();
            if (p.getEntrepreneur().getId().equals(e.getId())) {
                p.setFeatured(true);
                businessProposalRepository.save(p);
                redirectAttributes.addFlashAttribute("success", "Proposal featured successfully! It will be pinned to the top of the marketplace.");
            }
        }
        return "redirect:/entrepreneur/dashboard";
    }

    // --- Meeting Management ---

    @PostMapping("/meetings/{id}/accept")
    public String acceptMeeting(@PathVariable("id") Long id, HttpSession session, RedirectAttributes redirectAttributes) {
        Entrepreneur e = (Entrepreneur) session.getAttribute("loggedEntrepreneur");
        if (e == null) return "redirect:/entrepreneur/login";

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
    public String rejectMeeting(@PathVariable("id") Long id, HttpSession session, RedirectAttributes redirectAttributes) {
        Entrepreneur e = (Entrepreneur) session.getAttribute("loggedEntrepreneur");
        if (e == null) return "redirect:/entrepreneur/login";

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
        if (e == null) return "redirect:/entrepreneur/login";

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
            @RequestParam("proposalId") Long proposalId,
            HttpSession session,
            Model model) {

        Entrepreneur e = (Entrepreneur) session.getAttribute("loggedEntrepreneur");
        if (e == null) return "redirect:/entrepreneur/login";

        Optional<Investor> optI = investorRepository.findById(investorId);
        Optional<BusinessProposal> optP = businessProposalRepository.findById(proposalId);

        if (optI.isPresent() && optP.isPresent()) {
            BusinessProposal proposal = optP.get();
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
        if (e == null) return "redirect:/entrepreneur/login";

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
    public String payPlatformCommission(@PathVariable("id") Long id, HttpSession session, RedirectAttributes redirectAttributes) {
        Entrepreneur e = (Entrepreneur) session.getAttribute("loggedEntrepreneur");
        if (e == null) return "redirect:/entrepreneur/login";

        Optional<Investment> opt = investmentRepository.findById(id);
        if (opt.isPresent()) {
            Investment inv = opt.get();
            if (inv.getProposal().getEntrepreneur().getId().equals(e.getId())) {
                inv.setCommissionPaid(true);
                investmentRepository.save(inv);
                redirectAttributes.addFlashAttribute("success", "Commission of 2% paid successfully to FightDFire Platform!");
            }
        }
        return "redirect:/entrepreneur/dashboard";
    }
}
