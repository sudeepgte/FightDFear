-- Event Host / Women Events Unicode + long bio.
-- women_events may not exist yet on a fresh DB (Hibernate ddl-auto creates it
-- after Flyway runs), so only convert it when present; MySQL 8 already
-- defaults new tables to utf8mb4 anyway.
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
