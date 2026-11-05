package in.sp.main.Config;

import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.ResultSet;

import javax.sql.DataSource;

import org.flywaydb.core.Flyway;
import org.flywaydb.core.api.MigrationInfo;
import org.flywaydb.core.api.MigrationVersion;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.boot.autoconfigure.flyway.FlywayMigrationStrategy;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

/**
 * Staging/production databases were created by Hibernate {@code ddl-auto=update},
 * so historical Flyway scripts (CREATE/ALTER) fail with "table/column already exists"
 * or checksum mismatch. If the app schema is already present and Flyway has never
 * run, baseline at the latest classpath version and only apply newer migrations.
 */
@Configuration
@ConditionalOnProperty(name = "spring.flyway.enabled", havingValue = "true", matchIfMissing = true)
public class FlywayExistingSchemaConfig {

    private static final Logger log = LoggerFactory.getLogger(FlywayExistingSchemaConfig.class);

    @Bean
    public FlywayMigrationStrategy flywayMigrationStrategy(DataSource dataSource) {
        return flyway -> {
            try {
                if (!schemaHistoryExists(dataSource) && appSchemaExists(dataSource)) {
                    String latest = latestClasspathVersion(flyway);
                    log.info("Existing application schema detected with no Flyway history; baselining at {}", latest);
                    Flyway.configure()
                            .configuration(flyway.getConfiguration())
                            .baselineVersion(latest)
                            .baselineOnMigrate(true)
                            .load()
                            .baseline();
                }
            } catch (Exception e) {
                log.warn("Flyway baseline-for-existing-schema skipped: {}", e.getMessage());
            }

            try {
                flyway.repair();
            } catch (Exception e) {
                log.warn("Flyway repair skipped: {}", e.getMessage());
            }

            try {
                flyway.migrate();
            } catch (Exception e) {
                String msg = e.getMessage() != null ? e.getMessage() : "";
                if (isBenignExistingSchemaError(msg)) {
                    log.warn("Flyway migrate skipped because objects already exist: {}", msg);
                    try {
                        flyway.repair();
                    } catch (Exception ignored) {
                        // history already consistent enough to boot
                    }
                    return;
                }
                throw e;
            }
        };
    }

    private static boolean isBenignExistingSchemaError(String msg) {
        String lower = msg.toLowerCase();
        return lower.contains("already exists")
                || lower.contains("duplicate column")
                || lower.contains("duplicate key name")
                || lower.contains("duplicate entry");
    }

    private static String latestClasspathVersion(Flyway flyway) {
        MigrationVersion max = MigrationVersion.fromVersion("1");
        for (MigrationInfo info : flyway.info().all()) {
            if (info.getVersion() != null && info.getVersion().compareTo(max) > 0) {
                max = info.getVersion();
            }
        }
        return max.toString();
    }

    private static boolean schemaHistoryExists(DataSource dataSource) throws Exception {
        return tableExists(dataSource, "flyway_schema_history");
    }

    private static boolean appSchemaExists(DataSource dataSource) throws Exception {
        return tableExists(dataSource, "user")
                || tableExists(dataSource, "User")
                || tableExists(dataSource, "doctors")
                || tableExists(dataSource, "service_providers");
    }

    private static boolean tableExists(DataSource dataSource, String tableName) throws Exception {
        try (Connection connection = dataSource.getConnection()) {
            DatabaseMetaData meta = connection.getMetaData();
            try (ResultSet tables = meta.getTables(connection.getCatalog(), null, tableName, new String[] {"TABLE"})) {
                if (tables.next()) {
                    return true;
                }
            }
            // MySQL on Windows can store table names with different case.
            try (ResultSet tables = meta.getTables(connection.getCatalog(), null, tableName.toLowerCase(), new String[] {"TABLE"})) {
                return tables.next();
            }
        }
    }
}
