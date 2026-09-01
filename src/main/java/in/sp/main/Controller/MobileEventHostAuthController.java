package in.sp.main.Controller;

import in.sp.main.Config.JwtUtil;
import in.sp.main.Entities.*;
import in.sp.main.Repository.EventHostRepository;
import in.sp.main.Repository.WomenEventRegistrationRepository;
import in.sp.main.Repository.WomenEventRepository;
import in.sp.main.Service.EventHostProfileService;
import in.sp.main.Service.EventHostRegistrationService;
import in.sp.main.Service.EventsCareService;
import in.sp.main.Service.FileUploadService;
import in.sp.main.Service.WomenEventBookingService;
import in.sp.main.Service.WomenEventLifecycleService;
import in.sp.main.Service.PartnerLifecycleSupport;
import in.sp.main.Service.PasswordService;
import in.sp.main.Util.MobileValidation;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Objects;
import java.util.Optional;

@RestController
@RequestMapping("/api/women-events/host")
public class MobileEventHostAuthController {

    @Autowired
    private EventHostRepository hostRepo;
    @Autowired
    private WomenEventRepository eventRepo;
    @Autowired
    private WomenEventRegistrationRepository registrationRepo;
    @Autowired
    private PasswordService passwordService;
    @Autowired
    private JwtUtil jwtUtil;
    @Autowired
    private EventHostRegistrationService hostRegistrationService;
    @Autowired
    private EventHostProfileService hostProfileService;
    @Autowired
    private EventsCareService eventsCareService;
    @Autowired
    private FileUploadService fileUploadService;
    @Autowired
    private WomenEventLifecycleService lifecycleService;
    @Autowired
    private WomenEventBookingService bookingService;

    @PostMapping("/otp/send-email")
    public ResponseEntity<Map<String, Object>> sendEmailOtp(@RequestBody Map<String, String> body) {
        try {
            hostRegistrationService.sendRegistrationOtp(body == null ? null : body.get("email"));
            int mins = hostRegistrationService.getOtpExpirationMinutes();
            int cooldown = hostRegistrationService.getOtpResendCooldownSeconds();
            Map<String, Object> res = new LinkedHashMap<>();
            res.put("success", true);
            res.put("expirationMinutes", mins);
            res.put("resendCooldownSeconds", cooldown);
            res.put("message", "OTP sent to your email. Valid for " + mins
                    + " minutes. You can resend after " + cooldown + " seconds.");
            return ResponseEntity.ok(res);
        } catch (org.springframework.web.server.ResponseStatusException ex) {
            return ResponseEntity.status(ex.getStatusCode()).body(error(ex.getReason()));
        }
    }

    @PostMapping("/otp/verify-email")
    public ResponseEntity<Map<String, Object>> verifyEmailOtp(@RequestBody Map<String, String> body) {
        try {
            hostRegistrationService.verifyRegistrationOtp(
                    body == null ? null : body.get("email"),
                    body == null ? null : body.get("otp"));
            Map<String, Object> res = new LinkedHashMap<>();
            res.put("success", true);
            res.put("message", "Email verified. OTP was valid for "
                    + hostRegistrationService.getOtpExpirationMinutes() + " minutes.");
            return ResponseEntity.ok(res);
        } catch (org.springframework.web.server.ResponseStatusException ex) {
            return ResponseEntity.status(ex.getStatusCode()).body(error(ex.getReason()));
        }
    }

    @PostMapping("/register-quick")
    public ResponseEntity<Map<String, Object>> registerQuick(@RequestBody Map<String, Object> body, HttpSession session) {
        try {
            boolean accepted = body != null && (
                    Boolean.TRUE.equals(body.get("acceptedTerms"))
                            || "true".equalsIgnoreCase(String.valueOf(body.get("acceptedTerms"))));
            EventHost host = hostRegistrationService.registerQuick(
                    str(body, "fullName"),
                    str(body, "email"),
                    str(body, "phone"),
                    str(body, "password"),
                    str(body, "confirmPassword"),
                    str(body, "emailOtp"),
                    accepted);
            session.setAttribute("pendingHostLoginEmail", host.getEmail());
            Map<String, Object> res = new LinkedHashMap<>();
            res.put("success", true);
            res.put("message", "Account created. Sign in to complete your host profile.");
            res.put("hostId", host.getId());
            res.put("email", host.getEmail());
            res.put("loginPath", "/women-events/host/login");
            res.put("partnerProfileStatus", host.getPartnerProfileStatus() == null
                    ? null : host.getPartnerProfileStatus().name());
            res.put("profileCompletionPct", host.getProfileCompletionPct());
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
        String organizerName = trim(body == null ? null : body.get("organizerName"));
        String organizerType = trim(body == null ? null : body.get("organizerType"));
        String hostContact = trim(body == null ? null : body.get("hostContact"));
        String hostBio = sanitize(trim(body == null ? null : body.get("hostBio")));
        String city = trim(body == null ? null : body.get("city"));
        String state = trim(body == null ? null : body.get("state"));
        String officeAddress = sanitize(trim(body == null ? null : body.get("officeAddress")));
        String website = trim(body == null ? null : body.get("website"));
        String instagram = trim(body == null ? null : body.get("instagram"));
        String facebook = trim(body == null ? null : body.get("facebook"));
        String linkedin = trim(body == null ? null : body.get("linkedin"));
        String eventCategories = trim(body == null ? null : body.get("eventCategories"));
        String logoPath = trim(body == null ? null : body.get("logoPath"));
        String documentPath = trim(body == null ? null : body.get("documentPath"));
        String portfolioPath = trim(body == null ? null : body.get("portfolioPath"));
        Integer yearsExperience = parseIntOrNull(body == null ? null : body.get("yearsExperience"));
        Integer expectedParticipants = parseIntOrNull(body == null ? null : body.get("expectedParticipants"));

        if (fullName.isBlank() || organizerName.isBlank()) {
            return badRequest("fullName and organizerName are required");
        }
        String emailErr = MobileValidation.requireEmail(email);
        if (emailErr != null) return badRequest(emailErr);
        String phoneErr = MobileValidation.requirePhone(phone, true);
        if (phoneErr != null) return badRequest(phoneErr);
        String passErr = MobileValidation.requirePassword(password);
        if (passErr != null) return badRequest(passErr);
        if (!confirmPassword.isBlank()) {
            String confirmErr = MobileValidation.requireConfirm(password, confirmPassword);
            if (confirmErr != null) return badRequest(confirmErr);
        }
        if (hostRepo.findByEmail(email).isPresent()) {
            return ResponseEntity.status(HttpStatus.CONFLICT).body(error("Email already registered"));
        }

        EventHost host = new EventHost();
        host.setFullName(fullName);
        host.setEmail(email);
        host.setPhone(phone);
        host.setPassword(passwordService.encode(password));
        host.setOrganizerName(organizerName);
        host.setOrganizerType(organizerType.isBlank() ? null : organizerType);
        host.setHostContact(hostContact.isBlank() ? phone : hostContact);
        host.setHostBio(hostBio.isBlank() ? null : hostBio);
        host.setCity(city.isBlank() ? null : city);
        host.setState(state.isBlank() ? null : state);
        host.setOfficeAddress(officeAddress.isBlank() ? null : officeAddress);
        host.setWebsite(website.isBlank() ? null : website);
        host.setInstagram(instagram.isBlank() ? null : instagram);
        host.setFacebook(facebook.isBlank() ? null : facebook);
        host.setLinkedin(linkedin.isBlank() ? null : linkedin);
        host.setEventCategories(eventCategories.isBlank() ? null : eventCategories);
        host.setYearsExperience(yearsExperience);
        host.setExpectedParticipants(expectedParticipants);
        host.setLogoPath(logoPath.isBlank() ? "mobile-pending" : logoPath);
        host.setDocumentPath(documentPath.isBlank() ? "mobile-pending" : documentPath);
        host.setPortfolioPath(portfolioPath.isBlank() ? "mobile-pending" : portfolioPath);
        hostProfileService.setLifecycleStatus(host, PartnerProfileStatus.REGISTERED);
        hostRepo.save(host);
        hostProfileService.setLifecycleStatus(host, PartnerProfileStatus.PROFILE_INCOMPLETE);
        hostProfileService.refreshCompletion(host);

        Map<String, Object> res = new LinkedHashMap<>();
        res.put("success", true);
        res.put("message", "Registration submitted. Complete your profile and await admin verification.");
        res.put("hostId", host.getId());
        res.put("status", "PENDING");
        res.put("partnerProfileStatus", host.getPartnerProfileStatus() == null
                ? null : host.getPartnerProfileStatus().name());
        return ResponseEntity.status(HttpStatus.CREATED).body(res);
    }

    @PostMapping("/login")
    public ResponseEntity<Map<String, Object>> login(@RequestBody Map<String, String> body, HttpSession session) {
        String email = trim(body == null ? null : body.get("email")).toLowerCase(Locale.ROOT);
        String password = body == null ? "" : body.getOrDefault("password", "");
        if (email.isBlank() || password.isBlank()) return badRequest("Email and password are required");

        Optional<EventHost> opt = hostRepo.findByEmail(email);
        if (opt.isEmpty()) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(error("Event host not found"));
        }
        EventHost host = opt.get();
        boolean ok = passwordService.matchesAndUpgrade(password, host.getPassword(), hashed -> {
            host.setPassword(hashed);
            hostRepo.save(host);
        });
        if (!ok) return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(error("Invalid password"));

        if (host.getPartnerProfileStatus() == PartnerProfileStatus.SUSPENDED) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN)
                    .body(error("Your event host account has been suspended"));
        }

        PartnerProfileStatus status = host.getPartnerProfileStatus();
        if (status == null) {
            if (host.getVerificationStatus() == VerificationStatus.VERIFIED) {
                hostProfileService.setLifecycleStatus(host, PartnerProfileStatus.APPROVED);
            } else if (host.getVerificationStatus() == VerificationStatus.REJECTED) {
                hostProfileService.setLifecycleStatus(host, PartnerProfileStatus.REJECTED);
            } else {
                hostProfileService.setLifecycleStatus(host, PartnerProfileStatus.PROFILE_INCOMPLETE);
            }
            hostProfileService.refreshCompletion(host);
        } else {
            hostProfileService.refreshCompletion(host);
        }

        session.setAttribute("loggedHost", host);
        String token = jwtUtil.generateToken(host.getEmail(), "HOST");
        Map<String, Object> res = new LinkedHashMap<>();
        res.put("success", true);
        res.put("token", token);
        res.put("tokenType", "Bearer");
        res.put("role", "HOST");
        res.put("host", hostSummary(host));
        res.put("needsProfileCompletion",
                PartnerLifecycleSupport.needsProfileCompletion(host.getPartnerProfileStatus()));
        res.put("canSubmitForVerification",
                hostProfileService.isReadyForVerification(host)
                        && host.getPartnerProfileStatus() != PartnerProfileStatus.PENDING_ADMIN_APPROVAL);
        return ResponseEntity.ok(res);
    }

    @GetMapping("/profile")
    public ResponseEntity<Map<String, Object>> getProfile(HttpSession session) {
        EventHost host = requireHost(session);
        if (host == null) return unauthorized();
        host = hostRepo.findById(host.getId()).orElse(host);
        Map<String, Object> res = new LinkedHashMap<>();
        res.put("success", true);
        res.putAll(hostProfileService.profilePayload(host));
        return ResponseEntity.ok(res);
    }

    @PutMapping("/profile")
    @Transactional
    public ResponseEntity<Map<String, Object>> updateProfile(
            @RequestBody Map<String, Object> body,
            HttpSession session) {
        EventHost host = requireHost(session);
        if (host == null) return unauthorized();
        host = hostRepo.findById(host.getId()).orElse(host);
        hostProfileService.applyExtraFields(host, body);
        hostProfileService.refreshCompletion(host);
        Map<String, Object> res = new LinkedHashMap<>();
        res.put("success", true);
        res.put("message", "Profile saved");
        res.putAll(hostProfileService.profilePayload(host));
        return ResponseEntity.ok(res);
    }

    @PostMapping("/submit-verification")
    public ResponseEntity<Map<String, Object>> submitVerification(HttpSession session) {
        EventHost host = requireHost(session);
        if (host == null) return unauthorized();
        try {
            EventHost h = hostRepo.findById(host.getId()).orElse(host);
            hostRegistrationService.submitForVerification(h);
            Map<String, Object> res = new LinkedHashMap<>();
            res.put("success", true);
            res.put("message", "Submitted for admin verification");
            res.putAll(hostProfileService.profilePayload(h));
            return ResponseEntity.ok(res);
        } catch (org.springframework.web.server.ResponseStatusException ex) {
            return ResponseEntity.status(ex.getStatusCode()).body(error(ex.getReason()));
        }
    }

    @GetMapping("/me")
    public ResponseEntity<Map<String, Object>> me(HttpSession session) {
        EventHost host = requireHost(session);
        if (host == null) return unauthorized();
        host = hostRepo.findById(host.getId()).orElse(host);

        List<WomenEvent> myEvents = eventRepo.findByOrganizerOrderByCreatedAtDesc(host);
        List<Map<String, Object>> events = myEvents.stream().map(e -> {
            Map<String, Object> m = eventDto(e);
            m.put("registrationCount", registrationRepo.countActiveByEvent(e));
            return m;
        }).toList();

        long totalRegistrations = events.stream()
                .mapToLong(m -> ((Number) m.get("registrationCount")).longValue())
                .sum();

        Map<String, Object> data = new LinkedHashMap<>();
        data.put("host", hostSummary(host));
        data.put("events", events);
        data.put("totalEvents", events.size());
        data.put("totalRegistrations", totalRegistrations);
        data.put("payoutBalance", host.getPayoutBalance());
        data.put("upiId", host.getUpiId());
        data.put("rating", host.getRating());
        data.put("reviewCount", host.getReviewCount());
        data.put("cancelPolicy", EventsCareService.CANCEL_POLICY);
        return ResponseEntity.ok(ok(data));
    }

    @PostMapping("/events")
    @Transactional
    public ResponseEntity<Map<String, Object>> createEvent(@RequestBody Map<String, Object> body, HttpSession session) {
        EventHost host = requireHost(session);
        if (host == null) return unauthorized();
        if (!EventHostProfileService.isApproved(host)) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(error("Host must be verified"));
        }

        String name = trim(Objects.toString(body.get("name"), ""));
        String categoryRaw = trim(Objects.toString(body.get("category"), ""));
        String description = trim(Objects.toString(body.get("description"), ""));
        String eventDateRaw = trim(Objects.toString(body.get("eventDate"), ""));
        String venue = trim(Objects.toString(body.get("venue"), ""));
        String city = trim(Objects.toString(body.get("city"), ""));
        String contactInfo = trim(Objects.toString(body.get("contactInfo"), ""));
        String organizerName = trim(Objects.toString(body.get("organizerName"), ""));
        String organizerType = trim(Objects.toString(body.get("organizerType"), ""));

        if (name.isBlank() || categoryRaw.isBlank() || eventDateRaw.isBlank() || venue.isBlank() || city.isBlank()) {
            return badRequest("name, category, eventDate, venue and city are required");
        }

        WomenEventCategory category = WomenEventCategory.fromFlexible(categoryRaw);
        if (category == null) {
            return badRequest("Invalid category: " + categoryRaw
                    + ". Use Health & Wellness, Entrepreneurship & Career, Fitness & Sports, Education & Skills, Social & Community, or Safety & Awareness.");
        }

        LocalDate eventDate;
        try {
            eventDate = LocalDate.parse(eventDateRaw);
        } catch (Exception e) {
            return badRequest("Invalid eventDate (use yyyy-MM-dd)");
        }

        WomenEvent event = new WomenEvent();
        event.setName(name);
        event.setCategory(category);
        event.setDescription(sanitize(description).isBlank() ? null : sanitize(description));
        event.setEventDate(eventDate);
        String eventTimeRaw = trim(Objects.toString(body.get("eventTime"), ""));
        if (!eventTimeRaw.isBlank()) {
            try {
                event.setEventTime(LocalTime.parse(eventTimeRaw));
            } catch (Exception e) {
                return badRequest("Invalid eventTime (use HH:mm or HH:mm:ss)");
            }
        }
        event.setVenue(venue);
        event.setCity(city);
        event.setEntryFee(parseDouble(body.get("entryFee"), 0.0));
        Object maxPart = body.get("maxParticipants");
        if (maxPart != null && !trim(Objects.toString(maxPart, "")).isBlank()) {
            int max = parseInt(maxPart, 0);
            event.setMaxParticipants(max > 0 ? max : null);
        } else {
            event.setMaxParticipants(null);
        }
        event.setContactInfo(contactInfo.isBlank() ? host.getHostContact() : contactInfo);
        event.setOrganizerName(organizerName.isBlank() ? host.getOrganizerName() : organizerName);
        event.setOrganizerType(organizerType.isBlank() ? host.getOrganizerType() : organizerType);
        event.setOrganizer(host);
        event.setMapsLocation(trim(Objects.toString(body.get("mapsLocation"), "")));
        boolean virtual = Boolean.parseBoolean(Objects.toString(body.get("virtual"), "false"));
        event.setVirtual(virtual);
        event.setStreamLink(trim(Objects.toString(body.get("streamLink"), "")));
        event.setBoothFee(parseDouble(body.get("boothFee"), 0.0));
        boolean draft = Boolean.parseBoolean(Objects.toString(body.get("draft"), "false"))
                || Boolean.parseBoolean(Objects.toString(body.get("saveDraft"), "false"));
        lifecycleService.applyCreateStatus(event, draft);
        if (body.get("eventFormat") != null) {
            event.setEventFormat(EventFormat.fromFlexible(Objects.toString(body.get("eventFormat"), "OFFLINE")));
            event.setVirtual(event.getEventFormat() == EventFormat.ONLINE || event.getEventFormat() == EventFormat.HYBRID);
        }
        if (body.get("shortDescription") != null) event.setShortDescription(trim(Objects.toString(body.get("shortDescription"), "")));
        if (body.get("cancellationPolicy") != null) event.setCancellationPolicy(trim(Objects.toString(body.get("cancellationPolicy"), "")));
        if (body.get("refundPolicy") != null) event.setRefundPolicy(trim(Objects.toString(body.get("refundPolicy"), "")));
        event.setTimezone("Asia/Kolkata");
        if (event.getEventDate() != null) {
            LocalTime st = event.getEventTime() == null ? LocalTime.of(10, 0) : event.getEventTime();
            event.setStartsAt(java.time.LocalDateTime.of(event.getEventDate(), st));
            event.setRegistrationClosesAt(event.getStartsAt());
        }
        eventRepo.save(event);

        Map<String, Object> data = new LinkedHashMap<>();
        data.put("message", draft ? "Draft saved" : "Event submitted for admin approval");
        data.put("event", eventDto(event));
        return ResponseEntity.status(HttpStatus.CREATED).body(ok(data));
    }

    @GetMapping("/organizer-types")
    public ResponseEntity<Map<String, Object>> organizerTypes() {
        return ResponseEntity.ok(ok(Map.of("organizerTypes", List.of(
                "NGO", "Company", "Educational Institution", "Government Department",
                "Community Organization", "Women Self Help Group", "Startup",
                "Fitness Organization", "Healthcare Organization", "Event Management Company",
                "Charity Foundation", "Sports Club", "Youth Organization"
        ))));
    }

    @PutMapping("/events/{id}")
    @Transactional
    public ResponseEntity<Map<String, Object>> updateEvent(
            @PathVariable Long id,
            @RequestBody Map<String, Object> body,
            HttpSession session) {
        EventHost host = requireHost(session);
        if (host == null) return unauthorized();
        if (!EventHostProfileService.isApproved(host)) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(error("Host must be verified"));
        }
        WomenEvent event = eventRepo.findById(id).orElse(null);
        if (event == null || event.getOrganizer() == null || !event.getOrganizer().getId().equals(host.getId())) {
            return badRequest("Event not found");
        }
        if ("CANCELLED".equalsIgnoreCase(event.getStatus()) || "CANCELLED_BY_HOST".equalsIgnoreCase(event.getStatus())) {
            return badRequest("Cancelled events cannot be edited");
        }

        if (body.get("name") != null) {
            String name = trim(Objects.toString(body.get("name"), ""));
            if (name.isBlank()) return badRequest("name is required");
            event.setName(name);
        }
        if (body.get("category") != null) {
            WomenEventCategory category = WomenEventCategory.fromFlexible(Objects.toString(body.get("category"), ""));
            if (category == null) return badRequest("Invalid category");
            event.setCategory(category);
        }
        if (body.get("description") != null) {
            String description = sanitize(trim(Objects.toString(body.get("description"), "")));
            event.setDescription(description.isBlank() ? null : description);
        }
        if (body.get("eventDate") != null) {
            try {
                event.setEventDate(LocalDate.parse(trim(Objects.toString(body.get("eventDate"), ""))));
            } catch (Exception e) {
                return badRequest("Invalid eventDate (use yyyy-MM-dd)");
            }
        }
        if (body.get("eventTime") != null) {
            String eventTimeRaw = trim(Objects.toString(body.get("eventTime"), ""));
            if (eventTimeRaw.isBlank()) {
                event.setEventTime(null);
            } else {
                try {
                    event.setEventTime(LocalTime.parse(eventTimeRaw));
                } catch (Exception e) {
                    return badRequest("Invalid eventTime (use HH:mm or HH:mm:ss)");
                }
            }
        }
        if (body.get("venue") != null) {
            String venue = trim(Objects.toString(body.get("venue"), ""));
            if (venue.isBlank()) return badRequest("venue is required");
            event.setVenue(venue);
        }
        if (body.get("city") != null) {
            String city = trim(Objects.toString(body.get("city"), ""));
            if (city.isBlank()) return badRequest("city is required");
            event.setCity(city);
        }
        if (body.containsKey("entryFee")) {
            event.setEntryFee(parseDouble(body.get("entryFee"), 0.0));
        }
        if (body.containsKey("maxParticipants")) {
            Object maxPart = body.get("maxParticipants");
            if (maxPart == null || trim(Objects.toString(maxPart, "")).isBlank()) {
                event.setMaxParticipants(null);
            } else {
                int max = parseInt(maxPart, 0);
                event.setMaxParticipants(max > 0 ? max : null);
            }
        }
        if (body.get("contactInfo") != null) {
            event.setContactInfo(trim(Objects.toString(body.get("contactInfo"), "")));
        }
        if (body.get("mapsLocation") != null) {
            event.setMapsLocation(trim(Objects.toString(body.get("mapsLocation"), "")));
        }
        if (body.containsKey("virtual")) {
            event.setVirtual(Boolean.parseBoolean(Objects.toString(body.get("virtual"), "false")));
        }
        if (body.get("streamLink") != null) {
            event.setStreamLink(trim(Objects.toString(body.get("streamLink"), "")));
        }

        if ("APPROVED".equalsIgnoreCase(event.getStatus())) {
            event.setStatus("PENDING");
        }
        eventRepo.save(event);

        Map<String, Object> data = new LinkedHashMap<>();
        data.put("message", "PENDING".equalsIgnoreCase(event.getStatus())
                ? "Event updated and sent for admin approval"
                : "Event updated");
        data.put("event", eventDto(event));
        return ResponseEntity.ok(ok(data));
    }

    @PostMapping("/events/{id}/cancel")
    @Transactional
    public ResponseEntity<Map<String, Object>> cancelEvent(@PathVariable Long id, HttpSession session) {
        EventHost host = requireHost(session);
        if (host == null) return unauthorized();
        WomenEvent event = eventRepo.findById(id).orElse(null);
        if (event == null || event.getOrganizer() == null || !event.getOrganizer().getId().equals(host.getId())) {
            return badRequest("Event not found");
        }
        if ("CANCELLED".equalsIgnoreCase(event.getStatus()) || "CANCELLED_BY_HOST".equalsIgnoreCase(event.getStatus())) {
            return badRequest("Event already cancelled");
        }
        if (!eventsCareService.canCancelHostEvent(event)) {
            return badRequest(EventsCareService.CANCEL_POLICY);
        }
        event.setStatus("CANCELLED_BY_HOST");
        lifecycleService.transition(event, EventLifecycleStatus.CANCELLED,
                "EVENT_HOST", host.getId(), host.getEmail(), "Cancelled by host");
        return ResponseEntity.ok(ok(Map.of(
                "message", "Event cancelled",
                "event", eventDto(event)
        )));
    }

    @PostMapping("/events/{id}/submit")
    @Transactional
    public ResponseEntity<Map<String, Object>> submitEvent(@PathVariable Long id, HttpSession session) {
        EventHost host = requireHost(session);
        if (host == null) return unauthorized();
        if (!EventHostProfileService.isApproved(host)) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(error("Host must be verified"));
        }
        WomenEvent event = eventRepo.findById(id).orElse(null);
        if (event == null || event.getOrganizer() == null || !event.getOrganizer().getId().equals(host.getId())) {
            return badRequest("Event not found");
        }
        lifecycleService.transition(event, EventLifecycleStatus.SUBMITTED,
                "EVENT_HOST", host.getId(), host.getEmail(), "Submitted for approval");
        return ResponseEntity.ok(ok(Map.of("message", "Event submitted for admin approval", "event", eventDto(event))));
    }

    @PostMapping("/events/{id}/checkin")
    @Transactional
    public ResponseEntity<Map<String, Object>> checkIn(
            @PathVariable Long id,
            @RequestBody Map<String, Object> body,
            HttpSession session) {
        EventHost host = requireHost(session);
        if (host == null) return unauthorized();
        WomenEvent event = eventRepo.findById(id).orElse(null);
        if (event == null || event.getOrganizer() == null || !event.getOrganizer().getId().equals(host.getId())) {
            return badRequest("Event not found");
        }
        String ticketCode = trim(Objects.toString(body == null ? null : body.get("ticketCode"), ""));
        if (ticketCode.isBlank() && body != null && body.get("qrToken") != null) {
            ticketCode = trim(Objects.toString(body.get("qrToken"), ""));
        }
        if (ticketCode.isBlank()) return badRequest("ticketCode is required");
        try {
            WomenEventRegistration reg = bookingService.checkIn(event, ticketCode);
            Map<String, Object> attendee = new LinkedHashMap<>();
            attendee.put("id", reg.getId());
            attendee.put("ticketCode", reg.getTicketCode());
            attendee.put("status", reg.getStatus());
            attendee.put("checkedIn", true);
            attendee.put("paid", reg.isPaid());
            if (reg.getUser() != null) {
                attendee.put("userName", reg.getUser().getFullName());
                attendee.put("userEmail", reg.getUser().getEmail());
            }
            return ResponseEntity.ok(ok(Map.of(
                    "message", "Checked in successfully",
                    "registration", attendee
            )));
        } catch (org.springframework.web.server.ResponseStatusException ex) {
            return ResponseEntity.status(ex.getStatusCode()).body(error(ex.getReason()));
        }
    }

    @GetMapping("/events/{id}/registrations")
    public ResponseEntity<Map<String, Object>> eventRegistrations(@PathVariable Long id, HttpSession session) {
        EventHost host = requireHost(session);
        if (host == null) return unauthorized();

        WomenEvent event = eventRepo.findById(id).orElse(null);
        if (event == null || event.getOrganizer() == null || !event.getOrganizer().getId().equals(host.getId())) {
            return badRequest("Event not found");
        }

        List<Map<String, Object>> registrations = registrationRepo.findByEvent(event).stream().map(r -> {
            Map<String, Object> m = new LinkedHashMap<>();
            m.put("id", r.getId());
            m.put("status", r.getStatus());
            m.put("role", r.getRole());
            m.put("ticketCode", r.getTicketCode());
            m.put("checkedIn", r.isCheckedIn());
            m.put("paid", r.isPaid());
            m.put("amountPaid", r.getAmountPaid());
            m.put("coachNotes", r.getCoachNotes());
            m.put("registeredAt", r.getRegisteredAt() == null ? null : r.getRegisteredAt().toString());
            if (r.getUser() != null) {
                m.put("userName", r.getUser().getFullName());
                m.put("userEmail", r.getUser().getEmail());
                m.put("userPhone", r.getUser().getPhoneNumber());
            }
            return m;
        }).toList();

        Map<String, Object> data = new LinkedHashMap<>();
        data.put("event", eventDto(event));
        data.put("registrations", registrations);
        data.put("count", registrations.size());
        return ResponseEntity.ok(ok(data));
    }

    @PostMapping("/payout/request")
    @Transactional
    public ResponseEntity<Map<String, Object>> requestPayout(HttpSession session) {
        EventHost host = requireHost(session);
        if (host == null) return unauthorized();
        try {
            return ResponseEntity.ok(eventsCareService.requestPayout(hostRepo.findById(host.getId()).orElse(host)));
        } catch (org.springframework.web.server.ResponseStatusException ex) {
            return ResponseEntity.status(ex.getStatusCode()).body(error(ex.getReason()));
        }
    }

    @PostMapping("/events/{eventId}/registrations/{id}/notes")
    @Transactional
    public ResponseEntity<Map<String, Object>> updateNotes(
            @PathVariable Long eventId,
            @PathVariable Long id,
            @RequestBody Map<String, Object> body,
            HttpSession session) {
        EventHost host = requireHost(session);
        if (host == null) return unauthorized();
        WomenEventRegistration r = registrationRepo.findById(id).orElse(null);
        if (r == null || r.getEvent() == null || r.getEvent().getOrganizer() == null
                || !r.getEvent().getOrganizer().getId().equals(host.getId())
                || !r.getEvent().getId().equals(eventId)) {
            return badRequest("Registration not found");
        }
        r.setCoachNotes(body == null || body.get("coachNotes") == null ? "" : String.valueOf(body.get("coachNotes")));
        registrationRepo.save(r);
        return ResponseEntity.ok(ok(Map.of("message", "Notes saved")));
    }

    @PostMapping(value = "/photos", consumes = org.springframework.http.MediaType.MULTIPART_FORM_DATA_VALUE)
    @Transactional
    public ResponseEntity<Map<String, Object>> uploadPhotos(
            @RequestParam(value = "profileImage", required = false) org.springframework.web.multipart.MultipartFile profileImage,
            @RequestParam(value = "galleryPhotos", required = false) org.springframework.web.multipart.MultipartFile galleryPhotos,
            HttpSession session) {
        EventHost host = requireHost(session);
        if (host == null) return unauthorized();
        host = hostRepo.findById(host.getId()).orElse(host);
        try {
            if (profileImage != null && !profileImage.isEmpty()) {
                host.setLogoPath(fileUploadService.saveFile(profileImage));
            }
            if (galleryPhotos != null && !galleryPhotos.isEmpty()) {
                String path = fileUploadService.saveFile(galleryPhotos);
                String existing = host.getGalleryPhotos();
                host.setGalleryPhotos(existing == null || existing.isBlank() ? path : existing + "," + path);
            }
            hostRepo.save(host);
            Map<String, Object> res = new LinkedHashMap<>();
            res.put("success", true);
            res.put("message", "Photos saved");
            res.putAll(hostProfileService.profilePayload(host));
            return ResponseEntity.ok(res);
        } catch (Exception ex) {
            return badRequest(ex.getMessage() == null ? "Upload failed" : ex.getMessage());
        }
    }

    private EventHost requireHost(HttpSession session) {
        Object h = session == null ? null : session.getAttribute("loggedHost");
        return h instanceof EventHost ? (EventHost) h : null;
    }

    private ResponseEntity<Map<String, Object>> unauthorized() {
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(error("Host login required"));
    }

    private ResponseEntity<Map<String, Object>> badRequest(String msg) {
        return ResponseEntity.badRequest().body(error(msg));
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

    private static String sanitize(String v) {
        if (v == null) return "";
        return v.replace("₹", "Rs ").replace("\u20B9", "Rs ");
    }

    private static Integer parseIntOrNull(String value) {
        if (value == null || value.isBlank()) return null;
        try {
            return Integer.parseInt(value.replaceAll("[^0-9-]", ""));
        } catch (Exception e) {
            return null;
        }
    }

    private Map<String, Object> hostSummary(EventHost h) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", h.getId());
        m.put("fullName", h.getFullName());
        m.put("email", h.getEmail());
        m.put("phone", h.getPhone());
        m.put("organizerName", h.getOrganizerName());
        m.put("organizerType", h.getOrganizerType());
        m.put("hostContact", h.getHostContact());
        m.put("hostBio", h.getHostBio());
        m.put("city", h.getCity());
        m.put("state", h.getState());
        m.put("officeAddress", h.getOfficeAddress());
        m.put("website", h.getWebsite());
        m.put("instagram", h.getInstagram());
        m.put("facebook", h.getFacebook());
        m.put("linkedin", h.getLinkedin());
        m.put("eventCategories", h.getEventCategories());
        m.put("yearsExperience", h.getYearsExperience());
        m.put("expectedParticipants", h.getExpectedParticipants());
        m.put("verificationStatus", h.getVerificationStatus() == null ? null : h.getVerificationStatus().name());
        m.put("partnerProfileStatus", h.getPartnerProfileStatus() == null
                ? null : h.getPartnerProfileStatus().name());
        m.put("partnerProfileStatusLabel", EventHostProfileService.statusLabel(h.getPartnerProfileStatus()));
        m.put("profileCompletionPct", h.getProfileCompletionPct() == null ? 0 : h.getProfileCompletionPct());
        m.put("rejectionReason", h.getRejectionReason());
        m.put("changesRequestedNote", h.getChangesRequestedNote());
        m.put("approved", EventHostProfileService.isApproved(h));
        EventHostProfileService.putExtra(m, h);
        return m;
    }

    private Map<String, Object> eventDto(WomenEvent e) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", e.getId());
        m.put("name", e.getName());
        m.put("category", e.getCategory() == null ? null : e.getCategory().name());
        m.put("categoryLabel", e.getCategory() == null ? null : e.getCategory().getDisplayName());
        m.put("description", e.getDescription());
        m.put("eventDate", e.getEventDate() == null ? null : e.getEventDate().toString());
        m.put("eventTime", e.getEventTime() == null ? null : e.getEventTime().toString());
        m.put("venue", e.getVenue());
        m.put("city", e.getCity());
        m.put("entryFee", e.getEntryFee());
        m.put("free", e.isFree());
        m.put("maxParticipants", e.getMaxParticipants());
        m.put("capacity", e.getMaxParticipants());
        m.put("contactInfo", e.getContactInfo());
        m.put("organizerName", e.getOrganizerName());
        m.put("organizerType", e.getOrganizerType());
        m.put("status", e.getStatus());
        m.put("virtual", e.isVirtual());
        m.put("bannerImage", e.getBannerImage());
        m.put("imagePath", e.getBannerImage());
        m.put("bannerUrl", e.getBannerImage());
        m.put("createdAt", e.getCreatedAt() == null ? null : e.getCreatedAt().toString());
        return m;
    }
}
