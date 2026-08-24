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
import in.sp.main.Service.PasswordService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@Controller
@RequestMapping("/login")
public class LoginController {
    private static final Logger log = LoggerFactory.getLogger(LoginController.class);

    @Autowired
    private UserService userService;
    
    @Autowired
    private PasswordService passwordService;

    @Autowired
    private in.sp.main.Config.JwtUtil jwtUtil;

    @Autowired
    private in.sp.main.Repository.MartialArtsCenterRepository centreRepository;

    @Autowired
    private in.sp.main.Repository.FitnessTrainerRepository fitnessTrainerRepository;

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

        // 1. Try Normal User
        User user = userService.findByUsername(normEmail);
        if (user != null && user.getPassword() != null) {
            boolean ok = passwordService.matchesAndUpgrade(rawPassword, user.getPassword(), hashed -> {
                user.setPassword(hashed);
                userService.createUser(user);
            });
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

                session.removeAttribute("loggedDoctor");
                session.removeAttribute("loggedSalon");
                session.removeAttribute("loggedStylist");
                session.removeAttribute("loggedProvider");
                session.removeAttribute("loggedCentre");
                session.removeAttribute("loggedSeller");
                session.removeAttribute("loggedEntrepreneur");
                session.removeAttribute("loggedInvestor");
                session.removeAttribute("loggedHost");
                session.removeAttribute("loggedTrainer");
                session.removeAttribute("admin");
                session.setAttribute("user", user);

                String token = jwtUtil.generateToken(user.getEmail(), "USER");
                jakarta.servlet.http.Cookie cookie = new jakarta.servlet.http.Cookie("JWT_TOKEN", token);
                cookie.setPath("/");
                cookie.setHttpOnly(true);
                cookie.setMaxAge(365 * 24 * 60 * 60);
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
            }
        }

        // 2. Try Martial Arts Centre
        var centreOpt = centreRepository.findByEmail(normEmail);
        if (centreOpt.isPresent()) {
            var centre = centreOpt.get();
            boolean ok = passwordService.matchesAndUpgrade(rawPassword, centre.getPassword(), hashed -> {
                centre.setPassword(hashed);
                centreRepository.save(centre);
            });
            if (ok) {
                session.removeAttribute("user");
                session.removeAttribute("loggedTrainer");
                session.setAttribute("loggedCentre", centre);

                String token = jwtUtil.generateToken(centre.getEmail(), "CENTRE");
                jakarta.servlet.http.Cookie cookie = new jakarta.servlet.http.Cookie("JWT_TOKEN", token);
                cookie.setPath("/");
                cookie.setHttpOnly(true);
                cookie.setMaxAge(365 * 24 * 60 * 60);
                response.addCookie(cookie);

                boolean needsCompletion = centre.getCentreProfileStatus() == in.sp.main.Entities.CentreProfileStatus.REGISTERED
                        || centre.getCentreProfileStatus() == in.sp.main.Entities.CentreProfileStatus.PROFILE_INCOMPLETE
                        || centre.getCentreProfileStatus() == in.sp.main.Entities.CentreProfileStatus.CHANGES_REQUESTED
                        || (centre.getProfileCompletionPct() != null && centre.getProfileCompletionPct() < 100 && !centre.isApproved());

                if (needsCompletion) {
                    return "redirect:/centres/profile-completion";
                }
                return "redirect:/centres/dashboard";
            }
        }

        // 3. Try Fitness Trainer
        var trainerOpt = fitnessTrainerRepository.findByEmail(normEmail);
        if (trainerOpt.isPresent()) {
            var trainer = trainerOpt.get();
            boolean ok = passwordService.matchesAndUpgrade(rawPassword, trainer.getPassword(), hashed -> {
                trainer.setPassword(hashed);
                fitnessTrainerRepository.save(trainer);
            });
            if (ok) {
                if (trainer.isSuspended()) {
                    model.addAttribute("error", "Your trainer account has been suspended.");
                    return "login";
                }
                session.removeAttribute("user");
                session.removeAttribute("loggedCentre");
                session.setAttribute("loggedTrainer", trainer);

                String token = jwtUtil.generateToken(trainer.getEmail(), "TRAINER");
                jakarta.servlet.http.Cookie cookie = new jakarta.servlet.http.Cookie("JWT_TOKEN", token);
                cookie.setPath("/");
                cookie.setHttpOnly(true);
                cookie.setMaxAge(365 * 24 * 60 * 60);
                response.addCookie(cookie);

                return "redirect:/fitness/trainer/dashboard";
            }
        }

        log.warn("Login failed: invalid credentials for email={}", normEmail);
        model.addAttribute("error", "Invalid credentials. Please try again.");
        return "login";
    }
}