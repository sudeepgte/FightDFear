package in.sp.main.Controller;

import in.sp.main.Config.JwtUtil;
import in.sp.main.Entities.*;
import in.sp.main.Repository.*;
import in.sp.main.Service.FileUploadService;
import in.sp.main.Service.PartnerLifecycleSupport;
import in.sp.main.Service.PasswordService;
import in.sp.main.Service.ServiceProviderProfileService;
import in.sp.main.Service.ServiceProviderRegistrationService;
import in.sp.main.Service.WomenLawyerCareService;
import org.springframework.web.multipart.MultipartFile;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import in.sp.main.Util.LawyerCategories;
import in.sp.main.Util.MobileValidation;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.LinkedHashMap;
import java.util.Locale;
import java.util.Map;
import java.util.Objects;
import java.util.Optional;

@RestController
@RequestMapping("/api/marketplace/provider")
public class MobileMarketplaceProviderAuthController {

    @Autowired
    private ServiceProviderRepository providerRepo;
    @Autowired
    private ProviderBookingRepository bookingRepo;
    @Autowired
    private ProviderClassRepository classRepo;
    @Autowired
    private MarketplaceEnrollmentRepository enrollmentRepo;
    @Autowired
    private PasswordService passwordService;
    @Autowired
    private JwtUtil jwtUtil;
    @Autowired
    private ServiceProviderRegistrationService providerRegistrationService;
    @Autowired
    private ServiceProviderProfileService providerProfileService;
    @Autowired
    private MarketplaceMessageRepository messageRepo;
    @Autowired
    private WomenLawyerCareService lawyerCareService;
    @Autowired
    private FileUploadService fileUploadService;

    @PostMapping("/otp/send-email")
    public ResponseEntity<Map<String, Object>> sendEmailOtp(@RequestBody Map<String, String> body) {
        try {
            providerRegistrationService.sendRegistrationOtp(body == null ? null : body.get("email"));
            Map<String, Object> res = new LinkedHashMap<>();
            res.put("success", true);
            res.put("message", "OTP sent to your email");
            return ResponseEntity.ok(res);
        } catch (org.springframework.web.server.ResponseStatusException ex) {
            return ResponseEntity.status(ex.getStatusCode()).body(error(ex.getReason()));
        }
    }

    @PostMapping("/otp/verify-email")
    public ResponseEntity<Map<String, Object>> verifyEmailOtp(@RequestBody Map<String, String> body) {
        try {
            providerRegistrationService.verifyRegistrationOtp(
                    body == null ? null : body.get("email"),
                    body == null ? null : body.get("otp"));
            Map<String, Object> res = new LinkedHashMap<>();
            res.put("success", true);
            res.put("message", "Email verified");
            return ResponseEntity.ok(res);
        } catch (org.springframework.web.server.ResponseStatusException ex) {
            return ResponseEntity.status(ex.getStatusCode()).body(error(ex.getReason()));
        }
    }

    @PostMapping("/register-quick")
    public ResponseEntity<Map<String, Object>> registerQuick(@RequestBody Map<String, Object> body) {
        try {
            boolean accepted = body != null && (
                    Boolean.TRUE.equals(body.get("acceptedTerms"))
                            || "true".equalsIgnoreCase(String.valueOf(body.get("acceptedTerms"))));
            ServiceProvider p = providerRegistrationService.registerQuick(
                    str(body, "fullName"),
                    str(body, "email"),
                    str(body, "phone"),
                    str(body, "password"),
                    str(body, "confirmPassword"),
                    str(body, "emailOtp"),
                    accepted,
                    str(body, "category"));
            Map<String, Object> res = new LinkedHashMap<>();
            res.put("success", true);
            res.put("message", "Account created. Login and complete your profile to submit for verification.");
            res.put("providerId", p.getId());
            res.put("partnerProfileStatus", p.getPartnerProfileStatus() == null
                    ? null : p.getPartnerProfileStatus().name());
            res.put("profileCompletionPct", p.getProfileCompletionPct());
            return ResponseEntity.status(HttpStatus.CREATED).body(res);
        } catch (org.springframework.web.server.ResponseStatusException ex) {
            return ResponseEntity.status(ex.getStatusCode()).body(error(ex.getReason()));
        }
    }

    /**
     * Legacy full registration — kept for older clients.
     */
    @PostMapping("/register")
    public ResponseEntity<Map<String, Object>> register(@RequestBody Map<String, String> body) {
        String fullName = trim(body == null ? null : body.get("fullName"));
        String email = MobileValidation.normalizeEmail(body == null ? null : body.get("email"));
        String phone = trim(body == null ? null : body.get("phone"));
        String password = body == null ? "" : body.getOrDefault("password", "");
        String confirmPassword = body == null ? "" : body.getOrDefault("confirmPassword", "");
        String categoryRaw = trim(body == null ? null : body.get("category"));
        String description = trim(body == null ? null : body.get("description"))
                .replace("₹", "Rs ")
                .replace("\u20B9", "Rs ");
        String locationText = trim(body == null ? null : body.get("locationText"))
                .replace("₹", "Rs ")
                .replace("\u20B9", "Rs ");

        if (fullName.isBlank() || categoryRaw.isBlank()) {
            return badRequest("fullName and category are required");
        }
        String emailErr = MobileValidation.requireEmail(email);
        if (emailErr != null) return badRequest(emailErr);
        String phoneErr = MobileValidation.requirePhone(phone, true);
        if (phoneErr != null) return badRequest(phoneErr);
        String passErr = MobileValidation.requirePassword(password);
        if (passErr != null) return badRequest(passErr);
        String confirmErr = MobileValidation.requireConfirm(password, confirmPassword);
        if (confirmErr != null) return badRequest(confirmErr);
        if (locationText.isBlank()) return badRequest("locationText is required");
        if (providerRepo.findByEmail(email).isPresent()) {
            return ResponseEntity.status(HttpStatus.CONFLICT).body(error("Email already registered"));
        }

        ProviderCategory category = ProviderCategory.fromFlexible(categoryRaw);
        if (category == null) {
            return badRequest("Invalid category: " + categoryRaw
                    + ". Pick a Service Partner category from the app list.");
        }

        ServiceProvider p = new ServiceProvider();
        p.setFullName(fullName);
        p.setEmail(email);
        p.setPhone(phone);
        p.setPassword(passwordService.encode(password));
        p.setCategory(category);
        p.setDescription(description.isBlank() ? null : description);
        p.setLocationText(locationText.isBlank() ? null : locationText);
        p.setIdentityDocumentPath("mobile-pending");
        p.setRating(0.0);
        providerProfileService.setLifecycleStatus(p, PartnerProfileStatus.REGISTERED);
        try {
            providerRepo.save(p);
        } catch (Exception ex) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(error("Could not save service partner: " + ex.getMessage()));
        }
        providerProfileService.setLifecycleStatus(p, PartnerProfileStatus.PROFILE_INCOMPLETE);
        providerProfileService.refreshCompletion(p);

        Map<String, Object> res = new LinkedHashMap<>();
        res.put("success", true);
        res.put("message", "Registration submitted. Complete your profile and await admin verification.");
        res.put("providerId", p.getId());
        res.put("status", "PENDING");
        res.put("category", category.name());
        res.put("partnerProfileStatus", p.getPartnerProfileStatus() == null
                ? null : p.getPartnerProfileStatus().name());
        return ResponseEntity.status(HttpStatus.CREATED).body(res);
    }

    @PostMapping("/login")
    public ResponseEntity<Map<String, Object>> login(@RequestBody Map<String, String> body, HttpSession session) {
        String email = trim(body == null ? null : body.get("email")).toLowerCase(Locale.ROOT);
        String password = body == null ? "" : body.getOrDefault("password", "");
        if (email.isBlank() || password.isBlank()) return badRequest("Email and password are required");

        Optional<ServiceProvider> opt = providerRepo.findByEmail(email);
        if (opt.isEmpty()) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(error("Provider not found"));
        }
        ServiceProvider p = opt.get();
        boolean ok = passwordService.matchesAndUpgrade(password, p.getPassword(), hashed -> {
            p.setPassword(hashed);
            providerRepo.save(p);
        });
        if (!ok) return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(error("Invalid password"));

        if (p.getPartnerProfileStatus() == PartnerProfileStatus.SUSPENDED) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN)
                    .body(error("Your provider account has been suspended"));
        }
        String expectedCategory = trim(body == null ? null : body.get("expectedCategory"));
        if (!expectedCategory.isBlank()) {
            ProviderCategory want = ProviderCategory.fromFlexible(expectedCategory);
            if (want != null && p.getCategory() != want) {
                return ResponseEntity.status(HttpStatus.FORBIDDEN).body(error(
                        want == ProviderCategory.WOMEN_LAWYER
                                ? "This login is for Women Lawyer accounts. Use Service Partner login for other categories."
                                : "This account does not match this portal. Use the matching Join Us / Login option."));
            }
        } else if (p.getCategory() == ProviderCategory.WOMEN_LAWYER) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(error(
                    "This is a Women Lawyer account. Use Login → Women Lawyer Login."));
        }

        PartnerProfileStatus status = p.getPartnerProfileStatus();
        if (status == null) {
            if (p.getVerificationStatus() == VerificationStatus.VERIFIED) {
                providerProfileService.setLifecycleStatus(p, PartnerProfileStatus.APPROVED);
            } else if (p.getVerificationStatus() == VerificationStatus.REJECTED) {
                providerProfileService.setLifecycleStatus(p, PartnerProfileStatus.REJECTED);
            } else {
                providerProfileService.setLifecycleStatus(p, PartnerProfileStatus.PROFILE_INCOMPLETE);
            }
            providerProfileService.refreshCompletion(p);
        } else {
            providerProfileService.refreshCompletion(p);
        }

        session.setAttribute("loggedProvider", p);
        String token = jwtUtil.generateToken(p.getEmail(), "PROVIDER");
        Map<String, Object> res = new LinkedHashMap<>();
        res.put("success", true);
        res.put("token", token);
        res.put("tokenType", "Bearer");
        res.put("role", "PROVIDER");
        res.put("provider", providerSummary(p));
        res.put("needsProfileCompletion",
                PartnerLifecycleSupport.needsProfileCompletion(p.getPartnerProfileStatus()));
        res.put("canSubmitForVerification",
                providerProfileService.isReadyForVerification(p)
                        && p.getPartnerProfileStatus() != PartnerProfileStatus.PENDING_ADMIN_APPROVAL);
        return ResponseEntity.ok(res);
    }

    @GetMapping("/profile")
    public ResponseEntity<Map<String, Object>> getProfile(HttpSession session) {
        ServiceProvider p = requireProvider(session);
        if (p == null) return unauthorized();
        p = providerRepo.findById(p.getId()).orElse(p);
        Map<String, Object> res = new LinkedHashMap<>();
        res.put("success", true);
        res.putAll(providerProfileService.profilePayload(p));
        return ResponseEntity.ok(res);
    }

    @PutMapping("/profile")
    @Transactional
    public ResponseEntity<Map<String, Object>> updateProfile(
            @RequestBody Map<String, Object> body,
            HttpSession session) {
        ServiceProvider p = requireProvider(session);
        if (p == null) return unauthorized();
        p = providerRepo.findById(p.getId()).orElse(p);
        if (body != null) {
            if (body.get("fullName") != null) p.setFullName(String.valueOf(body.get("fullName")).trim());
            if (body.get("phone") != null) p.setPhone(String.valueOf(body.get("phone")).trim());
            if (body.get("description") != null) {
                String v = String.valueOf(body.get("description")).trim()
                        .replace("₹", "Rs ").replace("\u20B9", "Rs ");
                p.setDescription(v.isBlank() ? null : v);
            }
            if (body.get("locationText") != null) {
                String v = String.valueOf(body.get("locationText")).trim()
                        .replace("₹", "Rs ").replace("\u20B9", "Rs ");
                p.setLocationText(v.isBlank() ? null : v);
            }
            if (body.get("identityDocumentPath") != null) {
                String v = String.valueOf(body.get("identityDocumentPath")).trim();
                p.setIdentityDocumentPath(v.isBlank() ? null : v);
            }
            if (body.get("category") != null && p.getCategory() != ProviderCategory.WOMEN_LAWYER) {
                String raw = String.valueOf(body.get("category")).trim();
                if (raw.isBlank()) {
                    p.setCategory(null);
                } else {
                    ProviderCategory cat = ProviderCategory.fromFlexible(raw);
                    if (cat == null) {
                        return badRequest("Invalid category: " + raw);
                    }
                    if (cat == ProviderCategory.WOMEN_LAWYER) {
                        return badRequest("Women Lawyer accounts must register from Join Us → Women Lawyer.");
                    }
                    p.setCategory(cat);
                }
            }
            if (body.get("practiceAreas") != null) {
                Object rawAreas = body.get("practiceAreas");
                String joined = rawAreas instanceof List<?> list
                        ? String.join(", ", list.stream().map(String::valueOf).toList())
                        : String.valueOf(rawAreas);
                p.setPracticeAreas(LawyerCategories.normalizeList(joined));
            }
            if (body.get("barCouncilId") != null) {
                String v = String.valueOf(body.get("barCouncilId")).trim();
                p.setBarCouncilId(v.isBlank() ? null : v);
            }
            Object yearsRaw = body.get("experienceYears") != null ? body.get("experienceYears") : body.get("yearsExperience");
            if (yearsRaw != null && !String.valueOf(yearsRaw).isBlank()) {
                try {
                    int years = Integer.parseInt(String.valueOf(yearsRaw).trim());
                    if (years < 0 || years > 60) return badRequest("Years of experience must be 0–60");
                    p.setExperienceYears(years);
                } catch (Exception e) {
                    return badRequest("Invalid experienceYears");
                }
            }
            if (body.get("languages") != null) {
                Object rawLang = body.get("languages");
                String joined = rawLang instanceof List<?> list
                        ? String.join(", ", list.stream().map(String::valueOf).map(String::trim)
                                .filter(s -> !s.isEmpty()).toList())
                        : String.valueOf(rawLang).trim();
                p.setLanguages(joined.isBlank() ? null : joined);
            }
            if (body.get("consultationFee") != null && !String.valueOf(body.get("consultationFee")).isBlank()) {
                try {
                    double fee = Double.parseDouble(String.valueOf(body.get("consultationFee")).trim()
                            .replace("₹", "").replace("Rs", "").trim());
                    if (fee < 0) return badRequest("Consultation fee cannot be negative");
                    p.setConsultationFee(fee);
                } catch (Exception e) {
                    return badRequest("Invalid consultationFee");
                }
            }
            if (body.get("consultationMode") != null) {
                p.setConsultationMode(LawyerCategories.normalizeMode(String.valueOf(body.get("consultationMode"))));
            }
            providerProfileService.applyExtraFields(p, body);
        }
        providerProfileService.refreshCompletion(p);
        Map<String, Object> res = new LinkedHashMap<>();
        res.put("success", true);
        res.put("message", "Profile saved");
        res.putAll(providerProfileService.profilePayload(p));
        return ResponseEntity.ok(res);
    }

    @PostMapping("/submit-verification")
    public ResponseEntity<Map<String, Object>> submitVerification(HttpSession session) {
        ServiceProvider p = requireProvider(session);
        if (p == null) return unauthorized();
        try {
            ServiceProvider provider = providerRepo.findById(p.getId()).orElse(p);
            providerRegistrationService.submitForVerification(provider);
            Map<String, Object> res = new LinkedHashMap<>();
            res.put("success", true);
            res.put("message", "Submitted for admin verification");
            res.putAll(providerProfileService.profilePayload(provider));
            return ResponseEntity.ok(res);
        } catch (org.springframework.web.server.ResponseStatusException ex) {
            return ResponseEntity.status(ex.getStatusCode()).body(error(ex.getReason()));
        }
    }

    @GetMapping("/me")
    public ResponseEntity<Map<String, Object>> dashboard(HttpSession session) {
        ServiceProvider p = requireProvider(session);
        if (p == null) return unauthorized();
        p = providerRepo.findById(p.getId()).orElse(p);

        var bookings = bookingRepo.findByProviderOrderByRequestedTimeDesc(p).stream().map(b -> {
            Map<String, Object> m = new LinkedHashMap<>();
            m.put("id", b.getId());
            m.put("status", b.getStatus() == null ? null : b.getStatus().name());
            m.put("requestedTime", b.getRequestedTime() == null ? null : b.getRequestedTime().toString());
            m.put("note", b.getNote());
            m.put("coachNotes", b.getCoachNotes());
            m.put("totalAmount", b.getTotalAmount());
            m.put("cancelPolicy", WomenLawyerCareService.CANCEL_POLICY);
            m.put("canCancelFree", lawyerCareService.canCancelFree(b));
            if (b.getUser() != null) {
                m.put("clientName", b.getUser().getFullName());
                m.put("clientPhone", b.getUser().getPhoneNumber());
            }
            return m;
        }).toList();

        var classes = classRepo.findByProvider_Id(p.getId()).stream().map(this::classDto).toList();
        var enrollments = enrollmentRepo.findByProviderId(p.getId()).stream().map(e -> {
            Map<String, Object> m = new LinkedHashMap<>();
            m.put("id", e.getId());
            m.put("status", e.getStatus());
            m.put("paymentStatus", e.getPaymentStatus());
            m.put("amountPaid", e.getAmountPaid());
            m.put("enrollmentTime", e.getEnrollmentTime() == null ? null : e.getEnrollmentTime().toString());
            if (e.getUser() != null) m.put("userName", e.getUser().getFullName());
            if (e.getProviderClass() != null) {
                m.put("className", e.getProviderClass().getClassName());
                m.put("classId", e.getProviderClass().getId());
            }
            return m;
        }).toList();

        double classEarnings = enrollmentRepo.findByProviderId(p.getId()).stream()
                .filter(e -> "PAID".equalsIgnoreCase(e.getPaymentStatus()))
                .mapToDouble(e -> e.getAmountPaid() == null ? 0.0 : e.getAmountPaid())
                .sum();
        double consultEarnings = bookingRepo.findByProviderOrderByRequestedTimeDesc(p).stream()
                .filter(b -> b.getStatus() == ProviderBookingStatus.PAID || b.getStatus() == ProviderBookingStatus.COMPLETED)
                .mapToDouble(b -> b.getTotalAmount() == null ? 0.0 : b.getTotalAmount())
                .sum();

        return ResponseEntity.ok(ok(Map.of(
                "provider", providerSummary(p),
                "bookings", bookings,
                "classes", classes,
                "enrollments", enrollments,
                "totalEarnings", classEarnings + consultEarnings,
                "payoutBalance", p.getPayoutBalance(),
                "upiId", p.getUpiId() == null ? "" : p.getUpiId(),
                "cancelPolicy", WomenLawyerCareService.CANCEL_POLICY,
                "canCreateClass", p.getPartnerProfileStatus() == PartnerProfileStatus.APPROVED
        )));
    }

    @PostMapping("/payout/request")
    @Transactional
    public ResponseEntity<Map<String, Object>> requestPayout(HttpSession session) {
        ServiceProvider p = requireProvider(session);
        if (p == null) return unauthorized();
        try {
            return ResponseEntity.ok(lawyerCareService.requestPayout(providerRepo.findById(p.getId()).orElse(p)));
        } catch (org.springframework.web.server.ResponseStatusException ex) {
            return ResponseEntity.status(ex.getStatusCode()).body(error(ex.getReason()));
        }
    }

    @PostMapping("/photos")
    @Transactional
    public ResponseEntity<Map<String, Object>> uploadPhotos(
            @RequestParam(value = "profileImage", required = false) MultipartFile profileImage,
            @RequestParam(value = "galleryPhotos", required = false) MultipartFile[] galleryPhotos,
            HttpSession session) {
        ServiceProvider p = requireProvider(session);
        if (p == null) return unauthorized();
        p = providerRepo.findById(p.getId()).orElse(p);
        try {
            if (profileImage != null && !profileImage.isEmpty()) {
                p.setProfileImageUrl(fileUploadService.saveFile(profileImage));
            }
            if (galleryPhotos != null) {
                List<String> existing = new ArrayList<>();
                if (p.getGalleryPhotos() != null && !p.getGalleryPhotos().isBlank()) {
                    existing.addAll(Arrays.asList(p.getGalleryPhotos().split(",")));
                }
                for (MultipartFile photo : galleryPhotos) {
                    if (photo != null && !photo.isEmpty()) {
                        existing.add(fileUploadService.saveFile(photo));
                    }
                }
                p.setGalleryPhotos(String.join(",", existing.stream().map(String::trim).filter(s -> !s.isEmpty()).toList()));
            }
            providerRepo.save(p);
            Map<String, Object> res = new LinkedHashMap<>();
            res.put("success", true);
            res.put("message", "Photos saved");
            res.put("profileImageUrl", p.getProfileImageUrl());
            res.put("galleryPhotos", p.getGalleryPhotos());
            return ResponseEntity.ok(res);
        } catch (Exception ex) {
            return ResponseEntity.badRequest().body(error("Upload failed: " + ex.getMessage()));
        }
    }

    @PostMapping("/bookings/{id}/notes")
    @Transactional
    public ResponseEntity<Map<String, Object>> updateNotes(
            @PathVariable Long id,
            @RequestBody Map<String, String> body,
            HttpSession session) {
        ServiceProvider p = requireProvider(session);
        if (p == null) return unauthorized();
        ProviderBooking b = bookingRepo.findById(id).orElse(null);
        if (b == null || b.getProvider() == null || !b.getProvider().getId().equals(p.getId())) {
            return badRequest("Booking not found");
        }
        b.setCoachNotes(body == null ? "" : body.getOrDefault("coachNotes", ""));
        bookingRepo.save(b);
        return ResponseEntity.ok(ok(Map.of("message", "Notes saved", "coachNotes", b.getCoachNotes())));
    }

    @PostMapping("/bookings/{id}/status")
    @Transactional
    public ResponseEntity<Map<String, Object>> updateBookingStatus(
            @PathVariable Long id,
            @RequestBody Map<String, String> body,
            HttpSession session) {
        ServiceProvider p = requireProvider(session);
        if (p == null) return unauthorized();
        if (p.getPartnerProfileStatus() != PartnerProfileStatus.APPROVED) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(error(
                    "Your profile must be approved before you can manage bookings."));
        }
        ProviderBooking b = bookingRepo.findById(id).orElse(null);
        if (b == null || b.getProvider() == null || !b.getProvider().getId().equals(p.getId())) {
            return badRequest("Booking not found");
        }
        String statusRaw = trim(body == null ? null : body.get("status")).toUpperCase(Locale.ROOT);
        if ("ACCEPTED".equals(statusRaw)) statusRaw = "CONFIRMED";
        if ("REJECTED".equals(statusRaw)) statusRaw = "CANCELLED";
        ProviderBookingStatus next;
        try {
            next = ProviderBookingStatus.valueOf(statusRaw);
        } catch (Exception e) {
            return badRequest("Invalid booking status. Use CONFIRMED, CANCELLED, or COMPLETED.");
        }
        ProviderBookingStatus current = b.getStatus() == null ? ProviderBookingStatus.PENDING : b.getStatus();
        boolean allowed = switch (current) {
            case PENDING -> next == ProviderBookingStatus.CONFIRMED || next == ProviderBookingStatus.CANCELLED;
            case CONFIRMED, PAID -> next == ProviderBookingStatus.COMPLETED || next == ProviderBookingStatus.CANCELLED;
            default -> false;
        };
        if (!allowed) {
            return badRequest("Cannot change booking from " + current.name() + " to " + next.name());
        }
        b.setStatus(next);
        bookingRepo.save(b);
        return ResponseEntity.ok(ok(Map.of("message", "Booking updated", "status", next.name())));
    }

    @PostMapping("/classes")
    @Transactional
    public ResponseEntity<Map<String, Object>> addClass(@RequestBody Map<String, Object> body, HttpSession session) {
        ServiceProvider p = requireProvider(session);
        if (p == null) return unauthorized();
        if (p.getPartnerProfileStatus() != PartnerProfileStatus.APPROVED) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(error(
                    "Your profile must be approved before you can add classes."));
        }

        String className = trim(Objects.toString(body.get("className"), ""));
        String dateTimeRaw = trim(Objects.toString(body.get("dateTime"), ""));
        if (className.isBlank() || dateTimeRaw.isBlank()) {
            return badRequest("className and dateTime are required");
        }

        LocalDateTime dt = parseDateTime(dateTimeRaw);
        if (dt == null) return badRequest("Invalid dateTime format. Use yyyy-MM-dd'T'HH:mm");
        if (dt.isBefore(LocalDateTime.now())) return badRequest("Class date/time cannot be in the past");

        double price = parseDouble(body.get("price"), 0.0);
        if (price < 0) return badRequest("Price cannot be negative");
        int seats = parseInt(body.get("availableSeats"), 0);
        if (seats <= 0) return badRequest("Seats must be greater than zero");

        ProviderClass pc = new ProviderClass();
        pc.setProvider(p);
        pc.setClassName(className);
        pc.setDescription(trim(Objects.toString(body.get("description"), "")));
        pc.setDuration(trim(Objects.toString(body.get("duration"), "")));
        pc.setDateTime(dt);
        pc.setMode(trim(Objects.toString(body.get("mode"), "Live")));
        pc.setPrice(price);
        pc.setAvailableSeats(seats);
        pc.setMeetingLink(trim(Objects.toString(body.get("meetingLink"), "")));
        ProviderCategory cat = p.getCategory();
        String categoryRaw = trim(Objects.toString(body.get("category"), ""));
        if (!categoryRaw.isBlank()) {
            ProviderCategory parsed = ProviderCategory.fromFlexible(categoryRaw);
            if (parsed != null) cat = parsed;
        }
        pc.setCategory(cat);
        classRepo.save(pc);

        return ResponseEntity.status(HttpStatus.CREATED).body(ok(Map.of(
                "message", "Class added",
                "classItem", classDto(pc)
        )));
    }

    @GetMapping("/bookings/{id}/messages")
    public ResponseEntity<Map<String, Object>> bookingMessages(@PathVariable Long id, HttpSession session) {
        ServiceProvider p = requireProvider(session);
        if (p == null) return unauthorized();
        ProviderBooking booking = bookingRepo.findById(id).orElse(null);
        if (booking == null || booking.getProvider() == null || !booking.getProvider().getId().equals(p.getId())) {
            return badRequest("Booking not found");
        }
        var items = messageRepo.findByBookingOrderByTimestampAsc(booking).stream().map(this::messageDto).toList();
        return ResponseEntity.ok(ok(Map.of("messages", items)));
    }

    @PostMapping("/bookings/{id}/messages")
    @Transactional
    public ResponseEntity<Map<String, Object>> sendBookingMessage(
            @PathVariable Long id,
            @RequestBody Map<String, Object> body,
            HttpSession session) {
        ServiceProvider p = requireProvider(session);
        if (p == null) return unauthorized();
        ProviderBooking booking = bookingRepo.findById(id).orElse(null);
        if (booking == null || booking.getProvider() == null || !booking.getProvider().getId().equals(p.getId())) {
            return badRequest("Booking not found");
        }
        if (booking.getStatus() != ProviderBookingStatus.CONFIRMED
                && booking.getStatus() != ProviderBookingStatus.PAID) {
            return badRequest("Chat is available after you confirm this booking");
        }
        String content = trim(Objects.toString(body == null ? null : body.get("content"), ""));
        if (content.isBlank()) return badRequest("Message cannot be empty");
        MarketplaceMessage msg = new MarketplaceMessage(booking, content, "PROVIDER");
        messageRepo.save(msg);
        return ResponseEntity.ok(ok(Map.of("message", "Sent", "item", messageDto(msg))));
    }

    private ServiceProvider requireProvider(HttpSession session) {
        Object p = session == null ? null : session.getAttribute("loggedProvider");
        return p instanceof ServiceProvider ? (ServiceProvider) p : null;
    }

    private ResponseEntity<Map<String, Object>> unauthorized() {
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(error("Provider login required"));
    }

    private ResponseEntity<Map<String, Object>> badRequest(String error) {
        return ResponseEntity.badRequest().body(error(error));
    }

    private static Map<String, Object> error(String msg) {
        Map<String, Object> out = new LinkedHashMap<>();
        out.put("success", false);
        out.put("error", msg);
        return out;
    }

    private static Map<String, Object> ok(Map<String, Object> data) {
        Map<String, Object> out = new LinkedHashMap<>();
        out.put("success", true);
        out.putAll(data);
        return out;
    }

    private static String trim(String value) {
        return value == null ? "" : value.trim();
    }

    private static String str(Map<String, Object> body, String key) {
        if (body == null || body.get(key) == null) return "";
        return String.valueOf(body.get(key)).trim();
    }

    private static double parseDouble(Object value, double fallback) {
        if (value == null) return fallback;
        try {
            return Double.parseDouble(value.toString());
        } catch (Exception e) {
            return fallback;
        }
    }

    private static int parseInt(Object value, int fallback) {
        if (value == null) return fallback;
        try {
            return Integer.parseInt(value.toString());
        } catch (Exception e) {
            return fallback;
        }
    }

    private static LocalDateTime parseDateTime(String raw) {
        if (raw == null || raw.isBlank()) return null;
        try {
            return LocalDateTime.parse(raw, DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm"));
        } catch (Exception ignored) {
        }
        try {
            return LocalDateTime.parse(raw);
        } catch (Exception ignored) {
        }
        return null;
    }

    private Map<String, Object> providerSummary(ServiceProvider p) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", p.getId());
        m.put("fullName", p.getFullName());
        m.put("email", p.getEmail());
        m.put("phone", p.getPhone());
        m.put("category", p.getCategory() == null ? null : p.getCategory().name());
        m.put("description", p.getDescription());
        m.put("locationText", p.getLocationText());
        m.put("rating", p.getRating());
        m.put("verificationStatus", p.getVerificationStatus() == null ? null : p.getVerificationStatus().name());
        m.put("partnerProfileStatus", p.getPartnerProfileStatus() == null
                ? null : p.getPartnerProfileStatus().name());
        m.put("partnerProfileStatusLabel", ServiceProviderProfileService.statusLabel(p.getPartnerProfileStatus()));
        m.put("profileCompletionPct", p.getProfileCompletionPct() == null ? 0 : p.getProfileCompletionPct());
        m.put("canCreateClass", p.getPartnerProfileStatus() == PartnerProfileStatus.APPROVED);
        m.put("rejectionReason", p.getRejectionReason());
        m.put("changesRequestedNote", p.getChangesRequestedNote());
        m.put("missingItems", providerProfileService.missingItems(p));
        m.put("canSubmitForVerification",
                providerProfileService.isReadyForVerification(p)
                        && p.getPartnerProfileStatus() != PartnerProfileStatus.PENDING_ADMIN_APPROVAL);
        ServiceProviderProfileService.putLawyerFields(m, p);
        return m;
    }

    private Map<String, Object> messageDto(MarketplaceMessage msg) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", msg.getId());
        m.put("content", msg.getContent());
        m.put("senderRole", msg.getSenderRole());
        m.put("timestamp", msg.getTimestamp() == null ? null : msg.getTimestamp().getTime());
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
        return m;
    }
}
