package in.sp.main.Controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import in.sp.main.Service.PasswordResetService;

import static org.springframework.web.bind.annotation.RequestMethod.*;

@Controller
@RequestMapping("/auth")
public class AuthController {

    @Autowired 
    private PasswordResetService passwordResetService;

    @RequestMapping(value = "/forgot-password", method = GET)
    public String showForgotPasswordPage() {
        return "forgotPassword"; 
    }

    @RequestMapping(value = "/forgot-password", method = POST)
    public String forgotPassword(@RequestParam(required = false) String email, Model model) {
        if (email == null || email.trim().isEmpty()) {
            model.addAttribute("error", "Please enter your email address.");
            return "forgotPassword";
        }

        String normalizedEmail = email.trim().toLowerCase();
        if (!normalizedEmail.matches("^[a-zA-Z0-9._+\\-]+@[a-zA-Z0-9.\\-]+\\.[a-zA-Z]{2,}$")) {
            model.addAttribute("error", "Please enter a valid email address.");
            return "forgotPassword";
        }

        try {
            passwordResetService.createPasswordResetToken(normalizedEmail);
            model.addAttribute("message", "If an account with that email exists, a password reset link has been sent.");
        } catch (Exception ex) {
            model.addAttribute("error", "Unable to process your request right now. Please try again later.");
        }
        return "forgotPassword";
    }

    @RequestMapping(value = "/reset-password", method = GET)
    public String showResetPasswordPage(@RequestParam String token, @RequestParam String type, Model model) {
        model.addAttribute("token", token);
        model.addAttribute("userType", type);
        return "resetPassword";
    }

    @Autowired
    private in.sp.main.Repository.PasswordResetTokenRepository tokenRepository;

    @RequestMapping(value = "/reset-password", method = POST)
    public String resetPassword(@RequestParam String token, @RequestParam String newPassword, Model model) {
        String loginView = "login";
        java.util.Optional<in.sp.main.Entities.PasswordResetToken> tokenOpt = tokenRepository.findByToken(token);
        if (tokenOpt.isPresent()) {
            in.sp.main.Entities.UserType type = tokenOpt.get().getUserType();
            if (type == in.sp.main.Entities.UserType.FITNESS_TRAINER) {
                loginView = "fitnessTrainerLogin";
            } else if (type == in.sp.main.Entities.UserType.CENTRE) {
                loginView = "centreLogin";
            } else if (type == in.sp.main.Entities.UserType.DOCTOR) {
                loginView = "doctorLogin";
            } else if (type == in.sp.main.Entities.UserType.STYLIST) {
                loginView = "stylistLogin";
            } else if (type == in.sp.main.Entities.UserType.SALON) {
                loginView = "salonLogin";
            } else if (type == in.sp.main.Entities.UserType.PROVIDER) {
                loginView = "providerLogin";
            } else if (type == in.sp.main.Entities.UserType.SELLER) {
                loginView = "sellerLogin";
            } else if (type == in.sp.main.Entities.UserType.ENTREPRENEUR) {
                loginView = "entrepreneurLogin";
            } else if (type == in.sp.main.Entities.UserType.INVESTOR) {
                loginView = "investorLogin";
            } else if (type == in.sp.main.Entities.UserType.EVENT_HOST) {
                loginView = "eventHostLogin";
            }
        }
        
        String response = passwordResetService.resetPassword(token, newPassword);
        if ("Password reset successful".equals(response)) {
            model.addAttribute("success", response);
        } else {
            model.addAttribute("error", response);
        }
        return loginView;
    }
}
