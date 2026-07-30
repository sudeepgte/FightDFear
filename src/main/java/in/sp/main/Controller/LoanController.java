package in.sp.main.Controller;

import in.sp.main.Entities.LoanApplication;
import in.sp.main.Entities.User;
import in.sp.main.Repository.LoanApplicationRepository;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.time.LocalDateTime;

@Controller
@RequestMapping("/loan")
public class LoanController {

    @Autowired
    private LoanApplicationRepository loanApplicationRepository;

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
    public String loanApplication(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }
        model.addAttribute("user", user);
        return "loan/loan-application";
    }

    @PostMapping("/application")
    public String submitLoanApplication(@RequestParam String fullName,
                                        @RequestParam String email,
                                        @RequestParam(required = false) String phoneNumber,
                                        @RequestParam(required = false) String address,
                                        @RequestParam(required = false) String aadhaarNumber,
                                        @RequestParam(required = false) String panNumber,
                                        @RequestParam String loanType,
                                        @RequestParam(required = false) String occupation,
                                        @RequestParam(required = false) Double annualIncome,
                                        @RequestParam Double loanAmount,
                                        @RequestParam(required = false) String purpose,
                                        HttpSession session,
                                        RedirectAttributes redirectAttributes) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }
        if (fullName == null || fullName.isBlank() || email == null || email.isBlank()
                || loanType == null || loanType.isBlank() || loanAmount == null || loanAmount <= 0) {
            redirectAttributes.addFlashAttribute("error", "Please fill required fields with a valid loan amount.");
            return "redirect:/loan/application";
        }

        LoanApplication app = new LoanApplication();
        app.setUser(user);
        app.setFullName(fullName.trim());
        app.setEmail(email.trim());
        app.setPhoneNumber(phoneNumber);
        app.setAddress(address);
        app.setAadhaarNumber(aadhaarNumber);
        app.setPanNumber(panNumber);
        app.setLoanType(loanType.trim());
        app.setOccupation(occupation);
        app.setAnnualIncome(annualIncome);
        app.setLoanAmount(loanAmount);
        app.setPurpose(purpose);
        app.setStatus("SUBMITTED");
        app.setSubmittedAt(LocalDateTime.now());
        loanApplicationRepository.save(app);

        redirectAttributes.addFlashAttribute("applicationId", app.getId());
        redirectAttributes.addFlashAttribute("message", "Your loan application was submitted successfully.");
        return "redirect:/loan/confirmation";
    }

    @GetMapping("/confirmation")
    public String loanConfirmation(HttpSession session) {
        if (session.getAttribute("user") == null) {
            return "redirect:/login";
        }
        return "loan/loan-confirmation";
    }
}
