package in.sp.main.Controller;

import java.io.IOException;
import java.time.LocalDate;
import java.util.*;
import java.util.stream.Collectors;
import org.springframework.http.MediaType;
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
            @RequestParam("martialArtsJson") String martialArtsJson,
            RedirectAttributes redirectAttributes) {

        try {
            if (center.getEmail() == null || center.getEmail().isBlank()) {
                redirectAttributes.addFlashAttribute("error", "Email is required.");
                return "redirect:/centres/registerCentre";
            }
            String email = center.getEmail().trim().toLowerCase();
            center.setEmail(email);

            if (centreRepository.findByEmail(email).isPresent()) {
                redirectAttributes.addFlashAttribute("error", "Email already exists. Please login.");
                return "redirect:/centres/login";
            }

            if (center.getPhoneNumber() == null || !center.getPhoneNumber().trim().matches("^\\d{10}$")) {
                redirectAttributes.addFlashAttribute("error", "Phone number must be exactly 10 digits.");
                return "redirect:/centres/registerCentre";
            }

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

            if (types == null || types.isEmpty()) {
                redirectAttributes.addFlashAttribute("error",
                        "Please add at least one martial arts program with time slots.");
                return "redirect:/centres/registerCentre";
            }

            for (MartialArtsType type : types) {
                if (type.getName() == null || type.getName().isBlank()) {
                    redirectAttributes.addFlashAttribute("error", "Each program must have a name.");
                    return "redirect:/centres/registerCentre";
                }
                type.setCentre(center);
                if (type.getSlots() != null) {
                    for (Slot slot : type.getSlots()) {
                        slot.setMartialArtsType(type);
                    }
                }
            }

            if (availableDays != null) {
                center.setAvailableDays(new TreeSet<>(availableDays));
            } else {
                center.setAvailableDays(new TreeSet<>());
            }

            centreService.register(center, certificate, types, profilePhoto);

            redirectAttributes.addFlashAttribute("message",
                    "Centre registered successfully! Wait for admin approval, then sign in with your email and password.");
            return "redirect:/centres/success";

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
        
        if (user != null) {
            List<Enrollment> enrollments = enrollmentRepository.findByUser(user);
            Set<Long> enrolledBatchIds = enrollments.stream()
                .filter(e -> e.getBatch() != null)
                .map(e -> e.getBatch().getId())
                .collect(Collectors.toSet());
            model.addAttribute("enrolledBatchIds", enrolledBatchIds);
        }
        
        model.addAttribute("centers", centers);
        model.addAttribute("approvedCentreCount", centers.size());
        model.addAttribute("totalBatchCount", totalBatches);
        model.addAttribute("videos", videos);
        model.addAttribute("user", user);
        model.addAttribute("activeTab", "explore");

        // Sorting days for all centers chronologically
        for (MartialArtsCenter c : centers) {
            if (c.getAvailableDays() != null) {
                List<DayAvailable> sortedList = new ArrayList<>(c.getAvailableDays());
                sortedList.sort((d1, d2) -> d1.ordinal() - d2.ordinal());
                c.setAvailableDays(new LinkedHashSet<>(sortedList));
            }
        }

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
            List<DayAvailable> sortedDays = new ArrayList<>(center.getAvailableDays());
            sortedDays.sort((d1, d2) -> d1.ordinal() - d2.ordinal());

            // Build enrolled count map for capacity display on each batch
            java.util.Map<Long, Long> enrolledCountByBatch = new java.util.HashMap<>();
            for (MartialArtsBatch batch : center.getBatches()) {
                long count = enrollmentRepository.countPaidByBatchId(batch.getId());
                enrolledCountByBatch.put(batch.getId(), count);
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
                    "No centre found for this email. Please complete registration first.");
            return "redirect:/centres/registerCentre";
        }
        MartialArtsCenter center = centerOpt.get();
        if (center.getPassword() == null || !center.getPassword().equals(password)) {
            redirectAttributes.addFlashAttribute("error", "Invalid email or password.");
            return "redirect:/centres/login";
        }
        if (!center.isApproved()) {
            redirectAttributes.addFlashAttribute("error",
                    "Your centre is registered but not yet approved by admin. You will be able to sign in after approval.");
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
        
        return "redirect:/centres/dashboard";
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
        res.put("batches", buildBatchMaps(batches, onlineClassRepository.findByCenter_Id(center.getId())));
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
        List<OnlineClass> onlineClasses = onlineClassRepository.findByCenter_Id(center.getId());

        double totalEarnings = enrollments.stream()
                .filter(e -> e.getAmountPaid() != null)
                .mapToDouble(Enrollment::getAmountPaid)
                .sum();

        model.addAttribute("center", center);
        model.addAttribute("enrollments", enrollments);
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
            bMap.put("status", b.getStatus());
            bMap.put("batchType", b.getBatchType());
            bMap.put("meetingLink", b.getMeetingLink());
            bMap.put("capacity", b.getCapacity());
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
        List<MartialArtsType> types = centreService.getMartialArtsTypes(id);
        if (center == null) return "errorPage";
        
        List<DayAvailable> sortedDays = new ArrayList<>(center.getAvailableDays());
        sortedDays.sort((d1, d2) -> d1.ordinal() - d2.ordinal());
        
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
            MartialArtsCenter center = (MartialArtsCenter) session.getAttribute("loggedCentre");
            if (center == null) {
                response.put("success", false);
                response.put("message", "User not logged in");
                return response;
            }
            batch.setCenter(center);
            MartialArtsBatch savedBatch = batchRepository.save(batch);
            response.put("success", true);
            response.put("batch", savedBatch);
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", e.getMessage());
        }
        return response;
    }

    @GetMapping("/batches/center/{id}")
    @ResponseBody
    public List<MartialArtsBatch> getBatchesByCenter(@PathVariable Long id) {
        return batchRepository.findByCenterId(id);
    }

    @PostMapping("/batches/delete/{id}")
    @ResponseBody
    public Map<String, Object> deleteBatch(@PathVariable Long id) {
        Map<String, Object> response = new HashMap<>();
        try {
            batchRepository.deleteById(id);
            response.put("success", true);
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", e.getMessage());
        }
        return response;
    }
}
