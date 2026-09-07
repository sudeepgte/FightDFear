-- Glow Space 10/10: salon listing extras, service calendar, booking file, reviews, favourites, payout.

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'salons' AND column_name = 'salon_type');
SET @sql = IF(@exists = 0, 'ALTER TABLE salons ADD COLUMN salon_type VARCHAR(80) NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'salons' AND column_name = 'designation');
SET @sql = IF(@exists = 0, 'ALTER TABLE salons ADD COLUMN designation VARCHAR(80) NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'salons' AND column_name = 'contact_person');
SET @sql = IF(@exists = 0, 'ALTER TABLE salons ADD COLUMN contact_person VARCHAR(160) NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'salons' AND column_name = 'whatsapp_number');
SET @sql = IF(@exists = 0, 'ALTER TABLE salons ADD COLUMN whatsapp_number VARCHAR(32) NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'salons' AND column_name = 'categories_offered');
SET @sql = IF(@exists = 0, 'ALTER TABLE salons ADD COLUMN categories_offered TEXT NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'salons' AND column_name = 'audience');
SET @sql = IF(@exists = 0, 'ALTER TABLE salons ADD COLUMN audience VARCHAR(80) NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'salons' AND column_name = 'door_service');
SET @sql = IF(@exists = 0, 'ALTER TABLE salons ADD COLUMN door_service BIT(1) NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'salons' AND column_name = 'female_staff');
SET @sql = IF(@exists = 0, 'ALTER TABLE salons ADD COLUMN female_staff BIT(1) NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'salons' AND column_name = 'facilities');
SET @sql = IF(@exists = 0, 'ALTER TABLE salons ADD COLUMN facilities TEXT NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'salons' AND column_name = 'open_days');
SET @sql = IF(@exists = 0, 'ALTER TABLE salons ADD COLUMN open_days VARCHAR(80) NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'salons' AND column_name = 'open_time');
SET @sql = IF(@exists = 0, 'ALTER TABLE salons ADD COLUMN open_time TIME NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'salons' AND column_name = 'close_time');
SET @sql = IF(@exists = 0, 'ALTER TABLE salons ADD COLUMN close_time TIME NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'salons' AND column_name = 'break_start');
SET @sql = IF(@exists = 0, 'ALTER TABLE salons ADD COLUMN break_start TIME NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'salons' AND column_name = 'break_end');
SET @sql = IF(@exists = 0, 'ALTER TABLE salons ADD COLUMN break_end TIME NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'salons' AND column_name = 'blocked_dates');
SET @sql = IF(@exists = 0, 'ALTER TABLE salons ADD COLUMN blocked_dates TEXT NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'salons' AND column_name = 'hygiene_notes');
SET @sql = IF(@exists = 0, 'ALTER TABLE salons ADD COLUMN hygiene_notes VARCHAR(500) NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'salons' AND column_name = 'gallery_photos');
SET @sql = IF(@exists = 0, 'ALTER TABLE salons ADD COLUMN gallery_photos TEXT NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'salons' AND column_name = 'upi_id');
SET @sql = IF(@exists = 0, 'ALTER TABLE salons ADD COLUMN upi_id VARCHAR(120) NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'salons' AND column_name = 'bank_details');
SET @sql = IF(@exists = 0, 'ALTER TABLE salons ADD COLUMN bank_details VARCHAR(255) NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'salons' AND column_name = 'payout_balance');
SET @sql = IF(@exists = 0, 'ALTER TABLE salons ADD COLUMN payout_balance DOUBLE NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'salons' AND column_name = 'payout_requested_at');
SET @sql = IF(@exists = 0, 'ALTER TABLE salons ADD COLUMN payout_requested_at DATETIME NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'services' AND column_name = 'buffer_minutes');
SET @sql = IF(@exists = 0, 'ALTER TABLE services ADD COLUMN buffer_minutes INT NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'services' AND column_name = 'service_mode');
SET @sql = IF(@exists = 0, 'ALTER TABLE services ADD COLUMN service_mode VARCHAR(24) NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'booking1' AND column_name = 'created_at');
SET @sql = IF(@exists = 0, 'ALTER TABLE booking1 ADD COLUMN created_at DATETIME NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'booking1' AND column_name = 'coach_notes');
SET @sql = IF(@exists = 0, 'ALTER TABLE booking1 ADD COLUMN coach_notes TEXT NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'booking1' AND column_name = 'cancel_reason');
SET @sql = IF(@exists = 0, 'ALTER TABLE booking1 ADD COLUMN cancel_reason VARCHAR(255) NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'booking1' AND column_name = 'reminder_1h_sent');
SET @sql = IF(@exists = 0, 'ALTER TABLE booking1 ADD COLUMN reminder_1h_sent BIT(1) NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'booking1' AND column_name = 'consent_policy');
SET @sql = IF(@exists = 0, 'ALTER TABLE booking1 ADD COLUMN consent_policy BIT(1) NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'salon_reviews' AND column_name = 'user_id');
SET @sql = IF(@exists = 0, 'ALTER TABLE salon_reviews ADD COLUMN user_id BIGINT NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

CREATE TABLE IF NOT EXISTS salon_favorites (
    id BIGINT NOT NULL AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    salon_id BIGINT NOT NULL,
    created_at DATETIME NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uk_salon_fav_user (user_id, salon_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
