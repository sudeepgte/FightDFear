package in.sp.main.Config;

import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

@Component
public class DatabaseSchemaUpdate implements CommandLineRunner {

    @Override
    public void run(String... args) throws Exception {
        // Schema is frozen. Do not ALTER/UPDATE tables on startup.
        // Legacy service_providers category/verification sync lives in
        // V12__sync_service_provider_legacy_columns.sql (guards missing columns).
        // Hibernate ddl-auto is none; keep tables as they are.
    }
}
