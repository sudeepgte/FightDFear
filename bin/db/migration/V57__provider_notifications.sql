CREATE TABLE IF NOT EXISTS provider_notifications (
    id BIGINT NOT NULL AUTO_INCREMENT,
    provider_id BIGINT NOT NULL,
    type VARCHAR(64) NOT NULL,
    title VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    booking_id BIGINT NULL,
    read_flag BIT(1) NOT NULL DEFAULT 0,
    created_at DATETIME NULL,
    PRIMARY KEY (id),
    CONSTRAINT fk_prov_notif_provider FOREIGN KEY (provider_id) REFERENCES service_providers (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
