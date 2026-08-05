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

        // Women Marketplace: keep entity-mapped columns in sync with legacy columns
        try {
            jdbcTemplate.execute(
                "UPDATE service_providers SET provider_category = category " +
                "WHERE provider_category IS NULL AND category IS NOT NULL"
            );
            jdbcTemplate.execute(
                "UPDATE service_providers SET v_status = verification_status " +
                "WHERE provider_category IS NOT NULL AND verification_status IS NOT NULL " +
                "AND (v_status IS NULL OR (v_status = 'PENDING' AND verification_status IN ('VERIFIED', 'REJECTED')))"
            );
            System.out.println("Synced legacy service_providers category/verification columns.");
        } catch (Exception e) {
            System.err.println("Note: Could not sync service_providers legacy columns: " + e.getMessage());
        }
    }
}
