-- Martial Arts 10/10: centre listing fields, batch extras, reviews, favourites, enrollment notes.

SET @exists = (SELECT COUNT(*) FROM information_schema.columns
    WHERE table_schema = DATABASE() AND table_name = 'martial_arts_center' AND column_name = 'centre_type');
SET @sql = IF(@exists = 0, 'ALTER TABLE martial_arts_center ADD COLUMN centre_type VARCHAR(60) NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns
    WHERE table_schema = DATABASE() AND table_name = 'martial_arts_center' AND column_name = 'designation');
SET @sql = IF(@exists = 0, 'ALTER TABLE martial_arts_center ADD COLUMN designation VARCHAR(60) NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns
    WHERE table_schema = DATABASE() AND table_name = 'martial_arts_center' AND column_name = 'whatsapp_number');
SET @sql = IF(@exists = 0, 'ALTER TABLE martial_arts_center ADD COLUMN whatsapp_number VARCHAR(20) NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns
    WHERE table_schema = DATABASE() AND table_name = 'martial_arts_center' AND column_name = 'year_started');
SET @sql = IF(@exists = 0, 'ALTER TABLE martial_arts_center ADD COLUMN year_started INT NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns
    WHERE table_schema = DATABASE() AND table_name = 'martial_arts_center' AND column_name = 'affiliation');
SET @sql = IF(@exists = 0, 'ALTER TABLE martial_arts_center ADD COLUMN affiliation VARCHAR(80) NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns
    WHERE table_schema = DATABASE() AND table_name = 'martial_arts_center' AND column_name = 'area');
SET @sql = IF(@exists = 0, 'ALTER TABLE martial_arts_center ADD COLUMN area VARCHAR(120) NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns
    WHERE table_schema = DATABASE() AND table_name = 'martial_arts_center' AND column_name = 'city');
SET @sql = IF(@exists = 0, 'ALTER TABLE martial_arts_center ADD COLUMN city VARCHAR(80) NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns
    WHERE table_schema = DATABASE() AND table_name = 'martial_arts_center' AND column_name = 'state');
SET @sql = IF(@exists = 0, 'ALTER TABLE martial_arts_center ADD COLUMN state VARCHAR(80) NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns
    WHERE table_schema = DATABASE() AND table_name = 'martial_arts_center' AND column_name = 'pincode');
SET @sql = IF(@exists = 0, 'ALTER TABLE martial_arts_center ADD COLUMN pincode VARCHAR(10) NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns
    WHERE table_schema = DATABASE() AND table_name = 'martial_arts_center' AND column_name = 'google_map_location');
SET @sql = IF(@exists = 0, 'ALTER TABLE martial_arts_center ADD COLUMN google_map_location VARCHAR(500) NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns
    WHERE table_schema = DATABASE() AND table_name = 'martial_arts_center' AND column_name = 'centre_lat');
SET @sql = IF(@exists = 0, 'ALTER TABLE martial_arts_center ADD COLUMN centre_lat DOUBLE NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns
    WHERE table_schema = DATABASE() AND table_name = 'martial_arts_center' AND column_name = 'centre_lng');
SET @sql = IF(@exists = 0, 'ALTER TABLE martial_arts_center ADD COLUMN centre_lng DOUBLE NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns
    WHERE table_schema = DATABASE() AND table_name = 'martial_arts_center' AND column_name = 'styles_taught');
SET @sql = IF(@exists = 0, 'ALTER TABLE martial_arts_center ADD COLUMN styles_taught TEXT NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns
    WHERE table_schema = DATABASE() AND table_name = 'martial_arts_center' AND column_name = 'audience');
SET @sql = IF(@exists = 0, 'ALTER TABLE martial_arts_center ADD COLUMN audience VARCHAR(200) NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns
    WHERE table_schema = DATABASE() AND table_name = 'martial_arts_center' AND column_name = 'women_only_batches');
SET @sql = IF(@exists = 0, 'ALTER TABLE martial_arts_center ADD COLUMN women_only_batches BIT NULL DEFAULT 0', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns
    WHERE table_schema = DATABASE() AND table_name = 'martial_arts_center' AND column_name = 'female_instructor');
SET @sql = IF(@exists = 0, 'ALTER TABLE martial_arts_center ADD COLUMN female_instructor BIT NULL DEFAULT 0', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns
    WHERE table_schema = DATABASE() AND table_name = 'martial_arts_center' AND column_name = 'age_groups');
SET @sql = IF(@exists = 0, 'ALTER TABLE martial_arts_center ADD COLUMN age_groups VARCHAR(200) NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns
    WHERE table_schema = DATABASE() AND table_name = 'martial_arts_center' AND column_name = 'facilities');
SET @sql = IF(@exists = 0, 'ALTER TABLE martial_arts_center ADD COLUMN facilities TEXT NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns
    WHERE table_schema = DATABASE() AND table_name = 'martial_arts_center' AND column_name = 'open_time');
SET @sql = IF(@exists = 0, 'ALTER TABLE martial_arts_center ADD COLUMN open_time VARCHAR(8) NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns
    WHERE table_schema = DATABASE() AND table_name = 'martial_arts_center' AND column_name = 'close_time');
SET @sql = IF(@exists = 0, 'ALTER TABLE martial_arts_center ADD COLUMN close_time VARCHAR(8) NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns
    WHERE table_schema = DATABASE() AND table_name = 'martial_arts_center' AND column_name = 'break_start');
SET @sql = IF(@exists = 0, 'ALTER TABLE martial_arts_center ADD COLUMN break_start VARCHAR(8) NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns
    WHERE table_schema = DATABASE() AND table_name = 'martial_arts_center' AND column_name = 'break_end');
SET @sql = IF(@exists = 0, 'ALTER TABLE martial_arts_center ADD COLUMN break_end VARCHAR(8) NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns
    WHERE table_schema = DATABASE() AND table_name = 'martial_arts_center' AND column_name = 'blocked_dates');
SET @sql = IF(@exists = 0, 'ALTER TABLE martial_arts_center ADD COLUMN blocked_dates TEXT NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns
    WHERE table_schema = DATABASE() AND table_name = 'martial_arts_center' AND column_name = 'starting_fee');
SET @sql = IF(@exists = 0, 'ALTER TABLE martial_arts_center ADD COLUMN starting_fee DOUBLE NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns
    WHERE table_schema = DATABASE() AND table_name = 'martial_arts_center' AND column_name = 'trial_available');
SET @sql = IF(@exists = 0, 'ALTER TABLE martial_arts_center ADD COLUMN trial_available BIT NULL DEFAULT 0', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns
    WHERE table_schema = DATABASE() AND table_name = 'martial_arts_center' AND column_name = 'upi_id');
SET @sql = IF(@exists = 0, 'ALTER TABLE martial_arts_center ADD COLUMN upi_id VARCHAR(80) NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns
    WHERE table_schema = DATABASE() AND table_name = 'martial_arts_center' AND column_name = 'bank_details');
SET @sql = IF(@exists = 0, 'ALTER TABLE martial_arts_center ADD COLUMN bank_details VARCHAR(255) NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns
    WHERE table_schema = DATABASE() AND table_name = 'martial_arts_center' AND column_name = 'payout_balance');
SET @sql = IF(@exists = 0, 'ALTER TABLE martial_arts_center ADD COLUMN payout_balance DOUBLE NULL DEFAULT 0', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns
    WHERE table_schema = DATABASE() AND table_name = 'martial_arts_center' AND column_name = 'payout_requested_at');
SET @sql = IF(@exists = 0, 'ALTER TABLE martial_arts_center ADD COLUMN payout_requested_at DATETIME NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns
    WHERE table_schema = DATABASE() AND table_name = 'martial_arts_center' AND column_name = 'rating');
SET @sql = IF(@exists = 0, 'ALTER TABLE martial_arts_center ADD COLUMN rating DOUBLE NULL DEFAULT 0', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns
    WHERE table_schema = DATABASE() AND table_name = 'martial_arts_batch' AND column_name = 'admission_fee');
SET @sql = IF(@exists = 0, 'ALTER TABLE martial_arts_batch ADD COLUMN admission_fee DOUBLE NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns
    WHERE table_schema = DATABASE() AND table_name = 'martial_arts_batch' AND column_name = 'trial_type');
SET @sql = IF(@exists = 0, 'ALTER TABLE martial_arts_batch ADD COLUMN trial_type VARCHAR(20) NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns
    WHERE table_schema = DATABASE() AND table_name = 'martial_arts_batch' AND column_name = 'buffer_minutes');
SET @sql = IF(@exists = 0, 'ALTER TABLE martial_arts_batch ADD COLUMN buffer_minutes INT NULL DEFAULT 0', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns
    WHERE table_schema = DATABASE() AND table_name = 'enrollment' AND column_name = 'coach_notes');
SET @sql = IF(@exists = 0, 'ALTER TABLE enrollment ADD COLUMN coach_notes TEXT NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns
    WHERE table_schema = DATABASE() AND table_name = 'enrollment' AND column_name = 'reminder_1h_sent');
SET @sql = IF(@exists = 0, 'ALTER TABLE enrollment ADD COLUMN reminder_1h_sent BIT NULL DEFAULT 0', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns
    WHERE table_schema = DATABASE() AND table_name = 'enrollment' AND column_name = 'cancel_reason');
SET @sql = IF(@exists = 0, 'ALTER TABLE enrollment ADD COLUMN cancel_reason VARCHAR(255) NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

CREATE TABLE IF NOT EXISTS centre_favorites (
    user_id BIGINT NOT NULL,
    centre_id BIGINT NOT NULL,
    created_at DATETIME NULL,
    PRIMARY KEY (user_id, centre_id)
);

CREATE TABLE IF NOT EXISTS centre_reviews (
    id BIGINT NOT NULL AUTO_INCREMENT,
    user_id BIGINT NULL,
    centre_id BIGINT NULL,
    rating INT NULL,
    comment VARCHAR(1000) NULL,
    created_at DATETIME NULL,
    PRIMARY KEY (id)
);

SET @exists = (SELECT COUNT(*) FROM information_schema.columns
    WHERE table_schema = DATABASE() AND table_name = 'enrollment' AND column_name = 'transfer_used');
SET @sql = IF(@exists = 0, 'ALTER TABLE enrollment ADD COLUMN transfer_used BIT NULL DEFAULT 0', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns
    WHERE table_schema = DATABASE() AND table_name = 'enrollment' AND column_name = 'enrolled_at');
SET @sql = IF(@exists = 0, 'ALTER TABLE enrollment ADD COLUMN enrolled_at DATETIME NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns
    WHERE table_schema = DATABASE() AND table_name = 'martial_arts_batch' AND column_name = 'duration_minutes');
SET @sql = IF(@exists = 0, 'ALTER TABLE martial_arts_batch ADD COLUMN duration_minutes INT NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
