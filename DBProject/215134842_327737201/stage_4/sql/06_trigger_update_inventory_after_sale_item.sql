-- 06_trigger_update_inventory_after_sale_item.sql
-- Trigger 2: Updates derived inventory quantity after sale item changes.
-- Business logic:
--   * After INSERT into sale_inventory, subtracts sold quantity from inventory.
--   * After UPDATE, adjusts inventory according to the quantity difference.
--   * Prevents stock from becoming negative.
--   * Updates inventory automatically based on sale activity.

CREATE OR REPLACE FUNCTION public.trg_update_inventory_after_sale_item()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_current_stock INTEGER;
    v_quantity_delta INTEGER;
BEGIN
    IF TG_OP = 'INSERT' THEN
        v_quantity_delta := NEW.quantity;
    ELSIF TG_OP = 'UPDATE' THEN
        v_quantity_delta := NEW.quantity - OLD.quantity;
    ELSE
        RETURN NEW;
    END IF;

    SELECT COALESCE(i.quantity_in_stock, 0)
    INTO v_current_stock
    FROM public.inventory i
    WHERE i.inventory_id = NEW.inventory_id
    FOR UPDATE;

    IF v_current_stock IS NULL THEN
        RAISE EXCEPTION 'Inventory item % does not exist', NEW.inventory_id;
    END IF;

    IF v_current_stock - v_quantity_delta < 0 THEN
        RAISE EXCEPTION 'Not enough stock for inventory id %. Current stock: %, requested additional quantity: %',
            NEW.inventory_id, v_current_stock, v_quantity_delta;
    END IF;

    UPDATE public.inventory i
    SET quantity_in_stock = v_current_stock - v_quantity_delta
    WHERE i.inventory_id = NEW.inventory_id;

    RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_update_inventory_after_sale_item_change ON public.sale_inventory;

CREATE TRIGGER trg_update_inventory_after_sale_item_change
AFTER INSERT OR UPDATE ON public.sale_inventory
FOR EACH ROW
EXECUTE FUNCTION public.trg_update_inventory_after_sale_item();
