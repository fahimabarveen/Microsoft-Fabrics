CREATE TABLE [SalesData].[dim_customer] (

	[customer_id] int NULL, 
	[customer_name] varchar(100) NULL
);


GO
ALTER TABLE [SalesData].[dim_customer] ADD CONSTRAINT UQ_dcf6fb3d_aa7b_4a60_a38d_c4829c4cc501 unique NONCLUSTERED ([customer_id]);