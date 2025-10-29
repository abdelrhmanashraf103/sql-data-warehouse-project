/*
===============================================================================
DDL Script: Create Bronze Tables
===============================================================================
Script Purpose:
    This script creates tables in the 'bronze' schema, dropping existing tables 
    if they already exist.
	  Run this script to re-define the DDL structure of 'bronze' Tables
===============================================================================
*/


IF OBJECT_ID('[bronze].crm_customer_info' , 'U') IS NOT NULL
	DROP TABLE [bronze].crm_customer_info
CREATE TABLE [bronze].crm_customer_info (
	cst_id INT,
	cst_key NVARCHAR(50),
	cst_first_name NVARCHAR(50),
	cst_last_name NVARCHAR(50),
	cst_marital_status NVARCHAR(50),
	cst_gender NVARCHAR(50),
	cst_create_date DATE

);

IF OBJECT_ID('[bronze].crm_product_info' , 'U') IS NOT NULL
	DROP TABLE [bronze].crm_product_info
CREATE TABLE [bronze].crm_product_info (
	prod_id		  INT,
	prod_key	  NVARCHAR(50),
	prod_name	  NVARCHAR(50),
	prod_cost	  INT,
	prod_line	  NVARCHAR(50),
	prod_start_dt DATETIME,
	prod_end_dt   DATETIME
);

IF OBJECT_ID('[bronze].crm_sales_details' , 'U') IS NOT NULL
	DROP TABLE [bronze].crm_sales_details
CREATE TABLE [bronze].crm_sales_details (
	sls_order_num	  NVARCHAR(50),
	sls_prod_key	  NVARCHAR(50),
	sls_customer_id	  INT,
	sls_order_dt	  INT,
	sls_ship_dt		  INT,
	sls_due_dt        INT,
	sls_sales		  INT,
	sls_quantity      INT,
	sls_price         INT
);

IF OBJECT_ID('[bronze].erp_loc_a101' , 'U') IS NOT NULL
	DROP TABLE [bronze].erp_loc_a101
CREATE TABLE [bronze].erp_loc_a101 (
	cust_id NVARCHAR(50),
	country NVARCHAR(50),
);

IF OBJECT_ID('[bronze].erp_cusomer_az12' , 'U') IS NOT NULL
	DROP TABLE [bronze].erp_cusomer_az12
CREATE TABLE [bronze].erp_cusomer_az12 (
	cust_id NVARCHAR(50),
	birth_date DATE,
	gender NVARCHAR(50)
);

IF OBJECT_ID('[bronze].erp_px_cat_g1v2' , 'U') IS NOT NULL
	DROP TABLE [bronze].erp_px_cat_g1v2
CREATE TABLE [bronze].erp_px_cat_g1v2 (
	id		    NVARCHAR(50),
	cat		    NVARCHAR(50),
	sub_cat		NVARCHAR(50),
	maintenance NVARCHAR(50)
);