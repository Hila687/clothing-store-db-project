-- =========================================================
-- מבט 1: האגף המקורי שלנו (חנות הבגדים)
-- =========================================================
CREATE VIEW v_clothing_store_summary AS
SELECT 
    c.customer_id,
    c.first_name || ' ' || c.last_name AS customer_name,
    b.branch_name,
    COUNT(s.sale_id) AS total_purchases,
    SUM(s.total_amount) AS total_spent
FROM customer c
JOIN sale s ON c.customer_id = s.customer_id
JOIN branch b ON s.branch_id = b.branch_id
GROUP BY c.customer_id, c.first_name, c.last_name, b.branch_name;

-- שאילתה א' על מבט 1: לקוחות שהוציאו מעל 1000 ש"ח
SELECT * FROM v_clothing_store_summary 
WHERE total_spent > 1000;

-- שאילתה ב' על מבט 1: סיכום מכירות לפי סניף
SELECT branch_name, SUM(total_purchases) AS branch_total_sales
FROM v_clothing_store_summary
GROUP BY branch_name
ORDER BY branch_total_sales DESC;


-- =========================================================
-- מבט 2: האגף שקיבלנו (מערכת הקמפיינים)
-- =========================================================
CREATE VIEW v_campaign_reach_summary AS
SELECT 
    ac.campaign_id,
    ac.campaign_name,
    ac.budget,
    COUNT(cc.customer_id) AS total_targeted_customers
FROM advertising_campaign ac
LEFT JOIN campaign_customer cc ON ac.campaign_id = cc.campaign_id
GROUP BY ac.campaign_id, ac.campaign_name, ac.budget;

-- שאילתה א' על מבט 2: קמפיינים פעילים עם לקוחות
SELECT * FROM v_campaign_reach_summary 
WHERE total_targeted_customers > 0;

-- שאילתה ב' על מבט 2: סידור קמפיינים לפי תקציב מהגבוה לנמוך
SELECT * FROM v_campaign_reach_summary 
ORDER BY budget DESC;


-- =========================================================
-- מבט 3: מבט האינטגרציה המשולב (קמפיינים ומכירות)
-- =========================================================
CREATE VIEW v_integrated_marketing_sales AS
SELECT 
    ac.campaign_id,
    ac.campaign_name,
    COUNT(DISTINCT cc.customer_id) AS targeted_customers,
    COUNT(DISTINCT s.sale_id) AS actual_sales
FROM advertising_campaign ac
JOIN campaign_customer cc ON ac.campaign_id = cc.campaign_id
JOIN sale s ON cc.customer_id = s.customer_id
GROUP BY ac.campaign_id, ac.campaign_name;

-- שאילתה א' על מבט 3: הקמפיין שהביא הכי הרבה רכישות בפועל לחנות
SELECT * FROM v_integrated_marketing_sales 
ORDER BY actual_sales DESC;

-- שאילתה ב' על מבט 3: קמפיינים שהביאו 2 רכישות ומעלה
SELECT * FROM v_integrated_marketing_sales 
WHERE actual_sales >= 2;