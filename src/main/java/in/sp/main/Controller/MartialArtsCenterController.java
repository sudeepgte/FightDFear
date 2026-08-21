package in.sp.main.Controller;

import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.http.HttpStatus;
import org.springframework.beans.factory.annotation.Autowired;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import in.sp.main.Entities.*;
import in.sp.main.Repository.MartialArtsCenterRepository;
import in.sp.main.Repository.MartialArtsTypeRepository;
import in.sp.main.Repository.MartialArtsBatchRepository;
import in.sp.main.Service.FileUploadService;
import in.sp.main.Service.MartialArtsCenterService;
import jakarta.servlet.ServletContext;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/centres")
public class MartialArtsCenterController {

    private static final Logger log = LoggerFactory.getLogger(MartialArtsCenterController.class);

    @Autowired
    private in.sp.main.Repository.VideoUploadRepository videoRepository;

    @Autowired
    private MartialArtsCenterService centreService;
    @Autowired
    private final ObjectMapper objectMapper;
    @Autowired
    private ServletContext servletContext;
    @Autowired
    private FileUploadService fileuploadService;
    @Autowired
    private MartialArtsCenterRepository centreRepository;
    @Autowired
    private MartialArtsTypeRepository typeRepository;
    @Autowired
    private MartialArtsBatchRepository batchRepository;

    @Autowired
    private in.sp.main.Repository.EnrollmentRepository enrollmentRepository;

    @Autowired
    private in.sp.main.Repository.OnlineClassEnrollmentRepository onlineClassEnrollmentRepository;

    @Autowired
    private in.sp.main.Repository.OnlineClassRepository onlineClassRepository;

    @Autowired
    private in.sp.main.Repository.OnlineClassInvitationRepository invitationRepository;
    
    @Autowired
    private in.sp.main.Repository.AttendanceRepository attendanceRepository;
    
    @Autowired
    private in.sp.main.Config.JwtUtil jwtUtil;

    @Autowired
    private in.sp.main.Service.PasswordService passwordService;


    @Autowired
    private in.sp.main.Service.QrAttendanceService qrAttendanceService;

    @Autowired
    private in.sp.main.Service.BeltGradingService beltGradingService;

    @Autowired
    private in.sp.main.Repository.CentreInstructorRepository instructorRepository;

    @Autowired
    private in.sp.main.Service.OtpVerificationService otpVerificationService;

    public MartialArtsCenterController(MartialArtsCenterService centreService, ObjectMapper objectMapper) {
        this.centreService = centreService;
        this.objectMapper = objectMapper;
    }

    @InitBinder
    public void initBinder(org.springframework.web.bind.WebDataBinder binder) {
        binder.setDisallowedFields("galleryPhotos");
    }

    // ---------- REGISTER FORM ----------
    @RequestMapping(value = "/registerCentre", method = RequestMethod.GET)
    public String showRegisterForm(Model model) {
        MartialArtsCenter center = new MartialArtsCenter();
        MartialArtsType type = new MartialArtsType();
        type.getSlots().add(new Slot());
        center.getMartialArtsTypes().add(type);

        model.addAttribute("martialArtsCenter", center);
        model.addAttribute("AvailableDays", Arrays.asList(DayAvailable.values()));
        return "registerCentre";
    }

    // ---------- REGISTER SUBMIT ----------
    @RequestMapping(value = "/register", method = RequestMethod.POST)
    public String registerCentre(
            @ModelAttribute MartialArtsCenter center,
            @RequestPart(value = "certificate", required = false) MultipartFile certificate,
            @RequestParam(value = "profileimage", required = false) MultipartFile profilePhoto,
            @RequestParam(value = "galleryPhotos", required = false) MultipartFile[] galleryPhotos,
            @RequestParam(value = "availableDays", required = false) List<DayAvailable> availableDays,
            @RequestParam(value = "martialArtsJson", required = false) String martialArtsJson,
            RedirectAttributes redirectAttributes) {

        try {
            if (center.getEmail() == null || center.getEmail().isBlank()) {
                redirectAttributes.addFlashAttribute("error", "Email is required.");
                return "redirect:/centres/registerCentre";
            }
            String email = center.getEmail().trim().toLowerCase();
            center.setEmail(email);

            if (centreRepository.findByEmail(email).isPresent()) {
                redirectAttributes.addFlashAttribute("error", "Email already exists. Please sign in.");
                return "redirect:/centres/login";
            }

            // Enforce verified Email OTP (parity with mobile)
            if (!otpVerificationService.consumeVerifiedOtp(email, OtpPurpose.CENTRE_REGISTER, 15)) {
                redirectAttributes.addFlashAttribute("error", "Email verification required. Please verify your OTP before registering.");
                return "redirect:/centres/registerCentre";
            }


            if (center.getPhoneNumber() == null || !center.getPhoneNumber().trim().matches("^\\d{10}$")) {
                redirectAttributes.addFlashAttribute("error", "Phone number must be exactly 10 digits.");
                return "redirect:/centres/registerCentre";
            }

            if (center.getPassword() == null || center.getPassword().isBlank()) {
                redirectAttributes.addFlashAttribute("error", "Password is required.");
                return "redirect:/centres/registerCentre";
            }
            center.setPassword(passwordService.encode(center.getPassword()));
            center.setApproved(false);
            center.setCentreProfileStatus(CentreProfileStatus.REGISTERED);
            center.setProfileCompletionPct(0);

            if (galleryPhotos != null) {
                for (MultipartFile photo : galleryPhotos) {
                    if (!photo.isEmpty()) {
                        String photoUrl = fileuploadService.saveFile(photo);
                        center.getGalleryPhotos().add(photoUrl);
                    }
                }
            }

            ObjectMapper mapper = new ObjectMapper();
            List<MartialArtsType> types = mapper.readValue(
                    martialArtsJson != null && !martialArtsJson.isBlank() ? martialArtsJson : "[]",
                    new TypeReference<List<MartialArtsType>>() {}
            );

            if (types != null && !types.isEmpty()) {
                for (MartialArtsType type : types) {
                    if (type.getName() != null && !type.getName().isBlank()) {
                        type.setCentre(center);
                        if (type.getSlots() != null) {
                            for (Slot slot : type.getSlots()) {
                                slot.setMartialArtsType(type);
                            }
                        }
                    }
                }
            }

            if (availableDays != null) {
                center.setAvailableDays(new TreeSet<>(availableDays));
            } else {
                center.setAvailableDays(new TreeSet<>());
            }

            centreRepository.save(center);

            redirectAttributes.addFlashAttribute("registeredEmail", email);
            redirectAttributes.addFlashAttribute("message",
                    "Account created successfully! Please sign in to complete your profile and submit for verification.");
            return "redirect:/centres/login";

        } catch (IOException e) {
            e.printStackTrace();
            redirectAttributes.addFlashAttribute("error", "File upload failed: " + e.getMessage());
            return "redirect:/centres/registerCentre";
        } catch (Exception e) {
            e.printStackTrace();
            redirectAttributes.addFlashAttribute("error", "Registration failed: " + e.getMessage());
            return "redirect:/centres/registerCentre";
        }
    }

    // ---------- SUCCESS PAGE ----------
    @RequestMapping(value = "/success", method = RequestMethod.GET)
    public String showSuccessPage() {
        return "registerSucessCentre";
    }

    // ---------- CERTIFICATE VIEW ----------
    @RequestMapping(value = "/certificate/{id}", method = RequestMethod.GET)
    public String getCertificatePath(@PathVariable Long id, Model model) {
        String filePath = centreService.getCertificatePath(id);
        model.addAttribute("certificatePath", filePath);
        return "viewCertificate";
    }

    // ---------- GET ALL TYPES ----------
    @RequestMapping(value = "/types/{centreId}", method = RequestMethod.GET)
    @ResponseBody
    public List<MartialArtsType> getMartialArtsTypes(@PathVariable Long centreId) {
        return centreService.getMartialArtsTypes(centreId);
    }

    // ---------- ALL CENTERS ----------
    @RequestMapping(value = "/allcentres", method = RequestMethod.GET)
    public String getAllCenters(Model model) {
        List<MartialArtsCenter> centers = centreService.getAllCenters();
        model.addAttribute("centers", centers);
        return "listOfCentres";
    }

    // ---------- APPROVED CENTERS ----------
    @RequestMapping(value = "/allacceptedcentres", method = RequestMethod.GET)
    public String getAllAcceptedCenters(Model model, HttpSession session) {
        User user = (User) session.getAttribute("user");
        List<MartialArtsCenter> centers = centreService.getApprovedCentersForDiscovery();
        List<in.sp.main.Entities.Videoupload> videos = videoRepository.findByIsReel(true);

        int totalBatches = centers.stream().mapToInt(c -> c.getBatches() != null ? c.getBatches().size() : 0).sum();

        // Complete mobile source-of-truth style catalog
        List<String> catalogStyles = List.of(
            "Karate", "Taekwondo", "Judo", "Kung Fu", "Self-Defence", 
            "MMA", "Boxing", "Kickboxing", "Muay Thai", "Krav Maga", 
            "Aikido", "Kalaripayattu", "Wrestling", "Jiu-Jitsu", "Other"
        );
        model.addAttribute("catalogStyles", catalogStyles);
        
        if (user != null) {
            List<Enrollment> enrollments = enrollmentRepository.findByUser(user);
            Set<Long> enrolledBatchIds = enrollments.stream()
                .filter(e -> e.getBatch() != null)
                .map(e -> e.getBatch().getId())
                .collect(Collectors.toSet());
            model.addAttribute("enrolledBatchIds", enrolledBatchIds);
            model.addAttribute("userEnrollments", enrollments);

            Enrollment activeEnrollment = enrollments.stream()
                .filter(e -> e.getStatus() == null || e.getStatus() != TrainingStatus.COMPLETED)
                .findFirst()
                .orElse(enrollments.isEmpty() ? null : enrollments.get(0));
            model.addAttribute("activeEnrollment", activeEnrollment);

            List<Attendance> attendances = attendanceRepository.findByUser(user);
            long totalClasses = attendances.size();
            long attendedCount = attendances.stream()
                .filter(a -> a.getStatus() == in.sp.main.Entities.AttendanceStatus.PRESENT || a.getStatus() == in.sp.main.Entities.AttendanceStatus.LATE)
                .count();
            long presentCount = attendances.stream().filter(a -> a.getStatus() == in.sp.main.Entities.AttendanceStatus.PRESENT).count();
            long absentCount = attendances.stream().filter(a -> a.getStatus() == in.sp.main.Entities.AttendanceStatus.ABSENT).count();
            long lateCount = attendances.stream().filter(a -> a.getStatus() == in.sp.main.Entities.AttendanceStatus.LATE).count();
            double attendancePercentage = totalClasses == 0 ? 0.0 : ((double) attendedCount / (double) totalClasses) * 100.0;

            model.addAttribute("totalClasses", totalClasses);
            model.addAttribute("attendedCount", attendedCount);
            model.addAttribute("presentCount", presentCount);
            model.addAttribute("absentCount", absentCount);
            model.addAttribute("lateCount", lateCount);
            model.addAttribute("attendancePercentage", String.format(Locale.ROOT, "%.1f", attendancePercentage));

            // Belt calculation matching Mobile / UserController
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

            // Streak calculation
            int streak = 0;
            if (!attendances.isEmpty()) {
                List<java.time.LocalDate> dates = attendances.stream()
                    .filter(a -> a.getStatus() == in.sp.main.Entities.AttendanceStatus.PRESENT || a.getStatus() == in.sp.main.Entities.AttendanceStatus.LATE)
                    .map(a -> {
                        if (a.getSession() != null) return a.getSession().getDate();
                        if (a.getOnlineClass() != null) return a.getOnlineClass().getDate();
                        return a.getAttendanceDate();
                    })
                    .filter(java.util.Objects::nonNull)
                    .distinct()
                    .sorted(java.util.Comparator.reverseOrder())
                    .collect(Collectors.toList());

                if (!dates.isEmpty()) {
                    java.time.LocalDate today = java.time.LocalDate.now();
                    if (dates.get(0).equals(today) || dates.get(0).equals(today.minusDays(1))) {
                        streak = 1;
                        for (int i = 0; i < dates.size() - 1; i++) {
                            if (dates.get(i).minusDays(1).equals(dates.get(i + 1))) {
                                streak++;
                            } else {
                                break;
                            }
                        }
                    }
                }
            }
            model.addAttribute("streak", streak);

            // Upcoming Online Classes for user's batches
            List<MartialArtsBatch> userBatches = enrollments.stream()
                .map(Enrollment::getBatch)
                .filter(java.util.Objects::nonNull)
                .collect(Collectors.toList());

            List<OnlineClass> upcomingOnline = userBatches.isEmpty() ? Collections.emptyList() : 
                onlineClassRepository.findByBatchIn(userBatches).stream()
                .filter(oc -> oc.getDate() != null && !oc.getDate().isBefore(java.time.LocalDate.now()))
                .sorted(java.util.Comparator.comparing(OnlineClass::getDate))
                .collect(Collectors.toList());
            model.addAttribute("upcomingOnlineClasses", upcomingOnline);
        } else {
            model.addAttribute("currentBelt", "Guest");
            model.addAttribute("beltProgress", 0);
            model.addAttribute("streak", 0);
            model.addAttribute("attendedCount", 0);
            model.addAttribute("attendancePercentage", "0.0");
        }
        
        model.addAttribute("centers", centers);
        model.addAttribute("approvedCentreCount", centers.size());
        model.addAttribute("totalBatchCount", totalBatches);
        model.addAttribute("videos", videos);
        model.addAttribute("user", user);
        model.addAttribute("activeTab", "explore");

        return "userMartialDashboard";
    }

    // ---------- BY LOCATION ----------
    @RequestMapping(value = "/location/{location}", method = RequestMethod.GET)
    public String getCentersByLocation(@PathVariable String location, Model model) {
        List<MartialArtsCenter> centers = centreService.getCentersByLocation(location);
        model.addAttribute("centers", centers);
        return "centersByLocation";
    }

    // ---------- CENTER DETAILS ----------
    @RequestMapping(value = "/details/{id}", method = RequestMethod.GET)
    public String getCenterDetails(@PathVariable Long id, Model model, HttpSession session,
                                     RedirectAttributes redirectAttributes) {
        try {
            MartialArtsCenter center = centreService.getApprovedCenterById(id);
            if (center == null) {
                redirectAttributes.addFlashAttribute("message", "Center not found or not approved.");
                return "redirect:/centres/allacceptedcentres";
            }
            List<DayAvailable> sortedDays = new ArrayList<>();
            if (center.getAvailableDays() != null) {
                sortedDays.addAll(center.getAvailableDays());
                sortedDays.sort((d1, d2) -> d1.ordinal() - d2.ordinal());
            }

            // Build enrolled count map for capacity display on each batch
            java.util.Map<Long, Long> enrolledCountByBatch = new java.util.HashMap<>();
            if (center.getBatches() != null) {
                for (MartialArtsBatch batch : center.getBatches()) {
                    long count = enrollmentRepository.countPaidByBatchId(batch.getId());
                    enrolledCountByBatch.put(batch.getId(), count);
                }
            }

            model.addAttribute("center", center);
            model.addAttribute("sortedAvailableDays", sortedDays);
            model.addAttribute("batches", center.getBatches());
            model.addAttribute("user", session.getAttribute("user"));
            model.addAttribute("enrolledCountByBatch", enrolledCountByBatch);
            return "centreDetails";
        } catch (IllegalStateException ex) {
            redirectAttributes.addFlashAttribute("message", ex.getMessage());
            return "redirect:/centres/allacceptedcentres";
        } catch (RuntimeException ex) {
            return "errorPage";
        }
    }

    // ---------- DETAILS FOR DASHBOARD ----------
    @RequestMapping(value = "/detailsforCentre/{id}", method = RequestMethod.GET)
    public String getCenterDetailsforCentreDashboard(@PathVariable Long id, Model model) {
        MartialArtsCenter center = centreService.getCenterById(id);
        if (center == null) return "errorPage";
        
        List<DayAvailable> sortedDays = new ArrayList<>(center.getAvailableDays());
        sortedDays.sort((d1, d2) -> d1.ordinal() - d2.ordinal());
        
        List<MartialArtsBatch> batches = batchRepository.findByCenterId(id);
        model.addAttribute("center", center);
        model.addAttribute("sortedAvailableDays", sortedDays);
        model.addAttribute("batches", batches);
        return "centreProfile";
    }

    // ---------- LOGIN PAGE ----------
    @RequestMapping(value = "/login", method = RequestMethod.GET)
    public String showLoginPage() {
        return "centreLogin";
    }

    @Autowired
    private in.sp.main.Service.CentreProfileService centreProfileService;

    // ---------- LOGIN SUBMIT ----------
    @RequestMapping(value = "/loginCentre", method = RequestMethod.POST)
    public String loginCentre(@RequestParam String email,
                              @RequestParam String password,
                              Model model, HttpSession session,
                              jakarta.servlet.http.HttpServletResponse response,
                              RedirectAttributes redirectAttributes) {
        if (email == null || email.isBlank()) {
            redirectAttributes.addFlashAttribute("error", "Please enter your email.");
            return "redirect:/centres/login";
        }
        String normalizedEmail = email.trim().toLowerCase();
        java.util.Optional<MartialArtsCenter> centerOpt = centreRepository.findByEmail(normalizedEmail);
        if (centerOpt.isEmpty()) {
            redirectAttributes.addFlashAttribute("error",
                    "No centre found for this email. Please check your credentials or register.");
            return "redirect:/centres/login";
        }
        MartialArtsCenter center = centerOpt.get();
        boolean ok = passwordService.matchesAndUpgrade(password, center.getPassword(), hashed -> {
            center.setPassword(hashed);
            centreRepository.save(center);
        });
        if (!ok) {
            redirectAttributes.addFlashAttribute("error", "Invalid email or password.");
            return "redirect:/centres/login";
        }
        session.setAttribute("loggedCentre", center);
        
        // Generate JWT and add to response
        String token = jwtUtil.generateToken(center.getEmail(), "CENTRE");
        jakarta.servlet.http.Cookie cookie = new jakarta.servlet.http.Cookie("JWT_TOKEN", token);
        cookie.setPath("/");
        cookie.setHttpOnly(true);
        cookie.setMaxAge(365 * 24 * 60 * 60); // 1 year
        response.addCookie(cookie);

        // Smart routing: Check if profile needs completion (Mobile parity)
        boolean needsCompletion = center.getCentreProfileStatus() == CentreProfileStatus.REGISTERED
                || center.getCentreProfileStatus() == CentreProfileStatus.PROFILE_INCOMPLETE
                || center.getCentreProfileStatus() == CentreProfileStatus.CHANGES_REQUESTED
                || (center.getProfileCompletionPct() != null && center.getProfileCompletionPct() < 100 && !center.isApproved());

        if (needsCompletion) {
            return "redirect:/centres/profile-completion";
        }
        return "redirect:/centres/dashboard";
    }

    // ---------- PROFILE COMPLETION PAGE ----------
    @RequestMapping(value = "/profile-completion", method = RequestMethod.GET)
    public String showProfileCompletion(HttpSession session, Model model) {
        MartialArtsCenter sessionCenter = (MartialArtsCenter) session.getAttribute("loggedCentre");
        if (sessionCenter == null) {
            return "redirect:/centres/login";
        }
        MartialArtsCenter center = centreRepository.findById(sessionCenter.getId()).orElse(sessionCenter);
        model.addAttribute("center", center);
        return "centreProfileCompletion";
    }

    // ---------- UPDATE PROFILE HANDLER ----------
    @PostMapping("/updateProfile")
    public String updateProfile(
            @RequestParam Long id,
            @RequestParam(required = false) String name,
            @RequestParam(required = false) String centreType,
            @RequestParam(required = false) String contactPerson,
            @RequestParam(required = false) String designation,
            @RequestParam(required = false) String phone,
            @RequestParam(required = false) String whatsappNumber,
            @RequestParam(required = false) Integer yearStarted,
            @RequestParam(required = false) String affiliation,
            @RequestParam(required = false) String location,
            @RequestParam(required = false) String city,
            @RequestParam(required = false) String state,
            @RequestParam(required = false) String pincode,
            @RequestParam(required = false) String mapLink,
            @RequestParam(required = false) List<String> styles,
            @RequestParam(required = false) List<String> audience,
            @RequestParam(required = false) Boolean womenOnly,
            @RequestParam(required = false) Boolean femaleInstructor,
            @RequestParam(required = false) List<String> ageGroups,
            @RequestParam(required = false) List<String> facilities,
            @RequestParam(required = false) List<String> availableDays,
            @RequestParam(required = false) String openTime,
            @RequestParam(required = false) String closeTime,
            @RequestParam(required = false) String about,
            @RequestParam(required = false) String howWeTeach,
            @RequestParam(required = false) List<String> offers,
            @RequestParam(required = false) String upiId,
            @RequestParam(required = false) String bankDetails,
            @RequestParam(required = false) MultipartFile profilePhotoFile,
            @RequestParam(required = false) MultipartFile certificateFile,
            @RequestParam(required = false) MultipartFile[] galleryFiles,
            HttpSession session, RedirectAttributes redirectAttributes) {

        MartialArtsCenter sessionCenter = (MartialArtsCenter) session.getAttribute("loggedCentre");
        if (sessionCenter == null) return "redirect:/centres/login";

        MartialArtsCenter center = centreRepository.findById(id).orElse(sessionCenter);
        Map<String, Object> body = new HashMap<>();
        if (name != null) body.put("name", name);
        if (centreType != null) body.put("centreType", centreType);
        if (contactPerson != null) body.put("contactPerson", contactPerson);
        if (designation != null) body.put("designation", designation);
        if (phone != null) body.put("phoneNumber", phone);
        if (whatsappNumber != null) body.put("whatsappNumber", whatsappNumber);
        if (yearStarted != null) body.put("yearStarted", yearStarted);
        if (affiliation != null) body.put("affiliation", affiliation);
        if (location != null) body.put("location", location);
        if (city != null) body.put("city", city);
        if (state != null) body.put("state", state);
        if (pincode != null) body.put("pincode", pincode);
        if (mapLink != null) body.put("googleMapLocation", mapLink);
        if (styles != null) body.put("stylesTaught", styles);
        if (audience != null) body.put("audience", audience);
        if (womenOnly != null) body.put("womenOnlyBatches", womenOnly);
        if (femaleInstructor != null) body.put("femaleInstructor", femaleInstructor);
        if (ageGroups != null) body.put("ageGroups", ageGroups);
        if (facilities != null) body.put("facilities", facilities);
        if (availableDays != null) body.put("availableDays", availableDays);
        if (openTime != null) body.put("openTime", openTime);
        if (closeTime != null) body.put("closeTime", closeTime);
        if (about != null) body.put("about", about);
        if (howWeTeach != null) body.put("howWeTeach", howWeTeach);
        if (offers != null) body.put("whatWeOffer", offers);
        if (upiId != null) body.put("upiId", upiId);
        if (bankDetails != null) body.put("bankDetails", bankDetails);

        try {
            if (profilePhotoFile != null && !profilePhotoFile.isEmpty()) {
                center.setProfilePhoto(fileuploadService.saveFile(profilePhotoFile));
            }
            if (certificateFile != null && !certificateFile.isEmpty()) {
                center.setTrainerCertificatePath(fileuploadService.saveFile(certificateFile));
            }
            if (galleryFiles != null) {
                for (MultipartFile f : galleryFiles) {
                    if (f != null && !f.isEmpty()) {
                        center.getGalleryPhotos().add(fileuploadService.saveFile(f));
                    }
                }
            }
        } catch (Exception e) {
            log.error("Upload error during profile update", e);
        }

        centreProfileService.applyFields(center, body);
        center = centreProfileService.refreshCompletion(center);
        session.setAttribute("loggedCentre", center);

        redirectAttributes.addFlashAttribute("message", "Profile details saved successfully! Current completion: " + (center.getProfileCompletionPct() != null ? center.getProfileCompletionPct() : 0) + "%");
        return "redirect:/centres/profile-completion";
    }

    // ---------- SUBMIT VERIFICATION HANDLER ----------
    @PostMapping("/submitVerification")
    public String submitVerification(HttpSession session, RedirectAttributes redirectAttributes) {
        MartialArtsCenter sessionCenter = (MartialArtsCenter) session.getAttribute("loggedCentre");
        if (sessionCenter == null) return "redirect:/centres/login";

        MartialArtsCenter center = centreRepository.findById(sessionCenter.getId()).orElse(sessionCenter);
        center = centreProfileService.refreshCompletion(center);

        center.setCentreProfileStatus(CentreProfileStatus.PENDING_ADMIN_APPROVAL);
        center.setSubmittedForVerificationAt(LocalDateTime.now());
        centreRepository.save(center);
        session.setAttribute("loggedCentre", center);

        redirectAttributes.addFlashAttribute("message", "Your centre profile has been submitted for Admin Verification! Our team will review your application shortly.");
        return "redirect:/centres/profile-completion";
    }

    // ---------- LOGOUT ----------
    @RequestMapping(value = "/logout", method = RequestMethod.GET)
    public String logout(HttpSession session, jakarta.servlet.http.HttpServletResponse response) {
        session.invalidate();
        
        jakarta.servlet.http.Cookie cookie = new jakarta.servlet.http.Cookie("JWT_TOKEN", null);
        cookie.setPath("/");
        cookie.setHttpOnly(true);
        cookie.setMaxAge(0);
        response.addCookie(cookie);
        
        return "redirect:/centres/login";
    }

    // ---------- DASHBOARD ----------
    @RequestMapping(value = "/dashboard", method = RequestMethod.GET)
    public String centerDashboard(HttpSession session, Model model, HttpServletResponse response) {
        return loadCentreDashboard("dashboard", session, model, response);
    }

    @GetMapping("/dashboard1")
    public String legacyDashboard(HttpSession session, Model model, HttpServletResponse response) {
        return loadCentreDashboard("dashboard", session, model, response);
    }

    @GetMapping(value = "/dashboard.meta", produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public Map<String, Object> dashboardMeta(HttpSession session) {
        Map<String, Object> res = new HashMap<>();
        MartialArtsCenter sessionCenter = (MartialArtsCenter) session.getAttribute("loggedCentre");
        if (sessionCenter == null) {
            res.put("error", "LOGIN_REQUIRED");
            return res;
        }
        MartialArtsCenter center = centreRepository.findById(sessionCenter.getId()).orElse(sessionCenter);
        List<Enrollment> enrollments = centreService.getEnrolledUsersByCenter(center.getId());
        List<MartialArtsBatch> batches = batchRepository.findByCenterId(center.getId());
        List<Map<String, Object>> enrollList = buildEnrollmentMaps(center, enrollments);
        res.put("meta", buildDashboardMeta(center, batches, enrollments, enrollList));
        res.put("batches", buildBatchMaps(batches, onlineClassRepository.findByCenterId(center.getId())));
        res.put("enrollments", enrollList);
        return res;
    }

    @PostMapping("/settings")
    @ResponseBody
    public Map<String, Object> updateCentreSettings(
            @RequestParam String name,
            @RequestParam String email,
            @RequestParam(required = false) String phoneNumber,
            @RequestParam(required = false) String location,
            @RequestParam(required = false) String about,
            @RequestParam(required = false) String howWeTeach,
            @RequestParam(required = false) String whatWeOffer,
            @RequestParam(value = "profileImage", required = false) MultipartFile profileImage,
            @RequestParam(value = "galleryPhotos", required = false) MultipartFile[] galleryPhotos,
            HttpSession session) {
        Map<String, Object> res = new HashMap<>();
        MartialArtsCenter sessionCenter = (MartialArtsCenter) session.getAttribute("loggedCentre");
        if (sessionCenter == null) {
            res.put("status", "error");
            res.put("message", "Session expired. Please login again.");
            return res;
        }
        try {
            MartialArtsCenter center = centreRepository.findById(sessionCenter.getId())
                    .orElseThrow(() -> new RuntimeException("Center not found"));
            if (name != null && !name.isBlank()) center.setName(name.trim());
            if (email != null && !email.isBlank()) center.setEmail(email.trim().toLowerCase());
            if (phoneNumber != null) center.setPhoneNumber(phoneNumber.trim());
            if (location != null) center.setLocation(location.trim());
            if (about != null) center.setAbout(about.trim());
            if (howWeTeach != null) center.setHowWeTeach(howWeTeach.trim());
            if (whatWeOffer != null) center.setWhatWeOffer(whatWeOffer.trim());
            if (profileImage != null && !profileImage.isEmpty()) {
                center.setProfilePhoto(fileuploadService.saveFile(profileImage));
            }
            if (galleryPhotos != null && galleryPhotos.length > 0) {
                List<String> newPhotos = new ArrayList<>(center.getGalleryPhotos());
                for (MultipartFile photo : galleryPhotos) {
                    if (!photo.isEmpty()) {
                        newPhotos.add(fileuploadService.saveFile(photo));
                    }
                }
                center.setGalleryPhotos(newPhotos);
            }
            centreRepository.save(center);
            session.setAttribute("loggedCentre", center);
            res.put("status", "success");
            res.put("message", "Profile updated successfully");
            res.put("center", buildCenterMap(center));
        } catch (Exception e) {
            res.put("status", "error");
            res.put("message", e.getMessage());
        }
        return res;
    }

    @PostMapping("/process-batch")
    @ResponseBody
    public Map<String, Object> processBatch(@RequestBody MartialArtsBatch batch, HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        try {
            MartialArtsCenter sessionCenter = (MartialArtsCenter) session.getAttribute("loggedCentre");
            if (sessionCenter == null) {
                response.put("status", "error");
                response.put("message", "Session expired. Please login again.");
                return response;
            }
            MartialArtsCenter center = centreRepository.findById(sessionCenter.getId()).orElse(sessionCenter);
            batch.setCenter(center);
            batchRepository.save(batch);
            response.put("status", "success");
            response.put("message", "Batch created successfully");
        } catch (Exception e) {
            e.printStackTrace();
            response.put("status", "error");
            response.put("message", "Database error: " + e.getMessage());
        }
        return response;
    }

    @GetMapping("/{tab}")
    public String centerDashboardTab(@PathVariable String tab,
                                     HttpSession session, Model model, HttpServletResponse response) {
        Set<String> validTabs = new HashSet<>(Arrays.asList(
                "dashboard", "batches", "live-classes", "students",
                "bookings", "class-types", "attendance", "reports", "settings",
                "create-batch", "notifications", "dashboard1"
        ));
        if (!validTabs.contains(tab)) {
            return "redirect:/centres/dashboard";
        }
        if ("dashboard1".equals(tab)) {
            tab = "dashboard";
        }
        return loadCentreDashboard(tab, session, model, response);
    }

    private String loadCentreDashboard(String tab, HttpSession session, Model model, HttpServletResponse response) {
        MartialArtsCenter sessionCenter = (MartialArtsCenter) session.getAttribute("loggedCentre");
        if (sessionCenter == null) {
            return "redirect:/centres/login";
        }

        MartialArtsCenter center = centreRepository.findById(sessionCenter.getId()).orElse(sessionCenter);
        center.getMartialArtsTypes().size();

        model.addAttribute("currentTab", tab);
        setNoCacheHeaders(response);

        List<Enrollment> enrollments = centreService.getEnrolledUsersByCenter(center.getId());
        List<MartialArtsBatch> batches = batchRepository.findByCenterId(center.getId());
        List<OnlineClass> onlineClasses = onlineClassRepository.findByCenterId(center.getId());

        double totalEarnings = enrollments.stream()
                .filter(e -> e.getAmountPaid() != null)
                .mapToDouble(Enrollment::getAmountPaid)
                .sum();

        Map<Long, Long> enrolledCountByBatch = new HashMap<>();
        for (MartialArtsBatch b : batches) {
            enrolledCountByBatch.put(b.getId(), enrollmentRepository.countByBatchId(b.getId()));
        }

        model.addAttribute("center", center);
        model.addAttribute("loggedCentre", center);
        model.addAttribute("enrollments", enrollments);
        model.addAttribute("enrolledUsersCount", enrollments.size());
        model.addAttribute("enrolledCountByBatch", enrolledCountByBatch);
        model.addAttribute("batches", batches);
        model.addAttribute("totalEarnings", totalEarnings);
        model.addAttribute("trainingStatuses", TrainingStatus.values());

        try {
            List<Map<String, Object>> batchList = buildBatchMaps(batches, onlineClasses);
            List<Map<String, Object>> enrollList = buildEnrollmentMaps(center, enrollments);
            Map<String, Object> meta = buildDashboardMeta(center, batches, enrollments, enrollList);

            model.addAttribute("batchesJson", objectMapper.writeValueAsString(batchList));
            model.addAttribute("enrollmentsJson", objectMapper.writeValueAsString(enrollList));
            model.addAttribute("centerJson", objectMapper.writeValueAsString(buildCenterMap(center)));
            model.addAttribute("dashboardMetaJson", objectMapper.writeValueAsString(meta));
        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("batchesJson", "[]");
            model.addAttribute("enrollmentsJson", "[]");
            model.addAttribute("centerJson", "{}");
            model.addAttribute("dashboardMetaJson", "{}");
        }

        session.setAttribute("loggedCentre", center);
        return "centreDashboard";
    }

    private void setNoCacheHeaders(HttpServletResponse response) {
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);
    }

    private Map<String, Object> buildCenterMap(MartialArtsCenter center) {
        Map<String, Object> map = new LinkedHashMap<>();
        map.put("id", center.getId());
        map.put("name", center.getName() != null ? center.getName() : "");
        map.put("email", center.getEmail() != null ? center.getEmail() : "");
        map.put("phone", center.getPhoneNumber() != null ? center.getPhoneNumber() : "");
        map.put("location", center.getLocation() != null ? center.getLocation() : "");
        map.put("profilePhoto", center.getProfilePhoto());
        map.put("about", center.getAbout() != null ? center.getAbout() : "");
        return map;
    }

    private List<Map<String, Object>> buildBatchMaps(List<MartialArtsBatch> batches, List<OnlineClass> onlineClasses) {
        List<Map<String, Object>> batchList = new ArrayList<>();
        for (MartialArtsBatch b : batches) {
            Map<String, Object> bMap = new LinkedHashMap<>();
            bMap.put("id", b.getId());
            bMap.put("name", b.getName());
            bMap.put("style", b.getStyle());
            bMap.put("instructor", b.getInstructor());
            bMap.put("timeSlot", b.getTimeSlot());
            bMap.put("availableDays", formatBatchDays(b.getAvailableDays()));
            bMap.put("fee", b.getFee() != null ? b.getFee() : 0.0);
            bMap.put("admissionFee", b.getAdmissionFee() != null ? b.getAdmissionFee() : 0.0);
            bMap.put("status", b.getStatus() != null ? b.getStatus() : "Active");
            bMap.put("batchType", b.getBatchType() != null ? b.getBatchType() : "Offline");
            bMap.put("meetingLink", b.getMeetingLink());
            bMap.put("capacity", b.getCapacity() != null ? b.getCapacity() : 20);
            bMap.put("ageGroup", b.getAgeGroup() != null ? b.getAgeGroup() : "All Ages");
            bMap.put("skillLevel", b.getSkillLevel() != null ? b.getSkillLevel() : "All Levels");
            bMap.put("trialType", b.getTrialType() != null ? b.getTrialType() : "None");
            bMap.put("durationMinutes", b.getDurationMinutes() != null ? b.getDurationMinutes() : 60);
            bMap.put("bufferMinutes", b.getBufferMinutes() != null ? b.getBufferMinutes() : 10);
            bMap.put("startDate", b.getStartDate() != null ? b.getStartDate().toString() : "");
            bMap.put("endDate", b.getEndDate() != null ? b.getEndDate().toString() : "");
            bMap.put("location", b.getLocation() != null ? b.getLocation() : "");
            bMap.put("isBatch", true);
            batchList.add(bMap);
        }
        for (OnlineClass oc : onlineClasses) {
            Map<String, Object> ocMap = new LinkedHashMap<>();
            ocMap.put("id", oc.getId());
            ocMap.put("name", oc.getTitle());
            ocMap.put("style", "Live Session");
            ocMap.put("timeSlot", oc.getStartTime() + " - " + oc.getEndTime());
            ocMap.put("batchType", "Online");
            ocMap.put("meetingLink", oc.getMeetingLink());
            ocMap.put("isBatch", false);
            ocMap.put("status", oc.getStatus());
            if (oc.getBatch() != null) {
                ocMap.put("availableDays", formatBatchDays(oc.getBatch().getAvailableDays()));
                ocMap.put("fee", oc.getBatch().getFee());
            } else {
                ocMap.put("availableDays", "One-time");
                ocMap.put("fee", 0.0);
            }
            batchList.add(ocMap);
        }
        return batchList;
    }

    private String formatBatchDays(String days) {
        if (days == null || days.isBlank()) {
            return "All Week";
        }
        if (!days.contains(",")) {
            return days.trim();
        }
        List<String> dayList = new ArrayList<>(Arrays.asList(days.split(",")));
        dayList.sort((d1, d2) -> {
            Map<String, Integer> order = Map.of("MON", 1, "TUE", 2, "WED", 3, "THU", 4, "FRI", 5, "SAT", 6, "SUN", 7);
            return order.getOrDefault(d1.trim().toUpperCase(), 99) - order.getOrDefault(d2.trim().toUpperCase(), 99);
        });
        return String.join(", ", dayList);
    }

    private List<Map<String, Object>> buildEnrollmentMaps(MartialArtsCenter center, List<Enrollment> enrollments) {
        List<Map<String, Object>> enrollList = new ArrayList<>();
        for (Enrollment e : enrollments) {
            Map<String, Object> eMap = new LinkedHashMap<>();
            eMap.put("id", e.getId());
            eMap.put("traineeName", e.getFullName() != null ? e.getFullName()
                    : (e.getUser() != null ? e.getUser().getFullName() : "Unknown"));
            eMap.put("age", e.getAge());
            eMap.put("gender", e.getGender());
            eMap.put("phone", e.getPhoneNumber());
            eMap.put("email", e.getEmail() != null ? e.getEmail()
                    : (e.getUser() != null ? e.getUser().getEmail() : ""));
            eMap.put("martialArtType", e.getMartialArtsType() != null ? e.getMartialArtsType().getName() : "N/A");
            eMap.put("centreName", center.getName());
            eMap.put("batchName", e.getBatch() != null ? e.getBatch().getName() : "N/A");
            eMap.put("mode", e.getBatch() != null ? e.getBatch().getBatchType() : "N/A");
            eMap.put("slot", e.getBatch() != null ? e.getBatch().getTimeSlot() : "N/A");
            eMap.put("enrollmentDate", e.getProposedStartDate() != null ? e.getProposedStartDate().toString() : "");
            eMap.put("enrollmentStatus", e.getStatus() != null ? e.getStatus().toString() : "PENDING");
            eMap.put("paymentStatus", e.getPaymentStatus() != null ? e.getPaymentStatus() : "UNPAID");
            eMap.put("amount", e.getAmountPaid() != null ? e.getAmountPaid() : 0.0);

            Long userId = e.getUser() != null ? e.getUser().getId() : -1L;
            List<Attendance> history = attendanceRepository.findByUserId(userId);
            long totalAtt = history.size();
            long presentCount = history.stream()
                    .filter(h -> h.getStatus() == AttendanceStatus.PRESENT).count();
            eMap.put("attendancePercentage", totalAtt == 0 ? 0 : (int) ((double) presentCount / totalAtt * 100));
            eMap.put("progress", e.getProgressPercentage() != null ? e.getProgressPercentage() : 0);
            attendanceRepository.findFirstByUserIdOrderByAttendanceDateDesc(userId)
                    .ifPresent(a -> eMap.put("lastAttendedDate", a.getAttendanceDate().toString()));
            enrollList.add(eMap);
        }
        enrollList.sort((a, b) -> Long.compare((Long) b.get("id"), (Long) a.get("id")));
        return enrollList;
    }

    private Map<String, Object> buildDashboardMeta(MartialArtsCenter center, List<MartialArtsBatch> batches,
                                                   List<Enrollment> enrollments, List<Map<String, Object>> enrollList) {
        Map<String, Object> meta = new LinkedHashMap<>();

        long onlineCount = batches.stream().filter(b -> "Online".equalsIgnoreCase(b.getBatchType())).count();
        meta.put("onlineBatchCount", onlineCount);
        meta.put("offlineBatchCount", Math.max(0, batches.size() - onlineCount));

        double avgAttendance = enrollList.stream()
                .mapToInt(e -> (Integer) e.getOrDefault("attendancePercentage", 0))
                .average().orElse(0);
        meta.put("avgAttendance", (int) Math.round(avgAttendance));

        long completed = enrollments.stream().filter(e -> e.getStatus() == TrainingStatus.COMPLETED).count();
        meta.put("completionRate", enrollments.isEmpty() ? 0 : (int) (completed * 100 / enrollments.size()));

        List<Map<String, Object>> notifications = new ArrayList<>();
        enrollments.stream()
                .sorted((a, b) -> Long.compare(b.getId(), a.getId()))
                .limit(8)
                .forEach(e -> {
                    Map<String, Object> n = new LinkedHashMap<>();
                    String name = e.getFullName() != null ? e.getFullName()
                            : (e.getUser() != null ? e.getUser().getFullName() : "Student");
                    boolean paid = "PAID".equalsIgnoreCase(e.getPaymentStatus());
                    n.put("title", paid ? "Payment Received" : "New Enrollment");
                    n.put("detail", paid
                            ? "₹ " + (e.getAmountPaid() != null ? e.getAmountPaid() : 0) + " from " + name
                            : name + " joined " + (e.getBatch() != null ? e.getBatch().getName() : "your centre"));
                    n.put("unread", e.getStatus() == TrainingStatus.PENDING || !paid);
                    n.put("timeLabel", e.getProposedStartDate() != null ? e.getProposedStartDate().toString() : "Recent");
                    notifications.add(n);
                });
        meta.put("notifications", notifications);
        meta.put("unreadCount", notifications.stream().filter(n -> Boolean.TRUE.equals(n.get("unread"))).count());

        String todayCode = dayCodeForToday();
        List<Map<String, Object>> activities = new ArrayList<>();
        enrollments.stream()
                .sorted((a, b) -> Long.compare(b.getId(), a.getId()))
                .limit(5)
                .forEach(e -> {
                    Map<String, Object> act = new LinkedHashMap<>();
                    act.put("type", "New Enrollment");
                    act.put("detail", (e.getFullName() != null ? e.getFullName() : "Student")
                            + " — " + (e.getBatch() != null ? e.getBatch().getName() : "General"));
                    act.put("status", e.getStatus() != null ? e.getStatus().toString() : "PENDING");
                    act.put("statusClass", e.getStatus() == TrainingStatus.APPROVED ? "success" : "info");
                    activities.add(act);
                });
        for (MartialArtsBatch b : batches) {
            if (b.getAvailableDays() != null
                    && b.getAvailableDays().toUpperCase().contains(todayCode)
                    && !"Closed".equalsIgnoreCase(b.getStatus())) {
                Map<String, Object> act = new LinkedHashMap<>();
                act.put("type", "Batch Reminder");
                act.put("detail", b.getName() + " (" + b.getTimeSlot() + ") scheduled today");
                act.put("status", b.getStatus() != null ? b.getStatus() : "Active");
                act.put("statusClass", "warning");
                activities.add(act);
            }
        }
        meta.put("activities", activities.stream().limit(8).toList());

        List<Map<String, Object>> classTypes = new ArrayList<>();
        for (MartialArtsType type : center.getMartialArtsTypes()) {
            Map<String, Object> ct = new LinkedHashMap<>();
            ct.put("id", type.getId());
            ct.put("name", type.getName());
            ct.put("cost", type.getCost() != null ? type.getCost() : 0.0);
            ct.put("slotCount", type.getSlots() != null ? type.getSlots().size() : 0);
            classTypes.add(ct);
        }
        if (classTypes.isEmpty()) {
            batches.stream().map(MartialArtsBatch::getStyle).filter(Objects::nonNull).distinct()
                    .forEach(style -> {
                        Map<String, Object> ct = new LinkedHashMap<>();
                        ct.put("id", null);
                        ct.put("name", style);
                        ct.put("cost", 0.0);
                        ct.put("slotCount", 0);
                        classTypes.add(ct);
                    });
        }
        meta.put("classTypes", classTypes);

        LinkedHashSet<String> instructors = new LinkedHashSet<>();
        if (center.getName() != null) {
            instructors.add(center.getName());
        }
        batches.stream()
                .map(MartialArtsBatch::getInstructor)
                .filter(i -> i != null && !i.isBlank())
                .forEach(instructors::add);
        meta.put("instructors", new ArrayList<>(instructors));

        return meta;
    }

    private static String dayCodeForToday() {
        return switch (LocalDate.now().getDayOfWeek()) {
            case MONDAY -> "MON";
            case TUESDAY -> "TUE";
            case WEDNESDAY -> "WED";
            case THURSDAY -> "THU";
            case FRIDAY -> "FRI";
            case SATURDAY -> "SAT";
            case SUNDAY -> "SUN";
        };
    }

    // ---------- UPDATE ----------
    @RequestMapping(value = "/update/{centerId}", method = RequestMethod.POST)
    public String updateCenterDetails(@PathVariable Long centerId,
                                      @ModelAttribute MartialArtsCenter updatedCenter,
                                      @RequestParam(value = "file", required = false) MultipartFile file,
                                      @RequestParam(value = "galleryPhotos", required = false) MultipartFile[] galleryPhotos,
                                      @RequestParam(value = "types", required = false) List<Long> typeIds,
                                      RedirectAttributes redirectAttributes) throws IOException {
        centreService.updateCenterDetails(centerId, updatedCenter, file, galleryPhotos, typeIds);
        redirectAttributes.addFlashAttribute("message", "Center details updated successfully!");
        return "redirect:/centres/details/" + centerId;
    }

    // ---------- UPDATE FORM ----------
    @RequestMapping(value = "/updateCentre/{id}", method = RequestMethod.GET)
    public String showUpdateCentreForm(@PathVariable Long id, Model model) {
        MartialArtsCenter center = centreService.getCenterById(id);
        if (center == null) return "errorPage";

        List<MartialArtsType> allTypes = typeRepository.findAll();
        List<Long> selectedTypeIds = center.getMartialArtsTypes()
                                           .stream()
                                           .map(MartialArtsType::getId)
                                           .toList();

        model.addAttribute("center", center);
        model.addAttribute("allTypes", allTypes);
        model.addAttribute("selectedTypeIds", selectedTypeIds);

        return "updateCentre";
    }

    // ---------- ABOUT PAGE ----------
    @RequestMapping(value = "/about/{id}", method = RequestMethod.GET)
    public String showCenterProfile(@PathVariable Long id, Model model) {
        MartialArtsCenter center = centreService.getCenterById(id);
        if (center == null) return "errorPage";
        List<MartialArtsType> types = centreService.getMartialArtsTypes(id);
        
        List<DayAvailable> sortedDays = new ArrayList<>();
        if (center.getAvailableDays() != null) {
            sortedDays.addAll(center.getAvailableDays());
            sortedDays.sort((d1, d2) -> d1.ordinal() - d2.ordinal());
        }
        
        model.addAttribute("center", center);
        model.addAttribute("sortedAvailableDays", sortedDays);
        model.addAttribute("types", types);
        return "aboutCentre";
    }

    // ---------- DELETE ----------
    @RequestMapping(value = "/delete/{id}", method = RequestMethod.POST)
    public String deleteCenter(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        boolean isDeleted = centreService.deleteCenter(id);
        if (isDeleted) {
            redirectAttributes.addFlashAttribute("message", "Center deleted successfully!");
        } else {
            redirectAttributes.addFlashAttribute("error", "Failed to delete center.");
        }
        return "redirect:/centres/allcentres";
    }

    // ---------- BATCH MANAGEMENT API ----------
    
    @PostMapping("/batches/create")
    @ResponseBody
    public Map<String, Object> createBatch(@RequestBody MartialArtsBatch batch, HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        try {
            MartialArtsCenter sessionCenter = (MartialArtsCenter) session.getAttribute("loggedCentre");
            if (sessionCenter == null) {
                response.put("success", false);
                response.put("message", "User not logged in. Please sign in again.");
                return response;
            }
            MartialArtsCenter center = centreRepository.findById(sessionCenter.getId()).orElse(sessionCenter);

            // Approval gate enforcement
            if (!center.isApproved() && center.getCentreProfileStatus() != CentreProfileStatus.APPROVED) {
                response.put("success", false);
                response.put("message", "Your centre must be approved by an Admin before you can publish batches.");
                return response;
            }

            // Discipline validation: reject fitness-only styles
            if (batch.getStyle() != null) {
                String style = batch.getStyle().trim();
                if (in.sp.main.Util.MartialArtsDiscoveryFilter.isFitnessOnlyProgram(style)) {
                    response.put("success", false);
                    response.put("message", "Gym, Zumba, Yoga and fitness programs belong under Fitness & Wellness. Please select a martial arts style.");
                    return response;
                }
            }

            // If updating existing batch, verify ownership
            if (batch.getId() != null) {
                MartialArtsBatch existing = batchRepository.findById(batch.getId()).orElse(null);
                if (existing == null) {
                    response.put("success", false);
                    response.put("message", "Batch not found.");
                    return response;
                }
                if (existing.getCenter() != null && !existing.getCenter().getId().equals(center.getId())) {
                    response.put("success", false);
                    response.put("message", "Unauthorized. You do not own this batch.");
                    return response;
                }
            }

            batch.setCenter(center);
            if (batch.getStatus() == null || batch.getStatus().isBlank()) {
                batch.setStatus("Active");
            }
            if (batch.getBatchType() == null || batch.getBatchType().isBlank()) {
                batch.setBatchType("Offline");
            }

            MartialArtsBatch savedBatch = batchRepository.save(batch);
            response.put("success", true);
            response.put("message", "Batch saved successfully");
            response.put("batch", savedBatch);
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Failed to save batch: " + e.getMessage());
        }
        return response;
    }

    @GetMapping("/batches/details/{id}")
    @ResponseBody
    public Map<String, Object> getBatchDetails(@PathVariable Long id, HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        MartialArtsCenter sessionCenter = (MartialArtsCenter) session.getAttribute("loggedCentre");
        if (sessionCenter == null) {
            response.put("success", false);
            response.put("message", "User not logged in");
            return response;
        }
        MartialArtsBatch batch = batchRepository.findById(id).orElse(null);
        if (batch == null) {
            response.put("success", false);
            response.put("message", "Batch not found");
            return response;
        }
        if (batch.getCenter() == null || !batch.getCenter().getId().equals(sessionCenter.getId())) {
            response.put("success", false);
            response.put("message", "Access denied.");
            return response;
        }
        response.put("success", true);
        response.put("batch", batch);
        response.put("enrolledCount", enrollmentRepository.countByBatchId(id));
        return response;
    }

    @PostMapping("/batches/status/{id}")
    @ResponseBody
    public Map<String, Object> updateBatchStatus(@PathVariable Long id,
                                                 @RequestParam String status,
                                                 HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        MartialArtsCenter sessionCenter = (MartialArtsCenter) session.getAttribute("loggedCentre");
        if (sessionCenter == null) {
            response.put("success", false);
            response.put("message", "User not logged in");
            return response;
        }
        MartialArtsBatch batch = batchRepository.findById(id).orElse(null);
        if (batch == null) {
            response.put("success", false);
            response.put("message", "Batch not found");
            return response;
        }
        if (batch.getCenter() == null || !batch.getCenter().getId().equals(sessionCenter.getId())) {
            response.put("success", false);
            response.put("message", "Access denied.");
            return response;
        }
        batch.setStatus(status);
        batchRepository.save(batch);
        response.put("success", true);
        response.put("message", "Batch status updated to " + status);
        response.put("status", status);
        return response;
    }

    @GetMapping("/batches/center/{id}")
    @ResponseBody
    public List<MartialArtsBatch> getBatchesByCenter(@PathVariable Long id) {
        return batchRepository.findByCenterId(id);
    }

    @PostMapping("/batches/delete/{id}")
    @ResponseBody
    public Map<String, Object> deleteBatch(@PathVariable Long id, HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        try {
            MartialArtsCenter sessionCenter = (MartialArtsCenter) session.getAttribute("loggedCentre");
            if (sessionCenter == null) {
                response.put("success", false);
                response.put("message", "User not logged in");
                return response;
            }
            MartialArtsBatch batch = batchRepository.findById(id).orElse(null);
            if (batch == null) {
                response.put("success", false);
                response.put("message", "Batch not found");
                return response;
            }
            if (batch.getCenter() == null || !batch.getCenter().getId().equals(sessionCenter.getId())) {
                response.put("success", false);
                response.put("message", "Unauthorized. You do not own this batch.");
                return response;
            }

            long enrolledCount = enrollmentRepository.countByBatchId(id);
            if (enrolledCount > 0) {
                batch.setStatus("Closed");
                batchRepository.save(batch);
                response.put("success", true);
                response.put("archived", true);
                response.put("message", "Batch has " + enrolledCount + " active enrollment(s). It has been closed/archived instead of hard deleted.");
                return response;
            }

            batchRepository.delete(batch);
            response.put("success", true);
            response.put("message", "Batch deleted successfully");
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Error deleting batch: " + e.getMessage());
        }
        return response;
    }

    // ==========================================
    // QR ATTENDANCE SESSIONS (CENTRE / TRAINER)
    // ==========================================

    @PostMapping("/api/qr-session")
    @ResponseBody
    public ResponseEntity<?> createQrSession(@RequestBody Map<String, Object> body, HttpSession session) {
        MartialArtsCenter centre = (MartialArtsCenter) session.getAttribute("loggedCentre");
        if (centre == null) return ResponseEntity.status(401).body(Map.of("success", false, "error", "Centre login required"));

        try {
            Long batchId = Long.parseLong(body.get("batchId").toString());
            String dateStr = (String) body.get("date");
            LocalDate date = (dateStr != null && !dateStr.isBlank()) ? LocalDate.parse(dateStr) : LocalDate.now();
            int duration = body.get("duration") != null ? Integer.parseInt(body.get("duration").toString()) : 15;

            QrAttendanceSession qrSession = qrAttendanceService.createOrRefreshSession(centre, batchId, date, duration);

            Map<String, Object> res = new LinkedHashMap<>();
            res.put("success", true);
            res.put("sessionId", qrSession.getId());
            res.put("token", qrSession.getToken());
            res.put("batchId", batchId);
            res.put("batchName", qrSession.getBatch().getName());
            res.put("sessionDate", qrSession.getSessionDate().toString());
            res.put("expiresAt", qrSession.getExpiresAt().toString());
            res.put("active", qrSession.isActive());
            return ResponseEntity.ok(res);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("success", false, "error", e.getMessage()));
        }
    }

    @GetMapping("/api/qr-session")
    @ResponseBody
    public ResponseEntity<?> getActiveQrSession(@RequestParam Long batchId, @RequestParam(required = false) String date, HttpSession session) {
        MartialArtsCenter centre = (MartialArtsCenter) session.getAttribute("loggedCentre");
        if (centre == null) return ResponseEntity.status(401).body(Map.of("success", false, "error", "Centre login required"));

        LocalDate sessionDate = (date != null && !date.isBlank()) ? LocalDate.parse(date) : LocalDate.now();
        Optional<QrAttendanceSession> opt = qrAttendanceService.getActiveSession(batchId, sessionDate);

        if (opt.isEmpty()) {
            return ResponseEntity.ok(Map.of("success", false, "active", false, "message", "No active QR session for this batch today"));
        }

        QrAttendanceSession s = opt.get();
        Map<String, Object> res = new LinkedHashMap<>();
        res.put("success", true);
        res.put("active", true);
        res.put("sessionId", s.getId());
        res.put("token", s.getToken());
        res.put("batchName", s.getBatch().getName());
        res.put("sessionDate", s.getSessionDate().toString());
        res.put("expiresAt", s.getExpiresAt().toString());
        return ResponseEntity.ok(res);
    }

    @PostMapping("/api/qr-session/{id}/close")
    @ResponseBody
    public ResponseEntity<?> closeQrSession(@PathVariable Long id, HttpSession session) {
        MartialArtsCenter centre = (MartialArtsCenter) session.getAttribute("loggedCentre");
        if (centre == null) return ResponseEntity.status(401).body(Map.of("success", false, "error", "Centre login required"));

        try {
            qrAttendanceService.closeSession(id, centre);
            return ResponseEntity.ok(Map.of("success", true, "message", "QR attendance session closed successfully"));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("success", false, "error", e.getMessage()));
        }
    }

    // ==========================================
    // BELT GRADING & SKILL ASSESSMENTS (CENTRE)
    // ==========================================

    @GetMapping("/api/grading/criteria")
    @ResponseBody
    public ResponseEntity<?> getGradingCriteria(@RequestParam(required = false) String discipline) {
        List<String> criteria = beltGradingService.getDisciplineCriteria(discipline);
        List<String> belts = beltGradingService.getBeltHierarchy(discipline);
        return ResponseEntity.ok(Map.of("success", true, "criteria", criteria, "belts", belts));
    }

    @GetMapping("/api/gradings")
    @ResponseBody
    public ResponseEntity<?> getCentreGradings(HttpSession session) {
        MartialArtsCenter centre = (MartialArtsCenter) session.getAttribute("loggedCentre");
        if (centre == null) return ResponseEntity.status(401).body(Map.of("success", false, "error", "Centre login required"));

        List<Map<String, Object>> list = beltGradingService.getCentreGradingHistory(centre.getId());
        return ResponseEntity.ok(Map.of("success", true, "gradings", list));
    }

    @PostMapping("/api/gradings/schedule")
    @ResponseBody
    public ResponseEntity<?> scheduleGrading(@RequestBody Map<String, Object> body, HttpSession session) {
        MartialArtsCenter centre = (MartialArtsCenter) session.getAttribute("loggedCentre");
        if (centre == null) return ResponseEntity.status(401).body(Map.of("success", false, "error", "Centre login required"));

        try {
            Long studentId = Long.parseLong(body.get("studentId").toString());
            Long batchId = body.get("batchId") != null ? Long.parseLong(body.get("batchId").toString()) : null;
            String discipline = (String) body.get("discipline");
            String targetBelt = (String) body.get("targetBelt");
            String dateStr = (String) body.get("scheduledDate");
            LocalDate date = (dateStr != null && !dateStr.isBlank()) ? LocalDate.parse(dateStr) : LocalDate.now();
            String trainer = (String) body.get("trainerName");

            BeltGradingAssessment assessment = beltGradingService.scheduleGrading(
                    centre, studentId, batchId, discipline, targetBelt, date, trainer
            );
            return ResponseEntity.ok(Map.of("success", true, "message", "Grading scheduled successfully", "assessment", beltGradingService.assessmentSummary(assessment)));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("success", false, "error", e.getMessage()));
        }
    }

    @PostMapping("/api/gradings/{id}/score")
    @ResponseBody
    public ResponseEntity<?> conductAssessment(
            @PathVariable Long id,
            @RequestBody Map<String, Object> body,
            HttpSession session) {
        MartialArtsCenter centre = (MartialArtsCenter) session.getAttribute("loggedCentre");
        if (centre == null) return ResponseEntity.status(401).body(Map.of("success", false, "error", "Centre login required"));

        try {
            Map<String, Integer> criteriaScores = (Map<String, Integer>) body.get("scores");
            String remarks = (String) body.get("remarks");
            String examinerNotes = (String) body.get("examinerNotes");
            String trainerName = (String) body.get("trainerName");
            boolean autoPromote = body.get("autoPromote") != null && Boolean.parseBoolean(body.get("autoPromote").toString());

            BeltGradingAssessment assessment = beltGradingService.conductAndScoreAssessment(
                    centre, id, criteriaScores, remarks, examinerNotes, trainerName, autoPromote
            );
            return ResponseEntity.ok(Map.of(
                    "success", true,
                    "message", assessment.getPassed() ? "Assessment passed! " + (autoPromote ? "Student promoted & Certificate generated." : "Awaiting approval.") : "Assessment submitted as Failed.",
                    "assessment", beltGradingService.assessmentSummary(assessment)
            ));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("success", false, "error", e.getMessage()));
        }
    }

    @PostMapping("/api/gradings/{id}/promote")
    @ResponseBody
    public ResponseEntity<?> approveAndPromote(@PathVariable Long id, HttpSession session) {
        MartialArtsCenter centre = (MartialArtsCenter) session.getAttribute("loggedCentre");
        if (centre == null) return ResponseEntity.status(401).body(Map.of("success", false, "error", "Centre login required"));

        try {
            BeltGradingAssessment assessment = beltGradingService.approveAndPromote(centre, id);
            return ResponseEntity.ok(Map.of(
                    "success", true,
                    "message", "Belt promotion approved! Digital Certificate generated.",
                    "assessment", beltGradingService.assessmentSummary(assessment)
            ));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("success", false, "error", e.getMessage()));
        }
    }

    // ==========================================
    // INSTRUCTOR STAFF MANAGEMENT (CENTRE)
    // ==========================================

    @GetMapping("/api/instructors")
    @ResponseBody
    public ResponseEntity<?> getInstructors(HttpSession session) {
        MartialArtsCenter centre = (MartialArtsCenter) session.getAttribute("loggedCentre");
        if (centre == null) return ResponseEntity.status(401).body(Map.of("success", false, "error", "Centre login required"));

        List<CentreInstructor> list = instructorRepository.findByCenter_IdAndActiveTrue(centre.getId());
        return ResponseEntity.ok(Map.of("success", true, "instructors", list));
    }

    @PostMapping("/api/instructors")
    @ResponseBody
    public ResponseEntity<?> createInstructor(@RequestBody Map<String, String> body, HttpSession session) {
        MartialArtsCenter centre = (MartialArtsCenter) session.getAttribute("loggedCentre");
        if (centre == null) return ResponseEntity.status(401).body(Map.of("success", false, "error", "Centre login required"));

        String name = body.get("name");
        if (name == null || name.isBlank()) {
            return ResponseEntity.badRequest().body(Map.of("success", false, "error", "Instructor name is required"));
        }

        CentreInstructor inst = new CentreInstructor();
        inst.setCenter(centre);
        inst.setName(name.trim());
        inst.setEmail(body.get("email"));
        inst.setPhone(body.get("phone"));
        inst.setDesignation(body.getOrDefault("designation", "Instructor"));
        inst.setSpecialization(body.getOrDefault("specialization", "General Martial Arts"));
        inst.setExperienceYears(body.getOrDefault("experienceYears", "1+ years"));
        inst.setActive(true);
        instructorRepository.save(inst);

        return ResponseEntity.ok(Map.of("success", true, "message", "Instructor added successfully", "instructor", inst));
    }

    @DeleteMapping("/api/instructors/{id}")
    @ResponseBody
    public ResponseEntity<?> removeInstructor(@PathVariable Long id, HttpSession session) {
        MartialArtsCenter centre = (MartialArtsCenter) session.getAttribute("loggedCentre");
        if (centre == null) return ResponseEntity.status(401).body(Map.of("success", false, "error", "Centre login required"));

        CentreInstructor inst = instructorRepository.findById(id).orElse(null);
        if (inst == null || !inst.getCenter().getId().equals(centre.getId())) {
            return ResponseEntity.badRequest().body(Map.of("success", false, "error", "Instructor not found"));
        }
        inst.setActive(false);
        instructorRepository.save(inst);
        return ResponseEntity.ok(Map.of("success", true, "message", "Instructor removed successfully"));
    }

    // ==========================================
    // STUDENT RENEWAL & GRACE PERIOD
    // ==========================================

    @PostMapping("/api/enrollments/{id}/renewal")
    @ResponseBody
    public ResponseEntity<?> updateRenewal(
            @PathVariable Long id,
            @RequestBody Map<String, String> body,
            HttpSession session) {
        MartialArtsCenter centre = (MartialArtsCenter) session.getAttribute("loggedCentre");
        if (centre == null) return ResponseEntity.status(401).body(Map.of("success", false, "error", "Centre login required"));

        Enrollment e = enrollmentRepository.findById(id).orElse(null);
        if (e == null || e.getCenter() == null || !e.getCenter().getId().equals(centre.getId())) {
            return ResponseEntity.badRequest().body(Map.of("success", false, "error", "Enrollment not found"));
        }

        String renewalStatus = body.get("renewalStatus");
        String nextDueDateStr = body.get("nextRenewalDate");

        if (renewalStatus != null) e.setRenewalStatus(renewalStatus);
        if (nextDueDateStr != null && !nextDueDateStr.isBlank()) {
            e.setNextRenewalDate(LocalDate.parse(nextDueDateStr));
        }
        enrollmentRepository.save(e);

        return ResponseEntity.ok(Map.of("success", true, "message", "Renewal status updated"));
    }
}

