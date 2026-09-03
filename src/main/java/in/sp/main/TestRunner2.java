package in.sp.main;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import java.util.List;
import java.util.Map;

@Component
public class TestRunner2 implements CommandLineRunner {
    @Autowired
    private JdbcTemplate jdbcTemplate;

    @Override
    public void run(String... args) throws Exception {
        System.out.println("=== USER PROFILE PHOTOS ===");
        List<Map<String, Object>> users = jdbcTemplate.queryForList("SELECT id, full_name, profile_photo FROM user WHERE full_name IN ('Prakruthi', 'Aasif khan', 'varu1', 'varu')");
        for (Map<String, Object> u : users) {
            System.out.println(u.get("full_name") + " -> " + u.get("profile_photo"));
        }
    }
}
