package in.sp.main.Controller;

import in.sp.main.Config.JwtUtil;
import in.sp.main.Entities.*;
import in.sp.main.Repository.EventHostRepository;
import in.sp.main.Repository.WomenEventRegistrationRepository;
import in.sp.main.Repository.WomenEventRepository;
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
        host.setVerificationStatus(VerificationStatus.PENDING);
        hostRepo.save(host);

        Map<String, Object> res = new LinkedHashMap<>();
        res.put("success", true);
        res.put("message", "Registration submitted. Await admin verification at Women Events admin.");
        res.put("hostId", host.getId());
        res.put("status", "PENDING");
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
        if (host.getVerificationStatus() == VerificationStatus.PENDING) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(error("Your account is pending admin verification"));
        }
        if (host.getVerificationStatus() == VerificationStatus.REJECTED) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(error("Your account has been rejected by admin"));
        }

        session.setAttribute("loggedHost", host);
        String token = jwtUtil.generateToken(host.getEmail(), "HOST");
        Map<String, Object> res = new LinkedHashMap<>();
        res.put("success", true);
        res.put("token", token);
        res.put("tokenType", "Bearer");
        res.put("role", "HOST");
        res.put("host", hostSummary(host));
        return ResponseEntity.ok(res);
    }

    @GetMapping("/me")
    public ResponseEntity<Map<String, Object>> me(HttpSession session) {
        EventHost host = requireHost(session);
        if (host == null) return unauthorized();
        host = hostRepo.findById(host.getId()).orElse(host);

        List<WomenEvent> myEvents = eventRepo.findByOrganizerOrderByCreatedAtDesc(host);
        List<Map<String, Object>> events = myEvents.stream().map(e -> {
            Map<String, Object> m = eventDto(e);
            m.put("registrationCount", registrationRepo.countByEvent(e));
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
        return ResponseEntity.ok(ok(data));
    }

    @PostMapping("/events")
    @Transactional
    public ResponseEntity<Map<String, Object>> createEvent(@RequestBody Map<String, Object> body, HttpSession session) {
        EventHost host = requireHost(session);
        if (host == null) return unauthorized();
        if (host.getVerificationStatus() != VerificationStatus.VERIFIED) {
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
            event.setMaxParticipants(parseInt(maxPart, 0));
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
        event.setStatus("PENDING");
        eventRepo.save(event);

        Map<String, Object> data = new LinkedHashMap<>();
        data.put("message", "Event submitted for admin approval");
        data.put("event", eventDto(event));
        return ResponseEntity.status(HttpStatus.CREATED).body(ok(data));
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
