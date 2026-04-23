--SELECT Queries
--Query 1 – Sales Summary per Branch in a Date Range
SELECT
    b.branch_id,
    b.branch_name,
    COUNT(s.sale_id) AS number_of_sales,
    SUM(s.total_amount) AS total_sales_amount
FROM branch b
JOIN sale s
    ON b.branch_id = s.branch_id
WHERE EXTRACT(YEAR FROM s.sale_date) = 2024
GROUP BY b.branch_id, b.branch_name
ORDER BY total_sales_amount DESC;

--Query 2 – Best-Selling Products by Quantity
SELECT
    p.product_id,
    p.product_name,
    p.brand,
    SUM(si.quantity) AS total_quantity_sold
FROM product p
JOIN inventory i
    ON p.product_id = i.product_id
JOIN sale_inventory si
    ON i.inventory_id = si.inventory_id
GROUP BY p.product_id, p.product_name, p.brand
ORDER BY total_quantity_sold DESC;

--Query 3A – Customers Who Spent the Most Money (JOIN + GROUP BY)
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    SUM(s.total_amount) AS total_spent
FROM customer c
JOIN sale s
    ON c.customer_id = s.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_spent DESC;

--Query 3B – Customers Who Spent the Most Money (Correlated Subquery)
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    (
        SELECT SUM(s.total_amount)
        FROM sale s
        WHERE s.customer_id = c.customer_id
    ) AS total_spent
FROM customer c
WHERE EXISTS (
    SELECT 1
    FROM sale s
    WHERE s.customer_id = c.customer_id
)
ORDER BY total_spent DESC;

--Query 4A – Products Not Sold in a Selected Date Range (NOT EXISTS)
SELECT
    p.product_id,
    p.product_name,
    p.brand
FROM product p
WHERE NOT EXISTS (
    SELECT 1
    FROM inventory i
    JOIN sale_inventory si
        ON i.inventory_id = si.inventory_id
    JOIN sale s
        ON si.sale_id = s.sale_id
    WHERE i.product_id = p.product_id
      AND s.sale_date BETWEEN '2024-01-01' AND '2024-12-31'
)
ORDER BY p.product_id;

--Query 4B – Products Not Sold in a Selected Date Range (LEFT JOIN + IS NULL)
SELECT
    p.product_id,
    p.product_name,
    p.brand
FROM product p
LEFT JOIN inventory i
    ON p.product_id = i.product_id
LEFT JOIN sale_inventory si
    ON i.inventory_id = si.inventory_id
LEFT JOIN sale s
    ON si.sale_id = s.sale_id
   AND s.sale_date BETWEEN '2024-01-01' AND '2024-12-31'
WHERE s.sale_id IS NULL
ORDER BY p.product_id;

--Query 5 - Low Inventory Report for Goods Order
SELECT 
    p.product_name, 
    i.quantity_in_stock, 
    i.min_stock_level, 
    b.branch_name
FROM 
    Inventory i
JOIN 
    Product p ON i.product_id = p.product_id
JOIN 
    Branch b ON i.branch_id = b.branch_id
WHERE 
    i.quantity_in_stock < i.min_stock_level
ORDER BY 
    i.quantity_in_stock ASC;

--Query 6 - Suppliers and their products
SELECT 
    s.supplier_name, 
    p.product_name, 
    s.contract_start_date
FROM 
    Supplier s
JOIN 
    Product p ON s.supplier_id = p.supplier_id
WHERE 
    s.supplier_status = 'active'
ORDER BY 
    s.contract_start_date DESC;

--Query 7A - Customers who did not buy in a certain period
SELECT c.first_name, c.last_name, c.join_date
FROM Customer c
WHERE NOT EXISTS (
    SELECT 1 
    FROM Sale s 
    WHERE s.customer_id = c.customer_id 
    AND s.sale_date > '2024-11-01' -- כאן נשים תאריך של לפני חודשיים
);


--Query 7B - Customers who have not purchased in a certain period using LEFT JOIN and NULL checking
SELECT c.first_name, c.last_name, c.join_date
FROM Customer c
LEFT JOIN Sale s ON c.customer_id = s.customer_id AND s.sale_date > '2024-11-01'
WHERE s.sale_id IS NULL;

--Query 8A - Branches with the most sales using GROUP BY and ORDER BY
SELECT b.branch_name, COUNT(s.sale_id) AS total_sales
FROM Branch b
JOIN Sale s ON b.branch_id = s.branch_id
GROUP BY b.branch_id, b.branch_name
HAVING COUNT(s.sale_id) > 50
ORDER BY total_sales DESC;

--Query 8B - Branches with the most sales using a subquery
SELECT b.branch_name, 
       (SELECT COUNT(*) FROM Sale s WHERE s.branch_id = b.branch_id) AS total_sales
FROM Branch b
WHERE (SELECT COUNT(*) FROM Sale s WHERE s.branch_id = b.branch_id) > 50 -- רק סניפים עם מעל 100 מכירות
ORDER BY total_sales DESC;

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

--Delete Queries
--Delete 1
BEGIN;

DELETE FROM customer c
WHERE c.email IN ('noa.levi24@example.com', 'daniel.cohen24@example.com')
  AND NOT EXISTS (
      SELECT 1
      FROM sale s
      WHERE s.customer_id = c.customer_id
  );

COMMIT;

--Delete 2
DELETE FROM inventory i
WHERE i.quantity_in_stock = 0
  AND NOT EXISTS (
      SELECT 1
      FROM sale_inventory si
      WHERE si.inventory_id = i.inventory_id
  );

--Delete 3
DELETE FROM supplier s
WHERE s.supplier_status = 'inactive'
  AND NOT EXISTS (
      SELECT 1
      FROM product p
      WHERE p.supplier_id = s.supplier_id
  )
	AND supplier_id < 60;
