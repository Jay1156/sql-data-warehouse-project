-- 1) Create or replace customer dimension view
CREATE VIEW gold.dim_customers AS 
SELECT 
ROW_NUMBER() OVER(ORDER BY cust_id) AS customer_Key,
ci.cust_id AS customer_Id,
ci.cst_key AS customer_number,
ci.cst_firstname AS first_name,
ci.cst_lastname AS last_name,
ci.cst_marital_status AS marital_status,
CASE WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr
ELSE COALESCE(ea.gen, 'n/a')
END AS gender,
ea.bdate AS birth_date,
ela.cntry AS country
FROM silver.crm_cust_info AS ci
LEFT JOIN silver.erp_cust_az12 AS ea
ON ci.cst_key = ea.cid
LEFT JOIN silver.erp_loc_a101 AS ela
ON ci.cst_key = ela.cid



-- 2) Quick distinct check of gender resolution logic
SELECT DISTINCT
ci.cst_gndr,
ea.gen,
CASE WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr
ELSE COALESCE(ea.gen, 'n/a')
END AS new_gen
FROM silver.crm_cust_info AS ci
LEFT JOIN silver.erp_cust_az12 AS ea
ON ci.cst_key = ea.cid
LEFT JOIN silver.erp_loc_a101 AS ela
ON ci.cst_key = ela.cid
ORDER BY ci.cst_gndr,ea.gen



-- 3) Create or replace product dimension view
CREATE VIEW gold.dim_products AS
SELECT 
ROW_NUMBER() OVER(ORDER BY cp.prd_start_dt, cp.prd_key) AS product_key,
cp.prd_id AS product_Id,
cp.prd_key AS product_number,
cp.prd_nm AS product_name,
cp.cat_id AS category_Id,
ep.cat AS Category,
ep.subcat AS sub_category,
ep.maintenance,
cp.prd_cost AS product_cost,
cp.prd_line AS product_line,
cp.prd_start_dt AS product_start_date,
cp.prd_end_dt AS product_end_date
FROM silver.crm_prd_info AS cp
LEFT JOIN silver.erp_px_cat_g1v2 AS ep
ON cp.cat_id = ep.id





