-- Phase 8: Concurrency & Integrity indexes for wallet transactions and product orders
-- Idempotent: safe to run on fresh databases where tables are not yet created by Hibernate ddl-auto,
-- and on existing databases where tables already exist.

SET @t = (SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'wallet_transaction');
SET @exists = (SELECT COUNT(*) FROM information_schema.statistics WHERE table_schema = DATABASE() AND table_name = 'wallet_transaction' AND index_name = 'idx_wallet_tx_user_date');
SET @sql = IF(@t > 0 AND @exists = 0, 'CREATE INDEX idx_wallet_tx_user_date ON wallet_transaction (user_id, transaction_date)', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @t = (SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'women_product_orders');
SET @exists = (SELECT COUNT(*) FROM information_schema.statistics WHERE table_schema = DATABASE() AND table_name = 'women_product_orders' AND index_name = 'idx_wp_orders_payment_id');
SET @sql = IF(@t > 0 AND @exists = 0, 'CREATE INDEX idx_wp_orders_payment_id ON women_product_orders (razorpay_payment_id)', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

