BEGIN;

UPDATE product
SET base_price = base_price * 0.5
WHERE product_id = 190;

SELECT product_id, base_price
FROM product
WHERE product_id = 190;

ROLLBACK;

SELECT product_id, base_price
FROM product
WHERE product_id = 190;