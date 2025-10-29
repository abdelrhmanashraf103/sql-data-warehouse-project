/*
===============================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===============================================================================
Script Purpose:
    This stored procedure loads data into the 'bronze' schema from external CSV files. 
    It performs the following actions:
    - Truncates the bronze tables before loading data.
    - Uses the `BULK INSERT` command to load data from csv Files to bronze tables.

Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC bronze.load_bronze;
===============================================================================
*/
CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	DECLARE @start_time DATETIME , @end_time DATETIME , @batch_start_time DATETIME , @batch_end_time DATETIME;
	BEGIN TRY
		SET @batch_start_time = GETDATE(); 
		PRINT '============================================';
		PRINT 'lOADING THE BRONZE LAYER';
		PRINT '============================================';

		PRINT '--------------------------------------------';
		PRINT 'lOADING CRM TABLES';
		PRINT '--------------------------------------------';

		SET @start_time = GETDATE();
		PRINT '>> TRUNCATING TABLE : bronze.crm_customer_info';
		TRUNCATE TABLE [bronze].[crm_customer_info]

		PRINT '>> INSERTING DATE INTO : bronze.crm_customer_info';
		BULK INSERT [bronze].[crm_customer_info]
		FROM 'D:\Udemy\Luke\SQL from Zero to Hero\Projects\sql-datawarehouse-project\datasets\source_crm\cust_info.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> LOAD DURATION: ' + CAST(DATEDIFF(SECOND , @start_time , @end_time) AS NVARCHAR) + ' SECONDS';
		PRINT '----------------';

		SET @start_time = GETDATE();
		PRINT '>> TRUNCATING TABLE : bronze.crm_product_info';
		TRUNCATE TABLE [bronze].[crm_product_info]

		PRINT '>> INSERTING DATE INTO : bronze.crm_product_info';
		BULK INSERT [bronze].[crm_product_info]
		FROM 'D:\Udemy\Luke\SQL from Zero to Hero\Projects\sql-datawarehouse-project\datasets\source_crm\prd_info.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> LOAD DURATION: ' + CAST(DATEDIFF(SECOND , @start_time , @end_time) AS NVARCHAR) + ' SECONDS';
		PRINT '----------------';

		SET @start_time = GETDATE();
		PRINT '>> TRUNCATING TABLE : bronze.crm_sales_details';
		TRUNCATE TABLE [bronze].[crm_sales_details]

		PRINT '>> INSERTING DATE INTO : bronze.crm_sales_details';
		BULK INSERT [bronze].[crm_sales_details]
		FROM 'D:\Udemy\Luke\SQL from Zero to Hero\Projects\sql-datawarehouse-project\datasets\source_crm\sales_details.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> LOAD DURATION: ' + CAST(DATEDIFF(SECOND , @start_time , @end_time) AS NVARCHAR) + ' SECONDS';
		PRINT '----------------';

		PRINT '--------------------------------------------';
		PRINT 'lOADING ERP TABLES';
		PRINT '--------------------------------------------';

		SET @start_time = GETDATE();
		PRINT '>> TRUNCATING TABLE : bronze.erp_cusomer_az12';
		TRUNCATE TABLE [bronze].[erp_cusomer_az12]

		PRINT '>> INSERTING DATE INTO : bronze.erp_cusomer_az12';
		BULK INSERT [bronze].[erp_cusomer_az12]
		FROM 'D:\Udemy\Luke\SQL from Zero to Hero\Projects\sql-datawarehouse-project\datasets\source_erp\CUST_AZ12.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> LOAD DURATION: ' + CAST(DATEDIFF(SECOND , @start_time , @end_time) AS NVARCHAR) + ' SECONDS';
		PRINT '----------------';

		SET @start_time = GETDATE();
		PRINT '>> TRUNCATING TABLE : bronze.erp_loc_a101';
		TRUNCATE TABLE [bronze].[erp_loc_a101]

		PRINT '>> INSERTING DATE INTO : bronze.erp_loc_a101';
		BULK INSERT [bronze].[erp_loc_a101]
		FROM 'D:\Udemy\Luke\SQL from Zero to Hero\Projects\sql-datawarehouse-project\datasets\source_erp\LOC_A101.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> LOAD DURATION: ' + CAST(DATEDIFF(SECOND , @start_time , @end_time) AS NVARCHAR) + ' SECONDS';
		PRINT '----------------';

		SET @start_time = GETDATE();
		PRINT '>> TRUNCATING TABLE : bronze.erp_px_cat_g1v2';
		TRUNCATE TABLE [bronze].[erp_px_cat_g1v2]

		PRINT '>> INSERTING DATE INTO : bronze.erp_px_cat_g1v2';
		BULK INSERT [bronze].[erp_px_cat_g1v2]
		FROM 'D:\Udemy\Luke\SQL from Zero to Hero\Projects\sql-datawarehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> LOAD DURATION: ' + CAST(DATEDIFF(SECOND , @start_time , @end_time) AS NVARCHAR) + ' SECONDS';
		PRINT '----------------';

		SET @batch_end_time = GETDATE();
		PRINT '============================================='
		PRINT 'LOADING BRONZE LAYER IS COMPLETED'
		PRINT '	  - TOTAL LOADING DUARTION : ' + CAST(DATEDIFF(SECOND , @batch_start_time , @batch_end_time) AS NVARCHAR(50)) + ' SECONDS'
		PRINT '============================================='
	END TRY
	BEGIN CATCH
	PRINT '========================================='
	PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER'
	PRINT 'ERROR MESSAGE' + ERROR_MESSAGE();
	PRINT 'ERROR MESSAGE' + CAST (ERROR_NUMBER() AS NVARCHAR(50));
	PRINT 'ERROR MESSAGE' + CAST (ERROR_STATE() AS NVARCHAR(50));
	PRINT '========================================='
	END CATCH
END