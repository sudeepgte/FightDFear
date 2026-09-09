package in.sp.main.Controller;

import in.sp.main.Entities.Admin;
import in.sp.main.Repository.UserRepository;
import jakarta.servlet.http.HttpSession;
import org.springframework.context.annotation.Profile;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;

import java.util.stream.Collectors;

@RestController
@Profile({"dev", "test"})
public class DebugController {
    private final UserRepository repo;

    public DebugController(UserRepository repo) {
        this.repo = repo;
    }

    @GetMapping("/debug-photos")
    public String get(HttpSession session) {
        Object adminObj = (session != null) ? session.getAttribute("admin") : null;
        if (!(adminObj instanceof Admin)) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "Admin authorization required");
        }
        return repo.findAll().stream()
            .map(u -> u.getFullName() + ": " + u.getProfilePhoto())
            .collect(Collectors.joining("\n"));
    }
}
