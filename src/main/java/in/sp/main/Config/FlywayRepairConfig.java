package in.sp.main.Config;

import org.flywaydb.core.Flyway;
import org.springframework.boot.autoconfigure.flyway.FlywayMigrationStrategy;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

/**
 * Realign Flyway checksums when an already-applied migration file was edited
 * (e.g. V10), then run migrate. Without this, Spring Boot fails to start with
 * "Migration checksum mismatch" and nginx returns 502.
 */
@Configuration
public class FlywayRepairConfig {

    @Bean
    public FlywayMigrationStrategy flywayMigrationStrategy() {
        return (Flyway flyway) -> {
            flyway.repair();
            flyway.migrate();
        };
    }
}
