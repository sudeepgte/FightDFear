-- Service Partner registration packs business/hours/portfolio into description.
-- Skip on empty clones: service_providers is created in V57.
SET @t = (SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'service_providers');
SET @sql = IF(@t > 0, 'ALTER TABLE service_providers MODIFY COLUMN description TEXT NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql = IF(@t > 0, 'ALTER TABLE service_providers MODIFY COLUMN location_text TEXT NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
