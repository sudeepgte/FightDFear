-- Self-defense centre profile lifecycle (idempotent for existing Hibernate-era DBs)

SET @t = (SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'martial_arts_center');

SET @c = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'martial_arts_center' AND column_name = 'centre_profile_status');
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE martial_arts_center ADD COLUMN centre_profile_status VARCHAR(40) NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @c = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'martial_arts_center' AND column_name = 'profile_completion_pct');
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE martial_arts_center ADD COLUMN profile_completion_pct INT NULL DEFAULT 0', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @c = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'martial_arts_center' AND column_name = 'accepted_terms_at');
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE martial_arts_center ADD COLUMN accepted_terms_at DATETIME NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @c = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'martial_arts_center' AND column_name = 'submitted_for_verification_at');
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE martial_arts_center ADD COLUMN submitted_for_verification_at DATETIME NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @c = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'martial_arts_center' AND column_name = 'rejection_reason');
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE martial_arts_center ADD COLUMN rejection_reason TEXT NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @c = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'martial_arts_center' AND column_name = 'changes_requested_note');
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE martial_arts_center ADD COLUMN changes_requested_note TEXT NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @c = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'martial_arts_center' AND column_name = 'contact_person');
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE martial_arts_center ADD COLUMN contact_person VARCHAR(120) NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

UPDATE martial_arts_center
SET centre_profile_status = 'APPROVED',
    profile_completion_pct = 100
WHERE approved = 1
  AND (centre_profile_status IS NULL OR centre_profile_status = '');

UPDATE martial_arts_center
SET centre_profile_status = 'PENDING_ADMIN_APPROVAL',
    profile_completion_pct = COALESCE(profile_completion_pct, 80)
WHERE approved = 0
  AND about IS NOT NULL AND TRIM(about) <> ''
  AND (centre_profile_status IS NULL OR centre_profile_status = '');

UPDATE martial_arts_center
SET centre_profile_status = 'PROFILE_INCOMPLETE',
    profile_completion_pct = COALESCE(profile_completion_pct, 20)
WHERE approved = 0
  AND (about IS NULL OR TRIM(about) = '')
  AND (centre_profile_status IS NULL OR centre_profile_status = '');
