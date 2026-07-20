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
    public String forgotPassword(@RequestParam String email, Model model) {
        String response = passwordResetService.createPasswordResetToken(email);
        model.addAttribute("message", response);
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
        model.addAttribute("message", response);
        return "login";
    }
}
