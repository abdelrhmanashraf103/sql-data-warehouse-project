/*
===============================================================================
DDL Script: Create silver Tables
===============================================================================
Script Purpose:
    This script creates tables in the 'silver' schema, dropping existing tables 
    if they already exist.
	  Run this script to re-define the DDL structure of 'silver' Tables
===============================================================================
*/


IF OBJECT_ID('[silver].crm_customer_info' , 'U') IS NOT NULL
	DROP TABLE [silver].crm_customer_info
CREATE TABLE [silver].crm_customer_info (
	cst_id			   INT,
	cst_key			   NVARCHAR(50),
	cst_first_name	   NVARCHAR(50),
	cst_last_name	   NVARCHAR(50),
	cst_marital_status NVARCHAR(50),
	cst_gender		   NVARCHAR(50),
	cst_create_date	   DATE,
	dwh_create_date    DATETIME2 DEFAULT GETDATE()

);

IF OBJECT_ID('[silver].crm_product_info' , 'U') IS NOT NULL
	DROP TABLE [silver].crm_product_info
CREATE TABLE [silver].crm_product_info (
	prod_id		    INT,
	cat_id			NVARCHAR(50),
	prod_key	    NVARCHAR(50),
	prod_name	    NVARCHAR(50),
	prod_cost	    INT,
	prod_line	    NVARCHAR(50),
	prod_start_dt   DATE,
	prod_end_dt     DATE,
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);

IF OBJECT_ID('[silver].crm_sales_details' , 'U') IS NOT NULL
	DROP TABLE [silver].crm_sales_details
CREATE TABLE [silver].crm_sales_details (
	sls_order_num	  NVARCHAR(50),
	sls_prod_key	  NVARCHAR(50),
	sls_customer_id	  INT,
	sls_order_dt	  DATE,
	sls_ship_dt		  DATE,
	sls_due_dt        DATE,
	sls_sales		  INT,
	sls_quantity      INT,
	sls_price         INT,
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);

IF OBJECT_ID('[silver].erp_loc_a101' , 'U') IS NOT NULL
	DROP TABLE [silver].erp_loc_a101
CREATE TABLE [silver].erp_loc_a101 (
	cust_id NVARCHAR(50),
	country NVARCHAR(50),
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);

IF OBJECT_ID('[silver].erp_cusomer_az12' , 'U') IS NOT NULL
	DROP TABLE [silver].erp_cusomer_az12
CREATE TABLE [silver].erp_cusomer_az12 (
	cust_id NVARCHAR(50),
	birth_date DATE,
	gender NVARCHAR(50),
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);

IF OBJECT_ID('[silver].erp_px_cat_g1v2' , 'U') IS NOT NULL
	DROP TABLE [silver].erp_px_cat_g1v2
CREATE TABLE [silver].erp_px_cat_g1v2 (
	id		    NVARCHAR(50),
	cat		    NVARCHAR(50),
	sub_cat		NVARCHAR(50),
	maintenance NVARCHAR(50),
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);