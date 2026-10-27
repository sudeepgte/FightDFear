-- V55: Normalize NULL boolean values in contact_messages table
SET @t = (SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'contact_messages');

SET @sql1 = IF(@t > 0, 'UPDATE contact_messages SET reply_read_by_user = FALSE WHERE reply_read_by_user IS NULL', 'SELECT 1');
PREPARE stmt1 FROM @sql1; EXECUTE stmt1; DEALLOCATE PREPARE stmt1;

SET @sql2 = IF(@t > 0, 'UPDATE contact_messages SET read_by_admin = FALSE WHERE read_by_admin IS NULL', 'SELECT 1');
PREPARE stmt2 FROM @sql2; EXECUTE stmt2; DEALLOCATE PREPARE stmt2;

SET @sql3 = IF(@t > 0, 'ALTER TABLE contact_messages MODIFY COLUMN reply_read_by_user BOOLEAN NOT NULL DEFAULT FALSE', 'SELECT 1');
PREPARE stmt3 FROM @sql3; EXECUTE stmt3; DEALLOCATE PREPARE stmt3;

SET @sql4 = IF(@t > 0, 'ALTER TABLE contact_messages MODIFY COLUMN read_by_admin BOOLEAN NOT NULL DEFAULT FALSE', 'SELECT 1');
PREPARE stmt4 FROM @sql4; EXECUTE stmt4; DEALLOCATE PREPARE stmt4;
