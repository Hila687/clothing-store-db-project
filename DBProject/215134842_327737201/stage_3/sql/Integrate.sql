-- =========================
-- STEP 1: LOOKUP TABLES
-- =========================

CREATE TABLE IF NOT EXISTS strategy_type (
    strategy_id INT PRIMARY KEY,
    strategy_name VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS campaign_status (
    status_id INT PRIMARY KEY,
    status_name VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS loyalty_level (
    loyalty_id INT PRIMARY KEY,
    level_name VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS platform_category (
    category_id INT PRIMARY KEY,
    category_name VARCHAR(255) NOT NULL
);

-- =========================
-- STEP 2: MAIN NEW TABLES
-- =========================

CREATE TABLE IF NOT EXISTS marketing_management (
    director_id INT PRIMARY KEY,
    director_name VARCHAR(255) NOT NULL,
    head_office VARCHAR(255),
    employee_count INT,
    annual_budget NUMERIC(15,2),
    strategy_id INT,
    
    CONSTRAINT fk_strategy
        FOREIGN KEY (strategy_id)
        REFERENCES strategy_type(strategy_id)
);

CREATE TABLE IF NOT EXISTS advertising_campaign (
    campaign_id INT PRIMARY KEY,
    director_id INT,
    campaign_name VARCHAR(255),
    start_date DATE,
    end_date DATE,
    budget NUMERIC(15,2),
    status_id INT,

    CONSTRAINT fk_campaign_director
        FOREIGN KEY (director_id)
        REFERENCES marketing_management(director_id),

    CONSTRAINT fk_campaign_status
        FOREIGN KEY (status_id)
        REFERENCES campaign_status(status_id)
);

-- =========================
-- STEP 3: ADDITIONAL MAIN TABLES
-- =========================

CREATE TABLE IF NOT EXISTS advertising_platform (
    platform_id INT PRIMARY KEY,
    campaign_id INT,
    platform_name VARCHAR(255),
    price INT,
    audience_reach INT,
    category_id INT,

    CONSTRAINT fk_platform_campaign
        FOREIGN KEY (campaign_id)
        REFERENCES advertising_campaign(campaign_id),

    CONSTRAINT fk_platform_category
        FOREIGN KEY (category_id)
        REFERENCES platform_category(category_id)
);

CREATE TABLE IF NOT EXISTS promotion (
    promo_id INT PRIMARY KEY,
    campaign_id INT,
    promo_name VARCHAR(255),
    discount_percent INT,
    valid_from DATE,
    valid_to DATE,

    CONSTRAINT fk_promotion_campaign
        FOREIGN KEY (campaign_id)
        REFERENCES advertising_campaign(campaign_id)
);

-- =========================
-- STEP 4: RELATION TABLES
-- =========================

CREATE TABLE IF NOT EXISTS campaign_branch (
    campaign_id INT,
    branch_id INT,

    PRIMARY KEY (campaign_id, branch_id),

    CONSTRAINT fk_cb_campaign
        FOREIGN KEY (campaign_id)
        REFERENCES advertising_campaign(campaign_id),

    CONSTRAINT fk_cb_branch
        FOREIGN KEY (branch_id)
        REFERENCES branch(branch_id)
);

CREATE TABLE IF NOT EXISTS campaign_customer (
    campaign_id INT,
    customer_id INT,

    PRIMARY KEY (campaign_id, customer_id),

    CONSTRAINT fk_cc_campaign
        FOREIGN KEY (campaign_id)
        REFERENCES advertising_campaign(campaign_id),

    CONSTRAINT fk_cc_customer
        FOREIGN KEY (customer_id)
        REFERENCES customer(customer_id)
);

CREATE TABLE IF NOT EXISTS promotion_product (
    promo_id INT,
    product_id INT,

    PRIMARY KEY (promo_id, product_id),

    CONSTRAINT fk_pp_promotion
        FOREIGN KEY (promo_id)
        REFERENCES promotion(promo_id),

    CONSTRAINT fk_pp_product
        FOREIGN KEY (product_id)
        REFERENCES product(product_id)
);

-- =========================
-- STEP 5: ALTER EXISTING TABLES
-- =========================

-- CUSTOMER

ALTER TABLE customer
ADD COLUMN IF NOT EXISTS date_of_birth DATE;

ALTER TABLE customer
ADD COLUMN IF NOT EXISTS points_balance INT;

ALTER TABLE customer
ADD COLUMN IF NOT EXISTS loyalty_id INT;

ALTER TABLE customer
ADD CONSTRAINT fk_customer_loyalty
FOREIGN KEY (loyalty_id)
REFERENCES loyalty_level(loyalty_id);

-- BRANCH

ALTER TABLE branch
ADD COLUMN IF NOT EXISTS manager_name VARCHAR(255);

ALTER TABLE branch
ADD COLUMN IF NOT EXISTS opening_hours VARCHAR(255);

-- SALE

ALTER TABLE sale
ADD COLUMN IF NOT EXISTS campaign_id INT;

ALTER TABLE sale
ADD COLUMN IF NOT EXISTS promo_id INT;

ALTER TABLE sale
ADD CONSTRAINT fk_sale_campaign
FOREIGN KEY (campaign_id)
REFERENCES advertising_campaign(campaign_id);

ALTER TABLE sale
ADD CONSTRAINT fk_sale_promotion
FOREIGN KEY (promo_id)
REFERENCES promotion(promo_id);

-- =========================
-- STEP 6: INSERT DATA FROM STAGING TABLES
-- =========================

INSERT INTO strategy_type (strategy_id, strategy_name)
SELECT strategy_id, strategy_name
FROM stg_strategy_types
ON CONFLICT (strategy_id) DO NOTHING;

INSERT INTO campaign_status (status_id, status_name)
SELECT status_id, status_name
FROM stg_campaign_status
ON CONFLICT (status_id) DO NOTHING;

INSERT INTO loyalty_level (loyalty_id, level_name)
SELECT loyalty_id, level_name
FROM stg_loyalty_levels
ON CONFLICT (loyalty_id) DO NOTHING;

INSERT INTO platform_category (category_id, category_name)
SELECT category_id, category_name
FROM stg_platform_categories
ON CONFLICT (category_id) DO NOTHING;

INSERT INTO marketing_management (
    director_id,
    director_name,
    head_office,
    employee_count,
    annual_budget,
    strategy_id
)
SELECT
    director_id,
    director_name,
    head_office,
    employee_count,
    annual_budget,
    strategy_type_id
FROM stg_marketing_management
ON CONFLICT (director_id) DO NOTHING;

INSERT INTO advertising_campaign (
    campaign_id,
    director_id,
    campaign_name,
    start_date,
    end_date,
    budget,
    status_id
)
SELECT
    campaign_id,
    director_id,
    campaign_name,
    start_date,
    end_date,
    budget,
    status_id
FROM stg_advertising_campaigns
ON CONFLICT (campaign_id) DO NOTHING;

-- Customers from the received DB
INSERT INTO customer (
    customer_id,
    first_name,
    last_name,
    email,
    date_of_birth,
    points_balance,
    loyalty_id
)
SELECT
    customer_id + 100000,
    name,
    '',
    email,
    date_of_birth,
    points_balance,
    loyalty_level_id
FROM stg_customers
ON CONFLICT (customer_id) DO NOTHING;


-- Products from the received DB
INSERT INTO product (
    product_id,
    product_name,
    base_price,
    category_id
)
SELECT
    product_id + 100000,
    product_name,
    price,
    NULL
FROM stg_products
ON CONFLICT (product_id) DO NOTHING;


-- Branches from the received DB
INSERT INTO branch (
    branch_id,
    branch_name,
    manager_name,
    opening_hours,
    city_id
)
SELECT
    branch_id + 100000,
    branch_name,
    manager_name,
    opening_hours,
    NULL
FROM stg_branches
ON CONFLICT (branch_id) DO NOTHING;