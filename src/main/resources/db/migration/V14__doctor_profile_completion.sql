-- Milestone 3: doctor profile completion fields

ALTER TABLE doctors
    ADD COLUMN languages VARCHAR(500) NULL,
    ADD COLUMN services VARCHAR(1000) NULL,
    ADD COLUMN bio TEXT NULL,
    ADD COLUMN consultation_modes VARCHAR(200) NULL,
    ADD COLUMN availability_slots TEXT NULL,
    ADD COLUMN additional_certificate_path VARCHAR(1000) NULL;
