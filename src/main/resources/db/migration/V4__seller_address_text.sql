-- Marketplace seller registration can send multi-line shop details.
ALTER TABLE women_product_sellers
    MODIFY COLUMN address TEXT NULL;
ALTER TABLE women_product_sellers
    MODIFY COLUMN description TEXT NULL;
