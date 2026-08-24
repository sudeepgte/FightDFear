package in.sp.main.Controller;

import in.sp.main.Entities.JobApplication;
import in.sp.main.Entities.User;
import in.sp.main.Entities.VerificationStatus;
import in.sp.main.Repository.JobApplicationRepository;
import in.sp.main.Repository.UserRepository;
import in.sp.main.Service.FileUploadService;
import in.sp.main.Service.UserService;
import in.sp.main.Service.PasswordService;
import in.sp.main.Config.JwtUtil;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.Optional;

@Controller
@RequestMapping("/women-jobs")
public class WomenJobsController {

    @Autowired
    private UserService userService;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private JobApplicationRepository jobAppRepo;

    @Autowired
    private FileUploadService fileUploadService;

    @Autowired
    private PasswordService passwordService;

    @Autowired
    private JwtUtil jwtUtil;

    @Autowired
    private in.sp.main.Repository.WorkerBookingRepository workerBookingRepo;

    @Autowired
    private in.sp.main.Service.OtpVerificationService otpVerificationService;

    @Autowired
    private org.springframework.messaging.simp.SimpMessagingTemplate messagingTemplate;

    @GetMapping("/login")
    public String showLoginPage(Model model) {
        return "marketplace/women-jobs-login";
    }

    @PostMapping("/login")
    public String login(@RequestParam String email,
                        @RequestParam String password,
                        HttpSession session,
                        jakarta.servlet.http.HttpServletResponse response,
                        Model model) {
        String normEmail = (email == null) ? "" : email.trim().toLowerCase();
        String rawPassword = (password == null) ? "" : password;

        User user = userService.findByUsername(normEmail);
        if (user == null || user.getPassword() == null) {
            model.addAttribute("error", "Worker not found.");
            return "marketplace/women-jobs-login";
        }

        boolean ok = passwordService.matchesAndUpgrade(rawPassword, user.getPassword(), hashed -> {
            user.setPassword(hashed);
            userService.createUser(user);
        });

        if (!ok) {
            model.addAttribute("error", "Invalid credentials.");
            return "marketplace/women-jobs-login";
        }

        if (user.isBanned()) {
            model.addAttribute("error", "Your account has been banned.");
            return "marketplace/women-jobs-login";
        }

        // Set session
        session.setAttribute("user", user);

        // Set JWT Cookie
        String token = jwtUtil.generateToken(user.getEmail(), "USER");
        jakarta.servlet.http.Cookie cookie = new jakarta.servlet.http.Cookie("JWT_TOKEN", token);
        cookie.setPath("/");
        cookie.setHttpOnly(true);
        cookie.setMaxAge(365 * 24 * 60 * 60);
        response.addCookie(cookie);

        // Check if the user has a verified job application
        Optional<JobApplication> appOpt = jobAppRepo
                .findFirstByUser_IdAndStatusOrderByAppliedAtDesc(user.getId(), VerificationStatus.VERIFIED);
        
        if (appOpt.isPresent()) {
            // Worker is verified, redirect to dashboard bookings page
            return "redirect:/women-jobs/dashboard";
        }

        // Check if there is a pending application
        Optional<JobApplication> pendingOpt = jobAppRepo
                .findFirstByUser_IdAndStatusOrderByAppliedAtDesc(user.getId(), VerificationStatus.PENDING);
        if (pendingOpt.isPresent()) {
            model.addAttribute("error", "Your worker application is pending admin verification. You will be able to access the dashboard once approved.");
            // Log them out of session so they don't stay half logged-in
            session.removeAttribute("user");
            return "marketplace/women-jobs-login";
        }

        // If no application exists, redirect to the application page (they are registered but haven't applied)
        return "redirect:/marketplace/earn";
    }

    @GetMapping("/register")
    public String showRegisterPage(Model model) {
        return "marketplace/women-jobs-register";
    }

    @PostMapping("/register")
    public String register(@RequestParam String fullName,
                           @RequestParam String email,
                           @RequestParam String phone,
                           @RequestParam String password,
                           @RequestParam String confirmPassword,
                           @RequestParam String jobCategory,
                           @RequestParam String jobSubCategory,
                           @RequestParam Double hourlyRate,
                           @RequestParam("proofDocument") MultipartFile proofDocument,
                           Model model,
                           RedirectAttributes ra) {
        // Validation
        if (fullName == null || fullName.trim().isEmpty()) {
            model.addAttribute("error", "Full Name is required.");
            return "marketplace/women-jobs-register";
        }
        if (!fullName.trim().matches("^[a-zA-Z\\s]+$")) {
            model.addAttribute("error", "Full Name must contain only alphabets and spaces.");
            return "marketplace/women-jobs-register";
        }
        if (fullName.trim().length() < 2) {
            model.addAttribute("error", "Full Name must be at least 2 characters.");
            return "marketplace/women-jobs-register";
        }
        if (email == null || email.trim().isEmpty()) {
            model.addAttribute("error", "Email is required.");
            return "marketplace/women-jobs-register";
        }
        String normalizedEmail = email.trim().toLowerCase();
        if (!normalizedEmail.matches("^[a-zA-Z0-9_+&*-]+(?:\\.[a-zA-Z0-9_+&*-]+)*@(?:[a-zA-Z0-9-]+\\.)+[a-zA-Z]{2,7}$")) {
            model.addAttribute("error", "Please enter a valid email address.");
            return "marketplace/women-jobs-register";
        }
        if (userRepository.findByEmail(normalizedEmail).isPresent()) {
            model.addAttribute("error", "Email already registered. Please login.");
            return "marketplace/women-jobs-register";
        }
        if (!otpVerificationService.consumeVerifiedOtp(normalizedEmail, in.sp.main.Entities.OtpPurpose.JOB_WORKER_REGISTER, 10)) {
            model.addAttribute("error", "Email is not verified. Please verify your email via OTP first.");
            return "marketplace/women-jobs-register";
        }
        if (phone == null || !phone.trim().matches("^\\d{10}$")) {
            model.addAttribute("error", "Phone number must be exactly 10 digits.");
            return "marketplace/women-jobs-register";
        }
        if (password == null || password.length() < 8) {
            model.addAttribute("error", "Password must be at least 8 characters.");
            return "marketplace/women-jobs-register";
        }
        if (!password.equals(confirmPassword)) {
            model.addAttribute("error", "Password and Confirm Password do not match.");
            return "marketplace/women-jobs-register";
        }
        if (hourlyRate == null || hourlyRate <= 0) {
            model.addAttribute("error", "Hourly rate must be greater than zero.");
            return "marketplace/women-jobs-register";
        }
        if (proofDocument == null || proofDocument.isEmpty()) {
            model.addAttribute("error", "Please upload a proof document.");
            return "marketplace/women-jobs-register";
        }

        try {
            // Save proof document
            String docPath = fileUploadService.saveFile(proofDocument);

            // Create User
            User user = new User();
            user.setFullName(fullName.trim());
            user.setEmail(normalizedEmail);
            user.setPhoneNumber(phone.trim());
            user.setPassword(passwordService.encode(password));
            user.setVerificationStatus(VerificationStatus.VERIFIED); // User verified so they can log in
            user.setIdentityDocument("web-worker|jobCat:" + jobCategory);
            userService.createUser(user);

            // Create JobApplication
            JobApplication application = new JobApplication();
            application.setUser(user);
            application.setJobCategory(jobCategory);
            application.setJobSubCategory(jobSubCategory);
            application.setHourlyRate(hourlyRate);
            application.setDocumentPath(docPath);
            application.setStatus(VerificationStatus.PENDING); // Pending admin verification
            jobAppRepo.save(application);

            ra.addFlashAttribute("success", "Registration and application successful! Please await admin verification.");
            return "redirect:/women-jobs/login";

        } catch (Exception e) {
            model.addAttribute("error", "Registration failed: " + e.getMessage());
            return "marketplace/women-jobs-register";
        }
    }

    @GetMapping("/dashboard")
    public String workerDashboard(HttpSession session, Model model, RedirectAttributes redirectAttributes) {
        User u = (User) session.getAttribute("user");
        if (u == null) return "redirect:/login";

        in.sp.main.Entities.JobApplication app = jobAppRepo
                .findFirstByUser_IdAndStatusOrderByAppliedAtDesc(u.getId(), VerificationStatus.VERIFIED)
                .orElse(null);

        if (app == null) {
            redirectAttributes.addFlashAttribute("error", "Job Bookings are available only for verified workers.");
            return "redirect:/marketplace";
        }

        java.util.List<in.sp.main.Entities.WorkerBooking> incomingBookings = workerBookingRepo.findByJobApplication_Id(app.getId());
        
        long totalBookings = incomingBookings.size();
        long pendingBookings = incomingBookings.stream().filter(b -> "PENDING".equalsIgnoreCase(b.getStatus())).count();
        long completedBookings = incomingBookings.stream().filter(b -> "COMPLETED".equalsIgnoreCase(b.getStatus()) || "PAID".equalsIgnoreCase(b.getStatus())).count();
        double totalEarnings = incomingBookings.stream()
                .filter(b -> "COMPLETED".equalsIgnoreCase(b.getStatus()) || "PAID".equalsIgnoreCase(b.getStatus()))
                .mapToDouble(b -> b.getTotalAmount() != null ? b.getTotalAmount() : 0.0)
                .sum();

        model.addAttribute("incomingBookings", incomingBookings);
        model.addAttribute("totalBookings", totalBookings);
        model.addAttribute("pendingBookings", pendingBookings);
        model.addAttribute("completedBookings", completedBookings);
        model.addAttribute("totalEarnings", totalEarnings);
        model.addAttribute("workerApp", app);
        
        model.addAttribute("isWorker", true);
        session.setAttribute("isWorker", true);
        model.addAttribute("isWorkerDashboard", true);

        return "marketplace/worker-dashboard-bookings";
    }

    @PostMapping("/booking/{id}/status")
    public String updateWorkerBookingStatus(@PathVariable Long id, @RequestParam String status, HttpSession session, RedirectAttributes redirectAttributes) {
        User u = (User) session.getAttribute("user");
        if (u == null) return "redirect:/login";
        
        in.sp.main.Entities.WorkerBooking booking = workerBookingRepo.findById(id).orElse(null);
        if (booking == null || booking.getJobApplication() == null || booking.getJobApplication().getUser() == null
                || !booking.getJobApplication().getUser().getId().equals(u.getId())) {
            redirectAttributes.addFlashAttribute("error", "Booking not found.");
            return "redirect:/women-jobs/dashboard";
        }

        String current = booking.getStatus() != null ? booking.getStatus() : "";
        String next = status != null ? status.trim().toUpperCase() : "";
        boolean allowed =
                ("PENDING".equals(current) && ("ACCEPTED".equals(next) || "REJECTED".equals(next)))
                || (("ACCEPTED".equals(current) || "PAID".equals(current)) && "COMPLETED".equals(next));

        if (!allowed) {
            redirectAttributes.addFlashAttribute("error", "Invalid booking status transition.");
            return "redirect:/women-jobs/dashboard";
        }

        booking.setStatus(next);
        workerBookingRepo.save(booking);

        // Broadcast live refresh to worker and client dashboards
        try {
            if (booking.getJobApplication() != null && booking.getJobApplication().getUser() != null) {
                Long workerUserId = booking.getJobApplication().getUser().getId();
                messagingTemplate.convertAndSend("/topic/worker-bookings/" + workerUserId, "REFRESH");
            }
            if (booking.getClient() != null) {
                Long clientUserId = booking.getClient().getId();
                messagingTemplate.convertAndSend("/topic/client-bookings/" + clientUserId, "REFRESH");
            }
        } catch (Exception ignored) {}

        redirectAttributes.addFlashAttribute("success", "Booking updated successfully!");
        return "redirect:/women-jobs/dashboard";
    }

    @PostMapping("/send-otp")
    @ResponseBody
    public java.util.Map<String, Object> sendOtp(@RequestParam String email) {
        java.util.Map<String, Object> response = new java.util.HashMap<>();
        try {
            otpVerificationService.sendOtp(email, in.sp.main.Entities.OtpPurpose.JOB_WORKER_REGISTER, in.sp.main.Entities.OtpChannel.EMAIL);
            response.put("success", true);
            response.put("message", "OTP sent successfully.");
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", e.getMessage());
        }
        return response;
    }

    @PostMapping("/verify-otp")
    @ResponseBody
    public java.util.Map<String, Object> verifyOtp(@RequestParam String email, @RequestParam String otp) {
        java.util.Map<String, Object> response = new java.util.HashMap<>();
        boolean verified = otpVerificationService.verifyOtp(email, otp, in.sp.main.Entities.OtpPurpose.JOB_WORKER_REGISTER);
        if (verified) {
            response.put("success", true);
            response.put("message", "Email verified successfully!");
        } else {
            response.put("success", false);
            response.put("message", "Invalid or expired OTP.");
        }
        return response;
    }

    @GetMapping("/profile")
    public String workerProfile(HttpSession session, Model model, RedirectAttributes redirectAttributes) {
        User u = (User) session.getAttribute("user");
        if (u == null) return "redirect:/login";

        in.sp.main.Entities.JobApplication app = jobAppRepo
                .findFirstByUser_IdAndStatusOrderByAppliedAtDesc(u.getId(), VerificationStatus.VERIFIED)
                .orElse(null);
        if (app == null) {
            app = jobAppRepo
                .findFirstByUser_IdAndStatusOrderByAppliedAtDesc(u.getId(), VerificationStatus.PENDING)
                .orElse(null);
        }

        if (app == null) {
            redirectAttributes.addFlashAttribute("error", "Job Profile not found.");
            return "redirect:/marketplace";
        }

        model.addAttribute("workerApp", app);
        model.addAttribute("isWorkerDashboard", true);
        return "marketplace/worker-profile";
    }

    @PostMapping("/profile/send-otp")
    @ResponseBody
    public java.util.Map<String, Object> sendProfileOtp(HttpSession session) {
        java.util.Map<String, Object> response = new java.util.HashMap<>();
        User u = (User) session.getAttribute("user");
        if (u == null) {
            response.put("success", false);
            response.put("message", "User not logged in.");
            return response;
        }
        try {
            otpVerificationService.sendOtp(u.getEmail(), in.sp.main.Entities.OtpPurpose.JOB_WORKER_PROFILE_UPDATE, in.sp.main.Entities.OtpChannel.EMAIL);
            response.put("success", true);
            response.put("message", "OTP sent successfully to " + u.getEmail());
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", e.getMessage());
        }
        return response;
    }

    @PostMapping("/profile/verify-otp")
    @ResponseBody
    public java.util.Map<String, Object> verifyProfileOtp(@RequestParam String otp, HttpSession session) {
        java.util.Map<String, Object> response = new java.util.HashMap<>();
        User u = (User) session.getAttribute("user");
        if (u == null) {
            response.put("success", false);
            response.put("message", "User not logged in.");
            return response;
        }
        boolean verified = otpVerificationService.verifyOtp(u.getEmail(), otp, in.sp.main.Entities.OtpPurpose.JOB_WORKER_PROFILE_UPDATE);
        if (verified) {
            response.put("success", true);
            response.put("message", "Email verified successfully!");
        } else {
            response.put("success", false);
            response.put("message", "Invalid or expired OTP.");
        }
        return response;
    }

    @PostMapping("/profile")
    public String updateWorkerProfile(@RequestParam(required=false) String designation,
                                      @RequestParam(required=false) Integer yearsExperience,
                                      @RequestParam(required=false) String bio,
                                      @RequestParam(required=false) String whatsappNumber,
                                      @RequestParam(required=false) String skills,
                                      @RequestParam(required=false) String languages,
                                      @RequestParam(required=false) String address,
                                      @RequestParam(required=false) String city,
                                      @RequestParam(required=false) String state,
                                      @RequestParam(required=false) String pincode,
                                      @RequestParam(required=false) Double hourlyRate,
                                      @RequestParam(required=false) String bankDetails,
                                      @RequestParam(required=false) String upiId,
                                      HttpSession session,
                                      RedirectAttributes redirectAttributes) {
        User u = (User) session.getAttribute("user");
        if (u == null) return "redirect:/login";

        in.sp.main.Entities.JobApplication app = jobAppRepo
                .findFirstByUser_IdAndStatusOrderByAppliedAtDesc(u.getId(), VerificationStatus.VERIFIED)
                .orElse(null);
        if (app == null) {
            app = jobAppRepo
                .findFirstByUser_IdAndStatusOrderByAppliedAtDesc(u.getId(), VerificationStatus.PENDING)
                .orElse(null);
        }

        if (app == null) {
            redirectAttributes.addFlashAttribute("error", "Job Profile not found.");
            return "redirect:/marketplace";
        }

        if (!otpVerificationService.consumeVerifiedOtp(u.getEmail(), in.sp.main.Entities.OtpPurpose.JOB_WORKER_PROFILE_UPDATE, 10)) {
            redirectAttributes.addFlashAttribute("error", "Security check failed. Please verify your profile update with the OTP sent to your email.");
            return "redirect:/women-jobs/profile";
        }

        if (designation != null) app.setDesignation(designation);
        if (yearsExperience != null) app.setYearsExperience(yearsExperience);
        if (bio != null) app.setBio(bio);
        if (whatsappNumber != null) app.setWhatsappNumber(whatsappNumber);
        if (skills != null) app.setSkills(skills);
        if (languages != null) app.setLanguages(languages);
        if (address != null) {
            app.setAddress(address);
            u.setHomeAddress(address);
            userRepository.save(u);
        }
        if (city != null) app.setCity(city);
        if (state != null) app.setState(state);
        if (pincode != null) app.setPincode(pincode);
        if (hourlyRate != null) app.setHourlyRate(hourlyRate);
        if (bankDetails != null) app.setBankDetails(bankDetails);
        if (upiId != null) app.setUpiId(upiId);

        jobAppRepo.save(app);
        redirectAttributes.addFlashAttribute("success", "Profile updated successfully!");
        return "redirect:/women-jobs/profile";
    }

    @GetMapping("/earnings")
    public String workerEarnings(HttpSession session, Model model, RedirectAttributes redirectAttributes) {
        User u = (User) session.getAttribute("user");
        if (u == null) return "redirect:/login";

        in.sp.main.Entities.JobApplication app = jobAppRepo
                .findFirstByUser_IdAndStatusOrderByAppliedAtDesc(u.getId(), VerificationStatus.VERIFIED)
                .orElse(null);
        if (app == null) {
            app = jobAppRepo
                .findFirstByUser_IdAndStatusOrderByAppliedAtDesc(u.getId(), VerificationStatus.PENDING)
                .orElse(null);
        }

        if (app == null) {
            redirectAttributes.addFlashAttribute("error", "Job Profile not found.");
            return "redirect:/marketplace";
        }

        java.util.List<in.sp.main.Entities.WorkerBooking> bookings = workerBookingRepo.findByJobApplication_Id(app.getId());
        
        long totalBookings = bookings.size();
        long pendingBookings = bookings.stream().filter(b -> "PENDING".equalsIgnoreCase(b.getStatus())).count();
        long confirmedBookings = bookings.stream().filter(b -> "CONFIRMED".equalsIgnoreCase(b.getStatus()) || "ACCEPTED".equalsIgnoreCase(b.getStatus())).count();
        long completedBookings = bookings.stream().filter(b -> "COMPLETED".equalsIgnoreCase(b.getStatus()) || "PAID".equalsIgnoreCase(b.getStatus())).count();
        long paidBookingsCount = bookings.stream().filter(b -> "PAID".equalsIgnoreCase(b.getStatus())).count();

        double totalEarnings = bookings.stream()
                .filter(b -> "COMPLETED".equalsIgnoreCase(b.getStatus()) || "PAID".equalsIgnoreCase(b.getStatus()))
                .mapToDouble(b -> b.getTotalAmount() != null ? b.getTotalAmount() : 0.0)
                .sum();

        double pendingRevenue = bookings.stream()
                .filter(b -> "PENDING".equalsIgnoreCase(b.getStatus()) || "CONFIRMED".equalsIgnoreCase(b.getStatus()) || "ACCEPTED".equalsIgnoreCase(b.getStatus()))
                .mapToDouble(b -> b.getTotalAmount() != null ? b.getTotalAmount() : 0.0)
                .sum();

        model.addAttribute("workerApp", app);
        model.addAttribute("bookings", bookings);
        model.addAttribute("totalBookings", totalBookings);
        model.addAttribute("pendingBookings", pendingBookings);
        model.addAttribute("confirmedBookings", confirmedBookings);
        model.addAttribute("completedBookings", completedBookings);
        model.addAttribute("paidBookingsCount", paidBookingsCount);
        model.addAttribute("totalEarnings", totalEarnings);
        model.addAttribute("pendingRevenue", pendingRevenue);
        model.addAttribute("isWorkerDashboard", true);

        return "marketplace/worker-earnings";
    }

    @PostMapping("/earnings/update")
    public String updatePayoutInfo(@RequestParam(required=false) Double hourlyRate,
                                    @RequestParam(required=false) String bankDetails,
                                    @RequestParam(required=false) String upiId,
                                    HttpSession session,
                                    RedirectAttributes redirectAttributes) {
        User u = (User) session.getAttribute("user");
        if (u == null) return "redirect:/login";

        in.sp.main.Entities.JobApplication app = jobAppRepo
                .findFirstByUser_IdAndStatusOrderByAppliedAtDesc(u.getId(), VerificationStatus.VERIFIED)
                .orElse(null);
        if (app == null) {
            app = jobAppRepo
                .findFirstByUser_IdAndStatusOrderByAppliedAtDesc(u.getId(), VerificationStatus.PENDING)
                .orElse(null);
        }

        if (app == null) {
            redirectAttributes.addFlashAttribute("error", "Job Profile not found.");
            return "redirect:/marketplace";
        }

        if (hourlyRate != null) app.setHourlyRate(hourlyRate);
        if (bankDetails != null) app.setBankDetails(bankDetails);
        if (upiId != null) app.setUpiId(upiId);

        jobAppRepo.save(app);
        redirectAttributes.addFlashAttribute("success", "Payout details saved successfully!");
        return "redirect:/women-jobs/earnings";
    }
}
