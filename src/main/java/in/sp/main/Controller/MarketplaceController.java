package in.sp.main.Controller;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import in.sp.main.Entities.ProviderBooking;
import in.sp.main.Entities.ProviderBookingStatus;
import in.sp.main.Entities.ProviderCategory;
import in.sp.main.Entities.ProviderReview;
import in.sp.main.Entities.ServiceProvider;
import in.sp.main.Entities.User;
import in.sp.main.Entities.VerificationStatus;
import in.sp.main.Entities.ProviderClass;
import in.sp.main.Entities.MarketplaceEnrollment;
import in.sp.main.Repository.ProviderBookingRepository;
import in.sp.main.Repository.ProviderReviewRepository;
import in.sp.main.Repository.ServiceProviderRepository;
import in.sp.main.Repository.ProviderClassRepository;
import in.sp.main.Repository.MarketplaceEnrollmentRepository;
import in.sp.main.Service.FileUploadService;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/marketplace")
public class MarketplaceController {

    @Autowired
    private ServiceProviderRepository providerRepo;

    @Autowired
    private ProviderBookingRepository bookingRepo;

    @Autowired
    private ProviderReviewRepository reviewRepo;

    @Autowired
    private FileUploadService fileUploadService;

    @Autowired
    private ProviderClassRepository classRepo;

    @Autowired
    private MarketplaceEnrollmentRepository enrollmentRepo;
    
    @Autowired
    private in.sp.main.Repository.JobApplicationRepository jobAppRepo;

    @Autowired
    private in.sp.main.Repository.WorkerBookingRepository workerBookingRepo;

    @Autowired
    private in.sp.main.Config.JwtUtil jwtUtil;

    @Autowired
    private in.sp.main.Service.PasswordService passwordService;

    @Autowired
    private org.springframework.messaging.simp.SimpMessagingTemplate messagingTemplate;

    @org.springframework.beans.factory.annotation.Value("${razorpay.key.id:}")
    private String razorpayKeyId;

    @org.springframework.beans.factory.annotation.Value("${razorpay.key.secret:}")
    private String razorpayKeySecret;

    private boolean razorpayConfigured() {
        return razorpayKeyId != null && !razorpayKeyId.isBlank()
                && razorpayKeySecret != null && !razorpayKeySecret.isBlank();
    }

    private static String formatCategoryLabel(ProviderCategory cat) {
        if (cat == null) return "";
        return cat.getDisplayName();
    }

    private void validateMarketplaceUpload(MultipartFile file) {
        if (file == null || file.isEmpty()) {
            throw new IllegalArgumentException("Please upload a document (PDF or image).");
        }
        if (file.getSize() > 5L * 1024 * 1024) {
            throw new IllegalArgumentException("Document must be 5MB or smaller.");
        }
        String contentType = file.getContentType() != null ? file.getContentType().toLowerCase() : "";
        String name = file.getOriginalFilename() != null ? file.getOriginalFilename().toLowerCase() : "";
        boolean okType = contentType.startsWith("image/") || contentType.equals("application/pdf")
                || name.endsWith(".pdf") || name.endsWith(".png") || name.endsWith(".jpg")
                || name.endsWith(".jpeg") || name.endsWith(".webp");
        if (!okType) {
            throw new IllegalArgumentException("Only PDF or image files are allowed.");
        }
    }

    // ==============================
    // Provider registration + login
    // ==============================
    @GetMapping("/provider/register")
    public String providerRegisterPage(Model model) {
        model.addAttribute("providerCategories", ProviderCategory.values());
        return "marketplace/provider-register";
    }

    @PostMapping("/provider/register")
    public String providerRegister(@RequestParam String fullName,
                                   @RequestParam String email,
                                   @RequestParam String phone,
                                   @RequestParam String password,
                                   @RequestParam String category,
                                   @RequestParam String description,
                                   @RequestParam String locationText,
                                   @RequestParam("identityDoc") MultipartFile identityDoc,
                                   Model model,
                                   RedirectAttributes redirectAttributes) {
        if (providerRepo.findByEmail(email.trim().toLowerCase()).isPresent()) {
            model.addAttribute("error", "Email already registered.");
            return "marketplace/provider-register";
        }

        if (phone == null || !phone.trim().matches("^\\d{10}$")) {
            model.addAttribute("error", "Phone number must be exactly 10 digits.");
            return "marketplace/provider-register";
        }

        if (password == null || password.length() < 8) {
            model.addAttribute("error", "Password must be at least 8 characters.");
            return "marketplace/provider-register";
        }

        try {
            validateMarketplaceUpload(identityDoc);
            String docPath = fileUploadService.saveFile(identityDoc);

            ServiceProvider p = new ServiceProvider();
            p.setFullName(fullName);
            p.setEmail(email.trim().toLowerCase());
            p.setPhone(phone);
            p.setPassword(passwordService.encode(password));
            
            // Robust category parsing
            ProviderCategory parsedCat = ProviderCategory.fromFlexible(category);
            if (parsedCat == null) {
                model.addAttribute("error", "Invalid category: " + category);
                model.addAttribute("providerCategories", ProviderCategory.values());
                return "marketplace/provider-register";
            }
            p.setCategory(parsedCat);
            
            p.setDescription(description);
            p.setLocationText(locationText);
            p.setIdentityDocumentPath(docPath);
            p.setVerificationStatus(VerificationStatus.PENDING);
            p.setRating(0.0);

            providerRepo.save(p);
            redirectAttributes.addFlashAttribute("message", "Registration successful! Await admin verification.");
            return "redirect:/marketplace/provider/login";
        } catch (IllegalArgumentException e) {
            model.addAttribute("error", e.getMessage() != null ? e.getMessage() : "Invalid category selected.");
            return "marketplace/provider-register";
        } catch (IOException e) {
            model.addAttribute("error", "Failed to upload identity document.");
            return "marketplace/provider-register";
        } catch (Exception e) {
            model.addAttribute("error", "A database error occurred: " + e.getMessage());
            return "marketplace/provider-register";
        }
    }

    @GetMapping("/provider/login")
    public String providerLoginPage() {
        return "marketplace/provider-login";
    }

    @PostMapping("/provider/login")
    public String providerLogin(@RequestParam String email,
                                @RequestParam String password,
                                HttpSession session,
                                jakarta.servlet.http.HttpServletResponse response,
                                Model model) {
        Optional<ServiceProvider> pOpt = providerRepo.findByEmail(email.trim().toLowerCase());
        if (pOpt.isEmpty()) {
            model.addAttribute("error", "Provider not found.");
            return "marketplace/provider-login";
        }
        ServiceProvider p = pOpt.get();
        boolean ok = passwordService.matchesAndUpgrade(password, p.getPassword(), hashed -> {
            p.setPassword(hashed);
            providerRepo.save(p);
        });
        if (!ok) {
            model.addAttribute("error", "Invalid password.");
            return "marketplace/provider-login";
        }
        if (p.getVerificationStatus() != VerificationStatus.VERIFIED) {
            model.addAttribute("error", "Your account is pending verification.");
            return "marketplace/provider-login";
        }
        session.setAttribute("loggedProvider", p);
        
        // Generate JWT and add to response
        String token = jwtUtil.generateToken(p.getEmail(), "PROVIDER");
        jakarta.servlet.http.Cookie cookie = new jakarta.servlet.http.Cookie("JWT_TOKEN", token);
        cookie.setPath("/");
        cookie.setHttpOnly(true);
        cookie.setMaxAge(365 * 24 * 60 * 60); // 1 year
        response.addCookie(cookie);
        
        return "redirect:/marketplace/provider/dashboard";
    }

    @GetMapping("/provider/dashboard")
    public String providerDashboard(HttpSession session, Model model) {
        ServiceProvider p = (ServiceProvider) session.getAttribute("loggedProvider");
        if (p == null) return "redirect:/marketplace/provider/login";

        p = providerRepo.findById(p.getId()).orElse(p);
        model.addAttribute("provider", p);
        model.addAttribute("bookings", bookingRepo.findByProviderOrderByRequestedTimeDesc(p));
        // Using findByProviderId from MarketplaceEnrollmentRepository
        model.addAttribute("enrollments", enrollmentRepo.findByProviderId(p.getId()));
        model.addAttribute("classes", classRepo.findByProvider_Id(p.getId()));
        
        // Calculate total earnings from PAID enrollments
        double totalEarnings = enrollmentRepo.findByProviderId(p.getId()).stream()
                .filter(e -> "PAID".equals(e.getPaymentStatus()))
                .mapToDouble(e -> {
                    if (e.getProviderClass() == null || e.getProviderClass().getPrice() == null) {
                        return 0.0;
                    }
                    return e.getProviderClass().getPrice();
                })
                .sum();
        model.addAttribute("totalEarnings", totalEarnings);
        return "marketplace/provider-dashboard";
    }

    @PostMapping("/provider/profile/update")
    public String updateProviderProfile(@RequestParam String fullName,
                                       @RequestParam(required = false) String businessName,
                                       @RequestParam String phone,
                                       @RequestParam(required = false) String locationText,
                                       @RequestParam(required = false) String serviceArea,
                                       @RequestParam(required = false) String description,
                                       @RequestParam(required = false) String qualification,
                                       @RequestParam(required = false) String experience,
                                       @RequestParam(required = false) String availableDays,
                                       @RequestParam(required = false) String workingHoursFrom,
                                       @RequestParam(required = false) String workingHoursTo,
                                       @RequestParam(required = false) String languagesSpoken,
                                       @RequestParam(value = "profilePhoto", required = false) MultipartFile profilePhoto,
                                       HttpSession session, RedirectAttributes ra) {
        ServiceProvider p = (ServiceProvider) session.getAttribute("loggedProvider");
        if (p == null) return "redirect:/marketplace/provider/login";
        
        try {
            ServiceProvider existing = providerRepo.findById(p.getId()).orElse(null);
            if (existing != null) {
                existing.setFullName(fullName != null ? fullName.trim() : "");
                existing.setBusinessName(businessName != null ? businessName.trim() : "");
                existing.setPhone(phone != null ? phone.trim() : "");
                existing.setLocationText(locationText != null ? locationText.trim() : "");
                existing.setServiceArea(serviceArea != null ? serviceArea.trim() : "");
                existing.setDescription(description != null ? description.trim() : "");
                existing.setQualification(qualification != null ? qualification.trim() : "");
                existing.setExperience(experience != null ? experience.trim() : "");
                existing.setAvailableDays(availableDays != null ? availableDays.trim() : "");
                existing.setWorkingHoursFrom(workingHoursFrom != null ? workingHoursFrom.trim() : "");
                existing.setWorkingHoursTo(workingHoursTo != null ? workingHoursTo.trim() : "");
                existing.setLanguagesSpoken(languagesSpoken != null ? languagesSpoken.trim() : "");
                
                if (profilePhoto != null && !profilePhoto.isEmpty()) {
                    String originalFilename = profilePhoto.getOriginalFilename();
                    if (originalFilename != null) {
                        String lower = originalFilename.toLowerCase();
                        if (lower.endsWith(".jpg") || lower.endsWith(".jpeg") || lower.endsWith(".png") || lower.endsWith(".webp")) {
                            existing.setProfilePhoto(fileUploadService.saveFile(profilePhoto));
                        } else {
                            ra.addFlashAttribute("error", "Invalid photo format. Please upload JPG, JPEG, PNG or WEBP.");
                            return "redirect:/marketplace/provider/dashboard";
                        }
                    }
                }
                
                providerRepo.save(existing);
                session.setAttribute("loggedProvider", existing);
                ra.addFlashAttribute("message", "Profile updated successfully!");
            }
        } catch (IOException e) {
            ra.addFlashAttribute("error", "Failed to update profile photo.");
        }
        return "redirect:/marketplace/provider/dashboard";
    }

    @PostMapping("/provider/bookings/{id}/status")
    @ResponseBody
    public Map<String, Object> updateBookingStatus(@PathVariable Long id,
                                                  @RequestParam String status,
                                                  HttpSession session) {
        Map<String, Object> response = new HashMap();
        ServiceProvider p = (ServiceProvider) session.getAttribute("loggedProvider");
        if (p == null) {
            response.put("success", false);
            response.put("message", "Not logged in");
            return response;
        }

        ProviderBooking b = bookingRepo.findById(id).orElse(null);
        if (b == null || b.getProvider() == null || !b.getProvider().getId().equals(p.getId())) {
            response.put("success", false);
            response.put("message", "Booking not found");
            return response;
        }

        try {
            ProviderBookingStatus newStatus = ProviderBookingStatus.valueOf(status);
            b.setStatus(newStatus);
            bookingRepo.save(b);
            response.put("success", true);
            response.put("newStatus", newStatus.name());
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Invalid status");
        }
        return response;
    }

    // ==============================
    // Users: browse + book + review
    // ==============================
    @GetMapping
    public String categories(Model model) {
        List<String> dynamicCategories = jobAppRepo.findDistinctJobCategoriesByStatus(VerificationStatus.VERIFIED);
        model.addAttribute("dynamicCategories", dynamicCategories);
        model.addAttribute("providerCategories", ProviderCategory.values());
        return "marketplace/marketplace-home";
    }

    @GetMapping("/workers")
    public String workersList(@RequestParam String category, Model model, HttpSession session) {
        User u = (User) session.getAttribute("user");
        if (u == null) return "redirect:/login";

        List<in.sp.main.Entities.JobApplication> workers = jobAppRepo.findByJobCategoryAndStatus(category, VerificationStatus.VERIFIED);
        model.addAttribute("category", category);
        model.addAttribute("workers", workers);
        return "marketplace/worker-list";
    }

    @GetMapping("/worker/{id}")
    public String workerDetails(@PathVariable Long id, Model model, HttpSession session) {
        User u = (User) session.getAttribute("user");
        if (u == null) return "redirect:/login";

        in.sp.main.Entities.JobApplication app = jobAppRepo.findById(id).orElse(null);
        if (app == null || app.getStatus() != VerificationStatus.VERIFIED) {
            return "redirect:/marketplace";
        }

        List<in.sp.main.Entities.WorkerBooking> bookings = workerBookingRepo.findByJobApplication_Id(id);
        List<String> bookedTimes = bookings.stream()
                .filter(b -> !"REJECTED".equals(b.getStatus()))
                .map(b -> b.getBookingDate().format(DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm")))
                .collect(java.util.stream.Collectors.toList());

        boolean revealContact = bookings.stream().anyMatch(b ->
                b.getClient() != null && b.getClient().getId().equals(u.getId())
                        && ("ACCEPTED".equals(b.getStatus()) || "PAID".equals(b.getStatus()) || "COMPLETED".equals(b.getStatus())));

        model.addAttribute("workerApp", app);
        model.addAttribute("bookedTimes", bookedTimes);
        model.addAttribute("revealContact", revealContact);
        return "marketplace/worker-details";
    }

    @PostMapping("/worker/{id}/book")
    public String bookWorker(@PathVariable Long id,
                             @RequestParam String bookingDate,
                             @RequestParam(required = false) Double totalAmount,
                             @RequestParam(required = false) String note,
                             HttpSession session,
                             RedirectAttributes redirectAttributes) {
        User u = (User) session.getAttribute("user");
        if (u == null) return "redirect:/login";

        in.sp.main.Entities.JobApplication app = jobAppRepo.findById(id).orElse(null);
        if (app == null || app.getStatus() != VerificationStatus.VERIFIED) {
            redirectAttributes.addFlashAttribute("message", "Worker not found or not verified.");
            return "redirect:/marketplace";
        }

        if (app.getUser() != null && app.getUser().getId().equals(u.getId())) {
            redirectAttributes.addFlashAttribute("error", "You cannot book your own services.");
            return "redirect:/marketplace/worker/" + id;
        }

        try {
            LocalDateTime reqTime = LocalDateTime.parse(bookingDate, DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm"));
            if (reqTime.isBefore(LocalDateTime.now())) {
                redirectAttributes.addFlashAttribute("error", "Booking date/time cannot be in the past.");
                return "redirect:/marketplace/worker/" + id;
            }
            if (reqTime.isAfter(LocalDateTime.now().plusDays(2))) {
                redirectAttributes.addFlashAttribute("error", "Bookings can only be made up to 2 days in advance.");
                return "redirect:/marketplace/worker/" + id;
            }

            // Check if slot is already booked (within 1 hour)
            List<in.sp.main.Entities.WorkerBooking> existingBookings = workerBookingRepo.findByJobApplication_Id(id);
            boolean isBooked = existingBookings.stream()
                .filter(b -> !"REJECTED".equals(b.getStatus()))
                .anyMatch(b -> java.time.Duration.between(b.getBookingDate(), reqTime).abs().toMinutes() < 60);

            if (isBooked) {
                redirectAttributes.addFlashAttribute("error", "This time slot is already booked.");
                return "redirect:/marketplace/worker/" + id;
            }

            in.sp.main.Entities.WorkerBooking booking = new in.sp.main.Entities.WorkerBooking();
            booking.setClient(u);
            booking.setJobApplication(app);
            booking.setBookingDate(reqTime);
            booking.setTotalAmount(totalAmount != null ? totalAmount : 0.0);
            booking.setNote(note);
            booking.setStatus("PENDING");
            
            workerBookingRepo.save(booking);
            
            // Broadcast live refresh to worker dashboard
            try {
                if (booking.getJobApplication() != null && booking.getJobApplication().getUser() != null) {
                    Long workerUserId = booking.getJobApplication().getUser().getId();
                    messagingTemplate.convertAndSend("/topic/worker-bookings/" + workerUserId, "REFRESH");
                }
            } catch (Exception ignored) {}

            redirectAttributes.addFlashAttribute("success", "Booking request sent successfully!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Invalid date format or booking failed.");
        }

        return "redirect:/marketplace/worker/" + id;
    }

    @GetMapping("/list")
    public String list(@RequestParam String category, Model model, HttpSession session,
                       RedirectAttributes redirectAttributes) {
        User u = (User) session.getAttribute("user");
        if (u == null) return "redirect:/login";

        ProviderCategory cat = ProviderCategory.fromFlexible(category);
        if (cat == null) {
            redirectAttributes.addFlashAttribute("error", "Invalid marketplace category.");
            return "redirect:/marketplace";
        }
        model.addAttribute("category", cat);
        model.addAttribute("categoryLabel", formatCategoryLabel(cat));
        model.addAttribute("providers", providerRepo.findByCategoryAndVerificationStatus(cat, VerificationStatus.VERIFIED));
        return "marketplace/provider-list";
    }

    @GetMapping("/view/{id}")
    public String view(@PathVariable Long id, Model model, HttpSession session) {
        User u = (User) session.getAttribute("user");
        if (u == null) return "redirect:/login";

        ServiceProvider p = providerRepo.findById(id).orElse(null);
        if (p == null || p.getVerificationStatus() != VerificationStatus.VERIFIED) {
            return "redirect:/marketplace";
        }

        model.addAttribute("provider", p);
        model.addAttribute("categoryLabel", formatCategoryLabel(p.getCategory()));
        model.addAttribute("reviews", reviewRepo.findByProviderIdOrderByCreatedAtDesc(id));

        boolean alreadyReviewed = reviewRepo.existsByUserIdAndProviderId(u.getId(), id);
        boolean completedSession = bookingRepo.findByUserOrderByRequestedTimeDesc(u).stream()
                .anyMatch(b -> b.getProvider() != null && b.getProvider().getId().equals(id)
                        && b.getStatus() == ProviderBookingStatus.COMPLETED);
        boolean paidClass = enrollmentRepo.findByUser_Id(u.getId()).stream()
                .anyMatch(e -> e.getProviderClass() != null
                        && e.getProviderClass().getProvider() != null
                        && e.getProviderClass().getProvider().getId().equals(id)
                        && "PAID".equals(e.getPaymentStatus()));
        model.addAttribute("canReview", !alreadyReviewed && (completedSession || paidClass));
        
        // Load available classes
        model.addAttribute("classes", classRepo.findByProvider_Id(id));
        
        return "marketplace/provider-view";
    }

    @PostMapping("/classes/enroll")
    public String enrollClass(@RequestParam Long classId, HttpSession session, RedirectAttributes redirectAttributes) {
        User u = (User) session.getAttribute("user");
        if (u == null) return "redirect:/login";

        ProviderClass pc = classRepo.findById(classId).orElse(null);
        if (pc == null || pc.getAvailableSeats() == null || pc.getAvailableSeats() <= 0) {
            redirectAttributes.addFlashAttribute("error", "Class not available or full.");
            return "redirect:/marketplace";
        }

        if (pc.getDateTime() != null && pc.getDateTime().isBefore(LocalDateTime.now())) {
            redirectAttributes.addFlashAttribute("error", "Cannot enroll in a class that has already started or ended.");
            Long providerId = pc.getProvider() != null ? pc.getProvider().getId() : null;
            return providerId != null ? "redirect:/marketplace/view/" + providerId : "redirect:/marketplace";
        }

        if (enrollmentRepo.findByUser_Id(u.getId()).stream().anyMatch(e ->
                e.getProviderClass() != null
                        && classId.equals(e.getProviderClass().getId())
                        && !"CANCELLED".equals(e.getPaymentStatus()))) {
            redirectAttributes.addFlashAttribute("message", "You are already enrolled.");
            return "redirect:/marketplace/my-classes";
        }

        boolean paidClass = pc.getPrice() != null && pc.getPrice() > 0;

        MarketplaceEnrollment enrollment = new MarketplaceEnrollment();
        enrollment.setUser(u);
        enrollment.setProviderClass(pc);
        enrollment.setStatus("ENROLLED");
        enrollment.setPaymentStatus(paidClass ? "PENDING" : "PAID");
        enrollment.setEnrollmentTime(LocalDateTime.now());
        
        enrollmentRepo.save(enrollment);
        
        // Hold seat immediately; restored if user cancels unpaid checkout
        pc.setAvailableSeats(pc.getAvailableSeats() - 1);
        classRepo.save(pc);

        if (paidClass) {
            if (!razorpayConfigured()) {
                redirectAttributes.addFlashAttribute("error",
                        "Payment gateway is not configured. Please contact support or try again later.");
            }
            return "redirect:/marketplace/payment/" + enrollment.getId();
        }

        redirectAttributes.addFlashAttribute("message", "Enrolled successfully!");
        return "redirect:/marketplace/my-classes";
    }

    @GetMapping("/payment/{enrollmentId}")
    public String paymentPage(@PathVariable Long enrollmentId, Model model, HttpSession session) {
        User u = (User) session.getAttribute("user");
        if (u == null) return "redirect:/login";

        MarketplaceEnrollment e = enrollmentRepo.findById(enrollmentId).orElse(null);
        if (e == null || !e.getUser().getId().equals(u.getId())) return "redirect:/marketplace";

        model.addAttribute("enrollment", e);
        model.addAttribute("razorpayConfigured", razorpayConfigured());
        return "marketplace/payment";
    }

    @GetMapping("/payment/{enrollmentId}/cancel")
    public String cancelPayment(@PathVariable Long enrollmentId, HttpSession session,
                                RedirectAttributes redirectAttributes) {
        User u = (User) session.getAttribute("user");
        if (u == null) return "redirect:/login";

        MarketplaceEnrollment e = enrollmentRepo.findById(enrollmentId).orElse(null);
        if (e == null || e.getUser() == null || !e.getUser().getId().equals(u.getId())) {
            return "redirect:/marketplace";
        }

        if ("PENDING".equals(e.getPaymentStatus())) {
            ProviderClass pc = e.getProviderClass();
            if (pc != null && pc.getAvailableSeats() != null) {
                pc.setAvailableSeats(pc.getAvailableSeats() + 1);
                classRepo.save(pc);
            }
            e.setStatus("CANCELLED");
            e.setPaymentStatus("CANCELLED");
            enrollmentRepo.save(e);
            redirectAttributes.addFlashAttribute("message", "Checkout cancelled. Your seat was released.");
        }
        return "redirect:/marketplace/my-classes";
    }

    /**
     * Fake "confirm paid" without Razorpay — disabled. Use /payment/create-order + /payment/verify.
     */
    @PostMapping("/payment/confirm")
    public String confirmPayment(HttpSession session, RedirectAttributes redirectAttributes) {
        if (session.getAttribute("user") == null) return "redirect:/login";
        redirectAttributes.addFlashAttribute("error", "Direct payment confirmation is disabled. Complete payment via Razorpay.");
        return "redirect:/marketplace";
    }

    @GetMapping("/my-classes")
    public String myClasses(HttpSession session, Model model,
                            @RequestParam(value = "message", required = false) String message) {
        User u = (User) session.getAttribute("user");
        if (u == null) return "redirect:/login";

        model.addAttribute("enrollments", enrollmentRepo.findByUser_Id(u.getId()));
        model.addAttribute("now", LocalDateTime.now());
        if (message != null && !message.isBlank() && !model.containsAttribute("message")) {
            model.addAttribute("message", message.replace('-', ' '));
        }
        return "marketplace/my-classes";
    }

    // Provider creates classes (for testing/dashboard)
    @PostMapping("/provider/classes/add")
    public String addClass(@RequestParam String className,
                           @RequestParam String description,
                           @RequestParam String duration,
                           @RequestParam String dateTime,
                           @RequestParam String mode,
                           @RequestParam Double price,
                           @RequestParam(required = false) Integer seats,
                           @RequestParam(required = false) String meetingLink,
                           @RequestParam(required = false) String serviceLocation,
                           @RequestParam String category,
                           @RequestParam(required = false) String serviceProvided,
                           HttpSession session,
                           RedirectAttributes redirectAttributes) {
        ServiceProvider p = (ServiceProvider) session.getAttribute("loggedProvider");
        if (p == null) return "redirect:/marketplace/provider/login";

        String normalizedMode = mode != null ? mode.trim() : "";
        boolean isOnline = normalizedMode.equalsIgnoreCase("Online") || normalizedMode.equalsIgnoreCase("Live") || normalizedMode.contains("Online");
        boolean isOffline = normalizedMode.equalsIgnoreCase("Offline") || normalizedMode.contains("Offline");
        boolean isHybrid = normalizedMode.contains("Hybrid");

        if ((isOnline || isHybrid) && (meetingLink == null || meetingLink.isBlank())) {
            redirectAttributes.addFlashAttribute("error", "Meeting link is required for Online / Hybrid sessions.");
            return "redirect:/marketplace/provider/dashboard";
        }

        if ((isOffline || isHybrid) && (serviceLocation == null || serviceLocation.isBlank())) {
            redirectAttributes.addFlashAttribute("error", "Service location is required for Offline / Hybrid sessions.");
            return "redirect:/marketplace/provider/dashboard";
        }

        ProviderClass pc = new ProviderClass();
        pc.setProvider(p);
        pc.setClassName(className);
        pc.setDescription(description);
        pc.setDuration(duration);
        pc.setDateTime(LocalDateTime.parse(dateTime));
        pc.setMode(mode);
        pc.setPrice(price);
        pc.setAvailableSeats(seats != null ? seats : 100);
        pc.setMeetingLink(meetingLink != null ? meetingLink.trim() : "");
        pc.setServiceLocation(serviceLocation != null ? serviceLocation.trim() : "");
        pc.setCategory(ProviderCategory.valueOf(category.trim().toUpperCase()));
        if (serviceProvided != null && !serviceProvided.isBlank()) {
            pc.setServiceProvided(serviceProvided.trim());
        }

        classRepo.save(pc);
        return "redirect:/marketplace/provider/dashboard";
    }

    @PostMapping("/book")
    public String book(@RequestParam Long providerId,
                       @RequestParam String requestedTime,
                       @RequestParam(required = false) String note,
                       HttpSession session,
                       RedirectAttributes redirectAttributes) {
        User u = (User) session.getAttribute("user");
        if (u == null) return "redirect:/login";

        ServiceProvider p = providerRepo.findById(providerId).orElse(null);
        if (p == null || p.getVerificationStatus() != VerificationStatus.VERIFIED) {
            redirectAttributes.addFlashAttribute("error", "Provider not available.");
            return "redirect:/marketplace";
        }

        LocalDateTime reqTime;
        try {
            reqTime = LocalDateTime.parse(requestedTime, DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm"));
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Invalid date format.");
            return "redirect:/marketplace/view/" + providerId;
        }

        if (reqTime.isBefore(LocalDateTime.now())) {
            redirectAttributes.addFlashAttribute("error", "Booking date/time cannot be in the past.");
            return "redirect:/marketplace/view/" + providerId;
        }

        boolean slotTaken = bookingRepo.findByProviderOrderByRequestedTimeDesc(p).stream()
                .filter(b -> b.getStatus() != ProviderBookingStatus.CANCELLED)
                .anyMatch(b -> b.getRequestedTime() != null
                        && java.time.Duration.between(b.getRequestedTime(), reqTime).abs().toMinutes() < 60);
        if (slotTaken) {
            redirectAttributes.addFlashAttribute("error", "This time slot is already booked. Please choose another time.");
            return "redirect:/marketplace/view/" + providerId;
        }

        ProviderBooking b = new ProviderBooking();
        b.setUser(u);
        b.setProvider(p);
        b.setRequestedTime(reqTime);
        b.setNote(note);
        b.setStatus(ProviderBookingStatus.PENDING);
        bookingRepo.save(b);

        redirectAttributes.addFlashAttribute("message", "Booking request sent.");
        return "redirect:/marketplace/myBookings";
    }

    @GetMapping("/myBookings")
    public String myBookings(HttpSession session, Model model) {
        User u = (User) session.getAttribute("user");
        if (u == null) return "redirect:/login";

        model.addAttribute("bookings", bookingRepo.findByUserOrderByRequestedTimeDesc(u));
        model.addAttribute("workerBookings", workerBookingRepo.findByClient_Id(u.getId()));
        return "marketplace/my-bookings";
    }

    /**
     * Fake worker payment without Razorpay — disabled. Use /payment/create-order + /payment/verify with type WORKER_BOOKING.
     */
    @PostMapping("/worker-booking/{id}/pay")
    public String payWorkerBooking(@PathVariable Long id, HttpSession session, RedirectAttributes redirectAttributes) {
        if (session.getAttribute("user") == null) return "redirect:/login";
        redirectAttributes.addFlashAttribute("error", "Direct worker payment is disabled. Complete payment via Razorpay.");
        return "redirect:/marketplace/myBookings";
    }

    @PostMapping("/review")
    public String review(@RequestParam Long providerId,
                         @RequestParam Integer rating,
                         @RequestParam(required = false) String comment,
                         HttpSession session,
                         RedirectAttributes redirectAttributes) {
        User u = (User) session.getAttribute("user");
        if (u == null) return "redirect:/login";

        ServiceProvider p = providerRepo.findById(providerId).orElse(null);
        if (p == null) return "redirect:/marketplace";

        if (rating == null || rating < 1 || rating > 5) {
            redirectAttributes.addFlashAttribute("error", "Rating must be 1-5.");
            return "redirect:/marketplace/view/" + providerId;
        }

        if (reviewRepo.existsByUserIdAndProviderId(u.getId(), providerId)) {
            redirectAttributes.addFlashAttribute("error", "You already reviewed this provider.");
            return "redirect:/marketplace/view/" + providerId;
        }

        boolean completedSession = bookingRepo.findByUserOrderByRequestedTimeDesc(u).stream()
                .anyMatch(b -> b.getProvider() != null && b.getProvider().getId().equals(providerId)
                        && b.getStatus() == ProviderBookingStatus.COMPLETED);
        boolean paidClass = enrollmentRepo.findByUser_Id(u.getId()).stream()
                .anyMatch(e -> e.getProviderClass() != null
                        && e.getProviderClass().getProvider() != null
                        && e.getProviderClass().getProvider().getId().equals(providerId)
                        && "PAID".equals(e.getPaymentStatus()));
        if (!completedSession && !paidClass) {
            redirectAttributes.addFlashAttribute("error", "You can review only after completing a session or paid class with this provider.");
            return "redirect:/marketplace/view/" + providerId;
        }

        ProviderReview r = new ProviderReview();
        r.setUser(u);
        r.setProvider(p);
        r.setRating(rating);
        r.setComment(comment);
        reviewRepo.save(r);

        List<ProviderReview> reviews = reviewRepo.findByProviderIdOrderByCreatedAtDesc(providerId);
        double avg = reviews.stream().mapToInt(x -> x.getRating() == null ? 0 : x.getRating()).average().orElse(0.0);
        p.setRating(avg);
        providerRepo.save(p);

        redirectAttributes.addFlashAttribute("message", "Review submitted.");
        return "redirect:/marketplace/view/" + providerId;
    }
}

