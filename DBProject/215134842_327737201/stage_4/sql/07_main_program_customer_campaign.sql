-- 07_main_program_customer_campaign.sql
-- Main Program 1:
--   * Calls one function: calculate_customer_marketing_score
--   * Calls one procedure: apply_campaign_discount
-- Notes:
--   * The program dynamically chooses existing ids from the database.
--   * It is wrapped in a transaction so you can test safely.
--   * For screenshots, run section by section in pgAdmin.

BEGIN;

-- Before: choose an existing customer and show the marketing score.
WITH chosen_customer AS (
    SELECT customer_id
    FROM public.customer
    ORDER BY customer_id
    LIMIT 1
)
SELECT c.customer_id,
       c.first_name,
       c.last_name,
       public.calculate_customer_marketing_score(c.customer_id) AS marketing_score
FROM public.customer c
JOIN chosen_customer cc ON c.customer_id = cc.customer_id;

-- Before: choose an existing campaign with a promotion and show related sales.
WITH chosen_campaign AS (
    SELECT ac.campaign_id
    FROM public.advertising_campaign ac
    JOIN public.promotion p ON ac.campaign_id = p.campaign_id
    JOIN public.sale s ON s.campaign_id = ac.campaign_id
    ORDER BY ac.campaign_id
    LIMIT 1
)
SELECT s.sale_id, s.campaign_id, s.promo_id, s.total_amount
FROM public.sale s
JOIN chosen_campaign cc ON s.campaign_id = cc.campaign_id
ORDER BY s.sale_id
LIMIT 10;

-- Run procedure: apply campaign discount.
DO $$
DECLARE
    v_campaign_id INTEGER;
BEGIN
    SELECT ac.campaign_id
    INTO v_campaign_id
    FROM public.advertising_campaign ac
    JOIN public.promotion p ON ac.campaign_id = p.campaign_id
    JOIN public.sale s ON s.campaign_id = ac.campaign_id
    ORDER BY ac.campaign_id
    LIMIT 1;

    IF v_campaign_id IS NULL THEN
        RAISE EXCEPTION 'No campaign with promotion and sales was found for the demo';
    END IF;

    CALL public.apply_campaign_discount(v_campaign_id);
END;
$$;

-- After: show updated sales after applying the campaign discount.
WITH chosen_campaign AS (
    SELECT ac.campaign_id
    FROM public.advertising_campaign ac
    JOIN public.promotion p ON ac.campaign_id = p.campaign_id
    JOIN public.sale s ON s.campaign_id = ac.campaign_id
    ORDER BY ac.campaign_id
    LIMIT 1
)
SELECT s.sale_id, s.campaign_id, s.promo_id, s.total_amount
FROM public.sale s
JOIN chosen_campaign cc ON s.campaign_id = cc.campaign_id
ORDER BY s.sale_id
LIMIT 10;

-- Use COMMIT for real update screenshots, or ROLLBACK for safe testing.
ROLLBACK;
-- COMMIT;
