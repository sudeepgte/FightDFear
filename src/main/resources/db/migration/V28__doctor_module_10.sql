-- Doctor 10/10: slots, payout-ready fields, Rx JSON, reports, chat attachments, favourites.

SET @exists = (SELECT COUNT(*) FROM information_schema.columns
    WHERE table_schema = DATABASE() AND table_name = 'doctors' AND column_name = 'slot_duration_minutes');
SET @sql = IF(@exists = 0, 'ALTER TABLE doctors ADD COLUMN slot_duration_minutes INT NULL DEFAULT 30', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns
    WHERE table_schema = DATABASE() AND table_name = 'doctors' AND column_name = 'buffer_minutes');
SET @sql = IF(@exists = 0, 'ALTER TABLE doctors ADD COLUMN buffer_minutes INT NULL DEFAULT 0', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns
    WHERE table_schema = DATABASE() AND table_name = 'doctors' AND column_name = 'break_start');
SET @sql = IF(@exists = 0, 'ALTER TABLE doctors ADD COLUMN break_start VARCHAR(8) NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns
    WHERE table_schema = DATABASE() AND table_name = 'doctors' AND column_name = 'break_end');
SET @sql = IF(@exists = 0, 'ALTER TABLE doctors ADD COLUMN break_end VARCHAR(8) NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns
    WHERE table_schema = DATABASE() AND table_name = 'doctors' AND column_name = 'blocked_dates');
SET @sql = IF(@exists = 0, 'ALTER TABLE doctors ADD COLUMN blocked_dates TEXT NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns
    WHERE table_schema = DATABASE() AND table_name = 'doctors' AND column_name = 'auto_confirm');
SET @sql = IF(@exists = 0, 'ALTER TABLE doctors ADD COLUMN auto_confirm BIT NULL DEFAULT 0', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns
    WHERE table_schema = DATABASE() AND table_name = 'doctors' AND column_name = 'clinic_photos');
SET @sql = IF(@exists = 0, 'ALTER TABLE doctors ADD COLUMN clinic_photos TEXT NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns
    WHERE table_schema = DATABASE() AND table_name = 'doctors' AND column_name = 'clinic_lat');
SET @sql = IF(@exists = 0, 'ALTER TABLE doctors ADD COLUMN clinic_lat DOUBLE NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns
    WHERE table_schema = DATABASE() AND table_name = 'doctors' AND column_name = 'clinic_lng');
SET @sql = IF(@exists = 0, 'ALTER TABLE doctors ADD COLUMN clinic_lng DOUBLE NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns
    WHERE table_schema = DATABASE() AND table_name = 'doctors' AND column_name = 'payout_requested_at');
SET @sql = IF(@exists = 0, 'ALTER TABLE doctors ADD COLUMN payout_requested_at DATETIME NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns
    WHERE table_schema = DATABASE() AND table_name = 'doctor_appointments' AND column_name = 'prescription_json');
SET @sql = IF(@exists = 0, 'ALTER TABLE doctor_appointments ADD COLUMN prescription_json TEXT NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns
    WHERE table_schema = DATABASE() AND table_name = 'doctor_appointments' AND column_name = 'doctor_notes');
SET @sql = IF(@exists = 0, 'ALTER TABLE doctor_appointments ADD COLUMN doctor_notes TEXT NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns
    WHERE table_schema = DATABASE() AND table_name = 'doctor_appointments' AND column_name = 'report_paths');
SET @sql = IF(@exists = 0, 'ALTER TABLE doctor_appointments ADD COLUMN report_paths TEXT NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns
    WHERE table_schema = DATABASE() AND table_name = 'doctor_appointments' AND column_name = 'follow_up_of_id');
SET @sql = IF(@exists = 0, 'ALTER TABLE doctor_appointments ADD COLUMN follow_up_of_id BIGINT NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns
    WHERE table_schema = DATABASE() AND table_name = 'doctor_appointments' AND column_name = 'reminder_24h_sent');
SET @sql = IF(@exists = 0, 'ALTER TABLE doctor_appointments ADD COLUMN reminder_24h_sent BIT NULL DEFAULT 0', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns
    WHERE table_schema = DATABASE() AND table_name = 'doctor_appointments' AND column_name = 'reminder_1h_sent');
SET @sql = IF(@exists = 0, 'ALTER TABLE doctor_appointments ADD COLUMN reminder_1h_sent BIT NULL DEFAULT 0', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns
    WHERE table_schema = DATABASE() AND table_name = 'doctor_chat_messages' AND column_name = 'attachment_path');
SET @sql = IF(@exists = 0, 'ALTER TABLE doctor_chat_messages ADD COLUMN attachment_path VARCHAR(500) NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

CREATE TABLE IF NOT EXISTS doctor_favorites (
    user_id BIGINT NOT NULL,
    doctor_id BIGINT NOT NULL,
    created_at DATETIME NULL,
    PRIMARY KEY (user_id, doctor_id)
);
