
--Checking for unwanted spaces
SELECT 
cst_firstname,
DATALENGTH(cst_firstname) AS Len_FirstName
FROM bronze.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname)

SELECT
cst_lastname,
DATALENGTH(cst_lastname) AS Len_lastName
FROM bronze.crm_cust_info
WHERE cst_lastname != TRIM(cst_lastname)


--Data Standarization and Consistency
SELECT DISTINCT 
cst_gndr 
FROM bronze.crm_cust_info

SELECT DISTINCT
cst_marital_status
FROM bronze.crm_cust_info


--FOR bronze.crm_prd_info
SELECT 
prd_nm,
DATALENGTH(prd_nm)
FROM bronze.crm_prd_info
WHERE prd_nm != TRIM(prd_nm)


SELECT 
prd_start_dt,
prd_end_dt
FROM bronze.crm_prd_info
WHERE prd_start_dt > prd_end_dt


SELECT
prd_id,
prd_key,
prd_nm,
prd_start_dt,
LEAD(prd_start_dt) OVER(PARTITION BY prd_key ORDER BY prd_start_dt)-1 AS prd_end_dt_test
FROM bronze.crm_prd_info
WHERE prd_key IN ('AC-HE-HL-U509-R', 'AC-HE-HL-U509')


-- For bronze.crm_sales_details
SELECT 
*
FROM bronze.crm_sales_details


SELECT 
sls_quantity,
sls_price,

CASE WHEN sls_sales <= 0 OR sls_sales = 0 OR sls_sales IS NULL OR sls_sales != sls_price * sls_quantity
	THEN sls_price * sls_quantity
ELSE sls_sales 
END AS sls_sales,

CASE WHEN sls_price IS NULL OR sls_price < = 0
	THEN sls_sales / NULLIF(sls_quantity, 0)
ELSE sls_price
END AS sls_price
FROM bronze.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
OR sls_sales <= 0 OR sls_quantity <= 0 OR sls_price <= 0
OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
ORDER BY sls_sales, sls_quantity, sls_price

SELECT DISTINCT gen FROM bronze.erp_cust_az12


SELECT DISTINCT
CASE WHEN TRIM(cntry) = 'USA' THEN REPLACE(cntry, 'USA', 'United State of America')
	WHEN TRIM(cntry) = 'US' THEN REPLACE(cntry, 'US', 'United State')
	WHEN TRIM(cntry) = 'DE' THEN REPLACE(cntry, 'DE', 'Germany')
ELSE TRIM(cntry)
END AS cntry 
FROM bronze.erp_loc_a101

