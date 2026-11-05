-- Milestone 3: doctor profile completion fields (idempotent for existing Hibernate-era DBs)

SET @t = (SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'doctors');

SET @c = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'doctors' AND column_name = 'languages');
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE doctors ADD COLUMN languages VARCHAR(500) NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @c = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'doctors' AND column_name = 'services');
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE doctors ADD COLUMN services VARCHAR(1000) NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @c = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'doctors' AND column_name = 'bio');
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE doctors ADD COLUMN bio TEXT NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @c = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'doctors' AND column_name = 'consultation_modes');
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE doctors ADD COLUMN consultation_modes VARCHAR(200) NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @c = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'doctors' AND column_name = 'availability_slots');
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE doctors ADD COLUMN availability_slots TEXT NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @c = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'doctors' AND column_name = 'additional_certificate_path');
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE doctors ADD COLUMN additional_certificate_path VARCHAR(1000) NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
