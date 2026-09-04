-- Glow Space expanded service taxonomy (Hair, Bridal, Mehendi, etc.).
-- Legacy MySQL ENUM on services.category rejected new values ("Data truncated").
DELIMITER //

CREATE PROCEDURE AlterServicesIfExists()
BEGIN
    IF EXISTS (
        SELECT 1 
        FROM information_schema.tables 
        WHERE table_schema = DATABASE() 
        AND table_name = 'services'
    ) THEN
        ALTER TABLE services MODIFY COLUMN category VARCHAR(64) NULL;
    END IF;
END //

DELIMITER ;

CALL AlterServicesIfExists();
DROP PROCEDURE AlterServicesIfExists;
