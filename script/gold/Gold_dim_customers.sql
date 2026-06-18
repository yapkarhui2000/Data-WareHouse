/*
Script Purpose:
    This script creates views for the Gold layer in the data warehouse. 
    The Gold layer represents the final dimension and fact tables (Star Schema)

    Each view performs transformations and combines data from the Silver layer 
    to produce a clean, enriched, and business-ready dataset.
*/

CREATE VIEW gold.dim_customers AS
SELECT 
       ROW_NUMBER() OVER (ORDER BY cst_id) AS customer_key
      ,ci.cst_id AS customer_id
      ,ci.cst_key AS customer_num
      ,ci.cst_firstname AS first_name
      ,ci.cst_lastname AS Last_name
      ,la.cntry AS country
      ,ci.cst_marital_status AS marital_status
      ,CASE WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr --CRM is the Master of gender info
            ELSE COALESCE(ca.gen,'n/a')
      END as gender
      ,ca.bdate AS birthday
      ,ci.cst_create_date AS create_date
  FROM silver.crm_cust_info ci 
  LEFT JOIN silver.erp_cust_az12 ca
  ON ci.cst_key = ca.cid
  LEFT JOIN silver.erp_loc_a101 la
  ON ci.cst_key = la.cid

  SELECT * FROM gold.dim_customers;

