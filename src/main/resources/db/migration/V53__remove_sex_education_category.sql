-- V53: Migrate existing videos with category SEX_EDUCATION to AWARENESS
SET @t = (SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'videos');

SET @sql1 = IF(@t > 0, "UPDATE videos SET category = 'AWARENESS' WHERE UPPER(TRIM(category)) = 'SEX_EDUCATION'", 'SELECT 1');
PREPARE stmt1 FROM @sql1; EXECUTE stmt1; DEALLOCATE PREPARE stmt1;
