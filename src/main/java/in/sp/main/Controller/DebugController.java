package in.sp.main.Controller;
import in.sp.main.Entities.User;
import in.sp.main.Repository.UserRepository;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import java.util.stream.Collectors;
@RestController
public class DebugController {
    private final UserRepository repo;
    public DebugController(UserRepository repo) { this.repo = repo; }
    @GetMapping("/debug-photos")
    public String get() {
        return repo.findAll().stream()
            .map(u -> u.getFullName() + ": " + u.getProfilePhoto())
            .collect(Collectors.joining("\n"));
    }
}
