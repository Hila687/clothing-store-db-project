--Update Queries
--UPDATE 1 – Apply Discount to Products with Very Low Sales Quantity
UPDATE product
SET base_price = base_price * 0.9
WHERE product_id IN (
    SELECT p.product_id
    FROM product p
    JOIN inventory i
        ON p.product_id = i.product_id
    JOIN sale_inventory si
        ON i.inventory_id = si.inventory_id
    GROUP BY p.product_id
    HAVING SUM(si.quantity) < 80
);

--UPDATE 2 – Mark Customers as Inactive if They Did Not Purchase Since a Selected Date
UPDATE customer
SET customer_status = 'inactive'
WHERE customer_id IN (
    SELECT c.customer_id
    FROM customer c
    WHERE NOT EXISTS (
        SELECT 1
        FROM sale s
        WHERE s.customer_id = c.customer_id
          AND s.sale_date >= '2024-08-05'
    )
);

--UPDATE 3 – Increase Minimum Stock Level for High-Demand Products
UPDATE inventory
SET min_stock_level = min_stock_level + 5
WHERE product_id IN (
    SELECT
        i.product_id
    FROM inventory i
    JOIN sale_inventory si
        ON i.inventory_id = si.inventory_id
    GROUP BY i.product_id
    HAVING SUM(si.quantity) > 500
);
