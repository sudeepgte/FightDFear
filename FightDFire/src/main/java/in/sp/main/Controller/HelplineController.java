package in.sp.main.Controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class HelplineController {

    @GetMapping("/emergency-contacts")
    public String showHelplinePage() {
        return "helpline";
    }
}
