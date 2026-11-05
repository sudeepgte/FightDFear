-- Infrastructure tables skipped when Hibernate-era DBs were baselined at a later version.

CREATE TABLE IF NOT EXISTS shedlock (
    name VARCHAR(64) NOT NULL,
    lock_until TIMESTAMP(3) NOT NULL,
    locked_at TIMESTAMP(3) NOT NULL,
    locked_by VARCHAR(255) NOT NULL,
    PRIMARY KEY (name)
);

CREATE TABLE IF NOT EXISTS rate_limit_buckets (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    bucket_key VARCHAR(255) NOT NULL,
    created_at TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    INDEX idx_rate_limit_key_created (bucket_key, created_at)
);
