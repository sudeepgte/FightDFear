package in.sp.main.Controller;

import java.io.File;
import java.io.IOException;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import in.sp.main.Entities.*;
import in.sp.main.Service.*;
import jakarta.servlet.ServletContext;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/video")
public class VideoController {

    @Autowired
    private VideoService videoService;

    @Autowired
    private ServletContext servletContext;

    @Autowired
    private FileUploadService fileService;

    // Show Upload Video Page
    @RequestMapping(value = "/uploadVideo", method = RequestMethod.GET)
    public String showUploadVideoPage(Model model, HttpSession session) {
        if (session.getAttribute("admin") == null && session.getAttribute("user") == null) {
            return "redirect:/login";
        }
        model.addAttribute("categories", Category.values());
        return "uploadVideo";
    }

    // Uploads a video
    @RequestMapping(value = "/uploadingVideo", method = RequestMethod.POST)
    public String uploadVideo(@RequestParam String title,
                              @RequestParam Category category,
                              @RequestParam(value = "isReel", defaultValue = "false") boolean isReel,
                              @RequestParam("videoFile") MultipartFile file,
                              HttpSession session,
                              RedirectAttributes redirectAttributes) {
        if (file.isEmpty()) {
            redirectAttributes.addFlashAttribute("message", "Please select a video file to upload.");
            return "redirect:/video/uploadVideo";
        }

        try {
            String uploadDir = servletContext.getRealPath("/uploads/");
            File uploadFolder = new File(uploadDir);
            if (!uploadFolder.exists()) {
                uploadFolder.mkdirs();
            }

            String fileName = System.currentTimeMillis() + "_" + file.getOriginalFilename();
            String filePath = uploadDir + File.separator + fileName;
            file.transferTo(new File(filePath));

            Admin admin = (Admin) session.getAttribute("admin");
            User user = (User) session.getAttribute("user");

            if (admin == null && user == null) {
                redirectAttributes.addFlashAttribute("message", "Please log in to upload a video!");
                return "redirect:/video/uploadVideo";
            }

            Video video = new Video(title, category, "/uploads/" + fileName, admin);
            video.setReel(isReel);
            if (user != null) {
                video.setUserUploader(user);
            }
            videoService.uploadVideo(video);

            redirectAttributes.addFlashAttribute("message", (isReel ? "Reel" : "Video") + " uploaded successfully!");

            if (admin != null) {
                return "redirect:/video/videoManagement";
            } else {
                return "redirect:" + (isReel ? "/video/allReels" : "/video/allVideos");
            }

        } catch (IOException e) {
            redirectAttributes.addFlashAttribute("message", "Video upload failed: " + e.getMessage());
            return "redirect:/video/uploadVideo";
        }
    }

    // Show video edit form
    @RequestMapping(value = "/edit/{id}", method = RequestMethod.GET)
    public String editVideoForm(@PathVariable Long id, Model model) {
        Video video = videoService.getVideoById(id);
        model.addAttribute("video", video);
        model.addAttribute("categories", Category.values());
        return "editVideo";
    }

    // Update video
    @RequestMapping(value = "/update/{id}", method = RequestMethod.POST)
    public String updateVideo(@PathVariable Long id,
                              @ModelAttribute Video updatedVideo,
                              @RequestParam String title,
                              @RequestParam Category category,
                              @RequestParam(value = "videoFile", required = false) MultipartFile file,
                              HttpSession session) throws IOException {
        if (file != null && !file.isEmpty()) {
            String videoUrl = fileService.saveFile(file);
            updatedVideo.setFilePath(videoUrl);
        }
        videoService.updateVideo(id, updatedVideo);
        return "redirect:/video/videoManagement";
    }

    // Delete a video
    @RequestMapping(value = "/delete/{id}", method = RequestMethod.GET)
    public String deleteVideo(@PathVariable Long id) {
        videoService.deleteVideo(id);
        return "redirect:/video/videoManagement";
    }

    // Show All Videos for admin
    @RequestMapping(value = "/videoManagement", method = RequestMethod.GET)
    public String showVideoManagement(Model model,
                                      @RequestParam(value = "category", required = false) String category) {
        List<Video> videos;

        if (category != null && !category.isEmpty()) {
            Category selectedCategory = Category.valueOf(category);
            videos = videoService.getVideosByCategory(selectedCategory);
        } else {
            videos = videoService.getAllVideos();
        }

        model.addAttribute("videos", videos);
        model.addAttribute("categories", Category.values());
        model.addAttribute("selectedCategory", category);
        return "videoManagement";
    }

    // Show All Videos for users and volunteers
    @RequestMapping(value = "/allVideos", method = RequestMethod.GET)
    public String showVideos(@RequestParam(value = "category", required = false) Category category,
                             Model model,
                             HttpSession session) {
        List<Video> videos = (category != null) ? 
            videoService.getVideosByCategoryAndType(category, false) : 
            videoService.getVideosByType(false);
        model.addAttribute("videos", videos);
        model.addAttribute("categories", Category.values());
        model.addAttribute("user", session.getAttribute("user"));
        return "videosPage";
    }

    // Show All Reels for users and volunteers
    @RequestMapping(value = "/allReels", method = RequestMethod.GET)
    public String showReels(@RequestParam(value = "category", required = false) Category category,
                            Model model,
                            HttpSession session) {
        List<Video> reels = (category != null) ? 
            videoService.getVideosByCategoryAndType(category, true) : 
            videoService.getVideosByType(true);
        model.addAttribute("videos", reels);
        model.addAttribute("categories", Category.values());
        model.addAttribute("user", session.getAttribute("user"));
        return "reelsPage";
    }
    @RequestMapping(value = "/allVideos1", method = RequestMethod.GET)
    public String showVideos1(@RequestParam(value = "category", required = false) Category category,
                              Model model,
                              HttpSession session) {
        List<Video> videos = (category != null) ? 
            videoService.getVideosByCategoryAndType(category, false) : 
            videoService.getVideosByType(false);
        model.addAttribute("videos", videos);
        model.addAttribute("categories", Category.values());
        model.addAttribute("user", session.getAttribute("user"));
        return "videosPage1";
    }
}
