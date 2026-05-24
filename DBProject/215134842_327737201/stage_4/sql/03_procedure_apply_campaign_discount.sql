-- 03_procedure_apply_campaign_discount.sql
-- Procedure 1: Applies campaign promotion discounts to sales that belong to a campaign.
-- Business logic:
--   * Finds the active promotion of a campaign.
--   * Updates sale_inventory rows of sales that belong to the campaign.
--   * Recalculates final_price for each sale item.
--   * Recalculates the total_amount in the sale table.
--   * Uses records, loops, DML, conditions and exception handling.

CREATE OR REPLACE PROCEDURE public.apply_campaign_discount(p_campaign_id INTEGER)
LANGUAGE plpgsql
AS $$
DECLARE
    v_campaign_exists INTEGER;
    v_promo_id INTEGER;
    v_discount NUMERIC(5,2);
    v_updated_items INTEGER := 0;
    sale_rec RECORD;
BEGIN
    SELECT COUNT(*)
    INTO v_campaign_exists
    FROM public.advertising_campaign ac
    WHERE ac.campaign_id = p_campaign_id;

    IF v_campaign_exists = 0 THEN
        RAISE EXCEPTION 'Campaign with id % does not exist', p_campaign_id;
    END IF;

    SELECT p.promo_id, COALESCE(p.discount_percent, 0)::NUMERIC(5,2)
    INTO v_promo_id, v_discount
    FROM public.promotion p
    WHERE p.campaign_id = p_campaign_id
      AND (p.valid_from IS NULL OR p.valid_from <= CURRENT_DATE)
      AND (p.valid_to IS NULL OR p.valid_to >= CURRENT_DATE)
    ORDER BY COALESCE(p.discount_percent, 0) DESC, p.promo_id
    LIMIT 1;

    IF v_promo_id IS NULL THEN
        RAISE EXCEPTION 'No active promotion was found for campaign id %', p_campaign_id;
    END IF;

    FOR sale_rec IN
        SELECT s.sale_id
        FROM public.sale s
        WHERE s.campaign_id = p_campaign_id
          AND COALESCE(LOWER(s.sale_status), 'completed') NOT IN ('cancelled', 'canceled')
    LOOP
        UPDATE public.sale_inventory si
        SET discount_percent = v_discount,
            final_price = ROUND((COALESCE(si.unit_price, 0) * si.quantity * (1 - v_discount / 100.0))::NUMERIC, 2)
        WHERE si.sale_id = sale_rec.sale_id;

        GET DIAGNOSTICS v_updated_items = ROW_COUNT;

        UPDATE public.sale s
        SET promo_id = v_promo_id,
            total_amount = COALESCE((
                SELECT SUM(COALESCE(si.final_price, 0))
                FROM public.sale_inventory si
                WHERE si.sale_id = sale_rec.sale_id
            ), 0)
        WHERE s.sale_id = sale_rec.sale_id;
    END LOOP;

    RAISE NOTICE 'Campaign discount applied. Campaign id: %, Promotion id: %, Discount: %%%',
        p_campaign_id, v_promo_id, v_discount;

EXCEPTION
    WHEN OTHERS THEN
        RAISE;
END;
$$;
