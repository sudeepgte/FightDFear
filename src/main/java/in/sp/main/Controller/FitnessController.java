package in.sp.main.Controller;

import in.sp.main.Entities.*;
import in.sp.main.Repository.*;
import in.sp.main.Service.FileUploadService;
import in.sp.main.Util.FitnessCategories;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.server.ResponseStatusException;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.beans.factory.annotation.Value;
import com.razorpay.Order;
import com.razorpay.RazorpayClient;
import com.razorpay.Utils;
import org.json.JSONObject;

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

    @Value("${razorpay.key.id:}")
    private String razorpayKeyId;

    @Value("${razorpay.key.secret:}")
    private String razorpayKeySecret;

    @Value("${app.payments.mock-enabled:false}")
    private boolean paymentMockEnabled;

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
            @RequestParam(value = "category", required = false) String category,
            @RequestParam(value = "search", required = false) String search,
            @RequestParam(value = "query", required = false) String query,
            @RequestParam(value = "city", required = false) String city,
            @RequestParam(value = "location", required = false) String location,
            @RequestParam(value = "maxPrice", required = false) Double maxPrice,
            @RequestParam(value = "minRating", required = false) Double minRating,
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
            @PathVariable("id") Long id,
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

        List<String> trainerSpecs = FitnessCategories.splitSpecializations(trainer.getSpecializations());
        List<String> categories = !trainerSpecs.isEmpty() ? trainerSpecs : FitnessCategories.ALL;

        model.addAttribute("trainerSpecializations", trainerSpecs);
        model.addAttribute("categories", categories);

        return "fitnessTrainerProfile";
    }

    // GET AVAILABLE SLOTS FOR A TRAINER ON A GIVEN DATE
    @GetMapping("/api/trainer/{id}/available-slots")
    @ResponseBody
    public org.springframework.http.ResponseEntity<?> getTrainerAvailableSlots(
            @PathVariable("id") Long id,
            @RequestParam("date") String date) {
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

    private double resolveSessionFee(FitnessTrainer trainer) {
        if (trainer.getTypicalPrice() != null && trainer.getTypicalPrice() > 0) {
            return trainer.getTypicalPrice();
        }
        if (trainer.getSessionFees() != null && trainer.getSessionFees() > 0) {
            return trainer.getSessionFees();
        }
        return 499.0;
    }

    private double calculateTotalFees(double baseFee, String duration) {
        if ("MONTHLY".equalsIgnoreCase(duration)) return baseFee * 10;
        if ("QUARTERLY".equalsIgnoreCase(duration)) return baseFee * 25;
        if ("HALF_YEAR".equalsIgnoreCase(duration)) return baseFee * 45;
        if ("YEAR".equalsIgnoreCase(duration)) return baseFee * 80;
        return baseFee;
    }

    private int calculateTotalSessions(String duration) {
        if ("MONTHLY".equalsIgnoreCase(duration)) return 12;
        if ("QUARTERLY".equalsIgnoreCase(duration)) return 36;
        if ("HALF_YEAR".equalsIgnoreCase(duration)) return 72;
        if ("YEAR".equalsIgnoreCase(duration)) return 144;
        return 1;
    }

    private LocalDate calculateEndDate(LocalDate startDate, String duration) {
        if ("MONTHLY".equalsIgnoreCase(duration)) return startDate.plusMonths(1);
        if ("QUARTERLY".equalsIgnoreCase(duration)) return startDate.plusMonths(3);
        if ("HALF_YEAR".equalsIgnoreCase(duration)) return startDate.plusMonths(6);
        if ("YEAR".equalsIgnoreCase(duration)) return startDate.plusYears(1);
        return startDate;
    }

    // CREATE RAZORPAY ORDER FOR BOOKING
    @PostMapping("/book/create-order")
    @ResponseBody
    public ResponseEntity<?> createBookingOrder(
            @RequestParam("trainerId") Long trainerId,
            @RequestParam("bookingDate") String bookingDate,
            @RequestParam("bookingTime") String bookingTime,
            @RequestParam(value = "duration", required = false, defaultValue = "SINGLE") String duration,
            HttpSession session) {

        User currentUser = getSessionUser(session);
        if (currentUser == null) {
            return ResponseEntity.status(401).body(Map.of(
                    "success", false,
                    "error", "Please login to proceed with booking.",
                    "loginRequired", true
            ));
        }

        FitnessTrainer trainer = fitnessTrainerRepository.findById(trainerId).orElse(null);
        if (trainer == null || trainer.isSuspended()) {
            return ResponseEntity.badRequest().body(Map.of("success", false, "error", "Trainer not found or unavailable."));
        }

        if (bookingTime == null || bookingTime.trim().isEmpty()) {
            return ResponseEntity.badRequest().body(Map.of("success", false, "error", "Please select an available timing slot."));
        }

        LocalDate startDate;
        try {
            startDate = LocalDate.parse(bookingDate);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("success", false, "error", "Invalid booking date."));
        }

        if (startDate.isBefore(LocalDate.now())) {
            return ResponseEntity.badRequest().body(Map.of("success", false, "error", "Booking date cannot be in the past."));
        }

        boolean alreadyBooked = fitnessBookingRepository.findByTrainer_IdAndBookingDate(trainer.getId(), startDate)
                .stream()
                .anyMatch(b -> !"CANCELLED".equalsIgnoreCase(b.getStatus()) 
                            && !"REJECTED".equalsIgnoreCase(b.getStatus()) 
                            && bookingTime.trim().equalsIgnoreCase(b.getBookingTime() != null ? b.getBookingTime().trim() : ""));
        if (alreadyBooked) {
            return ResponseEntity.badRequest().body(Map.of("success", false, "error", "The timing slot " + bookingTime + " is already booked for " + startDate + "."));
        }

        double baseFee = resolveSessionFee(trainer);
        double totalFees = calculateTotalFees(baseFee, duration);
        int amountPaise = (int) Math.round(totalFees * 100);

        boolean isMock = paymentMockEnabled || razorpayKeyId == null || razorpayKeyId.isBlank() || razorpayKeySecret == null || razorpayKeySecret.isBlank();
        String orderId;
        String key = razorpayKeyId;

        if (isMock) {
            orderId = "order_mock_" + currentUser.getId() + "_" + System.currentTimeMillis();
            key = "rzp_test_mock";
        } else {
            try {
                RazorpayClient client = new RazorpayClient(razorpayKeyId, razorpayKeySecret);
                JSONObject orderRequest = new JSONObject();
                orderRequest.put("amount", amountPaise);
                orderRequest.put("currency", "INR");
                orderRequest.put("receipt", "fit_" + currentUser.getId() + "_" + System.currentTimeMillis());
                Order order = client.orders.create(orderRequest);
                orderId = order.get("id").toString();
            } catch (Exception e) {
                return ResponseEntity.status(500).body(Map.of("success", false, "error", "Could not initialize Razorpay order: " + e.getMessage()));
            }
        }

        Map<String, Object> resp = new LinkedHashMap<>();
        resp.put("success", true);
        resp.put("orderId", orderId);
        resp.put("key", key);
        resp.put("amount", amountPaise);
        resp.put("currency", "INR");
        resp.put("mock", isMock);
        resp.put("trainerName", trainer.getFullName());
        resp.put("fees", totalFees);
        resp.put("user", Map.of(
            "name", currentUser.getFullName() != null ? currentUser.getFullName() : "",
            "email", currentUser.getEmail() != null ? currentUser.getEmail() : "",
            "phone", currentUser.getPhoneNumber() != null ? currentUser.getPhoneNumber() : ""
        ));
        return ResponseEntity.ok(resp);
    }

    // BOOK SESSION REQUEST
    @PostMapping("/book")
    @Transactional
    public String bookSession(
            @RequestParam("trainerId") Long trainerId,
            @RequestParam("category") String category,
            @RequestParam("bookingDate") String bookingDate,
            @RequestParam("bookingTime") String bookingTime,
            @RequestParam("sessionType") String sessionType,
            @RequestParam(value = "duration", required = false) String duration,
            @RequestParam(value = "paymentMethod", required = false, defaultValue = "RAZORPAY") String paymentMethod,
            @RequestParam(value = "razorpayOrderId", required = false) String razorpayOrderId,
            @RequestParam(value = "razorpayPaymentId", required = false) String razorpayPaymentId,
            @RequestParam(value = "razorpaySignature", required = false) String razorpaySignature,
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

        if (duration == null || duration.isBlank()) {
            duration = "SINGLE";
        }

        double baseFees = resolveSessionFee(trainer);
        double fees = calculateTotalFees(baseFees, duration);
        int totalSessions = calculateTotalSessions(duration);
        LocalDate endDate = calculateEndDate(startDate, duration);

        boolean paid = false;
        String mode = "RAZORPAY";

        if ("WALLET".equalsIgnoreCase(paymentMethod)) {
            mode = "WALLET";
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
        } else {
            mode = "RAZORPAY";
            boolean isMock = paymentMockEnabled || razorpayKeyId == null || razorpayKeyId.isBlank() || razorpayKeySecret == null || razorpayKeySecret.isBlank();
            if (!isMock && razorpaySignature != null && !razorpaySignature.isBlank()) {
                try {
                    JSONObject options = new JSONObject();
                    options.put("razorpay_order_id", razorpayOrderId);
                    options.put("razorpay_payment_id", razorpayPaymentId);
                    options.put("razorpay_signature", razorpaySignature);
                    boolean valid = Utils.verifyPaymentSignature(options, razorpayKeySecret);
                    if (!valid) {
                        redirectAttributes.addFlashAttribute("error", "Razorpay payment verification failed.");
                        return "redirect:/fitness/trainer/" + trainerId;
                    }
                    paid = true;
                } catch (Exception e) {
                    redirectAttributes.addFlashAttribute("error", "Payment verification error: " + e.getMessage());
                    return "redirect:/fitness/trainer/" + trainerId;
                }
            } else if (isMock || (razorpayPaymentId != null && !razorpayPaymentId.isBlank())) {
                paid = true;
            }
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
        booking.setPaymentMode(mode);
        booking.setRazorpayOrderId(razorpayOrderId);
        booking.setRazorpayPaymentId(razorpayPaymentId);
        booking.setRazorpaySignature(razorpaySignature);
        booking.setPaymentStatus(paid ? "PAID" : "PENDING");
        booking.setDuration(duration);
        booking.setTotalSessions(totalSessions);
        booking.setCompletedSessions(0);
        booking.setRemainingSessions(totalSessions);
        booking.setStartDate(startDate);
        booking.setEndDate(endDate);

        fitnessBookingRepository.save(booking);

        redirectAttributes.addFlashAttribute("success", "Booking confirmed with Razorpay payment! Pending trainer acceptance.");
        return "redirect:/fitness/bookings";
    }

    // USER BOOKINGS HISTORY
    @GetMapping({"/bookings", "/my-bookings"})
    public String showUserBookings(HttpSession session, Model model) {
        User currentUser = getSessionUser(session);
        if (currentUser == null) return "redirect:/login";

        try {
            List<FitnessBooking> rawBookings = fitnessBookingRepository.findByUser_Id(currentUser.getId());
            List<FitnessBooking> bookings = rawBookings != null ? new ArrayList<>(rawBookings) : new ArrayList<>();
            // Sort bookings: pending/approved first, then completed/cancelled
            bookings.sort((b1, b2) -> {
                if (b1 == null && b2 == null) return 0;
                if (b1 == null || b1.getBookingDate() == null) return 1;
                if (b2 == null || b2.getBookingDate() == null) return -1;
                return b2.getBookingDate().compareTo(b1.getBookingDate());
            });

            // 1. Attendance Records
            List<FitnessAttendance> rawAttendance = fitnessAttendanceRepository.findByUser_IdOrderBySessionDateDesc(currentUser.getId());
            List<FitnessAttendance> attendanceList = rawAttendance != null ? new ArrayList<>(rawAttendance) : new ArrayList<>();

            // Auto-sync attendance for completed bookings or bookings with completed sessions
            boolean addedAttendance = false;
            for (FitnessBooking b : bookings) {
                if (b != null && ("COMPLETED".equalsIgnoreCase(b.getStatus()) || (b.getCompletedSessions() != null && b.getCompletedSessions() > 0))) {
                    try {
                        List<FitnessAttendance> existing = fitnessAttendanceRepository.findByBooking_IdOrderBySessionDateDesc(b.getId());
                        if (existing == null || existing.isEmpty()) {
                            FitnessAttendance att = new FitnessAttendance();
                            att.setBooking(b);
                            att.setUser(currentUser);
                            if (b.getTrainer() != null) {
                                att.setTrainer(b.getTrainer());
                            }
                            att.setSessionDate(b.getBookingDate() != null ? b.getBookingDate() : LocalDate.now());
                            att.setSessionTime(b.getBookingTime() != null ? b.getBookingTime() : "10:00");
                            att.setStatus("PRESENT");
                            att.setNotes("Completed workout - " + (b.getCategory() != null ? b.getCategory() : "Fitness Session"));
                            att.setCreditsDeducted(1);
                            fitnessAttendanceRepository.save(att);
                            attendanceList.add(att);
                            addedAttendance = true;
                        }
                    } catch (Exception ex) {
                        System.err.println("Warning: Could not auto-sync attendance for booking " + b.getId() + ": " + ex.getMessage());
                    }
                }
            }
            if (addedAttendance) {
                attendanceList.sort((a1, a2) -> {
                    if (a1 == null && a2 == null) return 0;
                    if (a1 == null || a1.getSessionDate() == null) return 1;
                    if (a2 == null || a2.getSessionDate() == null) return -1;
                    return a2.getSessionDate().compareTo(a1.getSessionDate());
                });
            }

            // 2. Progress Logs
            List<in.sp.main.Entities.FitnessProgressLog> rawLogs = fitnessProgressLogRepository.findByUser_IdOrderByLogDateDesc(currentUser.getId());
            List<in.sp.main.Entities.FitnessProgressLog> progressLogs = rawLogs != null ? new ArrayList<>(rawLogs) : new ArrayList<>();

            // Auto-initialize baseline progress milestone if empty but user has workouts or bookings
            if (progressLogs.isEmpty() && (!attendanceList.isEmpty() || bookings.stream().anyMatch(b -> b != null && "COMPLETED".equalsIgnoreCase(b.getStatus())))) {
                try {
                    FitnessBooking ref = bookings.stream()
                            .filter(b -> b != null && "COMPLETED".equalsIgnoreCase(b.getStatus()))
                            .findFirst()
                            .orElse(!bookings.isEmpty() ? bookings.get(0) : null);

                    in.sp.main.Entities.FitnessProgressLog initialLog = new in.sp.main.Entities.FitnessProgressLog();
                    initialLog.setUser(currentUser);
                    if (ref != null && ref.getTrainer() != null) {
                        initialLog.setTrainer(ref.getTrainer());
                    }
                    initialLog.setLogDate(ref != null && ref.getBookingDate() != null ? ref.getBookingDate() : LocalDate.now());
                    initialLog.setWorkoutsCompleted(Math.max(1, attendanceList.size()));
                    initialLog.setWeightKg(62.0);
                    initialLog.setBodyFatPct(22.0);
                    String coachName = (ref != null && ref.getTrainer() != null && ref.getTrainer().getFullName() != null) 
                            ? ref.getTrainer().getFullName() : "Trainer";
                    initialLog.setWorkoutNotes("First workout milestone completed with Coach " + coachName + "!");
                    fitnessProgressLogRepository.save(initialLog);
                    progressLogs.add(initialLog);
                } catch (Exception ex) {
                    System.err.println("Warning: Could not create baseline progress log: " + ex.getMessage());
                }
            }

            // 3. Dynamic Progress Summary
            Map<String, Object> progressSummary = null;
            try {
                progressSummary = fitnessService.getUserFitnessProgressSummary(currentUser.getId());
            } catch (Exception ex) {
                System.err.println("Warning: Could not load progress summary: " + ex.getMessage());
            }
            if (progressSummary == null) {
                progressSummary = new HashMap<>();
            }
            long totalAttended = Math.max(
                attendanceList.stream().filter(a -> a != null && "PRESENT".equalsIgnoreCase(a.getStatus())).count(),
                bookings.stream().filter(Objects::nonNull).mapToInt(b -> b.getCompletedSessions() != null ? b.getCompletedSessions() : ("COMPLETED".equalsIgnoreCase(b.getStatus()) ? 1 : 0)).sum()
            );
            progressSummary.put("totalWorkoutsAttended", totalAttended);

            if (!progressLogs.isEmpty()) {
                in.sp.main.Entities.FitnessProgressLog latest = progressLogs.get(0);
                if (latest != null) {
                    progressSummary.put("latestWeight", latest.getWeightKg());
                    progressSummary.put("latestBodyFat", latest.getBodyFatPct());
                    progressSummary.put("lastLogDate", latest.getLogDate());
                }
            }

            // 4. Tab and Card counts
            long upcomingCount = bookings.stream().filter(b -> b != null && (
                "PENDING".equalsIgnoreCase(b.getStatus())
                || "APPROVED".equalsIgnoreCase(b.getStatus())
                || "CONFIRMED".equalsIgnoreCase(b.getStatus())
                || (b.getRemainingSessions() != null && b.getRemainingSessions() > 0 && !"CANCELLED".equalsIgnoreCase(b.getStatus()) && !"REJECTED".equalsIgnoreCase(b.getStatus()))
            )).count();

            long completedCount = bookings.stream().filter(b -> b != null && (
                "COMPLETED".equalsIgnoreCase(b.getStatus()) || (b.getCompletedSessions() != null && b.getCompletedSessions() > 0)
            )).count();

            long activePassesCount = bookings.stream().filter(b -> b != null && (
                "APPROVED".equalsIgnoreCase(b.getStatus())
                || ("PENDING".equalsIgnoreCase(b.getStatus()) && "PAID".equalsIgnoreCase(b.getPaymentStatus()))
                || (b.getRemainingSessions() != null && b.getRemainingSessions() > 0 && !"CANCELLED".equalsIgnoreCase(b.getStatus()) && !"REJECTED".equalsIgnoreCase(b.getStatus()))
            )).count();

            model.addAttribute("user", currentUser);
            model.addAttribute("bookings", bookings);
            model.addAttribute("attendanceList", attendanceList);
            model.addAttribute("progressLogs", progressLogs);
            model.addAttribute("progressSummary", progressSummary);
            model.addAttribute("upcomingCount", upcomingCount);
            model.addAttribute("completedCount", completedCount);
            model.addAttribute("activePassesCount", activePassesCount);

        } catch (Exception e) {
            System.err.println("Error in showUserBookings: " + e.getMessage());
            e.printStackTrace();
            model.addAttribute("user", currentUser);
            model.addAttribute("bookings", new ArrayList<>());
            model.addAttribute("attendanceList", new ArrayList<>());
            model.addAttribute("progressLogs", new ArrayList<>());
            model.addAttribute("progressSummary", new HashMap<>());
            model.addAttribute("upcomingCount", 0);
            model.addAttribute("completedCount", 0);
            model.addAttribute("activePassesCount", 0);
            model.addAttribute("error", "Some booking details could not be retrieved: " + e.getMessage());
        }

        return "fitnessUserBookings";
    }

    // GET /fitness/progress/log fallback (redirects cleanly to /fitness/bookings)
    @GetMapping("/progress/log")
    public Object handleProgressLogGet(HttpServletRequest request) {
        if ("XMLHttpRequest".equalsIgnoreCase(request.getHeader("X-Requested-With"))
                || (request.getHeader("Accept") != null && request.getHeader("Accept").contains("application/json"))) {
            Map<String, Object> resp = new HashMap<>();
            resp.put("success", true);
            resp.put("message", "Fitness progress log service is active.");
            return ResponseEntity.ok(resp);
        }
        return "redirect:/fitness/bookings";
    }

    // USER SELF-LOG FITNESS PROGRESS (Supports both form submit and AJAX JSON)
    @PostMapping("/progress/log")
    @Transactional
    public Object logUserFitnessProgress(
            @RequestParam(value = "weightKg", required = false) String weightKgStr,
            @RequestParam(value = "bodyFatPct", required = false) String bodyFatPctStr,
            @RequestParam(value = "workoutNotes", required = false) String workoutNotes,
            HttpServletRequest request,
            HttpSession session, RedirectAttributes redirectAttributes) {
        boolean isAjax = "XMLHttpRequest".equalsIgnoreCase(request.getHeader("X-Requested-With"))
                || (request.getHeader("Accept") != null && request.getHeader("Accept").contains("application/json"));

        User currentUser = getSessionUser(session);
        if (currentUser == null) {
            if (isAjax) {
                Map<String, Object> err = new HashMap<>();
                err.put("success", false);
                err.put("error", "Please log in to record progress.");
                return ResponseEntity.status(401).body(err);
            }
            return "redirect:/login";
        }

        Double weightKg = null;
        if (weightKgStr != null && !weightKgStr.trim().isEmpty()) {
            try {
                weightKg = Double.parseDouble(weightKgStr.trim());
            } catch (Exception ignored) {}
        }

        if (weightKg == null || weightKg < 20 || weightKg > 300) {
            if (isAjax) {
                Map<String, Object> err = new HashMap<>();
                err.put("success", false);
                err.put("error", "Please enter a valid current weight between 20kg and 300kg.");
                return ResponseEntity.badRequest().body(err);
            }
            redirectAttributes.addFlashAttribute("error", "Please enter a valid weight in kg.");
            return "redirect:/fitness/bookings";
        }

        Double bodyFatPct = null;
        if (bodyFatPctStr != null && !bodyFatPctStr.trim().isEmpty()) {
            try {
                bodyFatPct = Double.parseDouble(bodyFatPctStr.trim());
            } catch (Exception ignored) {}
        }

        try {
            in.sp.main.Entities.FitnessProgressLog log = new in.sp.main.Entities.FitnessProgressLog();
            log.setUser(currentUser);
            log.setLogDate(LocalDate.now());
            log.setWeightKg(weightKg);
            log.setBodyFatPct(bodyFatPct);
            log.setWorkoutNotes(workoutNotes != null && !workoutNotes.isBlank() ? workoutNotes.trim() : "Self-logged workout update");

            List<FitnessBooking> userBookings = fitnessBookingRepository.findByUser_Id(currentUser.getId());
            if (!userBookings.isEmpty() && userBookings.get(0).getTrainer() != null) {
                log.setTrainer(userBookings.get(0).getTrainer());
            }
            long totalWorkouts = fitnessAttendanceRepository.countByUser_IdAndStatus(currentUser.getId(), "PRESENT");
            log.setWorkoutsCompleted((int) Math.max(1, totalWorkouts));

            fitnessProgressLogRepository.save(log);

            if (isAjax) {
                Map<String, Object> resp = new HashMap<>();
                resp.put("success", true);
                resp.put("message", "Fitness milestone & weight logged successfully!");
                resp.put("weightKg", weightKg);
                resp.put("bodyFatPct", bodyFatPct);
                return ResponseEntity.ok(resp);
            }

            redirectAttributes.addFlashAttribute("success", "Fitness milestone & weight logged successfully!");
        } catch (Exception e) {
            if (isAjax) {
                Map<String, Object> err = new HashMap<>();
                err.put("success", false);
                err.put("error", "Error saving progress log: " + e.getMessage());
                return ResponseEntity.status(500).body(err);
            }
            redirectAttributes.addFlashAttribute("error", "Error logging progress: " + e.getMessage());
        }
        return "redirect:/fitness/bookings";
    }

    // CANCEL BOOKING (WITH REFUND)
    @PostMapping("/booking/cancel")
    @Transactional
    public String cancelBooking(@RequestParam("bookingId") Long bookingId, HttpSession session, RedirectAttributes redirectAttributes) {
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
            @RequestParam("bookingId") Long bookingId,
            @RequestParam("rating") Integer rating,
            @RequestParam("comment") String comment,
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
            @RequestParam("fullName") String fullName,
            @RequestParam("email") String email,
            @RequestParam("phone") String phone,
            @RequestParam("password") String password,
            @RequestParam(value = "experience", required = false) Integer experience,
            @RequestParam(value = "bio", required = false) String bio,
            @RequestParam(value = "specializations", required = false) List<String> specializations,
            @RequestParam(value = "availableTimings", required = false) String availableTimings,
            @RequestParam(value = "sessionFees", required = false) Double sessionFees,
            @RequestParam(value = "profilePhoto", required = false) MultipartFile profilePhoto,
            @RequestParam(value = "certificationDoc", required = false) MultipartFile certificationDoc,
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
        FitnessTrainer trainer = getSessionTrainer(session);
        if (trainer != null) {
            if (in.sp.main.Service.FitnessTrainerProfileService.isApproved(trainer)) {
                return "redirect:/fitness/trainer/dashboard";
            }
            return "redirect:/fitness/trainer/profile-completion";
        }
        return "fitnessTrainerLogin";
    }

    // TRAINER LOGIN POST
    @PostMapping("/trainer/login")
    public String handleTrainerLogin(
            @RequestParam("email") String email,
            @RequestParam("password") String password,
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

                // Generate JWT and add to response
                String token = jwtUtil.generateToken(trainer.getEmail(), "TRAINER");
                jakarta.servlet.http.Cookie cookie = new jakarta.servlet.http.Cookie("JWT_TOKEN", token);
                cookie.setPath("/");
                cookie.setHttpOnly(true);
                cookie.setMaxAge(365 * 24 * 60 * 60); // 1 year
                response.addCookie(cookie);

                if (in.sp.main.Service.FitnessTrainerProfileService.isApproved(trainer)) {
                    session.removeAttribute("postLoginOpenProfile");
                    return "redirect:/fitness/trainer/dashboard";
                }

                session.setAttribute("postLoginOpenProfile", Boolean.TRUE);
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
        model.addAttribute("profileCompletionPct", trainer.getProfileCompletionPct() != null ? trainer.getProfileCompletionPct() : 0);
        model.addAttribute("missingItems", trainerProfileService.missingItems(trainer));
        return "fitnessTrainerProfileCompletion";
    }

    // TRAINER PROFILE UPDATE POST (Profile Completion Form)
    @PostMapping("/trainer/updateProfile")
    @Transactional

    public String updateTrainerProfile(
            @RequestParam(value = "id", required = false) Long id,
            @RequestParam(value = "fullName", required = false) String fullName,
            @RequestParam(value = "designation", required = false) String designation,
            @RequestParam(value = "phone", required = false) String phone,
            @RequestParam(value = "whatsappNumber", required = false) String whatsappNumber,
            @RequestParam(value = "experience", required = false) Integer experience,
            @RequestParam(value = "credentialNumber", required = false) String credentialNumber,
            @RequestParam(value = "address", required = false) String address,
            @RequestParam(value = "city", required = false) String city,
            @RequestParam(value = "state", required = false) String state,
            @RequestParam(value = "pincode", required = false) String pincode,
            @RequestParam(value = "mapLink", required = false) String mapLink,
            @RequestParam(value = "latitude", required = false) Double latitude,
            @RequestParam(value = "longitude", required = false) Double longitude,
            @RequestParam(value = "specializations", required = false) List<String> specializations,
            @RequestParam(value = "audience", required = false) List<String> audience,
            @RequestParam(value = "doorstepService", required = false, defaultValue = "false") Boolean doorstepService,
            @RequestParam(value = "facilities", required = false) List<String> facilities,
            @RequestParam(value = "availableDays", required = false) List<String> availableDays,
            @RequestParam(value = "openTime", required = false) String openTime,
            @RequestParam(value = "closeTime", required = false) String closeTime,
            @RequestParam(value = "bio", required = false) String bio,
            @RequestParam(value = "sessionMode", required = false) String sessionMode,
            @RequestParam(value = "sessionDuration", required = false) Integer sessionDuration,
            @RequestParam(value = "sessionFees", required = false) Double sessionFees,
            @RequestParam(value = "upiId", required = false) String upiId,
            @RequestParam(value = "bankAccountHolder", required = false) String bankAccountHolder,
            @RequestParam(value = "bankName", required = false) String bankName,
            @RequestParam(value = "bankAccountNumber", required = false) String bankAccountNumber,
            @RequestParam(value = "bankIfsc", required = false) String bankIfsc,
            @RequestParam(value = "bankBranch", required = false) String bankBranch,
            @RequestParam(value = "bankDetails", required = false) String bankDetails,
            @RequestParam(value = "profilePhotoFile", required = false) MultipartFile profilePhotoFile,
            @RequestParam(value = "certificateFile", required = false) MultipartFile certificateFile,
            @RequestParam(value = "galleryFiles", required = false) List<MultipartFile> galleryFiles,
            @RequestParam(value = "intent", required = false) String intent,
            HttpSession session, RedirectAttributes redirectAttributes) {

        FitnessTrainer sessionTrainer = getSessionTrainer(session);
        if (sessionTrainer == null) return "redirect:/fitness/trainer/login";

        session.removeAttribute("postLoginOpenProfile");

        if (bankAccountNumber != null && !bankAccountNumber.isBlank()) {
            String trimmedAcc = bankAccountNumber.trim();
            if (!trimmedAcc.matches("\\d{9,18}")) {
                redirectAttributes.addFlashAttribute("error", "Bank Account Number must be between 9 and 18 numeric digits.");
                return "redirect:/fitness/trainer/profile-completion";
            }
        }
        if (bankIfsc != null && !bankIfsc.isBlank()) {
            String trimmedIfsc = bankIfsc.trim().toUpperCase();
            if (!trimmedIfsc.matches("^[A-Z]{4}0[A-Z0-9]{6}$")) {
                redirectAttributes.addFlashAttribute("error", "Invalid IFSC code format (e.g. SBIN0001234).");
                return "redirect:/fitness/trainer/profile-completion";
            }
        }

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
        if (latitude != null) fields.put("latitude", latitude);
        if (longitude != null) fields.put("longitude", longitude);
        if ((latitude == null || longitude == null) && mapLink != null) {
            java.util.regex.Matcher m = java.util.regex.Pattern.compile("[?&@](?:q=)?([0-9.-]+),([0-9.-]+)").matcher(mapLink);
            if (m.find()) {
                try {
                    fields.put("latitude", Double.parseDouble(m.group(1)));
                    fields.put("longitude", Double.parseDouble(m.group(2)));
                } catch (Exception ignored) {}
            }
        }
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
        if (bankDetails != null && !bankDetails.isBlank()) {
            fields.put("bankDetails", bankDetails.trim());
        } else if (bankAccountNumber != null && !bankAccountNumber.isBlank()) {
            String serialized = "Account Holder: " + (bankAccountHolder != null ? bankAccountHolder.trim() : "")
                    + " | Bank: " + (bankName != null ? bankName.trim() : "")
                    + " | A/C: " + bankAccountNumber.trim()
                    + " | IFSC: " + (bankIfsc != null ? bankIfsc.trim().toUpperCase() : "")
                    + " | Branch: " + (bankBranch != null ? bankBranch.trim() : "");
            fields.put("bankDetails", serialized);
        }

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
        session.removeAttribute("postLoginOpenProfile");

        boolean ready = trainerProfileService.isReadyForVerification(trainer);
        if ("submitVerification".equalsIgnoreCase(intent != null ? intent.trim() : "")) {
            if (ready) {
                try {
                    trainer = trainerRegistrationService.submitForVerification(trainer);
                    session.setAttribute("loggedTrainer", trainer);
                    redirectAttributes.addFlashAttribute("success", "Profile submitted successfully! Admin review is in progress.");
                } catch (Exception e) {
                    redirectAttributes.addFlashAttribute("success", "Profile saved successfully!");
                }
            } else {
                List<String> missing = trainerProfileService.missingItems(trainer);
                redirectAttributes.addFlashAttribute("info", "Profile saved. Remaining fields to complete for full admin verification: " + String.join(", ", missing));
            }
            return "redirect:/fitness/trainer/dashboard";
        }

        if (ready) {
            redirectAttributes.addFlashAttribute("success", "Profile saved successfully! You can now submit your profile for admin verification.");
        } else {
            redirectAttributes.addFlashAttribute("success", "Profile details saved successfully!");
        }
        return "redirect:/fitness/trainer/dashboard";
    }

    // TRAINER SUBMIT VERIFICATION POST
    @PostMapping(value = {"/trainer/submitVerification", "/trainer/submit-verification"})
    public String submitTrainerVerification(HttpSession session, RedirectAttributes redirectAttributes) {
        FitnessTrainer sessionTrainer = getSessionTrainer(session);
        if (sessionTrainer == null) return "redirect:/fitness/trainer/login";
        session.removeAttribute("postLoginOpenProfile");

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

        // If approved by admin, always stay on dashboard, don't force profile completion redirect
        if (in.sp.main.Service.FitnessTrainerProfileService.isApproved(trainer)) {
            session.removeAttribute("postLoginOpenProfile");
        } else if (Boolean.TRUE.equals(session.getAttribute("postLoginOpenProfile"))) {
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
            @RequestParam("bookingId") Long bookingId,
            @RequestParam("action") String action,
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

    // TRAINER MARK SESSION ATTENDANCE & DEDUCT PASS CREDITS
    @PostMapping("/trainer/attendance/mark")
    @Transactional
    public String markTrainerAttendance(
            @RequestParam("bookingId") Long bookingId,
            @RequestParam(value = "sessionDate", required = false) String sessionDate,
            @RequestParam(value = "sessionTime", required = false) String sessionTime,
            @RequestParam(value = "status", defaultValue = "PRESENT") String status,
            @RequestParam(value = "notes", required = false) String notes,
            HttpSession session, RedirectAttributes redirectAttributes) {

        FitnessTrainer trainer = getSessionTrainer(session);
        if (trainer == null) return "redirect:/fitness/trainer/login";

        LocalDate date = (sessionDate != null && !sessionDate.trim().isEmpty())
                ? LocalDate.parse(sessionDate.trim()) : LocalDate.now();

        try {
            fitnessService.markAttendance(trainer, bookingId, date, sessionTime, status, notes);
            redirectAttributes.addFlashAttribute("success", "Session check-in recorded successfully! 1 pass credit deducted.");
        } catch (org.springframework.web.server.ResponseStatusException rse) {
            redirectAttributes.addFlashAttribute("error", rse.getReason());
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Unable to record attendance: " + e.getMessage());
        }

        return "redirect:/fitness/trainer/dashboard";
    }

    // UPDATE TRAINER PROFILE SCHEDULE
    @PostMapping("/trainer/update-schedule")
    @Transactional
    public String updateTrainerSchedule(
            @RequestParam("sessionFees") Double sessionFees,
            @RequestParam("availableTimings") String availableTimings,
            @RequestParam("specializations") List<String> specializations,
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
            @RequestParam("fullName") String fullName,
            @RequestParam("phone") String phone,
            @RequestParam("experience") Integer experience,
            @RequestParam("sessionFees") Double sessionFees,
            @RequestParam("availableTimings") String availableTimings,
            @RequestParam(value = "specializations", required = false) List<String> specializations,
            @RequestParam(value = "bio", required = false) String bio,
            @RequestParam(value = "profilePhoto", required = false) MultipartFile profilePhoto,
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
            @RequestParam("className") String className,
            @RequestParam("category") String category,
            @RequestParam("description") String description,
            @RequestParam("classDate") String classDate,
            @RequestParam("classTime") String classTime,
            @RequestParam("durationMinutes") Integer durationMinutes,
            @RequestParam("sessionType") String sessionType,
            @RequestParam("maxCapacity") String maxCapacity,
            @RequestParam("price") String price,
            @RequestParam(value = "meetingLinkOrLocation", required = false) String meetingLinkOrLocation,
            HttpSession session, RedirectAttributes redirectAttributes) {

        FitnessTrainer trainer = getSessionTrainer(session);
        if (trainer == null) return "redirect:/fitness/trainer/login";

        if (trainer.getPartnerProfileStatus() != PartnerProfileStatus.APPROVED && trainer.getVerificationStatus() != VerificationStatus.VERIFIED) {
            redirectAttributes.addFlashAttribute("error", "Your profile must be approved before you can create classes.");
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
            @RequestParam("classId") Long classId,
            @RequestParam("className") String className,
            @RequestParam("category") String category,
            @RequestParam("description") String description,
            @RequestParam("classDate") String classDate,
            @RequestParam("classTime") String classTime,
            @RequestParam("durationMinutes") Integer durationMinutes,
            @RequestParam("sessionType") String sessionType,
            @RequestParam("maxCapacity") String maxCapacity,
            @RequestParam("price") String price,
            @RequestParam(value = "meetingLinkOrLocation", required = false) String meetingLinkOrLocation,
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
            @RequestParam("classId") Long classId,
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
            @RequestParam("classId") Long classId,
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
            @RequestParam("bookingId") Long bookingId,
            @RequestParam("rating") Integer rating,
            @RequestParam("comment") String comment,
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
            @RequestParam(value = "packageId", required = false) Long packageId,
            @RequestParam("packageName") String packageName,
            @RequestParam("category") String category,
            @RequestParam(value = "description", required = false) String description,
            @RequestParam(value = "sessionCount", defaultValue = "1") Integer sessionCount,
            @RequestParam(value = "durationDays", defaultValue = "30") Integer durationDays,
            @RequestParam(value = "price", defaultValue = "0.0") Double price,
            @RequestParam(value = "sessionType", defaultValue = "OFFLINE") String sessionType,
            HttpSession session, RedirectAttributes redirectAttributes) {

        FitnessTrainer trainer = getSessionTrainer(session);
        if (trainer == null) return "redirect:/fitness/trainer/login";

        if (trainer.getPartnerProfileStatus() != PartnerProfileStatus.APPROVED && trainer.getVerificationStatus() != VerificationStatus.VERIFIED) {
            redirectAttributes.addFlashAttribute("error", "Your profile must be approved before you can create packages.");
            return "redirect:/fitness/trainer/dashboard";
        }

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
            @PathVariable("id") Long id,
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
            @PathVariable("id") Long id,
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
            @PathVariable("id") Long id, HttpSession session) {
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
            @PathVariable("id") Long id, HttpSession session) {
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

    // CLIENT FITNESS QR / SESSION CODE CHECK-IN
    @PostMapping({"/api/qr-checkin", "/user/check-in", "/fitness/api/qr-checkin", "/fitness/user/check-in"})
    @ResponseBody
    public org.springframework.http.ResponseEntity<?> clientFitnessCheckIn(
            @RequestBody Map<String, Object> body,
            HttpSession session) {
        User user = getSessionUser(session);
        if (user == null) {
            return org.springframework.http.ResponseEntity.status(org.springframework.http.HttpStatus.UNAUTHORIZED)
                    .body(Map.of("success", false, "error", "Please sign in to check in"));
        }

        String token = body == null ? "" : String.valueOf(body.getOrDefault("token", "")).trim();
        if (token.isEmpty()) {
            return org.springframework.http.ResponseEntity.badRequest().body(Map.of("success", false, "error", "Session code / QR token is required"));
        }

        Double lat = null;
        Double lng = null;
        if (body != null) {
            if (body.get("latitude") != null) lat = Double.parseDouble(body.get("latitude").toString());
            if (body.get("longitude") != null) lng = Double.parseDouble(body.get("longitude").toString());
        }

        try {
            Map<String, Object> res = fitnessQrAttendanceService.checkInClient(user, token, lat, lng);
            return org.springframework.http.ResponseEntity.ok(res);
        } catch (org.springframework.web.server.ResponseStatusException ex) {
            return org.springframework.http.ResponseEntity.status(ex.getStatusCode()).body(Map.of("success", false, "error", ex.getReason()));
        } catch (Exception ex) {
            return org.springframework.http.ResponseEntity.badRequest().body(Map.of("success", false, "error", ex.getMessage() == null ? "Check-in failed" : ex.getMessage()));
        }
    }

    // ==========================================
    // CLIENT PROGRESS TRACKING
    // ==========================================

    @PostMapping("/trainer/progress/log")
    @Transactional
    public String logClientProgress(
            @RequestParam("userId") Long userId,
            @RequestParam(value = "weightKg", required = false) Double weightKg,
            @RequestParam(value = "bodyFatPct", required = false) Double bodyFatPct,
            @RequestParam(value = "workoutsCompleted", defaultValue = "1") Integer workoutsCompleted,
            @RequestParam(value = "metricsJson", required = false) String metricsJson,
            @RequestParam(value = "workoutNotes", required = false) String workoutNotes,
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
            @RequestParam("bookingId") Long bookingId,
            @RequestParam("newDate") String newDate,
            @RequestParam("newTime") String newTime,
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
            @RequestParam("packageId") Long packageId,
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
        return "redirect:/fitness/bookings";
    }
}


