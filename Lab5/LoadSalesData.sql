--Updated table
CREATE   PROCEDURE SalesData.LoadSalesData
    @OrderYear INT
AS
BEGIN
    -- Insert data into dim_customer
    INSERT INTO SalesData.dim_customer (customer_id, customer_name)
    SELECT DISTINCT 
        DENSE_RANK() OVER (ORDER BY Customer_Name) AS customer_id,
        Customer_Name
    FROM [MarketingData_Lakehouse].[dbo].[lakehousedata_table]
    WHERE YEAR(Order_Date) = @OrderYear;

    -- Insert data into dim_category
    INSERT INTO SalesData.dim_category (category_id, category_name, sub_category)
    SELECT DISTINCT 
        DENSE_RANK() OVER (ORDER BY Category, Sub_Category) AS category_id,
        Category,
        Sub_Category
    FROM [MarketingData_Lakehouse].[dbo].[lakehousedata_table]
    WHERE YEAR(Order_Date) = @OrderYear;

    -- Insert data into dim_region
    INSERT INTO SalesData.dim_region (region_id, city, state, region)
    SELECT DISTINCT 
        DENSE_RANK() OVER (ORDER BY City, State, Region) AS region_id,
        City, 
        State, 
        Region
    FROM [MarketingData_Lakehouse].[dbo].[lakehousedata_table]
    WHERE YEAR(Order_Date) = @OrderYear;

    -- Insert data into fact_sales using the view
    INSERT INTO SalesData.fact_sales (order_id, customer_id, category_id, sales, order_date, region_id, discount)
    SELECT * FROM SalesData.vw_fact_sales_staging
    WHERE YEAR(Order_Date) = @OrderYear;
END;