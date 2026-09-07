-- Creator Hub Join Us profile lifecycle on `user` (videos remain user-owned).
-- Existing verified creators are treated as already approved.

SET @t = (
    SELECT COUNT(*) FROM information_schema.tables
    WHERE table_schema = DATABASE() AND table_name = 'user'
);

SET @exists = (SELECT COUNT(*) FROM information_schema.columns
    WHERE table_schema = DATABASE() AND table_name = 'user' AND column_name = 'creator_profile_status');
SET @sql = IF(@t > 0 AND @exists = 0, 'ALTER TABLE `user` ADD COLUMN creator_profile_status VARCHAR(40) NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns
    WHERE table_schema = DATABASE() AND table_name = 'user' AND column_name = 'creator_category');
SET @sql = IF(@t > 0 AND @exists = 0, 'ALTER TABLE `user` ADD COLUMN creator_category VARCHAR(80) NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns
    WHERE table_schema = DATABASE() AND table_name = 'user' AND column_name = 'creator_city');
SET @sql = IF(@t > 0 AND @exists = 0, 'ALTER TABLE `user` ADD COLUMN creator_city VARCHAR(80) NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns
    WHERE table_schema = DATABASE() AND table_name = 'user' AND column_name = 'creator_bio');
SET @sql = IF(@t > 0 AND @exists = 0, 'ALTER TABLE `user` ADD COLUMN creator_bio VARCHAR(1000) NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns
    WHERE table_schema = DATABASE() AND table_name = 'user' AND column_name = 'creator_handle');
SET @sql = IF(@t > 0 AND @exists = 0, 'ALTER TABLE `user` ADD COLUMN creator_handle VARCHAR(60) NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns
    WHERE table_schema = DATABASE() AND table_name = 'user' AND column_name = 'creator_profile_completion_pct');
SET @sql = IF(@t > 0 AND @exists = 0, 'ALTER TABLE `user` ADD COLUMN creator_profile_completion_pct INT NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns
    WHERE table_schema = DATABASE() AND table_name = 'user' AND column_name = 'creator_submitted_for_verification_at');
SET @sql = IF(@t > 0 AND @exists = 0, 'ALTER TABLE `user` ADD COLUMN creator_submitted_for_verification_at DATETIME NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns
    WHERE table_schema = DATABASE() AND table_name = 'user' AND column_name = 'creator_rejection_reason');
SET @sql = IF(@t > 0 AND @exists = 0, 'ALTER TABLE `user` ADD COLUMN creator_rejection_reason VARCHAR(500) NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns
    WHERE table_schema = DATABASE() AND table_name = 'user' AND column_name = 'creator_changes_requested_note');
SET @sql = IF(@t > 0 AND @exists = 0, 'ALTER TABLE `user` ADD COLUMN creator_changes_requested_note VARCHAR(500) NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @verified = (SELECT COUNT(*) FROM information_schema.columns
    WHERE table_schema = DATABASE() AND table_name = 'user' AND column_name = 'verified_creator');
SET @sql = IF(@t > 0 AND @verified > 0,
    'UPDATE `user` SET creator_profile_status = ''APPROVED'' WHERE verified_creator = 1 AND (creator_profile_status IS NULL OR creator_profile_status = '''')',
    'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
