-- 09_trigger_demo.sql
-- Demonstrates both triggers:
--   * trg_validate_sale_item_before_change
--   * trg_update_inventory_after_sale_item_change
-- Notes:
--   * This file is optional but useful for screenshots in the README.
--   * It is wrapped in a transaction and ends with ROLLBACK for safe testing.

BEGIN;

-- Choose existing sale and inventory records.
-- Show stock before trigger execution.
WITH chosen_inventory AS (
    SELECT inventory_id
    FROM public.inventory
    WHERE COALESCE(quantity_in_stock, 0) >= 5
    ORDER BY inventory_id
    LIMIT 1
)
SELECT inventory_id, quantity_in_stock, min_stock_level
FROM public.inventory
WHERE inventory_id = (SELECT inventory_id FROM chosen_inventory);

-- Insert a valid sale item.
-- Trigger 1 calculates final_price.
-- Trigger 2 subtracts quantity from inventory.
INSERT INTO public.sale_inventory (
    sale_id,
    inventory_id,
    quantity,
    unit_price,
    discount_percent,
    item_status
)
SELECT s.sale_id,
       i.inventory_id,
       1,
       100.00,
       10.00,
       'completed'
FROM public.sale s
CROSS JOIN public.inventory i
WHERE COALESCE(i.quantity_in_stock, 0) >= 5
ORDER BY s.sale_id, i.inventory_id
LIMIT 1
ON CONFLICT (sale_id, inventory_id) DO UPDATE
SET quantity = public.sale_inventory.quantity + 1,
    unit_price = EXCLUDED.unit_price,
    discount_percent = EXCLUDED.discount_percent,
    item_status = EXCLUDED.item_status;

-- Show sale item after validation trigger calculated final_price.
SELECT sale_id, inventory_id, quantity, unit_price, discount_percent, final_price, item_status
FROM public.sale_inventory
ORDER BY sale_id DESC, inventory_id DESC
LIMIT 10;

-- Show stock after inventory trigger.
SELECT inventory_id, quantity_in_stock, min_stock_level
FROM public.inventory
ORDER BY inventory_id
LIMIT 10;

-- Uncomment this block to demonstrate an exception for an invalid discount.
-- DO $$
-- DECLARE
--     v_sale_id INTEGER;
--     v_inventory_id INTEGER;
-- BEGIN
--     SELECT sale_id INTO v_sale_id FROM public.sale ORDER BY sale_id LIMIT 1;
--     SELECT inventory_id INTO v_inventory_id FROM public.inventory WHERE COALESCE(quantity_in_stock, 0) >= 1 ORDER BY inventory_id LIMIT 1;
--
--     INSERT INTO public.sale_inventory (
--         sale_id, inventory_id, quantity, unit_price, discount_percent, item_status
--     )
--     VALUES (v_sale_id, v_inventory_id, 1, 100.00, 80.00, 'completed');
-- END;
-- $$;

ROLLBACK;
