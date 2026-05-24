-- 05_trigger_validate_sale_item.sql
-- Trigger 1: Business validation before INSERT or UPDATE on sale_inventory.
-- Business logic:
--   * Prevents negative or zero quantities.
--   * Prevents discounts outside 0-70.
--   * Prevents discounts over 20% for non-VIP/non-Gold/non-Premium customers.
--   * Calculates final_price automatically.
-- Requirement note: this trigger runs on UPDATE as required by Stage 4.

CREATE OR REPLACE FUNCTION public.trg_validate_sale_item()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_customer_id INTEGER;
    v_loyalty_name VARCHAR(255);
BEGIN
    IF NEW.quantity IS NULL OR NEW.quantity <= 0 THEN
        RAISE EXCEPTION 'Sale item quantity must be positive. Received: %', NEW.quantity;
    END IF;

    IF NEW.unit_price IS NULL OR NEW.unit_price < 0 THEN
        RAISE EXCEPTION 'Sale item unit price must be non-negative. Received: %', NEW.unit_price;
    END IF;

    NEW.discount_percent := COALESCE(NEW.discount_percent, 0);

    IF NEW.discount_percent < 0 OR NEW.discount_percent > 70 THEN
        RAISE EXCEPTION 'Discount percent must be between 0 and 70. Received: %', NEW.discount_percent;
    END IF;

    SELECT s.customer_id
    INTO v_customer_id
    FROM public.sale s
    WHERE s.sale_id = NEW.sale_id;

    IF v_customer_id IS NULL THEN
        RAISE EXCEPTION 'Sale % does not exist or has no customer', NEW.sale_id;
    END IF;

    SELECT ll.level_name
    INTO v_loyalty_name
    FROM public.customer c
    LEFT JOIN public.loyalty_level ll ON c.loyalty_id = ll.loyalty_id
    WHERE c.customer_id = v_customer_id;

    IF NEW.discount_percent > 20
       AND LOWER(COALESCE(v_loyalty_name, '')) NOT IN ('vip', 'gold', 'premium') THEN
        RAISE EXCEPTION 'Discount above 20%% is allowed only for VIP/Gold/Premium customers. Customer id: %, loyalty level: %',
            v_customer_id, COALESCE(v_loyalty_name, 'none');
    END IF;

    NEW.final_price := ROUND((NEW.unit_price * NEW.quantity * (1 - NEW.discount_percent / 100.0))::NUMERIC, 2);

    RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_validate_sale_item_before_change ON public.sale_inventory;

CREATE TRIGGER trg_validate_sale_item_before_change
BEFORE INSERT OR UPDATE ON public.sale_inventory
FOR EACH ROW
EXECUTE FUNCTION public.trg_validate_sale_item();
