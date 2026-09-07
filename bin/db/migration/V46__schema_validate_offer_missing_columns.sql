-- Align production `offer` with origin/main Offer.java fields added after Hibernate ddl-auto=validate.
-- The `offer` table was never CREATE TABLE'd in Flyway V1–V45 (historical Hibernate ddl-auto).
-- Idempotent: skip when the table or column already exists.
-- MySQL 8: no-op branch uses SELECT 1 (not MariaDB DO 0).
-- Additive only: no DROP, no RENAME.

-- ---------- offer (extended offer fields) ----------
SET @t = (
    SELECT COUNT(*)
    FROM information_schema.tables
    WHERE table_schema = DATABASE()
      AND table_name = 'offer'
);

SET @c = (
    SELECT COUNT(*)
    FROM information_schema.columns
    WHERE table_schema = DATABASE()
      AND table_name = 'offer'
      AND column_name = 'category'
);
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE offer ADD COLUMN category VARCHAR(255) NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @c = (
    SELECT COUNT(*)
    FROM information_schema.columns
    WHERE table_schema = DATABASE()
      AND table_name = 'offer'
      AND column_name = 'image_url'
);
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE offer ADD COLUMN image_url VARCHAR(255) NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @c = (
    SELECT COUNT(*)
    FROM information_schema.columns
    WHERE table_schema = DATABASE()
      AND table_name = 'offer'
      AND column_name = 'offer_type'
);
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE offer ADD COLUMN offer_type VARCHAR(255) NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @c = (
    SELECT COUNT(*)
    FROM information_schema.columns
    WHERE table_schema = DATABASE()
      AND table_name = 'offer'
      AND column_name = 'min_booking_amount'
);
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE offer ADD COLUMN min_booking_amount DOUBLE NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @c = (
    SELECT COUNT(*)
    FROM information_schema.columns
    WHERE table_schema = DATABASE()
      AND table_name = 'offer'
      AND column_name = 'max_discount_amount'
);
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE offer ADD COLUMN max_discount_amount DOUBLE NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @c = (
    SELECT COUNT(*)
    FROM information_schema.columns
    WHERE table_schema = DATABASE()
      AND table_name = 'offer'
      AND column_name = 'customer_eligibility'
);
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE offer ADD COLUMN customer_eligibility VARCHAR(255) NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @c = (
    SELECT COUNT(*)
    FROM information_schema.columns
    WHERE table_schema = DATABASE()
      AND table_name = 'offer'
      AND column_name = 'max_usage_per_customer'
);
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE offer ADD COLUMN max_usage_per_customer INT NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @c = (
    SELECT COUNT(*)
    FROM information_schema.columns
    WHERE table_schema = DATABASE()
      AND table_name = 'offer'
      AND column_name = 'total_usage_limit'
);
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE offer ADD COLUMN total_usage_limit INT NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @c = (
    SELECT COUNT(*)
    FROM information_schema.columns
    WHERE table_schema = DATABASE()
      AND table_name = 'offer'
      AND column_name = 'usage_count'
);
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE offer ADD COLUMN usage_count INT NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @c = (
    SELECT COUNT(*)
    FROM information_schema.columns
    WHERE table_schema = DATABASE()
      AND table_name = 'offer'
      AND column_name = 'applicable_days'
);
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE offer ADD COLUMN applicable_days VARCHAR(255) NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @c = (
    SELECT COUNT(*)
    FROM information_schema.columns
    WHERE table_schema = DATABASE()
      AND table_name = 'offer'
      AND column_name = 'start_time'
);
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE offer ADD COLUMN start_time TIME NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @c = (
    SELECT COUNT(*)
    FROM information_schema.columns
    WHERE table_schema = DATABASE()
      AND table_name = 'offer'
      AND column_name = 'end_time'
);
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE offer ADD COLUMN end_time TIME NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @c = (
    SELECT COUNT(*)
    FROM information_schema.columns
    WHERE table_schema = DATABASE()
      AND table_name = 'offer'
      AND column_name = 'advance_booking_required'
);
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE offer ADD COLUMN advance_booking_required BIT(1) NULL DEFAULT 0', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @c = (
    SELECT COUNT(*)
    FROM information_schema.columns
    WHERE table_schema = DATABASE()
      AND table_name = 'offer'
      AND column_name = 'total_discount_given'
);
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE offer ADD COLUMN total_discount_given DOUBLE NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @c = (
    SELECT COUNT(*)
    FROM information_schema.columns
    WHERE table_schema = DATABASE()
      AND table_name = 'offer'
      AND column_name = 'revenue_generated'
);
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE offer ADD COLUMN revenue_generated DOUBLE NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @c = (
    SELECT COUNT(*)
    FROM information_schema.columns
    WHERE table_schema = DATABASE()
      AND table_name = 'offer'
      AND column_name = 'explicit_status'
);
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE offer ADD COLUMN explicit_status VARCHAR(255) NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- ManyToMany JoinTable Offer.applicableServices → services (Service1.id is BIGINT)
CREATE TABLE IF NOT EXISTS offer_applicable_services (
    offer_id INT NOT NULL,
    service_id BIGINT NOT NULL,
    PRIMARY KEY (offer_id, service_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Salon module tables from the same origin/main merge (CREATE IF NOT EXISTS; prod uses validate).
CREATE TABLE IF NOT EXISTS salon_clients (
    id BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    salon_id BIGINT NOT NULL,
    user_id BIGINT NOT NULL,
    client_notes TEXT NULL,
    preferences TEXT NULL,
    joined_date DATETIME NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS salon_memberships (
    id BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    salon_id BIGINT NOT NULL,
    membership_name VARCHAR(255) NOT NULL,
    benefits TEXT NULL,
    price DOUBLE NOT NULL,
    duration_in_months INT NOT NULL,
    is_active BIT(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS salon_packages (
    id BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    salon_id BIGINT NOT NULL,
    package_name VARCHAR(255) NOT NULL,
    description TEXT NULL,
    price DOUBLE NOT NULL,
    duration_in_days INT NOT NULL DEFAULT 0,
    is_active BIT(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS package_services (
    package_id BIGINT NOT NULL,
    service_id BIGINT NOT NULL,
    PRIMARY KEY (package_id, service_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS salon_promotions (
    id BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    salon_id BIGINT NOT NULL,
    promotion_name VARCHAR(255) NOT NULL,
    description TEXT NULL,
    headline VARCHAR(255) NULL,
    cta_text VARCHAR(255) NULL,
    banner_url VARCHAR(255) NULL,
    category VARCHAR(255) NULL,
    target_audience VARCHAR(255) NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    start_time TIME NULL,
    end_time TIME NULL,
    explicit_status VARCHAR(255) NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS promotion_offers (
    promotion_id BIGINT NOT NULL,
    offer_id INT NOT NULL,
    PRIMARY KEY (promotion_id, offer_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS salon_inventory_items (
    id BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    salon_id BIGINT NOT NULL,
    item_name VARCHAR(255) NULL,
    sku VARCHAR(255) NULL,
    category VARCHAR(255) NULL,
    usage_type VARCHAR(255) NULL,
    quantity_in_stock INT NOT NULL DEFAULT 0,
    low_stock_threshold INT NOT NULL DEFAULT 5,
    unit_cost DOUBLE NOT NULL DEFAULT 0,
    retail_price DOUBLE NOT NULL DEFAULT 0,
    supplier_name VARCHAR(255) NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS salon_invoices (
    id BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    invoice_number VARCHAR(255) NOT NULL,
    salon_id BIGINT NOT NULL,
    client_name VARCHAR(255) NULL,
    client_phone VARCHAR(255) NULL,
    sub_total DOUBLE NULL,
    discount_amount DOUBLE NULL,
    tax_amount DOUBLE NULL,
    final_total DOUBLE NULL,
    payment_method VARCHAR(255) NULL,
    payment_status VARCHAR(255) NULL,
    invoice_date DATETIME NULL,
    UNIQUE KEY uk_salon_invoices_number (invoice_number)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS salon_invoice_items (
    id BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    invoice_id BIGINT NOT NULL,
    item_name VARCHAR(255) NULL,
    quantity INT NULL,
    unit_price DOUBLE NULL,
    total_price DOUBLE NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS salon_expenses (
    id BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    salon_id BIGINT NOT NULL,
    category VARCHAR(255) NULL,
    description VARCHAR(255) NULL,
    amount DOUBLE NULL,
    expense_date DATE NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS salon_payouts (
    id BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    salon_id BIGINT NOT NULL,
    amount DOUBLE NULL,
    status VARCHAR(255) NULL,
    payout_date DATE NULL,
    transaction_reference VARCHAR(255) NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS salon_loyalty_settings (
    id BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    salon_id BIGINT NOT NULL,
    is_active BIT(1) NOT NULL DEFAULT 0,
    points_per_hundred_spent INT NOT NULL DEFAULT 10,
    silver_tier_threshold INT NOT NULL DEFAULT 0,
    gold_tier_threshold INT NOT NULL DEFAULT 500,
    platinum_tier_threshold INT NOT NULL DEFAULT 1000,
    point_value_in_rupees DOUBLE NOT NULL DEFAULT 0.5,
    UNIQUE KEY uk_salon_loyalty_settings_salon (salon_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS salon_loyalty_customers (
    id BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    salon_id BIGINT NOT NULL,
    client_name VARCHAR(255) NULL,
    client_phone VARCHAR(255) NULL,
    total_points_earned INT NOT NULL DEFAULT 0,
    current_points_balance INT NOT NULL DEFAULT 0,
    current_tier VARCHAR(255) NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
