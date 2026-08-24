-- Financial Literacy 10/10: educator extras, session fees, enrollment pay/notes/reviews.

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'financial_educators' AND column_name = 'designation');
SET @sql = IF(@exists = 0, 'ALTER TABLE financial_educators ADD COLUMN designation VARCHAR(80) NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'financial_educators' AND column_name = 'whatsapp_number');
SET @sql = IF(@exists = 0, 'ALTER TABLE financial_educators ADD COLUMN whatsapp_number VARCHAR(32) NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'financial_educators' AND column_name = 'address');
SET @sql = IF(@exists = 0, 'ALTER TABLE financial_educators ADD COLUMN address TEXT NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'financial_educators' AND column_name = 'state');
SET @sql = IF(@exists = 0, 'ALTER TABLE financial_educators ADD COLUMN state VARCHAR(80) NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'financial_educators' AND column_name = 'pincode');
SET @sql = IF(@exists = 0, 'ALTER TABLE financial_educators ADD COLUMN pincode VARCHAR(12) NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'financial_educators' AND column_name = 'latitude');
SET @sql = IF(@exists = 0, 'ALTER TABLE financial_educators ADD COLUMN latitude DOUBLE NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'financial_educators' AND column_name = 'longitude');
SET @sql = IF(@exists = 0, 'ALTER TABLE financial_educators ADD COLUMN longitude DOUBLE NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'financial_educators' AND column_name = 'categories_offered');
SET @sql = IF(@exists = 0, 'ALTER TABLE financial_educators ADD COLUMN categories_offered TEXT NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'financial_educators' AND column_name = 'audience');
SET @sql = IF(@exists = 0, 'ALTER TABLE financial_educators ADD COLUMN audience VARCHAR(255) NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'financial_educators' AND column_name = 'door_service');
SET @sql = IF(@exists = 0, 'ALTER TABLE financial_educators ADD COLUMN door_service BIT(1) NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'financial_educators' AND column_name = 'facilities');
SET @sql = IF(@exists = 0, 'ALTER TABLE financial_educators ADD COLUMN facilities TEXT NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'financial_educators' AND column_name = 'open_days');
SET @sql = IF(@exists = 0, 'ALTER TABLE financial_educators ADD COLUMN open_days VARCHAR(80) NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'financial_educators' AND column_name = 'open_time');
SET @sql = IF(@exists = 0, 'ALTER TABLE financial_educators ADD COLUMN open_time TIME NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'financial_educators' AND column_name = 'close_time');
SET @sql = IF(@exists = 0, 'ALTER TABLE financial_educators ADD COLUMN close_time TIME NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'financial_educators' AND column_name = 'break_start');
SET @sql = IF(@exists = 0, 'ALTER TABLE financial_educators ADD COLUMN break_start TIME NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'financial_educators' AND column_name = 'break_end');
SET @sql = IF(@exists = 0, 'ALTER TABLE financial_educators ADD COLUMN break_end TIME NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'financial_educators' AND column_name = 'blocked_dates');
SET @sql = IF(@exists = 0, 'ALTER TABLE financial_educators ADD COLUMN blocked_dates TEXT NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'financial_educators' AND column_name = 'credential_number');
SET @sql = IF(@exists = 0, 'ALTER TABLE financial_educators ADD COLUMN credential_number VARCHAR(80) NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'financial_educators' AND column_name = 'session_mode');
SET @sql = IF(@exists = 0, 'ALTER TABLE financial_educators ADD COLUMN session_mode VARCHAR(40) NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'financial_educators' AND column_name = 'duration_minutes');
SET @sql = IF(@exists = 0, 'ALTER TABLE financial_educators ADD COLUMN duration_minutes INT NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'financial_educators' AND column_name = 'buffer_minutes');
SET @sql = IF(@exists = 0, 'ALTER TABLE financial_educators ADD COLUMN buffer_minutes INT NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'financial_educators' AND column_name = 'typical_price');
SET @sql = IF(@exists = 0, 'ALTER TABLE financial_educators ADD COLUMN typical_price DOUBLE NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'financial_educators' AND column_name = 'upi_id');
SET @sql = IF(@exists = 0, 'ALTER TABLE financial_educators ADD COLUMN upi_id VARCHAR(120) NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'financial_educators' AND column_name = 'bank_details');
SET @sql = IF(@exists = 0, 'ALTER TABLE financial_educators ADD COLUMN bank_details VARCHAR(255) NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'financial_educators' AND column_name = 'payout_balance');
SET @sql = IF(@exists = 0, 'ALTER TABLE financial_educators ADD COLUMN payout_balance DOUBLE NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'financial_educators' AND column_name = 'payout_requested_at');
SET @sql = IF(@exists = 0, 'ALTER TABLE financial_educators ADD COLUMN payout_requested_at DATETIME NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'financial_educators' AND column_name = 'profile_photo_path');
SET @sql = IF(@exists = 0, 'ALTER TABLE financial_educators ADD COLUMN profile_photo_path VARCHAR(500) NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'financial_educators' AND column_name = 'gallery_photos');
SET @sql = IF(@exists = 0, 'ALTER TABLE financial_educators ADD COLUMN gallery_photos TEXT NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'financial_educators' AND column_name = 'rating');
SET @sql = IF(@exists = 0, 'ALTER TABLE financial_educators ADD COLUMN rating DOUBLE NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'financial_educators' AND column_name = 'review_count');
SET @sql = IF(@exists = 0, 'ALTER TABLE financial_educators ADD COLUMN review_count INT NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'financial_live_sessions' AND column_name = 'fee');
SET @sql = IF(@exists = 0, 'ALTER TABLE financial_live_sessions ADD COLUMN fee DOUBLE NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'financial_live_sessions' AND column_name = 'category');
SET @sql = IF(@exists = 0, 'ALTER TABLE financial_live_sessions ADD COLUMN category VARCHAR(80) NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'financial_workshops' AND column_name = 'fee');
SET @sql = IF(@exists = 0, 'ALTER TABLE financial_workshops ADD COLUMN fee DOUBLE NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'financial_workshops' AND column_name = 'category');
SET @sql = IF(@exists = 0, 'ALTER TABLE financial_workshops ADD COLUMN category VARCHAR(80) NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'financial_enrollments' AND column_name = 'payment_status');
SET @sql = IF(@exists = 0, 'ALTER TABLE financial_enrollments ADD COLUMN payment_status VARCHAR(24) NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'financial_enrollments' AND column_name = 'amount');
SET @sql = IF(@exists = 0, 'ALTER TABLE financial_enrollments ADD COLUMN amount DOUBLE NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'financial_enrollments' AND column_name = 'razorpay_payment_id');
SET @sql = IF(@exists = 0, 'ALTER TABLE financial_enrollments ADD COLUMN razorpay_payment_id VARCHAR(80) NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'financial_enrollments' AND column_name = 'coach_notes');
SET @sql = IF(@exists = 0, 'ALTER TABLE financial_enrollments ADD COLUMN coach_notes TEXT NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'financial_enrollments' AND column_name = 'rating');
SET @sql = IF(@exists = 0, 'ALTER TABLE financial_enrollments ADD COLUMN rating INT NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'financial_enrollments' AND column_name = 'review');
SET @sql = IF(@exists = 0, 'ALTER TABLE financial_enrollments ADD COLUMN review TEXT NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'financial_enrollments' AND column_name = 'payout_credited');
SET @sql = IF(@exists = 0, 'ALTER TABLE financial_enrollments ADD COLUMN payout_credited BIT(1) NULL', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
