import random
import time
import json
from datetime import datetime, timedelta

# פונקציית עזר ליצירת תאריכים אקראיים
def random_date(start_year=2020, end_year=2023):
    start = datetime(start_year, 1, 1)
    end = datetime(end_year, 12, 31)
    return start + timedelta(days=random.randint(0, (end - start).days))

# פתיחת קובץ טקסט לכתיבת פקודות ה-SQL
with open('insert_big_data.sql', 'w', encoding='utf-8') as file:
    
    file.write("-- התחלת ייצור נתונים\n\n")

    # ---------------------------------------------------------
    # 1. ייצור 500 מוצרים (Product)
    # ---------------------------------------------------------
    print("Generating Products...")
    file.write("-- מילוי טבלת מוצרים (500 רשומות)\n")
    for i in range(1, 501):
        name = f"Product_{i}"
        brand = random.choice(['Nike', 'Adidas', 'Zara', 'H&M', 'Gucci', 'LocalBrand'])
        audience = random.choice(['Men', 'Women', 'Kids', 'Unisex'])
        price = round(random.uniform(20.0, 500.0), 2)
        status = random.choice(['Active', 'Out of Stock', 'Discontinued'])
        
        # בונוס לדרישת המרצה: שדות NULL אקראיים (30% מהמוצרים ללא תכונות נוספות)
        attr_dict = {"material": "cotton"}
        extra_attr = f"'{json.dumps(attr_dict)}'" if random.random() > 0.3 else "NULL"
        
        supplier_id = random.randint(1, 500)
        season_id = random.randint(1, 4)
        category_id = random.randint(1, 6)
        
        file.write(f"INSERT INTO Product (product_name, brand, target_audience, base_price, product_status, extra_attributes, supplier_id, season_id, category_id) VALUES ('{name}', '{brand}', '{audience}', {price}, '{status}', {extra_attr}, {supplier_id}, {season_id}, {category_id});\n")

    # השהייה לשמירה על המעבד (דרישת מרצה)
    time.sleep(0.5)

    # ---------------------------------------------------------
    # 2. ייצור 600 רשומות מלאי (Inventory)
    # ---------------------------------------------------------
    print("Generating Inventory...")
    file.write("\n-- מילוי טבלת מלאי (600 רשומות)\n")
    for i in range(1, 601):
        qty = random.randint(0, 100)
        color = f"'{random.choice(['Red', 'Blue', 'Black', 'White', 'Green'])}'" if random.random() > 0.2 else "NULL" # 20% NULL
        size = f"'{random.choice(['S', 'M', 'L', 'XL'])}'" if random.random() > 0.1 else "NULL"
        shelf = f"Shelf-{random.choice(['A', 'B', 'C'])}-{random.randint(1, 20)}"
        min_stock = random.randint(5, 20)
        restock_date = random_date().strftime('%Y-%m-%d')
        branch_id = random.randint(1, 500)
        product_id = random.randint(1, 500)
        
        file.write(f"INSERT INTO Inventory (quantity_in_stock, color, size, shelf_location, min_stock_level, last_restock_date, branch_id, product_id) VALUES ({qty}, {color}, {size}, '{shelf}', {min_stock}, '{restock_date}', {branch_id}, {product_id});\n")

    time.sleep(0.5)

    # ---------------------------------------------------------
    # 3. ייצור 20,000 מכירות (Sale) בבאצ'ים של 1000
    # ---------------------------------------------------------
    print("Generating 20,000 Sales...")
    file.write("\n-- מילוי טבלת מכירות (20,000 רשומות)\n")
    
    for batch in range(20): # 20 מנות של 1000
        for i in range(1, 1001):
            s_date = random_date(2022, 2024).strftime('%Y-%m-%d')
            total = round(random.uniform(50.0, 1500.0), 2)
            status = random.choice(['Completed', 'Pending', 'Refunded'])
            receipt = f"REC-{batch}-{i}-{random.randint(1000,9999)}"
            customer_id = random.randint(1, 500)
            employee_id = random.randint(1, 500)
            branch_id = random.randint(1, 500)
            payment_id = random.randint(1, 4)
            
            file.write(f"INSERT INTO Sale (sale_date, total_amount, sale_status, receipt_number, customer_id, employee_id, branch_id, payment_method_id) VALUES ('{s_date}', {total}, '{status}', '{receipt}', {customer_id}, {employee_id}, {branch_id}, {payment_id});\n")
        
        # השהייה קטנה בין כל מנה (Batch) לשמירה על המעבד
        time.sleep(0.1)

    # ---------------------------------------------------------
    # 4. ייצור 25,000 פריטי מכירה (Sale_Inventory)
    # ---------------------------------------------------------
    print("Generating 25,000 Sale Items...")
    file.write("\n-- מילוי טבלת פריטי מכירה (25,000 רשומות)\n")
    
    # שימוש בסט (Set) כדי להבטיח שלא יהיו כפילויות של מפתח ראשי מורכב (sale_id, inventory_id)
    unique_pairs = set()
    while len(unique_pairs) < 25000:
        s_id = random.randint(1, 20000)
        inv_id = random.randint(1, 600)
        unique_pairs.add((s_id, inv_id))

    count = 0
    for s_id, inv_id in unique_pairs:
        qty = random.randint(1, 5)
        unit_price = round(random.uniform(20.0, 300.0), 2)
        
        # 40% מהפריטים יימכרו ללא הנחה (NULL)
        discount = round(random.uniform(5.0, 30.0), 2) if random.random() > 0.4 else "NULL"
        
        final_price = unit_price * qty
        if discount != "NULL":
            final_price = final_price * (1 - (discount / 100))
        final_price = round(final_price, 2)
            
        item_status = random.choice(['Sold', 'Returned'])
        
        file.write(f"INSERT INTO Sale_Inventory (sale_id, inventory_id, quantity, unit_price, discount_percent, final_price, item_status) VALUES ({s_id}, {inv_id}, {qty}, {unit_price}, {discount}, {final_price}, '{item_status}');\n")
        
        count += 1
        if count % 1000 == 0:
            time.sleep(0.1) # הפסקה כל 1000 שורות

print("Done! File 'insert_big_data.sql' created successfully.")