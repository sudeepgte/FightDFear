package in.sp.main.Controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import in.sp.main.Entities.FinancialEnrollment;
import in.sp.main.Entities.FinancialLiveSession;
import in.sp.main.Entities.FinancialVideo;
import in.sp.main.Entities.FinancialWorkshop;
import in.sp.main.Entities.User;
import in.sp.main.Service.FinancialLiteracyCatalogService;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/financial-literacy")
public class FinancialLiteracyController {

    @Autowired
    private FinancialLiteracyCatalogService catalog;

    @GetMapping
    public String financialLiteracyHome(Model model) {
        model.addAttribute("videos", catalog.publicVideos());
        model.addAttribute("liveSessions", catalog.publicLiveSessions());
        model.addAttribute("workshops", catalog.publicWorkshops());
        return "financial-literacy/financial-literacy-home";
    }

    @GetMapping("/video/{videoId}")
    public String videoDetails(@PathVariable String videoId, Model model) {
        FinancialVideo v = catalog.findVideo(videoId);
        model.addAttribute("video", v == null || !catalog.isPublicVideo(v) ? null : catalog.videoMap(v, true));
        model.addAttribute("videos", catalog.publicVideos());
        return "financial-literacy/video-details";
    }

    @GetMapping("/live-session/{sessionId}")
    public String liveSessionDetails(@PathVariable String sessionId, HttpSession httpSession, Model model) {
        FinancialLiveSession s = catalog.findLive(sessionId);
        model.addAttribute("session", s == null || !catalog.isPublicLive(s) ? null : catalog.liveMap(s));
        User user = httpSession == null ? null : (User) httpSession.getAttribute("user");
        if (user != null && s != null) {
            catalog.liveRegistrations().stream()
                    .filter(r -> sessionId.equals(String.valueOf(r.get("sessionId")))
                            && user.getEmail() != null && user.getEmail().equalsIgnoreCase(String.valueOf(r.get("email"))))
                    .findFirst()
                    .ifPresent(r -> model.addAttribute("userRegistration", r));
        }
        return "financial-literacy/live-session-details";
    }

    @PostMapping("/live-session/register")
    public String registerLiveSession(@RequestParam String sessionId, @RequestParam String fullName,
                                      @RequestParam String mobile, @RequestParam String email,
                                      @RequestParam(required = false) String occupation,
                                      HttpSession httpSession) {
        User user = httpSession == null ? null : (User) httpSession.getAttribute("user");
        try {
            catalog.registerLive(sessionId, user, fullName, mobile, email, occupation);
        } catch (Exception ignored) {
            return "redirect:/financial-literacy?registrationSuccess=false";
        }
        return "redirect:/financial-literacy?registrationSuccess=true";
    }

    @GetMapping("/workshop/{workshopId}")
    public String workshopDetails(@PathVariable String workshopId, HttpSession httpSession, Model model) {
        FinancialWorkshop w = catalog.findWorkshop(workshopId);
        model.addAttribute("workshop", w == null || !catalog.isPublicWorkshop(w) ? null : catalog.workshopMap(w));
        User user = httpSession == null ? null : (User) httpSession.getAttribute("user");
        if (user != null && w != null) {
            catalog.workshopRegistrations().stream()
                    .filter(r -> workshopId.equals(String.valueOf(r.get("workshopId")))
                            && user.getEmail() != null && user.getEmail().equalsIgnoreCase(String.valueOf(r.get("email"))))
                    .findFirst()
                    .ifPresent(r -> model.addAttribute("userRegistration", r));
        }
        return "financial-literacy/workshop-details";
    }

    @GetMapping("/admin")
    public String adminHome(Model model) {
        model.addAttribute("videos", catalog.publicVideos());
        model.addAttribute("liveSessions", catalog.publicLiveSessions());
        model.addAttribute("workshops", catalog.publicWorkshops());
        return "financial-literacy/admin/admin-home";
    }

    @GetMapping("/admin/add-video")
    public String addVideoForm() {
        return "financial-literacy/admin/add-video";
    }

    @PostMapping("/admin/add-video")
    public String addVideoSubmit(@RequestParam String title, @RequestParam String category,
                                 @RequestParam String description, @RequestParam String videoUrl) {
        catalog.addVideo(title, category, description, videoUrl, null);
        return "redirect:/financial-literacy/admin";
    }

    @GetMapping("/admin/add-live-session")
    public String addLiveSessionForm() {
        return "financial-literacy/admin/add-live-session";
    }

    @PostMapping("/admin/add-live-session")
    public String addLiveSessionSubmit(@RequestParam String title, @RequestParam String speaker,
                                       @RequestParam String date, @RequestParam String time,
                                       @RequestParam String meetingUrl, @RequestParam int seats,
                                       @RequestParam String description) {
        catalog.addLive(title, speaker, date, time, meetingUrl, seats, description, null);
        return "redirect:/financial-literacy/admin";
    }

    @GetMapping("/admin/add-workshop")
    public String addWorkshopForm() {
        return "financial-literacy/admin/add-workshop";
    }

    @PostMapping("/admin/add-workshop")
    public String addWorkshopSubmit(@RequestParam String title, @RequestParam String venue,
                                    @RequestParam String date, @RequestParam String time,
                                    @RequestParam String city, @RequestParam int seats,
                                    @RequestParam String description) {
        catalog.addWorkshop(title, venue, date, time, city, seats, description, null);
        return "redirect:/financial-literacy/admin";
    }

    @PostMapping("/workshop/register")
    public String registerWorkshop(@RequestParam String workshopId, @RequestParam String fullName,
                                   @RequestParam String mobile, @RequestParam String email,
                                   @RequestParam String city, @RequestParam(required = false) String occupation,
<<<<<<< HEAD
                                   HttpServletRequest request,
                                   org.springframework.web.servlet.mvc.support.RedirectAttributes ra) {
        String cleanedWorkshopId = workshopId == null ? "" : workshopId.trim();
        if (cleanedWorkshopId.isEmpty()) {
            ra.addFlashAttribute("error", "Invalid workshop. Please try again.");
            return "redirect:/financial-literacy";
        }

        String cleanedName = fullName == null ? "" : fullName.trim();
        if (cleanedName.length() < 2 || cleanedName.length() > 80
                || !cleanedName.matches("^[A-Za-z][A-Za-z .'-]{1,79}$")) {
            ra.addFlashAttribute("error",
                    "Full Name must be 2–80 letters only (spaces, apostrophes, periods, and hyphens allowed).");
            return "redirect:/financial-literacy/workshop/" + cleanedWorkshopId;
        }

        String cleanedMobile = mobile == null ? "" : mobile.trim().replaceAll("\\s+", "");
        if (!cleanedMobile.matches("^\\d{10}$")) {
            ra.addFlashAttribute("error", "Mobile number must be exactly 10 digits.");
            return "redirect:/financial-literacy/workshop/" + cleanedWorkshopId;
        }

        String cleanedEmail = email == null ? "" : email.trim().toLowerCase();
        if (cleanedEmail.isEmpty() || cleanedEmail.length() > 100
                || !cleanedEmail.matches("^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$")) {
            ra.addFlashAttribute("error", "Please enter a valid email address.");
            return "redirect:/financial-literacy/workshop/" + cleanedWorkshopId;
        }

        String cleanedCity = city == null ? "" : city.trim();
        if (cleanedCity.length() < 2 || cleanedCity.length() > 80
                || !cleanedCity.matches("^[A-Za-z][A-Za-z .'-]{1,79}$")) {
            ra.addFlashAttribute("error",
                    "City must be 2–80 letters only (spaces, apostrophes, periods, and hyphens allowed).");
            return "redirect:/financial-literacy/workshop/" + cleanedWorkshopId;
        }

        String cleanedOccupation = occupation == null ? "" : occupation.trim();
        if (cleanedOccupation.length() > 100) {
            ra.addFlashAttribute("error", "Occupation must be at most 100 characters.");
            return "redirect:/financial-literacy/workshop/" + cleanedWorkshopId;
        }

        ServletContext servletContext = request.getServletContext();

        @SuppressWarnings("unchecked")
        List<Map<String, Object>> registrations = (List<Map<String, Object>>) servletContext.getAttribute("flWorkshopRegistrations");
        if (registrations == null) {
            registrations = new ArrayList<>();
        }

        String id = java.util.UUID.randomUUID().toString();
        Map<String, Object> newRegistration = new HashMap<>();
        newRegistration.put("id", id);
        newRegistration.put("workshopId", cleanedWorkshopId);
        newRegistration.put("fullName", cleanedName);
        newRegistration.put("mobile", cleanedMobile);
        newRegistration.put("email", cleanedEmail);
        newRegistration.put("city", cleanedCity);
        newRegistration.put("occupation", cleanedOccupation.isEmpty() ? null : cleanedOccupation);
        newRegistration.put("status", "pending");
        registrations.add(newRegistration);

        servletContext.setAttribute("flWorkshopRegistrations", registrations);
        ra.addFlashAttribute("message", "Registration submitted successfully! We will contact you soon.");
        return "redirect:/financial-literacy/workshop/" + cleanedWorkshopId;
=======
                                   HttpSession httpSession) {
        User user = httpSession == null ? null : (User) httpSession.getAttribute("user");
        try {
            catalog.registerWorkshop(workshopId, user, fullName, mobile, email, city, occupation);
        } catch (Exception ignored) {
            return "redirect:/financial-literacy?registrationSuccess=false";
        }
        return "redirect:/financial-literacy?registrationSuccess=true";
>>>>>>> origin/main
    }

    @GetMapping("/admin/registrations")
    public String adminRegistrations(Model model) {
        model.addAttribute("workshops", catalog.publicWorkshops());
        model.addAttribute("liveSessions", catalog.publicLiveSessions());
        model.addAttribute("workshopRegistrations", catalog.workshopRegistrations());
        model.addAttribute("liveSessionRegistrations", catalog.liveRegistrations());
        return "financial-literacy/admin/registrations";
    }

    @PostMapping("/admin/registration/approve")
    public String approveRegistration(@RequestParam String registrationId, @RequestParam String type) {
        FinancialEnrollment e = catalog.findEnrollment(registrationId);
        if (e != null) catalog.setEnrollmentStatus(e.getId(), "approved");
        return "redirect:/financial-literacy/admin/registrations";
    }

    @PostMapping("/admin/registration/reject")
    public String rejectRegistration(@RequestParam String registrationId, @RequestParam String type) {
        FinancialEnrollment e = catalog.findEnrollment(registrationId);
        if (e != null) catalog.setEnrollmentStatus(e.getId(), "rejected");
        return "redirect:/financial-literacy/admin/registrations";
    }
}
