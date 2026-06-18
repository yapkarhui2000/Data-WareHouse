/*
===============================================================================
Quality Checks
===============================================================================
Script Purpose:
    This script performs quality checks to validate the integrity, consistency, 
    and accuracy of the Gold Layer. These checks ensure:
    - Uniqueness of surrogate keys in dimension tables.
    - Referential integrity between fact and dimension tables.
    - Validation of relationships in the data model for analytical purposes.
===============================================================================
*/

-- ====================================================================
-- Checking 'gold.dim_customers'
-- ====================================================================
-- Check for Uniqueness of Customer Key in gold.dim_customers
-- Expectation: No results 
SELECT 
    customer_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_customers
GROUP BY customer_key
HAVING COUNT(*) > 1;

-- ====================================================================
-- Checking 'gold.product_key'
-- ====================================================================

--Check if there is duplicate

SELECT prd_key,COUNT(*) FROM (
SELECT pn.prd_id
      ,pn.cate_id
      ,pn.prd_key
      ,pn.prd_nm
      ,pn.prd_cost
      ,pn.prd_line
      ,pn.prd_start_dt
      ,pn.prd_end_dt
      ,pc.cat
      ,pc.subcat
      ,pc.maintenance
  FROM silver.crm_prd_info pn
  LEFT JOIN silver.erp_px_cat_g1v2 pc
  ON pn.cate_id =pc.id
  WHERE pn.prd_end_dt is NULL -- filter out all historical data
)t GROUP BY prd_key HAVING COUNT (*)>1


-- ====================================================================
-- Checking 'gold.fact_sales'
-- ====================================================================
-- Check the data model connectivity between fact and dimensions
SELECT * 
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON c.customer_key = f.customer_key
LEFT JOIN gold.dim_products p
ON p.product_key = f.product_key
WHERE p.product_key IS NULL OR c.customer_key IS NULL  
