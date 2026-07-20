package in.sp.main.Controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/funding")
public class FundingController {

    @GetMapping
    public String fundingHome() {
        return "funding/funding-home";
    }

    @GetMapping("/details/{schemeId}")
    public String fundingDetails(@PathVariable String schemeId, Model model) {
        model.addAttribute("schemeId", schemeId);
        return "funding/funding-details";
    }
    
    @GetMapping("/application")
    public String fundingApplication() {
        return "funding/funding-application";
    }
    
    @GetMapping("/confirmation")
    public String fundingConfirmation() {
        return "funding/funding-confirmation";
    }
}
