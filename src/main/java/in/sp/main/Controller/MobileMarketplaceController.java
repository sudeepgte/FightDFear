package in.sp.main.Controller;

import in.sp.main.Entities.*;
import in.sp.main.Repository.*;
import in.sp.main.Service.FileUploadService;
import in.sp.main.Service.JobWorkerProfileService;
import in.sp.main.Service.ServiceProviderProfileService;
import in.sp.main.Service.WomenJobsCareService;
import in.sp.main.Service.WomenLawyerCareService;
import in.sp.main.Util.JobCategories;
import in.sp.main.Util.LawyerCategories;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.time.Duration;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/marketplace")
public class MobileMarketplaceController {

    @Autowired
    private ServiceProviderRepository providerRepo;
    @Autowired
    private ProviderBookingRepository bookingRepo;
    @Autowired
    private ProviderReviewRepository reviewRepo;
    @Autowired
    private ProviderClassRepository classRepo;
    @Autowired
    private MarketplaceEnrollmentRepository enrollmentRepo;
    @Autowired
    private JobApplicationRepository jobAppRepo;
    @Autowired
    private WorkerBookingRepository workerBookingRepo;
    @Autowired
    private MarketplaceMessageRepository messageRepo;
    @Autowired
    private FileUploadService fileUploadService;
    @Autowired
    private WomenJobsCareService jobsCareService;
    @Autowired
    private JobWorkerProfileService jobWorkerProfileService;
    @Autowired
    private WomenLawyerCareService lawyerCareService;

    @GetMapping("/categories")
    public ResponseEntity<Map<String, Object>> categories(HttpSession session) {
        if (requireUser(session) == null) return unauthorized();
        List<Map<String, Object>> providerCategories = Arrays.stream(ProviderCategory.values())
                .map(c -> {
                    Map<String, Object> row = new LinkedHashMap<>();
                    row.putAll(c.asCatalog());
                    return row;
                })
                .collect(Collectors.toList());
        return ResponseEntity.ok(ok(Map.of(
                "providerCategories", providerCategories,
                "workerCategories", JobCategories.asCatalog(),
                "lawyerPracticeAreas", LawyerCategories.asCatalog()
        )));
    }

    @GetMapping("/providers")
    public ResponseEntity<Map<String, Object>> providers(
            @RequestParam(required = false) String category,
            @RequestParam(required = false) String city,
            @RequestParam(required = false) String practiceArea,
            @RequestParam(required = false) Double minFee,
            @RequestParam(required = false) Double maxFee,
            @RequestParam(required = false) Boolean availableToday,
            @RequestParam(required = false) Boolean doorService,
            @RequestParam(required = false) String sort,
            @RequestParam(required = false) Double lat,
            @RequestParam(required = false) Double lng,
            HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        List<ServiceProvider> list;
        if (category != null && !category.isBlank()) {
            try {
                ProviderCategory cat = ProviderCategory.valueOf(category.trim().toUpperCase(Locale.ROOT));
                list = providerRepo.findByCategoryAndVerificationStatus(cat, VerificationStatus.VERIFIED);
            } catch (Exception e) {
                list = providerRepo.findByVerificationStatus(VerificationStatus.VERIFIED);
            }
        } else {
            list = providerRepo.findByVerificationStatus(VerificationStatus.VERIFIED);
        }
        boolean lawyerOnly = category != null && "WOMEN_LAWYER".equalsIgnoreCase(category.trim());
        String cityQ = city == null ? "" : city.trim().toLowerCase(Locale.ROOT);
        List<Map<String, Object>> items = new ArrayList<>();
        for (ServiceProvider p : list) {
            if (p.getVerificationStatus() != VerificationStatus.VERIFIED) continue;
            if (lawyerOnly ? p.getCategory() != ProviderCategory.WOMEN_LAWYER
                    : p.getCategory() == ProviderCategory.WOMEN_LAWYER) continue;
            if (!cityQ.isBlank() && (p.getCity() == null || !p.getCity().toLowerCase(Locale.ROOT).contains(cityQ))) continue;
            if (practiceArea != null && !practiceArea.isBlank() && !"all".equalsIgnoreCase(practiceArea)
                    && !LawyerCategories.matchesFilter(p.getPracticeAreas(), practiceArea)) continue;
            if (Boolean.TRUE.equals(doorService) && !Boolean.TRUE.equals(p.getDoorService())) continue;
            double fee = p.getConsultationFee() == null ? 0 : p.getConsultationFee();
            if (minFee != null && fee < minFee) continue;
            if (maxFee != null && (fee == 0 || fee > maxFee)) continue;
            if (Boolean.TRUE.equals(availableToday) && lawyerOnly && !lawyerCareService.availableToday(p)) continue;
            items.add(providerCard(p, user, lat, lng));
        }
        String sortKey = sort == null ? "rating" : sort.trim().toLowerCase(Locale.ROOT);
        items.sort((x, y) -> {
            if ("fee".equals(sortKey) || "price".equals(sortKey)) {
                return Double.compare(asNum(x.get("consultationFee")), asNum(y.get("consultationFee")));
            }
            if ("nearest".equals(sortKey)) {
                return Double.compare(asNum(x.get("distanceKm")), asNum(y.get("distanceKm")));
            }
            return Double.compare(asNum(y.get("rating")), asNum(x.get("rating")));
        });
        return ResponseEntity.ok(ok(Map.of(
                "providers", items,
                "count", items.size(),
                "cancelPolicy", WomenLawyerCareService.CANCEL_POLICY)));
    }

    @GetMapping("/providers/{id}")
    public ResponseEntity<Map<String, Object>> providerDetail(@PathVariable Long id, HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        ServiceProvider p = providerRepo.findById(id).orElse(null);
        if (p == null || p.getVerificationStatus() != VerificationStatus.VERIFIED) return badRequest("Provider not found");

        List<Map<String, Object>> classes = classRepo.findByProvider_Id(id).stream()
                .map(this::classDto)
                .toList();
        List<Map<String, Object>> reviews = reviewRepo.findByProviderIdOrderByCreatedAtDesc(id).stream()
                .map(this::reviewDto)
                .toList();

        int dur = p.getDurationMinutes() == null ? 60 : p.getDurationMinutes();
        List<String> slotsToday = p.getCategory() == ProviderCategory.WOMEN_LAWYER
                ? lawyerCareService.slotsFor(p, LocalDate.now(), dur) : List.of();
        Map<String, Object> next = p.getCategory() == ProviderCategory.WOMEN_LAWYER
                ? lawyerCareService.nextSlot(p) : null;
        return ResponseEntity.ok(ok(Map.of(
                "provider", providerCard(p, user, null, null),
                "classes", classes,
                "reviews", reviews,
                "canReview", !reviewRepo.existsByUserIdAndProviderId(user.getId(), id),
                "slotsToday", slotsToday,
                "nextSlot", next == null ? Map.of() : next,
                "noSlotsToday", slotsToday.isEmpty(),
                "favorite", lawyerCareService.isFavorite(user, id),
                "cancelPolicy", WomenLawyerCareService.CANCEL_POLICY
        )));
    }

    @GetMapping("/providers/{id}/slots")
    public ResponseEntity<Map<String, Object>> providerSlots(
            @PathVariable Long id,
            @RequestParam(required = false) String date,
            HttpSession session) {
        if (requireUser(session) == null) return unauthorized();
        ServiceProvider p = providerRepo.findById(id).orElse(null);
        if (p == null || p.getVerificationStatus() != VerificationStatus.VERIFIED) return badRequest("Provider not found");
        LocalDate day;
        try {
            day = (date == null || date.isBlank()) ? LocalDate.now() : LocalDate.parse(date);
        } catch (Exception e) {
            return badRequest("Invalid date");
        }
        int dur = p.getDurationMinutes() == null ? 60 : p.getDurationMinutes();
        Map<String, Object> next = lawyerCareService.nextSlot(p);
        return ResponseEntity.ok(ok(Map.of(
                "date", day.toString(),
                "slots", lawyerCareService.slotsFor(p, day, dur),
                "open", lawyerCareService.isOpenOn(p, day),
                "nextSlot", next == null ? Map.of() : next
        )));
    }

    @PostMapping("/providers/{id}/reviews")
    @Transactional
    public ResponseEntity<Map<String, Object>> addProviderReview(
            @PathVariable Long id,
            @RequestBody Map<String, Object> body,
            HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        ServiceProvider p = providerRepo.findById(id).orElse(null);
        if (p == null || p.getVerificationStatus() != VerificationStatus.VERIFIED) return badRequest("Provider not found");
        int rating = 5;
        try {
            if (body != null && body.get("rating") != null) rating = Integer.parseInt(body.get("rating").toString());
        } catch (Exception ignored) {}
        try {
            var review = lawyerCareService.addReview(user, p, rating, body == null ? "" : trim(Objects.toString(body.get("comment"), "")));
            return ResponseEntity.ok(ok(Map.of("review", reviewDto(review), "message", "Review saved")));
        } catch (org.springframework.web.server.ResponseStatusException ex) {
            return ResponseEntity.status(ex.getStatusCode()).body(Map.of("success", false, "error", ex.getReason()));
        }
    }

    @PostMapping("/providers/{id}/favorite")
    @Transactional
    public ResponseEntity<Map<String, Object>> toggleLawyerFavorite(@PathVariable Long id, HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        ServiceProvider p = providerRepo.findById(id).orElse(null);
        if (p == null || p.getVerificationStatus() != VerificationStatus.VERIFIED) return badRequest("Provider not found");
        boolean fav = lawyerCareService.toggleFavorite(user, id);
        return ResponseEntity.ok(ok(Map.of("favorite", fav, "message", fav ? "Added to favourites" : "Removed from favourites")));
    }

    @GetMapping("/lawyers/favorites")
    public ResponseEntity<Map<String, Object>> myLawyerFavorites(HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        List<Map<String, Object>> items = new ArrayList<>();
        for (var fav : lawyerCareService.favoritesFor(user)) {
            providerRepo.findById(fav.getProviderId()).ifPresent(p -> {
                if (p.getVerificationStatus() == VerificationStatus.VERIFIED) items.add(providerCard(p, user, null, null));
            });
        }
        return ResponseEntity.ok(ok(Map.of("providers", items, "count", items.size())));
    }

    @PostMapping("/providers/{id}/bookings")
    @Transactional
    public ResponseEntity<Map<String, Object>> book(
            @PathVariable Long id,
            @RequestBody Map<String, Object> body,
            HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        ServiceProvider p = providerRepo.findById(id).orElse(null);
        if (p == null || p.getVerificationStatus() != VerificationStatus.VERIFIED) return badRequest("Provider not found");

        String requestedTimeRaw = trim(Objects.toString(body.get("requestedTime"), ""));
        LocalDateTime requestedTime = parseRequestedTime(requestedTimeRaw);
        if (requestedTime == null) {
            return badRequest("requestedTime is required. Pick a date and time.");
        }
        if (requestedTime.isBefore(LocalDateTime.now())) return badRequest("Booking time cannot be in the past");
        if (requestedTime.isAfter(LocalDateTime.now().plusDays(60))) {
            return badRequest("Bookings allowed only up to 60 days ahead");
        }
        if (p.getCategory() == ProviderCategory.WOMEN_LAWYER && !lawyerCareService.isOpenOn(p, requestedTime.toLocalDate())) {
            return badRequest("Lawyer is not available on this date");
        }

        final LocalDateTime slotTime = requestedTime;
        int buffer = p.getBufferMinutes() == null ? 0 : p.getBufferMinutes();
        int window = Math.max(60, (p.getDurationMinutes() == null ? 60 : p.getDurationMinutes()) + buffer);
        boolean slotTaken = bookingRepo.findByProviderOrderByRequestedTimeDesc(p).stream()
                .filter(b -> b.getStatus() != ProviderBookingStatus.CANCELLED)
                .anyMatch(b -> b.getRequestedTime() != null
                        && Duration.between(b.getRequestedTime(), slotTime).abs().toMinutes() < window);
        if (slotTaken) {
            return badRequest("This time slot is already booked.");
        }

        ProviderBooking b = new ProviderBooking();
        b.setUser(user);
        b.setProvider(p);
        b.setRequestedTime(requestedTime);
        b.setNote(trim(Objects.toString(body.get("note"), "")));
        b.setStatus(ProviderBookingStatus.PENDING);
        b.setConsentPolicy(true);
        double amount = parseDouble(body.get("totalAmount"), p.getConsultationFee() == null ? 0 : p.getConsultationFee());
        b.setTotalAmount(Math.max(amount, 0));
        bookingRepo.save(b);
        return ResponseEntity.ok(ok(Map.of(
                "message", "Booking requested",
                "bookingId", b.getId(),
                "requestedTime", b.getRequestedTime().toString(),
                "amount", b.getTotalAmount(),
                "cancelPolicy", WomenLawyerCareService.CANCEL_POLICY)));
    }

    @GetMapping("/classes/{classId}")
    public ResponseEntity<Map<String, Object>> classDetail(@PathVariable Long classId, HttpSession session) {
        if (requireUser(session) == null) return unauthorized();
        ProviderClass pc = classRepo.findById(classId).orElse(null);
        if (pc == null) return badRequest("Class not found");
        return ResponseEntity.ok(ok(Map.of("classItem", classDto(pc))));
    }

    @PostMapping("/classes/{classId}/enroll")
    @Transactional
    public ResponseEntity<Map<String, Object>> enrollClass(@PathVariable Long classId, HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();

        ProviderClass pc = classRepo.findById(classId).orElse(null);
        if (pc == null || pc.getAvailableSeats() == null || pc.getAvailableSeats() <= 0) {
            return badRequest("Class not available or full");
        }
        if (enrollmentRepo.existsActiveByUserAndClass(user.getId(), classId)) {
            return badRequest("Already enrolled in this class");
        }

        MarketplaceEnrollment enrollment = new MarketplaceEnrollment();
        enrollment.setUser(user);
        enrollment.setProviderClass(pc);
        enrollment.setStatus("ENROLLED");
        double price = pc.getPrice() == null ? 0.0 : pc.getPrice();
        enrollment.setPaymentStatus(price > 0 ? "PENDING" : "PAID");
        enrollment.setEnrollmentTime(LocalDateTime.now());
        if (price <= 0) {
            enrollment.setAmountPaid(0.0);
        }
        enrollmentRepo.save(enrollment);

        pc.setAvailableSeats(pc.getAvailableSeats() - 1);
        classRepo.save(pc);

        return ResponseEntity.ok(ok(Map.of(
                "message", price > 0 ? "Enrollment created. Complete payment to confirm." : "Enrollment confirmed",
                "enrollmentId", enrollment.getId(),
                "paymentRequired", price > 0,
                "amount", price
        )));
    }

    @PostMapping("/enrollments/{id}/cancel")
    @Transactional
    public ResponseEntity<Map<String, Object>> cancelEnrollment(@PathVariable Long id, HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        MarketplaceEnrollment e = enrollmentRepo.findById(id).orElse(null);
        if (e == null || e.getUser() == null || !e.getUser().getId().equals(user.getId())) {
            return badRequest("Enrollment not found");
        }
        if (!"PENDING".equalsIgnoreCase(e.getPaymentStatus())) {
            return badRequest("Only unpaid enrollments can be cancelled");
        }
        if ("CANCELLED".equalsIgnoreCase(e.getStatus())) {
            return badRequest("Enrollment is already cancelled");
        }
        ProviderClass pc = e.getProviderClass();
        if (pc != null && pc.getAvailableSeats() != null) {
            pc.setAvailableSeats(pc.getAvailableSeats() + 1);
            classRepo.save(pc);
        }
        e.setStatus("CANCELLED");
        e.setPaymentStatus("CANCELLED");
        enrollmentRepo.save(e);
        return ResponseEntity.ok(ok(Map.of(
                "message", "Enrollment cancelled. Your seat was released.",
                "enrollment", enrollmentDto(e)
        )));
    }

    @GetMapping("/enrollments/me")
    public ResponseEntity<Map<String, Object>> myEnrollments(HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        List<Map<String, Object>> items = enrollmentRepo.findByUser_Id(user.getId()).stream()
                .map(this::enrollmentDto)
                .toList();
        return ResponseEntity.ok(ok(Map.of("enrollments", items, "count", items.size())));
    }

    @GetMapping("/bookings/me")
    public ResponseEntity<Map<String, Object>> myBookings(HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();

        List<Map<String, Object>> providerItems = bookingRepo.findByUserOrderByRequestedTimeDesc(user).stream().map(b -> {
            Map<String, Object> m = new LinkedHashMap<>();
            m.put("id", b.getId());
            m.put("kind", "PROVIDER");
            m.put("status", b.getStatus() == null ? null : b.getStatus().name());
            m.put("requestedTime", b.getRequestedTime() == null ? null : b.getRequestedTime().toString());
            m.put("note", b.getNote());
            m.put("totalAmount", b.getTotalAmount());
            m.put("cancelPolicy", WomenLawyerCareService.CANCEL_POLICY);
            m.put("canCancelFree", lawyerCareService.canCancelFree(b));
            if (b.getProvider() != null) m.put("provider", providerDto(b.getProvider()));
            return m;
        }).toList();

        List<Map<String, Object>> workerItems = workerBookingRepo.findByClient_Id(user.getId()).stream().map(this::workerBookingDto).toList();

        List<Map<String, Object>> all = new ArrayList<>();
        all.addAll(providerItems);
        all.addAll(workerItems);
        all.sort((a, b) -> Objects.toString(
                        b.getOrDefault("requestedTime", b.getOrDefault("bookingDate", "")))
                .compareTo(Objects.toString(a.getOrDefault("requestedTime", a.getOrDefault("bookingDate", "")))));

        return ResponseEntity.ok(ok(Map.of(
                "bookings", providerItems,
                "workerBookings", workerItems,
                "allBookings", all
        )));
    }

    @PostMapping("/bookings/{id}/cancel")
    @Transactional
    public ResponseEntity<Map<String, Object>> cancelBooking(@PathVariable Long id, HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        ProviderBooking booking = bookingRepo.findById(id).orElse(null);
        if (booking == null || booking.getUser() == null || !booking.getUser().getId().equals(user.getId())) {
            return badRequest("Booking not found");
        }
        try {
            ProviderBooking cancelled = lawyerCareService.cancelBooking(user, id, "");
            return ResponseEntity.ok(ok(Map.of(
                    "message", "Consultation cancelled",
                    "status", cancelled.getStatus().name(),
                    "cancelPolicy", WomenLawyerCareService.CANCEL_POLICY)));
        } catch (org.springframework.web.server.ResponseStatusException ex) {
            return ResponseEntity.status(ex.getStatusCode()).body(Map.of("success", false, "error", ex.getReason()));
        }
    }

    @PostMapping(value = "/jobs/apply", consumes = MediaType.APPLICATION_JSON_VALUE)
    @Transactional
    public ResponseEntity<Map<String, Object>> applyForJobJson(
            @RequestBody Map<String, Object> body,
            HttpSession session) {
        return applyForJobInternal(
                session,
                body == null ? null : Objects.toString(body.get("category"), ""),
                body == null ? null : Objects.toString(body.get("jobCategory"), ""),
                body == null ? null : Objects.toString(body.get("subCategory"), ""),
                body == null ? null : Objects.toString(body.get("jobSubCategory"), ""),
                body == null ? null : body.get("hourlyRate"),
                body == null ? null : Objects.toString(body.get("note"), ""),
                null);
    }

    @PostMapping(value = "/jobs/apply", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    @Transactional
    public ResponseEntity<Map<String, Object>> applyForJobMultipart(
            @RequestParam(value = "category", required = false) String category,
            @RequestParam(value = "jobCategory", required = false) String jobCategory,
            @RequestParam(value = "subCategory", required = false) String subCategory,
            @RequestParam(value = "jobSubCategory", required = false) String jobSubCategory,
            @RequestParam(value = "hourlyRate", required = false) String hourlyRate,
            @RequestParam(value = "note", required = false) String note,
            @RequestParam(value = "document", required = false) MultipartFile document,
            HttpSession session) {
        return applyForJobInternal(session, category, jobCategory, subCategory, jobSubCategory, hourlyRate, note, document);
    }

    private ResponseEntity<Map<String, Object>> applyForJobInternal(
            HttpSession session,
            String categoryRaw,
            String jobCategoryRaw,
            String subCategoryRaw,
            String jobSubCategoryRaw,
            Object hourlyRateRaw,
            String noteRaw,
            MultipartFile document) {
        User user = requireUser(session);
        if (user == null) return unauthorized();

        String category = JobCategories.normalize(trim(categoryRaw));
        if (category == null || category.isBlank()) {
            category = JobCategories.normalize(trim(jobCategoryRaw));
        }
        String subCategory = trim(subCategoryRaw);
        if (subCategory.isBlank()) subCategory = trim(jobSubCategoryRaw);
        final String resolvedSub = subCategory;
        Double hourlyRate = parseDoubleOrNull(hourlyRateRaw);

        if (category == null || category.isBlank() || resolvedSub.isBlank()) {
            return badRequest("category and subCategory are required");
        }
        if (!JobCategories.isKnown(category)) {
            return badRequest("Unknown job category");
        }
        List<String> subs = JobCategories.subcategories(category);
        if (!subs.isEmpty() && subs.stream().noneMatch(s -> s.equalsIgnoreCase(resolvedSub))) {
            return badRequest("subCategory does not match the selected category");
        }
        if (hourlyRate == null || hourlyRate < 0) {
            return badRequest("hourlyRate is required");
        }

        if (jobAppRepo.existsByUser_IdAndStatusIn(user.getId(),
                List.of(VerificationStatus.PENDING, VerificationStatus.VERIFIED))) {
            return badRequest("You already have a pending or verified job application.");
        }

        String docPath = "";
        if (document != null && !document.isEmpty()) {
            if (document.getSize() > 5L * 1024 * 1024) {
                return badRequest("Document must be 5MB or smaller.");
            }
            String contentType = document.getContentType() != null ? document.getContentType().toLowerCase(Locale.ROOT) : "";
            String name = document.getOriginalFilename() != null ? document.getOriginalFilename().toLowerCase(Locale.ROOT) : "";
            boolean okType = contentType.startsWith("image/") || contentType.equals("application/pdf")
                    || name.endsWith(".pdf") || name.endsWith(".png") || name.endsWith(".jpg")
                    || name.endsWith(".jpeg") || name.endsWith(".webp");
            if (!okType) {
                return badRequest("Only PDF or image files are allowed.");
            }
            try {
                docPath = fileUploadService.saveFile(document);
            } catch (Exception e) {
                return badRequest("Failed to upload document");
            }
        }

        JobApplication application = new JobApplication();
        application.setUser(user);
        application.setJobCategory(category);
        application.setJobSubCategory(resolvedSub);
        application.setHourlyRate(hourlyRate);
        application.setDocumentPath(docPath);
        application.setNote(sanitizeNote(noteRaw));
        application.setStatus(VerificationStatus.PENDING);
        jobAppRepo.save(application);

        return ResponseEntity.status(HttpStatus.CREATED).body(ok(Map.of(
                "message", "Job application submitted",
                "application", jobApplicationDto(application)
        )));
    }

    @GetMapping("/jobs/me")
    public ResponseEntity<Map<String, Object>> myJobApplication(HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        List<JobApplication> apps = jobAppRepo.findByUser_Id(user.getId());
        JobApplication latest = apps.stream()
                .max(Comparator.comparing(a -> a.getAppliedAt() == null ? LocalDateTime.MIN : a.getAppliedAt()))
                .orElse(null);
        Map<String, Object> data = new LinkedHashMap<>();
        data.put("hasApplication", latest != null);
        data.put("isVerifiedWorker", latest != null && latest.getStatus() == VerificationStatus.VERIFIED);
        data.put("needsProfileCompletion", latest == null || latest.getStatus() == VerificationStatus.REJECTED);
        data.put("suggestedCategory", in.sp.main.Service.JobWorkerRegistrationService.suggestedCategory(user));
        data.put("application", latest == null ? null : jobApplicationDto(latest));
        data.put("applications", apps.stream().map(this::jobApplicationDto).toList());
        return ResponseEntity.ok(ok(data));
    }

    @GetMapping("/jobs/dashboard")
    public ResponseEntity<Map<String, Object>> workerDashboard(HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        List<JobApplication> apps = jobAppRepo.findByUser_Id(user.getId());
        JobApplication latest = apps.stream()
                .max(Comparator.comparing(a -> a.getAppliedAt() == null ? LocalDateTime.MIN : a.getAppliedAt()))
                .orElse(null);
        List<WorkerBooking> bookings = workerBookingRepo.findByJobApplication_User_Id(user.getId());
        long pending = bookings.stream().filter(b -> "PENDING".equalsIgnoreCase(trim(b.getStatus()))).count();
        long accepted = bookings.stream().filter(b -> "ACCEPTED".equalsIgnoreCase(trim(b.getStatus()))).count();
        long completed = bookings.stream().filter(b -> "COMPLETED".equalsIgnoreCase(trim(b.getStatus()))).count();
        double earnings = bookings.stream()
                .filter(b -> "COMPLETED".equalsIgnoreCase(trim(b.getStatus())))
                .mapToDouble(b -> b.getTotalAmount() == null ? 0 : b.getTotalAmount())
                .sum();

        Map<String, Object> userDto = new LinkedHashMap<>();
        userDto.put("id", user.getId());
        userDto.put("name", user.getFullName());
        userDto.put("email", user.getEmail());
        userDto.put("phone", user.getPhoneNumber());

        Map<String, Object> data = new LinkedHashMap<>();
        data.put("user", userDto);
        data.put("hasApplication", latest != null);
        data.put("isVerifiedWorker", latest != null && latest.getStatus() == VerificationStatus.VERIFIED);
        List<String> missing = jobWorkerProfileService.missingItems(latest, user);
        data.put("needsProfileCompletion", !missing.isEmpty());
        data.put("profileCompletionPct", jobWorkerProfileService.completionPct(latest, user));
        data.put("missingItems", missing);
        data.put("suggestedCategory", in.sp.main.Service.JobWorkerRegistrationService.suggestedCategory(user));
        data.put("application", latest == null ? null : jobApplicationDto(latest));
        data.put("payoutBalance", latest == null ? 0 : latest.getPayoutBalance());
        data.put("upiId", latest == null ? null : latest.getUpiId());
        data.put("cancelPolicy", WomenJobsCareService.CANCEL_POLICY);
        data.put("bookings", bookings.stream().map(this::workerIncomingBookingDto).toList());
        data.put("pendingBookings", pending);
        data.put("acceptedBookings", accepted);
        data.put("completedBookings", completed);
        data.put("totalEarnings", earnings);
        return ResponseEntity.ok(ok(data));
    }

    @GetMapping("/workers")
    public ResponseEntity<Map<String, Object>> workers(
            @RequestParam(required = false) String category,
            @RequestParam(required = false) String city,
            @RequestParam(required = false) Double minFee,
            @RequestParam(required = false) Double maxFee,
            @RequestParam(required = false) Boolean availableToday,
            @RequestParam(required = false) Boolean doorService,
            @RequestParam(required = false) String sort,
            @RequestParam(required = false) Double lat,
            @RequestParam(required = false) Double lng,
            HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        List<JobApplication> list;
        if (category == null || category.isBlank() || "all".equalsIgnoreCase(category.trim())) {
            list = jobAppRepo.findByStatus(VerificationStatus.VERIFIED);
        } else {
            String normalized = JobCategories.normalize(category);
            list = jobAppRepo.findByJobCategoryAndStatus(
                    normalized == null ? category.trim() : normalized, VerificationStatus.VERIFIED);
        }
        String cityQ = city == null ? "" : city.trim().toLowerCase(Locale.ROOT);
        List<Map<String, Object>> items = new ArrayList<>();
        for (JobApplication a : list) {
            if (a.getStatus() != VerificationStatus.VERIFIED) continue;
            if (!cityQ.isBlank() && (a.getCity() == null || !a.getCity().toLowerCase(Locale.ROOT).contains(cityQ))) continue;
            if (Boolean.TRUE.equals(doorService) && !Boolean.TRUE.equals(a.getDoorService())) continue;
            double fee = a.getHourlyRate() == null ? 0 : a.getHourlyRate();
            if (minFee != null && fee < minFee) continue;
            if (maxFee != null && (fee == 0 || fee > maxFee)) continue;
            if (Boolean.TRUE.equals(availableToday) && !jobsCareService.availableToday(a)) continue;
            items.add(workerCard(a, user, lat, lng));
        }
        String sortKey = sort == null ? "rating" : sort.trim().toLowerCase(Locale.ROOT);
        items.sort((x, y) -> {
            if ("fee".equals(sortKey) || "price".equals(sortKey)) {
                return Double.compare(asNum(x.get("hourlyRate")), asNum(y.get("hourlyRate")));
            }
            if ("nearest".equals(sortKey)) {
                return Double.compare(asNum(x.get("distanceKm")), asNum(y.get("distanceKm")));
            }
            return Double.compare(asNum(y.get("rating")), asNum(x.get("rating")));
        });
        return ResponseEntity.ok(ok(Map.of("workers", items, "count", items.size(), "cancelPolicy", WomenJobsCareService.CANCEL_POLICY)));
    }

    @GetMapping("/workers/{id}")
    public ResponseEntity<Map<String, Object>> workerDetail(@PathVariable Long id, HttpSession session) {
        if (requireUser(session) == null) return unauthorized();
        JobApplication app = jobAppRepo.findById(id).orElse(null);
        if (app == null || app.getStatus() != VerificationStatus.VERIFIED) return badRequest("Worker not found");

        User user = requireUser(session);
        List<String> bookedTimes = workerBookingRepo.findByJobApplication_Id(id).stream()
                .filter(b -> !"REJECTED".equalsIgnoreCase(b.getStatus()) && !"CANCELLED".equalsIgnoreCase(b.getStatus()))
                .map(b -> b.getBookingDate().format(DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm")))
                .toList();
        int dur = app.getDurationMinutes() == null ? 60 : app.getDurationMinutes();
        List<String> slotsToday = jobsCareService.slotsFor(app, LocalDate.now(), dur);
        Map<String, Object> next = jobsCareService.nextSlot(app);

        return ResponseEntity.ok(ok(Map.of(
                "worker", workerCard(app, user, null, null),
                "bookedTimes", bookedTimes,
                "slotsToday", slotsToday,
                "nextSlot", next == null ? Map.of() : next,
                "noSlotsToday", slotsToday.isEmpty(),
                "reviews", jobsCareService.reviewsFor(app.getId()),
                "favorite", jobsCareService.isFavorite(user, id),
                "cancelPolicy", WomenJobsCareService.CANCEL_POLICY
        )));
    }

    @GetMapping("/workers/{id}/slots")
    public ResponseEntity<Map<String, Object>> workerSlots(
            @PathVariable Long id,
            @RequestParam(required = false) String date,
            HttpSession session) {
        if (requireUser(session) == null) return unauthorized();
        JobApplication app = jobAppRepo.findById(id).orElse(null);
        if (app == null || app.getStatus() != VerificationStatus.VERIFIED) return badRequest("Worker not found");
        LocalDate day;
        try {
            day = (date == null || date.isBlank()) ? LocalDate.now() : LocalDate.parse(date);
        } catch (Exception e) {
            return badRequest("Invalid date");
        }
        int dur = app.getDurationMinutes() == null ? 60 : app.getDurationMinutes();
        return ResponseEntity.ok(ok(Map.of(
                "date", day.toString(),
                "slots", jobsCareService.slotsFor(app, day, dur),
                "open", jobsCareService.isOpenOn(app, day),
                "nextSlot", jobsCareService.nextSlot(app) == null ? Map.of() : jobsCareService.nextSlot(app)
        )));
    }

    @PostMapping("/workers/{id}/reviews")
    @Transactional
    public ResponseEntity<Map<String, Object>> addWorkerReview(
            @PathVariable Long id,
            @RequestBody Map<String, Object> body,
            HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        JobApplication app = jobAppRepo.findById(id).orElse(null);
        if (app == null || app.getStatus() != VerificationStatus.VERIFIED) return badRequest("Worker not found");
        int rating = 5;
        try {
            if (body != null && body.get("rating") != null) rating = Integer.parseInt(body.get("rating").toString());
        } catch (Exception ignored) {}
        try {
            var review = jobsCareService.addReview(user, app, rating, body == null ? "" : trim(Objects.toString(body.get("comment"), "")));
            return ResponseEntity.ok(ok(Map.of("review", jobsCareService.reviewDto(review), "message", "Review saved")));
        } catch (org.springframework.web.server.ResponseStatusException ex) {
            return ResponseEntity.status(ex.getStatusCode()).body(Map.of("success", false, "error", ex.getReason()));
        }
    }

    @PostMapping("/workers/{id}/favorite")
    @Transactional
    public ResponseEntity<Map<String, Object>> toggleWorkerFavorite(@PathVariable Long id, HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        JobApplication app = jobAppRepo.findById(id).orElse(null);
        if (app == null || app.getStatus() != VerificationStatus.VERIFIED) return badRequest("Worker not found");
        boolean fav = jobsCareService.toggleFavorite(user, id);
        return ResponseEntity.ok(ok(Map.of("favorite", fav, "message", fav ? "Added to favourites" : "Removed from favourites")));
    }

    @GetMapping("/jobs/favorites")
    public ResponseEntity<Map<String, Object>> myJobFavorites(HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        List<Map<String, Object>> items = new ArrayList<>();
        for (var fav : jobsCareService.favoritesFor(user)) {
            jobAppRepo.findById(fav.getJobApplicationId()).ifPresent(a -> {
                if (a.getStatus() == VerificationStatus.VERIFIED) items.add(workerCard(a, user, null, null));
            });
        }
        return ResponseEntity.ok(ok(Map.of("workers", items, "count", items.size())));
    }

    @PostMapping("/workers/{id}/book")
    @Transactional
    public ResponseEntity<Map<String, Object>> bookWorker(
            @PathVariable Long id,
            @RequestBody Map<String, Object> body,
            HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();

        JobApplication app = jobAppRepo.findById(id).orElse(null);
        if (app == null || app.getStatus() != VerificationStatus.VERIFIED) return badRequest("Worker not found");
        if (app.getUser() != null && app.getUser().getId().equals(user.getId())) {
            return badRequest("You cannot book your own services");
        }

        String bookingDateRaw = trim(Objects.toString(body.get("bookingDate"), ""));
        LocalDateTime reqTime = parseRequestedTime(bookingDateRaw);
        if (reqTime == null) return badRequest("bookingDate is required in yyyy-MM-dd'T'HH:mm format");
        if (reqTime.isBefore(LocalDateTime.now())) return badRequest("Booking time cannot be in the past");
        if (reqTime.isAfter(LocalDateTime.now().plusDays(60))) return badRequest("Bookings allowed only up to 60 days ahead");
        if (!jobsCareService.isOpenOn(app, reqTime.toLocalDate())) {
            return badRequest("Worker is not available on this date");
        }

        int buffer = app.getBufferMinutes() == null ? 0 : app.getBufferMinutes();
        int window = Math.max(60, (app.getDurationMinutes() == null ? 60 : app.getDurationMinutes()) + buffer);
        boolean isBooked = workerBookingRepo.findByJobApplication_Id(id).stream()
                .filter(b -> !"REJECTED".equalsIgnoreCase(b.getStatus()) && !"CANCELLED".equalsIgnoreCase(b.getStatus()))
                .anyMatch(b -> Duration.between(b.getBookingDate(), reqTime).abs().toMinutes() < window);
        if (isBooked) return badRequest("This time slot is already booked");

        double amount = parseDouble(body.get("totalAmount"), 0.0);
        WorkerBooking booking = new WorkerBooking();
        booking.setClient(user);
        booking.setJobApplication(app);
        booking.setBookingDate(reqTime);
        booking.setTotalAmount(Math.max(amount, 0.0));
        booking.setNote(trim(Objects.toString(body.get("note"), "")));
        booking.setStatus("PENDING");
        booking.setHours(parseInt(body.get("hours"), null));
        booking.setConsentPolicy(true);
        workerBookingRepo.save(booking);

        return ResponseEntity.ok(ok(Map.of(
                "message", "Worker booking request sent",
                "bookingId", booking.getId(),
                "status", booking.getStatus(),
                "amount", booking.getTotalAmount(),
                "cancelPolicy", WomenJobsCareService.CANCEL_POLICY
        )));
    }

    @PostMapping("/workers/bookings/{id}/cancel")
    @Transactional
    public ResponseEntity<Map<String, Object>> cancelWorkerBooking(@PathVariable Long id, HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        try {
            WorkerBooking b = jobsCareService.cancelBooking(user, id, "");
            return ResponseEntity.ok(ok(Map.of(
                    "message", "Booking cancelled",
                    "status", b.getStatus(),
                    "cancelPolicy", WomenJobsCareService.CANCEL_POLICY)));
        } catch (org.springframework.web.server.ResponseStatusException ex) {
            return ResponseEntity.status(ex.getStatusCode()).body(Map.of("success", false, "error", ex.getReason()));
        }
    }

    @GetMapping("/bookings/{id}/messages")
    public ResponseEntity<Map<String, Object>> bookingMessages(@PathVariable Long id, HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        ProviderBooking booking = bookingRepo.findById(id).orElse(null);
        if (booking == null || booking.getUser() == null || !booking.getUser().getId().equals(user.getId())) {
            return badRequest("Booking not found");
        }
        return ResponseEntity.ok(ok(Map.of("messages", messageDtos(booking))));
    }

    @PostMapping("/bookings/{id}/messages")
    @Transactional
    public ResponseEntity<Map<String, Object>> sendBookingMessage(
            @PathVariable Long id,
            @RequestBody Map<String, Object> body,
            HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        ProviderBooking booking = bookingRepo.findById(id).orElse(null);
        if (booking == null || booking.getUser() == null || !booking.getUser().getId().equals(user.getId())) {
            return badRequest("Booking not found");
        }
        if (booking.getStatus() != ProviderBookingStatus.CONFIRMED
                && booking.getStatus() != ProviderBookingStatus.PAID) {
            return badRequest("Chat is available after the provider confirms this booking");
        }
        String content = trim(Objects.toString(body == null ? null : body.get("content"), ""));
        if (content.isBlank()) return badRequest("Message cannot be empty");
        MarketplaceMessage msg = new MarketplaceMessage(booking, content, "USER");
        messageRepo.save(msg);
        return ResponseEntity.ok(ok(Map.of("message", "Sent", "item", messageDto(msg))));
    }

    private Map<String, Object> providerDto(ServiceProvider p) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", p.getId());
        m.put("fullName", p.getFullName());
        m.put("category", p.getCategory() == null ? null : p.getCategory().name());
        m.put("description", p.getDescription());
        m.put("locationText", p.getLocationText() != null && !p.getLocationText().isBlank()
                ? p.getLocationText() : "Location not set");
        m.put("rating", p.getRating() != null ? p.getRating() : 0.0);
        m.put("phone", p.getPhone());
        m.put("email", p.getEmail());
        ServiceProviderProfileService.putLawyerFields(m, p);
        return m;
    }

    private Map<String, Object> providerCard(ServiceProvider p, User viewer, Double lat, Double lng) {
        Map<String, Object> m = providerDto(p);
        m.put("city", p.getCity());
        m.put("availableToday", p.getCategory() == ProviderCategory.WOMEN_LAWYER && lawyerCareService.availableToday(p));
        Map<String, Object> next = p.getCategory() == ProviderCategory.WOMEN_LAWYER ? lawyerCareService.nextSlot(p) : null;
        m.put("nextSlot", next == null ? Map.of() : next);
        m.put("nextSlotLabel", next == null ? null : next.get("label"));
        m.put("favorite", lawyerCareService.isFavorite(viewer, p.getId()));
        m.put("distanceKm", distanceKm(lat, lng, p.getLatitude(), p.getLongitude()));
        m.put("profileImageUrl", p.getProfileImageUrl());
        return m;
    }

    private Map<String, Object> classDto(ProviderClass pc) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", pc.getId());
        m.put("className", pc.getClassName());
        m.put("description", pc.getDescription());
        m.put("duration", pc.getDuration());
        m.put("dateTime", pc.getDateTime() == null ? null : pc.getDateTime().toString());
        m.put("mode", pc.getMode());
        m.put("price", pc.getPrice());
        m.put("availableSeats", pc.getAvailableSeats());
        m.put("meetingLink", pc.getMeetingLink());
        m.put("category", pc.getCategory() == null ? null : pc.getCategory().name());
        if (pc.getProvider() != null) {
            m.put("provider", providerDto(pc.getProvider()));
        }
        return m;
    }

    private Map<String, Object> reviewDto(ProviderReview review) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", review.getId());
        m.put("rating", review.getRating());
        m.put("comment", review.getComment());
        m.put("createdAt", review.getCreatedAt() == null ? null : review.getCreatedAt().toString());
        if (review.getUser() != null) {
            m.put("userName", review.getUser().getFullName());
            m.put("userId", review.getUser().getId());
        }
        return m;
    }

    private Map<String, Object> enrollmentDto(MarketplaceEnrollment e) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", e.getId());
        m.put("status", e.getStatus());
        m.put("paymentStatus", e.getPaymentStatus());
        m.put("enrollmentTime", e.getEnrollmentTime() == null ? null : e.getEnrollmentTime().toString());
        m.put("amountPaid", e.getAmountPaid());
        if (e.getProviderClass() != null) {
            m.put("classItem", classDto(e.getProviderClass()));
        }
        return m;
    }

    private Map<String, Object> jobApplicationDto(JobApplication app) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", app.getId());
        m.put("jobCategory", app.getJobCategory());
        m.put("jobSubCategory", app.getJobSubCategory());
        m.put("hourlyRate", app.getHourlyRate());
        m.put("note", app.getNote());
        m.put("documentPath", app.getDocumentPath());
        m.put("status", app.getStatus() == null ? null : app.getStatus().name());
        m.put("appliedAt", app.getAppliedAt() == null ? null : app.getAppliedAt().toString());
        m.put("hourlyRate", app.getHourlyRate());
        m.put("city", app.getCity());
        m.put("bio", app.getBio());
        m.put("rating", app.getRating());
        m.put("profileImageUrl", app.getProfileImageUrl());
        if (app.getUser() != null) {
            m.put("workerName", app.getUser().getFullName());
            m.put("workerId", app.getUser().getId());
        }
        return m;
    }

    private Map<String, Object> workerDto(JobApplication app) {
        return workerCard(app, null, null, null);
    }

    private Map<String, Object> workerCard(JobApplication app, User viewer, Double lat, Double lng) {
        Map<String, Object> m = jobApplicationDto(app);
        if (app.getUser() != null) {
            m.put("workerName", app.getUser().getFullName());
            m.put("phone", app.getUser().getPhoneNumber());
        }
        String loc = app.getCity();
        if (app.getAddress() != null && !app.getAddress().isBlank()) {
            loc = app.getAddress() + (loc == null || loc.isBlank() ? "" : ", " + loc);
        }
        m.put("location", loc == null || loc.isBlank()
                ? (app.getUser() == null ? "Location not set" : app.getUser().getHomeAddress())
                : loc);
        m.put("city", app.getCity());
        m.put("state", app.getState());
        m.put("bio", app.getBio());
        m.put("rating", app.getRating() == null ? 0.0 : app.getRating());
        m.put("doorService", Boolean.TRUE.equals(app.getDoorService()));
        m.put("serviceMode", app.getServiceMode());
        m.put("workType", app.getWorkType());
        m.put("durationMinutes", app.getDurationMinutes());
        m.put("languages", app.getLanguages());
        m.put("skills", app.getSkills());
        m.put("profileImageUrl", app.getProfileImageUrl());
        m.put("galleryPhotos", app.getGalleryPhotos());
        m.put("availableToday", jobsCareService.availableToday(app));
        Map<String, Object> next = jobsCareService.nextSlot(app);
        m.put("nextSlot", next == null ? Map.of() : next);
        m.put("nextSlotLabel", next == null ? null : next.get("label"));
        m.put("favorite", jobsCareService.isFavorite(viewer, app.getId()));
        m.put("distanceKm", distanceKm(lat, lng, app.getLatitude(), app.getLongitude()));
        return m;
    }

    private static double asNum(Object v) {
        if (v instanceof Number n) return n.doubleValue();
        try {
            return Double.parseDouble(String.valueOf(v));
        } catch (Exception e) {
            return 0;
        }
    }

    private static double distanceKm(Double lat1, Double lng1, Double lat2, Double lng2) {
        if (lat1 == null || lng1 == null || lat2 == null || lng2 == null) return 9999;
        double r = 6371;
        double dLat = Math.toRadians(lat2 - lat1);
        double dLng = Math.toRadians(lng2 - lng1);
        double a = Math.sin(dLat / 2) * Math.sin(dLat / 2)
                + Math.cos(Math.toRadians(lat1)) * Math.cos(Math.toRadians(lat2))
                * Math.sin(dLng / 2) * Math.sin(dLng / 2);
        return r * 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
    }

    private List<Map<String, Object>> messageDtos(ProviderBooking booking) {
        return messageRepo.findByBookingOrderByTimestampAsc(booking).stream().map(this::messageDto).toList();
    }

    private Map<String, Object> messageDto(MarketplaceMessage msg) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", msg.getId());
        m.put("content", msg.getContent());
        m.put("senderRole", msg.getSenderRole());
        m.put("timestamp", msg.getTimestamp() == null ? null : msg.getTimestamp().getTime());
        return m;
    }

    private Map<String, Object> workerIncomingBookingDto(WorkerBooking b) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", b.getId());
        m.put("status", b.getStatus());
        m.put("bookingDate", b.getBookingDate() == null ? null : b.getBookingDate().toString());
        m.put("note", b.getNote());
        m.put("coachNotes", b.getCoachNotes());
        m.put("hours", b.getHours());
        m.put("totalAmount", b.getTotalAmount());
        m.put("cancelPolicy", WomenJobsCareService.CANCEL_POLICY);
        m.put("serviceType", b.getJobApplication() == null ? null : b.getJobApplication().getJobCategory());
        if (b.getClient() != null) {
            m.put("clientName", b.getClient().getFullName());
            m.put("clientPhone", b.getClient().getPhoneNumber());
        }
        return m;
    }

    private Map<String, Object> workerBookingDto(WorkerBooking b) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", b.getId());
        m.put("kind", "WORKER");
        m.put("status", b.getStatus());
        m.put("bookingDate", b.getBookingDate() == null ? null : b.getBookingDate().toString());
        m.put("note", b.getNote());
        m.put("coachNotes", b.getCoachNotes());
        m.put("hours", b.getHours());
        m.put("totalAmount", b.getTotalAmount());
        m.put("cancelPolicy", WomenJobsCareService.CANCEL_POLICY);
        m.put("canCancelFree", jobsCareService.canCancelFree(b));
        if (b.getJobApplication() != null) {
            m.put("worker", workerDto(b.getJobApplication()));
        }
        return m;
    }

    private User requireUser(HttpSession session) {
        Object u = session == null ? null : session.getAttribute("user");
        return u instanceof User ? (User) u : null;
    }

    private ResponseEntity<Map<String, Object>> unauthorized() {
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(Map.of("success", false, "error", "Login required"));
    }

    private ResponseEntity<Map<String, Object>> badRequest(String error) {
        return ResponseEntity.badRequest().body(Map.of("success", false, "error", error));
    }

    private static Map<String, Object> ok(Map<String, Object> data) {
        Map<String, Object> out = new LinkedHashMap<>();
        out.put("success", true);
        out.putAll(data);
        return out;
    }

    private static String trim(String v) {
        return v == null ? "" : v.trim();
    }

    /** latin1 columns reject ₹; keep ASCII-safe until utf8mb4 migration is applied. */
    private static String sanitizeNote(String v) {
        if (v == null) return "";
        return v.trim().replace("₹", "Rs ").replace("\u20B9", "Rs ");
    }

    private static String toTitle(String raw) {
        if (raw == null || raw.isBlank()) return "";
        return Arrays.stream(raw.split("_"))
                .filter(s -> !s.isBlank())
                .map(s -> Character.toUpperCase(s.charAt(0)) + s.substring(1).toLowerCase(Locale.ROOT))
                .collect(Collectors.joining(" "));
    }

    private static double parseDouble(Object raw, double fallback) {
        Double parsed = parseDoubleOrNull(raw);
        return parsed == null ? fallback : parsed;
    }

    private static Double parseDoubleOrNull(Object raw) {
        if (raw == null || raw.toString().isBlank()) return null;
        try {
            return Double.parseDouble(raw.toString());
        } catch (Exception ignored) {
            return null;
        }
    }

    private static Integer parseInt(Object raw, Integer fallback) {
        if (raw == null) return fallback;
        try {
            return Integer.parseInt(raw.toString());
        } catch (Exception ignored) {
            return fallback;
        }
    }

    private static LocalDateTime parseRequestedTime(String raw) {
        if (raw == null || raw.isBlank()) return null;
        List<DateTimeFormatter> fmts = List.of(
                DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm"),
                DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"),
                DateTimeFormatter.ISO_LOCAL_DATE_TIME
        );
        for (DateTimeFormatter fmt : fmts) {
            try {
                return LocalDateTime.parse(raw, fmt);
            } catch (Exception ignored) {
            }
        }
        return null;
    }
}
