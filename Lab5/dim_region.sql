CREATE TABLE [SalesData].[dim_region] (

	[region_id] int NULL, 
	[city] varchar(100) NULL, 
	[state] varchar(100) NULL, 
	[region] varchar(50) NULL
);


GO
ALTER TABLE [SalesData].[dim_region] ADD CONSTRAINT UQ_4ea2450b_07d0_48b6_a58c_32d88f2f4532 unique NONCLUSTERED ([region_id]);