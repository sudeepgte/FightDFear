CREATE TABLE IF NOT EXISTS delivery_partners (
    id BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(160) NULL,
    email VARCHAR(190) NOT NULL,
    phone VARCHAR(20) NULL,
    password VARCHAR(255) NULL,
    city VARCHAR(120) NULL,
    vehicle_type VARCHAR(40) NULL,
    license_number VARCHAR(80) NULL,
    service_area VARCHAR(255) NULL,
    bio TEXT NULL,
    profile_photo_path VARCHAR(500) NULL,
    identity_doc_path VARCHAR(500) NULL,
    verification_status VARCHAR(20) NULL,
    partner_profile_status VARCHAR(40) NULL,
    profile_completion_pct INT NULL,
    accepted_terms_at DATETIME NULL,
    submitted_for_verification_at DATETIME NULL,
    rejection_reason TEXT NULL,
    changes_requested_note TEXT NULL,
    rating DOUBLE NULL,
    suspended BIT NULL,
    created_at DATETIME NULL,
    UNIQUE KEY uk_delivery_partners_email (email)
);

SET @exists = (
    SELECT COUNT(*) FROM information_schema.columns
    WHERE table_schema = DATABASE()
      AND table_name = 'women_product_orders'
      AND column_name = 'delivery_partner_id'
);
SET @sql = IF(@exists = 0,
    'ALTER TABLE women_product_orders ADD COLUMN delivery_partner_id BIGINT NULL',
    'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (
    SELECT COUNT(*) FROM information_schema.columns
    WHERE table_schema = DATABASE()
      AND table_name = 'women_product_orders'
      AND column_name = 'assigned_at'
);
SET @sql = IF(@exists = 0,
    'ALTER TABLE women_product_orders ADD COLUMN assigned_at DATETIME NULL',
    'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (
    SELECT COUNT(*) FROM information_schema.columns
    WHERE table_schema = DATABASE()
      AND table_name = 'women_product_orders'
      AND column_name = 'picked_up_at'
);
SET @sql = IF(@exists = 0,
    'ALTER TABLE women_product_orders ADD COLUMN picked_up_at DATETIME NULL',
    'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (
    SELECT COUNT(*) FROM information_schema.columns
    WHERE table_schema = DATABASE()
      AND table_name = 'women_product_orders'
      AND column_name = 'delivered_at'
);
SET @sql = IF(@exists = 0,
    'ALTER TABLE women_product_orders ADD COLUMN delivered_at DATETIME NULL',
    'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (
    SELECT COUNT(*) FROM information_schema.columns
    WHERE table_schema = DATABASE()
      AND table_name = 'women_product_orders'
      AND column_name = 'tracking_note'
);
SET @sql = IF(@exists = 0,
    'ALTER TABLE women_product_orders ADD COLUMN tracking_note VARCHAR(500) NULL',
    'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
