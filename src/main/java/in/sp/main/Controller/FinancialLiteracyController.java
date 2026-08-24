package in.sp.main.Controller;

import java.util.List;
import java.util.Map;
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
import in.sp.main.Service.FileUploadService;
import org.springframework.web.multipart.MultipartFile;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/financial-literacy")
public class FinancialLiteracyController {

    @Autowired
    private FinancialLiteracyCatalogService catalog;

    @Autowired
    private FileUploadService fileUploadService;

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
            return "redirect:/financial-literacy/live-session/" + sessionId + "?registrationSuccess=false";
        }
        return "redirect:/financial-literacy/live-session/" + sessionId + "?registrationSuccess=true";
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
        List<Map<String, Object>> videos = catalog.publicVideos();
        List<Map<String, Object>> liveSessions = catalog.publicLiveSessions();
        List<Map<String, Object>> workshops = catalog.publicWorkshops();

        long upcomingCount = liveSessions.stream()
                .filter(s -> "UPCOMING".equalsIgnoreCase(String.valueOf(s.get("sessionStatus"))) || "LIVE NOW".equalsIgnoreCase(String.valueOf(s.get("sessionStatus"))))
                .count();

        model.addAttribute("videos", videos);
        model.addAttribute("liveSessions", liveSessions);
        model.addAttribute("workshops", workshops);

        model.addAttribute("videoCount", videos.size());
        model.addAttribute("liveCount", liveSessions.size());
        model.addAttribute("workshopCount", workshops.size());
        model.addAttribute("upcomingCount", upcomingCount);

        return "financial-literacy/admin/admin-home";
    }

    @GetMapping("/admin/add-video")
    public String addVideoForm() {
        return "financial-literacy/admin/add-video";
    }

    @PostMapping("/admin/add-video")
    public String addVideoSubmit(@RequestParam(value = "title", required = false) String title,
                                 @RequestParam(value = "category", required = false) String category,
                                 @RequestParam(value = "customCategory", required = false) String customCategory,
                                 @RequestParam(value = "description", required = false) String description, 
                                 @RequestParam(value = "videoUrl", required = false) String videoUrl,
                                 @RequestParam(value = "videoFile", required = false) MultipartFile videoFile,
                                 org.springframework.web.servlet.mvc.support.RedirectAttributes redirectAttributes,
                                 Model model) {
        
        if (title == null || title.isBlank()) {
            model.addAttribute("error", "Video Title cannot be empty.");
            model.addAttribute("title", title);
            model.addAttribute("category", category);
            model.addAttribute("customCategory", customCategory);
            model.addAttribute("description", description);
            model.addAttribute("videoUrl", videoUrl);
            return "financial-literacy/admin/add-video";
        }
        if (description == null || description.isBlank()) {
            model.addAttribute("error", "Description cannot be empty.");
            model.addAttribute("title", title);
            model.addAttribute("category", category);
            model.addAttribute("customCategory", customCategory);
            model.addAttribute("description", description);
            model.addAttribute("videoUrl", videoUrl);
            return "financial-literacy/admin/add-video";
        }
        if (category == null || category.isBlank()) {
            model.addAttribute("error", "Category cannot be empty.");
            model.addAttribute("title", title);
            model.addAttribute("category", category);
            model.addAttribute("customCategory", customCategory);
            model.addAttribute("description", description);
            model.addAttribute("videoUrl", videoUrl);
            return "financial-literacy/admin/add-video";
        }
        if ("Others".equalsIgnoreCase(category.trim()) && (customCategory == null || customCategory.isBlank())) {
            model.addAttribute("error", "Enter Category cannot be empty when 'Others' is selected.");
            model.addAttribute("title", title);
            model.addAttribute("category", category);
            model.addAttribute("customCategory", customCategory);
            model.addAttribute("description", description);
            model.addAttribute("videoUrl", videoUrl);
            return "financial-literacy/admin/add-video";
        }

        String finalUrl = videoUrl != null ? videoUrl.trim() : "";
        try {
            if (videoFile != null && !videoFile.isEmpty()) {
                finalUrl = fileUploadService.saveFile(videoFile);
            }
        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("error", "Failed to upload video file: " + e.getMessage());
            return "financial-literacy/admin/add-video";
        }

        if (finalUrl.isBlank()) {
            model.addAttribute("error", "Video URL / uploaded video cannot be empty.");
            model.addAttribute("title", title);
            model.addAttribute("category", category);
            model.addAttribute("customCategory", customCategory);
            model.addAttribute("description", description);
            return "financial-literacy/admin/add-video";
        }
        
        try {
            catalog.addVideo(title, category, customCategory, description, finalUrl, null);
        } catch (Exception ex) {
            model.addAttribute("error", ex.getMessage());
            return "financial-literacy/admin/add-video";
        }
        
        redirectAttributes.addFlashAttribute("successMessage", "Recorded Video added successfully!");
        return "redirect:/financial-literacy/admin";
    }

    @GetMapping("/admin/edit-video/{videoId}")
    public String editVideoForm(@PathVariable String videoId, Model model) {
        FinancialVideo v = catalog.findVideo(videoId);
        if (v == null) {
            return "redirect:/financial-literacy/admin";
        }
        model.addAttribute("video", v);
        model.addAttribute("title", v.getTitle());
        model.addAttribute("category", v.getCategory());
        model.addAttribute("customCategory", v.getCustomCategory());
        model.addAttribute("description", v.getDescription());
        model.addAttribute("videoUrl", v.getVideoUrl());
        return "financial-literacy/admin/edit-video";
    }

    @PostMapping("/admin/edit-video/{videoId}")
    public String editVideoSubmit(@PathVariable String videoId,
                                  @RequestParam(value = "title", required = false) String title,
                                  @RequestParam(value = "category", required = false) String category,
                                  @RequestParam(value = "customCategory", required = false) String customCategory,
                                  @RequestParam(value = "description", required = false) String description,
                                  @RequestParam(value = "videoUrl", required = false) String videoUrl,
                                  @RequestParam(value = "videoFile", required = false) MultipartFile videoFile,
                                  org.springframework.web.servlet.mvc.support.RedirectAttributes redirectAttributes,
                                  Model model) {
        FinancialVideo v = catalog.findVideo(videoId);
        if (v == null) {
            redirectAttributes.addFlashAttribute("error", "Video not found.");
            return "redirect:/financial-literacy/admin";
        }

        if (title == null || title.isBlank()) {
            model.addAttribute("error", "Video Title cannot be empty.");
            model.addAttribute("video", v);
            model.addAttribute("title", title);
            model.addAttribute("category", category);
            model.addAttribute("customCategory", customCategory);
            model.addAttribute("description", description);
            model.addAttribute("videoUrl", videoUrl);
            return "financial-literacy/admin/edit-video";
        }
        if (description == null || description.isBlank()) {
            model.addAttribute("error", "Description cannot be empty.");
            model.addAttribute("video", v);
            model.addAttribute("title", title);
            model.addAttribute("category", category);
            model.addAttribute("customCategory", customCategory);
            model.addAttribute("description", description);
            model.addAttribute("videoUrl", videoUrl);
            return "financial-literacy/admin/edit-video";
        }
        if (category == null || category.isBlank()) {
            model.addAttribute("error", "Category cannot be empty.");
            model.addAttribute("video", v);
            model.addAttribute("title", title);
            model.addAttribute("category", category);
            model.addAttribute("customCategory", customCategory);
            model.addAttribute("description", description);
            model.addAttribute("videoUrl", videoUrl);
            return "financial-literacy/admin/edit-video";
        }
        if ("Others".equalsIgnoreCase(category.trim()) && (customCategory == null || customCategory.isBlank())) {
            model.addAttribute("error", "Enter Category cannot be empty when 'Others' is selected.");
            model.addAttribute("video", v);
            model.addAttribute("title", title);
            model.addAttribute("category", category);
            model.addAttribute("customCategory", customCategory);
            model.addAttribute("description", description);
            model.addAttribute("videoUrl", videoUrl);
            return "financial-literacy/admin/edit-video";
        }

        String finalUrl = videoUrl != null ? videoUrl.trim() : "";
        try {
            if (videoFile != null && !videoFile.isEmpty()) {
                finalUrl = fileUploadService.saveFile(videoFile);
            }
        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("error", "Failed to upload video file: " + e.getMessage());
            model.addAttribute("video", v);
            return "financial-literacy/admin/edit-video";
        }

        if (finalUrl.isBlank() && (v.getVideoUrl() != null && !v.getVideoUrl().isBlank())) {
            finalUrl = v.getVideoUrl();
        }

        if (finalUrl.isBlank()) {
            model.addAttribute("error", "Video URL / uploaded video cannot be empty.");
            model.addAttribute("video", v);
            model.addAttribute("title", title);
            model.addAttribute("category", category);
            model.addAttribute("customCategory", customCategory);
            model.addAttribute("description", description);
            return "financial-literacy/admin/edit-video";
        }

        try {
            catalog.updateVideo(v.getId(), title, category, customCategory, description, finalUrl);
        } catch (Exception ex) {
            model.addAttribute("error", ex.getMessage());
            model.addAttribute("video", v);
            return "financial-literacy/admin/edit-video";
        }

        redirectAttributes.addFlashAttribute("successMessage", "Recorded Video updated successfully!");
        return "redirect:/financial-literacy/admin";
    }

    @PostMapping("/admin/delete-video/{videoId}")
    public String deleteVideo(@PathVariable String videoId, org.springframework.web.servlet.mvc.support.RedirectAttributes redirectAttributes) {
        try {
            Long id = Long.parseLong(videoId);
            boolean deleted = catalog.deleteVideo(id);
            if (deleted) {
                redirectAttributes.addFlashAttribute("successMessage", "Recorded Video deleted successfully!");
            } else {
                redirectAttributes.addFlashAttribute("error", "Video not found or already deleted.");
            }
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Failed to delete video: " + e.getMessage());
        }
        return "redirect:/financial-literacy/admin";
    }

    @GetMapping("/admin/add-live-session")
    public String addLiveSessionForm() {
        return "financial-literacy/admin/add-live-session";
    }

    @PostMapping("/admin/add-live-session")
    public String addLiveSessionSubmit(@RequestParam String title, @RequestParam String speaker,
                                       @RequestParam(value = "category", required = false) String category,
                                       @RequestParam(value = "customCategory", required = false) String customCategory,
                                       @RequestParam String date,
                                       @RequestParam(value = "startTime", required = false) String startTime,
                                       @RequestParam(value = "endTime", required = false) String endTime,
                                       @RequestParam(value = "time", required = false) String time,
                                       @RequestParam String meetingUrl, @RequestParam int seats,
                                       @RequestParam String description,
                                       org.springframework.web.servlet.mvc.support.RedirectAttributes redirectAttributes) {
        String finalTime = time;
        if ((finalTime == null || finalTime.isBlank()) && startTime != null && !startTime.isBlank()) {
            if (endTime != null && !endTime.isBlank()) {
                finalTime = startTime + " - " + endTime;
            } else {
                finalTime = startTime;
            }
        }
        try {
            catalog.addLive(title, speaker, date, finalTime, meetingUrl, seats, description, null, null, category, customCategory);
            redirectAttributes.addFlashAttribute("successMessage", "Live Session published successfully!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Failed to publish live session: " + e.getMessage());
        }
        return "redirect:/financial-literacy/admin";
    }

    @GetMapping("/admin/edit-live-session/{sessionId}")
    public String editLiveSessionForm(@PathVariable String sessionId, Model model) {
        FinancialLiveSession s = catalog.findLive(sessionId);
        if (s == null) {
            return "redirect:/financial-literacy/admin";
        }
        model.addAttribute("session", s);
        model.addAttribute("title", s.getTitle());
        model.addAttribute("speaker", s.getSpeaker());
        model.addAttribute("category", s.getCategory());
        model.addAttribute("customCategory", s.getCustomCategory());
        model.addAttribute("date", s.getDate());
        
        String timeVal = s.getTime() == null ? "" : s.getTime();
        String startTime = timeVal;
        String endTime = "";
        if (timeVal.contains(" - ")) {
            String[] parts = timeVal.split(" - ");
            startTime = parts[0].trim();
            endTime = parts.length > 1 ? parts[1].trim() : "";
        }
        model.addAttribute("startTime", startTime);
        model.addAttribute("endTime", endTime);
        model.addAttribute("time", timeVal);
        model.addAttribute("meetingUrl", s.getMeetingUrl());
        model.addAttribute("seats", s.getSeats());
        model.addAttribute("description", s.getDescription());
        return "financial-literacy/admin/edit-live-session";
    }

    @PostMapping("/admin/edit-live-session/{sessionId}")
    public String editLiveSessionSubmit(@PathVariable String sessionId,
                                        @RequestParam String title, @RequestParam String speaker,
                                        @RequestParam(value = "category", required = false) String category,
                                        @RequestParam(value = "customCategory", required = false) String customCategory,
                                        @RequestParam String date,
                                        @RequestParam(value = "startTime", required = false) String startTime,
                                        @RequestParam(value = "endTime", required = false) String endTime,
                                        @RequestParam(value = "time", required = false) String time,
                                        @RequestParam String meetingUrl, @RequestParam int seats,
                                        @RequestParam String description,
                                        org.springframework.web.servlet.mvc.support.RedirectAttributes redirectAttributes) {
        FinancialLiveSession s = catalog.findLive(sessionId);
        if (s == null) {
            redirectAttributes.addFlashAttribute("error", "Live session not found.");
            return "redirect:/financial-literacy/admin";
        }

        String finalTime = time;
        if ((finalTime == null || finalTime.isBlank()) && startTime != null && !startTime.isBlank()) {
            if (endTime != null && !endTime.isBlank()) {
                finalTime = startTime + " - " + endTime;
            } else {
                finalTime = startTime;
            }
        }

        try {
            catalog.updateLive(s.getId(), title, speaker, date, finalTime, meetingUrl, seats, description, category, customCategory);
            redirectAttributes.addFlashAttribute("successMessage", "Live Session updated successfully!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Failed to update live session: " + e.getMessage());
        }
        return "redirect:/financial-literacy/admin";
    }

    @PostMapping("/admin/delete-live-session/{sessionId}")
    public String deleteLiveSession(@PathVariable String sessionId, org.springframework.web.servlet.mvc.support.RedirectAttributes redirectAttributes) {
        try {
            Long id = Long.parseLong(sessionId);
            boolean deleted = catalog.deleteLive(id);
            if (deleted) {
                redirectAttributes.addFlashAttribute("successMessage", "Live Session deleted successfully!");
            } else {
                redirectAttributes.addFlashAttribute("error", "Live session not found or already deleted.");
            }
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Failed to delete live session: " + e.getMessage());
        }
        return "redirect:/financial-literacy/admin";
    }

    @GetMapping("/admin/add-workshop")
    public String addWorkshopForm() {
        return "financial-literacy/admin/add-workshop";
    }

    @PostMapping("/admin/add-workshop")
    public String addWorkshopSubmit(@RequestParam String title, @RequestParam String venue,
                                    @RequestParam(value = "category", required = false) String category,
                                    @RequestParam(value = "customCategory", required = false) String customCategory,
                                    @RequestParam String date,
                                    @RequestParam(value = "startTime", required = false) String startTime,
                                    @RequestParam(value = "endTime", required = false) String endTime,
                                    @RequestParam(value = "time", required = false) String time,
                                    @RequestParam String city, @RequestParam int seats,
                                    @RequestParam String description,
                                    org.springframework.web.servlet.mvc.support.RedirectAttributes redirectAttributes) {
        String finalTime = time;
        if ((finalTime == null || finalTime.isBlank()) && startTime != null && !startTime.isBlank()) {
            if (endTime != null && !endTime.isBlank()) {
                finalTime = startTime + " - " + endTime;
            } else {
                finalTime = startTime;
            }
        }
        try {
            catalog.addWorkshop(title, venue, date, finalTime, city, seats, description, null, null, category, customCategory);
            redirectAttributes.addFlashAttribute("successMessage", "Offline Workshop published successfully!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Failed to publish workshop: " + e.getMessage());
        }
        return "redirect:/financial-literacy/admin";
    }

    @GetMapping("/admin/edit-workshop/{workshopId}")
    public String editWorkshopForm(@PathVariable String workshopId, Model model) {
        FinancialWorkshop w = catalog.findWorkshop(workshopId);
        if (w == null) {
            return "redirect:/financial-literacy/admin";
        }
        model.addAttribute("workshop", w);
        model.addAttribute("title", w.getTitle());
        model.addAttribute("venue", w.getVenue());
        model.addAttribute("category", w.getCategory());
        model.addAttribute("customCategory", w.getCustomCategory());
        model.addAttribute("date", w.getDate());
        model.addAttribute("city", w.getCity());
        model.addAttribute("seats", w.getSeats());
        model.addAttribute("description", w.getDescription());
        
        String timeVal = w.getTime() == null ? "" : w.getTime();
        String startTime = timeVal;
        String endTime = "";
        if (timeVal.contains(" - ")) {
            String[] parts = timeVal.split(" - ");
            startTime = parts[0].trim();
            endTime = parts.length > 1 ? parts[1].trim() : "";
        }
        model.addAttribute("startTime", startTime);
        model.addAttribute("endTime", endTime);
        model.addAttribute("time", timeVal);
        return "financial-literacy/admin/edit-workshop";
    }

    @PostMapping("/admin/edit-workshop/{workshopId}")
    public String editWorkshopSubmit(@PathVariable String workshopId,
                                     @RequestParam String title, @RequestParam String venue,
                                     @RequestParam(value = "category", required = false) String category,
                                     @RequestParam(value = "customCategory", required = false) String customCategory,
                                     @RequestParam String date,
                                     @RequestParam(value = "startTime", required = false) String startTime,
                                     @RequestParam(value = "endTime", required = false) String endTime,
                                     @RequestParam(value = "time", required = false) String time,
                                     @RequestParam String city, @RequestParam int seats,
                                     @RequestParam String description,
                                     org.springframework.web.servlet.mvc.support.RedirectAttributes redirectAttributes) {
        FinancialWorkshop w = catalog.findWorkshop(workshopId);
        if (w == null) {
            redirectAttributes.addFlashAttribute("error", "Workshop not found.");
            return "redirect:/financial-literacy/admin";
        }

        String finalTime = time;
        if ((finalTime == null || finalTime.isBlank()) && startTime != null && !startTime.isBlank()) {
            if (endTime != null && !endTime.isBlank()) {
                finalTime = startTime + " - " + endTime;
            } else {
                finalTime = startTime;
            }
        }

        try {
            catalog.updateWorkshop(w.getId(), title, venue, date, finalTime, city, seats, description, category, customCategory);
            redirectAttributes.addFlashAttribute("successMessage", "Offline Workshop updated successfully!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Failed to update workshop: " + e.getMessage());
        }
        return "redirect:/financial-literacy/admin";
    }

    @PostMapping("/admin/delete-workshop/{workshopId}")
    public String deleteWorkshop(@PathVariable String workshopId, org.springframework.web.servlet.mvc.support.RedirectAttributes redirectAttributes) {
        try {
            Long id = Long.parseLong(workshopId);
            boolean deleted = catalog.deleteWorkshop(id);
            if (deleted) {
                redirectAttributes.addFlashAttribute("successMessage", "Offline Workshop deleted successfully!");
            } else {
                redirectAttributes.addFlashAttribute("error", "Workshop not found or already deleted.");
            }
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Failed to delete workshop: " + e.getMessage());
        }
        return "redirect:/financial-literacy/admin";
    }

    @PostMapping("/workshop/register")
    public String registerWorkshop(@RequestParam String workshopId, @RequestParam String fullName,
                                   @RequestParam String mobile, @RequestParam String email,
                                   @RequestParam String city, @RequestParam(required = false) String occupation,
                                   HttpSession httpSession) {
        User user = httpSession == null ? null : (User) httpSession.getAttribute("user");
        try {
            catalog.registerWorkshop(workshopId, user, fullName, mobile, email, city, occupation);
        } catch (Exception ignored) {
            return "redirect:/financial-literacy?registrationSuccess=false";
        }
        return "redirect:/financial-literacy?registrationSuccess=true";
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
