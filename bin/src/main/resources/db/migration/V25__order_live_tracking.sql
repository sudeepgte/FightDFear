SET @exists = (
    SELECT COUNT(*) FROM information_schema.columns
    WHERE table_schema = DATABASE()
      AND table_name = 'women_product_orders'
      AND column_name = 'courier_lat'
);
SET @sql = IF(@exists = 0,
    'ALTER TABLE women_product_orders ADD COLUMN courier_lat DOUBLE NULL',
    'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (
    SELECT COUNT(*) FROM information_schema.columns
    WHERE table_schema = DATABASE()
      AND table_name = 'women_product_orders'
      AND column_name = 'courier_lng'
);
SET @sql = IF(@exists = 0,
    'ALTER TABLE women_product_orders ADD COLUMN courier_lng DOUBLE NULL',
    'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (
    SELECT COUNT(*) FROM information_schema.columns
    WHERE table_schema = DATABASE()
      AND table_name = 'women_product_orders'
      AND column_name = 'courier_location_at'
);
SET @sql = IF(@exists = 0,
    'ALTER TABLE women_product_orders ADD COLUMN courier_location_at DATETIME NULL',
    'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (
    SELECT COUNT(*) FROM information_schema.columns
    WHERE table_schema = DATABASE()
      AND table_name = 'women_product_orders'
      AND column_name = 'pickup_lat'
);
SET @sql = IF(@exists = 0,
    'ALTER TABLE women_product_orders ADD COLUMN pickup_lat DOUBLE NULL',
    'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (
    SELECT COUNT(*) FROM information_schema.columns
    WHERE table_schema = DATABASE()
      AND table_name = 'women_product_orders'
      AND column_name = 'pickup_lng'
);
SET @sql = IF(@exists = 0,
    'ALTER TABLE women_product_orders ADD COLUMN pickup_lng DOUBLE NULL',
    'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (
    SELECT COUNT(*) FROM information_schema.columns
    WHERE table_schema = DATABASE()
      AND table_name = 'women_product_orders'
      AND column_name = 'drop_lat'
);
SET @sql = IF(@exists = 0,
    'ALTER TABLE women_product_orders ADD COLUMN drop_lat DOUBLE NULL',
    'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (
    SELECT COUNT(*) FROM information_schema.columns
    WHERE table_schema = DATABASE()
      AND table_name = 'women_product_orders'
      AND column_name = 'drop_lng'
);
SET @sql = IF(@exists = 0,
    'ALTER TABLE women_product_orders ADD COLUMN drop_lng DOUBLE NULL',
    'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (
    SELECT COUNT(*) FROM information_schema.columns
    WHERE table_schema = DATABASE()
      AND table_name = 'women_product_orders'
      AND column_name = 'eta_minutes'
);
SET @sql = IF(@exists = 0,
    'ALTER TABLE women_product_orders ADD COLUMN eta_minutes INT NULL',
    'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (
    SELECT COUNT(*) FROM information_schema.columns
    WHERE table_schema = DATABASE()
      AND table_name = 'women_product_orders'
      AND column_name = 'remaining_km'
);
SET @sql = IF(@exists = 0,
    'ALTER TABLE women_product_orders ADD COLUMN remaining_km DOUBLE NULL',
    'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (
    SELECT COUNT(*) FROM information_schema.columns
    WHERE table_schema = DATABASE()
      AND table_name = 'women_product_orders'
      AND column_name = 'route_polyline'
);
SET @sql = IF(@exists = 0,
    'ALTER TABLE women_product_orders ADD COLUMN route_polyline TEXT NULL',
    'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (
    SELECT COUNT(*) FROM information_schema.columns
    WHERE table_schema = DATABASE()
      AND table_name = 'women_product_orders'
      AND column_name = 'route_updated_at'
);
SET @sql = IF(@exists = 0,
    'ALTER TABLE women_product_orders ADD COLUMN route_updated_at DATETIME NULL',
    'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
