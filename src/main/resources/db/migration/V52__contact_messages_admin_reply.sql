-- V52: Add admin reply columns to contact_messages table
SET @t = (SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'contact_messages');

SET @c1 = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'contact_messages' AND column_name = 'admin_reply');
SET @sql1 = IF(@t > 0 AND @c1 = 0, 'ALTER TABLE contact_messages ADD COLUMN admin_reply TEXT NULL', 'SELECT 1');
PREPARE stmt1 FROM @sql1; EXECUTE stmt1; DEALLOCATE PREPARE stmt1;

SET @c2 = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'contact_messages' AND column_name = 'replied_at');
SET @sql2 = IF(@t > 0 AND @c2 = 0, 'ALTER TABLE contact_messages ADD COLUMN replied_at DATETIME NULL', 'SELECT 1');
PREPARE stmt2 FROM @sql2; EXECUTE stmt2; DEALLOCATE PREPARE stmt2;

SET @c3 = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'contact_messages' AND column_name = 'reply_read_by_user');
SET @sql3 = IF(@t > 0 AND @c3 = 0, 'ALTER TABLE contact_messages ADD COLUMN reply_read_by_user BOOLEAN NOT NULL DEFAULT FALSE', 'SELECT 1');
PREPARE stmt3 FROM @sql3; EXECUTE stmt3; DEALLOCATE PREPARE stmt3;
