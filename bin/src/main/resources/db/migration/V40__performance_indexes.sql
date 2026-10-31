-- Phase 3: safe performance indexes on hot query paths (idempotent via information_schema checks)

SET @exists = (SELECT COUNT(*) FROM information_schema.statistics WHERE table_schema = DATABASE() AND table_name = 'user_videos' AND index_name = 'idx_user_videos_upload_time');
SET @sql = IF(@exists = 0, 'CREATE INDEX idx_user_videos_upload_time ON user_videos (upload_time)', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.statistics WHERE table_schema = DATABASE() AND table_name = 'user_videos' AND index_name = 'idx_user_videos_feed');
SET @sql = IF(@exists = 0, 'CREATE INDEX idx_user_videos_feed ON user_videos (status, is_blocked, is_draft, upload_time)', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.statistics WHERE table_schema = DATABASE() AND table_name = 'user_videos' AND index_name = 'idx_user_videos_uploader');
SET @sql = IF(@exists = 0, 'CREATE INDEX idx_user_videos_uploader ON user_videos (uploader_id)', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.statistics WHERE table_schema = DATABASE() AND table_name = 'doctor_appointments' AND index_name = 'idx_doctor_appt_doctor_time');
SET @sql = IF(@exists = 0, 'CREATE INDEX idx_doctor_appt_doctor_time ON doctor_appointments (doctor_id, appointment_time)', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.statistics WHERE table_schema = DATABASE() AND table_name = 'doctor_appointments' AND index_name = 'idx_doctor_appt_time_status');
SET @sql = IF(@exists = 0, 'CREATE INDEX idx_doctor_appt_time_status ON doctor_appointments (appointment_time, status)', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.statistics WHERE table_schema = DATABASE() AND table_name = 'fitness_bookings' AND index_name = 'idx_fitness_booking_trainer_date');
SET @sql = IF(@exists = 0, 'CREATE INDEX idx_fitness_booking_trainer_date ON fitness_bookings (trainer_id, booking_date)', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.statistics WHERE table_schema = DATABASE() AND table_name = 'provider_bookings' AND index_name = 'idx_provider_booking_provider_time');
SET @sql = IF(@exists = 0, 'CREATE INDEX idx_provider_booking_provider_time ON provider_bookings (provider_id, requested_time)', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.statistics WHERE table_schema = DATABASE() AND table_name = 'provider_bookings' AND index_name = 'idx_provider_booking_time_status');
SET @sql = IF(@exists = 0, 'CREATE INDEX idx_provider_booking_time_status ON provider_bookings (requested_time, status)', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.statistics WHERE table_schema = DATABASE() AND table_name = 'women_event_registrations' AND index_name = 'idx_women_event_reg_event');
SET @sql = IF(@exists = 0, 'CREATE INDEX idx_women_event_reg_event ON women_event_registrations (event_id)', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.statistics WHERE table_schema = DATABASE() AND table_name = 'women_event_registrations' AND index_name = 'idx_women_event_reg_user');
SET @sql = IF(@exists = 0, 'CREATE INDEX idx_women_event_reg_user ON women_event_registrations (user_id)', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.statistics WHERE table_schema = DATABASE() AND table_name = 'booking1' AND index_name = 'idx_booking1_salon_date');
SET @sql = IF(@exists = 0, 'CREATE INDEX idx_booking1_salon_date ON booking1 (salon_id, booking_date)', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.statistics WHERE table_schema = DATABASE() AND table_name = 'booking1' AND index_name = 'idx_booking1_date_status');
SET @sql = IF(@exists = 0, 'CREATE INDEX idx_booking1_date_status ON booking1 (booking_date, status)', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.statistics WHERE table_schema = DATABASE() AND table_name = 'worker_bookings' AND index_name = 'idx_worker_booking_date');
SET @sql = IF(@exists = 0, 'CREATE INDEX idx_worker_booking_date ON worker_bookings (booking_date)', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.statistics WHERE table_schema = DATABASE() AND table_name = 'online_classes' AND index_name = 'idx_online_classes_date_status');
SET @sql = IF(@exists = 0, 'CREATE INDEX idx_online_classes_date_status ON online_classes (date, status)', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
