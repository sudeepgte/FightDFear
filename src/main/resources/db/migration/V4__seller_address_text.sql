-- Marketplace seller registration can send multi-line shop details.
-- Skip on empty clones: women_product_sellers is created in V58.
SET @t = (SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'women_product_sellers');
SET @sql = IF(@t > 0, 'ALTER TABLE women_product_sellers MODIFY COLUMN address TEXT NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @sql = IF(@t > 0, 'ALTER TABLE women_product_sellers MODIFY COLUMN description TEXT NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
