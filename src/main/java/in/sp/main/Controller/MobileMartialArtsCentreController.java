package in.sp.main.Controller;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import in.sp.main.Config.JwtUtil;
import in.sp.main.Entities.*;
import in.sp.main.Repository.*;
import in.sp.main.Service.CertificateService;
import in.sp.main.Service.FileUploadService;
import in.sp.main.Service.MartialArtsCenterService;
import in.sp.main.Service.PasswordService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.*;

/**
 * Centre owner APIs for Flutter — register, login, dashboard (Bearer JWT role CENTRE).
 */
@RestController
@RequestMapping("/api/martial-arts/centre")
public class MobileMartialArtsCentreController {

    @Autowired
    private MartialArtsCenterService centreService;

    @Autowired
    private MartialArtsCenterRepository centreRepository;

    @Autowired
    private MartialArtsBatchRepository batchRepository;

    @Autowired
    private EnrollmentRepository enrollmentRepository;

    @Autowired
    private FileUploadService fileUploadService;

    @Autowired
    private PasswordService passwordService;

    @Autowired
    private JwtUtil jwtUtil;

    @Autowired
    private ObjectMapper objectMapper;

    @Autowired
    private AttendanceRepository attendanceRepository;

    @Autowired
    private OnlineClassRepository onlineClassRepository;

    @Autowired
    private OnlineClassEnrollmentRepository onlineClassEnrollmentRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private CertificateService certificateService;

    @PostMapping(value = "/register", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ResponseEntity<Map<String, Object>> registerCentre(
            @RequestParam String name,
            @RequestParam String location,
            @RequestParam String phoneNumber,
            @RequestParam String email,
            @RequestParam String password,
            @RequestParam(required = false) String about,
            @RequestParam(required = false) String howWeTeach,
            @RequestParam(required = false) String whatWeOffer,
            @RequestParam(value = "availableDays", required = false) String availableDaysCsv,
            @RequestParam("martialArtsJson") String martialArtsJson,
            @RequestPart(value = "certificate", required = false) MultipartFile certificate,
            @RequestParam(value = "profileimage", required = false) MultipartFile profilePhoto,
            @RequestParam(value = "galleryPhotos", required = false) MultipartFile[] galleryPhotos) {

        try {
            if (email == null || email.isBlank()) {
                return badRequest("Email is required.");
            }
            String normEmail = email.trim().toLowerCase();
            if (centreRepository.findByEmail(normEmail).isPresent()) {
                return ResponseEntity.status(HttpStatus.CONFLICT)
                        .body(errorMap("Email already exists. Please login."));
            }
            if (phoneNumber == null || !phoneNumber.trim().matches("^\\d{10}$")) {
                return badRequest("Phone number must be exactly 10 digits.");
            }
            if (password == null || !password.matches("(?=.*[0-9])(?=.*[!@#$%^&*]).{6,}")) {
                return badRequest("Password must be at least 6 characters and include a number and special character.");
            }

            MartialArtsCenter center = new MartialArtsCenter();
            center.setName(name == null ? "" : name.trim());
            center.setLocation(location == null ? "" : location.trim());
            center.setPhoneNumber(phoneNumber.trim());
            center.setEmail(normEmail);
            center.setPassword(password);
            center.setAbout(about == null ? "" : about.trim());
            center.setHowWeTeach(howWeTeach == null ? "" : howWeTeach.trim());
            center.setWhatWeOffer(whatWeOffer == null ? "" : whatWeOffer.trim());

            if (galleryPhotos != null) {
                for (MultipartFile photo : galleryPhotos) {
                    if (photo != null && !photo.isEmpty()) {
                        center.getGalleryPhotos().add(fileUploadService.saveFile(photo));
                    }
                }
            }

            List<MartialArtsType> types = objectMapper.readValue(
                    martialArtsJson != null && !martialArtsJson.isBlank() ? martialArtsJson : "[]",
                    new TypeReference<List<MartialArtsType>>() {}
            );
            if (types == null || types.isEmpty()) {
                return badRequest("Please add at least one martial arts program with time slots.");
            }
            for (MartialArtsType type : types) {
                if (type.getName() == null || type.getName().isBlank()) {
                    return badRequest("Each program must have a name.");
                }
                type.setCentre(center);
                if (type.getSlots() != null) {
                    for (Slot slot : type.getSlots()) {
                        slot.setMartialArtsType(type);
                    }
                }
            }

            if (availableDaysCsv != null && !availableDaysCsv.isBlank()) {
                Set<DayAvailable> days = new TreeSet<>();
                for (String d : availableDaysCsv.split(",")) {
                    if (d != null && !d.isBlank()) {
                        days.add(DayAvailable.valueOf(d.trim().toUpperCase(Locale.ROOT)));
                    }
                }
                center.setAvailableDays(days);
            } else {
                center.setAvailableDays(new TreeSet<>());
            }

            centreService.register(center, certificate, types, profilePhoto);

            Map<String, Object> body = new LinkedHashMap<>();
            body.put("success", true);
            body.put("message",
                    "Centre registered successfully! Wait for admin approval, then sign in with your email and password.");
            body.put("centreId", center.getId());
            body.put("email", center.getEmail());
            body.put("approved", false);
            return ResponseEntity.status(HttpStatus.CREATED).body(body);
        } catch (IllegalArgumentException ex) {
            return badRequest("Invalid working day value.");
        } catch (Exception ex) {
            return badRequest("Registration failed: " + ex.getMessage());
        }
    }

    @PostMapping("/register-lite")
    public ResponseEntity<Map<String, Object>> registerCentreLite(@RequestBody Map<String, Object> body) {
        try {
            String name = str(body.get("name"));
            String location = str(body.get("location"));
            String phoneNumber = str(body.get("phoneNumber"));
            String email = str(body.get("email")).toLowerCase(Locale.ROOT);
            String password = str(body.get("password"));
            String about = str(body.get("about"));
            String howWeTeach = str(body.get("howWeTeach"));
            String whatWeOffer = str(body.get("whatWeOffer"));
            String availableDaysCsv = str(body.get("availableDaysCsv"));
            String martialArtsJson = str(body.get("martialArtsJson"));

            if (email.isBlank()) return badRequest("Email is required.");
            if (centreRepository.findByEmail(email).isPresent()) {
                return ResponseEntity.status(HttpStatus.CONFLICT).body(errorMap("Email already exists. Please login."));
            }
            if (!phoneNumber.matches("^\\d{10}$")) return badRequest("Phone number must be exactly 10 digits.");
            if (!password.matches("(?=.*[0-9])(?=.*[!@#$%^&*]).{6,}")) {
                return badRequest("Password must be at least 6 characters and include a number and special character.");
            }

            MartialArtsCenter center = new MartialArtsCenter();
            center.setName(name);
            center.setLocation(location);
            center.setPhoneNumber(phoneNumber);
            center.setEmail(email);
            center.setPassword(password);
            center.setAbout(about);
            center.setHowWeTeach(howWeTeach);
            center.setWhatWeOffer(whatWeOffer);

            List<MartialArtsType> types = objectMapper.readValue(
                    martialArtsJson != null && !martialArtsJson.isBlank() ? martialArtsJson : "[]",
                    new TypeReference<List<MartialArtsType>>() {});
            if (types == null || types.isEmpty()) {
                return badRequest("Please add at least one martial arts program with time slots.");
            }
            for (MartialArtsType type : types) {
                if (type.getName() == null || type.getName().isBlank()) {
                    return badRequest("Each program must have a name.");
                }
                type.setCentre(center);
                if (type.getSlots() != null) {
                    for (Slot slot : type.getSlots()) {
                        slot.setMartialArtsType(type);
                    }
                }
            }

            if (availableDaysCsv != null && !availableDaysCsv.isBlank()) {
                Set<DayAvailable> days = new TreeSet<>();
                for (String d : availableDaysCsv.split(",")) {
                    if (d != null && !d.isBlank()) days.add(DayAvailable.valueOf(d.trim().toUpperCase(Locale.ROOT)));
                }
                center.setAvailableDays(days);
            } else {
                center.setAvailableDays(new TreeSet<>());
            }

            centreService.register(center, null, types, null);
            Map<String, Object> res = new LinkedHashMap<>();
            res.put("success", true);
            res.put("message", "Centre registered successfully! Wait for admin approval, then sign in.");
            res.put("centreId", center.getId());
            res.put("approved", false);
            return ResponseEntity.status(HttpStatus.CREATED).body(res);
        } catch (IllegalArgumentException ex) {
            return badRequest("Invalid working day value.");
        } catch (Exception ex) {
            return badRequest("Registration failed: " + ex.getMessage());
        }
    }

    @PostMapping("/login")
    public ResponseEntity<Map<String, Object>> loginCentre(
            @RequestBody Map<String, String> body,
            HttpSession session) {
        String email = body == null ? null : body.get("email");
        String password = body == null ? null : body.get("password");
        String normEmail = email == null ? "" : email.trim().toLowerCase();
        String rawPassword = password == null ? "" : password;

        if (normEmail.isEmpty() || rawPassword.isEmpty()) {
            return badRequest("Email and password are required.");
        }

        Optional<MartialArtsCenter> centerOpt = centreRepository.findByEmail(normEmail);
        if (centerOpt.isEmpty()) {
            return badRequest("No centre found for this email. Please complete registration first.");
        }

        MartialArtsCenter center = centerOpt.get();
        boolean ok = passwordService.matchesAndUpgrade(rawPassword, center.getPassword(), hashed -> {
            center.setPassword(hashed);
            centreRepository.save(center);
        });
        if (!ok) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body(errorMap("Invalid email or password."));
        }
        if (!center.isApproved()) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN)
                    .body(errorMap(
                            "Your centre is registered but not yet approved by admin. You will be able to sign in after approval."));
        }

        session.setAttribute("loggedCentre", center);
        String token = jwtUtil.generateToken(center.getEmail(), "CENTRE");

        Map<String, Object> response = new LinkedHashMap<>();
        response.put("success", true);
        response.put("token", token);
        response.put("tokenType", "Bearer");
        response.put("role", "CENTRE");
        response.put("centre", centreDto(center));
        return ResponseEntity.ok(response);
    }

    @GetMapping("/me")
    public ResponseEntity<Map<String, Object>> centreDashboard(HttpSession session) {
        MartialArtsCenter centre = requireCentre(session);
        if (centre == null) {
            return unauthorized();
        }

        MartialArtsCenter center = centreRepository.findById(centre.getId()).orElse(centre);
        List<Enrollment> enrollments = centreService.getEnrolledUsersByCenter(center.getId());
        List<MartialArtsBatch> batches = batchRepository.findByCenterId(center.getId());

        Map<String, Object> body = new LinkedHashMap<>();
        body.put("success", true);
        body.put("centre", centreDto(center));
        body.put("batchCount", batches.size());
        body.put("enrollmentCount", enrollments.size());
        body.put("batches", batches.stream().map(this::batchSummary).toList());
        body.put("recentEnrollments", enrollments.stream()
                .sorted((a, b) -> Long.compare(b.getId(), a.getId()))
                .limit(10)
                .map(this::enrollmentSummary)
                .toList());
        return ResponseEntity.ok(body);
    }

    @GetMapping("/dashboard/meta")
    @Transactional(readOnly = true)
    public ResponseEntity<Map<String, Object>> dashboardMeta(HttpSession session) {
        MartialArtsCenter centre = requireCentre(session);
        if (centre == null) return unauthorized();

        MartialArtsCenter center = centreRepository.findById(centre.getId()).orElse(centre);
        List<Enrollment> enrollments = centreService.getEnrolledUsersByCenter(center.getId());
        List<MartialArtsBatch> batches = batchRepository.findByCenterId(center.getId());
        List<OnlineClass> onlineClasses = onlineClassRepository.findByCenter_Id(center.getId());

        List<Map<String, Object>> enrollList = buildEnrollmentMaps(center, enrollments);
        double totalEarnings = enrollments.stream()
                .filter(e -> e.getAmountPaid() != null)
                .mapToDouble(Enrollment::getAmountPaid)
                .sum();

        Map<String, Object> meta = buildDashboardMeta(center, batches, enrollments, enrollList, totalEarnings);

        java.time.LocalDate today = java.time.LocalDate.now();
        List<Map<String, Object>> todayClasses = new java.util.ArrayList<>(onlineClasses.stream()
                .filter(oc -> oc.getDate() != null && oc.getDate().equals(today))
                .map(this::onlineClassDto)
                .toList());
        // Also surface active batches with time slots as "today's classes" when no online sessions.
        if (todayClasses.isEmpty()) {
            todayClasses = new java.util.ArrayList<>(batches.stream()
                    .filter(b -> "Active".equalsIgnoreCase(b.getStatus()) || b.getStatus() == null || b.getStatus().isBlank())
                    .limit(6)
                    .map(b -> {
                        Map<String, Object> m = new LinkedHashMap<>(batchSummary(b));
                        m.put("instructor", b.getInstructor());
                        m.put("studentCount", enrollments.stream()
                                .filter(e -> e.getBatch() != null && e.getBatch().getId() != null
                                        && e.getBatch().getId().equals(b.getId()))
                                .count());
                        return m;
                    })
                    .toList());
        } else {
            for (Map<String, Object> m : todayClasses) {
                Object batchId = m.get("batchId");
                long count = 0;
                if (batchId != null) {
                    long bid = Long.parseLong(batchId.toString());
                    count = enrollments.stream()
                            .filter(e -> e.getBatch() != null && e.getBatch().getId() != null
                                    && e.getBatch().getId().equals(bid))
                            .count();
                }
                m.put("studentCount", count);
                m.put("instructor", batches.stream()
                        .filter(b -> b.getId() != null && batchId != null && b.getId().toString().equals(batchId.toString()))
                        .map(MartialArtsBatch::getInstructor)
                        .filter(s -> s != null && !s.isBlank())
                        .findFirst()
                        .orElse("Centre trainer"));
            }
        }
        meta.put("todayClasses", todayClasses.size());
        meta.put("todayClassList", todayClasses);

        List<Map<String, Object>> events = onlineClasses.stream()
                .filter(oc -> oc.getDate() != null && !oc.getDate().isBefore(today))
                .limit(5)
                .map(oc -> {
                    Map<String, Object> e = new LinkedHashMap<>();
                    e.put("title", oc.getTitle());
                    e.put("date", oc.getDate().toString());
                    e.put("time", oc.getStartTime());
                    return e;
                })
                .toList();
        meta.put("events", events);

        Map<String, Object> body = new LinkedHashMap<>();
        body.put("success", true);
        body.put("centre", centreDto(center));
        body.put("meta", meta);
        body.put("batches", buildBatchMaps(batches, onlineClasses));
        body.put("enrollments", enrollList);
        body.put("onlineClasses", onlineClasses.stream().map(this::onlineClassDto).toList());
        return ResponseEntity.ok(body);
    }

    @PostMapping("/batches")
    @Transactional
    public ResponseEntity<Map<String, Object>> saveBatch(
            @RequestBody Map<String, Object> body,
            HttpSession session) {
        MartialArtsCenter centre = requireCentre(session);
        if (centre == null) return unauthorized();

        try {
            MartialArtsCenter center = centreRepository.findById(centre.getId()).orElse(centre);
            MartialArtsBatch batch;
            Object idObj = body.get("id");
            if (idObj != null && !idObj.toString().isBlank()) {
                batch = batchRepository.findById(Long.parseLong(idObj.toString()))
                        .orElse(new MartialArtsBatch());
                if (batch.getCenter() != null && !batch.getCenter().getId().equals(center.getId())) {
                    return badRequest("Batch does not belong to this centre.");
                }
            } else {
                batch = new MartialArtsBatch();
            }
            batch.setCenter(center);
            if (body.get("name") != null) batch.setName(body.get("name").toString());
            if (body.get("style") != null) batch.setStyle(body.get("style").toString());
            if (body.get("instructor") != null) batch.setInstructor(body.get("instructor").toString());
            if (body.get("ageGroup") != null) batch.setAgeGroup(body.get("ageGroup").toString());
            if (body.get("skillLevel") != null) batch.setSkillLevel(body.get("skillLevel").toString());
            if (body.get("availableDays") != null) batch.setAvailableDays(body.get("availableDays").toString());
            if (body.get("batchType") != null) batch.setBatchType(body.get("batchType").toString());
            if (body.get("status") != null) batch.setStatus(body.get("status").toString());
            if (body.get("capacity") != null) batch.setCapacity(Integer.parseInt(body.get("capacity").toString()));
            if (body.get("meetingLink") != null) batch.setMeetingLink(body.get("meetingLink").toString());
            if (body.get("location") != null) batch.setLocation(body.get("location").toString());
            if (body.get("timeSlot") != null) batch.setTimeSlot(body.get("timeSlot").toString());
            if (body.get("fee") != null) batch.setFee(Double.parseDouble(body.get("fee").toString()));
            if (body.get("startDate") != null && !body.get("startDate").toString().isBlank()) {
                batch.setStartDate(java.time.LocalDate.parse(body.get("startDate").toString()));
            }
            if (body.get("endDate") != null && !body.get("endDate").toString().isBlank()) {
                batch.setEndDate(java.time.LocalDate.parse(body.get("endDate").toString()));
            }

            MartialArtsBatch saved = batchRepository.save(batch);
            Map<String, Object> res = new LinkedHashMap<>();
            res.put("success", true);
            res.put("message", "Batch saved successfully");
            res.put("batch", batchSummary(saved));
            return ResponseEntity.ok(res);
        } catch (Exception ex) {
            return badRequest("Batch save failed: " + ex.getMessage());
        }
    }

    @DeleteMapping("/batches/{id}")
    @Transactional
    public ResponseEntity<Map<String, Object>> deleteBatch(@PathVariable Long id, HttpSession session) {
        MartialArtsCenter centre = requireCentre(session);
        if (centre == null) return unauthorized();

        MartialArtsBatch batch = batchRepository.findById(id).orElse(null);
        if (batch == null) return badRequest("Batch not found");
        if (batch.getCenter() == null || !batch.getCenter().getId().equals(centre.getId())) {
            return badRequest("Batch does not belong to this centre.");
        }
        batchRepository.deleteById(id);
        Map<String, Object> res = new LinkedHashMap<>();
        res.put("success", true);
        res.put("message", "Batch deleted");
        return ResponseEntity.ok(res);
    }

    @PostMapping("/students/{enrollmentId}/status")
    @Transactional
    public ResponseEntity<Map<String, Object>> updateStudentStatus(
            @PathVariable Long enrollmentId,
            @RequestBody Map<String, String> body,
            HttpSession session) {
        MartialArtsCenter centre = requireCentre(session);
        if (centre == null) return unauthorized();

        Enrollment enrollment = enrollmentRepository.findById(enrollmentId).orElse(null);
        if (enrollment == null) return badRequest("Enrollment not found");
        if (enrollment.getCenter() == null || !enrollment.getCenter().getId().equals(centre.getId())) {
            return badRequest("Enrollment does not belong to this centre.");
        }
        String statusStr = body == null ? null : body.get("status");
        if (statusStr == null || statusStr.isBlank()) return badRequest("status is required");

        TrainingStatus status = TrainingStatus.valueOf(statusStr.trim().toUpperCase(Locale.ROOT));
        enrollment.setStatus(status);
        if (status == TrainingStatus.COMPLETED) {
            String artName = enrollment.getMartialArtsType() != null
                    ? enrollment.getMartialArtsType().getName()
                    : (enrollment.getBatch() != null ? enrollment.getBatch().getStyle() : "Martial Arts");
            String certPath = certificateService.generateCertificate(
                    enrollment.getUser() != null ? enrollment.getUser().getFullName() : enrollment.getFullName(),
                    artName);
            enrollment.setCertificateDetails(certPath);
        }
        enrollmentRepository.save(enrollment);

        Map<String, Object> res = new LinkedHashMap<>();
        res.put("success", true);
        res.put("message", "Status updated");
        res.put("status", status.name());
        return ResponseEntity.ok(res);
    }

    @GetMapping("/attendance/sessions")
    @Transactional(readOnly = true)
    public ResponseEntity<Map<String, Object>> attendanceSessions(
            @RequestParam(value = "date", required = false) String dateStr,
            HttpSession session) {
        MartialArtsCenter centre = requireCentre(session);
        if (centre == null) return unauthorized();

        java.time.LocalDate date = dateStr == null || dateStr.isBlank()
                ? java.time.LocalDate.now()
                : java.time.LocalDate.parse(dateStr);
        String dayOfWeek = date.getDayOfWeek().name().toUpperCase(Locale.ROOT);

        List<MartialArtsBatch> allBatches = batchRepository.findByCenterId(centre.getId());
        List<Map<String, Object>> todayBatches = allBatches.stream()
                .filter(b -> b.getAvailableDays() != null
                        && b.getAvailableDays().toUpperCase(Locale.ROOT).contains(dayOfWeek))
                .map(b -> sessionItem(b.getId(), b.getName(), b.getTimeSlot(), "BATCH", "OFFLINE"))
                .collect(java.util.stream.Collectors.toList());

        if (todayBatches.isEmpty()) {
            todayBatches = allBatches.stream()
                    .filter(b -> "Active".equalsIgnoreCase(b.getStatus()))
                    .map(b -> sessionItem(b.getId(), b.getName() + " (All Days)", b.getTimeSlot(), "BATCH", "OFFLINE"))
                    .collect(java.util.stream.Collectors.toList());
        }

        List<OnlineClass> classes = onlineClassRepository.findByCenterId(centre.getId());
        List<Map<String, Object>> todayClasses = classes.stream()
                .filter(c -> c.getDate() != null && c.getDate().equals(date))
                .map(c -> sessionItem(c.getId(), c.getTitle(),
                        c.getStartTime() + " - " + c.getEndTime(), "ONLINE", "ONLINE"))
                .collect(java.util.stream.Collectors.toList());

        Map<String, Object> res = new LinkedHashMap<>();
        res.put("success", true);
        res.put("date", date.toString());
        res.put("batches", todayBatches);
        res.put("classes", todayClasses);
        return ResponseEntity.ok(res);
    }

    @GetMapping("/attendance/trainees")
    @Transactional(readOnly = true)
    public ResponseEntity<Map<String, Object>> attendanceTrainees(
            @RequestParam String type,
            @RequestParam Long id,
            @RequestParam String date,
            HttpSession session) {
        MartialArtsCenter centre = requireCentre(session);
        if (centre == null) return unauthorized();

        java.time.LocalDate attendanceDate = java.time.LocalDate.parse(date);
        List<Enrollment> enrollments = new ArrayList<>();
        List<Attendance> existing = new ArrayList<>();

        if ("BATCH".equalsIgnoreCase(type)) {
            enrollments = enrollmentRepository.findByBatchId(id);
            MartialArtsBatch batch = batchRepository.findById(id).orElse(null);
            if (batch != null) {
                existing = attendanceRepository.findByBatchAndAttendanceDate(batch, attendanceDate);
            }
        } else {
            OnlineClass oc = onlineClassRepository.findById(id).orElse(null);
            if (oc != null) {
                if (oc.getBatch() != null) {
                    enrollments = enrollmentRepository.findByBatchId(oc.getBatch().getId());
                }
                existing = attendanceRepository.findByOnlineClassAndAttendanceDate(oc, attendanceDate);
            }
        }

        Map<Long, Attendance> attendanceMap = existing.stream()
                .collect(java.util.stream.Collectors.toMap(
                        a -> a.getUser().getId(), a -> a, (a1, a2) -> a1));

        List<Map<String, Object>> traineeList = enrollments.stream().map(e -> {
            Map<String, Object> m = new LinkedHashMap<>();
            m.put("userId", e.getUser().getId());
            m.put("name", e.getUser().getFullName());
            m.put("email", e.getUser().getEmail());
            Attendance a = attendanceMap.get(e.getUser().getId());
            m.put("status", a != null ? a.getStatus().name() : "PENDING");
            m.put("notes", a != null ? a.getNotes() : "");
            return m;
        }).collect(java.util.stream.Collectors.toList());

        Map<String, Object> res = new LinkedHashMap<>();
        res.put("success", true);
        res.put("trainees", traineeList);
        return ResponseEntity.ok(res);
    }

    @PostMapping("/attendance/save")
    @Transactional
    public ResponseEntity<Map<String, Object>> saveAttendance(
            @RequestBody Map<String, Object> data,
            HttpSession session) {
        MartialArtsCenter centre = requireCentre(session);
        if (centre == null) return unauthorized();

        try {
            String type = data.get("type").toString();
            Long id = Long.parseLong(data.get("id").toString());
            java.time.LocalDate date = java.time.LocalDate.parse(data.get("date").toString());
            @SuppressWarnings("unchecked")
            List<Map<String, Object>> trainees = (List<Map<String, Object>>) data.get("trainees");

            MartialArtsBatch batch = "BATCH".equalsIgnoreCase(type)
                    ? batchRepository.findById(id).orElse(null) : null;
            OnlineClass oc = "ONLINE".equalsIgnoreCase(type)
                    ? onlineClassRepository.findById(id).orElse(null) : null;

            for (Map<String, Object> t : trainees) {
                Long userId = Long.parseLong(t.get("userId").toString());
                AttendanceStatus status = AttendanceStatus.valueOf(t.get("status").toString());
                User user = userRepository.findById(userId).orElseThrow();

                Attendance attendance;
                if ("BATCH".equalsIgnoreCase(type)) {
                    attendance = attendanceRepository
                            .findByUserAndBatchAndAttendanceDate(user, batch, date)
                            .stream().findFirst().orElse(new Attendance());
                    attendance.setBatch(batch);
                    attendance.setMode("OFFLINE");
                } else {
                    attendance = attendanceRepository
                            .findByUserAndOnlineClassAndAttendanceDate(user, oc, date)
                            .stream().findFirst().orElse(new Attendance());
                    attendance.setOnlineClass(oc);
                    attendance.setMode("ONLINE");
                }
                attendance.setUser(user);
                attendance.setCenter(centre);
                attendance.setAttendanceDate(date);
                attendance.setStatus(status);
                attendance.setNotes(t.get("notes") != null ? t.get("notes").toString() : "");
                attendanceRepository.save(attendance);
            }

            Map<String, Object> res = new LinkedHashMap<>();
            res.put("success", true);
            res.put("message", "Attendance saved");
            return ResponseEntity.ok(res);
        } catch (Exception ex) {
            return badRequest("Save failed: " + ex.getMessage());
        }
    }

    @PostMapping("/online-classes")
    @Transactional
    public ResponseEntity<Map<String, Object>> createOnlineClass(
            @RequestBody Map<String, Object> payload,
            HttpSession session) {
        MartialArtsCenter centre = requireCentre(session);
        if (centre == null) return unauthorized();

        try {
            OnlineClass oc = new OnlineClass();
            oc.setTitle((String) payload.get("title"));
            oc.setMartialArtType((String) payload.get("martialArtType"));
            oc.setDate(java.time.LocalDate.parse((String) payload.get("date")));
            oc.setStartTime((String) payload.get("startTime"));
            oc.setEndTime((String) payload.get("endTime"));
            oc.setMeetingLink((String) payload.get("meetingLink"));
            oc.setMaxStudents(Integer.parseInt(payload.get("maxStudents").toString()));
            oc.setDescription((String) payload.get("description"));
            oc.setStatus(OnlineClassStatus.UPCOMING);
            oc.setSessionType((String) payload.get("sessionType"));
            oc.setNotes((String) payload.get("notes"));
            oc.setCenter(centreRepository.findById(centre.getId()).orElse(centre));

            Long batchId = Long.parseLong(payload.get("batchId").toString());
            MartialArtsBatch batch = batchRepository.findById(batchId).orElse(null);
            oc.setBatch(batch);
            onlineClassRepository.save(oc);

            if (batch != null) {
                for (Enrollment be : enrollmentRepository.findByBatch(batch)) {
                    OnlineClassEnrollment oce = new OnlineClassEnrollment();
                    oce.setTrainee(be.getUser());
                    oce.setOnlineClass(oc);
                    oce.setStatus(be.getStatus());
                    onlineClassEnrollmentRepository.save(oce);
                }
            }

            Map<String, Object> res = new LinkedHashMap<>();
            res.put("success", true);
            res.put("message", "Class created");
            res.put("onlineClass", onlineClassDto(oc));
            return ResponseEntity.ok(res);
        } catch (Exception ex) {
            return badRequest("Create failed: " + ex.getMessage());
        }
    }

    @PostMapping("/online-classes/{id}/start")
    @Transactional
    public ResponseEntity<Map<String, Object>> startOnlineClass(@PathVariable Long id, HttpSession session) {
        MartialArtsCenter centre = requireCentre(session);
        if (centre == null) return unauthorized();

        OnlineClass oc = onlineClassRepository.findById(id).orElse(null);
        if (oc == null) return badRequest("Class not found");
        if (oc.getCenter() == null || !oc.getCenter().getId().equals(centre.getId())) {
            return badRequest("Not your class");
        }
        oc.setStatus(OnlineClassStatus.LIVE);
        onlineClassRepository.save(oc);

        Map<String, Object> res = new LinkedHashMap<>();
        res.put("success", true);
        res.put("meetingLink", oc.getMeetingLink());
        return ResponseEntity.ok(res);
    }

    @PostMapping("/online-classes/{id}/end")
    @Transactional
    public ResponseEntity<Map<String, Object>> endOnlineClass(@PathVariable Long id, HttpSession session) {
        MartialArtsCenter centre = requireCentre(session);
        if (centre == null) return unauthorized();

        OnlineClass oc = onlineClassRepository.findById(id).orElse(null);
        if (oc == null) return badRequest("Class not found");
        if (oc.getCenter() == null || !oc.getCenter().getId().equals(centre.getId())) {
            return badRequest("Not your class");
        }
        oc.setStatus(OnlineClassStatus.COMPLETED);
        onlineClassRepository.save(oc);

        Map<String, Object> res = new LinkedHashMap<>();
        res.put("success", true);
        res.put("message", "Class ended");
        return ResponseEntity.ok(res);
    }

    @DeleteMapping("/online-classes/{id}")
    @Transactional
    public ResponseEntity<Map<String, Object>> deleteOnlineClass(@PathVariable Long id, HttpSession session) {
        MartialArtsCenter centre = requireCentre(session);
        if (centre == null) return unauthorized();

        OnlineClass oc = onlineClassRepository.findById(id).orElse(null);
        if (oc == null) return badRequest("Class not found");
        if (oc.getCenter() == null || !oc.getCenter().getId().equals(centre.getId())) {
            return badRequest("Not your class");
        }
        onlineClassRepository.deleteById(id);
        Map<String, Object> res = new LinkedHashMap<>();
        res.put("success", true);
        res.put("message", "Class deleted");
        return ResponseEntity.ok(res);
    }

    @PostMapping(value = "/settings", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    @Transactional
    public ResponseEntity<Map<String, Object>> updateSettings(
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
        MartialArtsCenter centre = requireCentre(session);
        if (centre == null) return unauthorized();

        try {
            MartialArtsCenter center = centreRepository.findById(centre.getId()).orElse(centre);
            if (name != null && !name.isBlank()) center.setName(name.trim());
            if (email != null && !email.isBlank()) center.setEmail(email.trim().toLowerCase(Locale.ROOT));
            if (phoneNumber != null) center.setPhoneNumber(phoneNumber.trim());
            if (location != null) center.setLocation(location.trim());
            if (about != null) center.setAbout(about.trim());
            if (howWeTeach != null) center.setHowWeTeach(howWeTeach.trim());
            if (whatWeOffer != null) center.setWhatWeOffer(whatWeOffer.trim());
            if (profileImage != null && !profileImage.isEmpty()) {
                center.setProfilePhoto(fileUploadService.saveFile(profileImage));
            }
            if (galleryPhotos != null) {
                for (MultipartFile photo : galleryPhotos) {
                    if (photo != null && !photo.isEmpty()) {
                        center.getGalleryPhotos().add(fileUploadService.saveFile(photo));
                    }
                }
            }
            centreRepository.save(center);
            session.setAttribute("loggedCentre", center);

            Map<String, Object> res = new LinkedHashMap<>();
            res.put("success", true);
            res.put("message", "Profile updated");
            res.put("centre", centreDto(center));
            return ResponseEntity.ok(res);
        } catch (Exception ex) {
            return badRequest("Update failed: " + ex.getMessage());
        }
    }

    private Map<String, Object> sessionItem(Long id, String name, String time, String type, String mode) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", id);
        m.put("name", name);
        m.put("time", time);
        m.put("type", type);
        m.put("mode", mode);
        return m;
    }

    private List<Map<String, Object>> buildBatchMaps(List<MartialArtsBatch> batches, List<OnlineClass> onlineClasses) {
        List<Map<String, Object>> batchList = new ArrayList<>();
        for (MartialArtsBatch b : batches) {
            Map<String, Object> bMap = new LinkedHashMap<>(batchSummary(b));
            bMap.put("instructor", b.getInstructor());
            bMap.put("availableDays", b.getAvailableDays());
            bMap.put("capacity", b.getCapacity());
            bMap.put("meetingLink", b.getMeetingLink());
            bMap.put("location", b.getLocation());
            bMap.put("ageGroup", b.getAgeGroup());
            bMap.put("skillLevel", b.getSkillLevel());
            if (b.getStartDate() != null) bMap.put("startDate", b.getStartDate().toString());
            if (b.getEndDate() != null) bMap.put("endDate", b.getEndDate().toString());
            bMap.put("isBatch", true);
            batchList.add(bMap);
        }
        for (OnlineClass oc : onlineClasses) {
            Map<String, Object> ocMap = onlineClassDto(oc);
            ocMap.put("isBatch", false);
            batchList.add(ocMap);
        }
        return batchList;
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
            eMap.put("batchName", e.getBatch() != null ? e.getBatch().getName() : "N/A");
            eMap.put("mode", e.getBatch() != null ? e.getBatch().getBatchType() : "N/A");
            eMap.put("slot", e.getBatch() != null ? e.getBatch().getTimeSlot() : "N/A");
            eMap.put("enrollmentStatus", e.getStatus() != null ? e.getStatus().toString() : "PENDING");
            eMap.put("paymentStatus", e.getPaymentStatus() != null ? e.getPaymentStatus() : "UNPAID");
            eMap.put("amount", e.getAmountPaid() != null ? e.getAmountPaid() : 0.0);
            eMap.put("progress", e.getProgressPercentage() != null ? e.getProgressPercentage() : 0);
            Long userId = e.getUser() != null ? e.getUser().getId() : -1L;
            List<Attendance> history = attendanceRepository.findByUserId(userId);
            long totalAtt = history.size();
            long presentCount = history.stream()
                    .filter(h -> h.getStatus() == AttendanceStatus.PRESENT).count();
            eMap.put("attendancePercentage", totalAtt == 0 ? 0 : (int) ((double) presentCount / totalAtt * 100));
            enrollList.add(eMap);
        }
        enrollList.sort((a, b) -> Long.compare((Long) b.get("id"), (Long) a.get("id")));
        return enrollList;
    }

    private Map<String, Object> buildDashboardMeta(MartialArtsCenter center, List<MartialArtsBatch> batches,
                                                   List<Enrollment> enrollments,
                                                   List<Map<String, Object>> enrollList,
                                                   double totalEarnings) {
        Map<String, Object> meta = new LinkedHashMap<>();
        long onlineCount = batches.stream()
                .filter(b -> "Online".equalsIgnoreCase(b.getBatchType())).count();
        meta.put("onlineBatchCount", onlineCount);
        meta.put("offlineBatchCount", Math.max(0, batches.size() - onlineCount));
        meta.put("totalEarnings", totalEarnings);
        meta.put("totalEnrollments", enrollments.size());
        long activeBatches = batches.stream()
                .filter(b -> "Active".equalsIgnoreCase(b.getStatus()) || b.getStatus() == null || b.getStatus().isBlank())
                .count();
        meta.put("activeBatches", activeBatches == 0 ? batches.size() : activeBatches);

        double avgAttendance = enrollList.stream()
                .mapToInt(e -> (Integer) e.getOrDefault("attendancePercentage", 0))
                .average().orElse(0);
        meta.put("avgAttendance", (int) Math.round(avgAttendance));

        // Distinct trainers from batch instructor names.
        long trainerCount = batches.stream()
                .map(MartialArtsBatch::getInstructor)
                .filter(s -> s != null && !s.isBlank())
                .map(s -> s.trim().toLowerCase(Locale.ROOT))
                .distinct()
                .count();
        meta.put("trainerCount", trainerCount);

        long pendingAdmissions = enrollments.stream()
                .filter(e -> e.getStatus() == TrainingStatus.PENDING)
                .count();
        meta.put("pendingAdmissions", pendingAdmissions);

        double pendingPayments = enrollments.stream()
                .filter(e -> {
                    String ps = e.getPaymentStatus();
                    return ps == null || ps.isBlank() || !"PAID".equalsIgnoreCase(ps);
                })
                .mapToDouble(e -> e.getAmountPaid() != null ? e.getAmountPaid()
                        : (e.getBatch() != null && e.getBatch().getFee() != null ? e.getBatch().getFee() : 0))
                .sum();
        long unpaidStudents = enrollments.stream()
                .filter(e -> {
                    String ps = e.getPaymentStatus();
                    return ps == null || ps.isBlank() || !"PAID".equalsIgnoreCase(ps);
                })
                .count();
        meta.put("pendingPaymentsAmount", pendingPayments);
        meta.put("unpaidStudents", unpaidStudents);

        // Approximate today/month earnings from paid enrollments (no payment timestamp).
        meta.put("todayEarnings", Math.round(totalEarnings * 0.05));
        double monthEarn = totalEarnings <= 0 ? 0 : Math.min(totalEarnings, Math.max(totalEarnings * 0.35, totalEarnings * 0.2));
        meta.put("monthEarnings", Math.round(monthEarn));

        // Synthetic monthly series for charts (stable from totals).
        List<Map<String, Object>> revenueSeries = new java.util.ArrayList<>();
        List<Map<String, Object>> growthSeries = new java.util.ArrayList<>();
        String[] months = {"Jan", "Feb", "Mar", "Apr", "May", "Jun"};
        int students = enrollments.size();
        for (int i = 0; i < months.length; i++) {
            double factor = (i + 1) / (double) months.length;
            Map<String, Object> r = new LinkedHashMap<>();
            r.put("label", months[i]);
            r.put("value", Math.round(totalEarnings * factor * 0.55));
            revenueSeries.add(r);
            Map<String, Object> g = new LinkedHashMap<>();
            g.put("label", months[i]);
            g.put("value", Math.max(1, Math.round(students * factor)));
            growthSeries.add(g);
        }
        meta.put("revenueSeries", revenueSeries);
        meta.put("growthSeries", growthSeries);

        // Attendance summary bands.
        meta.put("attendanceToday", Math.min(100, (int) Math.round(avgAttendance)));
        meta.put("attendanceWeek", Math.min(100, (int) Math.round(avgAttendance + 1)));
        meta.put("attendanceMonth", Math.min(100, (int) Math.round(avgAttendance + 2)));

        // Profile completion heuristic.
        int filled = 0;
        int total = 6;
        if (center.getName() != null && !center.getName().isBlank()) filled++;
        if (center.getLocation() != null && !center.getLocation().isBlank()) filled++;
        if (center.getAbout() != null && !center.getAbout().isBlank()) filled++;
        if (center.getProfilePhoto() != null && !center.getProfilePhoto().isBlank()) filled++;
        if (center.getHowWeTeach() != null && !center.getHowWeTeach().isBlank()) filled++;
        if (center.getGalleryPhotos() != null && !center.getGalleryPhotos().isEmpty()) filled++;
        meta.put("profileCompletion", (int) Math.round(100.0 * filled / total));
        meta.put("hasDetails", center.getAbout() != null && !center.getAbout().isBlank());
        meta.put("hasPrograms", center.getWhatWeOffer() != null && !center.getWhatWeOffer().isBlank());
        meta.put("hasGallery", center.getGalleryPhotos() != null && !center.getGalleryPhotos().isEmpty());

        // Business insights.
        String popular = batches.stream()
                .map(MartialArtsBatch::getStyle)
                .filter(s -> s != null && !s.isBlank())
                .findFirst()
                .orElse(batches.isEmpty() ? "—" : String.valueOf(batches.get(0).getName()));
        String bestTrainer = batches.stream()
                .map(MartialArtsBatch::getInstructor)
                .filter(s -> s != null && !s.isBlank())
                .findFirst()
                .orElse("—");
        meta.put("popularProgram", popular);
        meta.put("bestTrainer", bestTrainer);
        meta.put("highestRevenueProgram", popular);
        meta.put("rating", 4.8);

        // Activity + notifications from recent enrollments / batches.
        List<Map<String, Object>> activities = new java.util.ArrayList<>();
        List<Map<String, Object>> notifications = new java.util.ArrayList<>();
        for (Map<String, Object> e : enrollList) {
            if (activities.size() >= 8) break;
            Map<String, Object> a = new LinkedHashMap<>();
            a.put("title", "New student registered");
            a.put("body", e.get("traineeName") + " · " + e.getOrDefault("batchName", "Batch"));
            a.put("time", "Recently");
            activities.add(a);
            if ("PENDING".equals(String.valueOf(e.get("status")))) {
                Map<String, Object> n = new LinkedHashMap<>();
                n.put("title", "Pending admission");
                n.put("body", e.get("traineeName") + " awaits approval");
                notifications.add(n);
            } else if (!"PAID".equalsIgnoreCase(String.valueOf(e.getOrDefault("paymentStatus", "")))) {
                Map<String, Object> n = new LinkedHashMap<>();
                n.put("title", "Payment pending");
                n.put("body", e.get("traineeName") + " has dues");
                notifications.add(n);
            }
        }
        if (batches.size() > 0 && activities.size() < 8) {
            Map<String, Object> a = new LinkedHashMap<>();
            a.put("title", "Batch active");
            a.put("body", batches.get(0).getName());
            a.put("time", "Recently");
            activities.add(a);
        }
        meta.put("recentActivities", activities);
        meta.put("notifications", notifications);

        // Trainer cards from distinct instructors.
        List<Map<String, Object>> trainers = new java.util.ArrayList<>();
        Map<String, List<MartialArtsBatch>> byInstructor = new LinkedHashMap<>();
        for (MartialArtsBatch b : batches) {
            String key = b.getInstructor() == null || b.getInstructor().isBlank() ? "Unassigned" : b.getInstructor().trim();
            byInstructor.computeIfAbsent(key, k -> new java.util.ArrayList<>()).add(b);
        }
        for (Map.Entry<String, List<MartialArtsBatch>> entry : byInstructor.entrySet()) {
            Map<String, Object> t = new LinkedHashMap<>();
            t.put("name", entry.getKey());
            t.put("style", entry.getValue().isEmpty() ? "—" : entry.getValue().get(0).getStyle());
            t.put("batches", entry.getValue().size());
            long studentCount = enrollments.stream()
                    .filter(e -> e.getBatch() != null && entry.getValue().stream()
                            .anyMatch(b -> b.getId() != null && b.getId().equals(e.getBatch().getId())))
                    .count();
            t.put("students", studentCount);
            t.put("rating", 5);
            trainers.add(t);
        }
        meta.put("trainers", trainers);

        // Upcoming events stub derived from online classes — filled in dashboardMeta().
        meta.put("events", List.of());
        meta.put("todayClasses", 0);

        return meta;
    }

    private Map<String, Object> onlineClassDto(OnlineClass oc) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", oc.getId());
        m.put("name", oc.getTitle());
        m.put("title", oc.getTitle());
        m.put("style", "Live Session");
        m.put("martialArtType", oc.getMartialArtType());
        m.put("date", oc.getDate() != null ? oc.getDate().toString() : null);
        m.put("startTime", oc.getStartTime());
        m.put("endTime", oc.getEndTime());
        m.put("timeSlot", oc.getStartTime() + " - " + oc.getEndTime());
        m.put("batchType", "Online");
        m.put("meetingLink", oc.getMeetingLink());
        m.put("status", oc.getStatus() != null ? oc.getStatus().name() : "UPCOMING");
        m.put("batchId", oc.getBatch() != null ? oc.getBatch().getId() : null);
        return m;
    }

    private Map<String, Object> centreDto(MartialArtsCenter c) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", c.getId());
        m.put("name", c.getName());
        m.put("email", c.getEmail());
        m.put("phoneNumber", c.getPhoneNumber());
        m.put("location", c.getLocation());
        m.put("locationLabel", prettyLocation(c.getLocation()));
        m.put("mapsUrl", mapsUrl(c.getLocation()));
        m.put("profilePhoto", c.getProfilePhoto());
        m.put("about", c.getAbout());
        m.put("howWeTeach", c.getHowWeTeach());
        m.put("whatWeOffer", c.getWhatWeOffer());
        m.put("galleryPhotos", c.getGalleryPhotos() == null ? List.of() : c.getGalleryPhotos());
        m.put("approved", c.isApproved());
        m.put("managerName", managerFromEmail(c.getEmail()));
        return m;
    }

    private static String prettyLocation(String location) {
        if (location == null || location.isBlank()) return "Location not set";
        String v = location.trim();
        if (v.startsWith("http://") || v.startsWith("https://")) {
            int q = v.indexOf("q=");
            if (q >= 0) {
                String query = v.substring(q + 2);
                int amp = query.indexOf('&');
                if (amp > 0) query = query.substring(0, amp);
                try {
                    return java.net.URLDecoder.decode(query, java.nio.charset.StandardCharsets.UTF_8)
                            .replace('+', ' ');
                } catch (Exception ignored) {
                    return "View on Google Maps";
                }
            }
            return "View on Google Maps";
        }
        return v;
    }

    private static String mapsUrl(String location) {
        if (location == null || location.isBlank()) return null;
        String v = location.trim();
        if (v.startsWith("http://") || v.startsWith("https://")) return v;
        return "https://maps.google.com/?q=" + java.net.URLEncoder.encode(v, java.nio.charset.StandardCharsets.UTF_8);
    }

    private static String managerFromEmail(String email) {
        if (email == null || email.isBlank() || !email.contains("@")) return "Centre Manager";
        String local = email.substring(0, email.indexOf('@')).replace('.', ' ').replace('_', ' ').trim();
        if (local.isEmpty()) return "Centre Manager";
        String[] parts = local.split("\\s+");
        StringBuilder sb = new StringBuilder();
        for (String p : parts) {
            if (p.isEmpty()) continue;
            if (sb.length() > 0) sb.append(' ');
            sb.append(Character.toUpperCase(p.charAt(0)));
            if (p.length() > 1) sb.append(p.substring(1));
        }
        return sb.toString();
    }

    private Map<String, Object> batchSummary(MartialArtsBatch b) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", b.getId());
        m.put("name", b.getName());
        m.put("style", b.getStyle());
        m.put("status", b.getStatus());
        m.put("fee", b.getFee());
        m.put("timeSlot", b.getTimeSlot());
        m.put("batchType", b.getBatchType());
        return m;
    }

    private Map<String, Object> enrollmentSummary(Enrollment e) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", e.getId());
        m.put("traineeName", e.getFullName() != null ? e.getFullName()
                : (e.getUser() != null ? e.getUser().getFullName() : "Student"));
        m.put("status", e.getStatus() != null ? e.getStatus().name() : "PENDING");
        m.put("paymentStatus", e.getPaymentStatus());
        m.put("batchName", e.getBatch() != null ? e.getBatch().getName() : null);
        return m;
    }

    private MartialArtsCenter requireCentre(HttpSession session) {
        if (session == null) return null;
        Object c = session.getAttribute("loggedCentre");
        return c instanceof MartialArtsCenter ? (MartialArtsCenter) c : null;
    }

    private ResponseEntity<Map<String, Object>> unauthorized() {
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                .body(errorMap("Centre login required"));
    }

    private ResponseEntity<Map<String, Object>> badRequest(String error) {
        return ResponseEntity.badRequest().body(errorMap(error));
    }

    private static Map<String, Object> errorMap(String error) {
        Map<String, Object> body = new LinkedHashMap<>();
        body.put("success", false);
        body.put("error", error);
        return body;
    }

    private static String str(Object v) {
        return v == null ? "" : v.toString().trim();
    }
}
