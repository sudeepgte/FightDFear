-- Normalize legacy women_products.category values to canonical codes shared by
-- seller dashboard and user shop filters (SKINCARE, HAIRCARE, …).
-- Safe to re-run: only updates known alias / display-name rows.

UPDATE women_products SET category = 'SKINCARE'
WHERE LOWER(TRIM(category)) IN ('skincare', 'skincare defense');

UPDATE women_products SET category = 'HAIRCARE'
WHERE LOWER(TRIM(category)) IN ('haircare');

UPDATE women_products SET category = 'HYGIENE'
WHERE LOWER(TRIM(category)) IN ('hygiene', 'sanitary hygiene');

UPDATE women_products SET category = 'CLOTHING'
WHERE LOWER(TRIM(category)) IN ('clothing', 'personal wear');

UPDATE women_products SET category = 'ACCESSORIES'
WHERE LOWER(TRIM(category)) IN ('accessories', 'tactical accessories');

UPDATE women_products SET category = 'WELLNESS'
WHERE LOWER(TRIM(category)) IN ('wellness', 'wellness essentials');

UPDATE women_products SET category = 'OTHER'
WHERE LOWER(TRIM(category)) IN ('other', 'other domains');

-- Uppercase any remaining exact canonical codes stored in mixed case
UPDATE women_products SET category = UPPER(TRIM(category))
WHERE UPPER(TRIM(category)) IN ('SKINCARE', 'HAIRCARE', 'HYGIENE', 'CLOTHING', 'ACCESSORIES', 'WELLNESS', 'OTHER')
  AND category <> UPPER(TRIM(category));
