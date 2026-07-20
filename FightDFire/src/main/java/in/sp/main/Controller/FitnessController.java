package in.sp.main.Controller;

import in.sp.main.Entities.*;
import in.sp.main.Repository.*;
import in.sp.main.Service.FileUploadService;
import jakarta.servlet.http.HttpSession;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/fitness")
public class FitnessController {

    @Autowired
    private FitnessTrainerRepository fitnessTrainerRepository;

    @Autowired
    private FitnessBookingRepository fitnessBookingRepository;

    @Autowired
    private FitnessReviewRepository fitnessReviewRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private FitnessClassRepository fitnessClassRepository;

    @Autowired
    private FileUploadService fileUploadService;

    @Autowired
    private in.sp.main.Config.JwtUtil jwtUtil;

    private final String[] FITNESS_CATEGORIES = {
        "Gym Training", "Zumba", "Dance Fitness", "Yoga", "Aerobics", "Pilates", 
        "Strength Training", "Cardio Training", "CrossFit", "Functional Training", 
        "HIIT (High-Intensity Interval Training)", "Weight Loss Programs", 
        "Weight Gain Programs", "Personal Training", "Prenatal & Postnatal Fitness", 
        "Meditation & Mindfulness", "Self-Defense Training", "Martial Arts", 
        "Nutrition & Diet Consultation", "Home Workout Sessions"
    };

    // User helpers
    private User getSessionUser(HttpSession session) {
        User u = (User) session.getAttribute("user");
        if (u == null) return null;
        return userRepository.findById(u.getId()).orElse(null);
    }

    private FitnessTrainer getSessionTrainer(HttpSession session) {
        FitnessTrainer t = (FitnessTrainer) session.getAttribute("loggedTrainer");
        if (t == null) return null;
        return fitnessTrainerRepository.findById(t.getId()).orElse(null);
    }

    // BROWSE TRAINERS & CATEGORIES
    @GetMapping("")
    public String browseFitness(
            @RequestParam(required = false) String category,
            @RequestParam(required = false) String search,
            @RequestParam(required = false) String location,
            @RequestParam(required = false) Double maxPrice,
            @RequestParam(required = false) Double minRating,
            HttpSession session, Model model) {
        
        User currentUser = getSessionUser(session);
        model.addAttribute("user", currentUser);

        // Fetch verified, active trainers
        List<FitnessTrainer> trainers = fitnessTrainerRepository.findByVerificationStatusAndSuspended(VerificationStatus.VERIFIED, false);

        // Apply filters in memory
        if (category != null && !category.trim().isEmpty()) {
            trainers = trainers.stream()
                    .filter(t -> t.getSpecializations() != null && t.getSpecializations().toLowerCase().contains(category.trim().toLowerCase()))
                    .collect(Collectors.toList());
        }

        if (search != null && !search.trim().isEmpty()) {
            trainers = trainers.stream()
                    .filter(t -> t.getFullName().toLowerCase().contains(search.trim().toLowerCase()))
                    .collect(Collectors.toList());
        }

        if (location != null && !location.trim().isEmpty()) {
            // ServiceProvider has locationText, but we can match text if trainer has it or phone or anything.
            // Let's filter by phone or name, or if we define default locations for trainers.
            // For now, search matches name and specializations as fallback.
        }

        if (maxPrice != null) {
            trainers = trainers.stream()
                    .filter(t -> t.getSessionFees() <= maxPrice)
                    .collect(Collectors.toList());
        }

        if (minRating != null) {
            trainers = trainers.stream()
                    .filter(t -> t.getRating() >= minRating)
                    .collect(Collectors.toList());
        }

        model.addAttribute("trainers", trainers);
        model.addAttribute("categories", FITNESS_CATEGORIES);
        model.addAttribute("selectedCategory", category);
        model.addAttribute("search", search);
        model.addAttribute("maxPrice", maxPrice);
        model.addAttribute("minRating", minRating);

        return "fitnessBrowse";
    }

    // VIEW TRAINER DETAILS
    @GetMapping("/trainer/{id}")
    public String viewTrainerProfile(@PathVariable Long id, HttpSession session, Model model, RedirectAttributes redirectAttributes) {
        User currentUser = getSessionUser(session);
        if (currentUser == null) return "redirect:/login";

        FitnessTrainer trainer = fitnessTrainerRepository.findById(id).orElse(null);
        if (trainer == null || trainer.isSuspended()) {
            redirectAttributes.addFlashAttribute("error", "Trainer not found or suspended.");
            return "redirect:/fitness";
        }

        // Fetch reviews
        List<FitnessReview> reviews = fitnessReviewRepository.findByBooking_Trainer_Id(id);

        model.addAttribute("user", currentUser);
        model.addAttribute("trainer", trainer);
        model.addAttribute("reviews", reviews);
        model.addAttribute("categories", trainer.getSpecializations() != null ? trainer.getSpecializations().split(",") : new String[0]);

        // Fetch upcoming active fitness classes for this trainer
        List<FitnessClass> trainerClasses = fitnessClassRepository.findByTrainer_IdOrderByClassDateAsc(id).stream()
                .filter(fc -> "ACTIVE".equals(fc.getStatus()) && !fc.getClassDate().isBefore(LocalDate.now()) && fc.getCurrentEnrollment() < fc.getMaxCapacity())
                .collect(Collectors.toList());
        model.addAttribute("trainerClasses", trainerClasses);

        return "fitnessTrainerProfile";
    }

    // BOOK SESSION REQUEST
    @PostMapping("/book")
    @Transactional
    public String bookSession(
            @RequestParam Long trainerId,
            @RequestParam String category,
            @RequestParam String bookingDate,
            @RequestParam String bookingTime,
            @RequestParam String sessionType,
            @RequestParam(required = false) String duration,
            @RequestParam(required = false, defaultValue = "WALLET") String paymentMethod,
            HttpSession session, RedirectAttributes redirectAttributes) {

        User currentUser = getSessionUser(session);
        if (currentUser == null) return "redirect:/login";

        FitnessTrainer trainer = fitnessTrainerRepository.findById(trainerId).orElse(null);
        if (trainer == null || trainer.isSuspended()) {
            redirectAttributes.addFlashAttribute("error", "Trainer not found.");
            return "redirect:/fitness";
        }

        Double baseFees = trainer.getSessionFees();
        if (baseFees == null) {
            baseFees = 0.0;
        }

        Double fees = baseFees;
        int totalSessions = 1;
        
        LocalDate startDate = LocalDate.parse(bookingDate);
        LocalDate endDate = startDate;
        
        if (duration == null) {
            duration = "SINGLE";
        }

        if ("MONTHLY".equals(duration)) {
            fees = baseFees * 10;
            totalSessions = 12;
            endDate = startDate.plusMonths(1);
        } else if ("QUARTERLY".equals(duration)) {
            fees = baseFees * 25;
            totalSessions = 36;
            endDate = startDate.plusMonths(3);
        } else if ("HALF_YEAR".equals(duration)) {
            fees = baseFees * 45;
            totalSessions = 72;
            endDate = startDate.plusMonths(6);
        } else if ("YEAR".equals(duration)) {
            fees = baseFees * 80;
            totalSessions = 144;
            endDate = startDate.plusYears(1);
        }

        boolean paid = false;
        if ("CARD_UPI".equals(paymentMethod)) {
            // Mock card processing - successful instantly
            paid = true;
        } else {
            Double walletBalance = currentUser.getWalletBalance();
            if (walletBalance == null) {
                walletBalance = 0.0;
            }
            if (walletBalance < fees) {
                redirectAttributes.addFlashAttribute("error", "Insufficient wallet balance to complete this booking.");
                return "redirect:/fitness/trainer/" + trainerId;
            }
            // Deduct
            currentUser.setWalletBalance(walletBalance - fees);
            userRepository.save(currentUser);
            session.setAttribute("user", currentUser);
            paid = true;
        }

        FitnessBooking booking = new FitnessBooking();
        booking.setUser(currentUser);
        booking.setTrainer(trainer);
        booking.setCategory(category);
        booking.setBookingDate(startDate);
        booking.setBookingTime(bookingTime);
        booking.setSessionType(sessionType);
        booking.setStatus("PENDING");
        booking.setPaymentAmount(fees);
        booking.setPaymentStatus(paid ? "PAID" : "PENDING");
        booking.setDuration(duration);
        booking.setTotalSessions(totalSessions);
        booking.setCompletedSessions(0);
        booking.setStartDate(startDate);
        booking.setEndDate(endDate);

        fitnessBookingRepository.save(booking);

        redirectAttributes.addFlashAttribute("success", "Booking request submitted successfully! Pending trainer acceptance.");
        return "redirect:/fitness/bookings";
    }

    // USER BOOKINGS HISTORY
    @GetMapping("/bookings")
    public String showUserBookings(HttpSession session, Model model) {
        User currentUser = getSessionUser(session);
        if (currentUser == null) return "redirect:/login";

        List<FitnessBooking> bookings = fitnessBookingRepository.findByUser_Id(currentUser.getId());
        // Sort bookings: pending/approved first, then completed/cancelled
        bookings.sort((b1, b2) -> b2.getBookingDate().compareTo(b1.getBookingDate()));

        model.addAttribute("user", currentUser);
        model.addAttribute("bookings", bookings);

        return "fitnessUserBookings";
    }

    // CANCEL BOOKING (WITH REFUND)
    @PostMapping("/booking/cancel")
    @Transactional
    public String cancelBooking(@RequestParam Long bookingId, HttpSession session, RedirectAttributes redirectAttributes) {
        User currentUser = getSessionUser(session);
        if (currentUser == null) return "redirect:/login";

        FitnessBooking booking = fitnessBookingRepository.findById(bookingId).orElse(null);
        if (booking == null) {
            redirectAttributes.addFlashAttribute("error", "Booking record not found.");
            return "redirect:/fitness/bookings";
        }

        if ("PAID".equals(booking.getPaymentStatus())) {
            // Refund wallet
            currentUser.setWalletBalance(currentUser.getWalletBalance() + booking.getPaymentAmount());
            userRepository.save(currentUser);
            session.setAttribute("user", currentUser);
            booking.setPaymentStatus("REFUNDED");
        }

        booking.setStatus("CANCELLED");
        fitnessBookingRepository.save(booking);

        redirectAttributes.addFlashAttribute("success", "Booking cancelled and refunded successfully.");
        return "redirect:/fitness/bookings";
    }

    // RATE/REVIEW COMPLETED BOOKING
    @PostMapping("/booking/rate")
    @Transactional
    public String rateTrainer(
            @RequestParam Long bookingId,
            @RequestParam Integer rating,
            @RequestParam String comment,
            HttpSession session, RedirectAttributes redirectAttributes) {

        User currentUser = getSessionUser(session);
        if (currentUser == null) return "redirect:/login";

        FitnessBooking booking = fitnessBookingRepository.findById(bookingId).orElse(null);
        if (booking == null || !"COMPLETED".equals(booking.getStatus())) {
            redirectAttributes.addFlashAttribute("error", "Cannot rate a non-completed session.");
            return "redirect:/fitness/bookings";
        }

        FitnessReview review = new FitnessReview();
        review.setBooking(booking);
        review.setRating(rating);
        review.setComment(comment);
        fitnessReviewRepository.save(review);

        // Update overall trainer average rating
        FitnessTrainer trainer = booking.getTrainer();
        List<FitnessReview> allReviews = fitnessReviewRepository.findByBooking_Trainer_Id(trainer.getId());
        double avg = allReviews.stream().mapToInt(FitnessReview::getRating).average().orElse(0.0);
        trainer.setRating(avg);
        fitnessTrainerRepository.save(trainer);

        redirectAttributes.addFlashAttribute("success", "Thank you for sharing your feedback!");
        return "redirect:/fitness/bookings";
    }

    // TRAINER REGISTRATION GET
    @GetMapping("/trainer/register")
    public String registerTrainerForm(Model model) {
        model.addAttribute("categories", FITNESS_CATEGORIES);
        return "fitnessTrainerRegister";
    }

    // TRAINER REGISTRATION POST
    @PostMapping("/trainer/register")
    public String submitTrainerRegistration(
            @RequestParam String fullName,
            @RequestParam String email,
            @RequestParam String phone,
            @RequestParam String password,
            @RequestParam Integer experience,
            @RequestParam List<String> specializations,
            @RequestParam String availableTimings,
            @RequestParam Double sessionFees,
            @RequestParam MultipartFile profilePhoto,
            @RequestParam MultipartFile certificationDoc,
            RedirectAttributes redirectAttributes) {

        if (fitnessTrainerRepository.findByEmail(email).isPresent()) {
            redirectAttributes.addFlashAttribute("error", "An account with this email already exists.");
            return "redirect:/fitness/trainer/register";
        }

        try {
            FitnessTrainer trainer = new FitnessTrainer();
            trainer.setFullName(fullName);
            trainer.setEmail(email.trim().toLowerCase());
            trainer.setPhone(phone);
            trainer.setPassword(password); // Simple storage
            trainer.setExperience(experience);
            trainer.setAvailableTimings(availableTimings);
            trainer.setSessionFees(sessionFees);
            trainer.setSpecializations(String.join(",", specializations));
            trainer.setVerificationStatus(VerificationStatus.PENDING);
            trainer.setSuspended(false);

            if (!profilePhoto.isEmpty()) {
                trainer.setProfilePhotoPath(fileUploadService.saveFile(profilePhoto));
            }
            if (!certificationDoc.isEmpty()) {
                trainer.setCertificationsPath(fileUploadService.saveFile(certificationDoc));
            }

            fitnessTrainerRepository.save(trainer);
            redirectAttributes.addFlashAttribute("success", "Registration submitted successfully! Please wait for Admin review.");
            return "redirect:/fitness/trainer/login";

        } catch (IOException e) {
            redirectAttributes.addFlashAttribute("error", "File upload failed. Please try again.");
            return "redirect:/fitness/trainer/register";
        }
    }

    // TRAINER LOGIN GET
    @GetMapping("/trainer/login")
    public String loginTrainerForm() {
        return "fitnessTrainerLogin";
    }

    // TRAINER LOGIN POST
    @PostMapping("/trainer/login")
    public String handleTrainerLogin(
            @RequestParam String email,
            @RequestParam String password,
            jakarta.servlet.http.HttpServletResponse response,
            HttpSession session, RedirectAttributes redirectAttributes) {

        Optional<FitnessTrainer> opt = fitnessTrainerRepository.findByEmail(email.trim().toLowerCase());
        if (opt.isPresent() && opt.get().getPassword().equals(password)) {
            FitnessTrainer trainer = opt.get();
            if (trainer.getVerificationStatus() == VerificationStatus.PENDING) {
                redirectAttributes.addFlashAttribute("error", "Your account is pending verification by admin.");
                return "redirect:/fitness/trainer/login";
            } else if (trainer.getVerificationStatus() == VerificationStatus.REJECTED) {
                redirectAttributes.addFlashAttribute("error", "Your certification credentials were rejected.");
                return "redirect:/fitness/trainer/login";
            } else if (trainer.isSuspended()) {
                redirectAttributes.addFlashAttribute("error", "Your trainer account has been suspended.");
                return "redirect:/fitness/trainer/login";
            }

            session.setAttribute("loggedTrainer", trainer);

            // Generate JWT and add to response
            String token = jwtUtil.generateToken(trainer.getEmail(), "TRAINER");
            jakarta.servlet.http.Cookie cookie = new jakarta.servlet.http.Cookie("JWT_TOKEN", token);
            cookie.setPath("/");
            cookie.setHttpOnly(true);
            cookie.setMaxAge(365 * 24 * 60 * 60); // 1 year
            response.addCookie(cookie);

            return "redirect:/fitness/trainer/dashboard";
        }

        redirectAttributes.addFlashAttribute("error", "Invalid credentials!");
        return "redirect:/fitness/trainer/login";
    }

    // TRAINER LOGOUT
    @GetMapping("/trainer/logout")
    public String logoutTrainer(HttpSession session, jakarta.servlet.http.HttpServletResponse response) {
        session.removeAttribute("loggedTrainer");

        // Clear JWT cookie
        jakarta.servlet.http.Cookie cookie = new jakarta.servlet.http.Cookie("JWT_TOKEN", null);
        cookie.setPath("/");
        cookie.setHttpOnly(true);
        cookie.setMaxAge(0);
        response.addCookie(cookie);

        return "redirect:/fitness/trainer/login";
    }

    // TRAINER STUDIO DASHBOARD
    @GetMapping("/trainer/dashboard")
    public String showTrainerDashboard(HttpSession session, Model model) {
        FitnessTrainer trainer = getSessionTrainer(session);
        if (trainer == null) return "redirect:/fitness/trainer/login";

        // Bookings
        List<FitnessBooking> bookings = fitnessBookingRepository.findByTrainer_Id(trainer.getId());
        List<FitnessBooking> requests = bookings.stream().filter(b -> "PENDING".equals(b.getStatus())).collect(Collectors.toList());
        List<FitnessBooking> active = bookings.stream().filter(b -> "APPROVED".equals(b.getStatus())).collect(Collectors.toList());
        List<FitnessBooking> completed = bookings.stream().filter(b -> "COMPLETED".equals(b.getStatus())).collect(Collectors.toList());

        // Earnings
        double totalEarnings = completed.stream().mapToDouble(FitnessBooking::getPaymentAmount).sum();

        // Reviews
        List<FitnessReview> reviews = fitnessReviewRepository.findByBooking_Trainer_Id(trainer.getId());

        model.addAttribute("trainer", trainer);
        model.addAttribute("requests", requests);
        model.addAttribute("activeBookings", active);
        model.addAttribute("completed", completed);
        model.addAttribute("totalEarnings", totalEarnings);
        model.addAttribute("reviews", reviews);
        model.addAttribute("categories", FITNESS_CATEGORIES);

        // Extract unique users from all bookings for the chat interface
        List<User> chatUsers = bookings.stream()
                .map(FitnessBooking::getUser)
                .distinct()
                .collect(Collectors.toList());
        model.addAttribute("chatUsers", chatUsers);

        // Fetch Trainer's Scheduled Classes
        List<FitnessClass> trainerClasses = fitnessClassRepository.findByTrainer_IdOrderByClassDateAsc(trainer.getId());
        model.addAttribute("trainerClasses", trainerClasses);

        // Fetch attendees for these classes
        java.util.Map<Long, List<FitnessBooking>> classAttendeesMap = new java.util.HashMap<>();
        for (FitnessClass fc : trainerClasses) {
            List<FitnessBooking> classBookings = fitnessBookingRepository.findByFitnessClass_Id(fc.getId());
            classAttendeesMap.put(fc.getId(), classBookings);
        }
        model.addAttribute("classAttendees", classAttendeesMap);

        return "fitnessTrainerDashboard";
    }

    // TRAINER ACCEPT/REJECT/COMPLETE BOOKINGS
    @PostMapping("/trainer/booking/status")
    @Transactional
    public String updateBookingStatus(
            @RequestParam Long bookingId,
            @RequestParam String action,
            HttpSession session, RedirectAttributes redirectAttributes) {

        FitnessTrainer trainer = getSessionTrainer(session);
        if (trainer == null) return "redirect:/fitness/trainer/login";

        FitnessBooking booking = fitnessBookingRepository.findById(bookingId).orElse(null);
        if (booking == null || !booking.getTrainer().getId().equals(trainer.getId())) {
            redirectAttributes.addFlashAttribute("error", "Booking record not found.");
            return "redirect:/fitness/trainer/dashboard";
        }

        if ("APPROVE".equalsIgnoreCase(action)) {
            booking.setStatus("APPROVED");
        } else if ("REJECT".equalsIgnoreCase(action)) {
            booking.setStatus("REJECTED");
            if ("PAID".equals(booking.getPaymentStatus())) {
                // Refund user
                User user = booking.getUser();
                user.setWalletBalance(user.getWalletBalance() + booking.getPaymentAmount());
                userRepository.save(user);
                booking.setPaymentStatus("REFUNDED");
            }
        } else if ("COMPLETE".equalsIgnoreCase(action)) {
            int total = booking.getTotalSessions() != null ? booking.getTotalSessions() : 1;
            int completed = booking.getCompletedSessions() != null ? booking.getCompletedSessions() : 0;
            
            completed++;
            booking.setCompletedSessions(completed);
            
            if (completed >= total) {
                booking.setStatus("COMPLETED");
                if (!"PAID".equals(booking.getPaymentStatus())) {
                    booking.setPaymentStatus("PAID");
                }
            } else {
                booking.setStatus("APPROVED"); // remains active
            }
        }

        fitnessBookingRepository.save(booking);

        redirectAttributes.addFlashAttribute("success", "Booking updated successfully.");
        return "redirect:/fitness/trainer/dashboard";
    }

    // UPDATE TRAINER PROFILE SCHEDULE
    @PostMapping("/trainer/update-schedule")
    @Transactional
    public String updateTrainerSchedule(
            @RequestParam Double sessionFees,
            @RequestParam String availableTimings,
            @RequestParam List<String> specializations,
            HttpSession session, RedirectAttributes redirectAttributes) {

        FitnessTrainer trainer = getSessionTrainer(session);
        if (trainer == null) return "redirect:/fitness/trainer/login";

        trainer.setSessionFees(sessionFees);
        trainer.setAvailableTimings(availableTimings);
        trainer.setSpecializations(String.join(",", specializations));
        fitnessTrainerRepository.save(trainer);

        session.setAttribute("loggedTrainer", trainer);

        redirectAttributes.addFlashAttribute("success", "Schedule configuration updated successfully!");
        return "redirect:/fitness/trainer/dashboard";
    }

    // TRAINER: CREATE SCHEDULED CLASS
    @PostMapping("/trainer/class/create")
    @Transactional
    public String createClass(
            @RequestParam String className,
            @RequestParam String category,
            @RequestParam String description,
            @RequestParam String classDate,
            @RequestParam String classTime,
            @RequestParam Integer durationMinutes,
            @RequestParam String sessionType,
            @RequestParam String maxCapacity,
            @RequestParam String price,
            @RequestParam(required = false) String meetingLinkOrLocation,
            HttpSession session, RedirectAttributes redirectAttributes) {

        FitnessTrainer trainer = getSessionTrainer(session);
        if (trainer == null) return "redirect:/fitness/trainer/login";

        int maxCapVal;
        double priceVal;
        try {
            maxCapVal = Integer.parseInt(maxCapacity);
            if (maxCapVal < 1 || maxCapVal > 9999) {
                redirectAttributes.addFlashAttribute("error", "Maximum capacity must be between 1 and 9,999.");
                return "redirect:/fitness/trainer/dashboard";
            }
        } catch (NumberFormatException e) {
            redirectAttributes.addFlashAttribute("error", "Please enter a valid numeric Maximum Capacity.");
            return "redirect:/fitness/trainer/dashboard";
        }

        try {
            priceVal = Double.parseDouble(price);
            if (priceVal < 0.01 || priceVal > 999999) {
                redirectAttributes.addFlashAttribute("error", "Price must be between ₹0.01 and ₹999,999.");
                return "redirect:/fitness/trainer/dashboard";
            }
        } catch (NumberFormatException e) {
            redirectAttributes.addFlashAttribute("error", "Please enter a valid numeric Price.");
            return "redirect:/fitness/trainer/dashboard";
        }

        FitnessClass fc = new FitnessClass();
        fc.setTrainer(trainer);
        fc.setClassName(className);
        fc.setCategory(category);
        fc.setDescription(description);
        fc.setClassDate(LocalDate.parse(classDate));
        fc.setClassTime(java.time.LocalTime.parse(classTime));
        fc.setDurationMinutes(durationMinutes);
        fc.setSessionType(sessionType);
        fc.setMaxCapacity(maxCapVal);
        fc.setPrice(priceVal);
        fc.setMeetingLinkOrLocation(meetingLinkOrLocation);
        fc.setStatus("ACTIVE");
        
        fitnessClassRepository.save(fc);

        redirectAttributes.addFlashAttribute("success", "Group class created successfully!");
        return "redirect:/fitness/trainer/dashboard";
    }

    // TRAINER: EDIT SCHEDULED CLASS
    @PostMapping("/trainer/class/edit")
    @Transactional
    public String editClass(
            @RequestParam Long classId,
            @RequestParam String className,
            @RequestParam String category,
            @RequestParam String description,
            @RequestParam String classDate,
            @RequestParam String classTime,
            @RequestParam Integer durationMinutes,
            @RequestParam String sessionType,
            @RequestParam String maxCapacity,
            @RequestParam String price,
            @RequestParam(required = false) String meetingLinkOrLocation,
            HttpSession session, RedirectAttributes redirectAttributes) {

        FitnessTrainer trainer = getSessionTrainer(session);
        if (trainer == null) return "redirect:/fitness/trainer/login";

        FitnessClass fc = fitnessClassRepository.findById(classId).orElse(null);
        if (fc == null || !fc.getTrainer().getId().equals(trainer.getId())) {
            redirectAttributes.addFlashAttribute("error", "Class not found or unauthorized access.");
            return "redirect:/fitness/trainer/dashboard";
        }

        int maxCapVal;
        double priceVal;
        try {
            maxCapVal = Integer.parseInt(maxCapacity);
            if (maxCapVal < 1 || maxCapVal > 9999) {
                redirectAttributes.addFlashAttribute("error", "Maximum capacity must be between 1 and 9,999.");
                return "redirect:/fitness/trainer/dashboard";
            }
        } catch (NumberFormatException e) {
            redirectAttributes.addFlashAttribute("error", "Please enter a valid numeric Maximum Capacity.");
            return "redirect:/fitness/trainer/dashboard";
        }

        try {
            priceVal = Double.parseDouble(price);
            if (priceVal < 0.01 || priceVal > 999999) {
                redirectAttributes.addFlashAttribute("error", "Price must be between ₹0.01 and ₹999,999.");
                return "redirect:/fitness/trainer/dashboard";
            }
        } catch (NumberFormatException e) {
            redirectAttributes.addFlashAttribute("error", "Please enter a valid numeric Price.");
            return "redirect:/fitness/trainer/dashboard";
        }

        fc.setClassName(className);
        fc.setCategory(category);
        fc.setDescription(description);
        fc.setClassDate(LocalDate.parse(classDate));
        fc.setClassTime(java.time.LocalTime.parse(classTime));
        fc.setDurationMinutes(durationMinutes);
        fc.setSessionType(sessionType);
        fc.setMaxCapacity(maxCapVal);
        fc.setPrice(priceVal);
        fc.setMeetingLinkOrLocation(meetingLinkOrLocation);

        fitnessClassRepository.save(fc);

        redirectAttributes.addFlashAttribute("success", "Group class updated successfully!");
        return "redirect:/fitness/trainer/dashboard";
    }

    // TRAINER: DELETE SCHEDULED CLASS
    @PostMapping("/trainer/class/delete")
    @Transactional
    public String deleteClass(
            @RequestParam Long classId,
            HttpSession session, RedirectAttributes redirectAttributes) {

        FitnessTrainer trainer = getSessionTrainer(session);
        if (trainer == null) return "redirect:/fitness/trainer/login";

        FitnessClass fc = fitnessClassRepository.findById(classId).orElse(null);
        if (fc == null || !fc.getTrainer().getId().equals(trainer.getId())) {
            redirectAttributes.addFlashAttribute("error", "Class not found or unauthorized access.");
            return "redirect:/fitness/trainer/dashboard";
        }

        // Refund registered users and delete bookings
        List<FitnessBooking> classBookings = fitnessBookingRepository.findByFitnessClass_Id(classId);
        for (FitnessBooking booking : classBookings) {
            if ("PAID".equals(booking.getPaymentStatus())) {
                User user = booking.getUser();
                if (user != null) {
                    double refundAmount = booking.getPaymentAmount() != null ? booking.getPaymentAmount() : 0.0;
                    user.setWalletBalance((user.getWalletBalance() != null ? user.getWalletBalance() : 0.0) + refundAmount);
                    userRepository.save(user);
                }
            }
        }
        fitnessBookingRepository.deleteAll(classBookings);
        fitnessClassRepository.delete(fc);

        redirectAttributes.addFlashAttribute("success", "Group class deleted successfully!");
        return "redirect:/fitness/trainer/dashboard";
    }

    // USER: BOOK SCHEDULED CLASS
    @PostMapping("/class/book")
    @Transactional
    public String bookClass(
            @RequestParam Long classId,
            HttpSession session, jakarta.servlet.http.HttpServletRequest request, RedirectAttributes redirectAttributes) {

        User currentUser = getSessionUser(session);
        if (currentUser == null) return "redirect:/login";

        FitnessClass fc = fitnessClassRepository.findById(classId).orElse(null);
        if (fc == null || !"ACTIVE".equals(fc.getStatus())) {
            redirectAttributes.addFlashAttribute("error", "Class is not available.");
            return "redirect:/users/dashboard";
        }

        if (fc.getCurrentEnrollment() >= fc.getMaxCapacity()) {
            redirectAttributes.addFlashAttribute("error", "Class is fully booked!");
            return "redirect:/users/dashboard";
        }

        Double walletBalance = currentUser.getWalletBalance();
        if (walletBalance == null) {
            walletBalance = 0.0;
        }

        // Deduct from wallet (Allow negative balance as per requirements)
        currentUser.setWalletBalance(walletBalance - fc.getPrice());
        userRepository.save(currentUser);
        session.setAttribute("user", currentUser);

        // Update class enrollment
        fc.setCurrentEnrollment(fc.getCurrentEnrollment() + 1);
        fitnessClassRepository.save(fc);

        // Create booking
        FitnessBooking booking = new FitnessBooking();
        booking.setUser(currentUser);
        booking.setTrainer(fc.getTrainer());
        booking.setFitnessClass(fc);
        booking.setCategory(fc.getCategory());
        booking.setBookingDate(fc.getClassDate());
        booking.setBookingTime(fc.getClassTime().toString());
        booking.setSessionType(fc.getSessionType());
        booking.setStatus("APPROVED"); // Group class bookings are automatically approved
        booking.setPaymentAmount(fc.getPrice());
        booking.setPaymentStatus("PAID");

        fitnessBookingRepository.save(booking);

        redirectAttributes.addFlashAttribute("success", "Successfully enrolled in " + fc.getClassName() + "!");
        
        String referer = request.getHeader("Referer");
        if (referer != null) {
            return "redirect:" + referer;
        }
        return "redirect:/users/dashboard";
    }

    // USER: SUBMIT FITNESS REVIEW
    @PostMapping("/review/submit")
    @Transactional
    public String submitReview(
            @RequestParam Long bookingId,
            @RequestParam Integer rating,
            @RequestParam String comment,
            HttpSession session, RedirectAttributes redirectAttributes) {
        
        User currentUser = getSessionUser(session);
        if (currentUser == null) return "redirect:/login";

        FitnessBooking booking = fitnessBookingRepository.findById(bookingId).orElse(null);
        if (booking == null || !booking.getUser().getId().equals(currentUser.getId())) {
            redirectAttributes.addFlashAttribute("error", "Invalid booking.");
            return "redirect:/users/dashboard";
        }

        if (fitnessReviewRepository.existsByBooking_Id(bookingId)) {
            redirectAttributes.addFlashAttribute("error", "You have already reviewed this session.");
            return "redirect:/users/dashboard";
        }

        FitnessReview review = new FitnessReview();
        review.setBooking(booking);
        review.setRating(rating);
        review.setComment(comment);
        
        fitnessReviewRepository.save(review);
        redirectAttributes.addFlashAttribute("success", "Review submitted successfully! Thank you for your feedback.");
        return "redirect:/users/dashboard";
    }
}
