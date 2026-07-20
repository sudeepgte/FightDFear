package in.sp.main.Controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/logout")
public class LogoutController {

    // Handle logout
    @RequestMapping(method = RequestMethod.GET)
    public String logout(HttpSession session, jakarta.servlet.http.HttpServletResponse response) {
        // Purpose: fully clear session for all roles (user/volunteer/doctor/provider/salon/stylist).
        if (session != null) {
            session.invalidate();
        }
        
        jakarta.servlet.http.Cookie cookie = new jakarta.servlet.http.Cookie("JWT_TOKEN", null);
        cookie.setPath("/");
        cookie.setHttpOnly(true);
        cookie.setMaxAge(0);
        response.addCookie(cookie);
        
        return "redirect:/login?logout=true"; // Redirect to login page after logout
    }
}
