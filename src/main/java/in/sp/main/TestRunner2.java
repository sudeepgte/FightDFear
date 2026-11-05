package in.sp.main;

import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Profile;
import org.springframework.stereotype.Component;

@Component
@Profile("!prod")
public class TestRunner2 implements CommandLineRunner {

    @Override
    public void run(String... args) throws Exception {
        // Intentionally empty: startup profile-photo dump cluttered the console.
    }
}
