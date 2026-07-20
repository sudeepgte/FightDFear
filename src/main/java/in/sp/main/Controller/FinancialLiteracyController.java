package in.sp.main.Controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import jakarta.servlet.ServletContext;
import jakarta.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/financial-literacy")
public class FinancialLiteracyController {

    @GetMapping
    public String financialLiteracyHome(HttpServletRequest request, Model model) {
        ServletContext servletContext = request.getServletContext();
        
        @SuppressWarnings("unchecked")
        List<Map<String, Object>> videos = (List<Map<String, Object>>) servletContext.getAttribute("flVideos");
        if (videos == null) {
            videos = new ArrayList<>();
            servletContext.setAttribute("flVideos", videos);
        }
        
        @SuppressWarnings("unchecked")
        List<Map<String, Object>> liveSessions = (List<Map<String, Object>>) servletContext.getAttribute("flLiveSessions");
        if (liveSessions == null) {
            liveSessions = new ArrayList<>();
            servletContext.setAttribute("flLiveSessions", liveSessions);
        }
        
        @SuppressWarnings("unchecked")
        List<Map<String, Object>> workshops = (List<Map<String, Object>>) servletContext.getAttribute("flWorkshops");
        if (workshops == null) {
            workshops = new ArrayList<>();
            servletContext.setAttribute("flWorkshops", workshops);
        }
        
        model.addAttribute("videos", videos);
        model.addAttribute("liveSessions", liveSessions);
        model.addAttribute("workshops", workshops);
        return "financial-literacy/financial-literacy-home";
    }

    @GetMapping("/video/{videoId}")
    public String videoDetails(@PathVariable String videoId, HttpServletRequest request, Model model) {
        ServletContext servletContext = request.getServletContext();
        @SuppressWarnings("unchecked")
        List<Map<String, Object>> videos = (List<Map<String, Object>>) servletContext.getAttribute("flVideos");
        if (videos == null) {
            videos = new ArrayList<>();
            servletContext.setAttribute("flVideos", videos);
        }
        
        Map<String, Object> selectedVideo = null;
        for (Map<String, Object> video : videos) {
            if (videoId.equals(video.get("id"))) {
                selectedVideo = video;
                // Convert video URL to embed URL
                String videoUrl = (String) video.get("videoUrl");
                if (videoUrl != null && !videoUrl.isEmpty()) {
                    String embedUrl = getYouTubeEmbedUrl(videoUrl);
                    selectedVideo.put("embedUrl", embedUrl);
                }
                break;
            }
        }
        model.addAttribute("video", selectedVideo);
        model.addAttribute("videos", videos);
        return "financial-literacy/video-details";
    }
    
    private String getYouTubeEmbedUrl(String url) {
        if (url == null || url.isEmpty()) {
            return "";
        }
        
        // Handle different YouTube URL formats
        String videoId = null;
        
        // Format: https://www.youtube.com/watch?v=VIDEO_ID
        if (url.contains("v=")) {
            int start = url.indexOf("v=") + 2;
            int end = url.indexOf("&", start);
            if (end == -1) {
                videoId = url.substring(start);
            } else {
                videoId = url.substring(start, end);
            }
        }
        // Format: https://youtu.be/VIDEO_ID
        else if (url.contains("youtu.be/")) {
            int start = url.indexOf("youtu.be/") + 9;
            int end = url.indexOf("?", start);
            if (end == -1) {
                videoId = url.substring(start);
            } else {
                videoId = url.substring(start, end);
            }
        }
        // Format: https://www.youtube.com/embed/VIDEO_ID
        else if (url.contains("/embed/")) {
            return url; // Already an embed URL
        }
        
        if (videoId != null && !videoId.isEmpty()) {
            return "https://www.youtube.com/embed/" + videoId;
        }
        
        return url; // Return original if we can't parse it
    }

    @GetMapping("/live-session/{sessionId}")
    public String liveSessionDetails(@PathVariable String sessionId, HttpServletRequest request, Model model) {
        ServletContext servletContext = request.getServletContext();
        @SuppressWarnings("unchecked")
        List<Map<String, Object>> liveSessions = (List<Map<String, Object>>) servletContext.getAttribute("flLiveSessions");
        if (liveSessions == null) {
            liveSessions = new ArrayList<>();
            servletContext.setAttribute("flLiveSessions", liveSessions);
        }
        
        Map<String, Object> selectedSession = null;
        for (Map<String, Object> session : liveSessions) {
            if (sessionId.equals(session.get("id"))) {
                selectedSession = session;
                break;
            }
        }
        
        // Check for user registration (for demo, we just check the list)
        @SuppressWarnings("unchecked")
        List<Map<String, Object>> liveRegistrations = (List<Map<String, Object>>) servletContext.getAttribute("flLiveSessionRegistrations");
        if (liveRegistrations != null) {
            for (Map<String, Object> reg : liveRegistrations) {
                if (sessionId.equals(reg.get("sessionId"))) {
                    model.addAttribute("userRegistration", reg);
                    break;
                }
            }
        }
        
        model.addAttribute("session", selectedSession);
        return "financial-literacy/live-session-details";
    }
    
    @PostMapping("/live-session/register")
    public String registerLiveSession(@RequestParam String sessionId, @RequestParam String fullName,
                                   @RequestParam String mobile, @RequestParam String email,
                                   @RequestParam(required = false) String occupation,
                                   HttpServletRequest request) {
        ServletContext servletContext = request.getServletContext();
        
        @SuppressWarnings("unchecked")
        List<Map<String, Object>> registrations = (List<Map<String, Object>>) servletContext.getAttribute("flLiveSessionRegistrations");
        if (registrations == null) {
            registrations = new ArrayList<>();
        }
        
        String id = java.util.UUID.randomUUID().toString();
        Map<String, Object> newRegistration = new HashMap<>();
        newRegistration.put("id", id);
        newRegistration.put("sessionId", sessionId);
        newRegistration.put("fullName", fullName);
        newRegistration.put("mobile", mobile);
        newRegistration.put("email", email);
        newRegistration.put("occupation", occupation);
        newRegistration.put("status", "pending"); // pending, approved, rejected
        registrations.add(newRegistration);
        
        servletContext.setAttribute("flLiveSessionRegistrations", registrations);
        return "redirect:/financial-literacy?registrationSuccess=true";
    }

    @GetMapping("/workshop/{workshopId}")
    public String workshopDetails(@PathVariable String workshopId, HttpServletRequest request, Model model) {
        ServletContext servletContext = request.getServletContext();
        @SuppressWarnings("unchecked")
        List<Map<String, Object>> workshops = (List<Map<String, Object>>) servletContext.getAttribute("flWorkshops");
        if (workshops == null) {
            workshops = new ArrayList<>();
            servletContext.setAttribute("flWorkshops", workshops);
        }
        
        Map<String, Object> selectedWorkshop = null;
        for (Map<String, Object> workshop : workshops) {
            if (workshopId.equals(workshop.get("id"))) {
                selectedWorkshop = workshop;
                break;
            }
        }
        
        // Check for user registration (for demo, we just check the list)
        @SuppressWarnings("unchecked")
        List<Map<String, Object>> workshopRegistrations = (List<Map<String, Object>>) servletContext.getAttribute("flWorkshopRegistrations");
        if (workshopRegistrations != null) {
            for (Map<String, Object> reg : workshopRegistrations) {
                if (workshopId.equals(reg.get("workshopId"))) {
                    model.addAttribute("userRegistration", reg);
                    break;
                }
            }
        }
        
        model.addAttribute("workshop", selectedWorkshop);
        return "financial-literacy/workshop-details";
    }

    // Admin Routes
    @GetMapping("/admin")
    public String adminHome(HttpServletRequest request, Model model) {
        ServletContext servletContext = request.getServletContext();
        
        @SuppressWarnings("unchecked")
        List<Map<String, Object>> videos = (List<Map<String, Object>>) servletContext.getAttribute("flVideos");
        if (videos == null) {
            videos = new ArrayList<>();
            servletContext.setAttribute("flVideos", videos);
        }
        
        @SuppressWarnings("unchecked")
        List<Map<String, Object>> liveSessions = (List<Map<String, Object>>) servletContext.getAttribute("flLiveSessions");
        if (liveSessions == null) {
            liveSessions = new ArrayList<>();
            servletContext.setAttribute("flLiveSessions", liveSessions);
        }
        
        @SuppressWarnings("unchecked")
        List<Map<String, Object>> workshops = (List<Map<String, Object>>) servletContext.getAttribute("flWorkshops");
        if (workshops == null) {
            workshops = new ArrayList<>();
            servletContext.setAttribute("flWorkshops", workshops);
        }
        
        model.addAttribute("videos", videos);
        model.addAttribute("liveSessions", liveSessions);
        model.addAttribute("workshops", workshops);
        return "financial-literacy/admin/admin-home";
    }

    @GetMapping("/admin/add-video")
    public String addVideoForm() {
        return "financial-literacy/admin/add-video";
    }

    @PostMapping("/admin/add-video")
    public String addVideoSubmit(@RequestParam String title, @RequestParam String category, 
                                @RequestParam String description, @RequestParam String videoUrl,
                                HttpServletRequest request) {
        ServletContext servletContext = request.getServletContext();
        @SuppressWarnings("unchecked")
        List<Map<String, Object>> videos = (List<Map<String, Object>>) servletContext.getAttribute("flVideos");
        if (videos == null) {
            videos = new ArrayList<>();
        }
        
        String id = title.toLowerCase().replace(" ", "-").replaceAll("[^a-z0-9-]", "");
        Map<String, Object> newVideo = new HashMap<>();
        newVideo.put("id", id);
        newVideo.put("title", title);
        newVideo.put("category", category);
        newVideo.put("description", description);
        newVideo.put("videoUrl", videoUrl);
        newVideo.put("duration", "15 mins");
        newVideo.put("level", "Beginner");
        videos.add(newVideo);
        
        servletContext.setAttribute("flVideos", videos);
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
                                    @RequestParam String description, HttpServletRequest request) {
        ServletContext servletContext = request.getServletContext();
        @SuppressWarnings("unchecked")
        List<Map<String, Object>> liveSessions = (List<Map<String, Object>>) servletContext.getAttribute("flLiveSessions");
        if (liveSessions == null) {
            liveSessions = new ArrayList<>();
        }
        
        String id = title.toLowerCase().replace(" ", "-").replaceAll("[^a-z0-9-]", "");
        Map<String, Object> newSession = new HashMap<>();
        newSession.put("id", id);
        newSession.put("title", title);
        newSession.put("speaker", speaker);
        newSession.put("date", date);
        newSession.put("time", time);
        newSession.put("meetingUrl", meetingUrl);
        newSession.put("seats", seats);
        newSession.put("description", description);
        liveSessions.add(newSession);
        
        servletContext.setAttribute("flLiveSessions", liveSessions);
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
                                @RequestParam String description, HttpServletRequest request) {
        ServletContext servletContext = request.getServletContext();
        @SuppressWarnings("unchecked")
        List<Map<String, Object>> workshops = (List<Map<String, Object>>) servletContext.getAttribute("flWorkshops");
        if (workshops == null) {
            workshops = new ArrayList<>();
        }
        
        String id = title.toLowerCase().replace(" ", "-").replaceAll("[^a-z0-9-]", "");
        Map<String, Object> newWorkshop = new HashMap<>();
        newWorkshop.put("id", id);
        newWorkshop.put("title", title);
        newWorkshop.put("venue", venue);
        newWorkshop.put("date", date);
        newWorkshop.put("time", time);
        newWorkshop.put("city", city);
        newWorkshop.put("seats", seats);
        newWorkshop.put("description", description);
        workshops.add(newWorkshop);
        
        servletContext.setAttribute("flWorkshops", workshops);
        return "redirect:/financial-literacy/admin";
    }
    
    @PostMapping("/workshop/register")
    public String registerWorkshop(@RequestParam String workshopId, @RequestParam String fullName,
                                   @RequestParam String mobile, @RequestParam String email,
                                   @RequestParam String city, @RequestParam(required = false) String occupation,
                                   HttpServletRequest request) {
        ServletContext servletContext = request.getServletContext();
        
        @SuppressWarnings("unchecked")
        List<Map<String, Object>> registrations = (List<Map<String, Object>>) servletContext.getAttribute("flWorkshopRegistrations");
        if (registrations == null) {
            registrations = new ArrayList<>();
        }
        
        String id = java.util.UUID.randomUUID().toString();
        Map<String, Object> newRegistration = new HashMap<>();
        newRegistration.put("id", id);
        newRegistration.put("workshopId", workshopId);
        newRegistration.put("fullName", fullName);
        newRegistration.put("mobile", mobile);
        newRegistration.put("email", email);
        newRegistration.put("city", city);
        newRegistration.put("occupation", occupation);
        newRegistration.put("status", "pending"); // pending, approved, rejected
        registrations.add(newRegistration);
        
        servletContext.setAttribute("flWorkshopRegistrations", registrations);
        return "redirect:/financial-literacy?registrationSuccess=true";
    }
    
    @GetMapping("/admin/registrations")
    public String adminRegistrations(HttpServletRequest request, Model model) {
        ServletContext servletContext = request.getServletContext();
        
        @SuppressWarnings("unchecked")
        List<Map<String, Object>> workshops = (List<Map<String, Object>>) servletContext.getAttribute("flWorkshops");
        if (workshops == null) {
            workshops = new ArrayList<>();
            servletContext.setAttribute("flWorkshops", workshops);
        }
        
        @SuppressWarnings("unchecked")
        List<Map<String, Object>> liveSessions = (List<Map<String, Object>>) servletContext.getAttribute("flLiveSessions");
        if (liveSessions == null) {
            liveSessions = new ArrayList<>();
            servletContext.setAttribute("flLiveSessions", liveSessions);
        }
        
        @SuppressWarnings("unchecked")
        List<Map<String, Object>> workshopRegistrations = (List<Map<String, Object>>) servletContext.getAttribute("flWorkshopRegistrations");
        if (workshopRegistrations == null) {
            workshopRegistrations = new ArrayList<>();
        }
        
        @SuppressWarnings("unchecked")
        List<Map<String, Object>> liveSessionRegistrations = (List<Map<String, Object>>) servletContext.getAttribute("flLiveSessionRegistrations");
        if (liveSessionRegistrations == null) {
            liveSessionRegistrations = new ArrayList<>();
        }
        
        model.addAttribute("workshops", workshops);
        model.addAttribute("liveSessions", liveSessions);
        model.addAttribute("workshopRegistrations", workshopRegistrations);
        model.addAttribute("liveSessionRegistrations", liveSessionRegistrations);
        return "financial-literacy/admin/registrations";
    }
    
    @PostMapping("/admin/registration/approve")
    public String approveRegistration(@RequestParam String registrationId, @RequestParam String type, HttpServletRequest request) {
        ServletContext servletContext = request.getServletContext();
        
        String attrName = "workshop".equals(type) ? "flWorkshopRegistrations" : "flLiveSessionRegistrations";
        
        @SuppressWarnings("unchecked")
        List<Map<String, Object>> registrations = (List<Map<String, Object>>) servletContext.getAttribute(attrName);
        if (registrations != null) {
            for (Map<String, Object> registration : registrations) {
                if (registrationId.equals(registration.get("id"))) {
                    registration.put("status", "approved");
                    break;
                }
            }
            servletContext.setAttribute(attrName, registrations);
        }
        
        return "redirect:/financial-literacy/admin/registrations";
    }
    
    @PostMapping("/admin/registration/reject")
    public String rejectRegistration(@RequestParam String registrationId, @RequestParam String type, HttpServletRequest request) {
        ServletContext servletContext = request.getServletContext();
        
        String attrName = "workshop".equals(type) ? "flWorkshopRegistrations" : "flLiveSessionRegistrations";
        
        @SuppressWarnings("unchecked")
        List<Map<String, Object>> registrations = (List<Map<String, Object>>) servletContext.getAttribute(attrName);
        if (registrations != null) {
            for (Map<String, Object> registration : registrations) {
                if (registrationId.equals(registration.get("id"))) {
                    registration.put("status", "rejected");
                    break;
                }
            }
            servletContext.setAttribute(attrName, registrations);
        }
        
        return "redirect:/financial-literacy/admin/registrations";
    }


}
