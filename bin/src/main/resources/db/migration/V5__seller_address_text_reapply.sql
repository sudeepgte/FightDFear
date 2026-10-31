-- Re-apply TEXT widths; Hibernate ddl-auto had shrunk these back to VARCHAR(255).
ALTER TABLE women_product_sellers MODIFY COLUMN address TEXT NULL;
ALTER TABLE women_product_sellers MODIFY COLUMN description TEXT NULL;
ALTER TABLE women_product_sellers MODIFY COLUMN identity_doc_path VARCHAR(500) NULL;
ALTER TABLE women_product_sellers MODIFY COLUMN profile_photo_path VARCHAR(500) NULL;
