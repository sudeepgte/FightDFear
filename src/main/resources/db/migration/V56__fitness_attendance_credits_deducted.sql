-- Add credits_deducted and make trainer_id nullable for fitness_attendance
SET @t = (SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'fitness_attendance');

-- Add credits_deducted if column doesn't exist
SET @c = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'fitness_attendance' AND column_name = 'credits_deducted');
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE fitness_attendance ADD COLUMN credits_deducted INT DEFAULT 1', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- Make trainer_id nullable if column exists
SET @c_tr = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'fitness_attendance' AND column_name = 'trainer_id');
SET @sql_tr = IF(@t > 0 AND @c_tr > 0, 'ALTER TABLE fitness_attendance MODIFY COLUMN trainer_id BIGINT NULL', 'SELECT 1');
PREPARE stmt_tr FROM @sql_tr; EXECUTE stmt_tr; DEALLOCATE PREPARE stmt_tr;
