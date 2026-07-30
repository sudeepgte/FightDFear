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
    private EnrollmentRepository enrollmentRepository;

    @Autowired
    private EnrollmentService enrollmentService;

    @GetMapping("/centres")
    @Transactional(readOnly = true)
    public ResponseEntity<Map<String, Object>> listCentres(
            @RequestParam(value = "q", required = false) String q,
            HttpSession session) {
        User user = requireUser(session);
        if (user == null) return unauthorized();

        String query = q == null ? "" : q.trim().toLowerCase(Locale.ROOT);
        List<Map<String, Object>> centres = new ArrayList<>();
        for (MartialArtsCenter c : centreService.getApprovedCentersForDiscovery()) {
            if (!query.isEmpty()) {
                String name = c.getName() == null ? "" : c.getName().toLowerCase(Locale.ROOT);
                String loc = c.getLocation() == null ? "" : c.getLocation().toLowerCase(Locale.ROOT);
                if (!name.contains(query) && !loc.contains(query)) continue;
            }
            centres.add(centreSummary(c));
        }

        Map<String, Object> body = new LinkedHashMap<>();
        body.put("success", true);
        body.put("centres", centres);
        body.put("count", centres.size());
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
            body.put("centre", centreDetailDto(c));
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
        if (!request.isConsentAccuracy() || !request.isConsentRules()) {
            return badRequest("Please accept the consent checkboxes to continue.");
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
            return ResponseEntity.ok(body);
        } catch (IllegalArgumentException ex) {
            return badRequest("Invalid preferred day value.");
        } catch (Exception ex) {
            return badRequest("Error saving enrollment: " + ex.getMessage());
        }
    }

    private Map<String, Object> centreSummary(MartialArtsCenter c) {
        List<MartialArtsBatch> batches = c.getBatches();
        Double minFee = null;
        Double maxFee = null;
        for (MartialArtsBatch b : batches) {
            if (b.getFee() == null) continue;
            if (minFee == null || b.getFee() < minFee) minFee = b.getFee();
            if (maxFee == null || b.getFee() > maxFee) maxFee = b.getFee();
        }

        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", c.getId());
        m.put("name", c.getName());
        m.put("location", c.getLocation());
        m.put("phoneNumber", c.getPhoneNumber());
        m.put("profilePhoto", c.getProfilePhoto());
        m.put("about", truncate(c.getAbout(), 160));
        m.put("batchCount", batches.size());
        m.put("minFee", minFee);
        m.put("maxFee", maxFee);
        m.put("styles", batches.stream()
                .map(MartialArtsBatch::getStyle)
                .filter(Objects::nonNull)
                .distinct()
                .limit(5)
                .collect(Collectors.toList()));
        return m;
    }

    private Map<String, Object> centreDetailDto(MartialArtsCenter c) {
        Map<String, Object> m = centreSummary(c);
        m.put("email", c.getEmail());
        m.put("about", c.getAbout());
        m.put("howWeTeach", c.getHowWeTeach());
        m.put("whatWeOffer", c.getWhatWeOffer());
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
        m.put("amount", e.getAmountPaid());
        m.put("progress", e.getProgressPercentage() != null ? e.getProgressPercentage() : 0);
        if (e.getProposedStartDate() != null) {
            m.put("startDate", e.getProposedStartDate().toString());
        }
        boolean free = e.getBatch() != null && (e.getBatch().getFee() == null || e.getBatch().getFee() <= 0);
        m.put("paymentRequired", !free && !"PAID".equalsIgnoreCase(e.getPaymentStatus()));
        String cert = e.getCertificateDetails();
        m.put("certificateAvailable", cert != null && !cert.isBlank());
        if (cert != null && !cert.isBlank()) {
            m.put("certificateUrl", "/api/martial-arts/enrollments/" + e.getId() + "/certificate");
        }
        return m;
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
