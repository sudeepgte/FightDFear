CREATE TABLE IF NOT EXISTS financial_educators (
    id BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(160) NULL,
    email VARCHAR(190) NOT NULL,
    phone VARCHAR(20) NULL,
    password VARCHAR(255) NULL,
    city VARCHAR(120) NULL,
    expertise VARCHAR(80) NULL,
    organization VARCHAR(160) NULL,
    years_experience INT NULL,
    bio TEXT NULL,
    verification_status VARCHAR(20) NULL,
    partner_profile_status VARCHAR(40) NULL,
    profile_completion_pct INT NULL,
    accepted_terms_at DATETIME NULL,
    submitted_for_verification_at DATETIME NULL,
    rejection_reason TEXT NULL,
    changes_requested_note TEXT NULL,
    suspended BIT NULL,
    created_at DATETIME NULL,
    UNIQUE KEY uk_financial_educators_email (email)
);

CREATE TABLE IF NOT EXISTS financial_videos (
    id BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    educator_id BIGINT NULL,
    title VARCHAR(255) NOT NULL,
    category VARCHAR(80) NULL,
    description TEXT NULL,
    video_url VARCHAR(1000) NULL,
    duration VARCHAR(40) NULL,
    level VARCHAR(40) NULL,
    published BIT NULL,
    created_at DATETIME NULL,
    CONSTRAINT fk_fl_video_educator FOREIGN KEY (educator_id) REFERENCES financial_educators (id)
);

CREATE TABLE IF NOT EXISTS financial_live_sessions (
    id BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    educator_id BIGINT NULL,
    title VARCHAR(255) NOT NULL,
    speaker VARCHAR(160) NULL,
    session_date VARCHAR(40) NULL,
    session_time VARCHAR(40) NULL,
    meeting_url VARCHAR(1000) NULL,
    seats INT NULL,
    description TEXT NULL,
    published BIT NULL,
    created_at DATETIME NULL,
    CONSTRAINT fk_fl_live_educator FOREIGN KEY (educator_id) REFERENCES financial_educators (id)
);

CREATE TABLE IF NOT EXISTS financial_workshops (
    id BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    educator_id BIGINT NULL,
    title VARCHAR(255) NOT NULL,
    venue VARCHAR(255) NULL,
    workshop_date VARCHAR(40) NULL,
    workshop_time VARCHAR(40) NULL,
    city VARCHAR(120) NULL,
    seats INT NULL,
    description TEXT NULL,
    published BIT NULL,
    created_at DATETIME NULL,
    CONSTRAINT fk_fl_workshop_educator FOREIGN KEY (educator_id) REFERENCES financial_educators (id)
);

CREATE TABLE IF NOT EXISTS financial_enrollments (
    id BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NULL,
    live_session_id BIGINT NULL,
    workshop_id BIGINT NULL,
    kind VARCHAR(20) NOT NULL,
    full_name VARCHAR(160) NULL,
    mobile VARCHAR(20) NULL,
    email VARCHAR(190) NULL,
    occupation VARCHAR(120) NULL,
    city VARCHAR(120) NULL,
    status VARCHAR(20) NOT NULL,
    created_at DATETIME NULL,
    CONSTRAINT fk_fl_enroll_live FOREIGN KEY (live_session_id) REFERENCES financial_live_sessions (id),
    CONSTRAINT fk_fl_enroll_workshop FOREIGN KEY (workshop_id) REFERENCES financial_workshops (id)
);
