-- Women Events Phase 1 — idempotent (skip columns/tables that already exist).
-- Reuses event_hosts / women_events / women_event_registrations.

SET @t = (SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'women_events');

SET @c = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'women_events' AND column_name = 'lifecycle_status');
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE women_events ADD COLUMN lifecycle_status VARCHAR(40) NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @c = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'women_events' AND column_name = 'event_format');
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE women_events ADD COLUMN event_format VARCHAR(20) NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @c = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'women_events' AND column_name = 'short_description');
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE women_events ADD COLUMN short_description VARCHAR(500) NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @c = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'women_events' AND column_name = 'subcategory');
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE women_events ADD COLUMN subcategory VARCHAR(255) NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @c = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'women_events' AND column_name = 'starts_at');
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE women_events ADD COLUMN starts_at DATETIME NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @c = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'women_events' AND column_name = 'ends_at');
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE women_events ADD COLUMN ends_at DATETIME NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @c = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'women_events' AND column_name = 'registration_opens_at');
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE women_events ADD COLUMN registration_opens_at DATETIME NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @c = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'women_events' AND column_name = 'registration_closes_at');
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE women_events ADD COLUMN registration_closes_at DATETIME NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @c = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'women_events' AND column_name = 'timezone');
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE women_events ADD COLUMN timezone VARCHAR(64) NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @c = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'women_events' AND column_name = 'min_participants');
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE women_events ADD COLUMN min_participants INT NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @c = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'women_events' AND column_name = 'venue_area');
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE women_events ADD COLUMN venue_area VARCHAR(255) NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @c = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'women_events' AND column_name = 'venue_state');
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE women_events ADD COLUMN venue_state VARCHAR(255) NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @c = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'women_events' AND column_name = 'venue_pincode');
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE women_events ADD COLUMN venue_pincode VARCHAR(16) NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @c = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'women_events' AND column_name = 'parking_available');
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE women_events ADD COLUMN parking_available BIT(1) NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @c = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'women_events' AND column_name = 'accessibility_info');
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE women_events ADD COLUMN accessibility_info TEXT NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @c = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'women_events' AND column_name = 'venue_instructions');
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE women_events ADD COLUMN venue_instructions TEXT NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @c = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'women_events' AND column_name = 'meeting_platform');
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE women_events ADD COLUMN meeting_platform VARCHAR(255) NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @c = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'women_events' AND column_name = 'access_instructions');
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE women_events ADD COLUMN access_instructions TEXT NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @c = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'women_events' AND column_name = 'cancellation_policy');
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE women_events ADD COLUMN cancellation_policy TEXT NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @c = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'women_events' AND column_name = 'refund_policy');
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE women_events ADD COLUMN refund_policy TEXT NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @c = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'women_events' AND column_name = 'age_restriction');
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE women_events ADD COLUMN age_restriction VARCHAR(255) NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @c = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'women_events' AND column_name = 'participant_requirements');
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE women_events ADD COLUMN participant_requirements TEXT NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @c = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'women_events' AND column_name = 'what_to_bring');
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE women_events ADD COLUMN what_to_bring TEXT NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @c = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'women_events' AND column_name = 'terms_instructions');
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE women_events ADD COLUMN terms_instructions TEXT NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @c = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'women_events' AND column_name = 'poster_path');
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE women_events ADD COLUMN poster_path VARCHAR(512) NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @c = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'women_events' AND column_name = 'promo_video_path');
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE women_events ADD COLUMN promo_video_path VARCHAR(512) NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @c = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'women_events' AND column_name = 'admin_review_note');
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE women_events ADD COLUMN admin_review_note TEXT NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @c = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'women_events' AND column_name = 'published_at');
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE women_events ADD COLUMN published_at DATETIME NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @c = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'women_events' AND column_name = 'cancelled_at');
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE women_events ADD COLUMN cancelled_at DATETIME NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @c = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'women_events' AND column_name = 'updated_at');
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE women_events ADD COLUMN updated_at DATETIME NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @c = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'women_events' AND column_name = 'version');
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE women_events ADD COLUMN version BIGINT NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @t = (SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'women_event_registrations');

SET @c = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'women_event_registrations' AND column_name = 'ticket_type_id');
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE women_event_registrations ADD COLUMN ticket_type_id BIGINT NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @c = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'women_event_registrations' AND column_name = 'ticket_type_name');
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE women_event_registrations ADD COLUMN ticket_type_name VARCHAR(255) NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @c = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'women_event_registrations' AND column_name = 'quantity');
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE women_event_registrations ADD COLUMN quantity INT NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @c = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'women_event_registrations' AND column_name = 'coins_used');
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE women_event_registrations ADD COLUMN coins_used INT NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @c = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'women_event_registrations' AND column_name = 'payable_amount');
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE women_event_registrations ADD COLUMN payable_amount DOUBLE NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @c = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'women_event_registrations' AND column_name = 'refunded');
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE women_event_registrations ADD COLUMN refunded BIT(1) NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @c = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'women_event_registrations' AND column_name = 'refund_amount');
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE women_event_registrations ADD COLUMN refund_amount DOUBLE NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @c = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'women_event_registrations' AND column_name = 'qr_token');
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE women_event_registrations ADD COLUMN qr_token VARCHAR(64) NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @c = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'women_event_registrations' AND column_name = 'checked_in_at');
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE women_event_registrations ADD COLUMN checked_in_at DATETIME NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @t = (SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'event_hosts');

SET @c = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'event_hosts' AND column_name = 'gender');
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE event_hosts ADD COLUMN gender VARCHAR(20) NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @c = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'event_hosts' AND column_name = 'date_of_birth');
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE event_hosts ADD COLUMN date_of_birth VARCHAR(32) NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @c = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'event_hosts' AND column_name = 'languages');
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE event_hosts ADD COLUMN languages TEXT NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @c = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'event_hosts' AND column_name = 'youtube');
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE event_hosts ADD COLUMN youtube VARCHAR(255) NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @c = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'event_hosts' AND column_name = 'awards_recognition');
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE event_hosts ADD COLUMN awards_recognition TEXT NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @c = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'event_hosts' AND column_name = 'country');
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE event_hosts ADD COLUMN country VARCHAR(128) NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @c = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'event_hosts' AND column_name = 'area');
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE event_hosts ADD COLUMN area VARCHAR(255) NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @c = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'event_hosts' AND column_name = 'events_conducted');
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE event_hosts ADD COLUMN events_conducted INT NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @c = (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'event_hosts' AND column_name = 'previous_event_details');
SET @sql = IF(@t > 0 AND @c = 0, 'ALTER TABLE event_hosts ADD COLUMN previous_event_details TEXT NULL', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

CREATE TABLE IF NOT EXISTS event_ticket_types (
    id BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    event_id BIGINT NOT NULL,
    name VARCHAR(255) NOT NULL,
    description VARCHAR(1000) NULL,
    price DOUBLE NOT NULL DEFAULT 0,
    quantity INT NOT NULL DEFAULT 0,
    sold_count INT NOT NULL DEFAULT 0,
    sale_start DATETIME NULL,
    sale_end DATETIME NULL,
    max_per_user INT NULL,
    active BIT(1) NOT NULL DEFAULT 1,
    version BIGINT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS event_speakers (
    id BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    event_id BIGINT NOT NULL,
    name VARCHAR(255) NOT NULL,
    photo_path VARCHAR(512) NULL,
    designation VARCHAR(255) NULL,
    organization VARCHAR(255) NULL,
    bio VARCHAR(2000) NULL,
    topic VARCHAR(255) NULL,
    sort_order INT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS event_agenda_items (
    id BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    event_id BIGINT NOT NULL,
    title VARCHAR(255) NOT NULL,
    description VARCHAR(2000) NULL,
    start_time TIME NULL,
    end_time TIME NULL,
    speaker_name VARCHAR(255) NULL,
    sort_order INT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS event_status_history (
    id BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    event_id BIGINT NOT NULL,
    from_status VARCHAR(40) NULL,
    to_status VARCHAR(40) NOT NULL,
    actor_role VARCHAR(40) NULL,
    actor_id BIGINT NULL,
    reason VARCHAR(2000) NULL,
    created_at DATETIME NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS event_favorites (
    id BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    event_id BIGINT NOT NULL,
    user_id BIGINT NOT NULL,
    created_at DATETIME NULL,
    UNIQUE KEY uk_event_favorite_user (event_id, user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS event_audit_logs (
    id BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    actor_role VARCHAR(40) NOT NULL,
    actor_id BIGINT NULL,
    actor_email VARCHAR(255) NULL,
    action VARCHAR(80) NOT NULL,
    entity_type VARCHAR(40) NOT NULL,
    entity_id BIGINT NULL,
    reason VARCHAR(2000) NULL,
    metadata TEXT NULL,
    created_at DATETIME NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
