CREATE TABLE IF NOT EXISTS seller_notifications (
    id BIGINT NOT NULL AUTO_INCREMENT,
    seller_id BIGINT NOT NULL,
    type VARCHAR(64) NOT NULL,
    title VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    order_id BIGINT NULL,
    read_flag BIT(1) NOT NULL DEFAULT 0,
    created_at DATETIME NULL,
    PRIMARY KEY (id),
    CONSTRAINT fk_seller_notif_seller FOREIGN KEY (seller_id) REFERENCES women_product_sellers (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
