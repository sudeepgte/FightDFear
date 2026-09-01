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

        try {
            jdbcTemplate.execute("ALTER TABLE financial_videos ADD COLUMN custom_category VARCHAR(255) DEFAULT NULL");
            System.out.println("Added custom_category column to financial_videos table.");
        } catch (Exception e) {
            // Column may already exist
        }

        try {
            jdbcTemplate.execute("ALTER TABLE financial_live_sessions ADD COLUMN custom_category VARCHAR(255) DEFAULT NULL");
            System.out.println("Added custom_category column to financial_live_sessions table.");
        } catch (Exception e) {
            // Column may already exist
        }

        try {
            jdbcTemplate.execute("ALTER TABLE financial_workshops ADD COLUMN custom_category VARCHAR(255) DEFAULT NULL");
            System.out.println("Added custom_category column to financial_workshops table.");
        } catch (Exception e) {
            // Column may already exist
        }

        try {
            jdbcTemplate.execute("UPDATE financial_videos SET duration = NULL, level = NULL");
            System.out.println("Cleared legacy duration/level values in financial_videos table.");
        } catch (Exception e) {
            // Table/columns may vary
        }

        try {
            jdbcTemplate.execute("UPDATE financial_live_sessions SET meeting_url = '' WHERE meeting_url LIKE '%/admin%' OR meeting_url = 'admin'");
            System.out.println("Cleaned legacy admin meeting_url values in financial_live_sessions table.");
        } catch (Exception e) {
            // Table/columns may vary
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

        // Seed default Super Admin account if none exists
        try {
            var count = jdbcTemplate.queryForObject("SELECT COUNT(*) FROM admin", Integer.class);
            if (count == null || count == 0) {
                // BCrypt hash for "Admin@123"
                String hash = "$2a$10$7R0Z.yO1Vd4c.xKqP7.mqu91jW1NqZ1kE3hP7e4wLzX3Y1.t7Vzqu";
                // Insert default admin
                jdbcTemplate.update(
                    "INSERT INTO admin (name, email, password) VALUES (?, ?, ?)",
                    "Super Admin", "admin@gmail.com", "Admin@123"
                );
                System.out.println("Default Super Admin seeded: admin@gmail.com / Admin@123");
            }
        } catch (Exception e) {
            System.err.println("Note: Could not check/seed default admin: " + e.getMessage());
        }

        try {
            jdbcTemplate.execute("ALTER TABLE women_events MODIFY COLUMN category VARCHAR(64) NOT NULL");
            System.out.println("women_events.category widened to VARCHAR(64) for expanded event categories.");
        } catch (Exception e) {
            System.err.println("Note: Could not alter women_events.category: " + e.getMessage());
        }
    }
}
