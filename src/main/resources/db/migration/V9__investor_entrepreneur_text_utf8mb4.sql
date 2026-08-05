-- Investor / Entrepreneur free-text + Unicode (Rs / long bios).
ALTER TABLE investors CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE entrepreneurs CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE business_proposals CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

ALTER TABLE investors MODIFY COLUMN investment_interests TEXT NULL;
ALTER TABLE investors MODIFY COLUMN preferred_locations TEXT NULL;
ALTER TABLE investors MODIFY COLUMN preferred_categories TEXT NULL;
ALTER TABLE investors MODIFY COLUMN verification_documents TEXT NULL;

ALTER TABLE entrepreneurs MODIFY COLUMN business_description TEXT NULL;
ALTER TABLE business_proposals MODIFY COLUMN description TEXT NULL;
