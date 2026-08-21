-- Align production schema with entity fields added after ddl-auto=validate.
-- Idempotent: skip when the table or column already exists (local ddl-auto=update).
-- MySQL 8: no-op branch uses SELECT 1 (not MariaDB DO 0).

-- ---------- doctor_chat_messages ----------
SET @t = (SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'doctor_chat_messages');
SET @c = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'doctor_chat_messages' AND column_name = 'read_by_doctor');
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE doctor_chat_messages ADD COLUMN read_by_doctor BIT(1) NOT NULL DEFAULT 0', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- ---------- salons (extended profile) ----------
SET @t = (SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'salons');

SET @c = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'salons' AND column_name = 'salon_tagline');
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE salons ADD COLUMN salon_tagline VARCHAR(255) NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @c = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'salons' AND column_name = 'salon_category');
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE salons ADD COLUMN salon_category VARCHAR(255) NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @c = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'salons' AND column_name = 'is_women_only');
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE salons ADD COLUMN is_women_only BIT(1) NULL DEFAULT 0', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @c = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'salons' AND column_name = 'current_status');
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE salons ADD COLUMN current_status VARCHAR(255) NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @c = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'salons' AND column_name = 'business_registration_no');
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE salons ADD COLUMN business_registration_no VARCHAR(255) NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @c = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'salons' AND column_name = 'gst_number');
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE salons ADD COLUMN gst_number VARCHAR(255) NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @c = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'salons' AND column_name = 'salon_license_no');
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE salons ADD COLUMN salon_license_no VARCHAR(255) NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @c = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'salons' AND column_name = 'alternate_number');
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE salons ADD COLUMN alternate_number VARCHAR(255) NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @c = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'salons' AND column_name = 'hygiene_standard');
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE salons ADD COLUMN hygiene_standard VARCHAR(255) NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @c = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'salons' AND column_name = 'languages_spoken');
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE salons ADD COLUMN languages_spoken VARCHAR(255) NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @c = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'salons' AND column_name = 'landmark');
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE salons ADD COLUMN landmark VARCHAR(255) NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @c = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'salons' AND column_name = 'has_reception_area');
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE salons ADD COLUMN has_reception_area BIT(1) NULL DEFAULT 0', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @c = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'salons' AND column_name = 'has_waiting_area');
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE salons ADD COLUMN has_waiting_area BIT(1) NULL DEFAULT 0', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @c = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'salons' AND column_name = 'salon_size_sq_ft');
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE salons ADD COLUMN salon_size_sq_ft INT NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @c = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'salons' AND column_name = 'total_floors');
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE salons ADD COLUMN total_floors INT NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @c = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'salons' AND column_name = 'total_chairs');
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE salons ADD COLUMN total_chairs INT NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @c = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'salons' AND column_name = 'treatment_rooms');
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE salons ADD COLUMN treatment_rooms INT NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @c = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'salons' AND column_name = 'washrooms');
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE salons ADD COLUMN washrooms INT NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @c = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'salons' AND column_name = 'has_parking');
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE salons ADD COLUMN has_parking BIT(1) NULL DEFAULT 0', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @c = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'salons' AND column_name = 'has_ac');
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE salons ADD COLUMN has_ac BIT(1) NULL DEFAULT 0', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @c = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'salons' AND column_name = 'has_wifi');
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE salons ADD COLUMN has_wifi BIT(1) NULL DEFAULT 0', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @c = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'salons' AND column_name = 'has_power_backup');
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE salons ADD COLUMN has_power_backup BIT(1) NULL DEFAULT 0', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @c = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'salons' AND column_name = 'is_wheelchair_accessible');
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE salons ADD COLUMN is_wheelchair_accessible BIT(1) NULL DEFAULT 0', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @c = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'salons' AND column_name = 'amenities_json');
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE salons ADD COLUMN amenities_json TEXT NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @c = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'salons' AND column_name = 'preferences_json');
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE salons ADD COLUMN preferences_json TEXT NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @c = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'salons' AND column_name = 'operating_hours_json');
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE salons ADD COLUMN operating_hours_json TEXT NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @c = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'salons' AND column_name = 'social_media_json');
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE salons ADD COLUMN social_media_json TEXT NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @c = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'salons' AND column_name = 'interior_images_json');
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE salons ADD COLUMN interior_images_json TEXT NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @c = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'salons' AND column_name = 'cover_image_url');
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE salons ADD COLUMN cover_image_url VARCHAR(255) NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @c = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'salons' AND column_name = 'business_registration_url');
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE salons ADD COLUMN business_registration_url VARCHAR(255) NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @c = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'salons' AND column_name = 'salon_license_url');
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE salons ADD COLUMN salon_license_url VARCHAR(255) NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @c = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'salons' AND column_name = 'fire_safety_url');
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE salons ADD COLUMN fire_safety_url VARCHAR(255) NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @c = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'salons' AND column_name = 'gst_certificate_url');
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE salons ADD COLUMN gst_certificate_url VARCHAR(255) NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- ---------- service_providers ----------
SET @t = (SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'service_providers');

SET @c = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'service_providers' AND column_name = 'profile_photo');
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE service_providers ADD COLUMN profile_photo VARCHAR(255) NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @c = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'service_providers' AND column_name = 'business_name');
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE service_providers ADD COLUMN business_name VARCHAR(255) NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @c = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'service_providers' AND column_name = 'service_area');
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE service_providers ADD COLUMN service_area VARCHAR(255) NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @c = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'service_providers' AND column_name = 'qualification');
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE service_providers ADD COLUMN qualification VARCHAR(255) NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @c = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'service_providers' AND column_name = 'experience');
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE service_providers ADD COLUMN experience VARCHAR(255) NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @c = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'service_providers' AND column_name = 'available_days');
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE service_providers ADD COLUMN available_days VARCHAR(255) NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @c = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'service_providers' AND column_name = 'working_hours_from');
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE service_providers ADD COLUMN working_hours_from VARCHAR(255) NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @c = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'service_providers' AND column_name = 'working_hours_to');
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE service_providers ADD COLUMN working_hours_to VARCHAR(255) NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @c = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'service_providers' AND column_name = 'languages_spoken');
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE service_providers ADD COLUMN languages_spoken TEXT NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- ---------- women_product_sellers ----------
SET @t = (SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'women_product_sellers');

SET @c = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'women_product_sellers' AND column_name = 'category');
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE women_product_sellers ADD COLUMN category VARCHAR(100) NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @c = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'women_product_sellers' AND column_name = 'service_area');
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE women_product_sellers ADD COLUMN service_area VARCHAR(255) NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @c = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'women_product_sellers' AND column_name = 'qualification');
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE women_product_sellers ADD COLUMN qualification TEXT NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @c = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'women_product_sellers' AND column_name = 'experience');
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE women_product_sellers ADD COLUMN experience VARCHAR(100) NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @c = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'women_product_sellers' AND column_name = 'available_days');
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE women_product_sellers ADD COLUMN available_days TEXT NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @c = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'women_product_sellers' AND column_name = 'working_hours_from');
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE women_product_sellers ADD COLUMN working_hours_from VARCHAR(50) NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @c = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'women_product_sellers' AND column_name = 'working_hours_to');
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE women_product_sellers ADD COLUMN working_hours_to VARCHAR(50) NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @c = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'women_product_sellers' AND column_name = 'languages_spoken');
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE women_product_sellers ADD COLUMN languages_spoken TEXT NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- ---------- women_product_orders ----------
SET @t = (SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'women_product_orders');
SET @c = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'women_product_orders' AND column_name = 'expected_delivery_date');
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE women_product_orders ADD COLUMN expected_delivery_date DATETIME NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- ---------- women_events (is_virtual is new; virtual already existed from Hibernate) ----------
SET @t = (SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'women_events');
SET @c = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'women_events' AND column_name = 'is_virtual');
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE women_events ADD COLUMN is_virtual BIT(1) NOT NULL DEFAULT 0', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @c_virtual = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'women_events' AND column_name = 'virtual');
SET @c_is = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'women_events' AND column_name = 'is_virtual');
SET @sql = IF(@t > 0 AND @c_virtual > 0 AND @c_is > 0,
    'UPDATE women_events SET is_virtual = `virtual` WHERE is_virtual = 0 AND `virtual` = 1',
    'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- ---------- provider_class ----------
SET @t = (SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'provider_class');
SET @c = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'provider_class' AND column_name = 'service_provided');
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE provider_class ADD COLUMN service_provided VARCHAR(255) NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @c = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'provider_class' AND column_name = 'service_location');
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE provider_class ADD COLUMN service_location VARCHAR(255) NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- ---------- new tables (entities added after validate) ----------
CREATE TABLE IF NOT EXISTS salon_chat_messages (
    id BIGINT NOT NULL AUTO_INCREMENT,
    salon_id BIGINT NULL,
    user_id BIGINT NULL,
    sender_role VARCHAR(255) NULL,
    message VARCHAR(255) NULL,
    is_read BIT(1) NOT NULL DEFAULT 0,
    `timestamp` DATETIME NULL,
    PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS salon_notifications (
    id BIGINT NOT NULL AUTO_INCREMENT,
    salon_id BIGINT NULL,
    title VARCHAR(255) NULL,
    message VARCHAR(255) NULL,
    is_read BIT(1) NOT NULL DEFAULT 0,
    `timestamp` DATETIME NULL,
    PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
