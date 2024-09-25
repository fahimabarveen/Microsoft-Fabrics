IF NOT EXISTS(SELECT * FROM sys.schemas WHERE name = 'SalesData')
BEGIN
EXEC('Create schema SalesData');
End;
GO