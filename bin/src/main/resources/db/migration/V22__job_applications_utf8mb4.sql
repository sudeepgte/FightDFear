-- job_applications.note was added as TEXT on a latin1 table, so ₹ / Hindi fail insert.
SET @exists = (
    SELECT COUNT(*) FROM information_schema.tables
    WHERE table_schema = DATABASE() AND table_name = 'job_applications'
);
SET @sql = IF(@exists > 0,
    'ALTER TABLE job_applications CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci',
    'DO 0');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;
