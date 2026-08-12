-- Investor / Entrepreneur free-text + Unicode (Rs / long bios).
-- Guard these alters as the tables may not exist yet on a fresh database (Hibernate ddl-auto creates them after Flyway runs).

-- 1. Guard investors table
SET @investors_exists = (
    SELECT COUNT(*) FROM information_schema.tables
    WHERE table_schema = DATABASE() AND table_name = 'investors'
);

SET @sql_inv_1 = IF(@investors_exists > 0, 'ALTER TABLE investors CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci', 'SELECT 1');
PREPARE stmt_inv_1 FROM @sql_inv_1;
EXECUTE stmt_inv_1;
DEALLOCATE PREPARE stmt_inv_1;

SET @sql_inv_2 = IF(@investors_exists > 0, 'ALTER TABLE investors MODIFY COLUMN investment_interests TEXT NULL', 'SELECT 1');
PREPARE stmt_inv_2 FROM @sql_inv_2;
EXECUTE stmt_inv_2;
DEALLOCATE PREPARE stmt_inv_2;

SET @sql_inv_3 = IF(@investors_exists > 0, 'ALTER TABLE investors MODIFY COLUMN preferred_locations TEXT NULL', 'SELECT 1');
PREPARE stmt_inv_3 FROM @sql_inv_3;
EXECUTE stmt_inv_3;
DEALLOCATE PREPARE stmt_inv_3;

SET @sql_inv_4 = IF(@investors_exists > 0, 'ALTER TABLE investors MODIFY COLUMN preferred_categories TEXT NULL', 'SELECT 1');
PREPARE stmt_inv_4 FROM @sql_inv_4;
EXECUTE stmt_inv_4;
DEALLOCATE PREPARE stmt_inv_4;

SET @sql_inv_5 = IF(@investors_exists > 0, 'ALTER TABLE investors MODIFY COLUMN verification_documents TEXT NULL', 'SELECT 1');
PREPARE stmt_inv_5 FROM @sql_inv_5;
EXECUTE stmt_inv_5;
DEALLOCATE PREPARE stmt_inv_5;


-- 2. Guard entrepreneurs table
SET @entrepreneurs_exists = (
    SELECT COUNT(*) FROM information_schema.tables
    WHERE table_schema = DATABASE() AND table_name = 'entrepreneurs'
);

SET @sql_ent_1 = IF(@entrepreneurs_exists > 0, 'ALTER TABLE entrepreneurs CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci', 'SELECT 1');
PREPARE stmt_ent_1 FROM @sql_ent_1;
EXECUTE stmt_ent_1;
DEALLOCATE PREPARE stmt_ent_1;

SET @sql_ent_2 = IF(@entrepreneurs_exists > 0, 'ALTER TABLE entrepreneurs MODIFY COLUMN business_description TEXT NULL', 'SELECT 1');
PREPARE stmt_ent_2 FROM @sql_ent_2;
EXECUTE stmt_ent_2;
DEALLOCATE PREPARE stmt_ent_2;


-- 3. Guard business_proposals table
SET @proposals_exists = (
    SELECT COUNT(*) FROM information_schema.tables
    WHERE table_schema = DATABASE() AND table_name = 'business_proposals'
);

SET @sql_prop_1 = IF(@proposals_exists > 0, 'ALTER TABLE business_proposals CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci', 'SELECT 1');
PREPARE stmt_prop_1 FROM @sql_prop_1;
EXECUTE stmt_prop_1;
DEALLOCATE PREPARE stmt_prop_1;

SET @sql_prop_2 = IF(@proposals_exists > 0, 'ALTER TABLE business_proposals MODIFY COLUMN description TEXT NULL', 'SELECT 1');
PREPARE stmt_prop_2 FROM @sql_prop_2;
EXECUTE stmt_prop_2;
DEALLOCATE PREPARE stmt_prop_2;

