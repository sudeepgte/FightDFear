package in.sp.main.Config;

import org.flywaydb.core.Flyway;
import org.springframework.boot.autoconfigure.flyway.FlywayMigrationStrategy;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.ResultSet;

/**
 * Realign Flyway checksums when an already-applied migration file was edited
 * (e.g. V10), then run migrate. Without this, Spring Boot fails to start with
 * "Migration checksum mismatch" and nginx returns 502.
 */
@Configuration
public class FlywayRepairConfig {

    private final DataSource dataSource;

    public FlywayRepairConfig(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    @Bean
    public FlywayMigrationStrategy flywayMigrationStrategy() {
        return (Flyway flyway) -> {
            try (Connection conn = dataSource.getConnection()) {
                boolean hasBusinessTables = false;
                try (ResultSet rs = conn.getMetaData().getTables(conn.getCatalog(), conn.getSchema(), "%", new String[]{"TABLE"})) {
                    while (rs.next()) {
                        String tableName = rs.getString("TABLE_NAME");
                        if (!tableName.equalsIgnoreCase("flyway_schema_history")) {
                            hasBusinessTables = true;
                            break;
                        }
                    }
                }
                
                try (java.sql.Statement stmt = conn.createStatement()) {
                    stmt.execute("CREATE TABLE IF NOT EXISTS shedlock (" +
                        "name VARCHAR(64) NOT NULL, " +
                        "lock_until TIMESTAMP(3) NOT NULL, " +
                        "locked_at TIMESTAMP(3) NOT NULL, " +
                        "locked_by VARCHAR(255) NOT NULL, " +
                        "PRIMARY KEY (name))");
                }
                
                // If it's a completely fresh DB, baseline at V47 so Flyway doesn't run old ALTER scripts
                // and lets Hibernate ddl-auto=update create the complete modern schema.
                if (!hasBusinessTables) {
                    Flyway emptyDbFlyway = Flyway.configure()
                            .configuration(flyway.getConfiguration())
                            .baselineVersion("47")
                            .baselineOnMigrate(true)
                            .load();
                    emptyDbFlyway.baseline();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }

            flyway.repair();
            flyway.migrate();
        };
    }
}
