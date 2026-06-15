/*
silver.crm_cust_info
*/

-- Check for Nulls or Duplicates in Primary Key
SELECT 
cst_id,
COUNT(*)
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) >1 OR cst_id IS NULL

--Check for unwanted space in string values
SELECT cst_firstname 
from silver.crm_cust_info 
WHERE cst_firstname != TRIM (cst_firstname)

--Data Standardization & Consistency
SELECT DISTINCT cst_gndr FROM silver.crm_cust_info
SELECT DISTINCT cst_marital_status FROM silver.crm_cust_info
--Final check
SELECT * FROM silver.crm_cust_info

/*
Silver.crm_prd_info
*/

 -- Check for Nulls or Duplicates in Primary Key
SELECT 
prd_id,
COUNT(*)
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) >1 or prd_id IS NULL

--Check for unwanted space in string values
SELECT prd_nm 
from silver.crm_prd_info 
WHERE prd_nm != TRIM (prd_nm)

--Check for NULLS or Negative Numbers
SELECT prd_cost 
from silver.crm_prd_info 
WHERE prd_cost <0 OR prd_cost IS NULL

--Data Standardization & Consistency
SELECT DISTINCT prd_line FROM silver.crm_prd_info

--Check for Invalid Date Orders
SELECT * 
FROM silver.crm_prd_info 
WHERE prd_end_dt < prd_start_dt --issue found: the start date is later than end date

--Final check
SELECT * FROM silver.crm_prd_info

/*
Silver.crm_sales_details
*/
SELECT sls_ord_num
      ,sls_prd_key
      ,sls_cust_id
      ,sls_order_dt
      ,sls_ship_dt
      ,sls_due_dt
      ,sls_sales
      ,sls_quantity
      ,sls_price
  FROM bronze.crm_sales_details

--Check for unwanted space in string values
SELECT sls_ord_num 
from bronze.crm_sales_details 
WHERE sls_ord_num != TRIM (sls_ord_num)

--Check for Invalid Date 
SELECT sls_due_dt 
FROM bronze.crm_sales_details 
WHERE sls_due_dt <=0 
OR LEN(sls_due_dt)!=8 --issue found: sales order date contain 0 and date that less than 8 

--Check for Invalid Date Orders
SELECT * 
FROM bronze.crm_sales_details 
WHERE sls_order_dt > sls_ship_dt OR sls_order_dt > sls_due_dt 

--Check if the sales match the business logic
SELECT DISTINCT
       sls_sales
      ,sls_quantity
      ,sls_price
      	,CASE WHEN sls_sales IS NULL OR sls_sales <=0 OR sls_sales != sls_quantity * ABS(sls_price)
			THEN sls_quantity * ABS(sls_price)
			ELSE sls_sales
		END AS new_sls_sales
      ,sls_quantity
      ,CASE WHEN sls_price IS NULL OR sls_price <=0
	  THEN sls_sales / NULLIF(sls_quantity,0)
	  ELSE sls_price
	  END AS new_sls_price
      FROM bronze.crm_sales_details
      WHERE sls_sales != sls_quantity * sls_price
      OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
      OR sls_sales <=0 OR sls_quantity <=0 OR sls_price <=0

--final check
SELECT DISTINCT
       sls_sales
      ,sls_quantity
      ,sls_price
      FROM silver.crm_sales_details
      WHERE sls_sales != sls_quantity * sls_price
      OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
      OR sls_sales <=0 OR sls_quantity <=0 OR sls_price <=0


SELECT * FROM silver.crm_sales_details


/*
Silver.erp_cust_az12
*/

--Matching the cid to crm_cust_info
SELECT
cid,
CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING (cid,4,LEN(cid))
    ELSE cid
    END new_cid,
bdate,
gen
FROM bronze.erp_cust_az12
WHERE CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING (cid,4,LEN(cid))
    ELSE cid
    END NOT IN (SELECT DISTINCT cst_key FROM silver.crm_cust_info)

--Indentify Out-of-Range Dates
SELECT DISTINCT
bdate
FROM bronze.erp_cust_az12
WHERE bdate < '1924-01-01' OR bdate > GETDATE()

--Data Standardization & Consistency
SELECT DISTINCT gen,
CASE WHEN UPPER(TRIM(gen))  IN ('F','FEMALE') THEN 'Female'
	WHEN UPPER(TRIM(gen))  IN ('M','MALE') THEN 'Male'
	ELSE 'n/a'
	END as gen FROM bronze.erp_cust_az12

--final check
SELECT * FROM silver.erp_cust_az12

/*
Silver.erp_loc_a101
*/
--Replacing unmatch data 
SELECT REPLACE (cid,'-','') AS cid FROM bronze.erp_loc_a101 WHERE REPLACE (cid,'-','') NOT IN
(SELECT cst_key FROM bronze.crm_cust_info)

--Data Standardization & Consistency
SELECT DISTINCT cntry
FROM bronze.erp_loc_a101 ORDER BY cntry

SELECT
CASE WHEN TRIM (cntry) = 'DE' THEN 'Germany'
	WHEN TRIM (cntry) IN ('US', 'USA') THEN 'United States'
	WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'n/a'
	ELSE TRIM (cntry)
	END AS cntry
    FROM bronze.erp_loc_a101

--final check
SELECT * FROM silver.erp_loc_a101


/*
Silver.erp_px_cat_g1v2
*/

--Check for unwanted spaces
SELECT * FROM bronze.erp_px_cat_g1v2
WHERE cat != TRIM(cat) OR subcat != TRIM(subcat) OR maintenance != TRIM (maintenance)

--Data Standardization & Consistency
SELECT DISTINCT 
maintenance FROM bronze.erp_px_cat_g1v2

--final check
SELECT 
*
FROM silver.erp_px_cat_g1v2
