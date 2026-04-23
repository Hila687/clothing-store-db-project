--Rollback
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

--Commit (The Commit was performed on Delete query1)
BEGIN;

DELETE FROM customer c
WHERE c.email IN ('noa.levi24@example.com', 'daniel.cohen24@example.com')
  AND NOT EXISTS (
      SELECT 1
      FROM sale s
      WHERE s.customer_id = c.customer_id
  );

COMMIT;

SELECT * FROM customer c
WHERE c.email IN ('noa.levi24@example.com', 'daniel.cohen24@example.com')
  AND NOT EXISTS (
      SELECT 1
      FROM sale s
      WHERE s.customer_id = c.customer_id
  );
