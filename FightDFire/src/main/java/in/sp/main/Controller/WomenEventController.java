package in.sp.main.Controller;

import in.sp.main.Entities.*;
import in.sp.main.Repository.*;
import in.sp.main.Service.FileUploadService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.*;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/women-events")
public class WomenEventController {

    @Autowired
    private WomenEventRepository womenEventRepository;

    @Autowired
    private WomenEventRegistrationRepository womenEventRegistrationRepository;

    @Autowired
    private WomenEventReviewRepository womenEventReviewRepository;

    @Autowired
    private WomenEventPhotoRepository womenEventPhotoRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private EventHostRepository eventHostRepository;

    @Autowired
    private in.sp.main.Config.JwtUtil jwtUtil;

    @Autowired
    private FileUploadService fileUploadService;

    // =========================================================
    // PUBLIC ROUTES — Browse & Discovery
    // =========================================================

    /**
     * Browse all approved events with optional city/category filters.
     */
    @GetMapping
    public String browse(@RequestParam(required = false) String city,
                         @RequestParam(required = false) WomenEventCategory category,
                         @RequestParam(required = false) String query,
                         Model model, HttpSession session) {

        List<WomenEvent> events;
        if ((city != null && !city.trim().isEmpty()) || category != null) {
            events = womenEventRepository.searchApprovedEvents(
                    (city != null && !city.trim().isEmpty()) ? city.trim() : null,
                    category
            );
        } else {
            events = womenEventRepository.findByStatusOrderByCreatedAtDesc("APPROVED");
        }

        // If text query provided, further filter by name/description
        if (query != null && !query.trim().isEmpty()) {
            final String q = query.trim().toLowerCase();
            events = events.stream()
                    .filter(e -> e.getName().toLowerCase().contains(q) ||
                            (e.getDescription() != null && e.getDescription().toLowerCase().contains(q)))
                    .collect(Collectors.toList());
        }

        List<WomenEvent> featured = womenEventRepository.findByStatusAndFeaturedTrueOrderByEventDateAsc("APPROVED");

        // Collect unique cities for filter dropdown
        List<String> cities = womenEventRepository.findByStatusOrderByCreatedAtDesc("APPROVED")
                .stream().map(WomenEvent::getCity).filter(Objects::nonNull)
                .distinct().sorted().collect(Collectors.toList());

        User loggedUser = (User) session.getAttribute("user");

        // Recommendations based on user interests
        List<WomenEvent> recommendations = new ArrayList<>();
        if (loggedUser != null) {
            List<WomenEventRegistration> regs = womenEventRegistrationRepository.findByUserOrderByRegisteredAtDesc(loggedUser);
            if (!regs.isEmpty()) {
                Set<WomenEventCategory> userInterests = regs.stream()
                        .map(r -> r.getEvent().getCategory())
                        .collect(Collectors.toSet());
                recommendations = womenEventRepository.findByStatusOrderByCreatedAtDesc("APPROVED").stream()
                        .filter(e -> userInterests.contains(e.getCategory()) && 
                                     regs.stream().noneMatch(r -> r.getEvent().getId().equals(e.getId())))
                        .limit(4)
                        .collect(Collectors.toList());
            }
        }
        if (recommendations.isEmpty()) {
            // Default recommendations: recent approved events
            recommendations = womenEventRepository.findByStatusOrderByCreatedAtDesc("APPROVED").stream()
                    .limit(4)
                    .collect(Collectors.toList());
        }

        model.addAttribute("events", events);
        model.addAttribute("featuredEvents", featured);
        model.addAttribute("recommendations", recommendations);
        model.addAttribute("categories", WomenEventCategory.values());
        model.addAttribute("cities", cities);
        model.addAttribute("selectedCity", city);
        model.addAttribute("selectedCategory", category);
        model.addAttribute("query", query);
        model.addAttribute("loggedUser", loggedUser);
        model.addAttribute("user", loggedUser);
        return "women-events/browse";
    }

    /**
     * View single event detail page.
     */
    @GetMapping("/{id}")
    public String detail(@PathVariable Long id, Model model, HttpSession session) {
        Optional<WomenEvent> opt = womenEventRepository.findById(id);
        if (opt.isEmpty() || !"APPROVED".equals(opt.get().getStatus())) {
            return "redirect:/women-events";
        }
        WomenEvent event = opt.get();
        User loggedUser = (User) session.getAttribute("user");

        List<WomenEventReview> reviews = womenEventReviewRepository.findByEventOrderByCreatedAtDesc(event);
        List<WomenEventPhoto> photos = womenEventPhotoRepository.findByEventOrderByUploadedAtDesc(event);
        Double avgRating = womenEventReviewRepository.getAverageRating(event);
        long registrationCount = womenEventRegistrationRepository.countByEvent(event);
        
        boolean alreadyRegistered = loggedUser != null &&
                womenEventRegistrationRepository.existsByEventAndUser(event, loggedUser);
        boolean alreadyVolunteer = loggedUser != null &&
                womenEventRegistrationRepository.existsByEventAndUserAndRole(event, loggedUser, "VOLUNTEER");
        boolean alreadyReviewed = loggedUser != null &&
                womenEventReviewRepository.existsByEventAndUser(event, loggedUser);
        boolean eventPassed = event.getEventDate() != null && event.getEventDate().isBefore(LocalDate.now());

        // Recommendations: similar events from the same category
        List<WomenEvent> similarEvents = womenEventRepository.findByStatusAndCategoryOrderByEventDateAsc("APPROVED", event.getCategory())
                .stream()
                .filter(e -> !e.getId().equals(event.getId()))
                .limit(3)
                .collect(Collectors.toList());

        // Attendee Networking Directory (registered users)
        List<WomenEventRegistration> regs = womenEventRegistrationRepository.findByEvent(event);
        List<User> attendeeDirectory = regs.stream()
                .filter(r -> "REGISTERED".equals(r.getStatus()) || "ATTENDED".equals(r.getStatus()))
                .map(WomenEventRegistration::getUser)
                .distinct()
                .limit(12)
                .collect(Collectors.toList());

        model.addAttribute("event", event);
        model.addAttribute("reviews", reviews);
        model.addAttribute("photos", photos);
        model.addAttribute("avgRating", avgRating != null ? Math.round(avgRating * 10.0) / 10.0 : 0.0);
        model.addAttribute("registrationCount", registrationCount);
        model.addAttribute("alreadyRegistered", alreadyRegistered);
        model.addAttribute("alreadyVolunteer", alreadyVolunteer);
        model.addAttribute("alreadyReviewed", alreadyReviewed);
        model.addAttribute("eventPassed", eventPassed);
        model.addAttribute("similarEvents", similarEvents);
        model.addAttribute("attendeeDirectory", attendeeDirectory);
        model.addAttribute("loggedUser", loggedUser);
        model.addAttribute("user", loggedUser);
        return "women-events/detail";
    }

    // =========================================================
    // USER ROUTES — Registration, Reviews, Photos
    // =========================================================

    /**
     * Register the logged-in user for an event.
     */
    @PostMapping("/{id}/register")
    public String register(@PathVariable Long id, HttpSession session, RedirectAttributes ra) {
        User loggedUser = (User) session.getAttribute("user");
        if (loggedUser == null) return "redirect:/login";

        Optional<WomenEvent> opt = womenEventRepository.findById(id);
        if (opt.isEmpty()) { ra.addFlashAttribute("error", "Event not found."); return "redirect:/women-events"; }

        WomenEvent event = opt.get();
        if (!"APPROVED".equals(event.getStatus())) {
            ra.addFlashAttribute("error", "This event is not available for registration.");
            return "redirect:/women-events/" + id;
        }

        if (womenEventRegistrationRepository.existsByEventAndUser(event, loggedUser)) {
            ra.addFlashAttribute("error", "You are already registered for this event.");
            return "redirect:/women-events/" + id;
        }

        if (event.getMaxParticipants() != null) {
            long count = womenEventRegistrationRepository.countByEvent(event);
            if (count >= event.getMaxParticipants()) {
                ra.addFlashAttribute("error", "Sorry, this event is full.");
                return "redirect:/women-events/" + id;
            }
        }

        WomenEventRegistration reg = new WomenEventRegistration();
        reg.setEvent(event);
        reg.setUser(loggedUser);
        reg.setRole("ATTENDEE");
        if (event.isFree()) {
            reg.setPaid(true);
            reg.setAmountPaid(0.0);
        } else {
            reg.setPaid(true);
            reg.setAmountPaid(event.getEntryFee());
        }
        womenEventRegistrationRepository.save(reg);

        ra.addFlashAttribute("success", "🎉 You're registered! Your ticket code: " + reg.getTicketCode());
        return "redirect:/women-events/my-registrations";
    }

    /**
     * Register the logged-in user as a volunteer.
     */
    @PostMapping("/{id}/volunteer")
    public String registerAsVolunteer(@PathVariable Long id, HttpSession session, RedirectAttributes ra) {
        User loggedUser = (User) session.getAttribute("user");
        if (loggedUser == null) return "redirect:/login";

        Optional<WomenEvent> opt = womenEventRepository.findById(id);
        if (opt.isEmpty()) { ra.addFlashAttribute("error", "Event not found."); return "redirect:/women-events"; }

        WomenEvent event = opt.get();
        if (!"APPROVED".equals(event.getStatus())) {
            ra.addFlashAttribute("error", "This event is not active.");
            return "redirect:/women-events/" + id;
        }

        if (womenEventRegistrationRepository.existsByEventAndUserAndRole(event, loggedUser, "VOLUNTEER")) {
            ra.addFlashAttribute("error", "You are already registered as a volunteer.");
            return "redirect:/women-events/" + id;
        }

        WomenEventRegistration reg = new WomenEventRegistration();
        reg.setEvent(event);
        reg.setUser(loggedUser);
        reg.setRole("VOLUNTEER");
        womenEventRegistrationRepository.save(reg);

        ra.addFlashAttribute("success", "🎉 Thank you! You are registered as a volunteer for this event.");
        return "redirect:/women-events/my-registrations";
    }

    /**
     * View user's registered events and digital tickets.
     */
    @GetMapping("/my-registrations")
    public String myRegistrations(HttpSession session, Model model) {
        User loggedUser = (User) session.getAttribute("user");
        if (loggedUser == null) return "redirect:/login";

        List<WomenEventRegistration> registrations =
                womenEventRegistrationRepository.findByUserOrderByRegisteredAtDesc(loggedUser);

        model.addAttribute("registrations", registrations);
        model.addAttribute("loggedUser", loggedUser);
        model.addAttribute("user", loggedUser);
        return "women-events/my-registrations";
    }

    /**
     * Cancel registration.
     */
    @PostMapping("/{id}/cancel-registration")
    public String cancelRegistration(@PathVariable Long id, HttpSession session, RedirectAttributes ra) {
        User loggedUser = (User) session.getAttribute("user");
        if (loggedUser == null) return "redirect:/login";

        WomenEvent event = womenEventRepository.findById(id).orElse(null);
        if (event == null) { ra.addFlashAttribute("error", "Event not found."); return "redirect:/women-events/my-registrations"; }

        womenEventRegistrationRepository.findByEventAndUser(event, loggedUser).ifPresent(reg -> {
            reg.setStatus("CANCELLED");
            womenEventRegistrationRepository.save(reg);
        });

        ra.addFlashAttribute("success", "Registration cancelled.");
        return "redirect:/women-events/my-registrations";
    }

    /**
     * Submit a post-event review.
     */
    @PostMapping("/{id}/review")
    public String submitReview(@PathVariable Long id,
                                @RequestParam Integer rating,
                                @RequestParam String reviewText,
                                HttpSession session, RedirectAttributes ra) {
        User loggedUser = (User) session.getAttribute("user");
        if (loggedUser == null) return "redirect:/login";

        WomenEvent event = womenEventRepository.findById(id).orElse(null);
        if (event == null) { ra.addFlashAttribute("error", "Event not found."); return "redirect:/women-events"; }

        if (womenEventReviewRepository.existsByEventAndUser(event, loggedUser)) {
            ra.addFlashAttribute("error", "You have already reviewed this event.");
            return "redirect:/women-events/" + id;
        }

        WomenEventReview review = new WomenEventReview();
        review.setEvent(event);
        review.setUser(loggedUser);
        review.setRating(Math.max(1, Math.min(5, rating)));
        review.setReviewText(reviewText);
        womenEventReviewRepository.save(review);

        ra.addFlashAttribute("success", "Thank you for your review!");
        return "redirect:/women-events/" + id;
    }

    /**
     * Upload a post-event gallery photo.
     */
    @PostMapping("/{id}/upload-photo")
    public String uploadPhoto(@PathVariable Long id,
                               @RequestParam MultipartFile photo,
                               @RequestParam(required = false) String caption,
                               HttpSession session, RedirectAttributes ra) {
        User loggedUser = (User) session.getAttribute("user");
        if (loggedUser == null) return "redirect:/login";

        WomenEvent event = womenEventRepository.findById(id).orElse(null);
        if (event == null) { ra.addFlashAttribute("error", "Event not found."); return "redirect:/women-events"; }

        try {
            String path = fileUploadService.saveFile(photo);
            WomenEventPhoto p = new WomenEventPhoto();
            p.setEvent(event);
            p.setUploadedBy(loggedUser);
            p.setPhotoPath(path);
            p.setCaption(caption);
            womenEventPhotoRepository.save(p);
            ra.addFlashAttribute("success", "Photo uploaded successfully!");
        } catch (IOException e) {
            ra.addFlashAttribute("error", "Photo upload failed: " + e.getMessage());
        }

        return "redirect:/women-events/" + id;
    }

    // =========================================================
    // HOST REGISTRATION & LOGIN MAPPINGS
    // =========================================================

    private EventHost checkAndGetHost(HttpSession session) {
        EventHost host = (EventHost) session.getAttribute("loggedHost");
        if (host == null) return null;
        EventHost refreshed = eventHostRepository.findById(host.getId()).orElse(host);
        session.setAttribute("loggedHost", refreshed);
        if (refreshed.getVerificationStatus() == VerificationStatus.VERIFIED) {
            return refreshed;
        }
        return null;
    }

    @GetMapping("/host/register")
    public String showHostRegisterForm() {
        return "women-events/host-register";
    }

    @PostMapping("/host/register")
    public String submitHostRegister(@RequestParam String fullName,
                                     @RequestParam String email,
                                     @RequestParam String phone,
                                     @RequestParam String password,
                                     @RequestParam String organizerName,
                                     @RequestParam String organizerType,
                                     @RequestParam String hostContact,
                                     @RequestParam String hostBio,
                                     Model model) {
        if (eventHostRepository.findByEmail(email.trim().toLowerCase()).isPresent()) {
            model.addAttribute("error", "Email already registered.");
            return "women-events/host-register";
        }
        if (phone == null || !phone.trim().matches("^\\d{10}$")) {
            model.addAttribute("error", "Phone number must be exactly 10 digits.");
            return "women-events/host-register";
        }

        EventHost host = new EventHost();
        host.setFullName(fullName);
        host.setEmail(email.trim().toLowerCase());
        host.setPhone(phone);
        host.setPassword(password);
        host.setOrganizerName(organizerName);
        host.setOrganizerType(organizerType);
        host.setHostContact(hostContact);
        host.setHostBio(hostBio);
        host.setVerificationStatus(VerificationStatus.PENDING);

        eventHostRepository.save(host);
        return "redirect:/women-events/host/login?registered=true";
    }

    @GetMapping("/host/login")
    public String showHostLoginForm() {
        return "women-events/host-login";
    }

    @PostMapping("/host/login")
    public String loginHost(@RequestParam String email,
                            @RequestParam String password,
                            HttpSession session,
                            jakarta.servlet.http.HttpServletResponse response,
                            Model model) {
        Optional<EventHost> hostOpt = eventHostRepository.findByEmail(email.trim().toLowerCase());
        if (hostOpt.isEmpty()) {
            model.addAttribute("error", "Event Host not found.");
            return "women-events/host-login";
        }
        EventHost host = hostOpt.get();
        if (!host.getPassword().equals(password)) {
            model.addAttribute("error", "Invalid password.");
            return "women-events/host-login";
        }
        if (host.getVerificationStatus() == VerificationStatus.PENDING) {
            model.addAttribute("error", "Your account is pending verification by Admin. Please check back later.");
            return "women-events/host-login";
        }
        if (host.getVerificationStatus() == VerificationStatus.REJECTED) {
            model.addAttribute("error", "Your account has been rejected by admin.");
            return "women-events/host-login";
        }

        session.setAttribute("loggedHost", host);

        // Generate JWT token if possible
        try {
            String token = jwtUtil.generateToken(host.getEmail(), "HOST");
            jakarta.servlet.http.Cookie cookie = new jakarta.servlet.http.Cookie("JWT_TOKEN", token);
            cookie.setPath("/");
            cookie.setHttpOnly(true);
            cookie.setMaxAge(365 * 24 * 60 * 60); // 1 year
            response.addCookie(cookie);
        } catch (Exception ex) {
            // jwtUtil exception fallback
        }

        return "redirect:/women-events/organizer/dashboard";
    }

    @GetMapping("/host/logout")
    public String hostLogout(HttpSession session, jakarta.servlet.http.HttpServletResponse response) {
        session.removeAttribute("loggedHost");
        jakarta.servlet.http.Cookie cookie = new jakarta.servlet.http.Cookie("JWT_TOKEN", null);
        cookie.setPath("/");
        cookie.setHttpOnly(true);
        cookie.setMaxAge(0);
        response.addCookie(cookie);
        return "redirect:/women-events";
    }

    // =========================================================
    // ORGANIZER ROUTES
    // =========================================================

    /**
     * Organizer dashboard.
     */
    @GetMapping("/organizer/dashboard")
    public String organizerDashboard(HttpSession session, Model model) {
        EventHost host = checkAndGetHost(session);
        if (host == null) {
            return "redirect:/women-events/host/login";
        }

        List<WomenEvent> myEvents = womenEventRepository.findByOrganizerOrderByCreatedAtDesc(host);
        long totalRegistrations = myEvents.stream()
                .mapToLong(e -> womenEventRegistrationRepository.countByEvent(e)).sum();
        long approvedCount = myEvents.stream().filter(e -> "APPROVED".equals(e.getStatus())).count();
        long pendingCount = myEvents.stream().filter(e -> "PENDING".equals(e.getStatus())).count();

        // Calculate commissions & financials for organizer
        double commissionsDue = myEvents.stream()
                .filter(e -> !e.isFree())
                .mapToDouble(e -> womenEventRegistrationRepository.countByEvent(e) * e.getEntryFee() * 0.05) // 5% fee commission
                .sum();

        model.addAttribute("myEvents", myEvents);
        model.addAttribute("totalRegistrations", totalRegistrations);
        model.addAttribute("approvedCount", approvedCount);
        model.addAttribute("pendingCount", pendingCount);
        model.addAttribute("commissionsDue", commissionsDue);
        model.addAttribute("loggedUser", host);
        model.addAttribute("user", host);
        return "women-events/organizer-dashboard";
    }

    @GetMapping("/organizer/create")
    public String createEventForm(HttpSession session, Model model) {
        EventHost host = checkAndGetHost(session);
        if (host == null) return "redirect:/women-events/host/login";
        model.addAttribute("categories", WomenEventCategory.values());
        model.addAttribute("loggedUser", host);
        model.addAttribute("user", host);
        return "women-events/create-event";
    }

    /**
     * Save a new event.
     */
    @PostMapping("/organizer/create")
    public String createEvent(@RequestParam String name,
                               @RequestParam WomenEventCategory category,
                               @RequestParam String description,
                               @RequestParam String eventDate,
                               @RequestParam(required = false) String eventTime,
                               @RequestParam String venue,
                               @RequestParam String city,
                               @RequestParam(defaultValue = "0") Double entryFee,
                               @RequestParam(required = false) Integer maxParticipants,
                               @RequestParam String contactInfo,
                               @RequestParam(required = false) String mapsLocation,
                               @RequestParam String organizerName,
                               @RequestParam String organizerType,
                               @RequestParam(defaultValue = "false") boolean virtual,
                               @RequestParam(required = false) String streamLink,
                               @RequestParam(defaultValue = "0") Double boothFee,
                               @RequestParam(required = false) MultipartFile bannerImage,
                               HttpSession session, RedirectAttributes ra) {
        EventHost host = checkAndGetHost(session);
        if (host == null) return "redirect:/women-events/host/login";

        WomenEvent event = new WomenEvent();
        event.setName(name);
        event.setCategory(category);
        event.setDescription(description);
        event.setEventDate(LocalDate.parse(eventDate));
        if (eventTime != null && !eventTime.isEmpty()) {
            event.setEventTime(LocalTime.parse(eventTime));
        }
        event.setVenue(venue);
        event.setCity(city);
        event.setEntryFee(entryFee);
        event.setMaxParticipants(maxParticipants);
        event.setContactInfo(contactInfo);
        event.setMapsLocation(mapsLocation);
        event.setOrganizerName(organizerName);
        event.setOrganizerType(organizerType);
        event.setOrganizer(host);
        event.setVirtual(virtual);
        event.setStreamLink(streamLink);
        event.setBoothFee(boothFee);
        event.setStatus("PENDING");

        if (bannerImage != null && !bannerImage.isEmpty()) {
            try {
                event.setBannerImage(fileUploadService.saveFile(bannerImage));
            } catch (IOException e) {
                ra.addFlashAttribute("error", "Banner upload failed: " + e.getMessage());
                return "redirect:/women-events/organizer/create";
            }
        }

        womenEventRepository.save(event);
        ra.addFlashAttribute("success", "Event submitted for admin approval!");
        return "redirect:/women-events/organizer/dashboard";
    }

    @GetMapping("/organizer/{id}/attendees")
    public String viewAttendees(@PathVariable Long id, HttpSession session, Model model) {
        EventHost host = checkAndGetHost(session);
        if (host == null) return "redirect:/women-events/host/login";

        WomenEvent event = womenEventRepository.findById(id).orElse(null);
        if (event == null || !event.getOrganizer().getId().equals(host.getId())) {
            return "redirect:/women-events/organizer/dashboard";
        }

        List<WomenEventRegistration> attendees = womenEventRegistrationRepository.findByEventAndRole(event, "ATTENDEE");
        List<WomenEventRegistration> volunteers = womenEventRegistrationRepository.findByEventAndRole(event, "VOLUNTEER");
        model.addAttribute("event", event);
        model.addAttribute("attendees", attendees);
        model.addAttribute("volunteers", volunteers);
        model.addAttribute("loggedUser", host);
        model.addAttribute("user", host);
        return "women-events/attendees";
    }

    @PostMapping("/organizer/{id}/checkin")
    public String checkIn(@PathVariable Long id, @RequestParam String ticketCode, HttpSession session, RedirectAttributes ra) {
        EventHost host = checkAndGetHost(session);
        if (host == null) return "redirect:/women-events/host/login";

        WomenEvent event = womenEventRepository.findById(id).orElse(null);
        if (event == null || !event.getOrganizer().getId().equals(host.getId())) {
            return "redirect:/women-events/organizer/dashboard";
        }

        Optional<WomenEventRegistration> regOpt = womenEventRegistrationRepository.findByTicketCode(ticketCode.trim().toUpperCase());
        if (regOpt.isEmpty() || !regOpt.get().getEvent().getId().equals(event.getId())) {
            ra.addFlashAttribute("error", "Ticket code not found for this event.");
            return "redirect:/women-events/organizer/" + id + "/attendees";
        }

        WomenEventRegistration reg = regOpt.get();
        if ("CANCELLED".equals(reg.getStatus())) {
            ra.addFlashAttribute("error", "This ticket is cancelled and cannot be verified.");
            return "redirect:/women-events/organizer/" + id + "/attendees";
        }

        reg.setCheckedIn(true);
        reg.setStatus("ATTENDED");
        womenEventRegistrationRepository.save(reg);

        ra.addFlashAttribute("success", "Ticket verified successfully! " + reg.getUser().getFullName() + " checked in.");
        return "redirect:/women-events/organizer/" + id + "/attendees";
    }

    // =========================================================
    // ADMIN ROUTES
    // =========================================================

    @GetMapping("/admin/list")
    public String adminList(HttpSession session, Model model) {
        if (session.getAttribute("admin") == null) return "redirect:/admin/loginAdmin";
        model.addAttribute("allEvents", womenEventRepository.findAll());
        model.addAttribute("categories", WomenEventCategory.values());
        
        List<EventHost> hostApplications = eventHostRepository.findAll();
        model.addAttribute("hostApplications", hostApplications);
        return "women-events/admin-events";
    }

    @PostMapping("/admin/host/{id}/approve")
    public String approveHost(@PathVariable Long id, HttpSession session, RedirectAttributes ra) {
        if (session.getAttribute("admin") == null) return "redirect:/admin/loginAdmin";
        eventHostRepository.findById(id).ifPresent(h -> {
            h.setVerificationStatus(VerificationStatus.VERIFIED);
            eventHostRepository.save(h);
        });
        ra.addFlashAttribute("success", "Event host approved!");
        return "redirect:/women-events/admin/list";
    }

    @PostMapping("/admin/host/{id}/reject")
    public String rejectHost(@PathVariable Long id, HttpSession session, RedirectAttributes ra) {
        if (session.getAttribute("admin") == null) return "redirect:/admin/loginAdmin";
        eventHostRepository.findById(id).ifPresent(h -> {
            h.setVerificationStatus(VerificationStatus.REJECTED);
            eventHostRepository.save(h);
        });
        ra.addFlashAttribute("success", "Event host application rejected.");
        return "redirect:/women-events/admin/list";
    }

    @PostMapping("/admin/{id}/approve")
    public String approveEvent(@PathVariable Long id, HttpSession session, RedirectAttributes ra) {
        if (session.getAttribute("admin") == null) return "redirect:/admin/loginAdmin";
        womenEventRepository.findById(id).ifPresent(e -> {
            e.setStatus("APPROVED");
            womenEventRepository.save(e);
        });
        ra.addFlashAttribute("success", "Event approved!");
        return "redirect:/women-events/admin/list";
    }

    @PostMapping("/admin/{id}/reject")
    public String rejectEvent(@PathVariable Long id, HttpSession session, RedirectAttributes ra) {
        if (session.getAttribute("admin") == null) return "redirect:/admin/loginAdmin";
        womenEventRepository.findById(id).ifPresent(e -> {
            e.setStatus("REJECTED");
            womenEventRepository.save(e);
        });
        ra.addFlashAttribute("success", "Event rejected.");
        return "redirect:/women-events/admin/list";
    }

    @PostMapping("/admin/{id}/feature")
    public String toggleFeature(@PathVariable Long id, HttpSession session, RedirectAttributes ra) {
        if (session.getAttribute("admin") == null) return "redirect:/admin/loginAdmin";
        womenEventRepository.findById(id).ifPresent(e -> {
            e.setFeatured(!e.isFeatured());
            womenEventRepository.save(e);
        });
        ra.addFlashAttribute("success", "Featured status updated.");
        return "redirect:/women-events/admin/list";
    }

    @PostMapping("/admin/{id}/delete")
    public String deleteEvent(@PathVariable Long id, HttpSession session, RedirectAttributes ra) {
        if (session.getAttribute("admin") == null) return "redirect:/admin/loginAdmin";
        womenEventRepository.deleteById(id);
        ra.addFlashAttribute("success", "Event deleted.");
        return "redirect:/women-events/admin/list";
    }
}
