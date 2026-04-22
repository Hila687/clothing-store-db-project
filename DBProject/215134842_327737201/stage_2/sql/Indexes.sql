--Indexes
--Index1
CREATE INDEX idx_sale_customer_id
ON sale(customer_id);

--Index2
CREATE INDEX idx_sale_sale_date
ON sale(sale_date);

--Index3
CREATE INDEX idx_inventory_product_id
ON inventory(product_id);