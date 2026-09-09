-- V51: Add role column to admin table for Super Admin authorization
SET @t = (SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'admin');
SET @c = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'admin' AND column_name = 'role');
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE admin ADD COLUMN role VARCHAR(32) NOT NULL DEFAULT ''ADMIN''', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
