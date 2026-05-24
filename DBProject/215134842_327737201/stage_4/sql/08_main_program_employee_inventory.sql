-- 08_main_program_employee_inventory.sql
-- Main Program 2:
--   * Calls one function: calculate_employee_bonus
--   * Calls one procedure: restock_low_inventory
-- Notes:
--   * The program dynamically chooses existing ids from the database.
--   * It is wrapped in a transaction so you can test safely.
--   * For screenshots, run section by section in pgAdmin.

BEGIN;

-- Before: choose an existing employee and calculate bonus.
WITH chosen_employee AS (
    SELECT employee_id
    FROM public.employee
    ORDER BY employee_id
    LIMIT 1
)
SELECT e.employee_id,
       e.first_name,
       e.last_name,
       public.calculate_employee_bonus(e.employee_id) AS calculated_bonus
FROM public.employee e
JOIN chosen_employee ce ON e.employee_id = ce.employee_id;

-- Prepare demo data if no inventory row is currently below minimum stock.
-- This makes the procedure easier to demonstrate.
UPDATE public.inventory i
SET quantity_in_stock = 0
WHERE i.inventory_id = (
    SELECT inventory_id
    FROM public.inventory
    WHERE min_stock_level IS NOT NULL
    ORDER BY inventory_id
    LIMIT 1
);

-- Before restock.
SELECT inventory_id, branch_id, product_id, quantity_in_stock, min_stock_level, last_restock_date
FROM public.inventory
WHERE COALESCE(quantity_in_stock, 0) < COALESCE(min_stock_level, 0)
ORDER BY inventory_id
LIMIT 10;

-- Run procedure: restock low inventory in all branches.
CALL public.restock_low_inventory(NULL, 20);

-- After restock.
SELECT inventory_id, branch_id, product_id, quantity_in_stock, min_stock_level, last_restock_date
FROM public.inventory
ORDER BY last_restock_date DESC NULLS LAST, inventory_id
LIMIT 10;

-- Use COMMIT for real update screenshots, or ROLLBACK for safe testing.
ROLLBACK;
-- COMMIT;
