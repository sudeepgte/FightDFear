-- Fitness trainer online availability for mobile dashboard toggle.

CREATE TABLE IF NOT EXISTS fitness_trainers (
    id BIGINT AUTO_INCREMENT PRIMARY KEY
);

SET @db := DATABASE();

SET @sql := IF(
    (SELECT COUNT(*) FROM information_schema.COLUMNS
     WHERE TABLE_SCHEMA = @db AND TABLE_NAME = 'fitness_trainers' AND COLUMN_NAME = 'online_available') = 0,
    'ALTER TABLE fitness_trainers ADD COLUMN online_available TINYINT(1) NOT NULL DEFAULT 1',
    'SELECT 1'
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;
