-- =========================================
-- createTables.sql
-- Clothing Store Database
-- Generated from the current ERD structure
-- PostgreSQL / pgAdmin
-- =========================================

CREATE TABLE City (
    city_id SERIAL PRIMARY KEY,
    city_name VARCHAR(100) NOT NULL
);

CREATE TABLE Season (
    season_id SERIAL PRIMARY KEY,
    season_name VARCHAR(50) NOT NULL
);

CREATE TABLE Category (
    category_id SERIAL PRIMARY KEY,
    category_name VARCHAR(50) NOT NULL
);

CREATE TABLE PaymentMethod (
    payment_method_id SERIAL PRIMARY KEY,
    payment_method_name VARCHAR(50) NOT NULL
);

CREATE TABLE Supplier (
    supplier_id SERIAL PRIMARY KEY,
    supplier_name VARCHAR(100) NOT NULL,
    contact_person VARCHAR(100),
    phone_number VARCHAR(20),
    email VARCHAR(100),
    supplier_status VARCHAR(50),
    contract_start_date DATE,
    city_id INT,
    CONSTRAINT fk_supplier_city
        FOREIGN KEY (city_id) REFERENCES City(city_id)
);

CREATE TABLE Branch (
    branch_id SERIAL PRIMARY KEY,
    branch_name VARCHAR(100) NOT NULL,
    branch_status VARCHAR(50),
    phone_number VARCHAR(20),
    opening_date DATE,
    city_id INT,
    CONSTRAINT fk_branch_city
        FOREIGN KEY (city_id) REFERENCES City(city_id)
);

CREATE TABLE Customer (
    customer_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    phone_number VARCHAR(20),
    email VARCHAR(100),
    join_date DATE,
    customer_status VARCHAR(50),
    preferences JSON,
    city_id INT,
    CONSTRAINT fk_customer_city
        FOREIGN KEY (city_id) REFERENCES City(city_id)
);

CREATE TABLE Employee (
    employee_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    phone_number VARCHAR(20),
    email VARCHAR(100),
    salary NUMERIC(10,2),
    role VARCHAR(50),
    hire_date DATE,
    branch_id INT,
    CONSTRAINT fk_employee_branch
        FOREIGN KEY (branch_id) REFERENCES Branch(branch_id)
);

CREATE TABLE Product (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    brand VARCHAR(50),
    target_audience VARCHAR(50),
    base_price NUMERIC(10,2),
    product_status VARCHAR(50),
    extra_attributes JSON,
    supplier_id INT,
    season_id INT,
    category_id INT,
    CONSTRAINT fk_product_supplier
        FOREIGN KEY (supplier_id) REFERENCES Supplier(supplier_id),
    CONSTRAINT fk_product_season
        FOREIGN KEY (season_id) REFERENCES Season(season_id),
    CONSTRAINT fk_product_category
        FOREIGN KEY (category_id) REFERENCES Category(category_id)
);

CREATE TABLE Inventory (
    inventory_id SERIAL PRIMARY KEY,
    quantity_in_stock INT,
    color VARCHAR(50),
    size VARCHAR(20),
    shelf_location VARCHAR(50),
    min_stock_level INT,
    last_restock_date DATE,
    branch_id INT,
    product_id INT,
    CONSTRAINT fk_inventory_branch
        FOREIGN KEY (branch_id) REFERENCES Branch(branch_id),
    CONSTRAINT fk_inventory_product
        FOREIGN KEY (product_id) REFERENCES Product(product_id)
);

CREATE TABLE Sale (
    sale_id SERIAL PRIMARY KEY,
    sale_date DATE,
    total_amount NUMERIC(10,2),
    sale_status VARCHAR(50),
    receipt_number VARCHAR(50),
    customer_id INT,
    employee_id INT,
    branch_id INT,
    payment_method_id INT,
    CONSTRAINT fk_sale_customer
        FOREIGN KEY (customer_id) REFERENCES Customer(customer_id),
    CONSTRAINT fk_sale_employee
        FOREIGN KEY (employee_id) REFERENCES Employee(employee_id),
    CONSTRAINT fk_sale_branch
        FOREIGN KEY (branch_id) REFERENCES Branch(branch_id),
    CONSTRAINT fk_sale_payment_method
        FOREIGN KEY (payment_method_id) REFERENCES PaymentMethod(payment_method_id)
);

CREATE TABLE Sale_Inventory (
    sale_id INT,
    inventory_id INT,
    quantity INT NOT NULL,
    unit_price NUMERIC(10,2),
    discount_percent NUMERIC(5,2),
    final_price NUMERIC(10,2),
    item_status VARCHAR(50),
    PRIMARY KEY (sale_id, inventory_id),
    CONSTRAINT fk_sale_inventory_sale
        FOREIGN KEY (sale_id) REFERENCES Sale(sale_id),
    CONSTRAINT fk_sale_inventory_inventory
        FOREIGN KEY (inventory_id) REFERENCES Inventory(inventory_id)
);
