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
    public String showForgotPasswordPage(@RequestParam(value = "redirect", required = false) String redirect, Model model) {
        if (redirect != null && !redirect.isBlank()) {
            model.addAttribute("redirect", redirect);
        }
        return "forgotPassword"; 
    }

    @RequestMapping(value = "/forgot-password", method = POST)
    public String forgotPassword(@RequestParam(value = "email", required = false) String email,
                                 @RequestParam(value = "redirect", required = false) String redirect,
                                 Model model) {
        if (redirect != null && !redirect.isBlank()) {
            model.addAttribute("redirect", redirect);
        }
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
            String result = passwordResetService.createPasswordResetToken(normalizedEmail, redirect);
            if ("No account found with this email address".equals(result)) {
                model.addAttribute("error", "No account found with this email address. Please check your email or register.");
            } else {
                model.addAttribute("message", "A password reset link has been sent to your registered email inbox.");
            }
        } catch (Exception ex) {
            model.addAttribute("error", "Unable to process your request right now. Please try again later.");
        }
        return "forgotPassword";
    }

    @RequestMapping(value = "/reset-password", method = GET)
    public String showResetPasswordPage(@RequestParam("token") String token,
                                        @RequestParam(value = "type", required = false) String type,
                                        @RequestParam(value = "redirect", required = false) String redirect,
                                        Model model) {
        model.addAttribute("token", token);
        model.addAttribute("userType", type);
        model.addAttribute("redirect", redirect);
        return "resetPassword";
    }

    @Autowired
    private in.sp.main.Repository.PasswordResetTokenRepository tokenRepository;

    @RequestMapping(value = "/reset-password", method = POST)
    public String resetPassword(@RequestParam("token") String token,
                                @RequestParam("newPassword") String newPassword,
                                @RequestParam(value = "redirect", required = false) String redirect,
                                Model model) {
        String defaultRedirectUrl = "/login";
        java.util.Optional<in.sp.main.Entities.PasswordResetToken> tokenOpt = tokenRepository.findByToken(token);
        if (tokenOpt.isPresent()) {
            in.sp.main.Entities.UserType type = tokenOpt.get().getUserType();
            if (type == in.sp.main.Entities.UserType.FITNESS_TRAINER) {
                defaultRedirectUrl = "/fitness/trainer/login";
            } else if (type == in.sp.main.Entities.UserType.CENTRE) {
                defaultRedirectUrl = "/centres/login";
            } else if (type == in.sp.main.Entities.UserType.DOCTOR) {
                defaultRedirectUrl = "/doctors/login";
            } else if (type == in.sp.main.Entities.UserType.STYLIST) {
                defaultRedirectUrl = "/stylists/login";
            } else if (type == in.sp.main.Entities.UserType.SALON) {
                defaultRedirectUrl = "/salons/login";
            } else if (type == in.sp.main.Entities.UserType.PROVIDER) {
                defaultRedirectUrl = "/marketplace/provider/login";
            } else if (type == in.sp.main.Entities.UserType.SELLER) {
                defaultRedirectUrl = "/women-products/seller/login";
            } else if (type == in.sp.main.Entities.UserType.ENTREPRENEUR) {
                defaultRedirectUrl = "/entrepreneur/login";
            } else if (type == in.sp.main.Entities.UserType.INVESTOR) {
                defaultRedirectUrl = "/investor/login";
            } else if (type == in.sp.main.Entities.UserType.EVENT_HOST) {
                defaultRedirectUrl = "/women-events/host/login";
            } else if (type == in.sp.main.Entities.UserType.ADMIN) {
                defaultRedirectUrl = "/admin/login";
            } else if (type == in.sp.main.Entities.UserType.USER) {
                defaultRedirectUrl = "/login";
            }
        }

        String targetUrl = (redirect != null && !redirect.isBlank()) ? redirect : defaultRedirectUrl;
        if (!targetUrl.startsWith("/")) {
            targetUrl = "/" + targetUrl;
        }

        String response = passwordResetService.resetPassword(token, newPassword);
        if ("Password reset successful".equals(response)) {
            return "redirect:" + targetUrl + "?reset=success";
        } else {
            model.addAttribute("error", response);
            model.addAttribute("token", token);
            model.addAttribute("redirect", redirect);
            return "resetPassword";
        }
    }
}
