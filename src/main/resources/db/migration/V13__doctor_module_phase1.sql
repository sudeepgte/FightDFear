-- Women Doctor module Phase 1: lifecycle, profile completion, OTP storage

ALTER TABLE doctors
    ADD COLUMN doctor_profile_status VARCHAR(32) NULL,
    ADD COLUMN profile_completion_pct INT NOT NULL DEFAULT 0,
    ADD COLUMN accepted_terms_at DATETIME NULL,
    ADD COLUMN created_at DATETIME NULL,
    ADD COLUMN updated_at DATETIME NULL,
    ADD COLUMN rejection_reason TEXT NULL,
    ADD COLUMN changes_requested_note TEXT NULL,
    ADD COLUMN submitted_for_verification_at DATETIME NULL;

UPDATE doctors SET doctor_profile_status = 'APPROVED' WHERE verification_status = 'VERIFIED';
UPDATE doctors SET doctor_profile_status = 'REJECTED' WHERE verification_status = 'REJECTED';
UPDATE doctors SET doctor_profile_status = 'PROFILE_INCOMPLETE' WHERE verification_status = 'PENDING';

UPDATE doctors SET created_at = NOW() WHERE created_at IS NULL;
UPDATE doctors SET updated_at = NOW() WHERE updated_at IS NULL;

CREATE TABLE IF NOT EXISTS email_otp_verifications (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(255) NOT NULL,
    code_hash VARCHAR(255) NOT NULL,
    purpose VARCHAR(64) NOT NULL,
    channel VARCHAR(16) NOT NULL DEFAULT 'EMAIL',
    verified TINYINT(1) NOT NULL DEFAULT 0,
    expires_at DATETIME NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_email_otp_email_purpose (email, purpose),
    INDEX idx_email_otp_expires (expires_at)
);
