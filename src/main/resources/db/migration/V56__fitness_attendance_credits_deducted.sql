-- Add credits_deducted and make trainer_id nullable for fitness_attendance
ALTER TABLE fitness_attendance ADD COLUMN IF NOT EXISTS credits_deducted INT DEFAULT 1;
ALTER TABLE fitness_attendance MODIFY COLUMN trainer_id BIGINT NULL;
