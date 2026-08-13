-- Glow Space expanded service taxonomy (Hair, Bridal, Mehendi, etc.).
-- Legacy MySQL ENUM on services.category rejected new values ("Data truncated").
ALTER TABLE services
    MODIFY COLUMN category VARCHAR(64) NULL;
