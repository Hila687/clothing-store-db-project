# Database Mini-Project: Retail Sales & Inventory Management 🛒👗
## Module: Sales & Retail Operations
**Mini-Project in Databases** | [cite_start]Jerusalem College of Technology (JCT) [cite: 31, 32]

---

## 👥 Project Contributors
* **Hila Miller** 
* **Hila Rosental** 
* [cite_start]**Target Organization:** Retail Clothing Chain [cite: 37]
* [cite_start]**Assigned Unit:** Sales, Inventory, Branches, and Employees [cite: 1]

---

## 📋 Table of Contents
1. [Introduction & System Description](#1-introduction--system-description)
2. [UI Mockups (AI-Generated)](#2-ui-mockups-ai-generated)
3. [Database Design (ERD & DSD)](#3-database-design-erd--dsd)
4. [Normalization & Functional Dependencies](#4-normalization--functional-dependencies)
5. [Implementation & Constraints](#5-implementation--constraints)
6. [Data Population](#6-data-population)
7. [Backup & Recovery](#7-backup--recovery)

---

## 1. Introduction & System Description
[cite_start]This project involves the design and implementation of a comprehensive database for a retail clothing store[cite: 36, 86]. [cite_start]The system focuses on the **Sales and Retail** module, handling the core business logic of a multi-branch organization[cite: 37, 1].

[cite_start]**Key Functionalities:** [cite: 26, 27]
* **Inventory Tracking:** Managing stock levels across multiple branches based on product model, size, and color.
* **Sales Processing:** Recording transactions, linking them to specific customers and sales associates.
* **Personnel Management:** Tracking employee records, roles, and branch assignments.
* **Supplier Relations:** Managing inventory sourcing and supplier contracts.

---

## 2. UI Mockups (AI-Generated)
> [cite_start]**Status:** ⏳ *Waiting for AI Studio Screenshots* 

[cite_start]The system interface was drafted using **Google AI Studio** to define the requirements and user flow.
* **Screen 1: POS Interface** - For processing customer transactions.
* **Screen 2: Inventory Dashboard** - For monitoring stock levels and reorder points.
* **Screen 3: Employee Management** - For tracking sales targets and branch staff.

---

## 3. Database Design (ERD & DSD)
### Entity Relationship Diagram (ERD)
> [cite_start]**Status:** ⏳ *Awaiting ERDPlus Export* [cite: 5, 99]

* [cite_start]**Design Choice:** The system includes 8 core entities (Customer, Employee, Branch, Supplier, Product, Inventory, Sale, SaleItem) to ensure a high-level project scope[cite: 6, 7].
* [cite_start]**Attributes:** Each entity contains at least 5 attributes to maintain sufficient detail[cite: 101].

### Data Structure Diagram (DSD)
> [cite_start]**Status:** ⏳ *Awaiting PostgreSQL Schema Export* [cite: 8, 115]

---

## 4. Normalization & Functional Dependencies
[cite_start]The database is normalized to **3NF/BCNF** to prevent data redundancy[cite: 9, 111].

[cite_start]**Key Functional Dependencies:** [cite: 111]
* `customer_id` → `first_name`, `last_name`, `email`, `phone_number`
* `product_id` → `product_name`, `brand`, `base_price`
* `branch_id` → `branch_name`, `city`, `address`

---

## 5. Implementation & Constraints
[cite_start]The physical database is implemented using **PostgreSQL**[cite: 41, 113].

**Data Types & Standards:**
* [cite_start]`VARCHAR2(size)` for strings and `DATE` for significant timestamps (e.g., `sale_date`, `hire_date`)[cite: 11, 103].
* [cite_start]**JSON Fields:** Implemented for semi-structured data like `technical_specs` in Products and `promotion_details` in Sales[cite: 103].
* [cite_start]**Integrity:** Constraints (`NOT NULL`, `UNIQUE`, `CHECK`) are applied to ensure data matches reality[cite: 12, 110].

---

## 6. Data Population
> [cite_start]**Status:** ⏳ *Awaiting Screenshots of Scripts/Tools* [cite: 29, 131]

[cite_start]We used three methods to populate the database with a total of **500+ records per table** and **20,000+ records** in major tables[cite: 16, 122].
1.  [cite_start]**Programming (Python):** For high-volume generation of Sales and Inventory data[cite: 16, 22].
2.  [cite_start]**External Tools (Mockaroo/Generatedata):** For realistic Customer and Employee profiles[cite: 16, 23].
3.  [cite_start]**Data Import (CSV):** For static configurations like Branches and Suppliers[cite: 16, 21].

---

## 7. Backup & Recovery
> [cite_start]**Status:** ⏳ *Awaiting Backup Log/Screenshot* [cite: 29]

* [cite_start]**Method:** Full database backup performed via `pgAdmin`[cite: 17, 125].
* [cite_start]**Verification:** Restored the `backup_[DATE].sql` file on a clean environment to ensure zero data loss[cite: 19, 143].

---
[cite_start]*This README is updated as part of Step A of the Database Mini-Project.* [cite: 26]
