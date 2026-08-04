-- Event Host / Women Events Unicode + long bio.
ALTER TABLE event_hosts CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE women_events CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE event_hosts MODIFY COLUMN host_bio TEXT NULL;
