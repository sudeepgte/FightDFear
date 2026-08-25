-- Partner two-step registration lifecycle columns (mirrors doctor/centre flow).
-- Idempotent: Hibernate ddl-auto=update may already have created these columns.

-- ===== helper: add column only if missing =====
-- Usage pattern repeated per table/column (Flyway-safe; no DELIMITER).

-- fitness_trainers
SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'fitness_trainers' AND column_name = 'partner_profile_status');
SET @sql = IF(@exists = 0, 'ALTER TABLE fitness_trainers ADD COLUMN partner_profile_status VARCHAR(40) NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'fitness_trainers' AND column_name = 'profile_completion_pct');
SET @sql = IF(@exists = 0, 'ALTER TABLE fitness_trainers ADD COLUMN profile_completion_pct INT NULL DEFAULT 0', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'fitness_trainers' AND column_name = 'accepted_terms_at');
SET @sql = IF(@exists = 0, 'ALTER TABLE fitness_trainers ADD COLUMN accepted_terms_at DATETIME NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'fitness_trainers' AND column_name = 'submitted_for_verification_at');
SET @sql = IF(@exists = 0, 'ALTER TABLE fitness_trainers ADD COLUMN submitted_for_verification_at DATETIME NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'fitness_trainers' AND column_name = 'rejection_reason');
SET @sql = IF(@exists = 0, 'ALTER TABLE fitness_trainers ADD COLUMN rejection_reason TEXT NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'fitness_trainers' AND column_name = 'changes_requested_note');
SET @sql = IF(@exists = 0, 'ALTER TABLE fitness_trainers ADD COLUMN changes_requested_note TEXT NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'fitness_trainers' AND column_name = 'city');
SET @sql = IF(@exists = 0, 'ALTER TABLE fitness_trainers ADD COLUMN city VARCHAR(120) NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'fitness_trainers' AND column_name = 'bio');
SET @sql = IF(@exists = 0, 'ALTER TABLE fitness_trainers ADD COLUMN bio TEXT NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'fitness_trainers' AND column_name = 'service_type');
SET @sql = IF(@exists = 0, 'ALTER TABLE fitness_trainers ADD COLUMN service_type VARCHAR(80) NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

UPDATE fitness_trainers
SET partner_profile_status = 'APPROVED', profile_completion_pct = 100
WHERE verification_status = 'VERIFIED' AND (partner_profile_status IS NULL OR partner_profile_status = '');

UPDATE fitness_trainers
SET partner_profile_status = 'REJECTED', profile_completion_pct = COALESCE(profile_completion_pct, 40)
WHERE verification_status = 'REJECTED' AND (partner_profile_status IS NULL OR partner_profile_status = '');

UPDATE fitness_trainers
SET partner_profile_status = 'PENDING_ADMIN_APPROVAL', profile_completion_pct = COALESCE(profile_completion_pct, 80)
WHERE verification_status = 'PENDING'
  AND specializations IS NOT NULL AND TRIM(specializations) <> ''
  AND (partner_profile_status IS NULL OR partner_profile_status = '');

UPDATE fitness_trainers
SET partner_profile_status = 'PROFILE_INCOMPLETE', profile_completion_pct = COALESCE(profile_completion_pct, 20)
WHERE (partner_profile_status IS NULL OR partner_profile_status = '');

-- salons
SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'salons' AND column_name = 'partner_profile_status');
SET @sql = IF(@exists = 0, 'ALTER TABLE salons ADD COLUMN partner_profile_status VARCHAR(40) NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'salons' AND column_name = 'profile_completion_pct');
SET @sql = IF(@exists = 0, 'ALTER TABLE salons ADD COLUMN profile_completion_pct INT NULL DEFAULT 0', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'salons' AND column_name = 'accepted_terms_at');
SET @sql = IF(@exists = 0, 'ALTER TABLE salons ADD COLUMN accepted_terms_at DATETIME NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'salons' AND column_name = 'submitted_for_verification_at');
SET @sql = IF(@exists = 0, 'ALTER TABLE salons ADD COLUMN submitted_for_verification_at DATETIME NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'salons' AND column_name = 'rejection_reason');
SET @sql = IF(@exists = 0, 'ALTER TABLE salons ADD COLUMN rejection_reason TEXT NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'salons' AND column_name = 'changes_requested_note');
SET @sql = IF(@exists = 0, 'ALTER TABLE salons ADD COLUMN changes_requested_note TEXT NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

UPDATE salons
SET partner_profile_status = 'APPROVED', profile_completion_pct = 100
WHERE approved = 1 AND (partner_profile_status IS NULL OR partner_profile_status = '');

UPDATE salons
SET partner_profile_status = 'PENDING_ADMIN_APPROVAL', profile_completion_pct = COALESCE(profile_completion_pct, 80)
WHERE approved = 0 AND (partner_profile_status IS NULL OR partner_profile_status = '');

-- stylists
SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'stylists' AND column_name = 'partner_profile_status');
SET @sql = IF(@exists = 0, 'ALTER TABLE stylists ADD COLUMN partner_profile_status VARCHAR(40) NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'stylists' AND column_name = 'profile_completion_pct');
SET @sql = IF(@exists = 0, 'ALTER TABLE stylists ADD COLUMN profile_completion_pct INT NULL DEFAULT 0', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'stylists' AND column_name = 'accepted_terms_at');
SET @sql = IF(@exists = 0, 'ALTER TABLE stylists ADD COLUMN accepted_terms_at DATETIME NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'stylists' AND column_name = 'submitted_for_verification_at');
SET @sql = IF(@exists = 0, 'ALTER TABLE stylists ADD COLUMN submitted_for_verification_at DATETIME NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'stylists' AND column_name = 'rejection_reason');
SET @sql = IF(@exists = 0, 'ALTER TABLE stylists ADD COLUMN rejection_reason TEXT NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'stylists' AND column_name = 'changes_requested_note');
SET @sql = IF(@exists = 0, 'ALTER TABLE stylists ADD COLUMN changes_requested_note TEXT NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

UPDATE stylists
SET partner_profile_status = 'APPROVED', profile_completion_pct = 100
WHERE approved = 1 AND (partner_profile_status IS NULL OR partner_profile_status = '');

UPDATE stylists
SET partner_profile_status = 'PENDING_ADMIN_APPROVAL', profile_completion_pct = COALESCE(profile_completion_pct, 80)
WHERE approved = 0 AND (partner_profile_status IS NULL OR partner_profile_status = '');

-- service_providers
SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'service_providers' AND column_name = 'partner_profile_status');
SET @sql = IF(@exists = 0, 'ALTER TABLE service_providers ADD COLUMN partner_profile_status VARCHAR(40) NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'service_providers' AND column_name = 'profile_completion_pct');
SET @sql = IF(@exists = 0, 'ALTER TABLE service_providers ADD COLUMN profile_completion_pct INT NULL DEFAULT 0', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'service_providers' AND column_name = 'accepted_terms_at');
SET @sql = IF(@exists = 0, 'ALTER TABLE service_providers ADD COLUMN accepted_terms_at DATETIME NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'service_providers' AND column_name = 'submitted_for_verification_at');
SET @sql = IF(@exists = 0, 'ALTER TABLE service_providers ADD COLUMN submitted_for_verification_at DATETIME NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'service_providers' AND column_name = 'rejection_reason');
SET @sql = IF(@exists = 0, 'ALTER TABLE service_providers ADD COLUMN rejection_reason TEXT NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'service_providers' AND column_name = 'changes_requested_note');
SET @sql = IF(@exists = 0, 'ALTER TABLE service_providers ADD COLUMN changes_requested_note TEXT NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

UPDATE service_providers
SET partner_profile_status = 'APPROVED', profile_completion_pct = 100
WHERE v_status = 'VERIFIED' AND (partner_profile_status IS NULL OR partner_profile_status = '');

UPDATE service_providers
SET partner_profile_status = 'REJECTED', profile_completion_pct = COALESCE(profile_completion_pct, 40)
WHERE v_status = 'REJECTED' AND (partner_profile_status IS NULL OR partner_profile_status = '');

UPDATE service_providers
SET partner_profile_status = 'PENDING_ADMIN_APPROVAL', profile_completion_pct = COALESCE(profile_completion_pct, 80)
WHERE (v_status = 'PENDING' OR v_status IS NULL)
  AND (partner_profile_status IS NULL OR partner_profile_status = '');

-- women_product_sellers
SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'women_product_sellers' AND column_name = 'partner_profile_status');
SET @sql = IF(@exists = 0, 'ALTER TABLE women_product_sellers ADD COLUMN partner_profile_status VARCHAR(40) NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'women_product_sellers' AND column_name = 'profile_completion_pct');
SET @sql = IF(@exists = 0, 'ALTER TABLE women_product_sellers ADD COLUMN profile_completion_pct INT NULL DEFAULT 0', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'women_product_sellers' AND column_name = 'accepted_terms_at');
SET @sql = IF(@exists = 0, 'ALTER TABLE women_product_sellers ADD COLUMN accepted_terms_at DATETIME NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'women_product_sellers' AND column_name = 'submitted_for_verification_at');
SET @sql = IF(@exists = 0, 'ALTER TABLE women_product_sellers ADD COLUMN submitted_for_verification_at DATETIME NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'women_product_sellers' AND column_name = 'rejection_reason');
SET @sql = IF(@exists = 0, 'ALTER TABLE women_product_sellers ADD COLUMN rejection_reason TEXT NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'women_product_sellers' AND column_name = 'changes_requested_note');
SET @sql = IF(@exists = 0, 'ALTER TABLE women_product_sellers ADD COLUMN changes_requested_note TEXT NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

UPDATE women_product_sellers
SET partner_profile_status = 'APPROVED', profile_completion_pct = 100
WHERE verification_status = 'VERIFIED' AND (partner_profile_status IS NULL OR partner_profile_status = '');

UPDATE women_product_sellers
SET partner_profile_status = 'REJECTED', profile_completion_pct = COALESCE(profile_completion_pct, 40)
WHERE verification_status = 'REJECTED' AND (partner_profile_status IS NULL OR partner_profile_status = '');

UPDATE women_product_sellers
SET partner_profile_status = 'PENDING_ADMIN_APPROVAL', profile_completion_pct = COALESCE(profile_completion_pct, 80)
WHERE (verification_status = 'PENDING' OR verification_status IS NULL)
  AND (partner_profile_status IS NULL OR partner_profile_status = '');

-- event_hosts
SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'event_hosts' AND column_name = 'partner_profile_status');
SET @sql = IF(@exists = 0, 'ALTER TABLE event_hosts ADD COLUMN partner_profile_status VARCHAR(40) NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'event_hosts' AND column_name = 'profile_completion_pct');
SET @sql = IF(@exists = 0, 'ALTER TABLE event_hosts ADD COLUMN profile_completion_pct INT NULL DEFAULT 0', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'event_hosts' AND column_name = 'accepted_terms_at');
SET @sql = IF(@exists = 0, 'ALTER TABLE event_hosts ADD COLUMN accepted_terms_at DATETIME NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'event_hosts' AND column_name = 'submitted_for_verification_at');
SET @sql = IF(@exists = 0, 'ALTER TABLE event_hosts ADD COLUMN submitted_for_verification_at DATETIME NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'event_hosts' AND column_name = 'rejection_reason');
SET @sql = IF(@exists = 0, 'ALTER TABLE event_hosts ADD COLUMN rejection_reason TEXT NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'event_hosts' AND column_name = 'changes_requested_note');
SET @sql = IF(@exists = 0, 'ALTER TABLE event_hosts ADD COLUMN changes_requested_note TEXT NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

UPDATE event_hosts
SET partner_profile_status = 'APPROVED', profile_completion_pct = 100
WHERE verification_status = 'VERIFIED' AND (partner_profile_status IS NULL OR partner_profile_status = '');

UPDATE event_hosts
SET partner_profile_status = 'REJECTED', profile_completion_pct = COALESCE(profile_completion_pct, 40)
WHERE verification_status = 'REJECTED' AND (partner_profile_status IS NULL OR partner_profile_status = '');

UPDATE event_hosts
SET partner_profile_status = 'PENDING_ADMIN_APPROVAL', profile_completion_pct = COALESCE(profile_completion_pct, 80)
WHERE (verification_status = 'PENDING' OR verification_status IS NULL)
  AND (partner_profile_status IS NULL OR partner_profile_status = '');

-- entrepreneurs
SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'entrepreneurs' AND column_name = 'partner_profile_status');
SET @sql = IF(@exists = 0, 'ALTER TABLE entrepreneurs ADD COLUMN partner_profile_status VARCHAR(40) NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'entrepreneurs' AND column_name = 'profile_completion_pct');
SET @sql = IF(@exists = 0, 'ALTER TABLE entrepreneurs ADD COLUMN profile_completion_pct INT NULL DEFAULT 0', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'entrepreneurs' AND column_name = 'accepted_terms_at');
SET @sql = IF(@exists = 0, 'ALTER TABLE entrepreneurs ADD COLUMN accepted_terms_at DATETIME NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'entrepreneurs' AND column_name = 'submitted_for_verification_at');
SET @sql = IF(@exists = 0, 'ALTER TABLE entrepreneurs ADD COLUMN submitted_for_verification_at DATETIME NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'entrepreneurs' AND column_name = 'rejection_reason');
SET @sql = IF(@exists = 0, 'ALTER TABLE entrepreneurs ADD COLUMN rejection_reason TEXT NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'entrepreneurs' AND column_name = 'changes_requested_note');
SET @sql = IF(@exists = 0, 'ALTER TABLE entrepreneurs ADD COLUMN changes_requested_note TEXT NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

UPDATE entrepreneurs
SET partner_profile_status = 'APPROVED', profile_completion_pct = 100
WHERE verification_status = 'VERIFIED' AND (partner_profile_status IS NULL OR partner_profile_status = '');

UPDATE entrepreneurs
SET partner_profile_status = 'REJECTED', profile_completion_pct = COALESCE(profile_completion_pct, 40)
WHERE verification_status = 'REJECTED' AND (partner_profile_status IS NULL OR partner_profile_status = '');

UPDATE entrepreneurs
SET partner_profile_status = 'PENDING_ADMIN_APPROVAL', profile_completion_pct = COALESCE(profile_completion_pct, 80)
WHERE (verification_status = 'PENDING' OR verification_status IS NULL)
  AND (partner_profile_status IS NULL OR partner_profile_status = '');

-- investors
SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'investors' AND column_name = 'partner_profile_status');
SET @sql = IF(@exists = 0, 'ALTER TABLE investors ADD COLUMN partner_profile_status VARCHAR(40) NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'investors' AND column_name = 'profile_completion_pct');
SET @sql = IF(@exists = 0, 'ALTER TABLE investors ADD COLUMN profile_completion_pct INT NULL DEFAULT 0', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'investors' AND column_name = 'accepted_terms_at');
SET @sql = IF(@exists = 0, 'ALTER TABLE investors ADD COLUMN accepted_terms_at DATETIME NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'investors' AND column_name = 'submitted_for_verification_at');
SET @sql = IF(@exists = 0, 'ALTER TABLE investors ADD COLUMN submitted_for_verification_at DATETIME NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'investors' AND column_name = 'rejection_reason');
SET @sql = IF(@exists = 0, 'ALTER TABLE investors ADD COLUMN rejection_reason TEXT NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'investors' AND column_name = 'changes_requested_note');
SET @sql = IF(@exists = 0, 'ALTER TABLE investors ADD COLUMN changes_requested_note TEXT NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

UPDATE investors
SET partner_profile_status = 'APPROVED', profile_completion_pct = 100
WHERE verification_status = 'VERIFIED' AND (partner_profile_status IS NULL OR partner_profile_status = '');

UPDATE investors
SET partner_profile_status = 'REJECTED', profile_completion_pct = COALESCE(profile_completion_pct, 40)
WHERE verification_status = 'REJECTED' AND (partner_profile_status IS NULL OR partner_profile_status = '');

UPDATE investors
SET partner_profile_status = 'PENDING_ADMIN_APPROVAL', profile_completion_pct = COALESCE(profile_completion_pct, 80)
WHERE (verification_status = 'PENDING' OR verification_status IS NULL)
  AND (partner_profile_status IS NULL OR partner_profile_status = '');
