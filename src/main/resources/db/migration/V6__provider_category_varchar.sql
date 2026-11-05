-- Expand service partner categories beyond legacy enum values.
-- Skip on empty clones: service_providers is created in V57.
SET @t = (SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'service_providers');
SET @sql = IF(@t > 0, 'ALTER TABLE service_providers MODIFY COLUMN provider_category VARCHAR(64) NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
