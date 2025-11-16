CREATE OR ALTER PROCEDURE bronze.load_bronze AS 
BEGIN
	TRUNCATE TABLE bronze.crm_cust_info;
	BULK INSERT bronze.crm_cust_info   --Bulk inserting data from original csv file
	FROM 'E:\30SqlAdv\Data Warehouse project\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
	WITH (                                        ----Now the sql dont know from where the data start, so this with functions help with that
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',                         --File seperated , like how the value are seperate
	TABLOCK
	);



	TRUNCATE TABLE bronze.crm_prd_info;
	BULK INSERT bronze.crm_prd_info
	FROM 'E:\30SqlAdv\Data Warehouse project\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
	WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
	);


	TRUNCATE TABLE bronze.crm_sales_details;
	BULK INSERT bronze.crm_sales_details
	FROM 'E:\30SqlAdv\Data Warehouse project\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
	WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
	);


	TRUNCATE TABLE bronze.erp_cust_az12;
	BULK INSERT bronze.erp_cust_az12
	FROM 'E:\30SqlAdv\Data Warehouse project\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
	WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
	);


	TRUNCATE TABLE bronze.erp_loc_a101;
	BULK INSERT bronze.erp_loc_a101
	FROM 'E:\30SqlAdv\Data Warehouse project\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
	WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
	);


	TRUNCATE TABLE bronze.erp_px_cat_g1v2;
	BULK INSERT bronze.erp_px_cat_g1v2
	FROM 'E:\30SqlAdv\Data Warehouse project\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
	WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
	);

END
