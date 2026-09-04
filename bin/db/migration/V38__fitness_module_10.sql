CREATE TABLE IF NOT EXISTS fitness_trainers (
    id BIGINT AUTO_INCREMENT PRIMARY KEY
);

ALTER TABLE fitness_trainers
    ADD COLUMN designation VARCHAR(128),
    ADD COLUMN whatsapp_number VARCHAR(32),
    ADD COLUMN address TEXT,
    ADD COLUMN state VARCHAR(64),
    ADD COLUMN pincode VARCHAR(16),
    ADD COLUMN latitude DOUBLE,
    ADD COLUMN longitude DOUBLE,
    ADD COLUMN audience TEXT,
    ADD COLUMN door_service BOOLEAN DEFAULT FALSE,
    ADD COLUMN facilities TEXT,
    ADD COLUMN open_days VARCHAR(255),
    ADD COLUMN open_time TIME,
    ADD COLUMN close_time TIME,
    ADD COLUMN break_start TIME,
    ADD COLUMN break_end TIME,
    ADD COLUMN blocked_dates TEXT,
    ADD COLUMN credential_number VARCHAR(128),
    ADD COLUMN session_mode VARCHAR(64),
    ADD COLUMN duration_minutes INT,
    ADD COLUMN buffer_minutes INT,
    ADD COLUMN typical_price DOUBLE,
    ADD COLUMN upi_id VARCHAR(128),
    ADD COLUMN bank_details TEXT,
    ADD COLUMN payout_balance DOUBLE DEFAULT 0,
    ADD COLUMN payout_requested_at DATETIME,
    ADD COLUMN gallery_photos TEXT,
    ADD COLUMN review_count INT DEFAULT 0;

CREATE TABLE IF NOT EXISTS fitness_bookings (
    id BIGINT AUTO_INCREMENT PRIMARY KEY
);

ALTER TABLE fitness_bookings
    ADD COLUMN payout_credited BOOLEAN DEFAULT FALSE,
    ADD COLUMN coach_notes TEXT;
