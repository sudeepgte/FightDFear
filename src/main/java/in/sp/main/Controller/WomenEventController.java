package in.sp.main.Controller;

import in.sp.main.Entities.*;
import in.sp.main.Repository.*;
import in.sp.main.Service.FileUploadService;
import in.sp.main.Service.EventHostProfileService;
import in.sp.main.Service.EventsCareService;
import in.sp.main.Service.PartnerLifecycleSupport;
import in.sp.main.Service.EventCoinPolicy;
import in.sp.main.Service.WomenEventBookingService;
import in.sp.main.Service.WomenEventLifecycleService;
import in.sp.main.Service.WomenEventSupport;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.transaction.annotation.Transactional;

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
    private in.sp.main.Service.PasswordService passwordService;

    @Autowired
    private in.sp.main.Config.JwtUtil jwtUtil;

    @Autowired
    private FileUploadService fileUploadService;

    @Autowired
    private EventHostProfileService eventHostProfileService;

    @Autowired
    private EventsCareService eventsCareService;

    @Autowired
    private WomenEventBookingService womenEventBookingService;

    @Autowired
    private WomenEventLifecycleService womenEventLifecycleService;

    @Autowired
    private EventTicketTypeRepository eventTicketTypeRepository;

    @Autowired
    private EventSpeakerRepository eventSpeakerRepository;

    @Autowired
    private EventAgendaItemRepository eventAgendaItemRepository;

    @Autowired
    private EventFavoriteRepository eventFavoriteRepository;

    @Autowired
    private EventCoinPolicy eventCoinPolicy;

    // =========================================================
    // PUBLIC ROUTES — Browse & Discovery
    // =========================================================

    /**
     * Browse all approved events with optional city/category filters.
     */
    @GetMapping
    @Transactional(readOnly = true)
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
            events = womenEventRepository.findListedEvents();
        }

        events = events.stream()
                .filter(WomenEventSupport::isPubliclyListed)
                .filter(e -> e.getOrganizer() == null || EventHostProfileService.isApproved(e.getOrganizer()))
                .collect(Collectors.toList());

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
        if (opt.isEmpty() || !WomenEventSupport.isPubliclyListed(opt.get())) {
            return "redirect:/women-events";
        }
        WomenEvent event = opt.get();
        if (event.getOrganizer() != null && !EventHostProfileService.isApproved(event.getOrganizer())) {
            return "redirect:/women-events";
        }
        User loggedUser = (User) session.getAttribute("user");

        List<WomenEventReview> reviews = womenEventReviewRepository.findByEventOrderByCreatedAtDesc(event);
        List<WomenEventPhoto> photos = womenEventPhotoRepository.findByEventOrderByUploadedAtDesc(event);
        Double avgRating = womenEventReviewRepository.getAverageRating(event);
        long registrationCount = womenEventRegistrationRepository.countByEvent(event);
        
        boolean alreadyRegistered = loggedUser != null &&
                womenEventRegistrationRepository.existsActiveByEventAndUser(event, loggedUser);
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
        model.addAttribute("speakers", eventSpeakerRepository.findByEventOrderBySortOrderAscIdAsc(event));
        model.addAttribute("agenda", eventAgendaItemRepository.findByEventOrderBySortOrderAscStartTimeAsc(event));
        model.addAttribute("ticketTypes", eventTicketTypeRepository.findByEventOrderByIdAsc(event));
        model.addAttribute("soldOut", womenEventBookingService.isSoldOut(event));
        model.addAttribute("registrationOpen", WomenEventSupport.registrationWindowOpen(event, java.time.LocalDateTime.now()));
        model.addAttribute("savedEvent", loggedUser != null && eventFavoriteRepository.existsByEventAndUser(event, loggedUser));
        
        EventHost loggedHost = (EventHost) session.getAttribute("loggedHost");
        boolean isOrganizerView = loggedHost != null && event.getOrganizer() != null && event.getOrganizer().getId().equals(loggedHost.getId());
        model.addAttribute("isOrganizerView", isOrganizerView);

        boolean eligibleAccess = alreadyRegistered;
        if (loggedUser != null) {
            eligibleAccess = womenEventRegistrationRepository.findActiveByEventAndUser(event, loggedUser)
                    .map(r -> r.isPaid() || event.isFree() || womenEventBookingService.payableOf(r) <= 0)
                    .orElse(false);
        }
        model.addAttribute("streamLink", WomenEventSupport.hideAccessIfUnauthorized(event, eligibleAccess));
        if (loggedUser != null) {
            double fee = event.getEntryFee() == null ? 0 : event.getEntryFee();
            model.addAttribute("coinQuote", womenEventBookingService.quoteCoins(loggedUser, fee, Integer.MAX_VALUE));
        }
        return "women-events/detail";
    }

    // =========================================================
    // USER ROUTES — Registration, Reviews, Photos
    // =========================================================

    /**
     * Register the logged-in user for an event.
     */
    @PostMapping("/{id}/register")
    public String register(@PathVariable Long id,
                           @RequestParam(required = false) Long ticketTypeId,
                           @RequestParam(defaultValue = "1") int quantity,
                           @RequestParam(defaultValue = "0") int coins,
                           HttpSession session, RedirectAttributes ra) {
        User loggedUser = (User) session.getAttribute("user");
        if (loggedUser == null) return "redirect:/login";

        try {
            WomenEventRegistration reg = womenEventBookingService.book(loggedUser, id, ticketTypeId, quantity, coins);
            session.setAttribute("user", loggedUser);
            if (reg.isPaid() || womenEventBookingService.payableOf(reg) <= 0) {
                ra.addFlashAttribute("success", "You're registered! Ticket: " + reg.getTicketCode());
                return "redirect:/women-events/tickets/" + reg.getId();
            }
            ra.addFlashAttribute("success", "Seat reserved. Complete payment to confirm your ticket.");
            ra.addFlashAttribute("pendingPaymentId", reg.getId());
            return "redirect:/women-events/" + id;
        } catch (org.springframework.web.server.ResponseStatusException ex) {
            ra.addFlashAttribute("error", ex.getReason());
            return "redirect:/women-events/" + id;
        }
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
            try {
                eventsCareService.cancel(reg);
                ra.addFlashAttribute("success", "Registration cancelled. Eligible coins were restored.");
            } catch (org.springframework.web.server.ResponseStatusException ex) {
                ra.addFlashAttribute("error", ex.getReason());
            }
        });
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
        return refreshed;
    }

    /** Incomplete hosts must finish profile before organizer features. */
    private String redirectIfProfileIncomplete(EventHost host) {
        if (host == null) return "redirect:/women-events/host/login";
        if (EventHostProfileService.isApproved(host)) return null;
        if (PartnerLifecycleSupport.needsProfileCompletion(host.getPartnerProfileStatus())) {
            return "redirect:/women-events/organizer/profile-completion";
        }
        return null;
    }

    /** Create / publish / check-in stay locked until admin approval. */
    private String redirectIfFeaturesLocked(EventHost host, RedirectAttributes ra, String message) {
        if (host == null) return "redirect:/women-events/host/login";
        if (EventHostProfileService.isApproved(host)) return null;
        if (ra != null && message != null) {
            ra.addFlashAttribute("error", message);
        }
        if (PartnerLifecycleSupport.needsProfileCompletion(host.getPartnerProfileStatus())) {
            return "redirect:/women-events/organizer/profile-completion";
        }
        return "redirect:/women-events/organizer/dashboard";
    }

    /** Matches Flutter Event Host login: incomplete / changes-requested hosts complete profile first. */
    private boolean hostNeedsProfileCompletion(EventHost host) {
        if (host == null) return false;
        PartnerProfileStatus status = host.getPartnerProfileStatus();
        return status == null || PartnerLifecycleSupport.needsProfileCompletion(status);
    }

    private String redirectAfterHostLogin(EventHost host) {
        if (hostNeedsProfileCompletion(host)) {
            return "redirect:/women-events/organizer/profile-completion";
        }
        return "redirect:/women-events/organizer/dashboard";
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
        host.setPassword(passwordService.encode(password));
        host.setOrganizerName(organizerName);
        host.setOrganizerType(organizerType);
        host.setHostContact(hostContact);
        host.setHostBio(hostBio);
        host.setPartnerProfileStatus(PartnerProfileStatus.PROFILE_INCOMPLETE);
        host.setProfileCompletionPct(10); // Initial quick reg percentage

        eventHostRepository.save(host);
        return "redirect:/women-events/host/login?registered=true";
    }

    @GetMapping("/host/login")
    public String showHostLoginForm(HttpSession session, Model model,
                                    @RequestParam(value = "email", required = false) String email) {
        Object pending = session.getAttribute("pendingHostLoginEmail");
        String pendingEmail = (pending instanceof String) ? ((String) pending).trim() : "";
        if (!pendingEmail.isEmpty()) {
            model.addAttribute("registeredEmail", pendingEmail);
            session.removeAttribute("pendingHostLoginEmail");
        } else if (email != null && !email.trim().isEmpty()) {
            model.addAttribute("registeredEmail", email.trim().toLowerCase());
        }
        return "women-events/host-login";
    }

    @PostMapping("/host/login")
    public String loginHost(@RequestParam String email,
                            @RequestParam String password,
                            HttpSession session,
                            jakarta.servlet.http.HttpServletResponse response,
                            Model model) {
        String normalizedEmail = email == null ? "" : email.trim().toLowerCase();
        model.addAttribute("registeredEmail", normalizedEmail);
        Optional<EventHost> hostOpt = eventHostRepository.findByEmail(normalizedEmail);
        if (hostOpt.isEmpty()) {
            model.addAttribute("error", "Event Host not found.");
            return "women-events/host-login";
        }
        EventHost host = hostOpt.get();
        boolean ok = passwordService.matchesAndUpgrade(password, host.getPassword(), hashed -> {
            host.setPassword(hashed);
            eventHostRepository.save(host);
        });
        if (!ok) {
            model.addAttribute("error", "Invalid password.");
            return "women-events/host-login";
        }

        PartnerProfileStatus partnerStatus = host.getPartnerProfileStatus();
        VerificationStatus verStatus = host.getVerificationStatus();

        if (partnerStatus == PartnerProfileStatus.SUSPENDED || verStatus == VerificationStatus.REJECTED || partnerStatus == PartnerProfileStatus.REJECTED) {
            model.addAttribute("error", "Your account has been rejected or suspended by admin." + (host.getRejectionReason() != null ? " Reason: " + host.getRejectionReason() : ""));
            return "women-events/host-login";
        }

        if (partnerStatus == null) {
            if (verStatus == VerificationStatus.VERIFIED) {
                eventHostProfileService.setLifecycleStatus(host, PartnerProfileStatus.APPROVED);
            } else {
                eventHostProfileService.setLifecycleStatus(host, PartnerProfileStatus.PROFILE_INCOMPLETE);
            }
            eventHostProfileService.refreshCompletion(host);
        } else {
            eventHostProfileService.refreshCompletion(host);
        }

        session.setAttribute("loggedHost", host);

        try {
            String token = jwtUtil.generateToken(host.getEmail(), "HOST");
            jakarta.servlet.http.Cookie cookie = new jakarta.servlet.http.Cookie("JWT_TOKEN", token);
            cookie.setPath("/");
            cookie.setHttpOnly(true);
            cookie.setMaxAge(365 * 24 * 60 * 60);
            response.addCookie(cookie);
        } catch (Exception ex) {
            // token generation fallback
        }

        return redirectAfterHostLogin(host);
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
    @Transactional(readOnly = true)
    public String organizerDashboard(HttpSession session, Model model) {
        EventHost host = checkAndGetHost(session);
        if (host == null) {
            return "redirect:/women-events/host/login";
        }
        String incomplete = redirectIfProfileIncomplete(host);
        if (incomplete != null) return incomplete;
        if (hostNeedsProfileCompletion(host)) {
            return "redirect:/women-events/organizer/profile-completion";
        }
        populateOrganizerDashboardModel(host, session, model, "dashboard");
        return "women-events/organizer-dashboard";
    }

    /** Organizer My Events list page */
    @GetMapping("/organizer/my-events")
    @Transactional(readOnly = true)
    public String myEvents(HttpSession session, Model model) {
        EventHost host = checkAndGetHost(session);
        if (host == null) return "redirect:/women-events/host/login";
        String incomplete = redirectIfProfileIncomplete(host);
        if (incomplete != null) return incomplete;
        if (hostNeedsProfileCompletion(host)) {
            return "redirect:/women-events/organizer/profile-completion";
        }

        populateOrganizerDashboardModel(host, session, model, "events");
        return "women-events/organizer-dashboard";
    }

    private void populateOrganizerDashboardModel(EventHost host, HttpSession session, Model model, String navActive) {
        host = eventHostRepository.findById(host.getId()).orElse(host);
        host = eventHostProfileService.refreshCompletion(host);
        session.setAttribute("loggedHost", host);

        model.addAttribute("hostApproved", EventHostProfileService.isApproved(host));
        model.addAttribute("nextStepGuidance", eventHostProfileService.profilePayload(host).get("nextStepGuidance"));
        model.addAttribute("organizerNavActive", navActive);

        List<WomenEvent> myEvents = womenEventRepository.findByOrganizerOrderByCreatedAtDesc(host);
        long totalRegistrations = myEvents.stream()
                .mapToLong(e -> womenEventRegistrationRepository.countByEvent(e)).sum();
        long approvedCount = myEvents.stream().filter(e -> "APPROVED".equals(e.getStatus()) || "PUBLISHED".equals(e.getStatus())).count();
        long pendingCount = myEvents.stream().filter(e -> "PENDING".equals(e.getStatus()) || "SUBMITTED".equals(e.getStatus())).count();
        long draftCount = myEvents.stream().filter(e -> "DRAFT".equals(e.getStatus())).count();
        long publishedCount = approvedCount;
        long upcomingCount = myEvents.stream().filter(e -> {
            java.time.LocalDateTime start = WomenEventSupport.eventStart(e);
            return start != null && start.isAfter(java.time.LocalDateTime.now())
                    && WomenEventSupport.isPubliclyListed(e);
        }).count();
        double grossRevenue = myEvents.stream()
                .flatMap(e -> womenEventRegistrationRepository.findByEvent(e).stream())
                .filter(r -> r.isPaid() && !"CANCELLED".equalsIgnoreCase(r.getStatus()))
                .mapToDouble(r -> r.getAmountPaid() == null ? 0 : r.getAmountPaid())
                .sum();

        List<WomenEventRegistration> allRegistrations = myEvents.isEmpty()
                ? List.of()
                : womenEventRegistrationRepository.findByEventsWithUserAndEvent(myEvents).stream()
                .sorted((a, b) -> {
                    if (a.getRegisteredAt() == null || b.getRegisteredAt() == null) return 0;
                    return b.getRegisteredAt().compareTo(a.getRegisteredAt());
                })
                .collect(Collectors.toList());

        List<WomenEventRegistration> recentRegistrations = allRegistrations.stream().limit(5).collect(Collectors.toList());

        long newNotifCount = allRegistrations.stream()
                .filter(r -> r.getRegisteredAt() != null
                        && r.getRegisteredAt().isAfter(java.time.LocalDateTime.now().minusDays(7)))
                .count();

        double commissionsDue = myEvents.stream()
                .filter(e -> !e.isFree())
                .mapToDouble(e -> womenEventRegistrationRepository.countByEvent(e) * e.getEntryFee() * 0.05)
                .sum();

        model.addAttribute("host", host);
        model.addAttribute("myEvents", myEvents);
        model.addAttribute("totalRegistrations", totalRegistrations);
        model.addAttribute("approvedCount", approvedCount);
        model.addAttribute("pendingCount", pendingCount);
        model.addAttribute("draftCount", draftCount);
        model.addAttribute("publishedCount", publishedCount);
        model.addAttribute("upcomingCount", upcomingCount);
        model.addAttribute("grossRevenue", grossRevenue);
        model.addAttribute("netEarnings", Math.max(0, grossRevenue - eventCoinPolicy.platformFee(grossRevenue)));
        model.addAttribute("platformFeePercent", eventCoinPolicy.platformFeePercent());
        model.addAttribute("avgRating", host.getRating());
        model.addAttribute("commissionsDue", commissionsDue);
        model.addAttribute("recentRegistrations", recentRegistrations);
        model.addAttribute("allRegistrations", allRegistrations);
        model.addAttribute("newNotifCount", newNotifCount);
        model.addAttribute("loggedUser", host);
        model.addAttribute("user", host);
    }

    /** Organizer Registrations page */
    @GetMapping("/organizer/registrations")
    @Transactional(readOnly = true)
    public String organizerRegistrations(HttpSession session, Model model) {
        EventHost host = checkAndGetHost(session);
        if (host == null) return "redirect:/women-events/host/login";
        String incomplete = redirectIfProfileIncomplete(host);
        if (incomplete != null) return incomplete;
        List<WomenEvent> myEvents = womenEventRepository.findByOrganizerOrderByCreatedAtDesc(host);
        List<WomenEventRegistration> allRegistrations = myEvents.isEmpty()
                ? List.of()
                : womenEventRegistrationRepository.findByEventsWithUserAndEvent(myEvents).stream()
                .sorted((a, b) -> {
                    if (a.getRegisteredAt() == null || b.getRegisteredAt() == null) return 0;
                    return b.getRegisteredAt().compareTo(a.getRegisteredAt());
                })
                .collect(Collectors.toList());
        long newNotifCount = allRegistrations.stream()
                .filter(r -> r.getRegisteredAt() != null
                        && r.getRegisteredAt().isAfter(java.time.LocalDateTime.now().minusDays(7)))
                .count();
        model.addAttribute("host", host);
        model.addAttribute("allRegistrations", allRegistrations);
        model.addAttribute("loggedUser", host);
        model.addAttribute("user", host);
        model.addAttribute("organizerNavActive", "registrations");
        model.addAttribute("newNotifCount", newNotifCount);
        model.addAttribute("hostApproved", EventHostProfileService.isApproved(host));
        return "women-events/organizer-registrations";
    }

    /** Organizer Notifications page – shows recent registrations */
    @GetMapping("/organizer/notifications")
    @Transactional(readOnly = true)
    public String organizerNotifications(HttpSession session, Model model) {
        EventHost host = checkAndGetHost(session);
        if (host == null) return "redirect:/women-events/host/login";
        String incomplete = redirectIfProfileIncomplete(host);
        if (incomplete != null) return incomplete;
        List<WomenEvent> myEvents = womenEventRepository.findByOrganizerOrderByCreatedAtDesc(host);
        List<WomenEventRegistration> allRegistrations = myEvents.isEmpty()
                ? List.of()
                : womenEventRegistrationRepository.findByEventsWithUserAndEvent(myEvents);
        List<WomenEventRegistration> notifications = allRegistrations.stream()
                .sorted((a, b) -> {
                    if (a.getRegisteredAt() == null || b.getRegisteredAt() == null) return 0;
                    return b.getRegisteredAt().compareTo(a.getRegisteredAt());
                })
                .limit(20)
                .collect(Collectors.toList());
        long newNotifCount = allRegistrations.stream()
                .filter(r -> r.getRegisteredAt() != null
                        && r.getRegisteredAt().isAfter(java.time.LocalDateTime.now().minusDays(7)))
                .count();
        model.addAttribute("host", host);
        model.addAttribute("notifications", notifications);
        model.addAttribute("loggedUser", host);
        model.addAttribute("user", host);
        model.addAttribute("organizerNavActive", "notifications");
        model.addAttribute("newNotifCount", newNotifCount);
        model.addAttribute("hostApproved", EventHostProfileService.isApproved(host));
        return "women-events/organizer-notifications";
    }

    /** Host Profile Completion / Edit Profile – GET */
    @GetMapping({"/organizer/profile-completion", "/organizer/edit-profile"})
    public String editProfileForm(@RequestParam(value = "submitted", required = false) Boolean submitted,
                                  HttpSession session, Model model) {
        EventHost host = checkAndGetHost(session);
        if (host == null) return "redirect:/women-events/host/login";
        host = eventHostRepository.findById(host.getId()).orElse(host);
        host = eventHostProfileService.refreshCompletion(host);
        session.setAttribute("loggedHost", host);
        Map<String, Object> profilePayload = eventHostProfileService.profilePayload(host);
        model.addAttribute("host", host);
        model.addAttribute("loggedUser", host);
        model.addAttribute("profilePayload", profilePayload);
        model.addAttribute("missingItems", profilePayload.get("missingItems"));
        model.addAttribute("nextStepGuidance", profilePayload.get("nextStepGuidance"));
        model.addAttribute("canSubmitForVerification", profilePayload.get("canSubmitForVerification"));
        model.addAttribute("organizerNavActive", "profile");
        model.addAttribute("newNotifCount", 0L);
        model.addAttribute("hostApproved", EventHostProfileService.isApproved(host));
        if (Boolean.TRUE.equals(submitted)) {
            model.addAttribute("success", "Profile submitted for admin verification. You can keep updating details while we review.");
        }
        return "women-events/organizer-edit-profile";
    }

    /** Edit Profile – POST */
    @PostMapping("/organizer/edit-profile")
    public String saveProfile(@RequestParam String fullName,
                              @RequestParam String phone,
                              @RequestParam String organizerName,
                              @RequestParam String organizerType,
                              @RequestParam(required = false) String hostBio,
                              @RequestParam(required = false) String city,
                              @RequestParam(required = false) String state,
                              @RequestParam(required = false) String website,
                              @RequestParam(required = false) String instagram,
                              @RequestParam(required = false) String facebook,
                              @RequestParam(required = false) String linkedin,
                              HttpSession session, RedirectAttributes ra) {
        EventHost host = checkAndGetHost(session);
        if (host == null) return "redirect:/women-events/host/login";
        host.setFullName(fullName);
        host.setPhone(phone);
        host.setOrganizerName(organizerName);
        host.setOrganizerType(organizerType);
        host.setHostBio(hostBio);
        host.setCity(city);
        host.setState(state);
        host.setWebsite(website);
        host.setInstagram(instagram);
        host.setFacebook(facebook);
        host.setLinkedin(linkedin);
        eventHostRepository.save(host);
        session.setAttribute("loggedHost", host);
        ra.addFlashAttribute("success", "Profile updated successfully!");
        return "redirect:/women-events/organizer/edit-profile";
    }

    /** Settings – GET */
    @GetMapping("/organizer/settings")
    @Transactional(readOnly = true)
    public String settingsForm(HttpSession session, Model model) {
        EventHost host = checkAndGetHost(session);
        if (host == null) return "redirect:/women-events/host/login";
        String incomplete = redirectIfProfileIncomplete(host);
        if (incomplete != null) return incomplete;
        List<WomenEvent> myEvents = womenEventRepository.findByOrganizerOrderByCreatedAtDesc(host);
        List<WomenEventRegistration> allRegistrations = myEvents.isEmpty()
                ? List.of()
                : womenEventRegistrationRepository.findByEventsWithUserAndEvent(myEvents);
        long newNotifCount = allRegistrations.stream()
                .filter(r -> r.getRegisteredAt() != null
                        && r.getRegisteredAt().isAfter(java.time.LocalDateTime.now().minusDays(7)))
                .count();
        model.addAttribute("host", host);
        model.addAttribute("loggedUser", host);
        model.addAttribute("user", host);
        model.addAttribute("organizerNavActive", "settings");
        model.addAttribute("newNotifCount", newNotifCount);
        model.addAttribute("hostApproved", EventHostProfileService.isApproved(host));
        return "women-events/organizer-settings";
    }

    /** Settings – Change Password POST */
    @PostMapping("/organizer/settings/change-password")
    public String changePassword(@RequestParam String currentPassword,
                                 @RequestParam String newPassword,
                                 @RequestParam String confirmPassword,
                                 HttpSession session, RedirectAttributes ra) {
        EventHost host = checkAndGetHost(session);
        if (host == null) return "redirect:/women-events/host/login";
        if (!newPassword.equals(confirmPassword)) {
            ra.addFlashAttribute("error", "New passwords do not match.");
            return "redirect:/women-events/organizer/settings";
        }
        boolean ok = passwordService.matchesAndUpgrade(currentPassword, host.getPassword(), hashed -> {
            host.setPassword(hashed);
            eventHostRepository.save(host);
        });
        if (!ok) {
            ra.addFlashAttribute("error", "Current password is incorrect.");
            return "redirect:/women-events/organizer/settings";
        }
        host.setPassword(passwordService.encode(newPassword));
        eventHostRepository.save(host);
        session.setAttribute("loggedHost", host);
        ra.addFlashAttribute("success", "Password changed successfully!");
        return "redirect:/women-events/organizer/settings";
    }

    @GetMapping("/organizer/create")
    public String createEventForm(HttpSession session, Model model) {
        EventHost host = checkAndGetHost(session);
        if (host == null) return "redirect:/women-events/host/login";
        if (!EventHostProfileService.isApproved(host)) {
            return redirectIfFeaturesLocked(host, null, null);
        }
        model.addAttribute("categories", WomenEventCategory.values());
        model.addAttribute("host", host);
        model.addAttribute("loggedUser", host);
        model.addAttribute("user", host);
        model.addAttribute("organizerNavActive", "create");
        model.addAttribute("newNotifCount", 0L);
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
                               @RequestParam(required = false) String endDate,
                               @RequestParam(required = false) String endTime,
                               @RequestParam(required = false) String registrationCloses,
                               @RequestParam String venue,
                               @RequestParam String city,
                               @RequestParam(defaultValue = "0") Double entryFee,
                               @RequestParam(required = false) Integer maxParticipants,
                               @RequestParam String contactInfo,
                               @RequestParam(required = false) String mapsLocation,
                               @RequestParam String organizerName,
                               @RequestParam String organizerType,
                               @RequestParam(defaultValue = "false") boolean virtual,
                               @RequestParam(required = false) String eventFormat,
                               @RequestParam(required = false) String streamLink,
                               @RequestParam(required = false) String meetingPlatform,
                               @RequestParam(required = false) String shortDescription,
                               @RequestParam(required = false) String cancellationPolicy,
                               @RequestParam(required = false) String refundPolicy,
                               @RequestParam(required = false) String ageRestriction,
                               @RequestParam(required = false) String participantRequirements,
                               @RequestParam(required = false) String whatToBring,
                               @RequestParam(defaultValue = "0") Double boothFee,
                               @RequestParam(required = false) MultipartFile bannerImage,
                               @RequestParam(defaultValue = "false") boolean saveDraft,
                               HttpSession session, RedirectAttributes ra) {
        EventHost host = checkAndGetHost(session);
        if (host == null) return "redirect:/women-events/host/login";
        if (!EventHostProfileService.isApproved(host)) {
            return redirectIfFeaturesLocked(host, ra, "Event creation is locked until admin profile approval.");
        }

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
        event.setShortDescription(shortDescription);
        event.setMeetingPlatform(meetingPlatform);
        event.setCancellationPolicy(cancellationPolicy);
        event.setRefundPolicy(refundPolicy);
        event.setAgeRestriction(ageRestriction);
        event.setParticipantRequirements(participantRequirements);
        event.setWhatToBring(whatToBring);
        event.setTimezone("Asia/Kolkata");
        event.setEventFormat(EventFormat.fromFlexible(eventFormat != null ? eventFormat : (virtual ? "ONLINE" : "OFFLINE")));
        event.setVirtual(event.getEventFormat() == EventFormat.ONLINE || event.getEventFormat() == EventFormat.HYBRID);
        if (event.getEventDate() != null) {
            LocalTime st = event.getEventTime() == null ? LocalTime.of(10, 0) : event.getEventTime();
            event.setStartsAt(java.time.LocalDateTime.of(event.getEventDate(), st));
            if (endDate != null && !endDate.isBlank()) {
                LocalDate ed = LocalDate.parse(endDate);
                LocalTime et = (endTime != null && !endTime.isBlank()) ? LocalTime.parse(endTime) : st.plusHours(2);
                event.setEndsAt(java.time.LocalDateTime.of(ed, et));
            }
            if (registrationCloses != null && !registrationCloses.isBlank()) {
                try {
                    String raw = registrationCloses.trim();
                    if (raw.length() == 16) raw = raw + ":00";
                    event.setRegistrationClosesAt(java.time.LocalDateTime.parse(raw.replace(" ", "T")));
                } catch (Exception ignored) {
                    event.setRegistrationClosesAt(event.getStartsAt());
                }
            } else {
                event.setRegistrationClosesAt(event.getStartsAt());
            }
            if (event.getStartsAt() != null && event.getEndsAt() != null
                    && event.getEndsAt().isBefore(event.getStartsAt())) {
                ra.addFlashAttribute("error", "End date/time cannot be before start.");
                return "redirect:/women-events/organizer/create";
            }
        }
        womenEventLifecycleService.applyCreateStatus(event, saveDraft);

        if (bannerImage != null && !bannerImage.isEmpty()) {
            try {
                event.setBannerImage(fileUploadService.saveFile(bannerImage));
            } catch (IOException e) {
                ra.addFlashAttribute("error", "Banner upload failed: " + e.getMessage());
                return "redirect:/women-events/organizer/create";
            }
        }

        try {
            womenEventRepository.save(event);
        } catch (org.springframework.dao.DataAccessException ex) {
            ra.addFlashAttribute("error", "Could not save the event. Check category and required fields, then try again.");
            return "redirect:/women-events/organizer/create";
        }
        womenEventLifecycleService.transition(event,
                saveDraft ? EventLifecycleStatus.DRAFT : EventLifecycleStatus.SUBMITTED,
                "EVENT_HOST", host.getId(), host.getEmail(), saveDraft ? "Saved as draft" : "Submitted for approval");
        ra.addFlashAttribute("success", saveDraft
                ? "Draft saved. Complete and submit for admin approval when ready."
                : "Event submitted for admin approval!");
        return "redirect:/women-events/organizer/dashboard";
    }

    @GetMapping("/organizer/{id}/attendees")
    public String viewAttendees(@PathVariable Long id, HttpSession session, Model model) {
        EventHost host = checkAndGetHost(session);
        if (host == null) return "redirect:/women-events/host/login";
        if (!EventHostProfileService.isApproved(host)) {
            return redirectIfFeaturesLocked(host, null, null);
        }

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
        if (!EventHostProfileService.isApproved(host)) {
            return redirectIfFeaturesLocked(host, ra, "Check-in is locked until admin profile approval.");
        }

        WomenEvent event = womenEventRepository.findById(id).orElse(null);
        if (event == null || !event.getOrganizer().getId().equals(host.getId())) {
            return "redirect:/women-events/organizer/dashboard";
        }

        try {
            womenEventBookingService.checkIn(event, ticketCode.trim());
            ra.addFlashAttribute("success", "Ticket verified and attendee checked in.");
        } catch (org.springframework.web.server.ResponseStatusException ex) {
            ra.addFlashAttribute("error", ex.getReason());
        }
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
            eventHostProfileService.setLifecycleStatus(h, PartnerProfileStatus.APPROVED);
            eventHostRepository.save(h);
        });
        ra.addFlashAttribute("success", "Event host approved!");
        return "redirect:/women-events/admin/list";
    }

    @PostMapping("/admin/host/{id}/reject")
    public String rejectHost(@PathVariable Long id, HttpSession session, RedirectAttributes ra) {
        if (session.getAttribute("admin") == null) return "redirect:/admin/loginAdmin";
        eventHostRepository.findById(id).ifPresent(h -> {
            eventHostProfileService.setLifecycleStatus(h, PartnerProfileStatus.REJECTED);
            eventHostRepository.save(h);
        });
        ra.addFlashAttribute("success", "Event host application rejected.");
        return "redirect:/women-events/admin/list";
    }

    @PostMapping("/admin/{id}/approve")
    public String approveEvent(@PathVariable Long id, HttpSession session, RedirectAttributes ra) {
        if (session.getAttribute("admin") == null) return "redirect:/admin/loginAdmin";
        womenEventRepository.findById(id).ifPresent(e -> {
            womenEventLifecycleService.transition(e, EventLifecycleStatus.APPROVED,
                    "ADMIN", null, "admin", "Approved");
            womenEventLifecycleService.transition(e, EventLifecycleStatus.PUBLISHED,
                    "ADMIN", null, "admin", "Published after approval");
        });
        ra.addFlashAttribute("success", "Event approved!");
        return "redirect:/women-events/admin/list";
    }

    @PostMapping("/admin/{id}/reject")
    public String rejectEvent(@PathVariable Long id, HttpSession session, RedirectAttributes ra) {
        if (session.getAttribute("admin") == null) return "redirect:/admin/loginAdmin";
        womenEventRepository.findById(id).ifPresent(e -> {
            womenEventLifecycleService.transition(e, EventLifecycleStatus.REJECTED,
                    "ADMIN", null, "admin", "Rejected");
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

    @PostMapping("/admin/{id}/request-changes")
    public String requestEventChanges(@PathVariable Long id,
                                      @RequestParam String reason,
                                      HttpSession session, RedirectAttributes ra) {
        if (session.getAttribute("admin") == null) return "redirect:/admin/loginAdmin";
        if (reason == null || reason.isBlank()) {
            ra.addFlashAttribute("error", "A reason is required when requesting changes.");
            return "redirect:/women-events/admin/list";
        }
        womenEventRepository.findById(id).ifPresent(e ->
                womenEventLifecycleService.transition(e, EventLifecycleStatus.CHANGES_REQUESTED,
                        "ADMIN", null, "admin", reason.trim()));
        ra.addFlashAttribute("success", "Changes requested. The host can update and resubmit.");
        return "redirect:/women-events/admin/list";
    }

    @PostMapping("/admin/{id}/unpublish")
    public String unpublishEvent(@PathVariable Long id, HttpSession session, RedirectAttributes ra) {
        if (session.getAttribute("admin") == null) return "redirect:/admin/loginAdmin";
        womenEventRepository.findById(id).ifPresent(e -> {
            e.setStatus("UNPUBLISHED");
            e.setLifecycleStatus(EventLifecycleStatus.APPROVED);
            womenEventRepository.save(e);
        });
        ra.addFlashAttribute("success", "Event unpublished.");
        return "redirect:/women-events/admin/list";
    }

    @PostMapping("/admin/{id}/cancel")
    public String adminCancelEvent(@PathVariable Long id, HttpSession session, RedirectAttributes ra) {
        if (session.getAttribute("admin") == null) return "redirect:/admin/loginAdmin";
        womenEventRepository.findById(id).ifPresent(e ->
                womenEventLifecycleService.transition(e, EventLifecycleStatus.CANCELLED,
                        "ADMIN", null, "admin", "Cancelled by admin"));
        ra.addFlashAttribute("success", "Event cancelled.");
        return "redirect:/women-events/admin/list";
    }

    @GetMapping("/tickets/{id}")
    public String digitalTicket(@PathVariable Long id, HttpSession session, Model model) {
        User loggedUser = (User) session.getAttribute("user");
        if (loggedUser == null) return "redirect:/login";
        WomenEventRegistration reg = womenEventRegistrationRepository.findById(id).orElse(null);
        if (reg == null || reg.getUser() == null || !reg.getUser().getId().equals(loggedUser.getId())) {
            return "redirect:/women-events/my-registrations";
        }
        model.addAttribute("reg", reg);
        model.addAttribute("event", reg.getEvent());
        model.addAttribute("loggedUser", loggedUser);
        model.addAttribute("user", loggedUser);
        boolean showAccess = reg.isPaid() || (reg.getEvent() != null && reg.getEvent().isFree())
                || womenEventBookingService.payableOf(reg) <= 0;
        model.addAttribute("streamLink",
                WomenEventSupport.hideAccessIfUnauthorized(reg.getEvent(), showAccess && !"CANCELLED".equalsIgnoreCase(reg.getStatus())));
        return "women-events/ticket";
    }

    @PostMapping("/{id}/save")
    public String toggleSave(@PathVariable Long id, HttpSession session, RedirectAttributes ra) {
        User loggedUser = (User) session.getAttribute("user");
        if (loggedUser == null) return "redirect:/login";
        WomenEvent event = womenEventRepository.findById(id).orElse(null);
        if (event == null) return "redirect:/women-events";
        eventFavoriteRepository.findByEventAndUser(event, loggedUser).ifPresentOrElse(
                fav -> {
                    eventFavoriteRepository.delete(fav);
                    ra.addFlashAttribute("success", "Removed from saved events.");
                },
                () -> {
                    EventFavorite fav = new EventFavorite();
                    fav.setEvent(event);
                    fav.setUser(loggedUser);
                    eventFavoriteRepository.save(fav);
                    ra.addFlashAttribute("success", "Event saved.");
                });
        return "redirect:/women-events/" + id;
    }

    @PostMapping("/organizer/{id}/submit")
    public String hostSubmitEvent(@PathVariable Long id, HttpSession session, RedirectAttributes ra) {
        EventHost host = checkAndGetHost(session);
        if (host == null) return "redirect:/women-events/host/login";
        if (!EventHostProfileService.isApproved(host)) {
            return redirectIfFeaturesLocked(host, ra, "Event features stay locked until admin profile approval.");
        }
        WomenEvent event = womenEventRepository.findById(id).orElse(null);
        if (event == null || event.getOrganizer() == null || !event.getOrganizer().getId().equals(host.getId())) {
            return "redirect:/women-events/organizer/dashboard";
        }
        womenEventLifecycleService.transition(event, EventLifecycleStatus.SUBMITTED,
                "EVENT_HOST", host.getId(), host.getEmail(), "Submitted for approval");
        ra.addFlashAttribute("success", "Event submitted for admin approval.");
        return "redirect:/women-events/organizer/dashboard";
    }
}
