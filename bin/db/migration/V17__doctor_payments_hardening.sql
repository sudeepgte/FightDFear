CREATE TABLE IF NOT EXISTS doctor_appointments (
    id BIGINT AUTO_INCREMENT PRIMARY KEY
);

ALTER TABLE doctor_appointments
    ADD COLUMN payment_status VARCHAR(32) NULL,
    ADD COLUMN refund_id VARCHAR(128) NULL,
    ADD COLUMN refund_amount DOUBLE NULL,
    ADD COLUMN refunded_at DATETIME NULL,
    ADD COLUMN receipt_number VARCHAR(64) NULL,
    ADD COLUMN meeting_password VARCHAR(64) NULL,
    ADD COLUMN rescheduled_from DATETIME NULL,
    ADD COLUMN platform_fee DOUBLE NULL,
    ADD COLUMN doctor_earning DOUBLE NULL,
    ADD COLUMN cancelled_by VARCHAR(32) NULL,
    ADD COLUMN cancel_reason VARCHAR(512) NULL;

ALTER TABLE doctors
    ADD COLUMN payout_balance DOUBLE NULL,
    ADD COLUMN total_earned DOUBLE NULL,
    ADD COLUMN commission_percent DOUBLE NULL,
    ADD COLUMN fcm_token VARCHAR(512) NULL;

CREATE TABLE IF NOT EXISTS doctor_payment_events (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    razorpay_event_id VARCHAR(128) NULL,
    event_type VARCHAR(64) NULL,
    razorpay_payment_id VARCHAR(128) NULL,
    razorpay_order_id VARCHAR(128) NULL,
    appointment_id BIGINT NULL,
    payload TEXT NULL,
    processed TINYINT(1) NOT NULL DEFAULT 0,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uk_razorpay_event (razorpay_event_id)
);

CREATE TABLE IF NOT EXISTS user_device_tokens (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    fcm_token VARCHAR(512) NOT NULL,
    platform VARCHAR(32) NULL,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY uk_user_token (user_id, fcm_token)
);

CREATE TABLE IF NOT EXISTS doctor_instant_requests (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    doctor_id BIGINT NULL,
    status VARCHAR(32) NOT NULL,
    consultation_type VARCHAR(32) NULL,
    reason VARCHAR(512) NULL,
    appointment_id BIGINT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    expires_at DATETIME NULL,
    responded_at DATETIME NULL
);
