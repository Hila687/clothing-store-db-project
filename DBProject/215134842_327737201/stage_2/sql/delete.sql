--Delete Queries
--Delete 1
BEGIN;

DELETE FROM customer c
WHERE c.email IN ('noa.levi24@example.com', 'daniel.cohen24@example.com')
  AND NOT EXISTS (
      SELECT 1
      FROM sale s
      WHERE s.customer_id = c.customer_id
  );

COMMIT;

--Delete 2
DELETE FROM inventory i
WHERE i.quantity_in_stock = 0
  AND NOT EXISTS (
      SELECT 1
      FROM sale_inventory si
      WHERE si.inventory_id = i.inventory_id
  );

--Delete 3
DELETE FROM supplier s
WHERE s.supplier_status = 'inactive'
  AND NOT EXISTS (
      SELECT 1
      FROM product p
      WHERE p.supplier_id = s.supplier_id
  )
	AND supplier_id < 60;