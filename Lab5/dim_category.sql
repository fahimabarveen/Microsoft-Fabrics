CREATE TABLE [SalesData].[dim_category] (

	[category_id] int NULL, 
	[category_name] varchar(50) NULL, 
	[sub_category] varchar(50) NULL
);


GO
ALTER TABLE [SalesData].[dim_category] ADD CONSTRAINT UQ_4d8e466f_10e5_4cf9_a332_06e264fa935b unique NONCLUSTERED ([category_id]);