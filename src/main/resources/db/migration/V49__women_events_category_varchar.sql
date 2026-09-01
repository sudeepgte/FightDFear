-- Legacy Hibernate ddl-auto mapped WomenEventCategory to a MySQL ENUM.
-- Expanded enum values (WOMEN_EMPOWERMENT, CAREER, BUSINESS, ...) were rejected
-- as "Data truncated for column 'category'". Store as VARCHAR like Glow services.

SET @t = (SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'women_events');

SET @sql = IF(@t > 0, 'ALTER TABLE women_events MODIFY COLUMN category VARCHAR(64) NOT NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @c = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'women_events' AND column_name = 'event_format');
SET @sql = IF(@t > 0 AND @c > 0, 'ALTER TABLE women_events MODIFY COLUMN event_format VARCHAR(20) NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @c = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'women_events' AND column_name = 'lifecycle_status');
SET @sql = IF(@t > 0 AND @c > 0, 'ALTER TABLE women_events MODIFY COLUMN lifecycle_status VARCHAR(40) NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
