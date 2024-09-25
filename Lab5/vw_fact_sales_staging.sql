CREATE VIEW SalesData.vw_fact_sales_staging
AS
SELECT 
    ls.Order_ID,
    dc.customer_id,
    dcat.category_id,
    ls.Sales,
    ls.Order_Date,
    dr.region_id,
    ls.Discount
FROM [MarketingData_Lakehouse].[dbo].[lakehousedata_table] ls
INNER JOIN SalesData.dim_customer dc ON ls.Customer_Name = dc.customer_name
INNER JOIN SalesData.dim_category dcat ON ls.Category = dcat.category_name AND ls.Sub_Category = dcat.sub_category
INNER JOIN SalesData.dim_region dr ON ls.City = dr.city AND ls.State = dr.state AND ls.Region = dr.region;