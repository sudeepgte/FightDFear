package in.sp.main;

import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Profile;
import org.springframework.stereotype.Component;

@Component
@Profile("!prod")
public class TestRunner implements CommandLineRunner {

    @Override
    public void run(String... args) throws Exception {
        // Intentionally empty: dumping every user/photo on startup flooded the console
        // and triggered N+1 Hibernate queries against medical_details.
    }
}
