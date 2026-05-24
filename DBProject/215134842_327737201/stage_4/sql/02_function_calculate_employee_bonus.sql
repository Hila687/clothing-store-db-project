-- 02_function_calculate_employee_bonus.sql
-- Function 2: Calculates an employee bonus according to sales performance.
-- Business logic:
--   * Sums all completed/non-cancelled sales made by the employee.
--   * Counts number of sales.
--   * Gives bonus by sales tiers.
--   * Adds an extra bonus for a high number of sales.
--   * Uses implicit cursor, conditions, calculations and exception handling.

CREATE OR REPLACE FUNCTION public.calculate_employee_bonus(p_employee_id INTEGER)
RETURNS NUMERIC
LANGUAGE plpgsql
AS $$
DECLARE
    v_employee_exists INTEGER;
    v_total_sales NUMERIC := 0;
    v_sale_count INTEGER := 0;
    v_bonus NUMERIC := 0;
    sale_rec RECORD;
BEGIN
    SELECT COUNT(*)
    INTO v_employee_exists
    FROM public.employee e
    WHERE e.employee_id = p_employee_id;

    IF v_employee_exists = 0 THEN
        RAISE EXCEPTION 'Employee with id % does not exist', p_employee_id;
    END IF;

    FOR sale_rec IN
        SELECT s.sale_id, COALESCE(s.total_amount, 0) AS total_amount
        FROM public.sale s
        WHERE s.employee_id = p_employee_id
          AND COALESCE(LOWER(s.sale_status), 'completed') NOT IN ('cancelled', 'canceled')
    LOOP
        v_total_sales := v_total_sales + sale_rec.total_amount;
        v_sale_count := v_sale_count + 1;
    END LOOP;

    IF v_total_sales >= 50000 THEN
        v_bonus := v_total_sales * 0.08;
    ELSIF v_total_sales >= 25000 THEN
        v_bonus := v_total_sales * 0.05;
    ELSIF v_total_sales >= 10000 THEN
        v_bonus := v_total_sales * 0.03;
    ELSE
        v_bonus := v_total_sales * 0.01;
    END IF;

    IF v_sale_count >= 100 THEN
        v_bonus := v_bonus + 500;
    ELSIF v_sale_count >= 50 THEN
        v_bonus := v_bonus + 250;
    END IF;

    RETURN ROUND(v_bonus, 2);

EXCEPTION
    WHEN OTHERS THEN
        RAISE;
END;
$$;
