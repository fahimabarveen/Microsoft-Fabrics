----------------------------Load Data via Pipeline----->Warehouse SQL Queries------------------------

Here’s a simplified version of your storyline and architecture diagram for loading CSV sales data into a Lakehouse for analysis by a supermarket’s marketing department:

Goal: Analyze Sales Data for Insights

The supermarket’s marketing department aims to:

1.Understand sales trends across various categories (e.g., Beverages, Snacks, Eggs).

2.Identify top-selling items and customers in each region.

3.Determine monthly and yearly sales patterns to optimize marketing strategies.

4.Evaluate customer preferences by city and region.

5.Measure the impact of discounts on overall profits and losses.

Solution:

1.Load Data: Collect daily sales data in CSV files.

Load these CSV files into Microsoft Fabric’s Lakehouse using pipelines.

Transform the data into warehouse tables.

2.Warehouse Schema: Create fact tables (e.g., fact_sales) to store sales data.

Create dimension tables (e.g., dim_customer, dim_product, dim_region) to store related information.

3.Stored Procedures: Develop stored procedures to load data from CSV files into the warehouse tables.
Use parameters such as year and city for data loading.

4.Power BI Reports: Use Power BI to generate visual reports.

Analyze total sales, top customers, and high-performing products.

Architecture Diagram(Data Warehouse):

Here’s a simple architecture diagram to illustrate the process:

CSV Files (SalesData)
        |
        v
Microsoft Fabric Lakehouse
        |
        v
Data Pipelines
        |
        v
Warehouse Tables (fact_sales, dim_customer, dim_product, dim_region)
        |
        v
Stored Procedures (Load Data)
        |
        v
Power BI Reports (Visual Analysis)

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

 **Goal**: Use the data schema to create a star schema in the warehouse.

**Solution**:

**Fact Table**: `FactSales`, storing transactional sales data.

**Dimension Tables**:
     - `dim_customer`: Customer details.
     - `dim_category`: Category and sub-category details.
     - `dim_region`: City and state details.

3. **Create Schema**:
   
   - Start by creating a schema to keep your data well-organized.