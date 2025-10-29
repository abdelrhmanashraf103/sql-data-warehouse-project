/*
===============================================================================
DDL Script: Create Gold Views
===============================================================================
Script Purpose:
    This script creates views for the Gold layer in the data warehouse. 
    The Gold layer represents the final dimension and fact tables (Star Schema)

    Each view performs transformations and combines data from the Silver layer 
    to produce a clean, enriched, and business-ready dataset.

Usage:
    - These views can be queried directly for analytics and reporting.
===============================================================================
*/

-- =============================================================================
-- Create Dimension: gold.dim_customers
-- =============================================================================

IF OBJECT_ID('gold.dim_customers', 'V') IS NOT NULL
    DROP VIEW gold.dim_customers;
GO

CREATE VIEW gold.dim_customers AS

SELECT
	ROW_NUMBER() OVER(ORDER BY cst_id) AS customer_key,
	ci.cst_id AS customer_id,
	ci.cst_key AS customer_number,
	ci.cst_first_name AS first_name,
	ci.cst_last_name AS last_name,
	la.country,
	ci.cst_marital_status AS marital_status,
	CASE 
		WHEN ci.cst_gender != 'N/A' THEN ci.cst_gender
		ELSE COALESCE(ca.gender , 'N/A')
	END gender,
	ca.birth_date AS birth_date,
	ci.cst_create_date AS create_date

FROM [silver].[crm_customer_info] ci
LEFT JOIN [silver].[erp_cusomer_az12] ca
ON		ci.cst_key = ca.cust_id

LEFT JOIN [silver].[erp_loc_a101] la
ON		ci.cst_key = la.cust_id

GO
-- =============================================================================
-- Create Dimension: gold.dim_products
-- =============================================================================
IF OBJECT_ID('gold.dim_products', 'V') IS NOT NULL
    DROP VIEW gold.dim_products;
GO

CREATE VIEW gold.dim_products AS
SELECT 
	ROW_NUMBER() OVER(ORDER BY pn.prod_start_dt , pn.prod_key) AS product_key,
	pn.prod_id AS product_id,
	pn.prod_key AS product_number,
	pn.prod_name AS product_name,
	pn.cat_id AS category_id,
	pc.cat AS category,
	pc.sub_cat AS subcategory,
	pc.maintenance,
	pn.prod_cost AS cost,
	pn.prod_line AS product_line,
	pn.prod_start_dt AS start_date
FROM [silver].[crm_product_info] pn
LEFT JOIN [silver].[erp_px_cat_g1v2] pc
ON pn.cat_id = pc.id
WHERE pn.prod_end_dt IS NULL -- Filter out all historical data

GO

-- =============================================================================
-- Create Fact Table: gold.fact_sales
-- =============================================================================
IF OBJECT_ID('gold.fact_sales', 'V') IS NOT NULL
    DROP VIEW gold.fact_sales;
GO

CREATE VIEW gold.fact_sales AS
SELECT 
	sls_order_num AS order_number,
	pr.product_key,
	cu.customer_key,
	sls_order_dt AS order_date,
	sls_ship_dt AS shipping_date,
	sls_due_dt AS due_date,
	sls_sales AS sales_amount,
	sls_quantity AS quantity,
	sls_price
FROM [silver].[crm_sales_details] sd
LEFT JOIN [gold].[dim_products] pr
ON sd.sls_prod_key = pr.product_number
LEFT JOIN [gold].[dim_customers] cu
ON sd.sls_customer_id = cu.customer_id
