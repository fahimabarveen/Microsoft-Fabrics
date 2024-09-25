 ### PART 1: Load and Transform Sales Data

#### Step 1: Load Data into Microsoft Fabric Lakehouse

**Goal**: Load the provided CSV file (sales data) into a Lakehouse.

**Solution**:

1. **Create Lakehouse and Folder**:
   - Download the data file from [this link](https://raw.githubusercontent.com/mofaizal/microsoft_fabric_playground/refs/heads/main/dataset/sales_data_05092024.csv).

2. **Create a Fabric Pipeline**:
   - Set up a data pipeline that monitors the storage location where the CSV files are uploaded. This pipeline will automate the data load process.

3. **Notebook Integration**:
   - Use a notebook to automate transformations on the raw CSV data and load it into a table in the Lakehouse.

   ```python

   # Sample code to load CSV to Lakehouse
   df = spark.read.format("csv").option("header", "true").load("Files/data/*.csv")
   df.write.format("delta").saveAsTable("lakehousedata_table")
   ```

4. **Schedule the Pipeline**:
   - Schedule the pipeline to run daily or whenever new files are detected.

#### Step 2: Create Warehouse

1. **Create Warehouse**:
   - Set up the warehouse environment where the data will be stored and analyzed.

2. **Create Fact and Dimension Tables in the Warehouse**:
   - **Goal**: Use the data schema to create a star schema in the warehouse.

   **Solution**:
   - **Fact Table**: `FactSales`, storing transactional sales data.
   - **Dimension Tables**:
     - `dim_customer`: Customer details.
     - `dim_category`: Category and sub-category details.
     - `dim_region`: City and state details.

3. **Create Schema**:
   - Start by creating a schema to keep your data well-organized.

--step1- check d create salesdata table

IF NOT EXISTS(SELECT * FROM sys.schemas WHERE name = 'SalesData')
BEGIN
EXEC('Create schema SalesData');
End;
GO

--step2- create fact d dim tables

-- Create fact_sales table

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'fact_sales' AND SCHEMA_NAME(schema_id) = 'SalesData')
BEGIN
    CREATE TABLE SalesData.fact_sales (
        order_id VARCHAR(50),
        customer_id INT,
        category_id INT,
        sales DECIMAL(10,2),
        order_date DATE,
        region_id INT,
        discount VARCHAR(50)
    );
END;
GO

-- Create dim_customer table

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'dim_customer' AND SCHEMA_NAME(schema_id) = 'SalesData')
BEGIN
    CREATE TABLE SalesData.dim_customer (
        customer_id INT,
        customer_name VARCHAR(100)
    );
END;
GO

-- Create dim_category table

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'dim_category' AND SCHEMA_NAME(schema_id) = 'SalesData')
BEGIN
    CREATE TABLE SalesData.dim_category (
        category_id INT,
        category_name VARCHAR(50),
        sub_category VARCHAR(50)
    );
END;
GO

-- Create dim_region table

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'dim_region' AND SCHEMA_NAME(schema_id) = 'SalesData')
BEGIN
    CREATE TABLE SalesData.dim_region (
        region_id INT,
        city VARCHAR(100),
        state VARCHAR(100),
        region VARCHAR(50)
    );
END;
GO

--step3-distinct data


-- To find unique RankID to each customer in Customer table

INSERT INTO SalesData.dim_customer (customer_id, customer_name)
SELECT DISTINCT 
    DENSE_RANK() OVER (ORDER BY Customer_Name) AS customer_id,
    Customer_Name
FROM [MarketingData_Lakehouse].[dbo].[lakehousedata_table];

-- To find unique RankID in Category table

INSERT INTO SalesData.dim_category (category_id, category_name, sub_category)
SELECT DISTINCT 
    DENSE_RANK() OVER (ORDER BY Category, Sub_Category) AS category_id,
    Category,
    Sub_Category
FROM [MarketingData_Lakehouse].[dbo].[lakehousedata_table];

-- To find unique RankID in Category table

INSERT INTO SalesData.dim_region (region_id, city, state, region)
SELECT DISTINCT 
    DENSE_RANK() OVER (ORDER BY City, State, Region) AS region_id,
    City, 
    State, 
    Region
FROM [MarketingData_Lakehouse].[dbo].[lakehousedata_table];

--step4-create view

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

--step5-store procedure

--Updated table
CREATE OR ALTER PROCEDURE SalesData.LoadSalesData
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

--step6-execute data

--Insert data into fact_sales table

EXEC SalesData.LoadSalesData 2020;

--step7-display date by year

SELECT * FROM SalesData.fact_sales
WHERE year(order_date) = 2020;

### Tables Recap

1. **fact_sales**: Contains order details, customer, category, region, sales amount, order date, and discount.
2. **dim_customer**: Contains customer details.
3. **dim_category**: Contains category and sub-category details.
4. **dim_region**: Contains city, state, and region details.

### Queries for Each Goal

These queries will help you address each goal by leveraging the `fact_sales` table and joining it with the relevant dimension tables. 

--step8-Trends Various Categories

--1. Understand Sales Trends Across Various Categories (e.g., Beverages, Snacks, Eggs, etc.)

--Required columns: --From fact_sales: sales, order_date
                    --From dim_category: category_name

SELECT 
    dc.category_name, 
    YEAR(fs.order_date) AS year, 
    MONTH(fs.order_date) AS month,
    SUM(fs.sales) AS total_sales
FROM 
    SalesData.fact_sales fs
INNER JOIN 
    SalesData.dim_category dc ON fs.category_id = dc.category_id
GROUP BY 
    dc.category_name, YEAR(fs.order_date), MONTH(fs.order_date)
ORDER BY 
    year DESC, month DESC, total_sales DESC;

--step9-Top-Selling Items and Customers in Each Region

--2. Identify Top-Selling Items and Customers in Each Region

--Required column: --From fact_sales: sales
                   --From dim_customer: customer_name
                   --From dim_region: city, state, region

SELECT 
    dc.customer_name, 
    dr.city, 
    dr.state, 
    dr.region, 
    SUM(fs.sales) AS total_sales
FROM 
    SalesData.fact_sales fs
INNER JOIN 
    SalesData.dim_customer dc ON fs.customer_id = dc.customer_id
INNER JOIN 
    SalesData.dim_region dr ON fs.region_id = dr.region_id
GROUP BY 
    dc.customer_name, dr.city, dr.state, dr.region
ORDER BY 
    total_sales DESC;

--step10-Monthly and Yearly Sales Patterns(Marketing Strategies)

--3. Determine Monthly and Yearly Sales Patterns to Optimize Marketing Strategies

--Required columns: --From fact_sales: sales, order_date
                    --Total Sales

SELECT 
    YEAR(fs.order_date) AS year, 
    MONTH(fs.order_date) AS month, 
    SUM(fs.sales) AS total_sales
FROM 
    SalesData.fact_sales fs
GROUP BY 
    YEAR(fs.order_date), MONTH(fs.order_date)ORDER BY 
    year DESC, month DESC;

--Total Discounted Sales

SELECT 
    YEAR(fs.order_date) AS year, 
    MONTH(fs.order_date) AS month, 
    SUM(fs.sales) AS total_sales,
    SUM(fs.sales * fs.discount) AS total_discounted_sales
FROM 
    SalesData.fact_sales fs
GROUP BY 
    YEAR(fs.order_date), MONTH(fs.order_date)
ORDER BY 
    year DESC, month DESC;

--Net Sales

SELECT 
    YEAR(fs.order_date) AS year, 
    MONTH(fs.order_date) AS month, 
    SUM(fs.sales) AS total_sales,
    SUM(fs.sales * fs.discount) AS total_discounted_sales,
    SUM(fs.sales) - SUM (fs.sales * fs.discount) AS net_sales
    FROM 
    SalesData.fact_sales fs
GROUP BY 
    YEAR(fs.order_date), MONTH(fs.order_date)
ORDER BY 
    year DESC, month DESC;

This setup will help you efficiently load, transform, and analyze your sales data. 
