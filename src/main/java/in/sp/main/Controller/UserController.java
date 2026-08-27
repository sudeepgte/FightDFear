package in.sp.main.Controller;

import java.io.IOException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.fasterxml.jackson.databind.ObjectMapper;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import in.sp.main.Entities.Enrollment;
import in.sp.main.Entities.Gender;
import in.sp.main.Entities.Salon;
import in.sp.main.Entities.Stylist;
import in.sp.main.Entities.User;
import in.sp.main.Entities.VerificationStatus;
import in.sp.main.Entities.Videoupload;
import in.sp.main.Entities.TrainingStatus;
import in.sp.main.Entities.Attendance;
import in.sp.main.Entities.AttendanceStatus;
import in.sp.main.Entities.OnlineClass;
import in.sp.main.Entities.TrainingSession;
import in.sp.main.Entities.MartialArtsBatch;
import in.sp.main.Entities.MartialArtsCenter;
import in.sp.main.Repository.AttendanceRepository;
import in.sp.main.Repository.OnlineClassRepository;
import in.sp.main.Repository.TrainingSessionRepository;
import in.sp.main.Repository.BookingRepository;
import in.sp.main.Repository.EnrollmentRepository;
import in.sp.main.Repository.ReviewRepository;
import in.sp.main.Repository.SalonRepository;
import in.sp.main.Repository.StylistRepository;
import in.sp.main.Repository.StylistServiceRepository;
import in.sp.main.Repository.UserRepository;
import in.sp.main.Repository.VideoUploadRepository;
import in.sp.main.Repository.BroadcastMessageRepository;
import in.sp.main.Repository.DangerPointRepository;
import in.sp.main.Entities.BroadcastMessage;
import in.sp.main.Entities.DangerPoint;
import in.sp.main.Entities.EmergencyContact;
import in.sp.main.Service.FileUploadService;
import in.sp.main.Service.MartialArtsCenterService;
import in.sp.main.Service.ServiceService;
import in.sp.main.Service.UserFollowService;
import in.sp.main.Service.UserNotificationService;
import in.sp.main.Service.UserService;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.annotation.Transactional;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import in.sp.main.Service.PasswordService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@Controller
@RequestMapping("/users")
public class UserController {
    private static final Logger log = LoggerFactory.getLogger(UserController.class);

    // Purpose: provide Google Maps API key to JSP pages without hardcoding it in views.
    @Value("${google.maps.apiKey:}")
    private String googleMapsApiKey;

    @Autowired
    private UserService userService;
    @Autowired
    private UserRepository userRepository;
    @Autowired
    private EnrollmentRepository enrollmentRepository;
    @Autowired
    private in.sp.main.Service.BeltGradingService beltGradingService;
    @Autowired
    private FileUploadService fileUploadService;

    @Autowired
    private PasswordService passwordService;
    
    @Autowired
    private UserFollowService followService;
    @Autowired
    private SalonRepository salonRepository;
    @Autowired
    private VideoUploadRepository videoRepository;

    @Autowired
    private BroadcastMessageRepository broadcastMessageRepository;

    @Autowired
    private UserNotificationService userNotificationService;

    @Autowired
    private StylistRepository stylistRepository;

    @Autowired
    private UserFollowService userfollowService;

    @Autowired
    private AttendanceRepository attendanceRepository;

    @Autowired
    private OnlineClassRepository onlineClassRepository;

    @Autowired
    private TrainingSessionRepository trainingSessionRepository;

    @Autowired
    private MartialArtsCenterService martialArtsCenterService;



    @Autowired
    private in.sp.main.Repository.JobApplicationRepository jobApplicationRepository;

    @Autowired
    private in.sp.main.Repository.WorkerBookingRepository workerBookingRepo;

    @Autowired
    private in.sp.main.Repository.FitnessClassRepository fitnessClassRepository;

    @Autowired
    private in.sp.main.Repository.FitnessBookingRepository fitnessBookingRepository;

    @Autowired
    private in.sp.main.Repository.FitnessReviewRepository fitnessReviewRepository;

    @Autowired
    private DangerPointRepository dangerPointRepository;

    @Autowired
    private ObjectMapper objectMapper;

    @Autowired
    private in.sp.main.Service.OtpVerificationService otpVerificationService;

    @org.springframework.beans.factory.annotation.Value("${otp.expiration-minutes:10}")
    private int otpExpirationMinutes;

    @GetMapping("/training-journey")
    public String showTrainingJourney(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) return "redirect:/login";

        List<Enrollment> enrollments = enrollmentRepository.findByUser(user);
        Enrollment activeEnrollment = enrollments.stream()
            .filter(e -> e.getStatus() == null || e.getStatus() != TrainingStatus.COMPLETED)
            .findFirst()
            .orElse(enrollments.isEmpty() ? null : enrollments.get(0));

        List<Attendance> attendances = attendanceRepository.findByUser(user);
        
        long totalClasses = attendances.size();
        long attendedCount = attendances.stream()
            .filter(a -> a.getStatus() == AttendanceStatus.PRESENT || a.getStatus() == AttendanceStatus.LATE)
            .count();
        long presentCount = attendances.stream().filter(a -> a.getStatus() == AttendanceStatus.PRESENT).count();
        long absentCount = attendances.stream().filter(a -> a.getStatus() == AttendanceStatus.ABSENT).count();
        long lateCount = attendances.stream().filter(a -> a.getStatus() == AttendanceStatus.LATE).count();

        double attendancePercentage = totalClasses == 0 ? 0.0 : ((double) attendedCount / (double) totalClasses) * 100.0;

        // Calculate Training Hours
        double totalHours = attendances.stream()
            .filter(a -> a.getStatus() == AttendanceStatus.PRESENT || a.getStatus() == AttendanceStatus.LATE)
            .mapToDouble(a -> {
                if (a.getSession() != null) {
                    try {
                        String dur = a.getSession().getDuration();
                        return Double.parseDouble(dur.split(" ")[0]);
                    } catch (Exception e) { return 1.0; }
                }
                return 1.0; // Default 1 hour for online
            }).sum();

        // Training Streak
        int streak = calculateStreak(attendances);

        // Upcoming Class
        List<MartialArtsBatch> userBatches = enrollments.stream()
            .map(Enrollment::getBatch)
            .filter(java.util.Objects::nonNull)
            .collect(java.util.stream.Collectors.toList());

        List<OnlineClass> upcomingOnline = userBatches.isEmpty() ? new java.util.ArrayList<>() : 
            onlineClassRepository.findByBatchIn(userBatches).stream()
            .filter(oc -> oc.getDate() != null && !oc.getDate().isBefore(LocalDate.now()))
            .sorted(java.util.Comparator.comparing(OnlineClass::getDate))
            .collect(java.util.stream.Collectors.toList());

        model.addAttribute("user", user);
        model.addAttribute("enrollments", enrollments);
        model.addAttribute("activeEnrollment", activeEnrollment);
        model.addAttribute("attendances", attendances);
        model.addAttribute("totalClasses", totalClasses);
        model.addAttribute("attendedCount", attendedCount);
        model.addAttribute("presentCount", presentCount);
        model.addAttribute("absentCount", absentCount);
        model.addAttribute("lateCount", lateCount);
        model.addAttribute("attendancePercentage", String.format("%.1f", attendancePercentage));
        model.addAttribute("totalHours", String.format("%.1f", totalHours));
        model.addAttribute("streak", streak);
        model.addAttribute("upcomingClass", upcomingOnline.isEmpty() ? null : upcomingOnline.get(0));
        
        // Belt from real grading assessments only
        Map<String, Object> beltRadar = beltGradingService.getStudentLatestSkillRadar(user.getId());
        boolean assessed = Boolean.TRUE.equals(beltRadar.get("assessed"));
        String belt = assessed && beltRadar.get("currentBelt") != null
                ? String.valueOf(beltRadar.get("currentBelt"))
                : "Not assessed";
        int beltProgress = 0;
        if (assessed && beltRadar.get("overallScore") instanceof Number) {
            beltProgress = Math.min(100, Math.max(0, ((Number) beltRadar.get("overallScore")).intValue()));
        }
        model.addAttribute("currentBelt", belt);
        model.addAttribute("beltProgress", beltProgress);
        model.addAttribute("beltAssessed", assessed);
        model.addAttribute("beltSkills", beltRadar.get("skills"));
        model.addAttribute("beltTarget", beltRadar.get("targetBelt"));
        model.addAttribute("beltRemarks", beltRadar.get("remarks"));

        return "trainingJourney";
    }

    private int calculateStreak(List<Attendance> attendances) {
        if (attendances.isEmpty()) return 0;
        
        List<LocalDate> dates = attendances.stream()
            .filter(a -> a.getStatus() == AttendanceStatus.PRESENT || a.getStatus() == AttendanceStatus.LATE)
            .map(a -> {
                if (a.getSession() != null) return a.getSession().getDate();
                if (a.getOnlineClass() != null) return a.getOnlineClass().getDate();
                return a.getAttendanceDate();
            })
            .filter(java.util.Objects::nonNull)
            .distinct()
            .sorted(java.util.Comparator.reverseOrder())
            .collect(java.util.stream.Collectors.toList());

        if (dates.isEmpty()) return 0;
        
        int streak = 0;
        LocalDate current = LocalDate.now();
        
        // If they didn't attend today, check if they attended yesterday to continue streak
        if (!dates.get(0).equals(current) && !dates.get(0).equals(current.minusDays(1))) {
            return 0;
        }

        LocalDate nextExpected = dates.get(0);
        for (LocalDate date : dates) {
            if (date.equals(nextExpected)) {
                streak++;
                nextExpected = nextExpected.minusDays(1);
            } else {
                break;
            }
        }
        return streak;
    }

    @GetMapping("/trackenrollments")
    public String showUserDashboard(Model model, HttpSession session) {
        User user = (User) session.getAttribute("user");
        List<Enrollment> enrollments = enrollmentRepository.findByUser(user);
        model.addAttribute("enrollments", enrollments);
        return "enrollmentList";
    }

    @RequestMapping(value = "/{id:[0-9]+}", method = RequestMethod.GET)
    public String getUser(@PathVariable Long id, Model model) {
        User user = userService.getUserById(id);
        model.addAttribute("user", user);
        return "user";
    }

    @RequestMapping(value = "/register", method = RequestMethod.GET)
    public String registerPage(Model model) {
        model.addAttribute("user", new User());
        return "user";
    }

    /**
     * Web member registration — business rules aligned with MobileAuthController (/api/auth/register)
     * and Flutter RegisterScreen. Visual page uses Fitness Web auth styling.
     */
    @RequestMapping(value = "/register", method = RequestMethod.POST)
    public String createUser(@RequestParam(value = "confirmPassword", required = false) String confirmPassword,
                             @RequestParam(value = "acceptedTerms", required = false) String acceptedTerms,
                             HttpServletRequest request,
                             HttpSession session,
                             Model model,
                             RedirectAttributes redirectAttributes) {
        try {
            User user = new User();

            String fullName = trimParam(request.getParameter("fullName"));
            String emailRaw = trimParam(request.getParameter("email"));
            String phone = trimParam(request.getParameter("phoneNumber"));
            String password = request.getParameter("password") == null ? "" : request.getParameter("password");
            String city = trimParam(request.getParameter("city"));
            String dob = trimParam(request.getParameter("dob"));
            String genderRaw = trimParam(request.getParameter("gender"));

            if (acceptedTerms == null || !("true".equalsIgnoreCase(acceptedTerms) || "on".equalsIgnoreCase(acceptedTerms))) {
                model.addAttribute("error", "You must accept the Terms & Conditions and Privacy Policy to register.");
                return "user";
            }

            if (fullName.isEmpty()) {
                model.addAttribute("error", "Full name is required.");
                return "user";
            }

            String emailErr = in.sp.main.Util.MobileValidation.requireEmail(emailRaw);
            if (emailErr != null) {
                model.addAttribute("error", emailErr);
                return "user";
            }
            String normEmail = in.sp.main.Util.MobileValidation.normalizeEmail(emailRaw);

            String phoneErr = in.sp.main.Util.MobileValidation.requirePhone(phone, true);
            if (phoneErr != null) {
                model.addAttribute("error", phoneErr);
                return "user";
            }

            String passErr = in.sp.main.Util.MobileValidation.requirePassword(password);
            if (passErr != null) {
                model.addAttribute("error", passErr);
                return "user";
            }
            String confirmErr = in.sp.main.Util.MobileValidation.requireConfirm(password, confirmPassword);
            if (confirmErr != null) {
                model.addAttribute("error", confirmErr);
                return "user";
            }

            if (city.isEmpty()) {
                model.addAttribute("error", "City / Location is required.");
                return "user";
            }

            if (!dob.isEmpty()) {
                try {
                    LocalDate birthDate = LocalDate.parse(dob);
                    if (birthDate.isAfter(LocalDate.now())) {
                        model.addAttribute("error", "Date of birth cannot be in the future.");
                        return "user";
                    }
                    user.setDob(dob);
                    user.setAge(java.time.Period.between(birthDate, LocalDate.now()).getYears());
                } catch (Exception e) {
                    model.addAttribute("error", "Date of birth must be YYYY-MM-DD.");
                    return "user";
                }
            }

            if (userRepository.findByEmail(normEmail).isPresent()) {
                redirectAttributes.addFlashAttribute("error", "Email already registered. Please sign in.");
                return "redirect:/login";
            }

            if (userRepository.findByPhoneNumber(phone).isPresent()) {
                model.addAttribute("error", "Phone number already registered.");
                return "user";
            }

            if (!isEmailVerifiedForRegistration(session, normEmail)
                    && !otpVerificationService.hasVerifiedOtp(normEmail,
                    in.sp.main.Entities.OtpPurpose.USER_REGISTER, otpExpirationMinutes)) {
                String emailOtp = trimParam(request.getParameter("emailOtp"));
                if (!emailOtp.isEmpty() && otpVerificationService.verifyOtp(normEmail, emailOtp,
                        in.sp.main.Entities.OtpPurpose.USER_REGISTER)) {
                    session.setAttribute("REG_VERIFIED_EMAIL", normEmail);
                } else {
                    model.addAttribute("error", "Email not verified. Please verify the OTP sent to your email first.");
                    return "user";
                }
            }

            user.setFullName(fullName);
            user.setEmail(normEmail);
            user.setPhoneNumber(phone);
            user.setCity(city);
            user.setPassword(passwordService.encode(password));
            user.setVerificationStatus(VerificationStatus.VERIFIED);
            user.setIdentityDocument("web-member|lang:English");

            if (!genderRaw.isEmpty()) {
                try {
                    Gender g = Gender.valueOf(genderRaw.toUpperCase());
                    if (g == Gender.MALE) {
                        model.addAttribute("error", "Registration is restricted to Female / Other.");
                        return "user";
                    }
                    user.setGender(g);
                } catch (IllegalArgumentException e) {
                    model.addAttribute("error", "Gender must be FEMALE or OTHER.");
                    return "user";
                }
            }

            userService.createUser(user);

            otpVerificationService.consumeVerifiedOtp(normEmail,
                    in.sp.main.Entities.OtpPurpose.USER_REGISTER, otpExpirationMinutes);
            session.removeAttribute("REG_VERIFIED_EMAIL");

            session.setAttribute("regPrefillEmail", normEmail);
            session.setAttribute("regPrefillPassword", password);
            session.setAttribute("regSuccessName", fullName);
            session.setAttribute("regSuccessEmail", normEmail);
            session.setAttribute("regSuccessPhone", phone);

            return "redirect:/users/register/success";

        } catch (Exception e) {
            log.error("Registration failed", e);
            String msg = e.getMessage() == null ? "Unknown error" : e.getMessage();
            if (msg.contains("Duplicate") || msg.contains("duplicate") || msg.contains("unique")) {
                model.addAttribute("error", "Email or phone number is already registered.");
            } else {
                model.addAttribute("error", "Registration failed. Please check your details and try again.");
            }
            return "user";
        }
    }

    @GetMapping("/register/success")
    public String registerSuccess(HttpSession session, Model model) {
        Object name = session.getAttribute("regSuccessName");
        Object email = session.getAttribute("regSuccessEmail");
        Object phone = session.getAttribute("regSuccessPhone");
        if (email == null) {
            return "redirect:/login";
        }
        model.addAttribute("regName", name);
        model.addAttribute("regEmail", email);
        model.addAttribute("regPhone", phone);
        session.removeAttribute("regSuccessName");
        session.removeAttribute("regSuccessEmail");
        session.removeAttribute("regSuccessPhone");
        return "userRegisterSuccess";
    }

    private static String trimParam(String v) {
        return v == null ? "" : v.trim();
    }

    private boolean isEmailVerifiedForRegistration(HttpSession session, String normEmail) {
        if (session == null || normEmail == null || normEmail.isBlank()) {
            return false;
        }
        Object verified = session.getAttribute("REG_VERIFIED_EMAIL");
        return normEmail.equals(verified);
    }


    @RequestMapping(value = "/list", method = RequestMethod.GET)
    public String getUserList(Model model) {
        List<User> users = userService.getAllUsers();
        model.addAttribute("users", users);
        return "userList";
    }

    @RequestMapping(method = RequestMethod.POST)
    public String createUserFromForm(@ModelAttribute User user) {
        userService.createUser(user);
        return "redirect:/users/" + user.getId();
    }

    @RequestMapping(value = "/delete/{id}", method = RequestMethod.GET)
    public String deleteUser(@PathVariable Long id) {
        userService.deleteUser(id);
        return "redirect:/users/register";
    }

    @RequestMapping(value = "/profile/{userId}", method = RequestMethod.GET)
    public String getUserProfile(@PathVariable Long userId, Model model) {
        User user = userService.getUserById(userId);
        if (user == null) {
            return "redirect:/login";
        }
        int completionPercentage = calculateCompletionPercentage(user);
        
        List<Videoupload> videos = videoRepository.findByUserId(userId);

        model.addAttribute("user", user);
        model.addAttribute("completionPercentage", completionPercentage);
        
        // Instagram-style counts
        model.addAttribute("postsCount", videos.size());
        model.addAttribute("followersCount", followService.getFollowers(userId).size());
        model.addAttribute("followingCount", followService.getFollowing(userId).size());

        return "user-profile";
    }

    private int calculateCompletionPercentage(User user) {
        // Shared web/mobile-compatible fields for member profile completeness.
        int totalFields = 8;
        int filledFields = 0;

        if (user.getFullName() != null && !user.getFullName().isBlank()) filledFields++;
        if (user.getEmail() != null && !user.getEmail().isBlank()) filledFields++;
        if (user.getPhoneNumber() != null && !user.getPhoneNumber().isBlank()) filledFields++;
        if (user.getHomeAddress() != null && !user.getHomeAddress().isBlank()) filledFields++;
        if (user.getDob() != null && !user.getDob().isBlank()) filledFields++;
        if (user.getGender() != null) filledFields++;
        if (user.getProfilePhoto() != null && !user.getProfilePhoto().isBlank()) filledFields++;
        try {
            if (user.getEmergencyContacts() != null && !user.getEmergencyContacts().isEmpty()) filledFields++;
        } catch (Exception ignored) {
            // Lazy collection may be unavailable outside transaction
        }

        return (filledFields * 100) / totalFields;
    }

    private java.util.List<String> missingProfileItems(User user) {
        java.util.List<String> missing = new java.util.ArrayList<>();
        if (user.getFullName() == null || user.getFullName().isBlank()) missing.add("Full name");
        if (user.getEmail() == null || user.getEmail().isBlank()) missing.add("Email");
        if (user.getPhoneNumber() == null || user.getPhoneNumber().isBlank()) missing.add("Phone number");
        if (user.getHomeAddress() == null || user.getHomeAddress().isBlank()) missing.add("Location / address");
        if (user.getDob() == null || user.getDob().isBlank()) missing.add("Date of birth");
        if (user.getGender() == null) missing.add("Gender");
        if (user.getProfilePhoto() == null || user.getProfilePhoto().isBlank()) missing.add("Profile photo");
        try {
            if (user.getEmergencyContacts() == null || user.getEmergencyContacts().isEmpty()) {
                missing.add("Emergency contact");
            }
        } catch (Exception ignored) {
            missing.add("Emergency contact");
        }
        return missing;
    }

    @RequestMapping(value = "/profile1/{userId}", method = RequestMethod.GET)
    public String getUserProfile(
            @PathVariable Long userId,
            Model model,
            HttpSession session) {

        User profileUser = userService.getUserById(userId);
        if (profileUser == null) return "redirect:/video/reels";

        User currentUser = (User) session.getAttribute("user");
        
        boolean isFollowing = false;
        boolean isPending = false;
        boolean isFriend = false;
        boolean hasIncomingRequest = false;
        if (currentUser != null) {
            isFollowing = followService.isAcceptedFollower(currentUser.getId(), profileUser.getId());
            isPending = followService.isPendingRequest(currentUser.getId(), profileUser.getId());
            isFriend = followService.getFriends(currentUser.getId()).contains(profileUser);
            hasIncomingRequest = followService.isPendingRequest(profileUser.getId(), currentUser.getId());
        }

        int completionPercentage = calculateCompletionPercentage(profileUser);
        List<Videoupload> profileUserVideos = videoRepository.findByUser_Id(profileUser.getId());

        model.addAttribute("user", profileUser);
        model.addAttribute("currentUser", currentUser);
        model.addAttribute("completionPercentage", completionPercentage);
        model.addAttribute("videos", profileUserVideos);

        // Instagram-style counts
        model.addAttribute("postsCount", profileUserVideos.size());
        model.addAttribute("followersCount", followService.getFollowers(userId).size());
        model.addAttribute("followingCount", followService.getFollowing(userId).size());
        model.addAttribute("friendsCount", followService.getFriends(userId).size());

        model.addAttribute("isFollowing", isFollowing);
        model.addAttribute("isPending", isPending);
        model.addAttribute("isFriend", isFriend);
        model.addAttribute("hasIncomingRequest", hasIncomingRequest);

        return "user-profile1";
    }

    @RequestMapping(value = "/dashboard", method = RequestMethod.GET)
    public String showDashboard(HttpSession session, Model model) {

        User loggedInUser = (User) session.getAttribute("user");

        if (loggedInUser == null) {
            return "redirect:/login";
        }

        // Refresh user from DB so profile completion reflects latest fields
        User fresh = userService.getUserById(loggedInUser.getId());
        final User currentUser = fresh != null ? fresh : loggedInUser;
        if (fresh != null) {
            session.setAttribute("user", fresh);
        }

        int requestCount = userfollowService.getPendingRequestCount(currentUser.getId());

        List<Salon> salons = salonRepository.findAll();
        List<Stylist> independentStylists = stylistRepository.findByIsIndependent(true);

        model.addAttribute("user", currentUser);
        model.addAttribute("requestCount", requestCount); // 🔔 IMPORTANT
        model.addAttribute("salons", salons);
        model.addAttribute("independentStylists", independentStylists);

        int profileCompletionPct = calculateCompletionPercentage(currentUser);
        model.addAttribute("profileCompletionPct", profileCompletionPct);
        model.addAttribute("profileMissingItems", missingProfileItems(currentUser));

        List<Enrollment> userEnrollments = enrollmentRepository.findByUser(currentUser);
        model.addAttribute("userEnrollments", userEnrollments);
        model.addAttribute("activeEnrollmentCount", userEnrollments == null ? 0 : userEnrollments.size());

        List<in.sp.main.Entities.FitnessBooking> allFitnessBookings =
                fitnessBookingRepository.findByUser_Id(currentUser.getId());
        long upcomingFitnessCount = allFitnessBookings.stream()
                .filter(b -> b.getStatus() != null
                        && !"CANCELLED".equalsIgnoreCase(b.getStatus())
                        && !"REJECTED".equalsIgnoreCase(b.getStatus())
                        && !"COMPLETED".equalsIgnoreCase(b.getStatus()))
                .count();
        model.addAttribute("upcomingFitnessCount", upcomingFitnessCount);

        List<in.sp.main.Entities.FitnessBooking> upcomingFitnessBookings = allFitnessBookings.stream()
                .filter(b -> b.getStatus() != null
                        && !"CANCELLED".equalsIgnoreCase(b.getStatus())
                        && !"REJECTED".equalsIgnoreCase(b.getStatus())
                        && !"COMPLETED".equalsIgnoreCase(b.getStatus()))
                .sorted((a, b) -> {
                    java.time.LocalDate da = a.getBookingDate() != null ? a.getBookingDate() : java.time.LocalDate.MAX;
                    java.time.LocalDate db = b.getBookingDate() != null ? b.getBookingDate() : java.time.LocalDate.MAX;
                    return da.compareTo(db);
                })
                .limit(5)
                .collect(java.util.stream.Collectors.toList());
        model.addAttribute("upcomingFitnessBookings", upcomingFitnessBookings);
        
        List<BroadcastMessage> broadcasts = broadcastMessageRepository.findAllByOrderBySentAtDesc();
        model.addAttribute("recentBroadcasts", broadcasts);
        
        long unreadCount = 0;
        if (currentUser.getLastReadBroadcastTime() == null) {
            unreadCount = broadcasts.size();
        } else {
            unreadCount = broadcasts.stream()
                .filter(b -> b.getSentAt() != null && b.getSentAt().isAfter(currentUser.getLastReadBroadcastTime()))
                .count();
        }
        model.addAttribute("unreadBroadcastCount", unreadCount);
        
        // Purpose: let userDashboard.jsp load Google Maps JS API (heatmap + directions).
        model.addAttribute("googleMapsApiKey", googleMapsApiKey);

        List<MartialArtsCenter> approvedCentres = martialArtsCenterService.getApprovedCentersForDiscovery();
        model.addAttribute("approvedCentres", approvedCentres);
        model.addAttribute("approvedCentreCount", approvedCentres.size());



        boolean isWorker = jobApplicationRepository.findByStatus(in.sp.main.Entities.VerificationStatus.VERIFIED)
                .stream().anyMatch(app -> app.getUser().getId().equals(currentUser.getId()));
        model.addAttribute("isWorker", isWorker);

        if (isWorker) {
            List<in.sp.main.Entities.WorkerBooking> incomingBookings = workerBookingRepo.findByJobApplication_User_Id(currentUser.getId());
            model.addAttribute("incomingBookings", incomingBookings);
        }

        // Fetch upcoming active fitness classes
        List<in.sp.main.Entities.FitnessClass> upcomingClasses = fitnessClassRepository
                .findByClassDateGreaterThanEqualAndStatusOrderByClassDateAsc(LocalDate.now(), "ACTIVE")
                .stream()
                .filter(c -> c.getCurrentEnrollment() < c.getMaxCapacity())
                .limit(5)
                .collect(java.util.stream.Collectors.toList());
        model.addAttribute("upcomingFitnessClasses", upcomingClasses);

        // Fetch completed fitness bookings that haven't been reviewed yet
        List<in.sp.main.Entities.FitnessBooking> myBookings = fitnessBookingRepository.findByUser_Id(currentUser.getId());
        List<in.sp.main.Entities.FitnessBooking> completedBookings = myBookings.stream()
                .filter(b -> b.getFitnessClass() != null)
                .filter(b -> b.getFitnessClass().getClassDate().isBefore(LocalDate.now()) || "COMPLETED".equals(b.getStatus()))
                .filter(b -> !fitnessReviewRepository.existsByBooking_Id(b.getId()))
                .collect(java.util.stream.Collectors.toList());
        model.addAttribute("completedFitnessBookings", completedBookings);

        // Fetch active personal coaching subscriptions
        List<in.sp.main.Entities.FitnessBooking> activeSubs = myBookings.stream()
                .filter(b -> b.getFitnessClass() == null)
                .filter(b -> "APPROVED".equals(b.getStatus()))
                .collect(java.util.stream.Collectors.toList());
        model.addAttribute("activeSubscriptions", activeSubs);

        List<User> allUsers = userRepository.findAll();
        int age17to30 = 0;
        int age31to50 = 0;
        int age51plus = 0;
        int maleCount = 0;
        int femaleCount = 0;
        for (User u : allUsers) {
            if (u.getGender() != null) {
                if (u.getGender() == Gender.MALE) maleCount++;
                else if (u.getGender() == Gender.FEMALE) femaleCount++;
            }
            if (u.getAge() == null) {
                continue;
            }
            if (u.getAge() >= 17 && u.getAge() <= 30) {
                age17to30++;
            } else if (u.getAge() >= 31 && u.getAge() <= 50) {
                age31to50++;
            } else if (u.getAge() >= 51) {
                age51plus++;
            }
        }
        int demoTotal = age17to30 + age31to50 + age51plus;
        int genderTotal = maleCount + femaleCount;
        
        model.addAttribute("malePct", genderTotal == 0 ? 0 : Math.round(100f * maleCount / genderTotal));
        model.addAttribute("femalePct", genderTotal == 0 ? 0 : Math.round(100f * femaleCount / genderTotal));

        model.addAttribute("demoAge17to30Count", age17to30);
        model.addAttribute("demoAge31to50Count", age31to50);
        model.addAttribute("demoAge51PlusCount", age51plus);
        model.addAttribute("demoAge17to30Pct", demoTotal == 0 ? 0 : Math.round(100f * age17to30 / demoTotal));
        model.addAttribute("demoAge31to50Pct", demoTotal == 0 ? 0 : Math.round(100f * age31to50 / demoTotal));
        model.addAttribute("demoAge51PlusPct", demoTotal == 0 ? 0 : Math.round(100f * age51plus / demoTotal));

        List<DangerPoint> mapPoints = dangerPointRepository.findTop500ByVerifiedOrderByCreatedAtDesc(true);
        if (mapPoints.isEmpty()) {
            mapPoints = dangerPointRepository.findTop500ByOrderByCreatedAtDesc();
        }
        List<Map<String, Object>> dangerMapData = new ArrayList<>();
        for (DangerPoint p : mapPoints) {
            Map<String, Object> point = new HashMap<>();
            point.put("lat", p.getLatitude());
            point.put("lng", p.getLongitude());
            point.put("category", p.getCategory());
            point.put("note", p.getNote());
            dangerMapData.add(point);
        }
        try {
            model.addAttribute("dangerMapPointsJson", objectMapper.writeValueAsString(dangerMapData));
        } catch (Exception ex) {
            model.addAttribute("dangerMapPointsJson", "[]");
        }
        model.addAttribute("dangerMapPointCount", dangerMapData.size());

        java.time.LocalTime now = java.time.LocalTime.now();
        String greeting = now.getHour() < 12 ? "Good morning"
                : (now.getHour() < 17 ? "Good afternoon" : "Good evening");
        model.addAttribute("dayGreeting", greeting);

        return "userDashboard";
    }

    @GetMapping("/notifications")
    @ResponseBody
    @Transactional(readOnly = true)
    public ResponseEntity<Map<String, Object>> notifications(HttpSession session) {
        User loggedInUser = (User) session.getAttribute("user");
        if (loggedInUser == null) {
            return ResponseEntity.status(401).body(Map.of("success", false, "error", "Unauthorized"));
        }
        User fresh = userRepository.findById(loggedInUser.getId()).orElse(loggedInUser);
        return ResponseEntity.ok(userNotificationService.buildForUser(fresh));
    }

    @RequestMapping(value = "/broadcast/read", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, Object> markBroadcastsAsRead(HttpSession session) {
        User loggedInUser = (User) session.getAttribute("user");
        if (loggedInUser == null) {
            return Map.of("success", false, "error", "Unauthorized");
        }
        userNotificationService.markAllRead(loggedInUser);
        User fresh = userRepository.findById(loggedInUser.getId()).orElse(loggedInUser);
        session.setAttribute("user", fresh);
        return Map.of("success", true);
    }

    @RequestMapping(value = "/update/{id}", method = RequestMethod.GET)
    public String showUpdateForm(@PathVariable Long id, Model model, HttpSession session) {
        User sessionUser = (User) session.getAttribute("user");
        if (sessionUser == null || !sessionUser.getId().equals(id)) {
            session.setAttribute("redirectAfterLogin", "/users/update/" + id);
            return "redirect:/login";
        }
        User user = userService.getUserByIdForProfileForm(id);
        if (user == null) {
            return "redirect:/login";
        }
        String lang = "English";
        if (user.getIdentityDocument() != null && user.getIdentityDocument().contains("lang:")) {
            int idx = user.getIdentityDocument().indexOf("lang:");
            lang = user.getIdentityDocument().substring(idx + 5);
            if (lang.contains("|")) {
                lang = lang.substring(0, lang.indexOf("|"));
            }
        }
        model.addAttribute("preferredLanguage", lang.trim());
        model.addAttribute("user", user);
        model.addAttribute("profileCompletionPct", calculateCompletionPercentage(user));
        model.addAttribute("profileMissingItems", missingProfileItems(user));
        return "userUpdateForm";
    }

    @RequestMapping(value = "/update/{id}", method = RequestMethod.POST)
    public String updateUser(@PathVariable Long id,
                             @RequestParam("name") String name,
                             @RequestParam("email") String email,
                             @RequestParam("phone") String phone,
                             @RequestParam(value = "city", required = false) String city,
                             @RequestParam(value = "address", required = false) String address,
                             @RequestParam(value = "dob", required = false) String dob,
                             @RequestParam(value = "gender", required = false) String gender,
                             @RequestParam(value = "isPrivate", defaultValue = "false") boolean isPrivate,
                             @RequestParam(value = "confirmSave", required = false) String confirmSave,
                             @RequestParam(value = "identityFile", required = false) MultipartFile identityFile,
                             @RequestParam(value = "image", required = false) MultipartFile image,
                             @RequestParam(value = "emergencyContactName", required = false) String emergencyContactName,
                             @RequestParam(value = "emergencyContactPhone", required = false) String emergencyContactPhone,
                             @RequestParam(value = "emergencyContactRelation", required = false) String emergencyContactRelation,
                             @RequestParam(value = "workCollegeAddress", required = false) String workCollegeAddress,
                             @RequestParam(value = "bloodGroup", required = false) String bloodGroup,
                             @RequestParam(value = "allergies", required = false) String allergies,
                             @RequestParam(value = "medicalHistory", required = false) String medicalHistory,
                             @RequestParam(value = "medications", required = false) String medications,
                             @RequestParam(value = "preferredLanguage", required = false) String preferredLanguage,
                             @RequestParam(value = "safetyPreferences", required = false) String safetyPreferences,
                             HttpSession session,
                             RedirectAttributes redirectAttributes) throws IOException {

        User sessionUser = (User) session.getAttribute("user");
        if (sessionUser == null || !sessionUser.getId().equals(id)) {
            return "redirect:/login";
        }

        User existingUser = userService.getUserByIdForProfileForm(id);
        if (existingUser == null) {
            return "error";
        }

        if (confirmSave == null || !"true".equalsIgnoreCase(confirmSave)) {
            redirectAttributes.addFlashAttribute("error", "Please confirm your profile preview before saving.");
            return "redirect:/users/update/" + id;
        }

        if (phone == null || !phone.trim().matches("^\\d{10}$")) {
            redirectAttributes.addFlashAttribute("error", "Phone number must be exactly 10 digits.");
            return "redirect:/users/update/" + id;
        }

        if (dob != null && !dob.isBlank()) {
            try {
                LocalDate birthDate = LocalDate.parse(dob);
                if (birthDate.isAfter(LocalDate.now()) || birthDate.isBefore(LocalDate.now().minusYears(100))) {
                    redirectAttributes.addFlashAttribute("error", "Invalid date of birth.");
                    return "redirect:/users/update/" + id;
                }
                int calculatedAge = java.time.Period.between(birthDate, LocalDate.now()).getYears();
                existingUser.setDob(dob);
                existingUser.setAge(calculatedAge);
            } catch (Exception ex) {
                redirectAttributes.addFlashAttribute("error", "Invalid date of birth format.");
                return "redirect:/users/update/" + id;
            }
        } else {
            existingUser.setDob(null);
            existingUser.setAge(null);
        }

        existingUser.setFullName(name);
        existingUser.setPhoneNumber(phone.trim());
        existingUser.setHomeAddress(address);
        existingUser.setPrivate(isPrivate);
        existingUser.setWorkCollegeAddress(workCollegeAddress);
        existingUser.setSafetyPreferences(safetyPreferences);
        if (city != null) {
            existingUser.setCity(city.trim());
        }

        if (gender != null && !gender.isBlank()) {
            try {
                Gender g = Gender.valueOf(gender.toUpperCase());
                if (g == Gender.MALE) {
                    redirectAttributes.addFlashAttribute("error", "Gender is restricted to Female / Other.");
                    return "redirect:/users/update/" + id;
                }
                existingUser.setGender(g);
            } catch (IllegalArgumentException e) {
                redirectAttributes.addFlashAttribute("error", "Invalid gender value.");
                return "redirect:/users/update/" + id;
            }
        } else {
            existingUser.setGender(null);
        }

        // Create/Update Emergency Contact
        if (emergencyContactName != null && !emergencyContactName.isBlank() &&
            emergencyContactPhone != null && !emergencyContactPhone.isBlank()) {
            
            if (!emergencyContactPhone.trim().matches("^\\d{10}$")) {
                redirectAttributes.addFlashAttribute("error", "Emergency contact phone must be exactly 10 digits.");
                return "redirect:/users/update/" + id;
            }
            if (emergencyContactPhone.trim().equals(phone.trim())) {
                redirectAttributes.addFlashAttribute("error", "Emergency contact phone should differ from your phone number.");
                return "redirect:/users/update/" + id;
            }

            List<EmergencyContact> contactList = existingUser.getEmergencyContacts();
            EmergencyContact primaryContact = (contactList != null && !contactList.isEmpty()) ? contactList.get(0) : null;
            if (primaryContact == null) {
                primaryContact = new EmergencyContact();
                primaryContact.setUser(existingUser);
                if (contactList == null) {
                    contactList = new ArrayList<>();
                    existingUser.setEmergencyContacts(contactList);
                }
                contactList.add(primaryContact);
            }
            primaryContact.setName(emergencyContactName.trim());
            primaryContact.setPhone(emergencyContactPhone.trim());
            primaryContact.setRelation(emergencyContactRelation != null ? emergencyContactRelation.trim() : "Other");
        }

        // Create/Update Medical Details
        in.sp.main.Entities.MedicalDetails medical = existingUser.getMedicalDetails();
        if (medical == null) {
            medical = new in.sp.main.Entities.MedicalDetails();
            medical.setUser(existingUser);
            existingUser.setMedicalDetails(medical);
        }
        medical.setBloodGroup(bloodGroup != null ? bloodGroup.trim() : "");
        medical.setAllergies(allergies != null ? allergies.trim() : "");
        medical.setMedicalHistory(medicalHistory != null ? medicalHistory.trim() : "");
        medical.setMedications(medications != null ? medications.trim() : "");

        if (preferredLanguage != null && !preferredLanguage.isBlank()) {
            existingUser.setIdentityDocument("web-member|lang:" + preferredLanguage.trim());
        }

        if (identityFile != null && !identityFile.isEmpty()) {
            String identityDocUrl = fileUploadService.saveFile(identityFile);
            existingUser.setIdentityDocument(identityDocUrl);
        }

        if (image != null && !image.isEmpty()) {
            String profilePhotoUrl = fileUploadService.saveFile(image);
            existingUser.setProfilePhoto(profilePhotoUrl);
        }

        userService.updateUser(id, existingUser);
        User savedUser = userService.getUserById(id);
        session.setAttribute("user", savedUser != null ? savedUser : existingUser);
        redirectAttributes.addFlashAttribute("success", "Profile updated successfully.");
        return "redirect:/users/profile/" + id;
    }
}
