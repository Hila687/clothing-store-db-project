# Database Mini Project – Clothing Store Management System

Mini-project for the **Database Systems course**.

This project designs and implements a database system for managing a clothing retail chain, including sales, inventory, products, customers, employees, suppliers, and branches.

The repository documents all stages of the system analysis, database design, implementation, data population, and backup process.

---

# Project Team

- Hila Miller
- Hila Rosental

Institution: Jerusalem College of Technology (JCT)

---

# Table of Contents

## Stage 1 – Information System Design
1. System Analysis (Top-Down)
2. UI Mockups
3. ERD – Entity Relationship Diagram
4. Relational Schema & DSD
5. Normalization & Functional Dependencies
6. Database Implementation
7. Data Population
8. Backup & Recovery

(Future stages will be added later)

---

# Stage 1 – Information System Design

## 1. System Analysis (Top-Down)

This section describes the system requirements and defines the system boundaries using a top-down analysis approach.

The system is designed to manage a clothing retail chain, including inventory management, sales tracking, customer management, employee operations, supplier relations, and branch activity.
---

## 2. UI Mockups (Google AI Studio)

(To be completed)

Planned system screens will be designed using Google AI Studio in order to demonstrate the future system interface and user flow.

Screenshots will be added in this section.

---

## 3. ERD – Entity Relationship Diagram

The database design was created using **ERDPlus**.

The ERD models the main entities of a clothing retail management system and the relationships between them.

Main entities include:

- Branch
- Employee
- Customer
- Supplier
- Product
- Inventory
- Sale
- SaleItem

Each entity contains at least five attributes according to the project requirements.

Relationships include:

- Branch employs Employees
- Branch records Sales
- Branch stores Inventory
- Supplier supplies Products
- Product appears in Inventory
- Customer makes Sales
- Employee handles Sales
- Sale contains SaleItems
- SaleItem references Inventory

Cardinality constraints were defined for all relationships.

### ERD Diagram

![ERD Diagram](images/erd_stage1_final.png)
---

## 4. Relational Schema & DSD

The ERD was translated into a relational schema and implemented in PostgreSQL.

Each entity and relationship was mapped into tables according to standard database design principles.

The following diagram presents the database schema (DSD) as implemented in pgAdmin, including all tables, primary keys, and foreign key relationships:

![Database Schema](images/dsd_schema.png)

---

## 5. Normalization & Functional Dependencies

All relations were analyzed and normalized to at least Third Normal Form (3NF).

Functional dependencies were identified for each table, and redundancy was minimized.

The schema ensures data consistency, eliminates update anomalies, and maintains logical data integrity.

---

## 6. Database Implementation

The database was implemented using PostgreSQL through pgAdmin.

The schema was created using the file:

- createTables.sql

Additional supporting scripts include:

- dropTables.sql – removes all tables in the correct dependency order
- selectAll.sql – used to retrieve and validate data from all tables

---

## 7. Data Population

The database was populated using a combination of three different methods, as required by the project instructions. Each method was used for different types of data based on its characteristics and advantages.

---

### 1. CSV / Excel Import

Several tables were populated using manually created CSV files.

These files were prepared using Excel and imported into PostgreSQL via pgAdmin.

Tables populated using this method:

- City  
- Season  
- Category  
- PaymentMethod  
- Branch  

This approach allowed precise control over the data and ensured consistency for structured and relatively small datasets.

---

### 2. External Data Generation (Mockaroo)

Mockaroo was used to generate realistic synthetic data for larger and more dynamic tables.

Tables populated using Mockaroo:

- Customer  
- Supplier  
- Employee  

Mockaroo enabled the creation of large datasets with realistic attributes such as names, emails, phone numbers, and dates.

Additionally, some fields were configured to include random NULL values, as required by the project guidelines.

---

### 3. Programmatic Data Generation (Python)

A Python script was used to generate and insert data programmatically for additional tables.

This method was used to efficiently create larger datasets and simulate realistic relationships between entities.

The script allowed flexibility in controlling data volume and structure, and was particularly useful for testing scalability and data integrity.

---

### Data Volume & Characteristics

- Multiple tables contain at least 500 records, as required  
- Some tables contain significantly larger datasets (20,000 rows)  
- Random NULL values were included in optional fields  
- Data was generated to maintain referential integrity between tables  

---

## 8. Backup & Recovery

A full database backup was created using pgAdmin.

The backup includes both structure and data.

To verify its correctness, the backup was restored into a new database instance.

The restoration process successfully recreated all tables and data, confirming the validity of the backup.

Backup file:
- backup_2026-03-19.backup
---

## How to Run the Project

1. Run createTables.sql
2. Run insertTables.sql
3. Use selectAll.sql to verify the data
4. Alternatively, restore the database using the backup file

---

# Stage 2 – (To be added later)

This section will be added when Stage 2 of the project begins.
