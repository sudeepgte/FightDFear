-- Phase 8: Concurrency & Integrity indexes for wallet transactions and product orders

SET @exists = (SELECT COUNT(*) FROM information_schema.statistics WHERE table_schema = DATABASE() AND table_name = 'wallet_transaction' AND index_name = 'idx_wallet_tx_user_date');
SET @sql = IF(@exists = 0, 'CREATE INDEX idx_wallet_tx_user_date ON wallet_transaction (user_id, transaction_date)', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.statistics WHERE table_schema = DATABASE() AND table_name = 'women_product_orders' AND index_name = 'idx_wp_orders_payment_id');
SET @sql = IF(@exists = 0, 'CREATE INDEX idx_wp_orders_payment_id ON women_product_orders (razorpay_payment_id)', 'DO 0');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
