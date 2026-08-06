-- Sync legacy service_providers columns into the columns mapped by ServiceProvider entity.
-- Legacy rows store category/verification in `category` + `verification_status`.
-- Entity reads/writes `provider_category` + `v_status`.
-- Some environments (e.g. this DB) never had the legacy columns, so guard on
-- their existence before referencing them.

SET @has_category = (
    SELECT COUNT(*) FROM information_schema.columns
    WHERE table_schema = DATABASE() AND table_name = 'service_providers' AND column_name = 'category'
);
SET @sql = IF(@has_category > 0,
    'UPDATE service_providers SET provider_category = category WHERE provider_category IS NULL AND category IS NOT NULL',
    'DO 0');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @has_verification_status = (
    SELECT COUNT(*) FROM information_schema.columns
    WHERE table_schema = DATABASE() AND table_name = 'service_providers' AND column_name = 'verification_status'
);
SET @sql = IF(@has_verification_status > 0,
    'UPDATE service_providers SET v_status = verification_status WHERE provider_category IS NOT NULL AND verification_status IS NOT NULL AND (v_status IS NULL OR (v_status = ''PENDING'' AND verification_status IN (''VERIFIED'', ''REJECTED'')))',
    'DO 0');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;
