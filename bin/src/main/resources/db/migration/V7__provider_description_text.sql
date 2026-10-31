-- Service Partner registration packs business/hours/portfolio into description.
ALTER TABLE service_providers MODIFY COLUMN description TEXT NULL;
ALTER TABLE service_providers MODIFY COLUMN location_text TEXT NULL;
