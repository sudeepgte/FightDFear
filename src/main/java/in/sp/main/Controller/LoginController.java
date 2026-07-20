package in.sp.main.Controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import in.sp.main.Entities.User;
import in.sp.main.Entities.VerificationStatus;
import in.sp.main.Service.UserService;
import jakarta.servlet.http.HttpSession;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@Controller
@RequestMapping("/login")
public class LoginController {
    private static final Logger log = LoggerFactory.getLogger(LoginController.class);

    @Autowired
    private UserService userService;
    
    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private in.sp.main.Config.JwtUtil jwtUtil;

    // Show login page
    @GetMapping
    public String showLoginPage(@RequestParam(value = "redirect", required = false) String redirect,
                                HttpSession session) {
        if (redirect != null && !redirect.isEmpty()) {
            session.setAttribute("redirectAfterLogin", redirect);
        }
        return "login"; // login.jsp
    }

    @RequestMapping(value = "/", method = RequestMethod.GET)
    public String homePage() {
        return "index";
    }

    @RequestMapping(value = "/index", method = RequestMethod.GET)
    public String homePage1() {
        return "indexDemo";
    }

 // Handle login action
    @RequestMapping(method = RequestMethod.POST)
    public String login(@RequestParam("email") String email,
                        @RequestParam("password") String password,
                        Model model,
                        HttpSession session,
                        jakarta.servlet.http.HttpServletResponse response) {
        String normEmail = (email == null) ? "" : email.trim().toLowerCase();
        String rawPassword = (password == null) ? "" : password;

        User user = userService.findByUsername(normEmail);

        boolean ok = false;
        if (user != null && user.getPassword() != null) {
            // Support both legacy plain-text passwords and BCrypt passwords.
            ok = passwordEncoder.matches(rawPassword, user.getPassword())
                    || user.getPassword().equals(rawPassword);
        }

        if (ok) {
            VerificationStatus status = user.getVerificationStatus();
            if (status == null || status == VerificationStatus.PENDING) {
                model.addAttribute("error", "Your account is pending verification by Admin. Please check back later.");
                return "login";
            }
            if (status == VerificationStatus.REJECTED) {
                model.addAttribute("error", "Your account has been rejected by admin.");
                return "login";
            }
            if (user.isBanned()) {
                model.addAttribute("error", "Your account has been banned due to policy violations.");
                return "login";
            }

            session.setAttribute("user", user);

            // Generate JWT and add to response
            String token = jwtUtil.generateToken(user.getEmail(), "USER");
            jakarta.servlet.http.Cookie cookie = new jakarta.servlet.http.Cookie("JWT_TOKEN", token);
            cookie.setPath("/");
            cookie.setHttpOnly(true);
            cookie.setMaxAge(365 * 24 * 60 * 60); // 1 year
            response.addCookie(cookie);

            String redirect = (String) session.getAttribute("redirectAfterLogin");
            if (redirect != null && !redirect.isBlank()) {
                session.removeAttribute("redirectAfterLogin");
                if (redirect.startsWith("/")) {
                    return "redirect:" + redirect;
                }
                return "redirect:/" + redirect;
            }
            return "redirect:/users/dashboard";
        } else {
            // Helpful diagnostics for dev; doesn't leak password.
            if (user == null) {
                log.warn("Login failed: user not found for email={}", normEmail);
            } else {
                String stored = user.getPassword();
                String prefix = (stored == null) ? "null" : stored.substring(0, Math.min(7, stored.length()));
                log.warn("Login failed: password mismatch for email={} storedPrefix={}", normEmail, prefix);
            }
            model.addAttribute("error", "Invalid credentials. Please try again.");
            return "login";
        }
    }
}