CREATE TABLE IF NOT EXISTS loan_applications (
    id BIGINT NOT NULL AUTO_INCREMENT,
    user_id BIGINT NULL,
    full_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    phone_number VARCHAR(50) NULL,
    address TEXT NULL,
    aadhaar_number VARCHAR(32) NULL,
    pan_number VARCHAR(32) NULL,
    loan_type VARCHAR(100) NULL,
    occupation VARCHAR(255) NULL,
    annual_income DOUBLE NULL,
    loan_amount DOUBLE NULL,
    purpose TEXT NULL,
    status VARCHAR(50) NOT NULL DEFAULT 'SUBMITTED',
    submitted_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);
