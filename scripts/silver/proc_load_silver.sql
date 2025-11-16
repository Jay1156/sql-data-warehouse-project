--Finding the duplicates in bronze.crm_cust_info
--There should be no nulls at least in primary key

SELECT 
COUNT(*),
cust_id
FROM bronze.crm_cust_info
GROUP BY cust_id
HAVING COUNT(*) > 1


-- looking at the cust_id we would always want data which is recent one 
TRUNCATE TABLE silver.crm_cust_info
INSERT INTO silver.crm_cust_info (
cust_id,
cst_key,
cst_firstname,
cst_lastname,
cst_marital_status,
cst_gndr,
cst_create_date)

SELECT 
cust_id,
cst_key,
TRIM(cst_firstname) AS cst_firstname,
TRIM(cst_lastname) AS cst_lastname,
CASE WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
	WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
	ELSE 'n/a'
END cst_marital_status,
CASE WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
	WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
	ELSE 'n/a'
END cst_gndr,
cst_create_date
FROM(
SELECT
* ,
ROW_NUMBER() OVER(PARTITION BY cust_id ORDER BY cst_create_date DESC) AS Flag_List
FROM bronze.crm_cust_info)t
WHERE Flag_List = 1


ALTER TABLE silver.crm_prd_info
ADD cat_id VARCHAR(50);  -- adjust length/type as you prefer
GO

ALTER TABLE silver.crm_prd_info
ADD cat_id VARCHAR(50);  
GO

TRUNCATE TABLE silver.crm_prd_info
INSERT INTO silver.crm_prd_info (
prd_id,
prd_key,
cat_id,
prd_nm,
prd_cost,
prd_line,
prd_start_dt,
prd_end_dt
)
SELECT
prd_id,
prd_key,
REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id,
prd_nm,
ISNULL(prd_cost, 0) AS prd_cost,
CASE WHEN UPPER(prd_line) = 'M' THEN 'Mountain'
	WHEN UPPER(prd_line) = 'R' THEN 'Road'
	WHEN UPPER(prd_line) = 'S' THEN 'Other Sales'
	WHEN UPPER(prd_line) = 'T' THEN 'Tour'
	ELSE 'n/a'
END AS prd_line,
CAST(prd_start_dt AS DATE) AS prd_start_dt,
CAST(LEAD(prd_start_dt) OVER(PARTITION BY prd_key ORDER BY prd_start_dt) - 1AS DATE) AS prd_end_dt
FROM bronze.crm_prd_info;
GO

TRUNCATE TABLE silver.crm_sales_details
INSERT INTO silver.crm_sales_details(
sls_ord_num,
sls_prd_key,
sls_cust_id,
sls_order_dt,
sls_ship_dt,
sls_due_dt,
sls_sales,
sls
SELECT 
sls_ord_num,
sls_prd_key,
sls_cust_id,
CASE WHEN sls_order_dt = 0 OR LEN(sls_order_dt) != 8 THEN NULL
	ELSE CAST(CAST(sls_order_dt AS VARCHAR) AS DATE)
END sls_order_dt,
CASE WHEN sls_ship_dt = 0 OR LEN(sls_ship_dt) != 8 THEN NULL
	ELSE CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE)
END sls_ship_dt,
CASE WHEN sls_due_dt = 0 OR LEN(sls_due_dt) != 8 THEN NULL
	ELSE CAST(CAST(sls_due_dt AS VARCHAR) AS DATE)
END sls_due_dt,

CASE WHEN sls_sales <= 0 OR sls_sales = 0 OR sls_sales IS NULL OR sls_sales != sls_price * sls_quantity
	THEN sls_price * sls_quantity
ELSE sls_sales 
END AS sls_sales,

CASE WHEN sls_price IS NULL OR sls_price < = 0
	THEN sls_sales / NULLIF(sls_quantity, 0)
ELSE sls_price
END AS sls_price
FROM bronze.crm_sales_details


-- For bronze.erp_cust_az12
TRUNCATE TABLE silver.erp_cust_az12
INSERT INTO silver.erp_cust_az12(
cid,
bdate,
gen)
SELECT 
CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LEN(cid)) 
	ELSE cid
END AS cid,
CASE WHEN bdate > GETDATE() THEN NULL
	ELSE bdate
END AS bdate,
CASE WHEN UPPER(TRIM(gen)) = 'M' THEN 'Male'
	WHEN UPPER(TRIM(gen)) = 'F' THEN 'Female'
ELSE gen
END AS gen
FROM bronze.erp_cust_az12

TRUNCATE TABLE silver.erp_loc_a101
INSERT INTO silver.erp_loc_a101(
cid,
cntry)
SELECT 
REPLACE(cid, '-','') AS cid,
CASE WHEN TRIM(cntry) = 'USA' THEN REPLACE(cntry, 'USA', 'United State of America')
	WHEN TRIM(cntry) = 'US' THEN REPLACE(cntry, 'US', 'United State')
	WHEN TRIM(cntry) = 'DE' THEN REPLACE(cntry, 'DE', 'Germany')
	WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'n/a' 
ELSE TRIM(cntry)
END AS cntry
FROM bronze.erp_loc_a101

TRUNCATE TABLE silver.erp_px_cat_g1v2
INSERT INTO silver.erp_px_cat_g1v2 (id, cat, subcat, maintenance)
SELECT * FROM bronze.erp_px_cat_g1v2
