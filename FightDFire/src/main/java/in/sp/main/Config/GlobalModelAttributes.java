package in.sp.main.Config;

import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;

import in.sp.main.Entities.User;
import jakarta.servlet.http.HttpSession;

@ControllerAdvice
public class GlobalModelAttributes {

    @ModelAttribute("user")
    public User currentUser(HttpSession session) {
        Object u = session.getAttribute("user");
        return (u instanceof User) ? (User) u : null;
    }
}

