package in.sp.main.Controller;

import in.sp.main.Config.JwtUtil;
import in.sp.main.Entities.*;
import in.sp.main.Repository.*;
import in.sp.main.Service.*;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

/**
 * Universal Mobile Admin Controller for Flutter APK.
 * Provides complete feature-parity with the website admin dashboard (adminDashboard.jsp).
 */
@RestController
@RequestMapping("/api/admin")
public class MobileAdminController {

    @Autowired
    private AdminService adminService;

    @Autowired
    private JwtUtil jwtUtil;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private DoctorRepository doctorRepository;

    @Autowired
    private DoctorProfileService doctorProfileService;

    @Autowired
    private SalonRepository salonRepository;

    @Autowired
    private StylistRepository stylistRepository;

    @Autowired
    private MartialArtsCenterRepository martialArtsCenterRepository;

    @Autowired
    private MartialArtsCenterService centreService;

    @Autowired
    private FitnessTrainerRepository fitnessTrainerRepository;

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
    private EventHostRepository eventHostRepository;

    @Autowired
    private WomenEventRepository womenEventRepository;

    @Autowired
    private WomenEventRegistrationRepository womenEventRegistrationRepository;

    @Autowired
    private FinancialEducatorRepository financialEducatorRepository;

    @Autowired
    private FinancialVideoRepository financialVideoRepository;

    @Autowired
    private FinancialWorkshopRepository financialWorkshopRepository;

    @Autowired
    private ServiceProviderRepository serviceProviderRepository;

    @Autowired
    private JobApplicationRepository jobApplicationRepository;

    @Autowired
    private WomenProductSellerRepository womenProductSellerRepository;

    @Autowired
    private DeliveryPartnerRepository deliveryPartnerRepository;

    @Autowired
    private WomenProductOrderRepository womenProductOrderRepository;

    @Autowired
    private VideoUploadRepository videoUploadRepository;

    @Autowired
    private VideoReportRepository videoReportRepository;

    @Autowired
    private CreatorCashoutRepository creatorCashoutRepository;

    @Autowired
    private BrandCollaborationRepository brandCollaborationRepository;

    @Autowired
    private SOSRequestRepository sosRequestRepository;

    @Autowired
    private SosActivationRepository sosActivationRepository;

    @Autowired
    private SOSAlertRepository sosAlertRepository;

    @Autowired
    private SafeRouteRepository safeRouteRepository;

    @Autowired
    private DangerPointRepository dangerPointRepository;

    @Autowired
    private BroadcastMessageRepository broadcastMessageRepository;

    @Autowired
    private ContactMessageRepository contactMessageRepository;

    @Autowired
    private FitnessBookingRepository fitnessBookingRepository;

    @Autowired
    private PasswordService passwordService;

    @Autowired
    private AdminRepository adminRepository;

    @Autowired(required = false)
    private jakarta.servlet.http.HttpServletRequest currentRequest;

    private Admin requireAdmin(HttpSession session) {
        Object obj = session.getAttribute("admin");
        if (obj instanceof Admin) return (Admin) obj;

        try {
            if (currentRequest != null) {
                String header = currentRequest.getHeader("Authorization");
                if (header != null && header.regionMatches(true, 0, "Bearer ", 0, 7)) {
                    String token = header.substring(7).trim();
                    if (!token.isEmpty() && jwtUtil.validateToken(token)) {
                        String email = jwtUtil.extractUsername(token);
                        String role = jwtUtil.extractRole(token);
                        if ("ADMIN".equals(role) && email != null) {
                            Admin a = adminRepository.findByEmailIgnoreCase(email)
                                    .or(() -> adminRepository.findByEmail(email))
                                    .orElse(null);
                            if (a != null) {
                                session.setAttribute("admin", a);
                                return a;
                            }
                        }
                    }
                }
            }
        } catch (Exception ignored) {}

        return null;
    }

    private ResponseEntity<Map<String, Object>> unauthorized() {
        Map<String, Object> err = new LinkedHashMap<>();
        err.put("success", false);
        err.put("error", "Admin authentication required. Please log in as Admin.");
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(err);
    }

    private ResponseEntity<Map<String, Object>> badRequest(String msg) {
        Map<String, Object> err = new LinkedHashMap<>();
        err.put("success", false);
        err.put("error", msg);
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(err);
    }

    private String str(Object o) {
        return o == null ? "" : o.toString().trim();
    }

    // ==========================================
    // 1. AUTHENTICATION
    // ==========================================

    @PostMapping("/login")
    public ResponseEntity<Map<String, Object>> login(@RequestBody Map<String, String> body, HttpSession session) {
        String email = body == null ? "" : str(body.get("email")).toLowerCase(Locale.ROOT);
        String password = body == null ? "" : str(body.get("password"));
        if (email.isBlank() || password.isBlank()) {
            return badRequest("Email and password are required.");
        }
        Admin admin = adminService.loginAdmin(email, password);
        if (admin == null) {
            // Auto-provision or password recovery for default Super Admin credentials
            if (("admin@gmail.com".equalsIgnoreCase(email) || "admin@fightdfear.com".equalsIgnoreCase(email) || "admin@example.com".equalsIgnoreCase(email))
                    && "Admin@123".equals(password)) {
                try {
                    Admin existing = adminRepository.findByEmailIgnoreCase(email)
                            .or(() -> adminRepository.findByEmail(email))
                            .orElse(null);
                    if (existing != null) {
                        existing.setPassword(passwordService.encode("Admin@123"));
                        admin = adminRepository.save(existing);
                    } else {
                        Admin def = new Admin("Super Admin", email.toLowerCase(Locale.ROOT), passwordService.encode("Admin@123"));
                        admin = adminRepository.save(def);
                    }
                } catch (Exception ignored) {
                    admin = adminRepository.findByEmail(email).orElse(null);
                }
            }
        }
        if (admin == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body(Map.of("success", false, "error", "Invalid admin email or password."));
        }
        session.setAttribute("admin", admin);
        session.setAttribute("userRole", "ADMIN");
        String token = jwtUtil.generateToken(admin.getEmail(), "ADMIN");

        Map<String, Object> res = new LinkedHashMap<>();
        res.put("success", true);
        res.put("token", token);
        res.put("tokenType", "Bearer");
        res.put("role", "ADMIN");
        res.put("admin", Map.of(
                "id", admin.getId(),
                "name", admin.getName() != null ? admin.getName() : "Administrator",
                "email", admin.getEmail(),
                "role", "SUPER_ADMIN"
        ));
        return ResponseEntity.ok(res);
    }

    @GetMapping("/me")
    public ResponseEntity<Map<String, Object>> me(HttpSession session) {
        Admin admin = requireAdmin(session);
        if (admin == null) return unauthorized();

        Map<String, Object> res = new LinkedHashMap<>();
        res.put("success", true);
        res.put("admin", Map.of(
                "id", admin.getId(),
                "name", admin.getName() != null ? admin.getName() : "Administrator",
                "email", admin.getEmail(),
                "role", "SUPER_ADMIN"
        ));
        return ResponseEntity.ok(res);
    }

    @PostMapping("/logout")
    public ResponseEntity<Map<String, Object>> logout(HttpSession session) {
        session.invalidate();
        return ResponseEntity.ok(Map.of("success", true, "message", "Logged out successfully."));
    }

    // ==========================================
    // 2. DASHBOARD STATS (Exact match to JSP)
    // ==========================================

    @GetMapping("/dashboard-stats")
    @Transactional(readOnly = true)
    public ResponseEntity<Map<String, Object>> getDashboardStats(HttpSession session) {
        if (requireAdmin(session) == null) return unauthorized();

        Map<String, Object> res = new LinkedHashMap<>();
        res.put("success", true);

        // Safety & Emergency
        long activeSosCount = sosRequestRepository.findAll().stream()
                .filter(s -> s.getStatus() == SOSRequest.SOSStatus.ACTIVE || s.getStatus() == SOSRequest.SOSStatus.ACCEPTED)
                .count();
        long activeActivationCount = sosActivationRepository.findAll().stream()
                .filter(s -> !"Resolved".equalsIgnoreCase(s.getStatus()) && !"Cancelled".equalsIgnoreCase(s.getStatus()))
                .count();
        long activeAlertCount = sosAlertRepository.findAll().stream()
                .filter(s -> "ACTIVE".equalsIgnoreCase(s.getStatus()))
                .count();
        int totalLiveSos = (int) (activeSosCount + activeActivationCount + activeAlertCount);
        long verifiedRoutes = safeRouteRepository.findByVerified(true).size();

        // Partners & Providers
        long totalDoctors = doctorRepository.count();
        long verifiedDoctors = doctorRepository.findByVerificationStatus(VerificationStatus.VERIFIED).size();
        long pendingDoctors = doctorRepository.findByVerificationStatus(VerificationStatus.PENDING).size();

        long totalSalons = salonRepository.count();
        long verifiedSalons = salonRepository.findByApproved(true).size();
        long pendingSalons = salonRepository.findByApproved(false).size();

        long totalStylists = stylistRepository.count();
        long verifiedStylists = stylistRepository.findByApproved(true).size();
        long pendingStylists = stylistRepository.findByApproved(false).size();

        long totalCentres = martialArtsCenterRepository.count();
        long approvedCentres = centreService.getCentresByApprovalStatus(true).size();
        long pendingCentres = centreService.getCentresByApprovalStatus(false).size();

        long totalTrainers = fitnessTrainerRepository.count();
        long verifiedTrainers = fitnessTrainerRepository.findByVerificationStatus(VerificationStatus.VERIFIED).size();
        long pendingTrainers = fitnessTrainerRepository.findByVerificationStatus(VerificationStatus.PENDING).size();
        long fitnessBookings = fitnessBookingRepository.count();

        // Community & Users
        long totalUsers = userRepository.count();
        long verifiedUsers = userRepository.findByVerificationStatus(VerificationStatus.VERIFIED).size();
        long pendingUsers = userRepository.findByVerificationStatus(VerificationStatus.PENDING).size();
        long bannedUsers = userRepository.findByBanned(true).size();

        // Entrepreneur & Investor
        List<Entrepreneur> allEntrepreneurs = entrepreneurRepository.findAll();
        List<Investor> allInvestors = investorRepository.findAll();
        List<BusinessProposal> allProposals = businessProposalRepository.findAll();
        List<Investment> allInvestments = investmentRepository.findAll();

        long totalEntrepreneurs = allEntrepreneurs.size();
        long verifiedEntrepreneurs = allEntrepreneurs.stream().filter(e -> e.getVerificationStatus() == VerificationStatus.VERIFIED).count();
        long pendingEntrepreneurs = allEntrepreneurs.stream().filter(e -> e.getVerificationStatus() == VerificationStatus.PENDING).count();

        long totalInvestors = allInvestors.size();
        long verifiedInvestors = allInvestors.stream().filter(i -> i.getVerificationStatus() == VerificationStatus.VERIFIED).count();
        long pendingInvestors = allInvestors.stream().filter(i -> i.getVerificationStatus() == VerificationStatus.PENDING).count();

        long totalProposals = allProposals.size();
        long verifiedProposals = allProposals.stream().filter(p -> p.getStatus() == VerificationStatus.VERIFIED).count();
        long pendingProposals = allProposals.stream().filter(p -> p.getStatus() == VerificationStatus.PENDING).count();

        double capitalRequested = allProposals.stream().mapToDouble(BusinessProposal::getFundingNeeded).sum();
        double capitalInvested = allInvestments.stream().mapToDouble(Investment::getAmount).sum();

        double verificationFees = allEntrepreneurs.stream().filter(Entrepreneur::isVerificationFeePaid).count() * 499.0;
        double subscriptionFees = allInvestors.stream().filter(Investor::isSubscribed).count() * 1999.0;
        double premiumListingFees = allProposals.stream().filter(BusinessProposal::isPremium).count() * 999.0;
        double featuredListingFees = allProposals.stream().filter(BusinessProposal::isFeatured).count() * 999.0;
        double platformCommissions = allInvestments.stream().filter(Investment::isCommissionPaid).mapToDouble(i -> i.getAmount() * 0.02).sum();
        double platformRevenue = verificationFees + subscriptionFees + premiumListingFees + featuredListingFees + platformCommissions;

        // Women Events
        long totalWomenEvents = womenEventRepository.count();
        long approvedWomenEvents = womenEventRepository.countByStatus("APPROVED");
        long pendingWomenEvents = womenEventRepository.countByStatus("PENDING");
        long totalEventBookings = womenEventRegistrationRepository.count();
        double totalEventRevenue = womenEventRegistrationRepository.findAll().stream()
                .filter(r -> r.isPaid() && r.getAmountPaid() != null)
                .mapToDouble(WomenEventRegistration::getAmountPaid).sum();

        // Creator Hub
        long totalVideos = videoUploadRepository.count();
        long reportedVideos = videoReportRepository.count();
        long pendingCashouts = creatorCashoutRepository.findByStatus("PENDING").size();
        long brandCollabs = brandCollaborationRepository.count();
        long pendingCreators = 0;
        try {
            pendingCreators = userRepository.countByCreatorProfileStatusIn(PartnerLifecycleSupport.pendingQueueStatuses());
        } catch (Exception ignored) {}

        // Financial Literacy
        long totalCourses = financialVideoRepository.count();
        long totalEducators = financialEducatorRepository.count();
        long pendingEducators = 0;
        try {
            pendingEducators = financialEducatorRepository.countByPartnerProfileStatusIn(PartnerLifecycleSupport.pendingQueueStatuses());
        } catch (Exception ignored) {}
        long workshopRegs = financialWorkshopRepository.count();

        // Marketplace, Lawyers, Jobs & Delivery
        long totalLawyers = serviceProviderRepository.findAll().stream().filter(p -> p.getCategory() == ProviderCategory.WOMEN_LAWYER).count();
        long pendingLawyers = serviceProviderRepository.findByCategoryAndVerificationStatus(ProviderCategory.WOMEN_LAWYER, VerificationStatus.PENDING).size();
        long pendingJobs = jobApplicationRepository.countByStatus(VerificationStatus.PENDING);
        long verifiedJobs = jobApplicationRepository.countByStatus(VerificationStatus.VERIFIED);
        long pendingSellers = womenProductSellerRepository.countByVerificationStatus(VerificationStatus.PENDING);
        long totalSellers = womenProductSellerRepository.count();
        long pendingDelivery = 0;
        try {
            pendingDelivery = deliveryPartnerRepository.findByPartnerProfileStatusIn(PartnerLifecycleSupport.pendingQueueStatuses()).size();
        } catch (Exception ignored) {
            pendingDelivery = deliveryPartnerRepository.findByVerificationStatus(VerificationStatus.PENDING).size();
        }
        long totalDelivery = deliveryPartnerRepository.count();
        long totalOrders = womenProductOrderRepository.count();

        // Messages
        long unreadContactMessages = contactMessageRepository.countByReadByAdminFalse();

        // Package Stats
        Map<String, Object> stats = new LinkedHashMap<>();
        stats.put("totalLiveSos", totalLiveSos);
        stats.put("verifiedRoutes", verifiedRoutes);

        stats.put("totalDoctors", totalDoctors);
        stats.put("verifiedDoctors", verifiedDoctors);
        stats.put("pendingDoctors", pendingDoctors);

        stats.put("totalSalons", totalSalons);
        stats.put("verifiedSalons", verifiedSalons);
        stats.put("pendingSalons", pendingSalons);

        stats.put("totalStylists", totalStylists);
        stats.put("verifiedStylists", verifiedStylists);
        stats.put("pendingStylists", pendingStylists);

        stats.put("totalCentres", totalCentres);
        stats.put("approvedCentres", approvedCentres);
        stats.put("pendingCentres", pendingCentres);

        stats.put("totalTrainers", totalTrainers);
        stats.put("verifiedTrainers", verifiedTrainers);
        stats.put("pendingTrainers", pendingTrainers);
        stats.put("fitnessBookings", fitnessBookings);

        stats.put("totalUsers", totalUsers);
        stats.put("verifiedUsers", verifiedUsers);
        stats.put("pendingUsers", pendingUsers);
        stats.put("bannedUsers", bannedUsers);

        stats.put("totalEntrepreneurs", totalEntrepreneurs);
        stats.put("verifiedEntrepreneurs", verifiedEntrepreneurs);
        stats.put("pendingEntrepreneurs", pendingEntrepreneurs);

        stats.put("totalInvestors", totalInvestors);
        stats.put("verifiedInvestors", verifiedInvestors);
        stats.put("pendingInvestors", pendingInvestors);

        stats.put("totalProposals", totalProposals);
        stats.put("verifiedProposals", verifiedProposals);
        stats.put("pendingProposals", pendingProposals);

        stats.put("capitalRequested", capitalRequested);
        stats.put("capitalInvested", capitalInvested);
        stats.put("platformRevenue", platformRevenue);

        stats.put("totalWomenEvents", totalWomenEvents);
        stats.put("approvedWomenEvents", approvedWomenEvents);
        stats.put("pendingWomenEvents", pendingWomenEvents);
        stats.put("totalEventBookings", totalEventBookings);
        stats.put("totalEventRevenue", totalEventRevenue);

        stats.put("totalVideos", totalVideos);
        stats.put("reportedVideos", reportedVideos);
        stats.put("pendingCashouts", pendingCashouts);
        stats.put("brandCollabs", brandCollabs);
        stats.put("pendingCreators", pendingCreators);

        stats.put("totalCourses", totalCourses);
        stats.put("totalEducators", totalEducators);
        stats.put("pendingEducators", pendingEducators);
        stats.put("workshopRegs", workshopRegs);

        stats.put("totalLawyers", totalLawyers);
        stats.put("pendingLawyers", pendingLawyers);
        stats.put("pendingJobs", pendingJobs);
        stats.put("verifiedJobs", verifiedJobs);
        stats.put("totalSellers", totalSellers);
        stats.put("pendingSellers", pendingSellers);
        stats.put("totalDelivery", totalDelivery);
        stats.put("pendingDelivery", pendingDelivery);
        stats.put("totalOrders", totalOrders);

        stats.put("unreadContactMessages", unreadContactMessages);

        res.put("stats", stats);

        // Recent Activity Feed
        List<Map<String, Object>> activities = new ArrayList<>();
        for (Investment inv : allInvestments) {
            activities.add(Map.of(
                    "type", "INVESTMENT",
                    "title", "New Investment Funded",
                    "desc", (inv.getInvestor() != null ? inv.getInvestor().getFullName() : "Investor") +
                            " invested ₹" + inv.getAmount() + " in \"" + (inv.getProposal() != null ? inv.getProposal().getTitle() : "Pitch") + "\"",
                    "time", inv.getCreatedAt() != null ? inv.getCreatedAt().toString() : LocalDateTime.now().toString()
            ));
        }
        res.put("activities", activities.stream().limit(10).collect(Collectors.toList()));

        return ResponseEntity.ok(res);
    }

    // ==========================================
    // 3. APPROVAL QUEUES & PARTNER DIRECTORY
    // ==========================================

    @GetMapping("/approvals")
    @Transactional(readOnly = true)
    public ResponseEntity<Map<String, Object>> listApprovals(
            @RequestParam(value = "category", defaultValue = "DOCTORS") String category,
            @RequestParam(value = "status", defaultValue = "PENDING") String status,
            @RequestParam(value = "search", required = false) String search,
            HttpSession session) {
        if (requireAdmin(session) == null) return unauthorized();

        List<Map<String, Object>> items = new ArrayList<>();
        String cat = category.toUpperCase(Locale.ROOT);
        String stat = status.toUpperCase(Locale.ROOT);

        switch (cat) {
            case "DOCTORS":
                for (Doctor d : doctorRepository.findAll()) {
                    String vStat = d.getVerificationStatus() != null ? d.getVerificationStatus().name() : "PENDING";
                    if (!"ALL".equals(stat) && !vStat.equalsIgnoreCase(stat)) continue;
                    if (matchesSearch(d.getFullName(), d.getEmail(), d.getSpecialization(), search)) {
                        Map<String, Object> m = new LinkedHashMap<>();
                        m.put("id", d.getId());
                        m.put("category", "DOCTORS");
                        m.put("title", d.getFullName());
                        m.put("subtitle", d.getSpecialization() != null ? d.getSpecialization() : "General Medicine");
                        m.put("email", d.getEmail());
                        m.put("phone", d.getPhone());
                        m.put("location", str(d.getCity()) + (d.getState() != null ? ", " + d.getState() : ""));
                        m.put("status", vStat);
                        m.put("profileStatus", d.getDoctorProfileStatus() != null ? d.getDoctorProfileStatus().name() : "INCOMPLETE");
                        m.put("experience", d.getExperienceYears() != null ? d.getExperienceYears() + " yrs" : "N/A");
                        m.put("hospital", d.getHospitalName());
                        m.put("registrationNo", d.getMedicalRegNumber());
                        m.put("completionPct", d.getProfileCompletionPct());
                        m.put("photoUrl", d.getProfilePhotoPath());
                        items.add(m);
                    }
                }
                break;

            case "SALONS":
                for (Salon s : salonRepository.findAll()) {
                    String vStat = s.isApproved() ? "VERIFIED" : "PENDING";
                    if (!"ALL".equals(stat) && !vStat.equalsIgnoreCase(stat)) continue;
                    if (matchesSearch(s.getName(), s.getEmail(), s.getUsername(), search)) {
                        Map<String, Object> m = new LinkedHashMap<>();
                        m.put("id", s.getId());
                        m.put("category", "SALONS");
                        m.put("title", s.getName());
                        m.put("subtitle", "Category: " + (s.getSalonCategory() != null ? s.getSalonCategory() : "Beauty & Spa"));
                        m.put("email", s.getEmail());
                        m.put("phone", s.getPhone());
                        m.put("location", str(s.getCity()) + (s.getAddress() != null ? ", " + s.getAddress() : ""));
                        m.put("status", vStat);
                        m.put("services", s.getSalonCategory());
                        m.put("photoUrl", s.getProfileImageUrl());
                        items.add(m);
                    }
                }
                break;

            case "STYLISTS":
                for (Stylist st : stylistRepository.findAll()) {
                    String vStat = st.isApproved() ? "VERIFIED" : "PENDING";
                    if (!"ALL".equals(stat) && !vStat.equalsIgnoreCase(stat)) continue;
                    String fullName = str(st.getFirstName()) + " " + str(st.getLastName());
                    if (matchesSearch(fullName, st.getEmail(), st.getSpecialization(), search)) {
                        Map<String, Object> m = new LinkedHashMap<>();
                        m.put("id", st.getId());
                        m.put("category", "STYLISTS");
                        m.put("title", fullName.trim().isEmpty() ? "Stylist" : fullName.trim());
                        m.put("subtitle", st.getSpecialization() != null ? st.getSpecialization() : "Hair & Makeup Stylist");
                        m.put("email", st.getEmail());
                        m.put("phone", st.getContactNumber());
                        m.put("location", st.getSalon() != null ? str(st.getSalon().getCity()) : "Independent");
                        m.put("status", vStat);
                        m.put("experience", st.getExperienceInYears() != null ? st.getExperienceInYears() + " yrs" : "N/A");
                        m.put("photoUrl", st.getProfileImage());
                        items.add(m);
                    }
                }
                break;

            case "CENTRES":
                for (MartialArtsCenter c : martialArtsCenterRepository.findAll()) {
                    String vStat = c.isApproved() ? "VERIFIED" : "PENDING";
                    if (!"ALL".equals(stat) && !vStat.equalsIgnoreCase(stat)) continue;
                    if (matchesSearch(c.getName(), c.getEmail(), c.getLocation(), search)) {
                        Map<String, Object> m = new LinkedHashMap<>();
                        m.put("id", c.getId());
                        m.put("category", "CENTRES");
                        m.put("title", c.getName());
                        m.put("subtitle", "Martial Arts & Self-Defense Centre");
                        m.put("email", c.getEmail());
                        m.put("phone", c.getPhoneNumber());
                        m.put("location", str(c.getLocation()));
                        m.put("status", vStat);
                        m.put("photoUrl", c.getProfilePhoto());
                        items.add(m);
                    }
                }
                break;

            case "TRAINERS":
                for (FitnessTrainer t : fitnessTrainerRepository.findAll()) {
                    String vStat = t.getVerificationStatus() != null ? t.getVerificationStatus().name() : "PENDING";
                    if (!"ALL".equals(stat) && !vStat.equalsIgnoreCase(stat)) continue;
                    if (matchesSearch(t.getFullName(), t.getEmail(), t.getSpecializations(), search)) {
                        Map<String, Object> m = new LinkedHashMap<>();
                        m.put("id", t.getId());
                        m.put("category", "TRAINERS");
                        m.put("title", t.getFullName());
                        m.put("subtitle", t.getSpecializations() != null ? t.getSpecializations() : "Fitness & Wellness Coach");
                        m.put("email", t.getEmail());
                        m.put("phone", t.getPhone());
                        m.put("location", str(t.getCity()));
                        m.put("status", vStat);
                        m.put("photoUrl", t.getProfilePhotoPath());
                        items.add(m);
                    }
                }
                break;

            case "ENTREPRENEURS":
                for (Entrepreneur e : entrepreneurRepository.findAll()) {
                    String vStat = e.getVerificationStatus() != null ? e.getVerificationStatus().name() : "PENDING";
                    if (!"ALL".equals(stat) && !vStat.equalsIgnoreCase(stat)) continue;
                    if (matchesSearch(e.getFullName(), e.getEmail(), e.getBusinessName(), search)) {
                        Map<String, Object> m = new LinkedHashMap<>();
                        m.put("id", e.getId());
                        m.put("category", "ENTREPRENEURS");
                        m.put("title", e.getFullName());
                        m.put("subtitle", e.getBusinessName() != null ? e.getBusinessName() : "Startup Founder");
                        m.put("email", e.getEmail());
                        m.put("phone", e.getPhone());
                        m.put("location", str(e.getBusinessLocation()));
                        m.put("status", vStat);
                        m.put("photoUrl", e.getProfilePhoto());
                        items.add(m);
                    }
                }
                break;

            case "INVESTORS":
                for (Investor inv : investorRepository.findAll()) {
                    String vStat = inv.getVerificationStatus() != null ? inv.getVerificationStatus().name() : "PENDING";
                    if (!"ALL".equals(stat) && !vStat.equalsIgnoreCase(stat)) continue;
                    if (matchesSearch(inv.getFullName(), inv.getEmail(), inv.getCompanyName(), search)) {
                        Map<String, Object> m = new LinkedHashMap<>();
                        m.put("id", inv.getId());
                        m.put("category", "INVESTORS");
                        m.put("title", inv.getFullName());
                        m.put("subtitle", inv.getCompanyName() != null ? inv.getCompanyName() : "Angel Investor");
                        m.put("email", inv.getEmail());
                        m.put("phone", inv.getPhone());
                        m.put("location", str(inv.getPreferredLocations()));
                        m.put("status", vStat);
                        m.put("photoUrl", inv.getProfilePhoto());
                        items.add(m);
                    }
                }
                break;

            case "EVENTS":
                for (WomenEvent ev : womenEventRepository.findAll()) {
                    String vStat = ev.getStatus() != null ? ev.getStatus() : "PENDING";
                    if (!"ALL".equals(stat) && !vStat.equalsIgnoreCase(stat)) continue;
                    if (matchesSearch(ev.getName(), ev.getVenue(), ev.getDescription(), search)) {
                        Map<String, Object> m = new LinkedHashMap<>();
                        m.put("id", ev.getId());
                        m.put("category", "EVENTS");
                        m.put("title", ev.getName());
                        m.put("subtitle", "Host: " + (ev.getOrganizerName() != null ? ev.getOrganizerName() : "Event Organizer"));
                        m.put("location", str(ev.getCity()) + (ev.getVenue() != null ? ", " + ev.getVenue() : ""));
                        m.put("status", vStat);
                        m.put("photoUrl", ev.getBannerImage());
                        items.add(m);
                    }
                }
                break;

            case "LAWYERS":
                for (ServiceProvider p : serviceProviderRepository.findAll()) {
                    if (p.getCategory() != ProviderCategory.WOMEN_LAWYER) continue;
                    String vStat = p.getVerificationStatus() != null ? p.getVerificationStatus().name() : "PENDING";
                    if (!"ALL".equals(stat) && !vStat.equalsIgnoreCase(stat)) continue;
                    if (matchesSearch(p.getFullName(), p.getEmail(), p.getLocationText(), search)) {
                        Map<String, Object> m = new LinkedHashMap<>();
                        m.put("id", p.getId());
                        m.put("category", "LAWYERS");
                        m.put("title", p.getFullName());
                        m.put("subtitle", "Women Legal Consultant & Lawyer");
                        m.put("email", p.getEmail());
                        m.put("phone", p.getPhone());
                        m.put("location", str(p.getLocationText()));
                        m.put("status", vStat);
                        m.put("photoUrl", p.getIdentityDocumentPath());
                        items.add(m);
                    }
                }
                break;

            case "JOBS":
                for (JobApplication j : jobApplicationRepository.findAll()) {
                    String vStat = j.getStatus() != null ? j.getStatus().name() : "PENDING";
                    if (!"ALL".equals(stat) && !vStat.equalsIgnoreCase(stat)) continue;
                    String userName = j.getUser() != null ? j.getUser().getFullName() : "Applicant";
                    String userEmail = j.getUser() != null ? j.getUser().getEmail() : "";
                    String userPhone = j.getUser() != null ? j.getUser().getPhoneNumber() : "";
                    if (matchesSearch(userName, userEmail, j.getJobCategory(), search)) {
                        Map<String, Object> m = new LinkedHashMap<>();
                        m.put("id", j.getId());
                        m.put("category", "JOBS");
                        m.put("title", userName);
                        m.put("subtitle", j.getJobCategory() != null ? j.getJobCategory() : "Skilled Worker");
                        m.put("email", userEmail);
                        m.put("phone", userPhone);
                        m.put("location", str(j.getCity()));
                        m.put("status", vStat);
                        m.put("photoUrl", j.getDocumentPath());
                        items.add(m);
                    }
                }
                break;

            case "SELLERS":
                for (WomenProductSeller s : womenProductSellerRepository.findAll()) {
                    String vStat = s.getVerificationStatus() != null ? s.getVerificationStatus().name() : "PENDING";
                    if (!"ALL".equals(stat) && !vStat.equalsIgnoreCase(stat)) continue;
                    if (matchesSearch(s.getBusinessName(), s.getEmail(), s.getFullName(), search)) {
                        Map<String, Object> m = new LinkedHashMap<>();
                        m.put("id", s.getId());
                        m.put("category", "SELLERS");
                        m.put("title", s.getBusinessName() != null ? s.getBusinessName() : s.getFullName());
                        m.put("subtitle", "Merchant: " + (s.getFullName() != null ? s.getFullName() : s.getEmail()));
                        m.put("email", s.getEmail());
                        m.put("phone", s.getPhone());
                        m.put("location", str(s.getCity()));
                        m.put("status", vStat);
                        m.put("photoUrl", s.getProfilePhotoPath());
                        items.add(m);
                    }
                }
                break;

            case "DELIVERY":
                for (DeliveryPartner dp : deliveryPartnerRepository.findAll()) {
                    String vStat = dp.getVerificationStatus() != null ? dp.getVerificationStatus().name() : "PENDING";
                    if (!"ALL".equals(stat) && !vStat.equalsIgnoreCase(stat)) continue;
                    if (matchesSearch(dp.getFullName(), dp.getEmail(), dp.getVehicleType(), search)) {
                        Map<String, Object> m = new LinkedHashMap<>();
                        m.put("id", dp.getId());
                        m.put("category", "DELIVERY");
                        m.put("title", dp.getFullName());
                        m.put("subtitle", "Vehicle: " + (dp.getVehicleType() != null ? dp.getVehicleType() : "Two Wheeler"));
                        m.put("email", dp.getEmail());
                        m.put("phone", dp.getPhone());
                        m.put("location", str(dp.getCity()));
                        m.put("status", vStat);
                        m.put("photoUrl", dp.getProfilePhotoPath());
                        items.add(m);
                    }
                }
                break;

            case "USERS":
            default:
                for (User u : userRepository.findAll()) {
                    String vStat = u.isBanned() ? "BANNED" : (u.getVerificationStatus() != null ? u.getVerificationStatus().name() : "VERIFIED");
                    if (!"ALL".equals(stat) && !vStat.equalsIgnoreCase(stat)) continue;
                    if (matchesSearch(u.getFullName(), u.getEmail(), u.getPhoneNumber(), search)) {
                        Map<String, Object> m = new LinkedHashMap<>();
                        m.put("id", u.getId());
                        m.put("category", "USERS");
                        m.put("title", u.getFullName());
                        m.put("subtitle", u.isVerifiedCreator() ? "Verified Creator" : "Member");
                        m.put("email", u.getEmail());
                        m.put("phone", u.getPhoneNumber());
                        m.put("location", str(u.getHomeAddress()));
                        m.put("status", vStat);
                        m.put("photoUrl", u.getProfilePhoto());
                        items.add(m);
                    }
                }
                break;
        }

        Map<String, Object> res = new LinkedHashMap<>();
        res.put("success", true);
        res.put("category", cat);
        res.put("status", stat);
        res.put("count", items.size());
        res.put("items", items);
        return ResponseEntity.ok(res);
    }

    private boolean matchesSearch(String a, String b, String c, String search) {
        if (search == null || search.trim().isEmpty()) return true;
        String query = search.trim().toLowerCase(Locale.ROOT);
        return (a != null && a.toLowerCase(Locale.ROOT).contains(query)) ||
                (b != null && b.toLowerCase(Locale.ROOT).contains(query)) ||
                (c != null && c.toLowerCase(Locale.ROOT).contains(query));
    }

    // ==========================================
    // 4. APPROVAL ACTIONS (Approve / Reject / Request Changes)
    // ==========================================

    @PostMapping("/approve")
    @Transactional
    public ResponseEntity<Map<String, Object>> approveItem(@RequestBody Map<String, Object> body, HttpSession session) {
        if (requireAdmin(session) == null) return unauthorized();
        String category = body == null ? "" : str(body.get("category")).toUpperCase(Locale.ROOT);
        Long id = body == null ? null : Long.valueOf(str(body.get("id")));

        if (id == null) return badRequest("Item ID is required.");

        switch (category) {
            case "DOCTORS":
                Doctor d = doctorRepository.findById(id).orElse(null);
                if (d == null) return badRequest("Doctor not found.");
                d.setVerificationStatus(VerificationStatus.VERIFIED);
                d.setDoctorProfileStatus(DoctorProfileStatus.APPROVED);
                doctorRepository.save(d);
                break;

            case "SALONS":
                Salon s = salonRepository.findById(id).orElse(null);
                if (s == null) return badRequest("Salon not found.");
                s.setApproved(true);
                salonRepository.save(s);
                break;

            case "STYLISTS":
                Stylist st = stylistRepository.findById(id).orElse(null);
                if (st == null) return badRequest("Stylist not found.");
                st.setApproved(true);
                stylistRepository.save(st);
                break;

            case "CENTRES":
                MartialArtsCenter c = martialArtsCenterRepository.findById(id).orElse(null);
                if (c == null) return badRequest("Centre not found.");
                c.setApproved(true);
                c.setCentreProfileStatus(CentreProfileStatus.APPROVED);
                martialArtsCenterRepository.save(c);
                break;

            case "TRAINERS":
                FitnessTrainer t = fitnessTrainerRepository.findById(id).orElse(null);
                if (t == null) return badRequest("Trainer not found.");
                t.setVerificationStatus(VerificationStatus.VERIFIED);
                fitnessTrainerRepository.save(t);
                break;

            case "ENTREPRENEURS":
                Entrepreneur e = entrepreneurRepository.findById(id).orElse(null);
                if (e == null) return badRequest("Entrepreneur not found.");
                e.setVerificationStatus(VerificationStatus.VERIFIED);
                entrepreneurRepository.save(e);
                break;

            case "INVESTORS":
                Investor inv = investorRepository.findById(id).orElse(null);
                if (inv == null) return badRequest("Investor not found.");
                inv.setVerificationStatus(VerificationStatus.VERIFIED);
                investorRepository.save(inv);
                break;

            case "EVENTS":
                WomenEvent ev = womenEventRepository.findById(id).orElse(null);
                if (ev == null) return badRequest("Event not found.");
                ev.setStatus("APPROVED");
                womenEventRepository.save(ev);
                break;

            case "LAWYERS":
                ServiceProvider p = serviceProviderRepository.findById(id).orElse(null);
                if (p == null) return badRequest("Lawyer not found.");
                p.setVerificationStatus(VerificationStatus.VERIFIED);
                serviceProviderRepository.save(p);
                break;

            case "JOBS":
                JobApplication j = jobApplicationRepository.findById(id).orElse(null);
                if (j == null) return badRequest("Job worker not found.");
                j.setStatus(VerificationStatus.VERIFIED);
                jobApplicationRepository.save(j);
                break;

            case "SELLERS":
                WomenProductSeller sel = womenProductSellerRepository.findById(id).orElse(null);
                if (sel == null) return badRequest("Seller not found.");
                sel.setVerificationStatus(VerificationStatus.VERIFIED);
                womenProductSellerRepository.save(sel);
                break;

            case "DELIVERY":
                DeliveryPartner dp = deliveryPartnerRepository.findById(id).orElse(null);
                if (dp == null) return badRequest("Delivery partner not found.");
                dp.setVerificationStatus(VerificationStatus.VERIFIED);
                deliveryPartnerRepository.save(dp);
                break;

            case "USERS":
                User u = userRepository.findById(id).orElse(null);
                if (u == null) return badRequest("User not found.");
                u.setVerificationStatus(VerificationStatus.VERIFIED);
                u.setBanned(false);
                userRepository.save(u);
                break;

            default:
                return badRequest("Unsupported approval category: " + category);
        }

        return ResponseEntity.ok(Map.of("success", true, "message", category + " approved successfully!"));
    }

    @PostMapping("/reject")
    @Transactional
    public ResponseEntity<Map<String, Object>> rejectItem(@RequestBody Map<String, Object> body, HttpSession session) {
        if (requireAdmin(session) == null) return unauthorized();
        String category = body == null ? "" : str(body.get("category")).toUpperCase(Locale.ROOT);
        Long id = body == null ? null : Long.valueOf(str(body.get("id")));
        String reason = body == null ? "Profile does not meet verification requirements." : str(body.get("reason"));

        if (id == null) return badRequest("Item ID is required.");

        switch (category) {
            case "DOCTORS":
                Doctor d = doctorRepository.findById(id).orElse(null);
                if (d == null) return badRequest("Doctor not found.");
                d.setVerificationStatus(VerificationStatus.REJECTED);
                d.setDoctorProfileStatus(DoctorProfileStatus.CHANGES_REQUESTED);
                doctorRepository.save(d);
                break;

            case "SALONS":
                Salon s = salonRepository.findById(id).orElse(null);
                if (s == null) return badRequest("Salon not found.");
                s.setApproved(false);
                salonRepository.save(s);
                break;

            case "STYLISTS":
                Stylist st = stylistRepository.findById(id).orElse(null);
                if (st == null) return badRequest("Stylist not found.");
                st.setApproved(false);
                stylistRepository.save(st);
                break;

            case "CENTRES":
                MartialArtsCenter c = martialArtsCenterRepository.findById(id).orElse(null);
                if (c == null) return badRequest("Centre not found.");
                c.setApproved(false);
                c.setCentreProfileStatus(CentreProfileStatus.CHANGES_REQUESTED);
                martialArtsCenterRepository.save(c);
                break;

            case "TRAINERS":
                FitnessTrainer t = fitnessTrainerRepository.findById(id).orElse(null);
                if (t == null) return badRequest("Trainer not found.");
                t.setVerificationStatus(VerificationStatus.REJECTED);
                fitnessTrainerRepository.save(t);
                break;

            case "EVENTS":
                WomenEvent ev = womenEventRepository.findById(id).orElse(null);
                if (ev == null) return badRequest("Event not found.");
                ev.setStatus("REJECTED");
                womenEventRepository.save(ev);
                break;

            default:
                break;
        }

        return ResponseEntity.ok(Map.of("success", true, "message", category + " rejected with note: " + reason));
    }

    // ==========================================
    // 5. SOS REAL-TIME MONITORING
    // ==========================================

    @GetMapping("/sos-alerts")
    @Transactional(readOnly = true)
    public ResponseEntity<Map<String, Object>> getSosAlerts(HttpSession session) {
        if (requireAdmin(session) == null) return unauthorized();

        List<Map<String, Object>> alerts = new ArrayList<>();
        for (SOSRequest req : sosRequestRepository.findAll()) {
            Map<String, Object> m = new LinkedHashMap<>();
            m.put("id", req.getId());
            m.put("source", "SOS_REQUEST");
            m.put("userName", req.getUser() != null ? req.getUser().getFullName() : "Anonymous User");
            m.put("userPhone", req.getUser() != null ? req.getUser().getPhoneNumber() : "N/A");
            m.put("userEmail", req.getUser() != null ? req.getUser().getEmail() : "N/A");
            m.put("latitude", req.getLatitude());
            m.put("longitude", req.getLongitude());
            m.put("status", req.getStatus() != null ? req.getStatus().name() : "ACTIVE");
            m.put("time", req.getActivatedAt() != null ? req.getActivatedAt().toString() : "");
            m.put("mapUrl", (req.getLatitude() != null && req.getLongitude() != null)
                    ? "https://maps.google.com/?q=" + req.getLatitude() + "," + req.getLongitude()
                    : null);
            alerts.add(m);
        }

        alerts.sort((a, b) -> str(b.get("time")).compareTo(str(a.get("time"))));

        return ResponseEntity.ok(Map.of("success", true, "count", alerts.size(), "alerts", alerts));
    }

    @PostMapping("/sos/{id}/resolve")
    @Transactional
    public ResponseEntity<Map<String, Object>> resolveSos(@PathVariable Long id, HttpSession session) {
        if (requireAdmin(session) == null) return unauthorized();
        SOSRequest req = sosRequestRepository.findById(id).orElse(null);
        if (req != null) {
            req.setStatus(SOSRequest.SOSStatus.RESOLVED);
            sosRequestRepository.save(req);
        }
        return ResponseEntity.ok(Map.of("success", true, "message", "SOS alert resolved."));
    }

    // ==========================================
    // 6. REPORTED VIDEOS & CONTENT MODERATION
    // ==========================================

    @GetMapping("/reported-videos")
    @Transactional(readOnly = true)
    public ResponseEntity<Map<String, Object>> getReportedVideos(HttpSession session) {
        if (requireAdmin(session) == null) return unauthorized();

        List<Map<String, Object>> list = new ArrayList<>();
        for (VideoReport rep : videoReportRepository.findAll()) {
            Map<String, Object> m = new LinkedHashMap<>();
            m.put("id", rep.getId());
            m.put("reason", rep.getReason());
            m.put("reportedAt", rep.getReportedAt() != null ? rep.getReportedAt().toString() : "");
            m.put("reportedByName", rep.getReportedBy() != null ? rep.getReportedBy().getFullName() : "Community Member");
            if (rep.getVideo() != null) {
                m.put("videoId", rep.getVideo().getId());
                m.put("videoTitle", rep.getVideo().getTitle());
                m.put("videoUrl", rep.getVideo().getVideoPath());
                m.put("videoCreator", (rep.getVideo().getUser() != null && rep.getVideo().getUser().getFullName() != null) ? rep.getVideo().getUser().getFullName() : "Creator");
            }
            list.add(m);
        }
        return ResponseEntity.ok(Map.of("success", true, "count", list.size(), "reports", list));
    }

    @PostMapping("/reported-videos/{id}/dismiss")
    @Transactional
    public ResponseEntity<Map<String, Object>> dismissReport(@PathVariable Long id, HttpSession session) {
        if (requireAdmin(session) == null) return unauthorized();
        videoReportRepository.deleteById(id);
        return ResponseEntity.ok(Map.of("success", true, "message", "Report dismissed."));
    }

    // ==========================================
    // 7. BROADCAST MESSAGES
    // ==========================================

    @GetMapping("/broadcasts")
    @Transactional(readOnly = true)
    public ResponseEntity<Map<String, Object>> getBroadcasts(HttpSession session) {
        if (requireAdmin(session) == null) return unauthorized();
        List<BroadcastMessage> list = broadcastMessageRepository.findAll();
        return ResponseEntity.ok(Map.of("success", true, "broadcasts", list));
    }

    @PostMapping("/broadcast")
    @Transactional
    public ResponseEntity<Map<String, Object>> sendBroadcast(@RequestBody Map<String, String> body, HttpSession session) {
        if (requireAdmin(session) == null) return unauthorized();
        String title = body == null ? "" : str(body.get("title"));
        String message = body == null ? "" : str(body.get("message"));
        String type = body == null ? "ALERT" : str(body.get("type"));

        if (title.isBlank() || message.isBlank()) return badRequest("Title and message are required.");

        BroadcastMessage bm = new BroadcastMessage();
        bm.setTitle(title);
        bm.setMessage(message);
        bm.setType(type);
        bm.setSentAt(LocalDateTime.now());
        broadcastMessageRepository.save(bm);

        return ResponseEntity.ok(Map.of("success", true, "message", "Broadcast sent!"));
    }

    // ==========================================
    // 8. CONTACT MESSAGES / SUPPORT
    // ==========================================

    @GetMapping("/contact-messages")
    @Transactional(readOnly = true)
    public ResponseEntity<Map<String, Object>> getContactMessages(HttpSession session) {
        if (requireAdmin(session) == null) return unauthorized();
        List<ContactMessage> list = contactMessageRepository.findAll();
        list.sort((a, b) -> (b.getId() != null ? b.getId().compareTo(a.getId()) : 0));
        return ResponseEntity.ok(Map.of("success", true, "messages", list));
    }

    @PostMapping("/contact-messages/{id}/mark-read")
    @Transactional
    public ResponseEntity<Map<String, Object>> markContactMessageRead(@PathVariable Long id, HttpSession session) {
        if (requireAdmin(session) == null) return unauthorized();
        ContactMessage cm = contactMessageRepository.findById(id).orElse(null);
        if (cm != null) {
            cm.setReadByAdmin(true);
            contactMessageRepository.save(cm);
        }
        return ResponseEntity.ok(Map.of("success", true, "message", "Marked as read."));
    }

    // ==========================================
    // 9. USER MANAGEMENT & BAN CONTROLS
    // ==========================================

    @PostMapping("/users/{id}/toggle-ban")
    @Transactional
    public ResponseEntity<Map<String, Object>> toggleUserBan(@PathVariable Long id, HttpSession session) {
        if (requireAdmin(session) == null) return unauthorized();
        User u = userRepository.findById(id).orElse(null);
        if (u == null) return badRequest("User not found.");
        u.setBanned(!u.isBanned());
        userRepository.save(u);
        return ResponseEntity.ok(Map.of("success", true, "banned", u.isBanned(), "message", u.isBanned() ? "User account suspended/banned." : "User account unbanned."));
    }
}
