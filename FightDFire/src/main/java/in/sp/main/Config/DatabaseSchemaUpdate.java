package in.sp.main.Config;

import org.springframework.boot.CommandLineRunner;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;

@Component
public class DatabaseSchemaUpdate implements CommandLineRunner {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @Override
    public void run(String... args) throws Exception {
        try {
            System.out.println("Checking and updating database schema for enrollment status column...");
            jdbcTemplate.execute("ALTER TABLE enrollment MODIFY COLUMN status VARCHAR(50)");
            System.out.println("Database schema updated successfully: enrollment.status altered to VARCHAR(50)");
        } catch (Exception e) {
            System.err.println("Note: Could not alter column status (it may already be correct): " + e.getMessage());
        }
    }
}
