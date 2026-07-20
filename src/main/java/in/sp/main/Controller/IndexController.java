package in.sp.main.Controller;

import in.sp.main.Service.IndexTemplatesFeedService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.Map;

@Controller
@RequestMapping("/index")
public class IndexController {

    @Autowired
    private IndexTemplatesFeedService indexTemplatesFeedService;

    // ✅ Home / Templates Page
    @GetMapping("/templates")
    public String showTemplatesPage(Model model) {
        model.addAttribute("pageTitle", "Startup Templates & Documents");
       
        return "index/index";  // /WEB-INF/jsp/index/index.jsp
    }

    @GetMapping(value = "/templates/feed", produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public Map<String, Object> templatesFeed() {
        return indexTemplatesFeedService.buildFeed();
    }

    // ✅ About Page
    @GetMapping("/about")
    public String about(Model model) {
        model.addAttribute("pageTitle", "About Us");
     
        return "index/about";
    }

    // ✅ Blog List Page
    @GetMapping("/blog")
    public String blog(Model model) {
        model.addAttribute("pageTitle", "Blog");
        
        return "index/blog";
    }

    // ✅ Blog Single Page
    @GetMapping("/blog-single")
    public String blogSingle(Model model) {
        model.addAttribute("pageTitle", "Blog Details");
   
        return "index/blog-single";
    }

    // ✅ Contact Page
    @GetMapping("/contact")
    public String contact(Model model) {
        model.addAttribute("pageTitle", "Contact Us");
       
        return "index/contact";
    }

    // ✅ Main Page
    @GetMapping("/main")
    public String mainPage(Model model) {
        model.addAttribute("pageTitle", "Main Dashboard");
    
        return "index/main";
    }

    // ✅ Pricing Page
    @GetMapping("/pricing")
    public String pricing(Model model) {
        model.addAttribute("pageTitle", "Pricing Plans");
      
        return "index/pricing";
    }

    // ✅ Specialists Page
    @GetMapping("/specialists")
    public String specialists(Model model) {
        model.addAttribute("pageTitle", "Our Specialists");
     
        return "index/specialists";
    }

    // ✅ Treatments Page
    @GetMapping("/treatments")
    public String treatments(Model model) {
        model.addAttribute("pageTitle", "Our Services & Treatments");
        
        return "index/treatments";
    }
}
