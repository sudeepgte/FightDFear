-- V54: Remove initial default 500 consultation fee for unverified/uncompleted doctor profiles
SET @t = (SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'doctors');

SET @sql1 = IF(@t > 0, "UPDATE doctors SET consultation_fee = NULL WHERE (doctor_profile_status IN ('REGISTERED', 'PROFILE_INCOMPLETE', 'CHANGES_REQUESTED') OR doctor_profile_status IS NULL) AND consultation_fee = 500.0", 'SELECT 1');
PREPARE stmt1 FROM @sql1; EXECUTE stmt1; DEALLOCATE PREPARE stmt1;
