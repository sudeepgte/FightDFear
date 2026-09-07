-- Women Lawyer 10/10 extras on shared service_providers + consult file, favourites.

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'service_providers' AND column_name = 'designation');
SET @sql = IF(@exists = 0, 'ALTER TABLE service_providers ADD COLUMN designation VARCHAR(80) NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'service_providers' AND column_name = 'whatsapp_number');
SET @sql = IF(@exists = 0, 'ALTER TABLE service_providers ADD COLUMN whatsapp_number VARCHAR(32) NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'service_providers' AND column_name = 'address');
SET @sql = IF(@exists = 0, 'ALTER TABLE service_providers ADD COLUMN address VARCHAR(255) NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'service_providers' AND column_name = 'city');
SET @sql = IF(@exists = 0, 'ALTER TABLE service_providers ADD COLUMN city VARCHAR(80) NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'service_providers' AND column_name = 'state');
SET @sql = IF(@exists = 0, 'ALTER TABLE service_providers ADD COLUMN state VARCHAR(80) NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'service_providers' AND column_name = 'pincode');
SET @sql = IF(@exists = 0, 'ALTER TABLE service_providers ADD COLUMN pincode VARCHAR(12) NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'service_providers' AND column_name = 'latitude');
SET @sql = IF(@exists = 0, 'ALTER TABLE service_providers ADD COLUMN latitude DOUBLE NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'service_providers' AND column_name = 'longitude');
SET @sql = IF(@exists = 0, 'ALTER TABLE service_providers ADD COLUMN longitude DOUBLE NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'service_providers' AND column_name = 'audience');
SET @sql = IF(@exists = 0, 'ALTER TABLE service_providers ADD COLUMN audience VARCHAR(255) NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'service_providers' AND column_name = 'door_service');
SET @sql = IF(@exists = 0, 'ALTER TABLE service_providers ADD COLUMN door_service BIT(1) NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'service_providers' AND column_name = 'facilities');
SET @sql = IF(@exists = 0, 'ALTER TABLE service_providers ADD COLUMN facilities TEXT NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'service_providers' AND column_name = 'open_days');
SET @sql = IF(@exists = 0, 'ALTER TABLE service_providers ADD COLUMN open_days VARCHAR(80) NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'service_providers' AND column_name = 'open_time');
SET @sql = IF(@exists = 0, 'ALTER TABLE service_providers ADD COLUMN open_time TIME NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'service_providers' AND column_name = 'close_time');
SET @sql = IF(@exists = 0, 'ALTER TABLE service_providers ADD COLUMN close_time TIME NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'service_providers' AND column_name = 'break_start');
SET @sql = IF(@exists = 0, 'ALTER TABLE service_providers ADD COLUMN break_start TIME NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'service_providers' AND column_name = 'break_end');
SET @sql = IF(@exists = 0, 'ALTER TABLE service_providers ADD COLUMN break_end TIME NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'service_providers' AND column_name = 'blocked_dates');
SET @sql = IF(@exists = 0, 'ALTER TABLE service_providers ADD COLUMN blocked_dates TEXT NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'service_providers' AND column_name = 'bio');
SET @sql = IF(@exists = 0, 'ALTER TABLE service_providers ADD COLUMN bio TEXT NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'service_providers' AND column_name = 'duration_minutes');
SET @sql = IF(@exists = 0, 'ALTER TABLE service_providers ADD COLUMN duration_minutes INT NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'service_providers' AND column_name = 'buffer_minutes');
SET @sql = IF(@exists = 0, 'ALTER TABLE service_providers ADD COLUMN buffer_minutes INT NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'service_providers' AND column_name = 'service_mode');
SET @sql = IF(@exists = 0, 'ALTER TABLE service_providers ADD COLUMN service_mode VARCHAR(24) NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'service_providers' AND column_name = 'upi_id');
SET @sql = IF(@exists = 0, 'ALTER TABLE service_providers ADD COLUMN upi_id VARCHAR(120) NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'service_providers' AND column_name = 'bank_details');
SET @sql = IF(@exists = 0, 'ALTER TABLE service_providers ADD COLUMN bank_details VARCHAR(255) NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'service_providers' AND column_name = 'payout_balance');
SET @sql = IF(@exists = 0, 'ALTER TABLE service_providers ADD COLUMN payout_balance DOUBLE NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'service_providers' AND column_name = 'payout_requested_at');
SET @sql = IF(@exists = 0, 'ALTER TABLE service_providers ADD COLUMN payout_requested_at DATETIME NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'service_providers' AND column_name = 'gallery_photos');
SET @sql = IF(@exists = 0, 'ALTER TABLE service_providers ADD COLUMN gallery_photos TEXT NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'service_providers' AND column_name = 'profile_image_url');
SET @sql = IF(@exists = 0, 'ALTER TABLE service_providers ADD COLUMN profile_image_url VARCHAR(255) NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'provider_bookings' AND column_name = 'total_amount');
SET @sql = IF(@exists = 0, 'ALTER TABLE provider_bookings ADD COLUMN total_amount DOUBLE NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'provider_bookings' AND column_name = 'coach_notes');
SET @sql = IF(@exists = 0, 'ALTER TABLE provider_bookings ADD COLUMN coach_notes TEXT NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'provider_bookings' AND column_name = 'cancel_reason');
SET @sql = IF(@exists = 0, 'ALTER TABLE provider_bookings ADD COLUMN cancel_reason VARCHAR(255) NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'provider_bookings' AND column_name = 'reminder_1h_sent');
SET @sql = IF(@exists = 0, 'ALTER TABLE provider_bookings ADD COLUMN reminder_1h_sent BIT(1) NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'provider_bookings' AND column_name = 'consent_policy');
SET @sql = IF(@exists = 0, 'ALTER TABLE provider_bookings ADD COLUMN consent_policy BIT(1) NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

CREATE TABLE IF NOT EXISTS lawyer_favorites (
    id BIGINT NOT NULL AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    provider_id BIGINT NOT NULL,
    created_at DATETIME NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uk_lawyer_fav_user (user_id, provider_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
