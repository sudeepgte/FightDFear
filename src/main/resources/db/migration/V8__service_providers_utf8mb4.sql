-- Mobile Service Partner registration includes ₹ and other Unicode in description.
-- Use the connected database (DB_URL), not the hardcoded legacy name.
SET @db = DATABASE();
SET @sql = CONCAT('ALTER DATABASE `', @db, '` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @t = (SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'service_providers');
SET @sql = IF(@t > 0, 'ALTER TABLE service_providers CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
