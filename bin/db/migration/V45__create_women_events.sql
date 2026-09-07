-- Create women_events when it was never created by Hibernate ddl-auto.
-- MySQL 8: CREATE TABLE IF NOT EXISTS; quote reserved column `virtual`.

CREATE TABLE IF NOT EXISTS women_events (
    id BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    category VARCHAR(255) NOT NULL,
    description VARCHAR(5000) NULL,
    event_date DATE NULL,
    event_time TIME NULL,
    venue VARCHAR(255) NULL,
    city VARCHAR(255) NULL,
    entry_fee DOUBLE NULL,
    is_free BIT(1) NOT NULL DEFAULT 1,
    max_participants INT NULL,
    banner_image VARCHAR(255) NULL,
    contact_info VARCHAR(255) NULL,
    maps_location VARCHAR(255) NULL,
    organizer_name VARCHAR(255) NULL,
    organizer_type VARCHAR(255) NULL,
    organizer_host_id BIGINT NULL,
    status VARCHAR(255) NULL,
    featured BIT(1) NOT NULL DEFAULT 0,
    created_at DATETIME NULL,
    is_virtual BIT(1) NOT NULL DEFAULT 0,
    `virtual` BIT(1) NOT NULL DEFAULT 0,
    stream_link VARCHAR(255) NULL,
    booth_fee DOUBLE NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
