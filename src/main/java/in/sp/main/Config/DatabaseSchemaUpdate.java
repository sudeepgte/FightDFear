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
        // Redundant DDL and destructive data overwrites removed:
        // - enrollment.status handled by Hibernate @Enumerated mapping.
        // - financial_videos, financial_live_sessions, financial_workshops custom_category columns handled by JPA & V47.
        // - women_events.category handled by JPA & V49.
        // - Destructive UPDATE on financial_videos (duration/level) removed to preserve real video data.
        // - Unnecessary UPDATE on financial_live_sessions removed.

        // Retained: Non-destructive legacy service_providers column synchronization
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
