package in.sp.main;

import in.sp.main.Entities.User;
import in.sp.main.Repository.UserRepository;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;
import java.util.List;

@Component
public class TestRunner implements CommandLineRunner {
    private final UserRepository userRepository;
    public TestRunner(UserRepository userRepository) { this.userRepository = userRepository; }

    @Override
    public void run(String... args) throws Exception {
        List<User> users = userRepository.findAll();
        for (User u : users) {
            System.out.println("USER: " + u.getFullName() + ", PHOTO: " + u.getProfilePhoto());
        }
    }
}
