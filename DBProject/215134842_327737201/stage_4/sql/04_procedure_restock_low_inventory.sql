-- 04_procedure_restock_low_inventory.sql
-- Procedure 2: Restocks products whose stock is below the minimum level.
-- Business logic:
--   * Finds inventory rows where quantity_in_stock is below min_stock_level.
--   * Restocks them to min_stock_level + p_extra_units.
--   * Updates last_restock_date.
--   * Can run for all branches or for a specific branch.
--   * Uses explicit cursor, loops, records, DML, conditions and exception handling.

CREATE OR REPLACE PROCEDURE public.restock_low_inventory(
    p_branch_id INTEGER DEFAULT NULL,
    p_extra_units INTEGER DEFAULT 20
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_branch_exists INTEGER;
    v_updated_count INTEGER := 0;
    inv_rec RECORD;

    cur_low_inventory CURSOR FOR
        SELECT i.inventory_id,
               i.branch_id,
               i.product_id,
               COALESCE(i.quantity_in_stock, 0) AS quantity_in_stock,
               COALESCE(i.min_stock_level, 0) AS min_stock_level
        FROM public.inventory i
        WHERE COALESCE(i.quantity_in_stock, 0) < COALESCE(i.min_stock_level, 0)
          AND (p_branch_id IS NULL OR i.branch_id = p_branch_id);
BEGIN
    IF p_extra_units < 0 THEN
        RAISE EXCEPTION 'Extra restock units cannot be negative. Received: %', p_extra_units;
    END IF;

    IF p_branch_id IS NOT NULL THEN
        SELECT COUNT(*)
        INTO v_branch_exists
        FROM public.branch b
        WHERE b.branch_id = p_branch_id;

        IF v_branch_exists = 0 THEN
            RAISE EXCEPTION 'Branch with id % does not exist', p_branch_id;
        END IF;
    END IF;

    OPEN cur_low_inventory;

    LOOP
        FETCH cur_low_inventory INTO inv_rec;
        EXIT WHEN NOT FOUND;

        UPDATE public.inventory i
        SET quantity_in_stock = inv_rec.min_stock_level + p_extra_units,
            last_restock_date = CURRENT_DATE
        WHERE i.inventory_id = inv_rec.inventory_id;

        v_updated_count := v_updated_count + 1;
    END LOOP;

    CLOSE cur_low_inventory;

    RAISE NOTICE 'Restock completed. Updated inventory rows: %', v_updated_count;

EXCEPTION
    WHEN OTHERS THEN
        IF cur_low_inventory%ISOPEN THEN
            CLOSE cur_low_inventory;
        END IF;
        RAISE;
END;
$$;
