/*
===============================================================================
Stored Procedure: Load Silver Layer (Bronze -> Silver)
===============================================================================
Script Purpose:
    This stored procedure performs the ETL (Extract, Transform, Load) process to 
    populate the 'silver' schema tables from the 'bronze' schema.
	Actions Performed:
		- Truncates Silver tables.
		- Inserts transformed and cleansed data from Bronze into Silver tables.
		
Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC Silver.load_silver;
===============================================================================
*/

CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN
    DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME; 
    BEGIN TRY
        SET @batch_start_time = GETDATE();
        PRINT '================================================';
        PRINT 'Loading Silver Layer';
        PRINT '================================================';

		PRINT '------------------------------------------------';
		PRINT 'Loading CRM Tables';
		PRINT '------------------------------------------------';

		-- Loading silver.crm_cust_info
        SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.crm_cust_info';
		TRUNCATE TABLE [silver].[crm_customer_info];
		PRINT '>> Inserting Data Into: silver.crm_cust_info';
		INSERT INTO [silver].[crm_customer_info] (
			cst_id,
			cst_key,
			cst_first_name,
			cst_last_name,
			cst_marital_status,
			cst_gender,
			cst_create_date
		)

		SELECT
		cst_id,
		cst_key,
		TRIM(cst_first_name) AS cst_first_name,
		TRIM(cst_last_name) AS cst_last_name,
		CASE
			WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
			WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
			ELSE 'N/A'
		END cst_marital_status,

		CASE
			WHEN UPPER(TRIM(cst_gender)) = 'F' THEN 'Female'
			WHEN UPPER(TRIM(cst_gender)) = 'M' THEN 'Male'
			ELSE 'N/A'
		END cst_gender,
		cst_create_date
		FROM 
		(
			SELECT
			*,
			ROW_NUMBER() OVER(PARTITION BY cst_id ORDER BY cst_create_date) as flag_last
			FROM [bronze].[crm_customer_info]
			WHERE cst_id IS NOT NULL
		)T WHERE flag_last = 1

		SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';

		-- Loading silver.crm_prd_info
        INSERT INTO [silver].[crm_product_info]
		(
			prod_id,
			cat_id,
			prod_key,
			prod_name,
			prod_cost,
			prod_line,
			prod_start_dt,
			prod_end_dt
		)
		SELECT 
		prod_id,
		REPLACE(SUBSTRING(prod_key , 1, 5),'-' , '_') AS cat_id,
		SUBSTRING(prod_key , 7, LEN(prod_key)) AS prod_key,
		prod_name,
		ISNULL(prod_cost, 0) AS prod_cost,

		CASE UPPER(TRIM(prod_line))
			WHEN 'M' THEN 'Mountain'
			WHEN 'R' THEN 'Road'
			WHEN 'S' THEN 'Other Sales'
			WHEN 'T' THEN 'Touring'
			ELSE 'N/A'
		END prod_line,
		CAST(prod_start_dt AS DATE) AS prod_start_dt,
		CAST(LEAD(prod_start_dt) OVER (PARTITION BY prod_key ORDER BY prod_start_dt)-1 AS DATE) AS prod_end_date	
		FROM [bronze].[crm_product_info]
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';

        -- Loading crm_sales_details
        SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.crm_sales_details';
		TRUNCATE TABLE silver.crm_sales_details;
		PRINT '>> Inserting Data Into: silver.crm_sales_details';
		INSERT INTO [silver].[crm_sales_details] (
			sls_order_num,
			sls_prod_key,
			sls_customer_id,
			sls_order_dt,
			sls_ship_dt,
			sls_due_dt,
			sls_sales,
			sls_quantity,
			sls_price
		)
		SELECT
		sls_order_num,
		sls_prod_key,
		sls_customer_id,

		CASE 
			WHEN sls_order_dt = 0 OR LEN(sls_order_dt) != 8 THEN NULL
				ELSE CAST(CAST(sls_order_dt AS VARCHAR) AS DATE)
		END AS sls_order_dt,

		CASE 
			WHEN sls_ship_dt = 0 OR LEN(sls_ship_dt) != 8 THEN NULL
				ELSE CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE)
		END AS sls_ship_dt,

		CASE 
			WHEN sls_due_dt = 0 OR LEN(sls_due_dt) != 8 THEN NULL
				ELSE CAST(CAST(sls_due_dt AS VARCHAR) AS DATE)
		END AS sls_due_dt,

		CASE 
			WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity * ABS(sls_price)
				THEN sls_quantity * ABS(sls_price)
			ELSE sls_sales
		END AS sls_sales,

		sls_quantity,

		CASE 
			WHEN sls_price IS NULL OR sls_price <= 0
				THEN sls_sales / NULLIF(sls_quantity , 0)
			ELSE sls_price
		END AS sls_price
		FROM [bronze].[crm_sales_details]
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';

        -- Loading erp_cust_az12
        SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.erp_cust_az12';
		TRUNCATE TABLE [silver].[erp_cusomer_az12];
		PRINT '>> Inserting Data Into: silver.erp_cust_az12';
		INSERT INTO [silver].[erp_cusomer_az12] (
			cust_id,
			birth_date,
			gender
		)
		SELECT
			CASE
				WHEN cust_id LIKE 'NAS%' THEN SUBSTRING(cust_id, 4, LEN(cust_id)) -- Remove 'NAS' prefix if present
				ELSE cust_id
			END AS cust_id, 
			CASE
				WHEN birth_date > GETDATE() THEN NULL
				ELSE birth_date
			END AS birth_date, -- Set future birthdates to NULL
			CASE
				WHEN UPPER(TRIM(gender)) IN ('F', 'FEMALE') THEN 'Female'
				WHEN UPPER(TRIM(gender)) IN ('M', 'MALE') THEN 'Male'
				ELSE 'N/A'
			END AS gender -- Normalize gender values and handle unknown cases
		FROM [bronze].[erp_cusomer_az12];
	    SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';

		PRINT '------------------------------------------------';
		PRINT 'Loading ERP Tables';
		PRINT '------------------------------------------------';

        -- Loading erp_loc_a101
        SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.erp_loc_a101';
		TRUNCATE TABLE [silver].[erp_loc_a101];
		PRINT '>> Inserting Data Into: silver.erp_loc_a101';
		INSERT INTO silver.erp_loc_a101 (
			cust_id,
			country
		)
		SELECT
			REPLACE(cust_id, '-', '') AS cust_id, 
			CASE
				WHEN TRIM(country) = 'DE' THEN 'Germany'
				WHEN TRIM(country) IN ('US', 'USA') THEN 'United States'
				WHEN TRIM(country) = '' OR country IS NULL THEN 'n/a'
				ELSE TRIM(country)
			END AS country -- Normalize and Handle missing or blank country codes
		FROM [bronze].[erp_loc_a101];
	    SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';
		
		-- Loading erp_px_cat_g1v2
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.erp_px_cat_g1v2';
		TRUNCATE TABLE [silver].[erp_px_cat_g1v2];
		PRINT '>> Inserting Data Into: silver.erp_px_cat_g1v2';
		INSERT INTO [silver].[erp_px_cat_g1v2] (
			id,
			cat,
			sub_cat,
			maintenance
		)
		SELECT
			id,
			cat,
			sub_cat,
			maintenance
		FROM [bronze].[erp_px_cat_g1v2];
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';

		SET @batch_end_time = GETDATE();
		PRINT '=========================================='
		PRINT 'Loading Silver Layer is Completed';
        PRINT '   - Total Load Duration: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
		PRINT '=========================================='
		
	END TRY
	BEGIN CATCH
		PRINT '=========================================='
		PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER'
		PRINT 'Error Message' + ERROR_MESSAGE();
		PRINT 'Error Message' + CAST (ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error Message' + CAST (ERROR_STATE() AS NVARCHAR);
		PRINT '=========================================='
	END CATCH
END