package in.sp.main.Controller;

import in.sp.main.Entities.*;
import in.sp.main.Repository.*;
import in.sp.main.Service.*;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.*;

import static org.springframework.web.bind.annotation.RequestMethod.*;

@Controller
@RequestMapping("/admin")
public class AdminController {

    @Autowired
    private MartialArtsCenterService centreService;
    
    @Autowired
    private in.sp.main.Config.JwtUtil jwtUtil;

    @Autowired
    private EmailService emailService;
    @Autowired
    private AdminService adminService;
    @Autowired
    private VideoUploadRepository videouploadRepository;
    @Autowired
    private AdminRepository adminRepository;

    @Autowired
    private BroadcastMessageRepository broadcastMessageRepository;

    @Autowired
    private VideoReportRepository videoReportRepository;
    @Autowired
    private CreatorCashoutRepository creatorCashoutRepository;
    @Autowired
    private BrandCollaborationRepository brandCollaborationRepository;


    @Autowired
    private UserRepository userRepository;

    @Autowired
    private FitnessTrainerRepository fitnessTrainerRepository;

    @Autowired
    private FitnessBookingRepository fitnessBookingRepository;

    @Autowired
    private DoctorRepository doctorRepository;

    @Autowired
    private ServiceProviderRepository serviceProviderRepository;

    @Autowired
    private SOSRequestRepository sosRequestRepository;



    @Autowired
    private SosActivationRepository sosActivationRepository;

    @Autowired
    private SOSAlertRepository sosAlertRepository;
    
    @Autowired
    private BuddyAvailabilityRepository buddyAvailabilityRepository;
    
    @Autowired
    private BuddyRequestRepository buddyRequestRepository;

    @Autowired
    private DangerPointRepository dangerPointRepository;

    @Autowired
    private SafeRouteRepository safeRouteRepository;

    @Autowired
    private SalonRepository salonRepository;

    @Autowired
    private StylistRepository stylistRepository;

    @Autowired
    private FileUploadService fileService;

    @Autowired
    private ContactMessageService contactMessageService;

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
    private WomenEventRepository womenEventRepository;

    @Autowired
    private WomenEventRegistrationRepository womenEventRegistrationRepository;

    // Sidebar counts are now handled globally via GlobalSidebarAdvice.java

    @RequestMapping(value = "/approve/{id}", method = POST)
    public String approveCentre(@PathVariable Long id, HttpSession session, RedirectAttributes redirectAttributes) {
        if (session.getAttribute("admin") == null) return "redirect:/admin/loginAdmin";
        centreService.approveCenter(id);
        MartialArtsCenter centre = centreService.getCenterById(id);

        String subject = "Your Martial Arts Center is Now Approved!";
        String text = "Dear " + centre.getName() + ",\n\n"
                + "We are excited to inform you that your registration as a Martial Arts Training Center has been successfully approved.\n\n"
                + "Your center is now visible to users, and they can start enrolling in your training sessions.\n\n"
                + "Please log in to your profile to manage enrollments and update training details as needed.\n\n"
                + "Best Regards,\nFight D Fear\n";

        emailService.sendEmail(centre.getEmail(), subject, text);
        redirectAttributes.addFlashAttribute("message", "Centre approved successfully!");
        return "redirect:/admin/martialManagement";
    }

    
    @RequestMapping(value = "/reject/{id}", method = POST)
    public String rejectCentre(@PathVariable Long id, HttpSession session, RedirectAttributes redirectAttributes) {
        if (session.getAttribute("admin") == null) return "redirect:/admin/loginAdmin";
        MartialArtsCenter centre = centreService.getCenterById(id);
        boolean deleted = centreService.rejectCenter(id);
        redirectAttributes.addFlashAttribute("message",
                deleted ? "Centre rejected and removed." : "Centre not found.");
        return "redirect:/admin/martialManagement";
    }

   
    @RequestMapping(value = "/view-certificate/{id}", method = GET)
    public String viewTrainerCertificate(@PathVariable Long id, HttpSession session, Model model) {
        if (session.getAttribute("admin") == null) return "redirect:/admin/loginAdmin";
        String certificatePath = centreService.getCertificatePath(id);
        model.addAttribute("certificatePath", certificatePath);
        return "viewCertificate";
    }

   
    @RequestMapping(value = "/martialManagement", method = GET)
    public String showAdminDashboard(HttpSession session, Model model) {
        if (session.getAttribute("admin") == null) return "redirect:/admin/loginAdmin";
        List<MartialArtsCenter> pendingCentres = centreService.getCentresByApprovalStatus(false);
        List<MartialArtsCenter> approvedCentres = centreService.getCentresByApprovalStatus(true);
        model.addAttribute("pendingCentres", pendingCentres);
        model.addAttribute("approvedCentres", approvedCentres);
        return "adminMartialManagement";
    }

   
    @RequestMapping(value = "/registerAdmin", method = GET)
    public String showRegisterPage(HttpSession session) {
        if (session.getAttribute("admin") != null) {
            return "redirect:/admin/adminDashboard";
        }
        return "adminRegister";
    }

   
    @RequestMapping(value = "/registerAdmin", method = POST)
    public String registerAdmin(@RequestParam String name,
                                @RequestParam String email,
                                @RequestParam String password,
                                RedirectAttributes redirectAttributes) {
        if (email == null || email.isBlank() || password == null || password.isBlank()) {
            redirectAttributes.addFlashAttribute("error", "Email and Password are required!");
            return "redirect:/admin/registerAdmin";
        }
        Admin admin = new Admin(name, email, password);
        if (adminService.registerAdmin(admin)) {
            redirectAttributes.addFlashAttribute("success", "Admin registered successfully! Please login.");
            return "redirect:/admin/loginAdmin";
        } else {
            redirectAttributes.addFlashAttribute("error", "Email already exists!");
            return "redirect:/admin/registerAdmin";
        }
    }

    
    @RequestMapping(value = "/loginAdmin", method = GET)
    public String showLoginPage(Model model, @ModelAttribute("error") String error,
                                @ModelAttribute("success") String success,
                                HttpSession session) {
        if (session.getAttribute("admin") != null) {
            return "redirect:/admin/adminDashboard";
        }
        model.addAttribute("error", error);
        model.addAttribute("success", success);
        return "adminLogin";
    }

    
    @RequestMapping(value = "/loginAdmin", method = POST)
    public String loginAdmin(@RequestParam String email,
                             @RequestParam String password,
                             HttpSession session,
                             jakarta.servlet.http.HttpServletResponse response,
                             RedirectAttributes redirectAttributes) {
        if (email == null || email.isBlank() || password == null || password.isBlank()) {
            redirectAttributes.addFlashAttribute("error", "Please enter both Email and Password!");
            return "redirect:/admin/loginAdmin";
        }
        Admin admin = adminService.loginAdmin(email, password);
        if (admin != null) {
            session.setAttribute("admin", admin);
            session.setAttribute("userRole", "ADMIN");
            
            // Generate JWT and add to response
            String token = jwtUtil.generateToken(admin.getEmail(), "ADMIN");
            jakarta.servlet.http.Cookie cookie = new jakarta.servlet.http.Cookie("JWT_TOKEN", token);
            cookie.setPath("/");
            cookie.setHttpOnly(true);
            cookie.setMaxAge(365 * 24 * 60 * 60); // 1 year
            response.addCookie(cookie);
            
            return "redirect:/admin/adminDashboard"; 
        } else {
            redirectAttributes.addFlashAttribute("error", "Invalid credentials!");
            return "redirect:/admin/loginAdmin";
        }
    }

  
    @RequestMapping(value = "/adminDashboard", method = GET)
    public String showDashboard(HttpSession session, Model model) {
        if (session.getAttribute("admin") == null) {
            return "redirect:/admin/loginAdmin";
        }
        // Ensure admin is available to JSP (it currently uses ${admin.id})
        model.addAttribute("admin", session.getAttribute("admin"));
        model.addAttribute("recentContactMessages", contactMessageService.findRecent(5));
        model.addAttribute("unreadContactMessages", contactMessageService.countUnread());

        // Platform Activity Feed
        List<Map<String, Object>> activities = new ArrayList<>();

        List<Investment> investments = investmentRepository.findAll();
        for (Investment inv : investments) {
            Map<String, Object> act = new HashMap<>();
            act.put("type", "INVESTMENT");
            act.put("icon", "bi-cash-stack text-success");
            act.put("desc", "Investor <strong>" + inv.getInvestor().getFullName() + "</strong> invested <strong>₹" + inv.getAmount() + "</strong> in pitch <em>\"" + inv.getProposal().getTitle() + "\"</em>");
            act.put("time", inv.getCreatedAt() != null ? inv.getCreatedAt() : LocalDateTime.now());
            activities.add(act);
        }

        List<InvestmentMeeting> meetings = investmentMeetingRepository.findAll();
        for (InvestmentMeeting m : meetings) {
            Map<String, Object> act = new HashMap<>();
            act.put("type", "MEETING");
            act.put("icon", "bi-calendar-event text-primary");
            act.put("desc", "Investor <strong>" + m.getInvestor().getFullName() + "</strong> requested a meeting with entrepreneur <strong>" + m.getProposal().getEntrepreneur().getFullName() + "</strong> for <em>\"" + m.getProposal().getTitle() + "\"</em>");
            act.put("time", m.getCreatedAt() != null ? m.getCreatedAt() : LocalDateTime.now());
            activities.add(act);
        }

        List<ProposalQuestion> questions = proposalQuestionRepository.findAll();
        for (ProposalQuestion q : questions) {
            Map<String, Object> act = new HashMap<>();
            act.put("type", "QUESTION");
            act.put("icon", "bi-question-circle text-warning");
            act.put("desc", "Investor <strong>" + q.getInvestor().getFullName() + "</strong> asked: <em>\"" + q.getQuestion() + "\"</em> on <em>\"" + q.getProposal().getTitle() + "\"</em>");
            act.put("time", q.getCreatedAt() != null ? q.getCreatedAt() : LocalDateTime.now());
            activities.add(act);

            if (q.getAnswer() != null && !q.getAnswer().trim().isEmpty()) {
                Map<String, Object> ansAct = new HashMap<>();
                ansAct.put("type", "ANSWER");
                ansAct.put("icon", "bi-chat-left-text text-info");
                ansAct.put("desc", "Entrepreneur <strong>" + q.getProposal().getEntrepreneur().getFullName() + "</strong> answered: <em>\"" + q.getAnswer() + "\"</em> on <em>\"" + q.getProposal().getTitle() + "\"</em>");
                ansAct.put("time", q.getCreatedAt() != null ? q.getCreatedAt() : LocalDateTime.now());
                activities.add(ansAct);
            }
        }

        List<ProposalChatMessage> chats = proposalChatMessageRepository.findAll();
        for (ProposalChatMessage chat : chats) {
            Map<String, Object> act = new HashMap<>();
            act.put("type", "CHAT");
            act.put("icon", "bi-chat-dots text-secondary");
            String sender = "Investor <strong>" + chat.getInvestor().getFullName() + "</strong>";
            if ("ENTREPRENEUR".equalsIgnoreCase(chat.getSenderRole())) {
                sender = "Entrepreneur <strong>" + chat.getProposal().getEntrepreneur().getFullName() + "</strong>";
            }
            act.put("desc", sender + " sent a message: <em>\"" + chat.getMessage() + "\"</em> regarding <em>\"" + chat.getProposal().getTitle() + "\"</em>");
            act.put("time", chat.getTimestamp() != null ? chat.getTimestamp() : LocalDateTime.now());
            activities.add(act);
        }

        // Sort chronologically descending
        activities.sort((a1, a2) -> {
            LocalDateTime t1 = (LocalDateTime) a1.get("time");
            LocalDateTime t2 = (LocalDateTime) a2.get("time");
            if (t1 == null || t2 == null) return 0;
            return t2.compareTo(t1);
        });

        List<Map<String, Object>> recentActivities = activities.stream().limit(10).collect(java.util.stream.Collectors.toList());
        model.addAttribute("recentPlatformActivities", recentActivities);

        // Moderation Queue (videos/reels pending moderation check)
        List<Videoupload> moderationQueue = videouploadRepository.findAll().stream()
                .filter(v -> "PENDING_MODERATION".equals(v.getStatus()))
                .collect(java.util.stream.Collectors.toList());

        // Reported Content list
        List<VideoReport> reports = videoReportRepository.findAll();

        // Creator Verification Requests
        List<User> creatorsVerificationList = userRepository.findAll().stream()
                .filter(u -> !u.isVerifiedCreator() && u.getRewardPoints() != null && u.getRewardPoints() > 100)
                .collect(java.util.stream.Collectors.toList());

        // Approved creators (to allow un-badge)
        List<User> verifiedCreators = userRepository.findAll().stream()
                .filter(User::isVerifiedCreator)
                .collect(java.util.stream.Collectors.toList());

        // Cash-out redemption requests
        List<CreatorCashout> cashoutRequests = creatorCashoutRepository.findByStatus("PENDING");

        // All Brand Collaborations
        List<BrandCollaboration> campaigns = brandCollaborationRepository.findAll();

        model.addAttribute("moderationQueue", moderationQueue);
        model.addAttribute("reports", reports);
        model.addAttribute("creatorsVerificationList", creatorsVerificationList);
        model.addAttribute("verifiedCreators", verifiedCreators);
        model.addAttribute("cashoutRequests", cashoutRequests);
        model.addAttribute("campaigns", campaigns);

        // Fitness & Wellness Module
        List<FitnessTrainer> pendingTrainers = fitnessTrainerRepository.findByVerificationStatus(VerificationStatus.PENDING);
        List<FitnessTrainer> activeTrainers = fitnessTrainerRepository.findByVerificationStatus(VerificationStatus.VERIFIED);
        List<FitnessBooking> fitnessBookings = fitnessBookingRepository.findAll();

        model.addAttribute("pendingTrainers", pendingTrainers);
        model.addAttribute("activeTrainers", activeTrainers);
        model.addAttribute("fitnessBookings", fitnessBookings);

        return "adminDashboard";
    }

    // Near real-time metrics for admin dashboard
    @GetMapping(value = "/dashboard.meta", produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public Map<String, Object> dashboardMeta(HttpSession session) {
        Map<String, Object> res = new HashMap<>();
        if (session.getAttribute("admin") == null) {
            res.put("error", "LOGIN_REQUIRED");
            return res;
        }

        int pendingCentres = centreService.getCentresByApprovalStatus(false).size();
        int approvedCentres = centreService.getCentresByApprovalStatus(true).size();


        int reportedVideos = videoReportRepository.findAllByOrderByReportedAtDesc().size();
        int pendingDoctors = doctorRepository.findByVerificationStatus(VerificationStatus.PENDING).size();
        int pendingWomenProducts = serviceProviderRepository.findByCategoryAndVerificationStatus(ProviderCategory.WOMEN_PRODUCTS, VerificationStatus.PENDING).size();

        // Purpose: analytics overview stats for the new summary section.
        int totalUsers    = (int) userRepository.count();
        int totalDoctors  = (int) doctorRepository.count();
        int totalVerifiedUsers   = userRepository.findByVerificationStatus(VerificationStatus.VERIFIED).size();
        int totalVerifiedDoctors = doctorRepository.findByVerificationStatus(VerificationStatus.VERIFIED).size();
        int totalProviders = (int) serviceProviderRepository.count();
        int totalVideos   = (int) videouploadRepository.count();
        
        // Purpose: count of ongoing SOS requests for the dashboard badge.
        long activeSosCount = sosRequestRepository.findAll().stream()
            .filter(s -> s.getStatus() == SOSRequest.SOSStatus.ACTIVE || 
                         s.getStatus() == SOSRequest.SOSStatus.ACCEPTED)
            .count();
            
        long activeActivationCount = sosActivationRepository.findAll().stream()
            .filter(s -> !"Resolved".equalsIgnoreCase(s.getStatus()) && !"Cancelled".equalsIgnoreCase(s.getStatus()))
            .count();
        
        long activeAlertCount = sosAlertRepository.findAll().stream()
            .filter(s -> "ACTIVE".equalsIgnoreCase(s.getStatus()))
            .count();
        
        int totalLiveSos = (int) (activeSosCount + activeActivationCount + activeAlertCount);
        
        long verifiedRoutes = safeRouteRepository.findByVerified(true).size();
        long totalSalons = salonRepository.count();
        long verifiedSalons = salonRepository.findByApproved(true).size();
        long totalStylists = stylistRepository.count();
        long verifiedStylists = stylistRepository.findByApproved(true).size();
        long bannedUsers = userRepository.findByBanned(true).size();
        long pendingUsers = userRepository.findByVerificationStatus(VerificationStatus.PENDING).size();
        long pendingTrainers = fitnessTrainerRepository.findByVerificationStatus(VerificationStatus.PENDING).size();

        // Simple signature: reload/update when any count changes
        String signature = pendingCentres + "|" + totalLiveSos + "|" + totalUsers + "|" + verifiedSalons + "|" + pendingTrainers;

        List<Entrepreneur> allEntrepreneurs = entrepreneurRepository.findAll();
        List<Investor> allInvestors = investorRepository.findAll();
        List<BusinessProposal> allProposals = businessProposalRepository.findAll();
        List<Investment> allInvestments = investmentRepository.findAll();

        long totalEntrepreneurs = allEntrepreneurs.size();
        long verifiedEntrepreneurs = allEntrepreneurs.stream()
                .filter(e -> e.getVerificationStatus() == VerificationStatus.VERIFIED)
                .count();
        long pendingEntrepreneurs = allEntrepreneurs.stream()
                .filter(e -> e.getVerificationStatus() == VerificationStatus.PENDING)
                .count();

        long totalInvestors = allInvestors.size();
        long verifiedInvestors = allInvestors.stream()
                .filter(i -> i.getVerificationStatus() == VerificationStatus.VERIFIED)
                .count();
        long pendingInvestors = allInvestors.stream()
                .filter(i -> i.getVerificationStatus() == VerificationStatus.PENDING)
                .count();

        long totalProposals = allProposals.size();
        long verifiedProposals = allProposals.stream()
                .filter(p -> p.getStatus() == VerificationStatus.VERIFIED)
                .count();
        long pendingProposals = allProposals.stream()
                .filter(p -> p.getStatus() == VerificationStatus.PENDING)
                .count();

        double totalCapitalRequested = allProposals.stream()
                .mapToDouble(BusinessProposal::getFundingNeeded)
                .sum();
        double totalCapitalInvested = allInvestments.stream()
                .mapToDouble(Investment::getAmount)
                .sum();

        double verificationFees = allEntrepreneurs.stream().filter(Entrepreneur::isVerificationFeePaid).count() * 499.0;
        double subscriptionFees = allInvestors.stream().filter(Investor::isSubscribed).count() * 1999.0;
        double premiumListingFees = allProposals.stream().filter(BusinessProposal::isPremium).count() * 999.0;
        double featuredListingFees = allProposals.stream().filter(BusinessProposal::isFeatured).count() * 999.0;
        double platformCommissions = allInvestments.stream()
                .filter(Investment::isCommissionPaid)
                .mapToDouble(i -> i.getAmount() * 0.02)
                .sum();
        double totalPlatformRevenue = verificationFees + subscriptionFees + premiumListingFees + featuredListingFees + platformCommissions;

        res.put("pendingCentres", pendingCentres);

        res.put("totalLiveSos", totalLiveSos);
        res.put("verifiedRoutes", verifiedRoutes);
        
        res.put("totalVerifiedDoctors", totalVerifiedDoctors);
        res.put("verifiedSalons", verifiedSalons);
        res.put("verifiedStylists", verifiedStylists);
        
        res.put("totalUsers", totalUsers);
        res.put("bannedUsers", bannedUsers);
        res.put("pendingUsers", pendingUsers);
        res.put("pendingTrainers", pendingTrainers);
        
        res.put("totalVideos", totalVideos);
        
        res.put("totalEntrepreneursCount", totalEntrepreneurs);
        res.put("verifiedEntrepreneurs", verifiedEntrepreneurs);
        res.put("pendingEntrepreneurs", pendingEntrepreneurs);
        
        res.put("totalInvestorsCount", totalInvestors);
        res.put("verifiedInvestors", verifiedInvestors);
        res.put("pendingInvestors", pendingInvestors);
        
        res.put("totalProposalsCount", totalProposals);
        res.put("verifiedProposals", verifiedProposals);
        res.put("pendingProposals", pendingProposals);
        
        res.put("totalCapitalRequested", totalCapitalRequested);
        res.put("totalCapitalInvested", totalCapitalInvested);
        res.put("totalPlatformRevenue", totalPlatformRevenue);

        // Women Events Platform stats
        long totalWomenEvents   = womenEventRepository.count();
        long approvedWomenEvents = womenEventRepository.countByStatus("APPROVED");
        long pendingWomenEvents  = womenEventRepository.countByStatus("PENDING");
        res.put("totalWomenEvents",   totalWomenEvents);
        res.put("approvedWomenEvents", approvedWomenEvents);
        res.put("pendingWomenEvents",  pendingWomenEvents);

        long totalEventBookings = womenEventRegistrationRepository.count();
        double totalEventTicketRevenue = womenEventRegistrationRepository.findAll().stream()
                .filter(r -> r.isPaid())
                .mapToDouble(r -> r.getAmountPaid())
                .sum();

        String mostPopularEvent = "None";
        List<WomenEventRegistration> allEventRegs = womenEventRegistrationRepository.findAll();
        if (!allEventRegs.isEmpty()) {
            Map<String, Long> countMap = allEventRegs.stream()
                    .collect(java.util.stream.Collectors.groupingBy(r -> r.getEvent().getName(), java.util.stream.Collectors.counting()));
            mostPopularEvent = countMap.entrySet().stream()
                    .max(Map.Entry.comparingByValue())
                    .map(Map.Entry::getKey)
                    .orElse("None");
        }
        res.put("totalEventBookings", totalEventBookings);
        res.put("totalEventTicketRevenue", totalEventTicketRevenue);
        res.put("mostPopularEvent", mostPopularEvent);

        res.put("signature", signature);
        return res;
    }

    // Purpose: provide incident data for the admin heatmap.
    @GetMapping(value = "/heatmap.json", produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public List<Map<String, Object>> heatmapData(HttpSession session) {
        List<Map<String, Object>> result = new java.util.ArrayList<>();
        if (session.getAttribute("admin") == null) return result;

        // Include Verified Danger Points
        for (DangerPoint dp : dangerPointRepository.findByVerified(true)) {
            Map<String, Object> point = new HashMap<>();
            point.put("id",          dp.getId());
            point.put("lat",         dp.getLatitude());
            point.put("lng",         dp.getLongitude());
            point.put("hasGps",      true);
            point.put("type",        dp.getCategory() != null ? dp.getCategory().toUpperCase() : "DANGER_POINT");
            point.put("location",    dp.getLocationName() != null ? dp.getLocationName() : "Danger Point");
            point.put("description", dp.getNote());
            point.put("status",      "VERIFIED");
            point.put("reportedAt",  dp.getCreatedAt() != null ? dp.getCreatedAt().toString() : "");
            point.put("source",      "DANGER_POINT");
            result.add(point);
        }
        return result;
    }

   
    @RequestMapping(value = "/logout", method = GET)
    public String logout(HttpSession session, jakarta.servlet.http.HttpServletResponse response) {
        session.invalidate();
        
        jakarta.servlet.http.Cookie cookie = new jakarta.servlet.http.Cookie("JWT_TOKEN", null);
        cookie.setPath("/");
        cookie.setHttpOnly(true);
        cookie.setMaxAge(0);
        response.addCookie(cookie);
        
        return "redirect:/admin/loginAdmin";
    }

    
    @RequestMapping(value = "/edit/{id}", method = GET)
    public String showEditForm(@PathVariable int id, Model model) {
        Admin admin = adminService.findById(id)
                .orElseThrow(() -> new RuntimeException("Admin not found with id: " + id));
        model.addAttribute("admin", admin);
        return "editAdmin";
    }

   
    @RequestMapping(value = "/update", method = POST)
    public String updateAdmin(@ModelAttribute("admin") Admin admin, 
                              @RequestParam(value = "profileImage", required = false) MultipartFile profileImage,
                              HttpSession session,
                              RedirectAttributes redirectAttributes) {
        if (session.getAttribute("admin") == null) return "redirect:/admin/loginAdmin";
        if (profileImage != null && !profileImage.isEmpty()) {
            try {
                String photoUrl = fileService.saveFile(profileImage);
                admin.setProfilePhoto(photoUrl);
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
        adminService.updateAdmin(admin.getId(), admin);
        redirectAttributes.addFlashAttribute("successMessage", "Admin updated successfully!");
        return "redirect:/admin/profile/" + admin.getId();
    }

   
    @RequestMapping(value = "/delete/{id}", method = GET)
    public String deleteAdmin(@PathVariable int id, HttpSession session, RedirectAttributes redirectAttributes) {
        if (session.getAttribute("admin") == null) return "redirect:/admin/loginAdmin";
        adminService.deleteAdmin(id);
        redirectAttributes.addFlashAttribute("successMessage", "Admin deleted successfully!");
        return "redirect:/admin/list";
    }

    @RequestMapping(value = "/list", method = GET)
    public String listAdmins(HttpSession session, Model model) {
        if (session.getAttribute("admin") == null) return "redirect:/admin/loginAdmin";
        model.addAttribute("admins", adminService.findAllAdmins());
        return "listAdmins";
    }

    
    @RequestMapping(value = "/profile/{id}", method = GET)
    public String showAdminProfile(@PathVariable int id, HttpSession session, Model model) {
        if (session.getAttribute("admin") == null) return "redirect:/admin/loginAdmin";
        Admin admin = adminService.findById(id)
                .orElseThrow(() -> new RuntimeException("Admin not found with id: " + id));
        model.addAttribute("admin", admin);
        return "adminProfile";
    }

   
    @RequestMapping(value = "/volunteer-management", method = GET)
    public String showAdminVolunteerManagementPage(HttpSession session) {
        if (session.getAttribute("admin") == null) return "redirect:/admin/loginAdmin";
        return "adminVolunteerManagement";
    }

    // Purpose: admin page for reviewing volunteer suggestions.
    // The suggestion entity/repository is not yet implemented, so we supply empty lists
    // to prevent the 404 Whitelabel Error from the dashboard link.
    @GetMapping("/pending-suggestions")
    public String viewPendingSuggestions(Model model, HttpSession session) {
        if (session.getAttribute("admin") == null) {
            return "redirect:/admin/loginAdmin";
        }
        // Provide empty lists so the JSP c:if blocks render gracefully.
        model.addAttribute("pending",  java.util.Collections.emptyList());
        model.addAttribute("approved", java.util.Collections.emptyList());
        model.addAttribute("rejected", java.util.Collections.emptyList());
        return "adminPendingVolunteerSuggestions";
    }

    // Purpose: admin rejects a volunteer — called from approvedVolunteers.jsp and
    // pendingVolunteers.jsp forms which POST to /admin/rejectvolunteer/{id}.
    @PostMapping("/rejectvolunteer/{id}")
    public String rejectVolunteer(@PathVariable Long id,
                                  HttpSession session,
                                  RedirectAttributes redirectAttributes) {
        if (session.getAttribute("admin") == null) {
            return "redirect:/admin/loginAdmin";
        }
        User u = userRepository.findById(id).orElse(null);
        if (u == null) {
            redirectAttributes.addFlashAttribute("error", "Volunteer not found.");
            return "redirect:/volunteer/approved-volunteers";
        }
        u.setVerificationStatus(VerificationStatus.REJECTED);
        userRepository.save(u);
        redirectAttributes.addFlashAttribute("message", "Volunteer rejected.");
        return "redirect:/volunteer/approved-volunteers";
    }

    // ── User Management (ban / unban / delete) ─────────────────────────────

    // Purpose: admin user management page — lists all users with ban/unban/delete actions.
    @GetMapping("/users")
    public String userManagement(@RequestParam(value = "q", required = false) String q,
                                 Model model, HttpSession session) {
        if (session.getAttribute("admin") == null) {
            return "redirect:/admin/loginAdmin";
        }
        if (q != null && !q.trim().isEmpty()) {
            model.addAttribute("searchResults", userRepository.searchUsers(q.trim()));
            model.addAttribute("q", q.trim());
        } else {
            // Include pending and verified users for approval workflow
            model.addAttribute("pendingUsers", userRepository.findByVerificationStatus(VerificationStatus.PENDING));
            model.addAttribute("verifiedUsers", userRepository.findByVerificationStatus(VerificationStatus.VERIFIED));
            model.addAttribute("rejectedUsers", userRepository.findByVerificationStatus(VerificationStatus.REJECTED));
            model.addAttribute("bannedUsers",  userRepository.findByBanned(true));
        }
        return "adminUserManagement";
    }

    // Purpose: admin approves a user — allows them to login.
    @PostMapping("/users/{id}/approve")
    public String approveUser(@PathVariable Long id, HttpSession session, RedirectAttributes ra) {
        if (session.getAttribute("admin") == null) return "redirect:/admin/loginAdmin";
        userRepository.findById(id).ifPresent(u -> {
            u.setVerificationStatus(VerificationStatus.VERIFIED);
            userRepository.save(u);
        });
        ra.addFlashAttribute("message", "User verified successfully. They can now log in.");
        return "redirect:/admin/users";
    }



    // Purpose: admin bans a user — sets banned=true, blocks login.
    @PostMapping("/users/{id}/ban")
    public String banUser(@PathVariable Long id, HttpSession session, RedirectAttributes ra) {
        if (session.getAttribute("admin") == null) return "redirect:/admin/loginAdmin";
        userRepository.findById(id).ifPresent(u -> {
            u.setBanned(true);
            userRepository.save(u);
        });
        ra.addFlashAttribute("message", "User banned successfully.");
        return "redirect:/admin/users";
    }

    // Purpose: admin unbans a previously banned user.
    @PostMapping("/users/{id}/unban")
    public String unbanUser(@PathVariable Long id, HttpSession session, RedirectAttributes ra) {
        if (session.getAttribute("admin") == null) return "redirect:/admin/loginAdmin";
        userRepository.findById(id).ifPresent(u -> {
            u.setBanned(false);
            userRepository.save(u);
        });
        ra.addFlashAttribute("message", "User unbanned successfully.");
        return "redirect:/admin/users";
    }

    // Purpose: admin permanently deletes a user account.
    @PostMapping("/users/{id}/delete")
    public String deleteUser(@PathVariable Long id, HttpSession session, RedirectAttributes ra) {
        if (session.getAttribute("admin") == null) return "redirect:/admin/loginAdmin";
        userRepository.deleteById(id);
        ra.addFlashAttribute("message", "User deleted permanently.");
        return "redirect:/admin/users";
    }

    // ── SOS Alert Monitoring ───────────────────────────────────────────────

    // Purpose: Render the SOS monitoring dashboard page.
    @GetMapping("/sos")
    public String sosMonitor(Model model, HttpSession session) {
        if (session.getAttribute("admin") == null) {
            return "redirect:/admin/loginAdmin";
        }
        return "adminSOSMonitor";
    }

    @GetMapping(value = "/sos.json", produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public List<Map<String, Object>> liveSosData(HttpSession session) {
        List<Map<String, Object>> result = new java.util.ArrayList<>();
        if (session.getAttribute("admin") == null) return result;

        // 1. Fetch from SOSRequest
        List<SOSRequest> requests = sosRequestRepository.findAll();
        for (SOSRequest sos : requests) {
            Map<String, Object> map = new HashMap<>();
            map.put("id", "req_" + sos.getId());
            map.put("type", "SOS_REQUEST");

            // Resolve user name robustly
            String userName = null;
            String userPhone = "N/A";
            if (sos.getUser() != null) {
                userName = sos.getUser().getFullName();
                userPhone = sos.getUser().getPhoneNumber();
                if (userName == null || userName.isEmpty()) {
                    userName = sos.getUser().getEmail();
                }
                if (userName == null || userName.isEmpty()) {
                    userName = "User #" + sos.getUser().getId();
                }
            } else {
                userName = "Unknown (Req #" + sos.getId() + ")";
            }
            map.put("userName", userName);
            map.put("userPhone", userPhone != null ? userPhone : "N/A");

            // Handle location — always output as String for consistent JS parsing
            Double lat = sos.getLatitude();
            Double lng = sos.getLongitude();
            map.put("lat", lat != null ? String.valueOf(lat) : null);
            map.put("lng", lng != null ? String.valueOf(lng) : null);
            map.put("status", sos.getStatus() != null ? sos.getStatus().toString() : "ACTIVE");
            map.put("time", sos.getActivatedAt() != null ? sos.getActivatedAt().toString() : "");
            map.put("mapsLink", sos.getGoogleMapsLink());
            result.add(map);
        }

        // 2. Fetch from sosActivation (Shake-to-alert, etc.)
        List<sosActivation> activations = sosActivationRepository.findAll();
        for (sosActivation act : activations) {
            Map<String, Object> map = new HashMap<>();
            map.put("id", "act_" + act.getId());
            map.put("type", "ACTIVATION");

            // Resolve user name — try DB lookup if userName is null
            String userName = act.getUserName();
            String userPhone = "N/A";
            if (userName == null || userName.isEmpty()) {
                if (act.getUserId() != null) {
                    userRepository.findById(act.getUserId()).ifPresent(u -> {
                        String name = u.getFullName();
                        if (name == null || name.isEmpty()) name = u.getEmail();
                        map.put("userName", name != null ? name : "User #" + u.getId());
                        map.put("userPhone", u.getPhoneNumber() != null ? u.getPhoneNumber() : "N/A");
                    });
                }
                if (!map.containsKey("userName")) {
                    map.put("userName", "User #" + act.getUserId());
                }
            } else {
                map.put("userName", userName);
            }
            if (!map.containsKey("userPhone")) map.put("userPhone", userPhone);

            map.put("lat", String.valueOf(act.getLatitude()));
            map.put("lng", String.valueOf(act.getLongitude()));
            map.put("status", act.getStatus() != null ? act.getStatus().toUpperCase() : "PENDING");
            map.put("time", act.getActivationTime() != null ? act.getActivationTime().toString() : "");
            map.put("mapsLink", "https://www.google.com/maps?q=" + act.getLatitude() + "," + act.getLongitude());
            result.add(map);
        }

        // 3. Fetch from new unified sosAlert table
        List<sosAlert> alerts = sosAlertRepository.findAll();
        for (sosAlert alert : alerts) {
            Map<String, Object> map = new HashMap<>();
            map.put("id", "alert_" + alert.getId());
            map.put("type", "SOS_ALERT");

            // Resolve user name — try DB lookup if userName is null
            String userName = alert.getUserName();
            String userPhone = alert.getUserPhone();
            if (userName == null || userName.isEmpty()) {
                if (alert.getUserId() != null) {
                    userRepository.findById(alert.getUserId()).ifPresent(u -> {
                        String name = u.getFullName();
                        if (name == null || name.isEmpty()) name = u.getEmail();
                        map.put("userName", name != null ? name : "User #" + u.getId());
                        map.put("userPhone", u.getPhoneNumber() != null ? u.getPhoneNumber() : "N/A");
                    });
                }
                if (!map.containsKey("userName")) {
                    map.put("userName", "User #" + alert.getUserId());
                }
            } else {
                map.put("userName", userName);
            }
            if (!map.containsKey("userPhone")) {
                map.put("userPhone", userPhone != null ? userPhone : "N/A");
            }

            map.put("lat", alert.getLatitude());
            map.put("lng", alert.getLongitude());
            map.put("status", alert.getStatus() != null ? alert.getStatus() : "ACTIVE");
            map.put("time", alert.getTimeOfActivation() != null ? alert.getTimeOfActivation().toString() : "");
            map.put("mapsLink", "https://www.google.com/maps?q=" + alert.getLatitude() + "," + alert.getLongitude());
            result.add(map);
        }

        // Sort combined list by time descending
        result.sort((a, b) -> {
            String t1 = (String) a.getOrDefault("time", "");
            String t2 = (String) b.getOrDefault("time", "");
            return t2.compareTo(t1);
        });

        return result;
    }

    // Purpose: Admin manually resolves an SOS alert.
    @PostMapping("/sos/{id}/resolve")
    @ResponseBody
    public Map<String, Object> resolveSos(@PathVariable String id, HttpSession session) {
        Map<String, Object> res = new HashMap<>();
        if (session.getAttribute("admin") == null) {
            res.put("success", false);
            return res;
        }

        try {
            if (id.startsWith("req_")) {
                Long reqId = Long.parseLong(id.substring(4));
                sosRequestRepository.findById(reqId).ifPresent(sos -> {
                    sos.setStatus(SOSRequest.SOSStatus.RESOLVED);
                    sos.setResolvedAt(LocalDateTime.now());
                    sosRequestRepository.save(sos);
                });
            } else if (id.startsWith("act_")) {
                Long actId = Long.parseLong(id.substring(4));
                sosActivationRepository.findById(actId).ifPresent(act -> {
                    act.setStatus("Resolved");
                    sosActivationRepository.save(act);
                });
            } else if (id.startsWith("alert_")) {
                Long alertId = Long.parseLong(id.substring(6));
                sosAlertRepository.findById(alertId).ifPresent(al -> {
                    al.setStatus("RESOLVED");
                    sosAlertRepository.save(al);
                });
            }
            res.put("success", true);
        } catch (Exception e) {
            res.put("success", false);
            res.put("error", e.getMessage());
        }

        return res;
    }

    @RequestMapping(value = "/videos", method = GET)
    public String showAllVideosForReward(Model model, HttpSession session) {

        if (session.getAttribute("admin") == null) {
            return "redirect:/admin/loginAdmin";
        }

        List<Videoupload> videos = videouploadRepository.findAll();

        
     
        for (Videoupload v : videos) {
            int score = v.getViewCount()
                       + (v.getLikeCount() * 5)
                       ;
            v.setScore(score);
        }

      
        videos.sort((a, b) -> b.getScore() - a.getScore());

        model.addAttribute("videos", videos);
        return "adminVideoRewards";
    }
    @RequestMapping(value = "/videos/reward/{id}", method = POST)
    public String rewardVideo(@PathVariable Long id,
                              HttpSession session,
                              RedirectAttributes redirectAttributes) {
        if (session.getAttribute("admin") == null) return "redirect:/admin/loginAdmin";

        Videoupload video = videouploadRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Video not found"));

        // 🔔 Here you can:
        // 1️⃣ Add wallet points
        // 2️⃣ Save reward history
        // 3️⃣ Send email / OneSignal notification

        redirectAttributes.addFlashAttribute("success",
                "Reward given to video: " + video.getTitle());
        // 1. Calculate the current score (Views + Likes*5 + Comments*8)
        int commentCount = (video.getComments() != null) ? video.getComments().size() : 0;
        int score = video.getViewCount()
                   + (video.getLikeCount() * 5)
                   + (commentCount * 8);

        // 2. Check eligibility (1 month rule)
        LocalDateTime oneMonthAgo = LocalDateTime.now().minusMonths(1);
        if (video.getUploadTime() != null && video.getUploadTime().isAfter(oneMonthAgo)) {
            redirectAttributes.addFlashAttribute("error", "Rewards can only be given for videos uploaded at least 1 month ago.");
            return "redirect:/admin/videos";
        }

        // 3. Award points to the uploader's wallet
        User uploader = video.getUser();
        if (uploader != null) {
            int currentPoints = (uploader.getRewardPoints() != null) ? uploader.getRewardPoints() : 0;
            uploader.setRewardPoints(currentPoints + score);
            userRepository.save(uploader);

            redirectAttributes.addFlashAttribute("success",
                    "Successfully awarded " + score + " coins to " + uploader.getFullName() + "'s wallet!");
        } else {
            redirectAttributes.addFlashAttribute("error", "Could not find uploader for this video.");
        }

        return "redirect:/admin/videos";
    }


    // Purpose: admin screen to verify registered users (used by Buddy Matching: verified-only).
    // Supports optional ?q= search param to filter users by name, email, or phone.
    @GetMapping("/pending-users")
    public String viewPendingUsers(@RequestParam(value = "q", required = false) String q,
                                   Model model, HttpSession session) {
        if (session.getAttribute("admin") == null) {
            return "redirect:/admin/loginAdmin";
        }

        // Purpose: if a search keyword is provided, run DB search and return flat results.
        if (q != null && !q.trim().isEmpty()) {
            List<User> searchResults = userRepository.searchUsers(q.trim());
            model.addAttribute("searchResults", searchResults);
            model.addAttribute("q", q.trim());
            return "adminPendingUsers";
        }

        // Purpose: treat NULL status as pending (older users before verificationStatus existed).
        List<User> pending = userRepository.findByVerificationStatus(VerificationStatus.PENDING);
        pending.addAll(userRepository.findByVerificationStatusIsNull());
        model.addAttribute("pending", pending);
        model.addAttribute("verified", userRepository.findByVerificationStatus(VerificationStatus.VERIFIED));
        model.addAttribute("rejected", userRepository.findByVerificationStatus(VerificationStatus.REJECTED));
        return "adminPendingUsers";
    }

    // Purpose: verify a user after identity document review.
    @PostMapping("/users/{id}/verify")
    public String verifyUser(@PathVariable Long id, HttpSession session, RedirectAttributes redirectAttributes) {
        if (session.getAttribute("admin") == null) {
            return "redirect:/admin/loginAdmin";
        }

        User u = userRepository.findById(id).orElse(null);
        if (u == null) {
            redirectAttributes.addFlashAttribute("message", "User not found.");
            return "redirect:/admin/pending-users";
        }

        u.setVerificationStatus(VerificationStatus.VERIFIED);
        userRepository.save(u);
        redirectAttributes.addFlashAttribute("message", "User verified successfully.");
        return "redirect:/admin/pending-users";
    }

    // Purpose: reject a user if documents are invalid.
    @PostMapping("/users/{id}/reject")
    public String rejectUser(@PathVariable Long id, HttpSession session, RedirectAttributes redirectAttributes) {
        if (session.getAttribute("admin") == null) {
            return "redirect:/admin/loginAdmin";
        }

        User u = userRepository.findById(id).orElse(null);
        if (u == null) {
            redirectAttributes.addFlashAttribute("message", "User not found.");
            return "redirect:/admin/pending-users";
        }

        u.setVerificationStatus(VerificationStatus.REJECTED);
        userRepository.save(u);
        redirectAttributes.addFlashAttribute("message", "User rejected.");
        return "redirect:/admin/pending-users";
    }

    // Purpose: admin views full profile of a specific user.
    @GetMapping("/users/{id}/profile")
    public String viewUserProfile(@PathVariable Long id, HttpSession session, Model model, RedirectAttributes redirectAttributes) {
        if (session.getAttribute("admin") == null) {
            return "redirect:/admin/loginAdmin";
        }

        User u = userRepository.findById(id).orElse(null);
        if (u == null) {
            redirectAttributes.addFlashAttribute("message", "User not found.");
            return "redirect:/admin/pending-users";
        }

        model.addAttribute("user", u);
        return "adminViewUserProfile";
    }

    // Purpose: admin verification for doctors (only VERIFIED doctors are shown in booking).
    // Supports optional ?q= search param to filter doctors by name, email, phone, specialization, or location.
    @GetMapping("/pending-doctors")
    public String viewPendingDoctors(@RequestParam(value = "q", required = false) String q,
                                     Model model, HttpSession session) {
        if (session.getAttribute("admin") == null) {
            return "redirect:/admin/loginAdmin";
        }

        // Purpose: if a search keyword is provided, run DB search and return flat results.
        if (q != null && !q.trim().isEmpty()) {
            List<Doctor> searchResults = doctorRepository.searchDoctors(q.trim());
            model.addAttribute("searchResults", searchResults);
            model.addAttribute("q", q.trim());
            return "adminPendingDoctors";
        }

        model.addAttribute("pending", doctorRepository.findByVerificationStatus(VerificationStatus.PENDING));
        model.addAttribute("verified", doctorRepository.findByVerificationStatus(VerificationStatus.VERIFIED));
        model.addAttribute("rejected", doctorRepository.findByVerificationStatus(VerificationStatus.REJECTED));
        return "adminPendingDoctors";
    }

    // Purpose: admin views full profile of a specific doctor.
    @GetMapping("/doctors/{id}/profile")
    public String viewDoctorProfile(@PathVariable Long id, HttpSession session, Model model, RedirectAttributes redirectAttributes) {
        if (session.getAttribute("admin") == null) {
            return "redirect:/admin/loginAdmin";
        }

        Doctor d = doctorRepository.findById(id).orElse(null);
        if (d == null) {
            redirectAttributes.addFlashAttribute("message", "Doctor not found.");
            return "redirect:/admin/pending-doctors";
        }

        model.addAttribute("doctor", d);
        return "adminViewDoctorProfile";
    }

    @PostMapping("/doctors/{id}/verify")
    public String verifyDoctor(@PathVariable Long id, HttpSession session, RedirectAttributes redirectAttributes) {
        if (session.getAttribute("admin") == null) {
            return "redirect:/admin/loginAdmin";
        }

        Doctor d = doctorRepository.findById(id).orElse(null);
        if (d == null) {
            redirectAttributes.addFlashAttribute("message", "Doctor not found.");
            return "redirect:/admin/pending-doctors";
        }
        d.setVerificationStatus(VerificationStatus.VERIFIED);
        doctorRepository.save(d);
        redirectAttributes.addFlashAttribute("message", "Doctor verified.");
        return "redirect:/admin/pending-doctors";
    }

    @PostMapping("/doctors/{id}/reject")
    public String rejectDoctor(@PathVariable Long id, HttpSession session, RedirectAttributes redirectAttributes) {
        if (session.getAttribute("admin") == null) {
            return "redirect:/admin/loginAdmin";
        }

        Doctor d = doctorRepository.findById(id).orElse(null);
        if (d == null) {
            redirectAttributes.addFlashAttribute("message", "Doctor not found.");
            return "redirect:/admin/pending-doctors";
        }
        d.setVerificationStatus(VerificationStatus.REJECTED);
        doctorRepository.save(d);
        redirectAttributes.addFlashAttribute("message", "Doctor rejected.");
        return "redirect:/admin/pending-doctors";
    }

    // Purpose: admin verification for marketplace providers (tutors/bakers/language trainers).
    @GetMapping("/pending-providers")
    public String viewPendingProviders(@RequestParam(required = false) ProviderCategory category, Model model, HttpSession session) {
        if (session.getAttribute("admin") == null) {
            return "redirect:/admin/loginAdmin";
        }

        if (category != null) {
            model.addAttribute("pending", serviceProviderRepository.findByCategoryAndVerificationStatus(category, VerificationStatus.PENDING));
            model.addAttribute("verified", serviceProviderRepository.findByCategoryAndVerificationStatus(category, VerificationStatus.VERIFIED));
            model.addAttribute("rejected", serviceProviderRepository.findByCategoryAndVerificationStatus(category, VerificationStatus.REJECTED));
            model.addAttribute("selectedCategory", category);
        } else {
            model.addAttribute("pending", serviceProviderRepository.findByVerificationStatus(VerificationStatus.PENDING));
            model.addAttribute("verified", serviceProviderRepository.findByVerificationStatus(VerificationStatus.VERIFIED));
            model.addAttribute("rejected", serviceProviderRepository.findByVerificationStatus(VerificationStatus.REJECTED));
        }
        return "adminPendingProviders";
    }

    @PostMapping("/providers/{id}/verify")
    public String verifyProvider(@PathVariable Long id, HttpSession session, RedirectAttributes redirectAttributes) {
        if (session.getAttribute("admin") == null) {
            return "redirect:/admin/loginAdmin";
        }
        ServiceProvider p = serviceProviderRepository.findById(id).orElse(null);
        if (p == null) {
            redirectAttributes.addFlashAttribute("message", "Provider not found.");
            return "redirect:/admin/pending-providers";
        }
        p.setVerificationStatus(VerificationStatus.VERIFIED);
        serviceProviderRepository.save(p);
        redirectAttributes.addFlashAttribute("message", "Provider verified.");
        return "redirect:/admin/pending-providers";
    }

    @PostMapping("/providers/{id}/reject")
    public String rejectProvider(@PathVariable Long id, HttpSession session, RedirectAttributes redirectAttributes) {
        if (session.getAttribute("admin") == null) {
            return "redirect:/admin/loginAdmin";
        }
        ServiceProvider p = serviceProviderRepository.findById(id).orElse(null);
        if (p == null) {
            redirectAttributes.addFlashAttribute("message", "Provider not found.");
            return "redirect:/admin/pending-providers";
        }
        p.setVerificationStatus(VerificationStatus.REJECTED);
        serviceProviderRepository.save(p);
        redirectAttributes.addFlashAttribute("message", "Provider rejected.");
        return "redirect:/admin/pending-providers";
    }

    // Purpose: admin views full profile of a specific marketplace provider.
    @GetMapping("/providers/{id}/profile")
    public String viewProviderProfile(@PathVariable Long id, HttpSession session, Model model, RedirectAttributes redirectAttributes) {
        if (session.getAttribute("admin") == null) {
            return "redirect:/admin/loginAdmin";
        }

        ServiceProvider p = serviceProviderRepository.findById(id).orElse(null);
        if (p == null) {
            redirectAttributes.addFlashAttribute("message", "Provider not found.");
            return "redirect:/admin/pending-providers";
        }

        model.addAttribute("provider", p);
        return "adminViewProviderProfile";
    }

    @GetMapping("/user-reels")
    public String showAllUserReels(Model model, HttpSession session) {
        if (session.getAttribute("admin") == null) {
            return "redirect:/admin/loginAdmin";
        }
        List<Videoupload> reels = videouploadRepository.findAll();
        reels.sort((a, b) -> Long.compare(b.getId(), a.getId()));
        model.addAttribute("reels", reels);
        return "adminUserReels";
    }

    @Transactional
    @PostMapping("/user-reels/delete/{id}")
    public String deleteUserReel(@PathVariable Long id, RedirectAttributes redirectAttributes, HttpSession session) {
        if (session.getAttribute("admin") == null) {
            return "redirect:/admin/loginAdmin";
        }
        try {
            videouploadRepository.deleteById(id);
            redirectAttributes.addFlashAttribute("successMessage", "Reel deleted successfully!");
        } catch (Exception e) {
            e.printStackTrace();
            redirectAttributes.addFlashAttribute("error", "Error deleting reel: " + e.getMessage());
        }
        return "redirect:/admin/user-reels";
    }

    // ==========================================
    // CONTACT MESSAGES (from public contact form)
    // ==========================================
    @GetMapping("/contact-messages")
    public String viewContactMessages(Model model, HttpSession session) {
        if (session.getAttribute("admin") == null) {
            return "redirect:/admin/loginAdmin";
        }
        model.addAttribute("contactMessages", contactMessageService.findAll());
        model.addAttribute("unreadContactMessages", contactMessageService.countUnread());
        return "adminContactMessages";
    }

    @PostMapping("/contact-messages/{id}/read")
    public String markContactMessageRead(@PathVariable Long id, HttpSession session) {
        if (session.getAttribute("admin") == null) {
            return "redirect:/admin/loginAdmin";
        }
        contactMessageService.markAsRead(id);
        return "redirect:/admin/contact-messages";
    }

    @PostMapping("/contact-messages/delete/{id}")
    public String deleteContactMessage(@PathVariable Long id, HttpSession session, RedirectAttributes redirectAttributes) {
        if (session.getAttribute("admin") == null) {
            return "redirect:/admin/loginAdmin";
        }
        try {
            contactMessageService.delete(id);
            redirectAttributes.addFlashAttribute("successMessage", "Contact message deleted.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Error deleting contact message.");
        }
        return "redirect:/admin/contact-messages";
    }

    // ==========================================
    // BROADCAST CENTER
    // ==========================================
    @GetMapping("/broadcast")
    public String viewBroadcastCenter(Model model, HttpSession session) {
        if (session.getAttribute("admin") == null) {
            return "redirect:/admin/loginAdmin";
        }
        model.addAttribute("broadcasts", broadcastMessageRepository.findAllByOrderBySentAtDesc());
        return "adminBroadcast";
    }

    @PostMapping("/broadcast/send")
    public String sendBroadcast(@RequestParam String title, 
                                @RequestParam String message, 
                                @RequestParam String type, 
                                HttpSession session, 
                                RedirectAttributes redirectAttributes) {
        if (session.getAttribute("admin") == null) {
            return "redirect:/admin/loginAdmin";
        }
        
        BroadcastMessage broadcast = new BroadcastMessage();
        broadcast.setTitle(title);
        broadcast.setMessage(message);
        broadcast.setType(type); // INFO, WARNING, ALERT
        
        broadcastMessageRepository.save(broadcast);
        
        // In a full implementation, here we would iterate over all users and save an in-app notification 
        // or trigger a Firebase Push Notification service.
        
        redirectAttributes.addFlashAttribute("successMessage", "Broadcast sent successfully to all users!");
        return "redirect:/admin/broadcast";
    }

    @PostMapping("/broadcast/delete/{id}")
    public String deleteBroadcast(@PathVariable Long id, HttpSession session, RedirectAttributes redirectAttributes) {
        if (session.getAttribute("admin") == null) {
            return "redirect:/admin/loginAdmin";
        }
        try {
            broadcastMessageRepository.deleteById(id);
            redirectAttributes.addFlashAttribute("successMessage", "Broadcast deleted successfully.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Error deleting broadcast.");
        }
        return "redirect:/admin/broadcast";
    }

    // ==========================================
    // REPORTS & EXPORTS
    // ==========================================
    @GetMapping("/reports")
    public String viewReports(Model model, HttpSession session) {
        if (session.getAttribute("admin") == null) {
            return "redirect:/admin/loginAdmin";
        }
        return "adminReports";
    }

    @GetMapping("/reports/export-users")
    public void exportUsers(HttpServletResponse response, HttpSession session) throws IOException {
        if (session.getAttribute("admin") == null) return;

        response.setContentType("text/csv");
        response.setHeader("Content-Disposition", "attachment; filename=\"users_report_" + LocalDateTime.now() + ".csv\"");

        List<User> users = userRepository.findAll();
        StringBuilder csv = new StringBuilder("ID,Full Name,Email,Phone,Verification Status,Reward Points\n");
        for (User u : users) {
            csv.append(u.getId()).append(",")
               .append("\"").append(u.getFullName() != null ? u.getFullName() : "").append("\",")
               .append(u.getEmail()).append(",")
               .append(u.getPhoneNumber()).append(",")
               .append(u.getVerificationStatus()).append(",")
               .append(u.getRewardPoints()).append("\n");
        }
        response.getWriter().write(csv.toString());
    }



    @GetMapping("/reports/export-sos")
    public void exportSOS(HttpServletResponse response, HttpSession session) throws IOException {
        if (session.getAttribute("admin") == null) return;

        response.setContentType("text/csv");
        response.setHeader("Content-Disposition", "attachment; filename=\"sos_report_" + LocalDateTime.now() + ".csv\"");

        List<SOSRequest> requests = sosRequestRepository.findAll();
        StringBuilder csv = new StringBuilder("ID,User,Status,Activated At,Resolved At,Escalated,Lat,Long\n");
        for (SOSRequest r : requests) {
            csv.append(r.getId()).append(",")
               .append("\"").append(r.getUser() != null ? r.getUser().getFullName() : "Unknown").append("\",")
               .append(r.getStatus()).append(",")
               .append(r.getActivatedAt()).append(",")
               .append(r.getResolvedAt()).append(",")
               .append(r.isEscalated()).append(",")
               .append(r.getLatitude()).append(",")
               .append(r.getLongitude()).append("\n");
        }
        response.getWriter().write(csv.toString());
    }

    @GetMapping("/reported-videos")
    public String viewReportedVideos(Model model) {
        List<VideoReport> reports = videoReportRepository.findAllByOrderByReportedAtDesc();
        model.addAttribute("reports", reports);
        return "reported-videos"; 
    }

    // Legacy support for double-admin path
    @GetMapping("/admin/reported-videos")
    public String legacyReportedVideos() {
        return "redirect:/admin/reported-videos";
    }

    @PostMapping("/reported-videos/block/{id}")
    public String blockReportedVideo(@PathVariable Long id, RedirectAttributes redirectAttributes, HttpSession session) {
        if (session.getAttribute("admin") == null) return "redirect:/admin/loginAdmin";
        Videoupload video = videouploadRepository.findById(id).orElse(null);
        if (video != null) {
            video.setBlocked(true);
            videouploadRepository.save(video);
            redirectAttributes.addFlashAttribute("message", "Video blocked successfully.");
        }
        return "redirect:/admin/reported-videos";
    }

    @Autowired
    private WomenProductSellerRepository womenSellerRepo;

    @Autowired
    private WomenProductOrderRepository womenOrderRepo;

    @Autowired
    private WomenProductRepository womenProductRepo;

    // Purpose: admin page to verify/reject women product sellers.
    @GetMapping("/pending-sellers")
    public String viewPendingSellers(Model model, HttpSession session) {
        if (session.getAttribute("admin") == null) return "redirect:/admin/loginAdmin";

        // Purpose: fix legacy rows with null status so they appear in Pending.
        for (WomenProductSeller s : womenSellerRepo.findAllByOrderByCreatedAtDesc()) {
            if (s.getVerificationStatus() == null) {
                s.setVerificationStatus(VerificationStatus.PENDING);
                womenSellerRepo.save(s);
            }
        }
        for (ServiceProvider p : serviceProviderRepository.findAll()) {
            if (p.getVerificationStatus() == null) {
                p.setVerificationStatus(VerificationStatus.PENDING);
                serviceProviderRepository.save(p);
            }
        }

        model.addAttribute("pending", womenSellerRepo.findByVerificationStatus(VerificationStatus.PENDING));
        model.addAttribute("verified", womenSellerRepo.findByVerificationStatus(VerificationStatus.VERIFIED));
        model.addAttribute("rejected", womenSellerRepo.findByVerificationStatus(VerificationStatus.REJECTED));

        // Purpose: sellers who registered via marketplace with WOMEN_PRODUCTS category.
        model.addAttribute("pendingMarketplace", serviceProviderRepository
                .findByCategoryAndVerificationStatus(ProviderCategory.WOMEN_PRODUCTS, VerificationStatus.PENDING));
        model.addAttribute("verifiedMarketplace", serviceProviderRepository
                .findByCategoryAndVerificationStatus(ProviderCategory.WOMEN_PRODUCTS, VerificationStatus.VERIFIED));
        model.addAttribute("rejectedMarketplace", serviceProviderRepository
                .findByCategoryAndVerificationStatus(ProviderCategory.WOMEN_PRODUCTS, VerificationStatus.REJECTED));

        return "adminPendingSellers";
    }

    @PostMapping("/sellers/{id}/verify")
    public String verifySeller(@PathVariable Long id, HttpSession session, RedirectAttributes ra) {
        if (session.getAttribute("admin") == null) return "redirect:/admin/loginAdmin";
        womenSellerRepo.findById(id).ifPresent(s -> {
            s.setVerificationStatus(VerificationStatus.VERIFIED);
            womenSellerRepo.save(s);
        });
        ra.addFlashAttribute("message", "Seller verified.");
        return "redirect:/admin/pending-sellers";
    }

    @PostMapping("/sellers/{id}/reject")
    public String rejectSeller(@PathVariable Long id, HttpSession session, RedirectAttributes ra) {
        if (session.getAttribute("admin") == null) return "redirect:/admin/loginAdmin";
        womenSellerRepo.findById(id).ifPresent(s -> {
            s.setVerificationStatus(VerificationStatus.REJECTED);
            womenSellerRepo.save(s);
        });
        ra.addFlashAttribute("message", "Seller rejected.");
        return "redirect:/admin/pending-sellers";
    }

    // Purpose: admin views full profile of a specific women product seller.
    @GetMapping("/sellers/{id}/profile")
    public String viewSellerProfile(@PathVariable Long id, HttpSession session, Model model, RedirectAttributes ra) {
        if (session.getAttribute("admin") == null) return "redirect:/admin/loginAdmin";
        WomenProductSeller seller = womenSellerRepo.findById(id).orElse(null);
        if (seller == null) {
            ra.addFlashAttribute("message", "Seller not found.");
            return "redirect:/admin/pending-sellers";
        }
        model.addAttribute("seller", seller);
        return "adminViewSellerProfile";
    }

    // Purpose: admin views all women product orders + stock levels.
    @GetMapping("/women-product-orders")
    public String viewAllWomenOrders(Model model, HttpSession session) {
        if (session.getAttribute("admin") == null) return "redirect:/admin/loginAdmin";
        model.addAttribute("orders", womenOrderRepo.findAllByOrderByOrderTimeDesc());
        model.addAttribute("products", womenProductRepo.findByActiveTrueOrderByCreatedAtDesc());
        return "adminWomenProductOrders";
    }


    @RequestMapping(value = "/buddy-management", method = GET)
    public String showBuddyManagement(Model model) {
        List<BuddyAvailability> activeAvailabilities = buddyAvailabilityRepository.findAll().stream()
                .filter(a -> a.isActive())
                .collect(java.util.stream.Collectors.toList());
        
        List<BuddyRequest> activeRequests = buddyRequestRepository.findAll().stream()
                .filter(r -> r.getStatus() == BuddyRequestStatus.ACCEPTED || r.getStatus() == BuddyRequestStatus.PENDING)
                .collect(java.util.stream.Collectors.toList());

        model.addAttribute("availabilities", activeAvailabilities);
        model.addAttribute("requests", activeRequests);
        return "adminBuddyManagement";
    }

    @RequestMapping(value = "/safety-points", method = GET)
    public String showSafetyPoints(Model model, HttpSession session) {
        if (session.getAttribute("admin") == null) return "redirect:/admin/loginAdmin";
        model.addAttribute("pendingPoints", dangerPointRepository.findByVerified(false));
        model.addAttribute("verifiedPoints", dangerPointRepository.findByVerified(true));
        model.addAttribute("pendingRoutes", safeRouteRepository.findByVerified(false));
        model.addAttribute("verifiedRoutes", safeRouteRepository.findByVerified(true));
        return "adminSafetyPoints";
    }

    @PostMapping("/safety-points/danger/{id}/verify")
    public String verifyDangerPoint(@PathVariable Long id, RedirectAttributes ra) {
        dangerPointRepository.findById(id).ifPresent(p -> {
            p.setVerified(true);
            dangerPointRepository.save(p);
        });
        ra.addFlashAttribute("message", "Danger point verified and is now live.");
        return "redirect:/admin/safety-points";
    }

    @PostMapping("/safety-points/danger/{id}/delete")
    public String deleteDangerPoint(@PathVariable Long id, RedirectAttributes ra) {
        dangerPointRepository.deleteById(id);
        ra.addFlashAttribute("message", "Danger point removed.");
        return "redirect:/admin/safety-points";
    }

    @PostMapping("/safety-points/route/{id}/verify")
    public String verifySafeRoute(@PathVariable Long id, RedirectAttributes ra) {
        safeRouteRepository.findById(id).ifPresent(r -> {
            r.setVerified(true);
            safeRouteRepository.save(r);
        });
        ra.addFlashAttribute("message", "Safe route verified.");
        return "redirect:/admin/safety-points";
    }

    @PostMapping("/safety-points/route/{id}/delete")
    public String deleteSafeRoute(@PathVariable Long id, RedirectAttributes ra) {
        safeRouteRepository.deleteById(id);
        ra.addFlashAttribute("message", "Safe route removed.");
        return "redirect:/admin/safety-points";
    }

    @RequestMapping(value = "/salons", method = GET)
    public String showSalons(Model model, HttpSession session) {
        if (session.getAttribute("admin") == null) return "redirect:/admin/loginAdmin";
        model.addAttribute("pendingSalons", salonRepository.findByApproved(false));
        model.addAttribute("approvedSalons", salonRepository.findByApproved(true));
        return "adminSalons";
    }

    @PostMapping("/salons/{id}/approve")
    public String approveSalon(@PathVariable Long id, RedirectAttributes ra) {
        salonRepository.findById(id).ifPresent(s -> {
            s.setApproved(true);
            salonRepository.save(s);
        });
        ra.addFlashAttribute("message", "Salon approved successfully.");
        return "redirect:/admin/salons";
    }

    @PostMapping("/salons/{id}/reject")
    public String rejectSalon(@PathVariable Long id, RedirectAttributes ra) {
        salonRepository.deleteById(id);
        ra.addFlashAttribute("message", "Salon rejected and removed.");
        return "redirect:/admin/salons";
    }

    @PostMapping("/salons/{id}/delete")
    public String deleteSalon(@PathVariable Long id, RedirectAttributes ra) {
        salonRepository.deleteById(id);
        ra.addFlashAttribute("message", "Salon deleted successfully.");
        return "redirect:/admin/salons";
    }

    @GetMapping("/salons/{id}/profile")
    public String viewSalonProfile(@PathVariable Long id, Model model, HttpSession session) {
        if (session.getAttribute("admin") == null) return "redirect:/admin/loginAdmin";
        Salon salon = salonRepository.findById(id).orElse(null);
        if (salon == null) return "redirect:/admin/salons";
        model.addAttribute("salon", salon);
        return "adminViewSalonProfile";
    }

    @GetMapping("/stylists")
    public String manageStylists(Model model, HttpSession session) {
        if (session.getAttribute("admin") == null) return "redirect:/admin/loginAdmin";
        model.addAttribute("pendingStylists", stylistRepository.findByApproved(false));
        model.addAttribute("approvedStylists", stylistRepository.findByApproved(true));
        return "adminStylists";
    }

    @PostMapping("/stylists/{id}/approve")
    public String approveStylist(@PathVariable Long id, RedirectAttributes ra) {
        Stylist stylist = stylistRepository.findById(id).orElse(null);
        if (stylist != null) {
            stylist.setApproved(true);
            stylistRepository.save(stylist);
            ra.addFlashAttribute("message", "Stylist approved successfully.");
        }
        return "redirect:/admin/stylists";
    }

    @PostMapping("/stylists/{id}/reject")
    public String rejectStylist(@PathVariable Long id, RedirectAttributes ra) {
        stylistRepository.deleteById(id);
        ra.addFlashAttribute("message", "Stylist rejected and removed.");
        return "redirect:/admin/stylists";
    }

    @GetMapping("/stylists/{id}/profile")
    public String viewStylistProfile(@PathVariable Long id, Model model, HttpSession session) {
        if (session.getAttribute("admin") == null) return "redirect:/admin/loginAdmin";
        Stylist stylist = stylistRepository.findById(id).orElse(null);
        if (stylist == null) return "redirect:/admin/stylists";
        model.addAttribute("stylist", stylist);
        return "adminViewStylistProfile";
    }


    @Autowired
    private JobApplicationRepository jobApplicationRepository;

    @GetMapping("/job-applications")
    public String manageJobApplications(Model model, HttpSession session) {
        if (session.getAttribute("admin") == null) return "redirect:/admin/loginAdmin";
        model.addAttribute("pendingApplications", jobApplicationRepository.findByStatus(VerificationStatus.PENDING));
        model.addAttribute("approvedApplications", jobApplicationRepository.findByStatus(VerificationStatus.VERIFIED));
        model.addAttribute("rejectedApplications", jobApplicationRepository.findByStatus(VerificationStatus.REJECTED));
        return "adminPendingJobs";
    }

    @PostMapping("/job-applications/{id}/approve")
    public String approveJobApplication(@PathVariable Long id, RedirectAttributes ra) {
        jobApplicationRepository.findById(id).ifPresent(app -> {
            app.setStatus(VerificationStatus.VERIFIED);
            jobApplicationRepository.save(app);
        });
        ra.addFlashAttribute("message", "Job Application approved successfully.");
        return "redirect:/admin/job-applications";
    }

    @PostMapping("/job-applications/{id}/reject")
    public String rejectJobApplication(@PathVariable Long id, RedirectAttributes ra) {
        jobApplicationRepository.findById(id).ifPresent(app -> {
            app.setStatus(VerificationStatus.REJECTED);
            jobApplicationRepository.save(app);
        });
        ra.addFlashAttribute("message", "Job Application rejected.");
        return "redirect:/admin/job-applications";
    }
    // --- Women Entrepreneur Investment Platform Admin Actions ---

    @GetMapping("/pending-proposals")
    public String viewPendingProposals(Model model, HttpSession session) {
        if (session.getAttribute("admin") == null) return "redirect:/admin/loginAdmin";
        
        List<BusinessProposal> allProposals = businessProposalRepository.findAll();
        List<Entrepreneur> allEntrepreneurs = entrepreneurRepository.findAll();
        List<Investor> allInvestors = investorRepository.findAll();
        List<InvestmentMeeting> allMeetings = investmentMeetingRepository.findAll();
        List<Investment> allInvestments = investmentRepository.findAll();
        List<ProposalQuestion> allQuestions = proposalQuestionRepository.findAll();
        List<ProposalChatMessage> allChats = proposalChatMessageRepository.findAll();

        // Sort chat messages by timestamp descending
        allChats.sort((c1, c2) -> {
            if (c1.getTimestamp() == null || c2.getTimestamp() == null) return 0;
            return c2.getTimestamp().compareTo(c1.getTimestamp());
        });

        model.addAttribute("allProposals", allProposals);
        model.addAttribute("allEntrepreneurs", allEntrepreneurs);
        model.addAttribute("allInvestors", allInvestors);
        model.addAttribute("allMeetings", allMeetings);
        model.addAttribute("allInvestments", allInvestments);
        model.addAttribute("allQuestions", allQuestions);
        model.addAttribute("allChats", allChats);

        // Pending counts for quick badge counters in UI tabs
        long pendingProposalsCount = allProposals.stream().filter(p -> p.getStatus() == VerificationStatus.PENDING).count();
        long pendingEntCount = allEntrepreneurs.stream().filter(e -> e.getVerificationStatus() == VerificationStatus.PENDING).count();
        long pendingInvCount = allInvestors.stream().filter(i -> i.getVerificationStatus() == VerificationStatus.PENDING).count();
        
        model.addAttribute("pendingProposalsCount", pendingProposalsCount);
        model.addAttribute("pendingEntCount", pendingEntCount);
        model.addAttribute("pendingInvCount", pendingInvCount);

        return "admin/pendingProposals";
    }

    @PostMapping("/proposals/{id}/approve")
    public String approveProposal(@PathVariable Long id, HttpSession session, RedirectAttributes ra) {
        if (session.getAttribute("admin") == null) return "redirect:/admin/loginAdmin";
        businessProposalRepository.findById(id).ifPresent(p -> {
            p.setStatus(VerificationStatus.VERIFIED);
            businessProposalRepository.save(p);
        });
        ra.addFlashAttribute("message", "Business proposal approved successfully.");
        return "redirect:/admin/pending-proposals";
    }

    @PostMapping("/proposals/{id}/reject")
    public String rejectProposal(@PathVariable Long id, HttpSession session, RedirectAttributes ra) {
        if (session.getAttribute("admin") == null) return "redirect:/admin/loginAdmin";
        businessProposalRepository.findById(id).ifPresent(p -> {
            p.setStatus(VerificationStatus.REJECTED);
            businessProposalRepository.save(p);
        });
        ra.addFlashAttribute("message", "Business proposal rejected.");
        return "redirect:/admin/pending-proposals";
    }

    @PostMapping("/entrepreneurs/{id}/approve")
    public String approveEntrepreneur(@PathVariable Long id, HttpSession session, RedirectAttributes ra) {
        if (session.getAttribute("admin") == null) return "redirect:/admin/loginAdmin";
        entrepreneurRepository.findById(id).ifPresent(e -> {
            e.setVerificationStatus(VerificationStatus.VERIFIED);
            entrepreneurRepository.save(e);
        });
        ra.addFlashAttribute("message", "Entrepreneur verified successfully.");
        return "redirect:/admin/pending-proposals";
    }

    @PostMapping("/entrepreneurs/{id}/reject")
    public String rejectEntrepreneur(@PathVariable Long id, HttpSession session, RedirectAttributes ra) {
        if (session.getAttribute("admin") == null) return "redirect:/admin/loginAdmin";
        entrepreneurRepository.findById(id).ifPresent(e -> {
            e.setVerificationStatus(VerificationStatus.REJECTED);
            entrepreneurRepository.save(e);
        });
        ra.addFlashAttribute("message", "Entrepreneur verification rejected.");
        return "redirect:/admin/pending-proposals";
    }

    @PostMapping("/investors/{id}/approve")
    public String approveInvestor(@PathVariable Long id, HttpSession session, RedirectAttributes ra) {
        if (session.getAttribute("admin") == null) return "redirect:/admin/loginAdmin";
        investorRepository.findById(id).ifPresent(i -> {
            i.setVerificationStatus(VerificationStatus.VERIFIED);
            investorRepository.save(i);
        });
        ra.addFlashAttribute("message", "Investor verified successfully.");
        return "redirect:/admin/pending-proposals";
    }

    @PostMapping("/investors/{id}/reject")
    public String rejectInvestor(@PathVariable Long id, HttpSession session, RedirectAttributes ra) {
        if (session.getAttribute("admin") == null) return "redirect:/admin/loginAdmin";
        investorRepository.findById(id).ifPresent(i -> {
            i.setVerificationStatus(VerificationStatus.REJECTED);
            investorRepository.save(i);
        });
        ra.addFlashAttribute("message", "Investor verification rejected.");
        return "redirect:/admin/pending-proposals";
    }

    @GetMapping("/investment-revenue")
    public String viewInvestmentRevenue(Model model, HttpSession session) {
        if (session.getAttribute("admin") == null) return "redirect:/admin/loginAdmin";

        List<Investment> allInvestments = investmentRepository.findAll();
        List<Entrepreneur> allEntrepreneurs = entrepreneurRepository.findAll();
        List<Investor> allInvestors = investorRepository.findAll();
        List<BusinessProposal> allProposals = businessProposalRepository.findAll();

        double verificationFees = allEntrepreneurs.stream().filter(Entrepreneur::isVerificationFeePaid).count() * 499.0;
        double subscriptionFees = allInvestors.stream().filter(Investor::isSubscribed).count() * 1999.0;
        
        double premiumListingFees = allProposals.stream().filter(BusinessProposal::isPremium).count() * 999.0;
        double featuredListingFees = allProposals.stream().filter(BusinessProposal::isFeatured).count() * 999.0;

        double platformCommissions = allInvestments.stream()
                .filter(Investment::isCommissionPaid)
                .mapToDouble(i -> (i.getReleasedAmount() != null ? i.getReleasedAmount() : i.getAmount()) * 0.02)
                .sum();

        double adminRetainedAmount = allInvestments.stream()
                .filter(i -> "COMPLETED".equals(i.getStatus()) && i.getAdminAmount() != null)
                .mapToDouble(Investment::getAdminAmount)
                .sum();

        double totalRevenue = verificationFees + subscriptionFees + premiumListingFees + featuredListingFees + platformCommissions + adminRetainedAmount;

        model.addAttribute("verificationFees", verificationFees);
        model.addAttribute("subscriptionFees", subscriptionFees);
        model.addAttribute("premiumListingFees", premiumListingFees);
        model.addAttribute("featuredListingFees", featuredListingFees);
        model.addAttribute("platformCommissions", platformCommissions);
        model.addAttribute("adminRetainedAmount", adminRetainedAmount);
        model.addAttribute("totalRevenue", totalRevenue);
        model.addAttribute("investments", allInvestments);

        return "admin/investmentRevenue";
    }

    @PostMapping("/investments/{id}/release")
    @Transactional
    public String releaseInvestment(
            @PathVariable("id") Long id,
            @RequestParam("releasedAmount") Double releasedAmount,
            HttpSession session,
            RedirectAttributes ra) {
        if (session.getAttribute("admin") == null) return "redirect:/admin/loginAdmin";
        
        Optional<Investment> opt = investmentRepository.findById(id);
        if (opt.isPresent()) {
            Investment inv = opt.get();
            if ("PENDING".equals(inv.getStatus())) {
                if (releasedAmount == null || releasedAmount < 0 || releasedAmount > inv.getAmount()) {
                    ra.addFlashAttribute("error", "Invalid release amount. Must be between 0 and ₹" + inv.getAmount() + ".");
                    return "redirect:/admin/pending-proposals";
                }
                
                inv.setStatus("COMPLETED");
                inv.setReleasedAmount(releasedAmount);
                double adminAmount = inv.getAmount() - releasedAmount;
                inv.setAdminAmount(adminAmount);
                investmentRepository.save(inv);
                
                BusinessProposal proposal = inv.getProposal();
                proposal.setAmountRaised(proposal.getAmountRaised() + releasedAmount);
                businessProposalRepository.save(proposal);
                
                String msg = "Successfully processed investment release: ₹" + releasedAmount + " released to entrepreneur " + proposal.getEntrepreneur().getFullName();
                if (adminAmount > 0) {
                    msg += " and ₹" + adminAmount + " retained by Admin account.";
                } else {
                    msg += ".";
                }
                ra.addFlashAttribute("message", msg);
            } else {
                ra.addFlashAttribute("error", "Investment is not in PENDING status.");
            }
        } else {
            ra.addFlashAttribute("error", "Investment not found.");
        }
        return "redirect:/admin/pending-proposals";
    }

    // VERIFY TRAINER CERTIFICATIONS
    @PostMapping("/fitness/verify")
    @Transactional
    public String verifyFitnessTrainer(
            @RequestParam Long id,
            @RequestParam boolean approve,
            HttpSession session, RedirectAttributes ra) {
        if (session.getAttribute("admin") == null) return "redirect:/admin/loginAdmin";

        FitnessTrainer trainer = fitnessTrainerRepository.findById(id).orElse(null);
        if (trainer != null) {
            trainer.setVerificationStatus(approve ? VerificationStatus.VERIFIED : VerificationStatus.REJECTED);
            fitnessTrainerRepository.save(trainer);
            ra.addFlashAttribute("message", "Trainer verification status updated to " + trainer.getVerificationStatus());
        } else {
            ra.addFlashAttribute("error", "Trainer not found.");
        }
        return "redirect:/admin/adminDashboard#fitnessOversightTabs";
    }

    // SUSPEND/ACTIVATE TRAINER PROFILE
    @PostMapping("/fitness/suspend")
    @Transactional
    public String suspendFitnessTrainer(
            @RequestParam Long id,
            @RequestParam boolean suspend,
            HttpSession session, RedirectAttributes ra) {
        if (session.getAttribute("admin") == null) return "redirect:/admin/loginAdmin";

        FitnessTrainer trainer = fitnessTrainerRepository.findById(id).orElse(null);
        if (trainer != null) {
            trainer.setSuspended(suspend);
            fitnessTrainerRepository.save(trainer);
            ra.addFlashAttribute("message", suspend ? "Trainer account suspended." : "Trainer account activated.");
        } else {
            ra.addFlashAttribute("error", "Trainer not found.");
        }
        return "redirect:/admin/adminDashboard#fitnessOversightTabs";
    }
}

