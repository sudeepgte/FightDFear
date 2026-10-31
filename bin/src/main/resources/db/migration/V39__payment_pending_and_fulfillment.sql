-- Phase 2: durable payment pending orders + idempotent fulfillment (multi-instance safe)

CREATE TABLE IF NOT EXISTS payment_pending_orders (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    razorpay_order_id VARCHAR(128) NOT NULL,
    user_id BIGINT NOT NULL,
    amount_paise INT NOT NULL,
    payment_type VARCHAR(64) NULL,
    target_id BIGINT NULL,
    consultation_type VARCHAR(32) NULL,
    appointment_time VARCHAR(64) NULL,
    reason VARCHAR(512) NULL,
    status VARCHAR(32) NOT NULL DEFAULT 'PENDING',
    razorpay_payment_id VARCHAR(128) NULL,
    fulfilled_at DATETIME NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    expires_at DATETIME NOT NULL,
    UNIQUE KEY uk_payment_pending_order (razorpay_order_id),
    INDEX idx_payment_pending_user (user_id),
    INDEX idx_payment_pending_status_expires (status, expires_at)
);

CREATE TABLE IF NOT EXISTS payment_fulfillments (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    razorpay_payment_id VARCHAR(128) NOT NULL,
    razorpay_order_id VARCHAR(128) NOT NULL,
    user_id BIGINT NOT NULL,
    payment_type VARCHAR(64) NOT NULL,
    target_id BIGINT NULL,
    amount_paise INT NOT NULL,
    response_json TEXT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uk_payment_fulfillment_payment (razorpay_payment_id),
    UNIQUE KEY uk_payment_fulfillment_order (razorpay_order_id),
    INDEX idx_payment_fulfillment_user (user_id)
);

-- Webhook dedup for all payment types (generalizes doctor-only events)
CREATE TABLE IF NOT EXISTS payment_webhook_events (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    razorpay_event_id VARCHAR(128) NOT NULL,
    event_type VARCHAR(64) NULL,
    razorpay_payment_id VARCHAR(128) NULL,
    razorpay_order_id VARCHAR(128) NULL,
    payload TEXT NULL,
    processed TINYINT(1) NOT NULL DEFAULT 0,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uk_payment_webhook_event (razorpay_event_id),
    INDEX idx_payment_webhook_order (razorpay_order_id)
);

-- Note: doctor slot unique index omitted — existing data may contain duplicate slots.
-- Slot protection enforced in DoctorBookingService with validate + transactional checks.
