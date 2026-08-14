-- Women Lawyer profile extras on shared service_providers (nullable for other categories).
SET @t = (
    SELECT COUNT(*) FROM information_schema.tables
    WHERE table_schema = DATABASE() AND table_name = 'service_providers'
);

SET @exists = (SELECT COUNT(*) FROM information_schema.columns
    WHERE table_schema = DATABASE() AND table_name = 'service_providers' AND column_name = 'practice_areas');
SET @sql = IF(@t > 0 AND @exists = 0, 'ALTER TABLE service_providers ADD COLUMN practice_areas TEXT NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns
    WHERE table_schema = DATABASE() AND table_name = 'service_providers' AND column_name = 'bar_council_id');
SET @sql = IF(@t > 0 AND @exists = 0, 'ALTER TABLE service_providers ADD COLUMN bar_council_id VARCHAR(80) NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns
    WHERE table_schema = DATABASE() AND table_name = 'service_providers' AND column_name = 'experience_years');
SET @sql = IF(@t > 0 AND @exists = 0, 'ALTER TABLE service_providers ADD COLUMN experience_years INT NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns
    WHERE table_schema = DATABASE() AND table_name = 'service_providers' AND column_name = 'languages');
SET @sql = IF(@t > 0 AND @exists = 0, 'ALTER TABLE service_providers ADD COLUMN languages VARCHAR(255) NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns
    WHERE table_schema = DATABASE() AND table_name = 'service_providers' AND column_name = 'consultation_fee');
SET @sql = IF(@t > 0 AND @exists = 0, 'ALTER TABLE service_providers ADD COLUMN consultation_fee DOUBLE NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns
    WHERE table_schema = DATABASE() AND table_name = 'service_providers' AND column_name = 'consultation_mode');
SET @sql = IF(@t > 0 AND @exists = 0, 'ALTER TABLE service_providers ADD COLUMN consultation_mode VARCHAR(40) NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
