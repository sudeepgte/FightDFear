package in.sp.main.Controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/loan")
public class LoanController {

    @GetMapping
    public String loanHome() {
        return "loan/loan-home";
    }

    @GetMapping("/details/{loanId}")
    public String loanDetails(@PathVariable String loanId, Model model) {
        model.addAttribute("loanId", loanId);
        return "loan/loan-details";
    }
    
    @GetMapping("/application")
    public String loanApplication() {
        return "loan/loan-application";
    }
    
    @GetMapping("/confirmation")
    public String loanConfirmation() {
        return "loan/loan-confirmation";
    }
}
