-- Persist worker apply extras (skills, languages, experience) without new skill columns.
SET @exists = (SELECT COUNT(*) FROM information_schema.columns
    WHERE table_schema = DATABASE() AND table_name = 'job_applications' AND column_name = 'note');
SET @sql = IF(@exists = 0, 'ALTER TABLE job_applications ADD COLUMN note TEXT NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
