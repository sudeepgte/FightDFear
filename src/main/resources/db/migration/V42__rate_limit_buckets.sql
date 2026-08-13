-- Sliding-window rate limit buckets (MySQL-backed; no Redis)

CREATE TABLE IF NOT EXISTS rate_limit_buckets (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    bucket_key VARCHAR(255) NOT NULL,
    created_at TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    INDEX idx_rate_limit_key_created (bucket_key, created_at)
);
