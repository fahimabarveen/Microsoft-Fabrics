## 1. Dynamic Data Masking
### Create the `Customers` Table

Run the following T-SQL code to create the `Customers` table with masking rules:

```sql
CREATE TABLE dbo.Customers
(   
    CustomerID INT NOT NULL,   
    FirstName varchar(50) MASKED WITH (FUNCTION = 'partial(1,"XXXXXXX",0)') NULL,     
    LastName varchar(50) NOT NULL,     
    Phone varchar(20) MASKED WITH (FUNCTION = 'default()') NULL,     
    Email varchar(50) MASKED WITH (FUNCTION = 'email()') NULL   
);
   
INSERT dbo.Customers (CustomerID, FirstName, LastName, Phone, Email) VALUES
(29485,'Catherine','Abel','555-555-5555','catherine0@adventure-works.com'),
(29486,'Kim','Abercrombie','444-444-4444','kim2@adventure-works.com'),
(29489,'Frances','Adams','333-333-3333','frances0@adventure-works.com');

SELECT * FROM dbo.Customers;

Testing as a Restricted User

1.Connect as a test user with the Viewer role and run:

```sql
SELECT * FROM dbo.Customers;
The user will see masked values.

Granting UNMASK Permission
Reconnect as the Workspace Admin and run:

```sql
GRANT UNMASK ON dbo.Customers TO [<username>@<your_domain>.com];

Connect again as the test user and run:

```sql
SELECT * FROM dbo.Customers;
The data should now appear unmasked.

2. Row-Level Security (RLS)

Create the Sales Table
Run the following T-SQL code:

sql
CREATE TABLE dbo.Sales  
(  
    OrderID INT,  
    SalesRep VARCHAR(60),  
    Product VARCHAR(10),  
    Quantity INT  
);
    
INSERT dbo.Sales (OrderID, SalesRep, Product, Quantity) VALUES
(1, '<username1>@<your_domain>.com', 'Valve', 5),   
(2, '<username1>@<your_domain>.com', 'Wheel', 2),   
(3, '<username1>@<your_domain>.com', 'Valve', 4),  
(4, '<username2>@<your_domain>.com', 'Bracket', 2),   
(5, '<username2>@<your_domain>.com', 'Wheel', 5),   
(6, '<username2>@<your_domain>.com', 'Seat', 5);  

SELECT * FROM dbo.Sales;  

Create RLS Objects
Create a schema, a security predicate function, and a security policy:

sql
CREATE SCHEMA rls;
GO
   
CREATE FUNCTION rls.fn_securitypredicate(@SalesRep AS VARCHAR(60)) 
    RETURNS TABLE  
WITH SCHEMABINDING  
AS  
    RETURN SELECT 1 AS fn_securitypredicate_result   
WHERE @SalesRep = USER_NAME();
GO   

CREATE SECURITY POLICY SalesFilter  
ADD FILTER PREDICATE rls.fn_securitypredicate(SalesRep)   
ON dbo.Sales  
WITH (STATE = ON);
GO

Testing RLS
Log in as <username1>@<your_domain>.com and run:

sql
SELECT USER_NAME();
SELECT * FROM dbo.Sales;

You should only see rows corresponding to the logged-in user.

3. Column-Level Security


Create the Orders Table
Run the following code:

sql
CREATE TABLE dbo.Orders
(   
    OrderID INT,   
    CustomerID INT,  
    CreditCard VARCHAR(20)      
);   

INSERT dbo.Orders (OrderID, CustomerID, CreditCard) VALUES
(1234, 5678, '111111111111111'),
(2341, 6785, '222222222222222'),
(3412, 7856, '333333333333333');   

SELECT * FROM dbo.Orders;

Deny Access to the CreditCard Column
Run:

sql
DENY SELECT ON dbo.Orders (CreditCard) TO [<username>@<your_domain>.com];

Testing Column-Level Security
Log in as the user denied access and run:

sql
SELECT * FROM dbo.Orders;

You will receive an error due to restricted access. Now run:

sql
SELECT OrderID, CustomerID FROM dbo.Orders;

This should succeed, returning only accessible columns.

