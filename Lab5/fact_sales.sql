CREATE TABLE [SalesData].[fact_sales] (

	[order_id] varchar(50) NULL, 
	[customer_id] int NULL, 
	[category_id] int NULL, 
	[sales] decimal(10,2) NULL, 
	[order_date] date NULL, 
	[region_id] int NULL, 
	[discount] varchar(50) NULL
);


GO
ALTER TABLE [SalesData].[fact_sales] ADD CONSTRAINT FK_ca7bf107_7987_4fbd_81b3_2c9fd3219372 FOREIGN KEY ([region_id]) REFERENCES SalesData.dim_region([region_id]);
GO
ALTER TABLE [SalesData].[fact_sales] ADD CONSTRAINT FK_d1a1d18f_a794_472d_a2ee_5b328dcc06dd FOREIGN KEY ([customer_id]) REFERENCES SalesData.dim_customer([customer_id]);
GO
ALTER TABLE [SalesData].[fact_sales] ADD CONSTRAINT FK_ffa08cfb_93f3_4684_89e5_685d70164750 FOREIGN KEY ([category_id]) REFERENCES SalesData.dim_category([category_id]);