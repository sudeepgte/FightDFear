package in.sp.main.Controller;

import in.sp.main.Entities.*;
import in.sp.main.Repository.EnrollmentRepository;
import in.sp.main.Repository.MartialArtsBatchRepository;
import in.sp.main.Service.EnrollmentService;
import in.sp.main.Service.MartialArtsCenterService;
import in.sp.main.dto.EnrollmentRequest;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;

import java.util.*;
import java.util.stream.Collectors;

/**
 * JSON Martial Arts APIs for Flutter (Bearer JWT → session user).
 */
@RestController
@RequestMapping("/api/martial-arts")
public class MobileMartialArtsController {

    @Autowired
    private MartialArtsCenterService centreService;

    @Autowired
    private MartialArtsBatchRepository batchRepository;

    @Autowired
    private in.sp.main.Repository.OnlineClassRepository onlineClassRepository;

    @Autowired
    private EnrollmentRepository enrollmentRepository;

    @Autowired
    private EnrollmentService enrollmentService;

    @Autowired
    private in.sp.main.Service.MartialArtsCareService martialArtsCareService;

    @GetMapping("/centres")
    @Transactional(readOnly = true)
    public ResponseEntity<Map<String, Object>> listCentres(
            @RequestParam(value = "q", required = false) String q,
            @RequestParam(value = "city", required = false) String city,
            @RequestParam(value = "style", required = false) String style,
            @RequestParam(value = "feeMax", required = false) Double feeMax,
            @RequestParam(value = "batchToday", required = false) Boolean batchToday,
            @RequestParam(value = "online", required = false) Boolean online,
            @RequestParam(value = "sort", required = false) String sort,
            @RequestParam(value = "lat", required = false) Double lat,
            @RequestParam(value = "lng", required = false) Double lng,
            HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();

        String query = q == null ? "" : q.trim().toLowerCase(Locale.ROOT);
        String cityQ = city == null ? "" : city.trim().toLowerCase(Locale.ROOT);
        String styleQ = style == null ? "" : style.trim().toLowerCase(Locale.ROOT);
        List<Map<String, Object>> centres = new ArrayList<>();
        for (MartialArtsCenter c : centreService.getApprovedCentersForDiscovery()) {
            if (!query.isEmpty()) {
                String name = c.getName() == null ? "" : c.getName().toLowerCase(Locale.ROOT);
                String loc = c.getLocation() == null ? "" : c.getLocation().toLowerCase(Locale.ROOT);
                String cityName = c.getCity() == null ? "" : c.getCity().toLowerCase(Locale.ROOT);
                if (!name.contains(query) && !loc.contains(query) && !cityName.contains(query)) continue;
            }
            if (!cityQ.isEmpty()) {
                String cityName = c.getCity() == null ? "" : c.getCity().toLowerCase(Locale.ROOT);
                String loc = c.getLocation() == null ? "" : c.getLocation().toLowerCase(Locale.ROOT);
                if (!cityName.contains(cityQ) && !loc.contains(cityQ)) continue;
            }
            List<MartialArtsBatch> batches = c.getBatches();
            if (!styleQ.isEmpty()) {
                String taught = c.getStylesTaught() == null ? "" : c.getStylesTaught().toLowerCase(Locale.ROOT);
                boolean match = taught.contains(styleQ)
                        || batches.stream().anyMatch(b -> b.getStyle() != null && b.getStyle().toLowerCase(Locale.ROOT).contains(styleQ));
                if (!match) continue;
            }
            Double minFee = minFee(batches);
            if (feeMax != null && minFee != null && minFee > feeMax) continue;
            if (Boolean.TRUE.equals(batchToday)
                    && batches.stream().noneMatch(martialArtsCareService::isBatchDayToday)) continue;
            if (Boolean.TRUE.equals(online)
                    && batches.stream().noneMatch(martialArtsCareService::isOnlineBatch)) continue;
            Map<String, Object> dto = centreSummary(c, user);
            if (lat != null && lng != null && c.getCentreLat() != null && c.getCentreLng() != null) {
                dto.put("distanceKm", haversineKm(lat, lng, c.getCentreLat(), c.getCentreLng()));
            }
            centres.add(dto);
        }
        centres.sort((a, b) -> compareCentres(a, b, sort));

        Map<String, Object> body = new LinkedHashMap<>();
        body.put("success", true);
        body.put("centres", centres);
        body.put("count", centres.size());
        body.put("cancelPolicy", in.sp.main.Service.MartialArtsCareService.CANCEL_POLICY);
        return ResponseEntity.ok(body);
    }

    @GetMapping("/centres/{id}")
    @Transactional(readOnly = true)
    public ResponseEntity<Map<String, Object>> centreDetail(@PathVariable Long id, HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();

        try {
            MartialArtsCenter c = centreService.getApprovedCenterById(id);
            Map<String, Object> body = new LinkedHashMap<>();
            body.put("success", true);
            body.put("centre", centreDetailDto(c, user));
            return ResponseEntity.ok(body);
        } catch (Exception ex) {
            return badRequest(ex.getMessage() == null ? "Centre not found" : ex.getMessage());
        }
    }

    @GetMapping("/my-enrollments")
    @Transactional(readOnly = true)
    public ResponseEntity<Map<String, Object>> myEnrollments(HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();

        List<Map<String, Object>> items = new ArrayList<>();
        for (Enrollment e : enrollmentService.getUserEnrollments(user.getId())) {
            items.add(enrollmentDto(e));
        }

        Map<String, Object> body = new LinkedHashMap<>();
        body.put("success", true);
        body.put("enrollments", items);
        body.put("count", items.size());
        return ResponseEntity.ok(body);
    }

    @PostMapping("/enroll")
    @Transactional
    public ResponseEntity<Map<String, Object>> enroll(
            @RequestBody EnrollmentRequest request,
            HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        if (request == null || request.getCenterId() == null || request.getBatchId() == null) {
            return badRequest("centerId and batchId are required");
        }
        if (request.getFullName() == null || request.getFullName().trim().isEmpty()) {
            return badRequest("Full name is required");
        }
        if (!request.isConsentAccuracy() || !request.isConsentRules() || !request.isConsentPolicy()) {
            return badRequest("Please accept the consent checkboxes and cancel / transfer policy to continue.");
        }

        try {
            MartialArtsCenter center = centreService.getApprovedCenterById(request.getCenterId());
            MartialArtsBatch batch = batchRepository.findById(request.getBatchId()).orElse(null);
            boolean batchBelongs = batchRepository.findByCenterId(center.getId()).stream()
                    .anyMatch(b -> b.getId().equals(request.getBatchId()));
            if (batch == null || !batchBelongs) {
                return badRequest("Invalid batch for this centre.");
            }
            if (batch.getStatus() != null && "Full".equalsIgnoreCase(batch.getStatus())) {
                return ResponseEntity.status(HttpStatus.CONFLICT)
                        .body(errorMap("This batch is full. No seats available."));
            }

            boolean alreadyEnrolled = enrollmentRepository.findByUser(user).stream()
                    .anyMatch(e -> e.getBatch() != null && e.getBatch().getId().equals(batch.getId()));
            if (alreadyEnrolled) {
                return badRequest("You are already enrolled in this batch.");
            }

            if (batch.getCapacity() != null && batch.getCapacity() > 0) {
                long currentCount = enrollmentRepository.countPaidByBatchId(batch.getId());
                if (currentCount >= batch.getCapacity()) {
                    return ResponseEntity.status(HttpStatus.CONFLICT)
                            .body(errorMap("This batch is full. No seats available."));
                }
            }

            Enrollment enrollment = new Enrollment();
            enrollment.setUser(user);
            enrollment.setCenter(center);
            enrollment.setBatch(batch);
            enrollment.setStatus(TrainingStatus.PENDING);
            enrollment.setPaymentStatus("PENDING");

            if (batch.getStyle() != null && center.getMartialArtsTypes() != null) {
                center.getMartialArtsTypes().stream()
                        .filter(t -> batch.getStyle().equalsIgnoreCase(t.getName()))
                        .findFirst()
                        .ifPresent(enrollment::setMartialArtsType);
            }

            enrollment.setFullName(request.getFullName().trim());
            enrollment.setDob(request.getDob());
            enrollment.setAge(request.getAge());
            enrollment.setGender(request.getGender());
            enrollment.setPhoneNumber(request.getPhoneNumber());
            enrollment.setEmail(request.getEmail());
            enrollment.setResidentialAddress(request.getAddress());
            enrollment.setEmergencyContactName(request.getEmergencyName());
            enrollment.setSkillLevel(request.getSkillLevel());
            enrollment.setTrainingGoal(request.getGoal());
            enrollment.setMotivation(request.getMotivation());
            if (request.getPreferredDays() != null && !request.getPreferredDays().isEmpty()) {
                Set<DayAvailable> days = request.getPreferredDays().stream()
                        .filter(Objects::nonNull)
                        .map(d -> DayAvailable.valueOf(d.trim().toUpperCase(Locale.ROOT)))
                        .collect(Collectors.toSet());
                enrollment.setPreferredDays(days);
            }
            enrollment.setMedicalConditions(request.getMedicalConditions());
            enrollment.setAllergies(request.getAllergies());
            enrollment.setFitnessNotes(request.getFitnessNotes());
            enrollment.setProposedStartDate(request.getStartDate());
            enrollment.setTrainerPreference(request.getTrainerPreference());
            Double fee = request.getMonthlyFee() != null ? request.getMonthlyFee() : batch.getFee();
            enrollment.setAmountPaid(fee);
            enrollment.setConsentAccuracy(request.isConsentAccuracy());
            enrollment.setConsentRules(request.isConsentRules());

            Enrollment saved = enrollmentRepository.save(enrollment);

            boolean isFree = batch.getFee() == null || batch.getFee() <= 0;
            if (isFree) {
                saved.setPaymentStatus("PAID");
                saved.setStatus(TrainingStatus.APPROVED);
                saved.setAmountPaid(0.0);
                enrollmentRepository.save(saved);
                if (batch.getCapacity() != null && batch.getCapacity() > 0) {
                    long newCount = enrollmentRepository.countPaidByBatchId(batch.getId());
                    if (newCount >= batch.getCapacity()) {
                        batch.setStatus("Full");
                        batchRepository.save(batch);
                    }
                }
            }

            Map<String, Object> body = new LinkedHashMap<>();
            body.put("success", true);
            body.put("message", isFree
                    ? "Enrolled successfully!"
                    : "Enrollment saved. Complete payment to confirm your seat.");
            body.put("enrollmentId", saved.getId());
            body.put("free", isFree);
            body.put("paymentRequired", !isFree);
            body.put("amount", isFree ? 0.0 : (batch.getFee() == null ? 0.0 : batch.getFee()));
            body.put("enrollment", enrollmentDto(saved));
            body.put("cancelPolicy", in.sp.main.Service.MartialArtsCareService.CANCEL_POLICY);
            return ResponseEntity.ok(body);
        } catch (IllegalArgumentException ex) {
            return badRequest("Invalid preferred day value.");
        } catch (Exception ex) {
            return badRequest("Error saving enrollment: " + ex.getMessage());
        }
    }

    @PostMapping("/favorites/{centreId}")
    @Transactional
    public ResponseEntity<Map<String, Object>> addFavorite(@PathVariable Long centreId, HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        martialArtsCareService.addFavorite(user.getId(), centreId);
        return ResponseEntity.ok(Map.of("success", true, "favorite", true));
    }

    @DeleteMapping("/favorites/{centreId}")
    @Transactional
    public ResponseEntity<Map<String, Object>> removeFavorite(@PathVariable Long centreId, HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        martialArtsCareService.removeFavorite(user.getId(), centreId);
        return ResponseEntity.ok(Map.of("success", true, "favorite", false));
    }

    @GetMapping("/centres/{id}/reviews")
    @Transactional(readOnly = true)
    public ResponseEntity<Map<String, Object>> listReviews(@PathVariable Long id, HttpSession session) {
        if (requireUser(session) == null) return unauthorized();
        Map<String, Object> body = new LinkedHashMap<>(martialArtsCareService.reviewSummary(id));
        body.put("success", true);
        body.put("reviews", martialArtsCareService.reviewDtos(id));
        return ResponseEntity.ok(body);
    }

    @PostMapping("/centres/{id}/reviews")
    @Transactional
    public ResponseEntity<Map<String, Object>> addReview(
            @PathVariable Long id,
            @RequestBody Map<String, Object> body,
            HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        try {
            MartialArtsCenter c = centreService.getApprovedCenterById(id);
            int rating = body.get("rating") == null ? 0 : Integer.parseInt(body.get("rating").toString());
            String comment = body.get("comment") == null ? "" : body.get("comment").toString();
            martialArtsCareService.addReview(user, c, rating, comment);
            Map<String, Object> res = new LinkedHashMap<>();
            res.put("success", true);
            res.put("message", "Review saved");
            res.putAll(martialArtsCareService.reviewSummary(id));
            return ResponseEntity.ok(res);
        } catch (org.springframework.web.server.ResponseStatusException ex) {
            return ResponseEntity.status(ex.getStatusCode())
                    .body(errorMap(ex.getReason() == null ? "Review failed" : ex.getReason()));
        } catch (Exception ex) {
            return badRequest(ex.getMessage() == null ? "Centre not found" : ex.getMessage());
        }
    }

    @PostMapping("/enrollments/{id}/cancel")
    @Transactional
    public ResponseEntity<Map<String, Object>> cancelEnrollment(
            @PathVariable Long id,
            @RequestBody(required = false) Map<String, String> body,
            HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        try {
            Enrollment saved = martialArtsCareService.cancelEnrollment(
                    user, id, body == null ? null : body.get("reason"));
            Map<String, Object> res = new LinkedHashMap<>();
            res.put("success", true);
            res.put("message", "Enrollment cancelled");
            res.put("enrollment", enrollmentDto(saved));
            return ResponseEntity.ok(res);
        } catch (org.springframework.web.server.ResponseStatusException ex) {
            return ResponseEntity.status(ex.getStatusCode())
                    .body(errorMap(ex.getReason() == null ? "Cancel failed" : ex.getReason()));
        }
    }

    @PostMapping("/enrollments/{id}/transfer")
    @Transactional
    public ResponseEntity<Map<String, Object>> transferEnrollment(
            @PathVariable Long id,
            @RequestBody Map<String, Object> body,
            HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        try {
            Long newBatchId = Long.parseLong(String.valueOf(body.get("batchId")));
            Enrollment saved = martialArtsCareService.transferEnrollment(user, id, newBatchId);
            Map<String, Object> res = new LinkedHashMap<>();
            res.put("success", true);
            res.put("message", "Batch transferred");
            res.put("enrollment", enrollmentDto(saved));
            return ResponseEntity.ok(res);
        } catch (org.springframework.web.server.ResponseStatusException ex) {
            return ResponseEntity.status(ex.getStatusCode())
                    .body(errorMap(ex.getReason() == null ? "Transfer failed" : ex.getReason()));
        } catch (Exception ex) {
            return badRequest("batchId is required");
        }
    }

    @GetMapping("/online-classes/{id}/join")
    @Transactional
    public ResponseEntity<Map<String, Object>> joinOnlineClass(@PathVariable Long id, HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();
        in.sp.main.Entities.OnlineClass oc = onlineClassRepository.findById(id).orElse(null);
        if (oc == null) return badRequest("Class not found");
        if (!martialArtsCareService.canJoin(oc)) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(errorMap(martialArtsCareService.joinWindowHint(oc)));
        }
        Map<String, Object> res = new LinkedHashMap<>();
        res.put("success", true);
        res.put("meetingLink", oc.getMeetingLink());
        res.put("canJoin", true);
        res.put("joinHint", martialArtsCareService.joinWindowHint(oc));
        return ResponseEntity.ok(res);
    }

    private Map<String, Object> centreSummary(MartialArtsCenter c) {
        return centreSummary(c, null);
    }

    private Map<String, Object> centreSummary(MartialArtsCenter c, User user) {
        List<MartialArtsBatch> batches = c.getBatches();
        Double minFee = minFee(batches);
        Double maxFee = null;
        for (MartialArtsBatch b : batches) {
            if (b.getFee() == null) continue;
            if (maxFee == null || b.getFee() > maxFee) maxFee = b.getFee();
        }

        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", c.getId());
        m.put("name", c.getName());
        m.put("location", c.getLocation());
        m.put("city", c.getCity());
        m.put("state", c.getState());
        m.put("pincode", c.getPincode());
        m.put("phoneNumber", c.getPhoneNumber());
        m.put("profilePhoto", c.getProfilePhoto());
        m.put("about", truncate(c.getAbout(), 160));
        m.put("batchCount", batches.size());
        m.put("minFee", minFee);
        m.put("maxFee", maxFee);
        m.put("startingFee", c.getStartingFee() == null ? minFee : c.getStartingFee());
        m.put("rating", c.getRating() == null ? 0 : c.getRating());
        m.put("trialAvailable", Boolean.TRUE.equals(c.getTrialAvailable()));
        m.put("onlineAvailable", batches.stream().anyMatch(martialArtsCareService::isOnlineBatch));
        m.put("batchToday", batches.stream().anyMatch(martialArtsCareService::isBatchDayToday));
        m.put("favorite", user != null && martialArtsCareService.isFavorite(user.getId(), c.getId()));
        m.put("galleryPhotos", c.getGalleryPhotos() == null ? List.of() : c.getGalleryPhotos());
        Map<String, Object> next = martialArtsCareService.nextBatchInfo(c, batches);
        m.putAll(next);
        m.put("styles", stylesOf(c, batches));
        return m;
    }

    private Map<String, Object> centreDetailDto(MartialArtsCenter c, User user) {
        Map<String, Object> m = centreSummary(c, user);
        m.put("email", c.getEmail());
        m.put("about", c.getAbout());
        m.put("howWeTeach", c.getHowWeTeach());
        m.put("whatWeOffer", c.getWhatWeOffer());
        m.put("facilities", c.getFacilities());
        m.put("openTime", c.getOpenTime());
        m.put("closeTime", c.getCloseTime());
        m.put("googleMapLocation", c.getGoogleMapLocation());
        m.put("centreLat", c.getCentreLat());
        m.put("centreLng", c.getCentreLng());
        m.put("womenOnlyBatches", Boolean.TRUE.equals(c.getWomenOnlyBatches()));
        m.put("femaleInstructor", Boolean.TRUE.equals(c.getFemaleInstructor()));
        m.put("cancelPolicy", in.sp.main.Service.MartialArtsCareService.CANCEL_POLICY);
        m.put("reviews", martialArtsCareService.reviewDtos(c.getId()));
        m.putAll(martialArtsCareService.reviewSummary(c.getId()));
        m.put("galleryPhotos", c.getGalleryPhotos() == null ? List.of() : c.getGalleryPhotos());
        if (c.getAvailableDays() != null) {
            m.put("availableDays", c.getAvailableDays().stream().map(Enum::name).collect(Collectors.toList()));
        } else {
            m.put("availableDays", List.of());
        }

        List<Map<String, Object>> batchDtos = new ArrayList<>();
        for (MartialArtsBatch b : c.getBatches()) {
            batchDtos.add(batchDto(b));
        }
        m.put("batches", batchDtos);

        List<Map<String, Object>> types = new ArrayList<>();
        if (c.getMartialArtsTypes() != null) {
            for (MartialArtsType t : c.getMartialArtsTypes()) {
                Map<String, Object> tm = new LinkedHashMap<>();
                tm.put("id", t.getId());
                tm.put("name", t.getName());
                tm.put("cost", t.getCost());
                types.add(tm);
            }
        }
        m.put("types", types);
        return m;
    }

    private Map<String, Object> batchDto(MartialArtsBatch b) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", b.getId());
        m.put("name", b.getName());
        m.put("style", b.getStyle());
        m.put("instructor", b.getInstructor());
        m.put("ageGroup", b.getAgeGroup());
        m.put("skillLevel", b.getSkillLevel());
        m.put("availableDays", b.getAvailableDays());
        m.put("batchType", b.getBatchType());
        m.put("status", b.getStatus());
        m.put("capacity", b.getCapacity());
        m.put("timeSlot", b.getTimeSlot());
        m.put("location", b.getLocation());
        m.put("fee", b.getFee());
        m.put("admissionFee", b.getAdmissionFee());
        m.put("trialType", b.getTrialType());
        m.put("bufferMinutes", b.getBufferMinutes());
        m.put("durationMinutes", b.getDurationMinutes());
        m.put("batchToday", martialArtsCareService.isBatchDayToday(b));
        m.put("free", b.getFee() == null || b.getFee() <= 0);
        if (b.getCapacity() != null && b.getCapacity() > 0) {
            long paid = enrollmentRepository.countPaidByBatchId(b.getId());
            m.put("enrolledCount", paid);
            m.put("seatsLeft", Math.max(0, b.getCapacity() - paid));
        }
        if (b.getStartDate() != null) m.put("startDate", b.getStartDate().toString());
        if (b.getEndDate() != null) m.put("endDate", b.getEndDate().toString());
        return m;
    }

    private Map<String, Object> enrollmentDto(Enrollment e) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("enrollmentId", e.getId());
        m.put("centreId", e.getCenter() != null ? e.getCenter().getId() : null);
        m.put("centreName", e.getCenter() != null ? e.getCenter().getName() : null);
        m.put("batchId", e.getBatch() != null ? e.getBatch().getId() : null);
        m.put("batchName", e.getBatch() != null ? e.getBatch().getName() : null);
        m.put("martialArtType", e.getMartialArtsType() != null
                ? e.getMartialArtsType().getName()
                : (e.getBatch() != null ? e.getBatch().getStyle() : null));
        m.put("mode", e.getBatch() != null && e.getBatch().getBatchType() != null
                ? e.getBatch().getBatchType() : "Offline");
        m.put("slot", e.getBatch() != null ? e.getBatch().getTimeSlot() : null);
        m.put("instructor", e.getBatch() != null ? e.getBatch().getInstructor() : null);
        m.put("status", e.getStatus() != null ? e.getStatus().name() : "PENDING");
        m.put("paymentStatus", e.getPaymentStatus());
        if (e.getProposedStartDate() != null) {
            m.put("startDate", e.getProposedStartDate().toString());
        }
        boolean free = e.getBatch() != null && (e.getBatch().getFee() == null || e.getBatch().getFee() <= 0);
        double fee = free ? 0 : (e.getBatch() != null && e.getBatch().getFee() != null ? e.getBatch().getFee() : 0);
        m.put("fee", fee);
        m.put("amount", fee > 0 ? fee : (e.getAmountPaid() != null ? e.getAmountPaid() : 0));
        m.put("progress", e.getProgressPercentage() != null ? e.getProgressPercentage() : 0);
        m.put("paymentRequired", !free && !"PAID".equalsIgnoreCase(e.getPaymentStatus()));
        m.put("cancelPolicy", in.sp.main.Service.MartialArtsCareService.CANCEL_POLICY);
        m.put("transferUsed", Boolean.TRUE.equals(e.getTransferUsed()));
        m.put("canCancel", e.getStatus() != TrainingStatus.CANCELLED && e.getStatus() != TrainingStatus.COMPLETED);
        m.put("canTransfer", e.getStatus() != TrainingStatus.CANCELLED
                && e.getStatus() != TrainingStatus.COMPLETED
                && !Boolean.TRUE.equals(e.getTransferUsed()));
        String cert = e.getCertificateDetails();
        m.put("certificateAvailable", cert != null && !cert.isBlank());
        if (cert != null && !cert.isBlank()) {
            m.put("certificateUrl", "/api/martial-arts/enrollments/" + e.getId() + "/certificate");
        }
        return m;
    }

    private static Double minFee(List<MartialArtsBatch> batches) {
        Double min = null;
        for (MartialArtsBatch b : batches) {
            if (b.getFee() == null) continue;
            if (min == null || b.getFee() < min) min = b.getFee();
        }
        return min;
    }

    private static List<String> stylesOf(MartialArtsCenter c, List<MartialArtsBatch> batches) {
        List<String> styles = new ArrayList<>();
        if (c.getStylesTaught() != null && !c.getStylesTaught().isBlank()) {
            for (String s : c.getStylesTaught().split(",")) {
                if (!s.isBlank()) styles.add(s.trim());
            }
        }
        for (MartialArtsBatch b : batches) {
            if (b.getStyle() != null && !b.getStyle().isBlank() && !styles.contains(b.getStyle())) {
                styles.add(b.getStyle());
            }
        }
        return styles.stream().limit(6).toList();
    }

    private static int compareCentres(Map<String, Object> a, Map<String, Object> b, String sort) {
        if ("fee".equalsIgnoreCase(sort)) {
            double fa = a.get("minFee") instanceof Number n ? n.doubleValue() : Double.MAX_VALUE;
            double fb = b.get("minFee") instanceof Number n ? n.doubleValue() : Double.MAX_VALUE;
            return Double.compare(fa, fb);
        }
        if ("nearest".equalsIgnoreCase(sort)) {
            double da = a.get("distanceKm") instanceof Number n ? n.doubleValue() : Double.MAX_VALUE;
            double db = b.get("distanceKm") instanceof Number n ? n.doubleValue() : Double.MAX_VALUE;
            return Double.compare(da, db);
        }
        double ra = a.get("rating") instanceof Number n ? n.doubleValue() : 0;
        double rb = b.get("rating") instanceof Number n ? n.doubleValue() : 0;
        return Double.compare(rb, ra);
    }

    private static double haversineKm(double lat1, double lng1, double lat2, double lng2) {
        double r = 6371;
        double dLat = Math.toRadians(lat2 - lat1);
        double dLng = Math.toRadians(lng2 - lng1);
        double h = Math.sin(dLat / 2) * Math.sin(dLat / 2)
                + Math.cos(Math.toRadians(lat1)) * Math.cos(Math.toRadians(lat2))
                * Math.sin(dLng / 2) * Math.sin(dLng / 2);
        return Math.round(r * 2 * Math.atan2(Math.sqrt(h), Math.sqrt(1 - h)) * 10.0) / 10.0;
    }

    private static String truncate(String s, int max) {
        if (s == null) return null;
        String t = s.trim();
        if (t.length() <= max) return t;
        return t.substring(0, max - 1) + "…";
    }

    private User requireUser(HttpSession session) {
        if (session == null) return null;
        Object u = session.getAttribute("user");
        return u instanceof User ? (User) u : null;
    }

    private ResponseEntity<Map<String, Object>> unauthorized() {
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                .body(errorMap("Login required"));
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
}
