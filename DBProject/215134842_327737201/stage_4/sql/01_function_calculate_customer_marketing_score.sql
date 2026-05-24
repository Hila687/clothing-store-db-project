-- 01_function_calculate_customer_marketing_score.sql
-- Function 1: Calculates a marketing value score for a customer.
-- Business logic:
--   * Gives points for total purchases.
--   * Gives points for number of targeted campaigns.
--   * Gives points for actual campaign-related purchases.
--   * Adds a loyalty-level bonus.
--   * Uses an explicit cursor, loop, conditions, records and exception handling.

CREATE OR REPLACE FUNCTION public.calculate_customer_marketing_score(p_customer_id INTEGER)
RETURNS NUMERIC
LANGUAGE plpgsql
AS $$
DECLARE
    v_customer_exists INTEGER;
    v_loyalty_name VARCHAR(255);
    v_total_spent NUMERIC := 0;
    v_targeted_campaigns INTEGER := 0;
    v_campaign_sales INTEGER := 0;
    v_score NUMERIC := 0;
    v_sale_record RECORD;

    cur_customer_sales CURSOR FOR
        SELECT s.sale_id, s.total_amount, s.campaign_id
        FROM public.sale s
        WHERE s.customer_id = p_customer_id;
BEGIN
    SELECT COUNT(*)
    INTO v_customer_exists
    FROM public.customer c
    WHERE c.customer_id = p_customer_id;

    IF v_customer_exists = 0 THEN
        RAISE EXCEPTION 'Customer with id % does not exist', p_customer_id;
    END IF;

    SELECT ll.level_name
    INTO v_loyalty_name
    FROM public.customer c
    LEFT JOIN public.loyalty_level ll ON c.loyalty_id = ll.loyalty_id
    WHERE c.customer_id = p_customer_id;

    SELECT COUNT(*)
    INTO v_targeted_campaigns
    FROM public.campaign_customer cc
    WHERE cc.customer_id = p_customer_id;

    OPEN cur_customer_sales;

    LOOP
        FETCH cur_customer_sales INTO v_sale_record;
        EXIT WHEN NOT FOUND;

        v_total_spent := v_total_spent + COALESCE(v_sale_record.total_amount, 0);

        IF v_sale_record.campaign_id IS NOT NULL THEN
            v_campaign_sales := v_campaign_sales + 1;
        END IF;
    END LOOP;

    CLOSE cur_customer_sales;

    v_score := (v_total_spent / 100)
               + (v_targeted_campaigns * 10)
               + (v_campaign_sales * 20);

    IF LOWER(COALESCE(v_loyalty_name, '')) IN ('vip', 'gold', 'premium') THEN
        v_score := v_score + 50;
    ELSIF LOWER(COALESCE(v_loyalty_name, '')) IN ('silver') THEN
        v_score := v_score + 25;
    END IF;

    RETURN ROUND(v_score, 2);

EXCEPTION
    WHEN OTHERS THEN
        IF cur_customer_sales%ISOPEN THEN
            CLOSE cur_customer_sales;
        END IF;
        RAISE;
END;
$$;
