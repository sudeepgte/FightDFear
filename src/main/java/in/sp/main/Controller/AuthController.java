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
            String response = passwordResetService.createPasswordResetToken(normalizedEmail);
            if ("Email not found".equals(response)) {
                model.addAttribute("error", "Email not found. Please enter a registered email address.");
            } else {
                model.addAttribute("message", response);
            }
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

    @RequestMapping(value = "/reset-password", method = POST)
    public String resetPassword(@RequestParam String token, @RequestParam String newPassword, Model model) {
        String response = passwordResetService.resetPassword(token, newPassword);
        if ("Password reset successful".equals(response)) {
            model.addAttribute("success", response);
        } else {
            model.addAttribute("error", response);
        }
        return "login";
    }
}
