-- Sync legacy service_providers columns into the columns mapped by ServiceProvider entity.
-- Legacy rows store category/verification in `category` + `verification_status`.
-- Entity reads/writes `provider_category` + `v_status`.

UPDATE service_providers
SET provider_category = category
WHERE provider_category IS NULL
  AND category IS NOT NULL;

UPDATE service_providers
SET v_status = verification_status
WHERE provider_category IS NOT NULL
  AND verification_status IS NOT NULL
  AND (
        v_status IS NULL
        OR (v_status = 'PENDING' AND verification_status IN ('VERIFIED', 'REJECTED'))
      );
