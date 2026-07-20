package in.sp.main.Controller;

import java.io.IOException;
import java.time.LocalDate;
import java.util.List;

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
import in.sp.main.Entities.BroadcastMessage;
import in.sp.main.Service.FileUploadService;
import in.sp.main.Service.MartialArtsCenterService;
import in.sp.main.Service.ServiceService;
import in.sp.main.Service.UserFollowService;
import in.sp.main.Service.UserService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import org.springframework.security.crypto.password.PasswordEncoder;
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
    private FileUploadService fileUploadService;

    @Autowired
    private PasswordEncoder passwordEncoder;
    
    @Autowired
    private UserFollowService followService;
    @Autowired
    private SalonRepository salonRepository;
    @Autowired
    private VideoUploadRepository videoRepository;

    @Autowired
    private BroadcastMessageRepository broadcastMessageRepository;

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

    @GetMapping("/training-journey")
    public String showTrainingJourney(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) return "redirect:/login";

        List<Enrollment> enrollments = enrollmentRepository.findByUser(user);
        Enrollment activeEnrollment = enrollments.stream()
            .filter(e -> e.getStatus() != TrainingStatus.COMPLETED)
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
        
        // Belt Logic
        String belt = "Not Started";
        int beltProgress = 0;
        if (attendedCount >= 200) { belt = "Black"; beltProgress = 100; }
        else if (attendedCount >= 100) { belt = "Blue"; beltProgress = 75; }
        else if (attendedCount >= 50) { belt = "Green"; beltProgress = 50; }
        else if (attendedCount >= 25) { belt = "Orange"; beltProgress = 35; }
        else if (attendedCount >= 10) { belt = "Yellow"; beltProgress = 20; }
        else if (attendedCount > 0) { belt = "White"; beltProgress = 10; }
        
        model.addAttribute("currentBelt", belt);
        model.addAttribute("beltProgress", beltProgress);

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

    @RequestMapping(value = "/register", method = RequestMethod.POST)
    public String createUser(@ModelAttribute("user") User user,
                             @RequestParam(value = "image", required = false) MultipartFile image,
                             @RequestParam(value = "identityDoc", required = false) MultipartFile identityDoc,
                             HttpServletRequest request,
                             Model model,
                             RedirectAttributes redirectAttributes) {
        try {
            if (user == null) {
                user = new User();
            }

            // Save profile photo if uploaded
            if (image != null && !image.isEmpty()) {
                String profilePhotoUrl = fileUploadService.saveFile(image);
                user.setProfilePhoto(profilePhotoUrl);
            }

            // Save identity document (mandatory)
            if (identityDoc != null && !identityDoc.isEmpty()) {
                String identityDocUrl = fileUploadService.saveFile(identityDoc);
                user.setIdentityDocument(identityDocUrl);
            } else {
                model.addAttribute("error", "Please upload your identity document.");
                return "user"; // return to the registration page
            }

            // In some multipart setups, @ModelAttribute binding can arrive empty.
            // Fallback to raw request parameters so registration still works for ALL fields.
            if (request != null) {
                if (user.getEmail() == null || user.getEmail().trim().isEmpty()) {
                    user.setEmail(request.getParameter("email"));
                }
                if (user.getPassword() == null || user.getPassword().trim().isEmpty()) {
                    user.setPassword(request.getParameter("password"));
                }
                if (user.getFullName() == null || user.getFullName().trim().isEmpty()) {
                    user.setFullName(request.getParameter("fullName"));
                }
                if (user.getPhoneNumber() == null || user.getPhoneNumber().trim().isEmpty()) {
                    user.setPhoneNumber(request.getParameter("phoneNumber"));
                }
                if (user.getHomeAddress() == null || user.getHomeAddress().trim().isEmpty()) {
                    user.setHomeAddress(request.getParameter("homeAddress"));
                }
                if (user.getDob() == null || user.getDob().trim().isEmpty()) {
                    user.setDob(request.getParameter("dob"));
                }
                if (user.getDob() != null && !user.getDob().trim().isEmpty()) {
                    try {
                        java.time.LocalDate birthDate = java.time.LocalDate.parse(user.getDob());
                        int calculatedAge = java.time.Period.between(birthDate, java.time.LocalDate.now()).getYears();
                        user.setAge(calculatedAge);
                    } catch (Exception e) {
                        String ageParam = request.getParameter("age");
                        if (ageParam != null && !ageParam.isEmpty()) {
                            try { user.setAge(Integer.parseInt(ageParam)); } catch (NumberFormatException ex) {}
                        }
                    }
                } else if (user.getAge() == null) {
                    String ageParam = request.getParameter("age");
                    if (ageParam != null && !ageParam.isEmpty()) {
                        try { user.setAge(Integer.parseInt(ageParam)); } catch (NumberFormatException e) {}
                    }
                }
                if (user.getGender() == null) {
                    String genderParam = request.getParameter("gender");
                    if (genderParam != null && !genderParam.isEmpty()) {
                        try { user.setGender(Gender.valueOf(genderParam.toUpperCase())); } catch (IllegalArgumentException e) {}
                    }
                }
            }

            if (user.getEmail() == null || user.getEmail().trim().isEmpty()) {
                model.addAttribute("error", "Email is required.");
                return "user";
            }

            if (user.getPassword() == null || user.getPassword().trim().isEmpty()) {
                model.addAttribute("error", "Password is required.");
                return "user";
            }

            // Date of Birth Validation
            if (user.getDob() != null && !user.getDob().isEmpty()) {
                LocalDate dob = LocalDate.parse(user.getDob());
                if (dob.isAfter(LocalDate.now())) {
                    model.addAttribute("error", "Date of Birth cannot be in the future.");
                    return "user";
                }
            }

            // Phone validation
            if (user.getPhoneNumber() == null || !user.getPhoneNumber().trim().matches("^\\d{10}$")) {
                model.addAttribute("error", "Phone number must be exactly 10 digits.");
                return "user";
            }

            String rawPassword = user.getPassword().trim();
            if (!rawPassword.matches("^(?=.*[0-9])(?=.*[!@#$%^&*])[a-zA-Z0-9!@#$%^&*]{6,}$")) {
                model.addAttribute("error",
                        "Password must be at least 6 characters long and include a number and special character");
                return "user";
            }

            // Store BCrypt password for security (login supports legacy plain-text too).
            user.setEmail(user.getEmail().trim().toLowerCase());
            user.setPassword(passwordEncoder.encode(rawPassword));

            // Check duplicate email
            if (userRepository.findByEmail(user.getEmail()).isPresent()) {
                redirectAttributes.addFlashAttribute("error", "Email already exists. Please login.");
                return "redirect:/login";
            }

            // Save user into DB
            // Purpose: new users must be verified by admin before Buddy Mode is allowed.
            user.setVerificationStatus(VerificationStatus.PENDING);
            userService.createUser(user);
            redirectAttributes.addFlashAttribute("success", "Registration successful! Please login.");
            return "redirect:/login";

        } catch (IOException e) {
            log.error("File upload error during registration", e);
            model.addAttribute("error", "File upload failed. Please try again.");
            return "user";
        } catch (Exception e) {
            log.error("Registration failed", e);
            model.addAttribute("error", "Registration failed: " + e.getMessage());
            return "user";
        }
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

        int totalCoins = 0;

        
        for (Videoupload v : videos) {
            int score = v.getViewCount()
                       + (v.getLikeCount() * 5)
                       ;
            totalCoins += score;
        }
        model.addAttribute("user", user);
        model.addAttribute("completionPercentage", completionPercentage);
        model.addAttribute("coins", totalCoins);
        
        // Instagram-style counts
        model.addAttribute("postsCount", videos.size());
        model.addAttribute("followersCount", followService.getFollowers(userId).size());
        model.addAttribute("followingCount", followService.getFollowing(userId).size());

        return "user-profile";
    }

    private int calculateCompletionPercentage(User user) {
        int totalFields = 6;
        int filledFields = 0;

        if (user.getFullName() != null && !user.getFullName().isEmpty()) filledFields++;
        if (user.getEmail() != null && !user.getEmail().isEmpty()) filledFields++;
        if (user.getPhoneNumber() != null && !user.getPhoneNumber().isEmpty()) filledFields++;
        if (user.getHomeAddress() != null && !user.getHomeAddress().isEmpty()) filledFields++;
        if (user.getAge() != null) filledFields++;
        if (user.getGender() != null) filledFields++;

        return (filledFields * 100) / totalFields;
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

        int requestCount = userfollowService.getPendingRequestCount(loggedInUser.getId());

        List<Salon> salons = salonRepository.findAll();
        List<Stylist> independentStylists = stylistRepository.findByIsIndependent(true);

        model.addAttribute("user", loggedInUser);
        model.addAttribute("requestCount", requestCount); // 🔔 IMPORTANT
        model.addAttribute("salons", salons);
        model.addAttribute("independentStylists", independentStylists);
        
        List<BroadcastMessage> broadcasts = broadcastMessageRepository.findAllByOrderBySentAtDesc();
        model.addAttribute("recentBroadcasts", broadcasts);
        
        long unreadCount = 0;
        if (loggedInUser.getLastReadBroadcastTime() == null) {
            unreadCount = broadcasts.size();
        } else {
            unreadCount = broadcasts.stream()
                .filter(b -> b.getSentAt() != null && b.getSentAt().isAfter(loggedInUser.getLastReadBroadcastTime()))
                .count();
        }
        model.addAttribute("unreadBroadcastCount", unreadCount);
        
        // Purpose: let userDashboard.jsp load Google Maps JS API (heatmap + directions).
        model.addAttribute("googleMapsApiKey", googleMapsApiKey);

        List<MartialArtsCenter> approvedCentres = martialArtsCenterService.getApprovedCentersForDiscovery();
        model.addAttribute("approvedCentres", approvedCentres);
        model.addAttribute("approvedCentreCount", approvedCentres.size());



        boolean isWorker = jobApplicationRepository.findByStatus(in.sp.main.Entities.VerificationStatus.VERIFIED)
                .stream().anyMatch(app -> app.getUser().getId().equals(loggedInUser.getId()));
        model.addAttribute("isWorker", isWorker);

        if (isWorker) {
            List<in.sp.main.Entities.WorkerBooking> incomingBookings = workerBookingRepo.findByJobApplication_User_Id(loggedInUser.getId());
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
        List<in.sp.main.Entities.FitnessBooking> myBookings = fitnessBookingRepository.findByUser_Id(loggedInUser.getId());
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

        return "userDashboard";
    }

    @RequestMapping(value = "/broadcast/read", method = RequestMethod.POST)
    @ResponseBody
    public String markBroadcastsAsRead(HttpSession session) {
        User loggedInUser = (User) session.getAttribute("user");
        if (loggedInUser != null) {
            loggedInUser.setLastReadBroadcastTime(java.time.LocalDateTime.now());
            userService.updateUser(loggedInUser.getId(), loggedInUser);
            session.setAttribute("user", loggedInUser);
            return "success";
        }
        return "error";
    }

    @RequestMapping(value = "/update/{id}", method = RequestMethod.GET)
    public String showUpdateForm(@PathVariable Long id, Model model) {
        User user = userService.getUserById(id);
        model.addAttribute("user", user);
        return "userUpdateForm";
    }

    @RequestMapping(value = "/update/{id}", method = RequestMethod.POST)
    public String updateUser(@PathVariable Long id,
                             @RequestParam("name") String name,
                             @RequestParam("email") String email,
                             @RequestParam("phone") String phone,
                             @RequestParam("address") String address,
                             @RequestParam("age") Integer age,
                             @RequestParam("gender") String gender,
                             @RequestParam(value = "isPrivate", defaultValue = "false") boolean isPrivate,
                             @RequestParam(value = "identityFile", required = false) MultipartFile identityFile,
                             @RequestParam(value = "image", required = false) MultipartFile image) throws IOException {

        User existingUser = userService.getUserById(id);
        if (existingUser == null) {
            return "error";
        }

        if (phone == null || !phone.trim().matches("^\\d{10}$")) {
            return "redirect:/users/update/" + id;
        }

        existingUser.setFullName(name);
        existingUser.setEmail(email);
        existingUser.setPhoneNumber(phone);
        existingUser.setHomeAddress(address);
        existingUser.setAge(age);
        existingUser.setPrivate(isPrivate);

        try {
            existingUser.setGender(Gender.valueOf(gender.toUpperCase()));
        } catch (IllegalArgumentException e) {
            return "error";
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
        return "redirect:/users/profile/" + id;
    }
}
