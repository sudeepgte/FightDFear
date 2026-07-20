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

    // ==============================
    // Provider registration + login
    // ==============================
    @GetMapping("/provider/register")
    public String providerRegisterPage() {
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
                                   Model model) {
        if (providerRepo.findByEmail(email.trim().toLowerCase()).isPresent()) {
            model.addAttribute("error", "Email already registered.");
            return "marketplace/provider-register";
        }

        if (phone == null || !phone.trim().matches("^\\d{10}$")) {
            model.addAttribute("error", "Phone number must be exactly 10 digits.");
            return "marketplace/provider-register";
        }

        try {
            String docPath = fileUploadService.saveFile(identityDoc);

            ServiceProvider p = new ServiceProvider();
            p.setFullName(fullName);
            p.setEmail(email.trim().toLowerCase());
            p.setPhone(phone);
            p.setPassword(password);
            
            // Robust category parsing
            try {
                p.setCategory(ProviderCategory.valueOf(category.trim().toUpperCase()));
            } catch (Exception e) {
                model.addAttribute("error", "Invalid category: " + category);
                return "marketplace/provider-register";
            }
            
            p.setDescription(description);
            p.setLocationText(locationText);
            p.setIdentityDocumentPath(docPath);
            p.setVerificationStatus(VerificationStatus.PENDING);
            p.setRating(0.0);

            providerRepo.save(p);
            model.addAttribute("message", "Registration successful! Await admin verification.");
            return "redirect:/marketplace/provider/login";
        } catch (IllegalArgumentException e) {
            model.addAttribute("error", "Invalid category selected.");
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
        if (!p.getPassword().equals(password)) {
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
                .mapToDouble(e -> e.getProviderClass().getPrice())
                .sum();
        model.addAttribute("totalEarnings", totalEarnings);
        return "marketplace/provider-dashboard";
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

        model.addAttribute("workerApp", app);
        model.addAttribute("bookedTimes", bookedTimes);
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
            redirectAttributes.addFlashAttribute("success", "Booking request sent successfully!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Invalid date format or booking failed.");
        }

        return "redirect:/marketplace/worker/" + id;
    }

    @GetMapping("/list")
    public String list(@RequestParam String category, Model model, HttpSession session) {
        User u = (User) session.getAttribute("user");
        if (u == null) return "redirect:/login";

        ProviderCategory cat = ProviderCategory.valueOf(category);
        model.addAttribute("category", cat);
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
        model.addAttribute("reviews", reviewRepo.findByProviderIdOrderByCreatedAtDesc(id));
        model.addAttribute("canReview", !reviewRepo.existsByUserIdAndProviderId(u.getId(), id));
        
        // Load available classes
        model.addAttribute("classes", classRepo.findByProvider_Id(id));
        
        return "marketplace/provider-view";
    }

    @PostMapping("/classes/enroll")
    public String enrollClass(@RequestParam Long classId, HttpSession session, RedirectAttributes redirectAttributes) {
        User u = (User) session.getAttribute("user");
        if (u == null) return "redirect:/login";

        ProviderClass pc = classRepo.findById(classId).orElse(null);
        if (pc == null || pc.getAvailableSeats() <= 0) {
            redirectAttributes.addFlashAttribute("message", "Class not available or full.");
            return "redirect:/marketplace";
        }

        if (enrollmentRepo.existsByUser_IdAndProviderClass_Id(u.getId(), classId)) {
            redirectAttributes.addFlashAttribute("message", "You are already enrolled.");
            return "redirect:/marketplace/my-classes";
        }

        MarketplaceEnrollment enrollment = new MarketplaceEnrollment();
        enrollment.setUser(u);
        enrollment.setProviderClass(pc);
        enrollment.setStatus("ENROLLED");
        enrollment.setPaymentStatus(pc.getPrice() > 0 ? "PENDING" : "PAID");
        enrollment.setEnrollmentTime(LocalDateTime.now());
        
        enrollmentRepo.save(enrollment);
        
        // Deduct seat
        pc.setAvailableSeats(pc.getAvailableSeats() - 1);
        classRepo.save(pc);

        if (pc.getPrice() > 0) {
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
        return "marketplace/payment";
    }

    @PostMapping("/payment/confirm")
    public String confirmPayment(@RequestParam Long enrollmentId, HttpSession session, RedirectAttributes redirectAttributes) {
        User u = (User) session.getAttribute("user");
        if (u == null) return "redirect:/login";

        MarketplaceEnrollment e = enrollmentRepo.findById(enrollmentId).orElse(null);
        if (e == null || !e.getUser().getId().equals(u.getId())) return "redirect:/marketplace";

        e.setPaymentStatus("PAID");
        enrollmentRepo.save(e);

        redirectAttributes.addFlashAttribute("message", "Payment successful! Enrolled.");
        return "redirect:/marketplace/my-classes";
    }

    @GetMapping("/my-classes")
    public String myClasses(HttpSession session, Model model) {
        User u = (User) session.getAttribute("user");
        if (u == null) return "redirect:/login";

        model.addAttribute("enrollments", enrollmentRepo.findByUser_Id(u.getId()));
        model.addAttribute("now", LocalDateTime.now());
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
                           @RequestParam Integer seats,
                           @RequestParam String meetingLink,
                           @RequestParam String category,
                           HttpSession session) {
        ServiceProvider p = (ServiceProvider) session.getAttribute("loggedProvider");
        if (p == null) return "redirect:/marketplace/provider/login";

        ProviderClass pc = new ProviderClass();
        pc.setProvider(p);
        pc.setClassName(className);
        pc.setDescription(description);
        pc.setDuration(duration);
        pc.setDateTime(LocalDateTime.parse(dateTime));
        pc.setMode(mode);
        pc.setPrice(price);
        pc.setAvailableSeats(seats);
        pc.setMeetingLink(meetingLink);
        pc.setCategory(ProviderCategory.valueOf(category.trim().toUpperCase()));

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
            redirectAttributes.addFlashAttribute("message", "Provider not available.");
            return "redirect:/marketplace";
        }

        LocalDateTime reqTime;
        try {
            reqTime = LocalDateTime.parse(requestedTime, DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm"));
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("message", "Invalid date format.");
            return "redirect:/marketplace/view/" + providerId;
        }

        if (reqTime.isBefore(LocalDateTime.now())) {
            redirectAttributes.addFlashAttribute("message", "Booking date/time cannot be in the past.");
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

    @GetMapping("/worker-bookings")
    public String workerBookings(HttpSession session, Model model) {
        User u = (User) session.getAttribute("user");
        if (u == null) return "redirect:/login";

        in.sp.main.Entities.JobApplication app = jobAppRepo.findByStatus(VerificationStatus.VERIFIED)
                .stream().filter(a -> a.getUser().getId().equals(u.getId())).findFirst().orElse(null);

        if (app == null) {
            return "redirect:/users/dashboard";
        }

        List<in.sp.main.Entities.WorkerBooking> incomingBookings = workerBookingRepo.findByJobApplication_Id(app.getId());
        model.addAttribute("incomingBookings", incomingBookings);
        return "marketplace/worker-dashboard-bookings";
    }

    @GetMapping("/myBookings")
    public String myBookings(HttpSession session, Model model) {
        User u = (User) session.getAttribute("user");
        if (u == null) return "redirect:/login";

        model.addAttribute("bookings", bookingRepo.findByUserOrderByRequestedTimeDesc(u));
        model.addAttribute("workerBookings", workerBookingRepo.findByClient_Id(u.getId()));
        return "marketplace/my-bookings";
    }

    @PostMapping("/worker-booking/{id}/status")
    public String updateWorkerBookingStatus(@PathVariable Long id, @RequestParam String status, HttpSession session, RedirectAttributes redirectAttributes) {
        User u = (User) session.getAttribute("user");
        if (u == null) return "redirect:/login";
        
        in.sp.main.Entities.WorkerBooking booking = workerBookingRepo.findById(id).orElse(null);
        if (booking != null && booking.getJobApplication().getUser().getId().equals(u.getId())) {
            booking.setStatus(status); // ACCEPTED, REJECTED, COMPLETED
            workerBookingRepo.save(booking);
            redirectAttributes.addFlashAttribute("success", "Booking updated successfully!");
        }
        return "redirect:/marketplace/worker-bookings";
    }

    @PostMapping("/worker-booking/{id}/pay")
    public String payWorkerBooking(@PathVariable Long id, HttpSession session, RedirectAttributes redirectAttributes) {
        User u = (User) session.getAttribute("user");
        if (u == null) return "redirect:/login";

        Optional<in.sp.main.Entities.WorkerBooking> bOpt = workerBookingRepo.findById(id);
        if (bOpt.isPresent()) {
            in.sp.main.Entities.WorkerBooking booking = bOpt.get();
            if (booking.getClient().getId().equals(u.getId()) && booking.getStatus().equals("ACCEPTED")) {
                booking.setStatus("PAID");
                workerBookingRepo.save(booking);
                redirectAttributes.addFlashAttribute("success", "Payment successful!");
            }
        }
        return "redirect:/user/bookings";
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
            redirectAttributes.addFlashAttribute("message", "Rating must be 1-5.");
            return "redirect:/marketplace/view/" + providerId;
        }

        if (reviewRepo.existsByUserIdAndProviderId(u.getId(), providerId)) {
            redirectAttributes.addFlashAttribute("message", "You already reviewed this provider.");
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

