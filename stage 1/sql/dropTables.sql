-- =========================================
-- dropTables.sql
-- Drops all tables in correct order (PostgreSQL)
-- =========================================

DROP TABLE IF EXISTS Sale_Inventory;

DROP TABLE IF EXISTS Sale;
DROP TABLE IF EXISTS Inventory;

DROP TABLE IF EXISTS Product;
DROP TABLE IF EXISTS Employee;
DROP TABLE IF EXISTS Customer;
DROP TABLE IF EXISTS Branch;
DROP TABLE IF EXISTS Supplier;

DROP TABLE IF EXISTS PaymentMethod;
DROP TABLE IF EXISTS Category;
DROP TABLE IF EXISTS Season;
DROP TABLE IF EXISTS City;
