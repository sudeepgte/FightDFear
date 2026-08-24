-- Milestone 4: doctor verification workflow, drafts, notifications, history

CREATE TABLE IF NOT EXISTS doctor_verification_actions (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    doctor_id BIGINT NOT NULL,
    action VARCHAR(40) NOT NULL,
    from_status VARCHAR(40) NULL,
    to_status VARCHAR(40) NULL,
    notes TEXT NULL,
    reasons VARCHAR(1000) NULL,
    admin_id BIGINT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_dva_doctor_created (doctor_id, created_at),
    CONSTRAINT fk_dva_doctor FOREIGN KEY (doctor_id) REFERENCES doctors(id)
);

CREATE TABLE IF NOT EXISTS doctor_profile_drafts (
    doctor_id BIGINT PRIMARY KEY,
    draft_json LONGTEXT NOT NULL,
    status VARCHAR(32) NOT NULL DEFAULT 'DRAFT',
    admin_notes TEXT NULL,
    submitted_at DATETIME NULL,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_dpd_doctor FOREIGN KEY (doctor_id) REFERENCES doctors(id)
);

CREATE TABLE IF NOT EXISTS doctor_notifications (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    doctor_id BIGINT NOT NULL,
    type VARCHAR(64) NOT NULL,
    title VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    read_flag TINYINT(1) NOT NULL DEFAULT 0,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_dn_doctor_created (doctor_id, created_at),
    CONSTRAINT fk_dn_doctor FOREIGN KEY (doctor_id) REFERENCES doctors(id)
);

ALTER TABLE doctors
    ADD COLUMN has_pending_reverification TINYINT(1) NOT NULL DEFAULT 0;
