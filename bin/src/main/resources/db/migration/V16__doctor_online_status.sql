-- Doctor presence + discovery support

ALTER TABLE doctors
    ADD COLUMN is_online TINYINT(1) NOT NULL DEFAULT 0,
    ADD COLUMN last_seen_at DATETIME NULL;
