-- Self-defense centre (MartialArtsCenter) profile lifecycle — mirrors doctor quick-register flow.
ALTER TABLE martial_arts_center
    ADD COLUMN centre_profile_status VARCHAR(40) NULL,
    ADD COLUMN profile_completion_pct INT NULL DEFAULT 0,
    ADD COLUMN accepted_terms_at DATETIME NULL,
    ADD COLUMN submitted_for_verification_at DATETIME NULL,
    ADD COLUMN rejection_reason TEXT NULL,
    ADD COLUMN changes_requested_note TEXT NULL,
    ADD COLUMN contact_person VARCHAR(120) NULL;

UPDATE martial_arts_center
SET centre_profile_status = 'APPROVED',
    profile_completion_pct = 100
WHERE approved = 1
  AND (centre_profile_status IS NULL OR centre_profile_status = '');

UPDATE martial_arts_center
SET centre_profile_status = 'PENDING_ADMIN_APPROVAL',
    profile_completion_pct = COALESCE(profile_completion_pct, 80)
WHERE approved = 0
  AND about IS NOT NULL AND TRIM(about) <> ''
  AND (centre_profile_status IS NULL OR centre_profile_status = '');

UPDATE martial_arts_center
SET centre_profile_status = 'PROFILE_INCOMPLETE',
    profile_completion_pct = COALESCE(profile_completion_pct, 20)
WHERE approved = 0
  AND (about IS NULL OR TRIM(about) = '')
  AND (centre_profile_status IS NULL OR centre_profile_status = '');
