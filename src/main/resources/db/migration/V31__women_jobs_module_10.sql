-- Women Jobs 10/10: worker listing extras, booking file, reviews, favourites, payout.

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'job_applications' AND column_name = 'city');
SET @sql = IF(@exists = 0, 'ALTER TABLE job_applications ADD COLUMN city VARCHAR(80) NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'job_applications' AND column_name = 'state');
SET @sql = IF(@exists = 0, 'ALTER TABLE job_applications ADD COLUMN state VARCHAR(80) NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'job_applications' AND column_name = 'pincode');
SET @sql = IF(@exists = 0, 'ALTER TABLE job_applications ADD COLUMN pincode VARCHAR(12) NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'job_applications' AND column_name = 'address');
SET @sql = IF(@exists = 0, 'ALTER TABLE job_applications ADD COLUMN address VARCHAR(255) NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'job_applications' AND column_name = 'latitude');
SET @sql = IF(@exists = 0, 'ALTER TABLE job_applications ADD COLUMN latitude DOUBLE NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'job_applications' AND column_name = 'longitude');
SET @sql = IF(@exists = 0, 'ALTER TABLE job_applications ADD COLUMN longitude DOUBLE NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'job_applications' AND column_name = 'designation');
SET @sql = IF(@exists = 0, 'ALTER TABLE job_applications ADD COLUMN designation VARCHAR(80) NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'job_applications' AND column_name = 'whatsapp_number');
SET @sql = IF(@exists = 0, 'ALTER TABLE job_applications ADD COLUMN whatsapp_number VARCHAR(32) NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'job_applications' AND column_name = 'years_experience');
SET @sql = IF(@exists = 0, 'ALTER TABLE job_applications ADD COLUMN years_experience INT NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'job_applications' AND column_name = 'categories_offered');
SET @sql = IF(@exists = 0, 'ALTER TABLE job_applications ADD COLUMN categories_offered TEXT NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'job_applications' AND column_name = 'audience');
SET @sql = IF(@exists = 0, 'ALTER TABLE job_applications ADD COLUMN audience VARCHAR(120) NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'job_applications' AND column_name = 'door_service');
SET @sql = IF(@exists = 0, 'ALTER TABLE job_applications ADD COLUMN door_service BIT(1) NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'job_applications' AND column_name = 'languages');
SET @sql = IF(@exists = 0, 'ALTER TABLE job_applications ADD COLUMN languages TEXT NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'job_applications' AND column_name = 'skills');
SET @sql = IF(@exists = 0, 'ALTER TABLE job_applications ADD COLUMN skills TEXT NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'job_applications' AND column_name = 'facilities');
SET @sql = IF(@exists = 0, 'ALTER TABLE job_applications ADD COLUMN facilities TEXT NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'job_applications' AND column_name = 'open_days');
SET @sql = IF(@exists = 0, 'ALTER TABLE job_applications ADD COLUMN open_days VARCHAR(80) NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'job_applications' AND column_name = 'open_time');
SET @sql = IF(@exists = 0, 'ALTER TABLE job_applications ADD COLUMN open_time TIME NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'job_applications' AND column_name = 'close_time');
SET @sql = IF(@exists = 0, 'ALTER TABLE job_applications ADD COLUMN close_time TIME NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'job_applications' AND column_name = 'break_start');
SET @sql = IF(@exists = 0, 'ALTER TABLE job_applications ADD COLUMN break_start TIME NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'job_applications' AND column_name = 'break_end');
SET @sql = IF(@exists = 0, 'ALTER TABLE job_applications ADD COLUMN break_end TIME NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'job_applications' AND column_name = 'blocked_dates');
SET @sql = IF(@exists = 0, 'ALTER TABLE job_applications ADD COLUMN blocked_dates TEXT NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'job_applications' AND column_name = 'bio');
SET @sql = IF(@exists = 0, 'ALTER TABLE job_applications ADD COLUMN bio TEXT NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'job_applications' AND column_name = 'duration_minutes');
SET @sql = IF(@exists = 0, 'ALTER TABLE job_applications ADD COLUMN duration_minutes INT NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'job_applications' AND column_name = 'buffer_minutes');
SET @sql = IF(@exists = 0, 'ALTER TABLE job_applications ADD COLUMN buffer_minutes INT NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'job_applications' AND column_name = 'service_mode');
SET @sql = IF(@exists = 0, 'ALTER TABLE job_applications ADD COLUMN service_mode VARCHAR(24) NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'job_applications' AND column_name = 'work_type');
SET @sql = IF(@exists = 0, 'ALTER TABLE job_applications ADD COLUMN work_type VARCHAR(40) NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'job_applications' AND column_name = 'upi_id');
SET @sql = IF(@exists = 0, 'ALTER TABLE job_applications ADD COLUMN upi_id VARCHAR(120) NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'job_applications' AND column_name = 'bank_details');
SET @sql = IF(@exists = 0, 'ALTER TABLE job_applications ADD COLUMN bank_details VARCHAR(255) NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'job_applications' AND column_name = 'payout_balance');
SET @sql = IF(@exists = 0, 'ALTER TABLE job_applications ADD COLUMN payout_balance DOUBLE NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'job_applications' AND column_name = 'payout_requested_at');
SET @sql = IF(@exists = 0, 'ALTER TABLE job_applications ADD COLUMN payout_requested_at DATETIME NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'job_applications' AND column_name = 'gallery_photos');
SET @sql = IF(@exists = 0, 'ALTER TABLE job_applications ADD COLUMN gallery_photos TEXT NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'job_applications' AND column_name = 'profile_image_url');
SET @sql = IF(@exists = 0, 'ALTER TABLE job_applications ADD COLUMN profile_image_url VARCHAR(255) NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'job_applications' AND column_name = 'rating');
SET @sql = IF(@exists = 0, 'ALTER TABLE job_applications ADD COLUMN rating DOUBLE NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'worker_bookings' AND column_name = 'coach_notes');
SET @sql = IF(@exists = 0, 'ALTER TABLE worker_bookings ADD COLUMN coach_notes TEXT NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'worker_bookings' AND column_name = 'cancel_reason');
SET @sql = IF(@exists = 0, 'ALTER TABLE worker_bookings ADD COLUMN cancel_reason VARCHAR(255) NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'worker_bookings' AND column_name = 'reminder_1h_sent');
SET @sql = IF(@exists = 0, 'ALTER TABLE worker_bookings ADD COLUMN reminder_1h_sent BIT(1) NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'worker_bookings' AND column_name = 'consent_policy');
SET @sql = IF(@exists = 0, 'ALTER TABLE worker_bookings ADD COLUMN consent_policy BIT(1) NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

CREATE TABLE IF NOT EXISTS job_worker_favorites (
    id BIGINT NOT NULL AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    job_application_id BIGINT NOT NULL,
    created_at DATETIME NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uk_job_fav_user (user_id, job_application_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS job_worker_reviews (
    id BIGINT NOT NULL AUTO_INCREMENT,
    job_application_id BIGINT NOT NULL,
    user_id BIGINT NULL,
    user_name VARCHAR(160) NULL,
    rating INT NULL,
    comment VARCHAR(1000) NULL,
    created_at DATETIME NULL,
    PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
