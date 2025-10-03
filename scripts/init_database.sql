-- ===============================================
-- STEP 1: Create Database for Data Warehouse
-- ===============================================
CREATE DATABASE DataWarehouse;
GO

-- Switch context to the newly created database
USE DataWarehouse;
GO

-- ===============================================
-- STEP 2: Create Schemas for Layered Architecture
-- ===============================================

-- Bronze Layer:
-- Raw data storage (directly ingested from source systems, minimal processing)
CREATE SCHEMA bronze;
GO

-- Silver Layer:
-- Cleaned, transformed, and standardized data
-- Applied business rules, joins, type conversions, etc.
CREATE SCHEMA silver;
GO

-- Gold Layer:
-- Final curated data for analytics and reporting
-- Optimized for BI tools (Power BI, Tableau, etc.)
CREATE SCHEMA gold;
GO

-- ===============================================
-- Purpose of Each Layer
-- Bronze → Stores raw, unprocessed data
-- Silver → Stores cleansed & business-ready data
-- Gold   → Stores aggregated, analytics-ready data
-- ===============================================
