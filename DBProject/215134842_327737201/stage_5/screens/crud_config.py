"""
CRUD table definitions – SQL queries and form fields for each central table.
All table/column names match the existing project schema.
"""

TABLE_CONFIGS = {
    "customer": {
        "title": "Customer Management",
        "table": "customer",
        "pk": "customer_id",
        "list_query": """
            SELECT c.customer_id, c.first_name, c.last_name, c.phone_number, c.email,
                   c.join_date, c.customer_status, ci.city_name, ll.level_name,
                   c.date_of_birth, c.points_balance
            FROM customer c
            LEFT JOIN city ci ON c.city_id = ci.city_id
            LEFT JOIN loyalty_level ll ON c.loyalty_id = ll.loyalty_id
            ORDER BY c.customer_id
        """,
        "list_columns": [
            ("customer_id", "ID"),
            ("first_name", "First Name"),
            ("last_name", "Last Name"),
            ("phone_number", "Phone"),
            ("email", "Email"),
            ("join_date", "Join Date"),
            ("customer_status", "Status"),
            ("city_name", "City"),
            ("level_name", "Loyalty Level"),
            ("date_of_birth", "Date of Birth"),
            ("points_balance", "Points"),
        ],
        "load_query": "SELECT * FROM customer WHERE customer_id = %s",
        "fields": [
            {"name": "first_name", "label": "First Name", "type": "text", "required": True},
            {"name": "last_name", "label": "Last Name", "type": "text", "required": True},
            {"name": "phone_number", "label": "Phone", "type": "text"},
            {"name": "email", "label": "Email", "type": "text"},
            {"name": "join_date", "label": "Join Date (YYYY-MM-DD)", "type": "date"},
            {"name": "customer_status", "label": "Status", "type": "text"},
            {"name": "preferences", "label": "Preferences (JSON)", "type": "json"},
            {
                "name": "city_id",
                "label": "City",
                "type": "fk",
                "lookup_table": "city",
                "lookup_id": "city_id",
                "lookup_display": "city_name",
            },
            {"name": "date_of_birth", "label": "Date of Birth (YYYY-MM-DD)", "type": "date"},
            {"name": "points_balance", "label": "Points Balance", "type": "int"},
            {
                "name": "loyalty_id",
                "label": "Loyalty Level",
                "type": "fk",
                "lookup_table": "loyalty_level",
                "lookup_id": "loyalty_id",
                "lookup_display": "level_name",
            },
        ],
    },
    "product": {
        "title": "Product Management",
        "table": "product",
        "pk": "product_id",
        "list_query": """
            SELECT p.product_id, p.product_name, p.brand, p.target_audience,
                   p.base_price, p.product_status, cat.category_name,
                   sup.supplier_name, sea.season_name
            FROM product p
            LEFT JOIN category cat ON p.category_id = cat.category_id
            LEFT JOIN supplier sup ON p.supplier_id = sup.supplier_id
            LEFT JOIN season sea ON p.season_id = sea.season_id
            ORDER BY p.product_id
        """,
        "list_columns": [
            ("product_id", "ID"),
            ("product_name", "Product Name"),
            ("brand", "Brand"),
            ("target_audience", "Audience"),
            ("base_price", "Base Price"),
            ("product_status", "Status"),
            ("category_name", "Category"),
            ("supplier_name", "Supplier"),
            ("season_name", "Season"),
        ],
        "load_query": "SELECT * FROM product WHERE product_id = %s",
        "fields": [
            {"name": "product_name", "label": "Product Name", "type": "text", "required": True},
            {"name": "brand", "label": "Brand", "type": "text"},
            {"name": "target_audience", "label": "Target Audience", "type": "text"},
            {"name": "base_price", "label": "Base Price", "type": "decimal"},
            {"name": "product_status", "label": "Status", "type": "text"},
            {"name": "extra_attributes", "label": "Extra Attributes (JSON)", "type": "json"},
            {
                "name": "category_id",
                "label": "Category",
                "type": "fk",
                "lookup_table": "category",
                "lookup_id": "category_id",
                "lookup_display": "category_name",
            },
            {
                "name": "supplier_id",
                "label": "Supplier",
                "type": "fk",
                "lookup_table": "supplier",
                "lookup_id": "supplier_id",
                "lookup_display": "supplier_name",
            },
            {
                "name": "season_id",
                "label": "Season",
                "type": "fk",
                "lookup_table": "season",
                "lookup_id": "season_id",
                "lookup_display": "season_name",
            },
        ],
    },
    "inventory": {
        "title": "Inventory Management",
        "table": "inventory",
        "pk": "inventory_id",
        "list_query": """
            SELECT i.inventory_id, p.product_name, b.branch_name,
                   i.quantity_in_stock, i.color, i.size, i.shelf_location,
                   i.min_stock_level, i.last_restock_date
            FROM inventory i
            LEFT JOIN product p ON i.product_id = p.product_id
            LEFT JOIN branch b ON i.branch_id = b.branch_id
            ORDER BY i.inventory_id
        """,
        "list_columns": [
            ("inventory_id", "ID"),
            ("product_name", "Product"),
            ("branch_name", "Branch"),
            ("quantity_in_stock", "Qty in Stock"),
            ("color", "Color"),
            ("size", "Size"),
            ("shelf_location", "Shelf"),
            ("min_stock_level", "Min Stock"),
            ("last_restock_date", "Last Restock"),
        ],
        "load_query": "SELECT * FROM inventory WHERE inventory_id = %s",
        "fields": [
            {"name": "quantity_in_stock", "label": "Quantity in Stock", "type": "int"},
            {"name": "color", "label": "Color", "type": "text"},
            {"name": "size", "label": "Size", "type": "text"},
            {"name": "shelf_location", "label": "Shelf Location", "type": "text"},
            {"name": "min_stock_level", "label": "Min Stock Level", "type": "int"},
            {"name": "last_restock_date", "label": "Last Restock (YYYY-MM-DD)", "type": "date"},
            {
                "name": "branch_id",
                "label": "Branch",
                "type": "fk",
                "lookup_table": "branch",
                "lookup_id": "branch_id",
                "lookup_display": "branch_name",
            },
            {
                "name": "product_id",
                "label": "Product",
                "type": "fk",
                "lookup_table": "product",
                "lookup_id": "product_id",
                "lookup_display": "product_name",
            },
        ],
    },
    "sale": {
        "title": "Sale Management",
        "table": "sale",
        "pk": "sale_id",
        "list_query": """
            SELECT s.sale_id, s.sale_date, s.total_amount, s.sale_status,
                   s.receipt_number,
                   c.first_name || ' ' || c.last_name AS customer_name,
                   e.first_name || ' ' || e.last_name AS employee_name,
                   b.branch_name, pm.payment_method_name,
                   ac.campaign_name, pr.promo_name
            FROM sale s
            LEFT JOIN customer c ON s.customer_id = c.customer_id
            LEFT JOIN employee e ON s.employee_id = e.employee_id
            LEFT JOIN branch b ON s.branch_id = b.branch_id
            LEFT JOIN paymentmethod pm ON s.payment_method_id = pm.payment_method_id
            LEFT JOIN advertising_campaign ac ON s.campaign_id = ac.campaign_id
            LEFT JOIN promotion pr ON s.promo_id = pr.promo_id
            ORDER BY s.sale_id
        """,
        "list_columns": [
            ("sale_id", "ID"),
            ("sale_date", "Sale Date"),
            ("total_amount", "Total"),
            ("sale_status", "Status"),
            ("receipt_number", "Receipt #"),
            ("customer_name", "Customer"),
            ("employee_name", "Employee"),
            ("branch_name", "Branch"),
            ("payment_method_name", "Payment Method"),
            ("campaign_name", "Campaign"),
            ("promo_name", "Promotion"),
        ],
        "load_query": "SELECT * FROM sale WHERE sale_id = %s",
        "fields": [
            {"name": "sale_date", "label": "Sale Date (YYYY-MM-DD)", "type": "date"},
            {"name": "total_amount", "label": "Total Amount", "type": "decimal"},
            {"name": "sale_status", "label": "Status", "type": "text"},
            {"name": "receipt_number", "label": "Receipt Number", "type": "text"},
            {
                "name": "customer_id",
                "label": "Customer",
                "type": "fk",
                "lookup_table": "customer",
                "lookup_id": "customer_id",
                "lookup_display": "first_name || ' ' || last_name",
            },
            {
                "name": "employee_id",
                "label": "Employee",
                "type": "fk",
                "lookup_table": "employee",
                "lookup_id": "employee_id",
                "lookup_display": "first_name || ' ' || last_name",
            },
            {
                "name": "branch_id",
                "label": "Branch",
                "type": "fk",
                "lookup_table": "branch",
                "lookup_id": "branch_id",
                "lookup_display": "branch_name",
            },
            {
                "name": "payment_method_id",
                "label": "Payment Method",
                "type": "fk",
                "lookup_table": "paymentmethod",
                "lookup_id": "payment_method_id",
                "lookup_display": "payment_method_name",
            },
            {
                "name": "campaign_id",
                "label": "Campaign",
                "type": "fk",
                "lookup_table": "advertising_campaign",
                "lookup_id": "campaign_id",
                "lookup_display": "campaign_name",
            },
            {
                "name": "promo_id",
                "label": "Promotion",
                "type": "fk",
                "lookup_table": "promotion",
                "lookup_id": "promo_id",
                "lookup_display": "promo_name",
            },
        ],
    },
}
