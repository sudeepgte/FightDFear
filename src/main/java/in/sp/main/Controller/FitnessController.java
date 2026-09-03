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
import org.springframework.web.server.ResponseStatusException;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
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
    private in.sp.main.Service.PasswordService passwordService;

    @Autowired
    private in.sp.main.Config.JwtUtil jwtUtil;

    @Autowired
    private in.sp.main.Service.FitnessTrainerProfileService trainerProfileService;

    @Autowired
    private in.sp.main.Service.FitnessTrainerRegistrationService trainerRegistrationService;

    @Autowired
    private in.sp.main.Service.FitnessService fitnessService;

    @Autowired
    private in.sp.main.Repository.FitnessPackageRepository fitnessPackageRepository;

    @Autowired
    private in.sp.main.Repository.FitnessAttendanceRepository fitnessAttendanceRepository;

    @Autowired
    private in.sp.main.Repository.FitnessProgressLogRepository fitnessProgressLogRepository;

    @Autowired
    private in.sp.main.Service.FitnessQrAttendanceService fitnessQrAttendanceService;



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
    @GetMapping({"", "/browse"})
    public String browseFitness(
            @RequestParam(required = false) String category,
            @RequestParam(required = false) String search,
            @RequestParam(required = false) String query,
            @RequestParam(required = false) String city,
            @RequestParam(required = false) String location,
            @RequestParam(required = false) Double maxPrice,
            @RequestParam(required = false) Double minRating,
            HttpSession session, Model model) {

        User currentUser = getSessionUser(session);
        model.addAttribute("user", currentUser);

        // Fetch verified, active trainers
        List<FitnessTrainer> trainers = fitnessTrainerRepository.findByVerificationStatusAndSuspended(VerificationStatus.VERIFIED, false);

        String searchTerm = (search != null && !search.isBlank()) ? search.trim() : (query != null && !query.isBlank() ? query.trim() : null);

        // Apply filters in memory
        if (category != null && !category.trim().isEmpty() && !"all".equalsIgnoreCase(category.trim())) {
            trainers = trainers.stream()
                    .filter(t -> t.getSpecializations() != null && t.getSpecializations().toLowerCase().contains(category.trim().toLowerCase()))
                    .collect(Collectors.toList());
        }

        if (searchTerm != null && !searchTerm.isEmpty()) {
            String q = searchTerm.toLowerCase();
            trainers = trainers.stream()
                    .filter(t -> (t.getFullName() != null && t.getFullName().toLowerCase().contains(q))
                            || (t.getSpecializations() != null && t.getSpecializations().toLowerCase().contains(q))
                            || (t.getCity() != null && t.getCity().toLowerCase().contains(q)))
                    .collect(Collectors.toList());
        }

        if (city != null && !city.trim().isEmpty()) {
            trainers = trainers.stream()
                    .filter(t -> t.getCity() != null && t.getCity().equalsIgnoreCase(city.trim()))
                    .collect(Collectors.toList());
        }

        if (maxPrice != null) {
            trainers = trainers.stream()
                    .filter(t -> t.getSessionFees() != null && t.getSessionFees() <= maxPrice)
                    .collect(Collectors.toList());
        }

        if (minRating != null) {
            trainers = trainers.stream()
                    .filter(t -> t.getRating() >= minRating)
                    .collect(Collectors.toList());
        }

        List<FitnessClass> activeClasses = fitnessClassRepository.findAll().stream()
                .filter(c -> "ACTIVE".equals(c.getStatus()) && c.getClassDate() != null && !c.getClassDate().isBefore(LocalDate.now()))
                .collect(Collectors.toList());

        List<FitnessPackage> activePackages = fitnessPackageRepository.findByActiveTrue();

        model.addAttribute("trainers", trainers);
        model.addAttribute("classes", activeClasses);
        model.addAttribute("packages", activePackages);
        model.addAttribute("categories", in.sp.main.Util.FitnessCategories.ALL != null ? in.sp.main.Util.FitnessCategories.ALL : FITNESS_CATEGORIES);
        model.addAttribute("selectedCategory", category);
        model.addAttribute("selectedCity", city);
        model.addAttribute("search", searchTerm);
        model.addAttribute("query", searchTerm);
        model.addAttribute("maxPrice", maxPrice);
        model.addAttribute("minRating", minRating);

        return "fitnessBrowse";
    }

    // VIEW TRAINER DETAILS
    @GetMapping("/trainer/{id}")
    public String viewTrainerProfile(
            @PathVariable Long id,
            HttpSession session,
            Model model,
            RedirectAttributes redirectAttributes) {

        FitnessTrainer trainer = fitnessTrainerRepository.findById(id).orElse(null);
        if (trainer == null || trainer.isSuspended()) {
            if (redirectAttributes != null) {
                redirectAttributes.addFlashAttribute("error", "Trainer not found or suspended.");
            }
            return "redirect:/fitness";
        }

        User currentUser = getSessionUser(session);
        if (currentUser != null) {
            model.addAttribute("user", currentUser);
        }

        // Fetch active membership packages for this trainer
        List<FitnessPackage> packages = fitnessPackageRepository.findByTrainer_IdAndActiveTrue(id);

        // Fetch upcoming active group classes for this trainer
        List<FitnessClass> trainerClasses = fitnessClassRepository.findByTrainer_IdOrderByClassDateAsc(id).stream()
                .filter(fc -> "ACTIVE".equals(fc.getStatus()) && fc.getClassDate() != null && !fc.getClassDate().isBefore(LocalDate.now()) && fc.getCurrentEnrollment() < fc.getMaxCapacity())
                .collect(Collectors.toList());

        // Fetch reviews
        List<FitnessReview> reviews = fitnessReviewRepository.findByBooking_Trainer_Id(id);

        model.addAttribute("trainer", trainer);
        model.addAttribute("packages", packages);
        model.addAttribute("classes", trainerClasses);
        model.addAttribute("trainerClasses", trainerClasses);
        model.addAttribute("reviews", reviews);
        model.addAttribute("categories", trainer.getSpecializations() != null ? trainer.getSpecializations().split(",") : new String[0]);

        return "fitnessTrainerProfile";
    }

    // GET AVAILABLE SLOTS FOR A TRAINER ON A GIVEN DATE
    @GetMapping("/api/trainer/{id}/available-slots")
    @ResponseBody
    public org.springframework.http.ResponseEntity<?> getTrainerAvailableSlots(
            @PathVariable Long id,
            @RequestParam String date) {
        try {
            FitnessTrainer trainer = fitnessTrainerRepository.findById(id).orElse(null);
            if (trainer == null || trainer.isSuspended()) {
                return org.springframework.http.ResponseEntity.badRequest()
                        .body(Map.of("success", false, "message", "Trainer not found or inactive"));
            }

            LocalDate targetDate = LocalDate.parse(date);
            if (targetDate.isBefore(LocalDate.now())) {
                return org.springframework.http.ResponseEntity.ok(Map.of(
                        "success", true,
                        "trainerId", id,
                        "date", date,
                        "slots", List.of(),
                        "message", "Cannot select past dates"
                ));
            }

            List<String> defaultSlots = List.of(
                    "06:00 AM - 07:00 AM",
                    "07:00 AM - 08:00 AM",
                    "08:00 AM - 09:00 AM",
                    "09:00 AM - 10:00 AM",
                    "10:00 AM - 11:00 AM",
                    "11:00 AM - 12:00 PM",
                    "04:00 PM - 05:00 PM",
                    "05:00 PM - 06:00 PM",
                    "06:00 PM - 07:00 PM",
                    "07:00 PM - 08:00 PM",
                    "08:00 PM - 09:00 PM"
            );

            List<FitnessBooking> bookedList = fitnessBookingRepository.findByTrainer_IdAndBookingDate(id, targetDate);
            Set<String> bookedTimes = bookedList.stream()
                    .filter(b -> !"CANCELLED".equalsIgnoreCase(b.getStatus()) && !"REJECTED".equalsIgnoreCase(b.getStatus()))
                    .map(b -> b.getBookingTime() != null ? b.getBookingTime().trim() : "")
                    .collect(Collectors.toSet());

            List<Map<String, Object>> resultSlots = new ArrayList<>();
            LocalTime nowTime = LocalTime.now();
            boolean isToday = targetDate.equals(LocalDate.now());

            for (String slot : defaultSlots) {
                boolean isBooked = bookedTimes.contains(slot);
                boolean isPast = false;
                if (isToday) {
                    try {
                        String startTimeStr = slot.split(" - ")[0].trim();
                        java.time.format.DateTimeFormatter dtf = java.time.format.DateTimeFormatter.ofPattern("hh:mm a", java.util.Locale.ENGLISH);
                        LocalTime slotStart = LocalTime.parse(startTimeStr, dtf);
                        if (slotStart.isBefore(nowTime)) {
                            isPast = true;
                        }
                    } catch (Exception ignored) {}
                }

                boolean available = !isBooked && !isPast;
                Map<String, Object> item = new LinkedHashMap<>();
                item.put("time", slot);
                item.put("available", available);
                item.put("reason", isBooked ? "Booked" : (isPast ? "Time Passed" : "Available"));
                resultSlots.add(item);
            }

            return org.springframework.http.ResponseEntity.ok(Map.of(
                    "success", true,
                    "trainerId", id,
                    "date", date,
                    "slots", resultSlots
            ));
        } catch (Exception e) {
            return org.springframework.http.ResponseEntity.badRequest()
                    .body(Map.of("success", false, "message", "Invalid date format or request: " + e.getMessage()));
        }
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

        if (bookingTime == null || bookingTime.trim().isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "Please select an available timing slot.");
            return "redirect:/fitness/trainer/" + trainerId;
        }

        LocalDate startDate = LocalDate.parse(bookingDate);
        if (startDate.isBefore(LocalDate.now())) {
            redirectAttributes.addFlashAttribute("error", "Booking date cannot be in the past.");
            return "redirect:/fitness/trainer/" + trainerId;
        }

        boolean alreadyBooked = fitnessBookingRepository.findByTrainer_IdAndBookingDate(trainer.getId(), startDate)
                .stream()
                .anyMatch(b -> !"CANCELLED".equalsIgnoreCase(b.getStatus()) 
                            && !"REJECTED".equalsIgnoreCase(b.getStatus()) 
                            && bookingTime.trim().equalsIgnoreCase(b.getBookingTime() != null ? b.getBookingTime().trim() : ""));
        if (alreadyBooked) {
            redirectAttributes.addFlashAttribute("error", "The timing slot " + bookingTime + " is already booked for " + startDate + ". Please select another slot.");
            return "redirect:/fitness/trainer/" + trainerId;
        }

        Double baseFees = trainer.getSessionFees();
        if (baseFees == null) {
            baseFees = 0.0;
        }

        Double fees = baseFees;
        int totalSessions = 1;
        
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
        if (booking.getUser() == null || !booking.getUser().getId().equals(currentUser.getId())) {
            redirectAttributes.addFlashAttribute("error", "Access denied.");
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

    @PostMapping("/trainer/register")
    public String submitTrainerRegistration(
            @RequestParam String fullName,
            @RequestParam String email,
            @RequestParam String phone,
            @RequestParam String password,
            @RequestParam(required = false) Integer experience,
            @RequestParam(required = false) String bio,
            @RequestParam(required = false) List<String> specializations,
            @RequestParam(required = false) String availableTimings,
            @RequestParam(required = false) Double sessionFees,
            @RequestParam(required = false) MultipartFile profilePhoto,
            @RequestParam(required = false) MultipartFile certificationDoc,
            RedirectAttributes redirectAttributes) {

        if (fitnessTrainerRepository.findByEmail(email.trim().toLowerCase()).isPresent()) {
            redirectAttributes.addFlashAttribute("error", "An account with this email already exists. Please sign in.");
            return "redirect:/fitness/trainer/login";
        }

        try {
            FitnessTrainer trainer = new FitnessTrainer();
            trainer.setFullName(fullName.trim());
            trainer.setEmail(email.trim().toLowerCase());
            trainer.setPhone(phone.trim());
            trainer.setPassword(passwordService.encode(password));
            trainer.setExperience(experience != null ? experience : 0);
            trainer.setBio(bio != null ? bio.trim() : "");
            trainer.setAvailableTimings(availableTimings != null ? availableTimings : "");
            trainer.setSessionFees(sessionFees != null ? sessionFees : 0.0);
            trainer.setSpecializations(specializations != null ? String.join(",", specializations) : "");
            trainer.setVerificationStatus(VerificationStatus.PENDING);
            trainer.setPartnerProfileStatus(PartnerProfileStatus.REGISTERED);
            trainer.setProfileCompletionPct(0);
            trainer.setSuspended(false);

            if (profilePhoto != null && !profilePhoto.isEmpty()) {
                trainer.setProfilePhotoPath(fileUploadService.saveFile(profilePhoto));
            }
            if (certificationDoc != null && !certificationDoc.isEmpty()) {
                trainer.setCertificationsPath(fileUploadService.saveFile(certificationDoc));
            }

            fitnessTrainerRepository.save(trainer);
            redirectAttributes.addFlashAttribute("registeredEmail", email.trim().toLowerCase());
            redirectAttributes.addFlashAttribute("message", "Account created successfully! Please sign in to complete your profile and submit for verification.");
            return "redirect:/fitness/trainer/login";

        } catch (IOException e) {
            redirectAttributes.addFlashAttribute("error", "File upload failed: " + e.getMessage());
            return "redirect:/fitness/trainer/register";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Registration failed: " + e.getMessage());
            return "redirect:/fitness/trainer/register";
        }
    }

    // TRAINER LOGIN GET
    @GetMapping("/trainer/login")
    public String loginTrainerForm(HttpSession session) {
        if (getSessionTrainer(session) != null) {
            return "redirect:/fitness/trainer/profile-completion";
        }
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
        if (opt.isPresent()) {
            FitnessTrainer trainer = opt.get();
            boolean ok = passwordService.matchesAndUpgrade(password, trainer.getPassword(), hashed -> {
                trainer.setPassword(hashed);
                fitnessTrainerRepository.save(trainer);
            });
            if (ok) {
                if (trainer.isSuspended()) {
                    redirectAttributes.addFlashAttribute("error", "Your trainer account has been suspended.");
                    return "redirect:/fitness/trainer/login";
                }

                trainerProfileService.refreshCompletion(trainer);
                session.setAttribute("loggedTrainer", trainer);
                session.setAttribute("postLoginOpenProfile", Boolean.TRUE);

                // Generate JWT and add to response
                String token = jwtUtil.generateToken(trainer.getEmail(), "TRAINER");
                jakarta.servlet.http.Cookie cookie = new jakarta.servlet.http.Cookie("JWT_TOKEN", token);
                cookie.setPath("/");
                cookie.setHttpOnly(true);
                cookie.setMaxAge(365 * 24 * 60 * 60); // 1 year
                response.addCookie(cookie);

                return "redirect:/fitness/trainer/profile-completion";
            }
        }

        redirectAttributes.addFlashAttribute("error", "Invalid credentials!");
        return "redirect:/fitness/trainer/login";
    }

    // TRAINER PROFILE COMPLETION GET
    @GetMapping("/trainer/profile-completion")
    public String showTrainerProfileCompletion(HttpSession session, Model model) {
        FitnessTrainer sessionTrainer = (FitnessTrainer) session.getAttribute("loggedTrainer");
        if (sessionTrainer == null) return "redirect:/fitness/trainer/login";
        session.removeAttribute("postLoginOpenProfile");

        FitnessTrainer trainer = fitnessTrainerRepository.findById(sessionTrainer.getId()).orElse(sessionTrainer);
        trainerProfileService.refreshCompletion(trainer);
        model.addAttribute("trainer", trainer);
        model.addAttribute("missingItems", trainerProfileService.missingItems(trainer));
        return "fitnessTrainerProfileCompletion";
    }

    // TRAINER PROFILE UPDATE POST (Profile Completion Form)
    @PostMapping("/trainer/updateProfile")
    @Transactional

    public String updateTrainerProfile(
            @RequestParam(required = false) Long id,
            @RequestParam(required = false) String fullName,
            @RequestParam(required = false) String designation,
            @RequestParam(required = false) String phone,
            @RequestParam(required = false) String whatsappNumber,
            @RequestParam(required = false) Integer experience,
            @RequestParam(required = false) String credentialNumber,
            @RequestParam(required = false) String address,
            @RequestParam(required = false) String city,
            @RequestParam(required = false) String state,
            @RequestParam(required = false) String pincode,
            @RequestParam(required = false) String mapLink,
            @RequestParam(required = false) List<String> specializations,
            @RequestParam(required = false) List<String> audience,
            @RequestParam(required = false, defaultValue = "false") Boolean doorstepService,
            @RequestParam(required = false) List<String> facilities,
            @RequestParam(required = false) List<String> availableDays,
            @RequestParam(required = false) String openTime,
            @RequestParam(required = false) String closeTime,
            @RequestParam(required = false) String bio,
            @RequestParam(required = false) String sessionMode,
            @RequestParam(required = false) Integer sessionDuration,
            @RequestParam(required = false) Double sessionFees,
            @RequestParam(required = false) String upiId,
            @RequestParam(required = false) String bankDetails,
            @RequestParam(value = "profilePhotoFile", required = false) MultipartFile profilePhotoFile,
            @RequestParam(value = "certificateFile", required = false) MultipartFile certificateFile,
            @RequestParam(value = "galleryFiles", required = false) List<MultipartFile> galleryFiles,
            HttpSession session, RedirectAttributes redirectAttributes) {

        FitnessTrainer sessionTrainer = getSessionTrainer(session);
        if (sessionTrainer == null) return "redirect:/fitness/trainer/login";

        FitnessTrainer trainer = fitnessTrainerRepository.findById(sessionTrainer.getId()).orElse(sessionTrainer);

        Map<String, Object> fields = new HashMap<>();
        if (fullName != null) fields.put("fullName", fullName);
        if (designation != null) fields.put("designation", designation);
        if (phone != null) fields.put("phone", phone);
        if (whatsappNumber != null) fields.put("whatsappNumber", whatsappNumber);
        if (experience != null) fields.put("experience", experience);
        if (credentialNumber != null) fields.put("credentialNumber", credentialNumber);
        if (address != null) fields.put("address", address);
        if (city != null) fields.put("city", city);
        if (state != null) fields.put("state", state);
        if (pincode != null) fields.put("pincode", pincode);
        if (mapLink != null) fields.put("mapLink", mapLink);
        if (specializations != null) fields.put("specializations", specializations);
        if (audience != null) fields.put("audience", audience);
        fields.put("doorService", doorstepService);
        if (facilities != null) fields.put("facilities", facilities);
        if (availableDays != null) fields.put("openDays", availableDays);
        if (openTime != null) fields.put("openTime", openTime);
        if (closeTime != null) fields.put("closeTime", closeTime);
        if (bio != null) fields.put("bio", bio);
        if (sessionMode != null) fields.put("sessionMode", sessionMode);
        if (sessionDuration != null) fields.put("durationMinutes", sessionDuration);
        if (sessionFees != null) fields.put("typicalPrice", sessionFees);
        if (upiId != null) fields.put("upiId", upiId);
        if (bankDetails != null) fields.put("bankDetails", bankDetails);

        trainerProfileService.applyExtraFields(trainer, fields);

        try {
            if (profilePhotoFile != null && !profilePhotoFile.isEmpty()) {
                trainer.setProfilePhotoPath(fileUploadService.saveFile(profilePhotoFile));
            }
            if (certificateFile != null && !certificateFile.isEmpty()) {
                trainer.setCertificationsPath(fileUploadService.saveFile(certificateFile));
            }
            if (galleryFiles != null && !galleryFiles.isEmpty()) {
                List<String> paths = new ArrayList<>();
                for (MultipartFile gf : galleryFiles) {
                    if (gf != null && !gf.isEmpty()) {
                        paths.add(fileUploadService.saveFile(gf));
                    }
                }
                if (!paths.isEmpty()) {
                    trainer.setGalleryPhotos(String.join(",", paths));
                }
            }
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "File upload failed: " + e.getMessage());
        }

        trainerProfileService.refreshCompletion(trainer);
        trainer = fitnessTrainerRepository.save(trainer);
        session.setAttribute("loggedTrainer", trainer);

        boolean ready = trainerProfileService.isReadyForVerification(trainer);
        if (ready) {
            redirectAttributes.addFlashAttribute("success", "Profile saved successfully! You can now submit your profile for admin verification.");
            return "redirect:/fitness/trainer/dashboard";
        } else {
            List<String> missing = trainerProfileService.missingItems(trainer);
            redirectAttributes.addFlashAttribute("info", "Profile saved. Remaining fields to complete: " + String.join(", ", missing));
            return "redirect:/fitness/trainer/profile-completion";
        }
    }

    // TRAINER SUBMIT VERIFICATION POST
    @PostMapping(value = {"/trainer/submitVerification", "/trainer/submit-verification"})
    public String submitTrainerVerification(HttpSession session, RedirectAttributes redirectAttributes) {
        FitnessTrainer sessionTrainer = getSessionTrainer(session);
        if (sessionTrainer == null) return "redirect:/fitness/trainer/login";

        FitnessTrainer trainer = fitnessTrainerRepository.findById(sessionTrainer.getId()).orElse(sessionTrainer);
        try {
            trainer = trainerRegistrationService.submitForVerification(trainer);
            session.setAttribute("loggedTrainer", trainer);
            redirectAttributes.addFlashAttribute("success", "Profile submitted successfully! Admin review is in progress.");
            return "redirect:/fitness/trainer/dashboard";
        } catch (ResponseStatusException ex) {
            redirectAttributes.addFlashAttribute("error",
                    ex.getReason() != null ? ex.getReason() : "Unable to submit profile for verification.");
            return "redirect:/fitness/trainer/profile-completion";
        }
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
        if (Boolean.TRUE.equals(session.getAttribute("postLoginOpenProfile"))) {
            return "redirect:/fitness/trainer/profile-completion";
        }

        trainer = trainerProfileService.refreshCompletion(trainer);
        model.addAttribute("missingItems", trainerProfileService.missingItems(trainer));



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

        // Packages
        List<FitnessPackage> packages = fitnessPackageRepository.findByTrainer_Id(trainer.getId());
        model.addAttribute("packages", packages);

        // Attendance records for this trainer
        List<FitnessAttendance> attendanceList = fitnessAttendanceRepository.findByTrainer_IdOrderBySessionDateDesc(trainer.getId());
        model.addAttribute("attendanceList", attendanceList);

        // Client Progress Logs
        List<FitnessProgressLog> progressLogs = fitnessProgressLogRepository.findByTrainer_IdOrderByLogDateDesc(trainer.getId());
        model.addAttribute("progressLogs", progressLogs);

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

    // UPDATE TRAINER PROFILE (Name, Phone, Experience, Photo, etc.)
    @PostMapping("/trainer/update-profile")
    @Transactional
    public String updateTrainerProfile(
            @RequestParam String fullName,
            @RequestParam String phone,
            @RequestParam Integer experience,
            @RequestParam Double sessionFees,
            @RequestParam String availableTimings,
            @RequestParam(required = false) List<String> specializations,
            @RequestParam(required = false) String bio,
            @RequestParam(required = false) MultipartFile profilePhoto,
            HttpSession session, RedirectAttributes redirectAttributes) {

        FitnessTrainer trainer = getSessionTrainer(session);
        if (trainer == null) return "redirect:/fitness/trainer/login";

        trainer.setFullName(fullName.trim());
        trainer.setPhone(phone.trim());
        trainer.setExperience(experience);
        trainer.setBio(bio);
        trainer.setSessionFees(sessionFees);
        trainer.setAvailableTimings(availableTimings.trim());
        if (specializations != null && !specializations.isEmpty()) {
            trainer.setSpecializations(String.join(",", specializations));
        }

        if (profilePhoto != null && !profilePhoto.isEmpty()) {
            try {
                trainer.setProfilePhotoPath(fileUploadService.saveFile(profilePhoto));
            } catch (IOException e) {
                redirectAttributes.addFlashAttribute("error", "Photo upload failed. Other changes were saved.");
                fitnessTrainerRepository.save(trainer);
                session.setAttribute("loggedTrainer", trainer);
                return "redirect:/fitness/trainer/dashboard";
            }
        }

        fitnessTrainerRepository.save(trainer);
        session.setAttribute("loggedTrainer", trainer);

        redirectAttributes.addFlashAttribute("success", "Profile updated successfully!");
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

    // ==========================================
    // TRAINER PACKAGE MANAGEMENT
    // ==========================================

    @PostMapping("/trainer/package/create")
    @Transactional
    public String createTrainerPackage(
            @RequestParam(required = false) Long packageId,
            @RequestParam String packageName,
            @RequestParam String category,
            @RequestParam(required = false) String description,
            @RequestParam(defaultValue = "1") Integer sessionCount,
            @RequestParam(defaultValue = "30") Integer durationDays,
            @RequestParam(defaultValue = "0.0") Double price,
            @RequestParam(defaultValue = "OFFLINE") String sessionType,
            HttpSession session, RedirectAttributes redirectAttributes) {

        FitnessTrainer trainer = getSessionTrainer(session);
        if (trainer == null) return "redirect:/fitness/trainer/login";

        try {
            fitnessService.createOrUpdatePackage(trainer, packageId, packageName, category, description,
                    sessionCount, durationDays, price, sessionType);
            redirectAttributes.addFlashAttribute("success", "Fitness package saved successfully!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        }
        return "redirect:/fitness/trainer/dashboard";
    }

    @PostMapping("/trainer/package/toggle/{id}")
    @Transactional
    public String toggleTrainerPackage(
            @PathVariable Long id,
            HttpSession session, RedirectAttributes redirectAttributes) {

        FitnessTrainer trainer = getSessionTrainer(session);
        if (trainer == null) return "redirect:/fitness/trainer/login";

        try {
            boolean active = fitnessService.togglePackageActive(trainer, id);
            redirectAttributes.addFlashAttribute("success", "Package is now " + (active ? "Active" : "Inactive"));
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        }
        return "redirect:/fitness/trainer/dashboard";
    }

    @PostMapping("/trainer/package/delete/{id}")
    @Transactional
    public String deleteTrainerPackage(
            @PathVariable Long id,
            HttpSession session, RedirectAttributes redirectAttributes) {

        FitnessTrainer trainer = getSessionTrainer(session);
        if (trainer == null) return "redirect:/fitness/trainer/login";

        try {
            fitnessService.deletePackage(trainer, id);
            redirectAttributes.addFlashAttribute("success", "Package deleted successfully.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        }
        return "redirect:/fitness/trainer/dashboard";
    }

    // ==========================================
    // ATTENDANCE & ROSTER MANAGEMENT
    // ==========================================

    @PostMapping("/trainer/attendance/mark")
    @Transactional
    public String markSessionAttendance(
            @RequestParam Long bookingId,
            @RequestParam(required = false) String sessionDate,
            @RequestParam(required = false) String sessionTime,
            @RequestParam(defaultValue = "PRESENT") String status,
            @RequestParam(required = false) String notes,
            HttpSession session, RedirectAttributes redirectAttributes) {

        FitnessTrainer trainer = getSessionTrainer(session);
        if (trainer == null) return "redirect:/fitness/trainer/login";

        try {
            LocalDate date = (sessionDate != null && !sessionDate.isBlank())
                    ? LocalDate.parse(sessionDate) : LocalDate.now();
            fitnessService.markAttendance(trainer, bookingId, date, sessionTime, status, notes);
            redirectAttributes.addFlashAttribute("success", "Attendance marked (" + status + ") successfully!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        }
        return "redirect:/fitness/trainer/dashboard";
    }

    // ==========================================
    // DYNAMIC QR ATTENDANCE (WEB AJAX & API)
    // ==========================================

    @PostMapping("/trainer/api/qr-session")
    @ResponseBody
    public org.springframework.http.ResponseEntity<?> createTrainerQrSession(
            @RequestBody(required = false) Map<String, Object> payload,
            HttpSession session) {
        FitnessTrainer trainer = getSessionTrainer(session);
        if (trainer == null) {
            return org.springframework.http.ResponseEntity.status(org.springframework.http.HttpStatus.UNAUTHORIZED)
                    .body(Map.of("success", false, "message", "Trainer authentication required"));
        }

        try {
            Long classId = null;
            int duration = 15;
            Double lat = null;
            Double lng = null;

            if (payload != null) {
                if (payload.get("classId") != null && !payload.get("classId").toString().isEmpty()) {
                    classId = Long.valueOf(payload.get("classId").toString());
                }
                if (payload.get("duration") != null && !payload.get("duration").toString().isEmpty()) {
                    duration = Integer.parseInt(payload.get("duration").toString());
                }
                if (payload.get("latitude") != null) {
                    lat = Double.parseDouble(payload.get("latitude").toString());
                }
                if (payload.get("longitude") != null) {
                    lng = Double.parseDouble(payload.get("longitude").toString());
                }
            }

            in.sp.main.Entities.FitnessQrAttendanceSession qrSession = fitnessQrAttendanceService.createOrRefreshSession(
                    trainer, classId, LocalDate.now(), duration, lat, lng);

            Map<String, Object> res = new HashMap<>();
            res.put("success", true);
            res.put("sessionId", qrSession.getId());
            res.put("token", qrSession.getToken());
            res.put("qrPayload", qrSession.getToken());
            res.put("trainerName", trainer.getFullName());
            res.put("sessionDate", qrSession.getSessionDate().toString());
            res.put("expiresAt", qrSession.getExpiresAt().toString());
            res.put("durationMinutes", duration);

            return org.springframework.http.ResponseEntity.ok(res);
        } catch (Exception e) {
            return org.springframework.http.ResponseEntity.badRequest()
                    .body(Map.of("success", false, "message", e.getMessage()));
        }
    }

    @PostMapping("/trainer/api/qr-session/{id}/close")
    @ResponseBody
    public org.springframework.http.ResponseEntity<?> closeTrainerQrSession(
            @PathVariable Long id, HttpSession session) {
        FitnessTrainer trainer = getSessionTrainer(session);
        if (trainer == null) {
            return org.springframework.http.ResponseEntity.status(org.springframework.http.HttpStatus.UNAUTHORIZED)
                    .body(Map.of("success", false, "message", "Trainer authentication required"));
        }

        try {
            fitnessQrAttendanceService.closeSession(id, trainer);
            return org.springframework.http.ResponseEntity.ok(Map.of("success", true, "message", "QR Session closed"));
        } catch (Exception e) {
            return org.springframework.http.ResponseEntity.badRequest()
                    .body(Map.of("success", false, "message", e.getMessage()));
        }
    }

    @GetMapping("/trainer/api/qr-session/{id}/attendees")
    @ResponseBody
    public org.springframework.http.ResponseEntity<?> getTrainerQrSessionAttendees(
            @PathVariable Long id, HttpSession session) {
        FitnessTrainer trainer = getSessionTrainer(session);
        if (trainer == null) {
            return org.springframework.http.ResponseEntity.status(org.springframework.http.HttpStatus.UNAUTHORIZED)
                    .body(Map.of("success", false, "message", "Trainer authentication required"));
        }

        try {
            List<Map<String, Object>> attendees = fitnessQrAttendanceService.getSessionAttendees(trainer, id);
            return org.springframework.http.ResponseEntity.ok(Map.of("success", true, "attendees", attendees));
        } catch (Exception e) {
            return org.springframework.http.ResponseEntity.badRequest()
                    .body(Map.of("success", false, "message", e.getMessage()));
        }
    }

    @GetMapping("/trainer/api/qr-session/active")
    @ResponseBody
    public org.springframework.http.ResponseEntity<?> getActiveTrainerQrSession(HttpSession session) {
        FitnessTrainer trainer = getSessionTrainer(session);
        if (trainer == null) {
            return org.springframework.http.ResponseEntity.status(org.springframework.http.HttpStatus.UNAUTHORIZED)
                    .body(Map.of("success", false, "message", "Trainer authentication required"));
        }

        Optional<in.sp.main.Entities.FitnessQrAttendanceSession> active = fitnessQrAttendanceService.getActiveSession(trainer, LocalDate.now());
        if (active.isPresent()) {
            in.sp.main.Entities.FitnessQrAttendanceSession s = active.get();
            Map<String, Object> res = new HashMap<>();
            res.put("success", true);
            res.put("active", true);
            res.put("sessionId", s.getId());
            res.put("token", s.getToken());
            res.put("qrPayload", s.getToken());
            res.put("trainerName", trainer.getFullName());
            res.put("sessionDate", s.getSessionDate().toString());
            res.put("expiresAt", s.getExpiresAt().toString());
            return org.springframework.http.ResponseEntity.ok(res);
        }
        return org.springframework.http.ResponseEntity.ok(Map.of("success", true, "active", false));
    }

    // ==========================================
    // CLIENT PROGRESS TRACKING
    // ==========================================

    @PostMapping("/trainer/progress/log")
    @Transactional
    public String logClientProgress(
            @RequestParam Long userId,
            @RequestParam(required = false) Double weightKg,
            @RequestParam(required = false) Double bodyFatPct,
            @RequestParam(defaultValue = "1") Integer workoutsCompleted,
            @RequestParam(required = false) String metricsJson,
            @RequestParam(required = false) String workoutNotes,
            HttpSession session, RedirectAttributes redirectAttributes) {

        FitnessTrainer trainer = getSessionTrainer(session);
        if (trainer == null) return "redirect:/fitness/trainer/login";

        try {
            fitnessService.logClientProgress(userId, trainer, LocalDate.now(), weightKg, bodyFatPct,
                    workoutsCompleted, metricsJson, workoutNotes);
            redirectAttributes.addFlashAttribute("success", "Client fitness progress logged successfully!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        }
        return "redirect:/fitness/trainer/dashboard";
    }

    @GetMapping("/api/my-progress")
    @ResponseBody
    public org.springframework.http.ResponseEntity<Map<String, Object>> getMyProgressApi(HttpSession session) {
        User currentUser = getSessionUser(session);
        if (currentUser == null) {
            return org.springframework.http.ResponseEntity.status(401).body(Map.of("error", "Unauthorized"));
        }
        Map<String, Object> summary = fitnessService.getUserFitnessProgressSummary(currentUser.getId());
        return org.springframework.http.ResponseEntity.ok(summary);
    }

    // ==========================================
    // RESCHEDULE BOOKING
    // ==========================================

    @PostMapping("/trainer/booking/reschedule")
    @Transactional
    public String rescheduleBooking(
            @RequestParam Long bookingId,
            @RequestParam String newDate,
            @RequestParam String newTime,
            HttpSession session, RedirectAttributes redirectAttributes) {

        FitnessTrainer trainer = getSessionTrainer(session);
        if (trainer == null) return "redirect:/fitness/trainer/login";

        FitnessBooking booking = fitnessBookingRepository.findById(bookingId).orElse(null);
        if (booking == null || !booking.getTrainer().getId().equals(trainer.getId())) {
            redirectAttributes.addFlashAttribute("error", "Booking record not found.");
            return "redirect:/fitness/trainer/dashboard";
        }

        try {
            booking.setBookingDate(LocalDate.parse(newDate));
            booking.setBookingTime(newTime);
            fitnessBookingRepository.save(booking);
            redirectAttributes.addFlashAttribute("success", "Session rescheduled to " + newDate + " at " + newTime);
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Invalid date or time: " + e.getMessage());
        }
        return "redirect:/fitness/trainer/dashboard";
    }

    // ==========================================
    // USER MEMBERSHIP & BOOKINGS
    // ==========================================


    @PostMapping("/booking/package/buy")
    @Transactional
    public String buyFitnessPackage(
            @RequestParam Long packageId,
            HttpSession session, RedirectAttributes redirectAttributes) {

        User currentUser = getSessionUser(session);
        if (currentUser == null) return "redirect:/login";

        FitnessPackage pkg = fitnessPackageRepository.findById(packageId).orElse(null);
        if (pkg == null || !pkg.isActive()) {
            redirectAttributes.addFlashAttribute("error", "Selected package is unavailable.");
            return "redirect:/fitness";
        }

        Double walletBalance = currentUser.getWalletBalance() != null ? currentUser.getWalletBalance() : 0.0;
        currentUser.setWalletBalance(walletBalance - pkg.getPrice());
        userRepository.save(currentUser);
        session.setAttribute("user", currentUser);

        FitnessBooking booking = new FitnessBooking();
        booking.setUser(currentUser);
        booking.setTrainer(pkg.getTrainer());
        booking.setFitnessPackage(pkg);
        booking.setCategory(pkg.getCategory());
        booking.setBookingDate(LocalDate.now());
        booking.setBookingTime("Package Membership");
        booking.setSessionType(pkg.getSessionType());
        booking.setStatus("APPROVED");
        booking.setPaymentAmount(pkg.getPrice());
        booking.setPaymentStatus("PAID");
        booking.setTotalSessions(pkg.getSessionCount());
        booking.setRemainingSessions(pkg.getSessionCount());
        booking.setCompletedSessions(0);
        booking.setStartDate(LocalDate.now());
        booking.setValidUntil(LocalDate.now().plusDays(pkg.getDurationDays()));
        booking.setEndDate(LocalDate.now().plusDays(pkg.getDurationDays()));

        fitnessBookingRepository.save(booking);

        redirectAttributes.addFlashAttribute("success", "Successfully subscribed to " + pkg.getPackageName() + "!");
        return "redirect:/fitness/my-bookings";
    }

    @GetMapping("/my-bookings")
    public String showUserFitnessBookings(HttpSession session, Model model) {
        User currentUser = getSessionUser(session);
        if (currentUser == null) return "redirect:/login";

        List<FitnessBooking> bookings = fitnessBookingRepository.findByUser_Id(currentUser.getId());
        List<FitnessAttendance> attendanceList = fitnessAttendanceRepository.findByUser_IdOrderBySessionDateDesc(currentUser.getId());
        Map<String, Object> progressSummary = fitnessService.getUserFitnessProgressSummary(currentUser.getId());

        model.addAttribute("bookings", bookings);
        model.addAttribute("attendanceList", attendanceList);
        model.addAttribute("progressSummary", progressSummary);

        return "fitnessUserBookings";
    }
}

