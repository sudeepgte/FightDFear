-- Doctor presence + discovery support (idempotent)

SET @t = (SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'doctors');

SET @c = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'doctors' AND column_name = 'is_online');
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE doctors ADD COLUMN is_online TINYINT(1) NOT NULL DEFAULT 0', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @c = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'doctors' AND column_name = 'last_seen_at');
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE doctors ADD COLUMN last_seen_at DATETIME NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
