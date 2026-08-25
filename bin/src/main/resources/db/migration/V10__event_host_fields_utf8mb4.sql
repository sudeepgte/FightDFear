-- Event Host / Women Events Unicode + long bio.

-- Guard these alters as the tables may not exist yet on a fresh database (Hibernate ddl-auto creates them after Flyway runs).

SET @event_hosts_exists = (
    SELECT COUNT(*) FROM information_schema.tables
    WHERE table_schema = DATABASE() AND table_name = 'event_hosts'
);

SET @sql_eh_1 = IF(@event_hosts_exists > 0, 'ALTER TABLE event_hosts CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci', 'SELECT 1');
PREPARE stmt_eh_1 FROM @sql_eh_1;
EXECUTE stmt_eh_1;
DEALLOCATE PREPARE stmt_eh_1;

SET @sql_eh_2 = IF(@event_hosts_exists > 0, 'ALTER TABLE event_hosts MODIFY COLUMN host_bio TEXT NULL', 'SELECT 1');
PREPARE stmt_eh_2 FROM @sql_eh_2;
EXECUTE stmt_eh_2;
DEALLOCATE PREPARE stmt_eh_2;


-- women_events may not exist yet on a fresh DB (Hibernate ddl-auto creates it
-- after Flyway runs), so only convert it when present; MySQL 8 already
-- defaults new tables to utf8mb4 anyway.
CREATE TABLE IF NOT EXISTS event_hosts (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    host_bio TEXT NULL
);

ALTER TABLE event_hosts CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE event_hosts MODIFY COLUMN host_bio TEXT NULL;


SET @women_events_exists = (
    SELECT COUNT(*) FROM information_schema.tables
    WHERE table_schema = DATABASE() AND table_name = 'women_events'
);
SET @sql = IF(@women_events_exists > 0,
    'ALTER TABLE women_events CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci',
    'DO 0');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

