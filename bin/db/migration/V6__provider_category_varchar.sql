-- Expand service partner categories beyond legacy enum values.
ALTER TABLE service_providers MODIFY COLUMN provider_category VARCHAR(64) NULL;
