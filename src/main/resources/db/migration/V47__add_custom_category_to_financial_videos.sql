-- Idempotent: skip when financial_videos.custom_category already exists

SET @t = (SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'financial_videos');
SET @c = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'financial_videos' AND column_name = 'custom_category');
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE financial_videos ADD COLUMN custom_category VARCHAR(255) DEFAULT NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
