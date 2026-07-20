package in.sp.main.Controller;

import java.io.IOException;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import in.sp.main.Entities.ExpressPost;
import in.sp.main.Entities.ExpressPostType;
import in.sp.main.Entities.User;
import in.sp.main.Repository.ExpressPostRepository;
import in.sp.main.Service.FileUploadService;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/stories")
public class SafetyStoriesController {

    @Autowired
    private ExpressPostRepository postRepo;

    @Autowired
    private FileUploadService fileUploadService;

    @GetMapping
    public String page(Model model, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) return "redirect:/login";

        List<ExpressPost> posts = postRepo.findByPostTypeOrderByCreatedAtDesc(ExpressPostType.SAFETY_STORY);
        model.addAttribute("user", user);
        model.addAttribute("posts", posts);
        return "safety-stories";
    }

    @PostMapping("/create")
    public String create(@RequestParam String content,
                         @RequestParam(value = "media", required = false) MultipartFile media,
                         HttpSession session,
                         RedirectAttributes redirectAttributes) {
        User user = (User) session.getAttribute("user");
        if (user == null) return "redirect:/login";

        String c = content == null ? "" : content.trim();
        if (c.isEmpty()) {
            redirectAttributes.addFlashAttribute("message", "Please write something.");
            return "redirect:/stories";
        }

        ExpressPost p = new ExpressPost();
        p.setUser(user);
        p.setContent(c);
        p.setPostType(ExpressPostType.SAFETY_STORY);

        if (media != null && !media.isEmpty()) {
            try {
                String url = fileUploadService.saveFile(media);
                p.setMediaUrl(url);
            } catch (IOException e) {
                redirectAttributes.addFlashAttribute("message", "Media upload failed.");
                return "redirect:/stories";
            }
        }

        postRepo.save(p);
        redirectAttributes.addFlashAttribute("message", "Posted.");
        return "redirect:/stories";
    }
}

