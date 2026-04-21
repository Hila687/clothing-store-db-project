--Constraints
--Constraint 1 – Product Base Price Must Be Positive
ALTER TABLE product
ADD CONSTRAINT chk_product_base_price_positive
CHECK (base_price > 0);

--Constraint 2 – Inventory Quantity Must Be Non-Negative
ALTER TABLE inventory
ADD CONSTRAINT chk_inventory_quantity_nonnegative
CHECK (quantity_in_stock >= 0);

--Constraint 3 – Discount Percent Must Be Between 0 and 100
ALTER TABLE sale_inventory
ADD CONSTRAINT chk_sale_inventory_discount_percent_range
CHECK (discount_percent >= 0 AND discount_percent <= 100);