-- Women Products 10/10: seller + delivery extras, order payout/notes.

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'women_product_sellers' AND column_name = 'designation');
SET @sql = IF(@exists = 0, 'ALTER TABLE women_product_sellers ADD COLUMN designation VARCHAR(80) NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'women_product_sellers' AND column_name = 'whatsapp_number');
SET @sql = IF(@exists = 0, 'ALTER TABLE women_product_sellers ADD COLUMN whatsapp_number VARCHAR(32) NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'women_product_sellers' AND column_name = 'city');
SET @sql = IF(@exists = 0, 'ALTER TABLE women_product_sellers ADD COLUMN city VARCHAR(80) NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'women_product_sellers' AND column_name = 'state');
SET @sql = IF(@exists = 0, 'ALTER TABLE women_product_sellers ADD COLUMN state VARCHAR(80) NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'women_product_sellers' AND column_name = 'pincode');
SET @sql = IF(@exists = 0, 'ALTER TABLE women_product_sellers ADD COLUMN pincode VARCHAR(12) NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'women_product_sellers' AND column_name = 'latitude');
SET @sql = IF(@exists = 0, 'ALTER TABLE women_product_sellers ADD COLUMN latitude DOUBLE NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'women_product_sellers' AND column_name = 'longitude');
SET @sql = IF(@exists = 0, 'ALTER TABLE women_product_sellers ADD COLUMN longitude DOUBLE NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'women_product_sellers' AND column_name = 'categories_offered');
SET @sql = IF(@exists = 0, 'ALTER TABLE women_product_sellers ADD COLUMN categories_offered TEXT NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'women_product_sellers' AND column_name = 'brand_type');
SET @sql = IF(@exists = 0, 'ALTER TABLE women_product_sellers ADD COLUMN brand_type VARCHAR(40) NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'women_product_sellers' AND column_name = 'audience');
SET @sql = IF(@exists = 0, 'ALTER TABLE women_product_sellers ADD COLUMN audience VARCHAR(255) NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'women_product_sellers' AND column_name = 'facilities');
SET @sql = IF(@exists = 0, 'ALTER TABLE women_product_sellers ADD COLUMN facilities TEXT NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'women_product_sellers' AND column_name = 'open_days');
SET @sql = IF(@exists = 0, 'ALTER TABLE women_product_sellers ADD COLUMN open_days VARCHAR(80) NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'women_product_sellers' AND column_name = 'open_time');
SET @sql = IF(@exists = 0, 'ALTER TABLE women_product_sellers ADD COLUMN open_time TIME NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'women_product_sellers' AND column_name = 'close_time');
SET @sql = IF(@exists = 0, 'ALTER TABLE women_product_sellers ADD COLUMN close_time TIME NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'women_product_sellers' AND column_name = 'break_start');
SET @sql = IF(@exists = 0, 'ALTER TABLE women_product_sellers ADD COLUMN break_start TIME NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'women_product_sellers' AND column_name = 'break_end');
SET @sql = IF(@exists = 0, 'ALTER TABLE women_product_sellers ADD COLUMN break_end TIME NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'women_product_sellers' AND column_name = 'blocked_dates');
SET @sql = IF(@exists = 0, 'ALTER TABLE women_product_sellers ADD COLUMN blocked_dates TEXT NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'women_product_sellers' AND column_name = 'bio');
SET @sql = IF(@exists = 0, 'ALTER TABLE women_product_sellers ADD COLUMN bio TEXT NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'women_product_sellers' AND column_name = 'dispatch_hours');
SET @sql = IF(@exists = 0, 'ALTER TABLE women_product_sellers ADD COLUMN dispatch_hours INT NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'women_product_sellers' AND column_name = 'typical_price');
SET @sql = IF(@exists = 0, 'ALTER TABLE women_product_sellers ADD COLUMN typical_price DOUBLE NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'women_product_sellers' AND column_name = 'primary_category');
SET @sql = IF(@exists = 0, 'ALTER TABLE women_product_sellers ADD COLUMN primary_category VARCHAR(40) NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'women_product_sellers' AND column_name = 'gstin');
SET @sql = IF(@exists = 0, 'ALTER TABLE women_product_sellers ADD COLUMN gstin VARCHAR(32) NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'women_product_sellers' AND column_name = 'upi_id');
SET @sql = IF(@exists = 0, 'ALTER TABLE women_product_sellers ADD COLUMN upi_id VARCHAR(120) NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'women_product_sellers' AND column_name = 'bank_details');
SET @sql = IF(@exists = 0, 'ALTER TABLE women_product_sellers ADD COLUMN bank_details VARCHAR(255) NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'women_product_sellers' AND column_name = 'payout_balance');
SET @sql = IF(@exists = 0, 'ALTER TABLE women_product_sellers ADD COLUMN payout_balance DOUBLE NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'women_product_sellers' AND column_name = 'payout_requested_at');
SET @sql = IF(@exists = 0, 'ALTER TABLE women_product_sellers ADD COLUMN payout_requested_at DATETIME NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'women_product_sellers' AND column_name = 'gallery_photos');
SET @sql = IF(@exists = 0, 'ALTER TABLE women_product_sellers ADD COLUMN gallery_photos TEXT NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'delivery_partners' AND column_name = 'whatsapp_number');
SET @sql = IF(@exists = 0, 'ALTER TABLE delivery_partners ADD COLUMN whatsapp_number VARCHAR(32) NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'delivery_partners' AND column_name = 'address');
SET @sql = IF(@exists = 0, 'ALTER TABLE delivery_partners ADD COLUMN address VARCHAR(255) NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'delivery_partners' AND column_name = 'state');
SET @sql = IF(@exists = 0, 'ALTER TABLE delivery_partners ADD COLUMN state VARCHAR(80) NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'delivery_partners' AND column_name = 'pincode');
SET @sql = IF(@exists = 0, 'ALTER TABLE delivery_partners ADD COLUMN pincode VARCHAR(12) NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'delivery_partners' AND column_name = 'latitude');
SET @sql = IF(@exists = 0, 'ALTER TABLE delivery_partners ADD COLUMN latitude DOUBLE NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'delivery_partners' AND column_name = 'longitude');
SET @sql = IF(@exists = 0, 'ALTER TABLE delivery_partners ADD COLUMN longitude DOUBLE NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'delivery_partners' AND column_name = 'capabilities');
SET @sql = IF(@exists = 0, 'ALTER TABLE delivery_partners ADD COLUMN capabilities TEXT NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'delivery_partners' AND column_name = 'facilities');
SET @sql = IF(@exists = 0, 'ALTER TABLE delivery_partners ADD COLUMN facilities TEXT NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'delivery_partners' AND column_name = 'open_days');
SET @sql = IF(@exists = 0, 'ALTER TABLE delivery_partners ADD COLUMN open_days VARCHAR(80) NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'delivery_partners' AND column_name = 'open_time');
SET @sql = IF(@exists = 0, 'ALTER TABLE delivery_partners ADD COLUMN open_time TIME NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'delivery_partners' AND column_name = 'close_time');
SET @sql = IF(@exists = 0, 'ALTER TABLE delivery_partners ADD COLUMN close_time TIME NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'delivery_partners' AND column_name = 'break_start');
SET @sql = IF(@exists = 0, 'ALTER TABLE delivery_partners ADD COLUMN break_start TIME NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'delivery_partners' AND column_name = 'break_end');
SET @sql = IF(@exists = 0, 'ALTER TABLE delivery_partners ADD COLUMN break_end TIME NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'delivery_partners' AND column_name = 'blocked_dates');
SET @sql = IF(@exists = 0, 'ALTER TABLE delivery_partners ADD COLUMN blocked_dates TEXT NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'delivery_partners' AND column_name = 'typical_radius_km');
SET @sql = IF(@exists = 0, 'ALTER TABLE delivery_partners ADD COLUMN typical_radius_km INT NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'delivery_partners' AND column_name = 'upi_id');
SET @sql = IF(@exists = 0, 'ALTER TABLE delivery_partners ADD COLUMN upi_id VARCHAR(120) NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'delivery_partners' AND column_name = 'bank_details');
SET @sql = IF(@exists = 0, 'ALTER TABLE delivery_partners ADD COLUMN bank_details VARCHAR(255) NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'delivery_partners' AND column_name = 'payout_balance');
SET @sql = IF(@exists = 0, 'ALTER TABLE delivery_partners ADD COLUMN payout_balance DOUBLE NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'delivery_partners' AND column_name = 'payout_requested_at');
SET @sql = IF(@exists = 0, 'ALTER TABLE delivery_partners ADD COLUMN payout_requested_at DATETIME NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'delivery_partners' AND column_name = 'gallery_photos');
SET @sql = IF(@exists = 0, 'ALTER TABLE delivery_partners ADD COLUMN gallery_photos TEXT NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'women_product_orders' AND column_name = 'coach_notes');
SET @sql = IF(@exists = 0, 'ALTER TABLE women_product_orders ADD COLUMN coach_notes TEXT NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'women_product_orders' AND column_name = 'delivery_notes');
SET @sql = IF(@exists = 0, 'ALTER TABLE women_product_orders ADD COLUMN delivery_notes TEXT NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'women_product_orders' AND column_name = 'seller_payout_credited');
SET @sql = IF(@exists = 0, 'ALTER TABLE women_product_orders ADD COLUMN seller_payout_credited BIT(1) NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'women_product_orders' AND column_name = 'delivery_payout_credited');
SET @sql = IF(@exists = 0, 'ALTER TABLE women_product_orders ADD COLUMN delivery_payout_credited BIT(1) NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'women_product_orders' AND column_name = 'payment_status');
SET @sql = IF(@exists = 0, 'ALTER TABLE women_product_orders ADD COLUMN payment_status VARCHAR(24) NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
