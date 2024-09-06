create database dataspark;  
use dataspark;
CREATE TABLE Customers (Unnamed int,
    CustomerKey INT PRIMARY KEY,
    Gender VARCHAR(10),
    Name VARCHAR(100),
    City VARCHAR(50),
    State_Code VARCHAR(255),
    State VARCHAR(50),
    Zip_Code VARCHAR(20),
    Country VARCHAR(50),
    Continent VARCHAR(50),
    Birthday Date,
    Age INT
);
select * from Customers;
CREATE TABLE Sales (
    Unnamed_0 INT,
    Order_Number INT,
    Line_Item INT,
    Order_Date DATE,
    Delivery_Date DATE,
    CustomerKey INT,
    StoreKey INT,
    ProductKey INT,
    Quantity INT,
    Currency_Code VARCHAR(10)
);
CREATE TABLE Products (Unnamed_0 int,
    ProductKey INT,
    Product_Name VARCHAR(255),
    Brand VARCHAR(255),
    Color VARCHAR(255),
    Unit_Cost_USD FLOAT,
    Unit_Price_USD FLOAT,
    SubcategoryKey INT,
    Subcategory VARCHAR(255),
    CategoryKey INT,
    Category VARCHAR(255)
);
CREATE TABLE Stores (Unnamed int,
    StoreKey INT,
    Country VARCHAR(255),
    State VARCHAR(255),
    Square_Meters FLOAT,
    Open_Date DATE);
    
CREATE TABLE ExchangeRates ( Unnamed int,
    Date DATE,
    Currency VARCHAR(10) ,
    Exchange FLOAT ); 

select * from Customers;

CREATE TABLE JoinedData AS
SELECT
    C.CustomerKey,
    C.Name,
    C.Gender,
    C.City,
    C.State,
    C.Country,
    C.Continent,
    C.Birthday,
    C.Age,
    S.Order_Number,
    S.Order_Date,
    S.Delivery_Date,
    S.Quantity,
    P.Product_Name,
    P.Brand,
    P.Color,
    P.Unit_Cost_USD,
    P.Unit_Price_USD,
    P.Subcategory,
    P.Category,
    St.Country AS Store_Country,
    St.State AS Store_State,
    St.Square_Meters,
    St.Open_Date,
    E.Currency,
    S.StoreKey,
    E.Exchange,
    S.Currency_code
FROM Sales S
-- Join Customers table using CustomerKey
JOIN Customers C ON S.CustomerKey = C.CustomerKey
-- Join Products table using ProductKey
JOIN Products P ON S.ProductKey = P.ProductKey
-- Join Stores table using StoreKey
JOIN Stores St ON S.StoreKey = St.StoreKey
-- Join ExchangeRates table using Currency_Code and Date
JOIN ExchangeRates E ON S.Currency_Code = E.Currency AND S.Order_Date = E.Date;

select * from joineddata;
select count(*) from joineddata;

-- Demographic Distribution
SELECT Gender, COUNT(*) AS NumberOfCustomers
FROM joineddata
GROUP BY Gender;

SELECT City, COUNT(*) AS NumberOfCustomers
FROM joineddata
GROUP BY City;

SELECT State, COUNT(*) AS NumberOfCustomers
FROM joineddata
GROUP BY State;

SELECT Country, COUNT(*) AS NumberOfCustomers
FROM joineddata
GROUP BY Country;

SELECT Continent, COUNT(*) AS NumberOfCustomers
FROM joineddata
GROUP BY Continent;

-- Purchase Patterns
SELECT AVG(Order_Value) AS AverageOrderValue, COUNT(*) AS TotalPurchases
FROM (SELECT Order_Number, SUM(Unit_Price_USD * Quantity) AS Order_Value
      FROM joineddata
      GROUP BY Order_Number) AS Orders;

-- Segment customers (example: high-value customers)
SELECT CustomerKey, SUM(Unit_Price_USD * Quantity) AS TotalSpent
FROM joineddata
GROUP BY CustomerKey
HAVING SUM(Unit_Price_USD * Quantity) > 1000;

-- Overall Sales Performance
SELECT Order_Date, SUM(Unit_Price_USD * Quantity) AS TotalSales
FROM joineddata
GROUP BY Order_Date
ORDER BY Order_Date;

-- Sales by Product
SELECT Product_Name, SUM(Quantity) AS TotalQuantity, SUM(Unit_Price_USD * Quantity) AS TotalRevenue
FROM joineddata
GROUP BY Product_Name
ORDER BY TotalRevenue DESC;

-- Sales by Store
SELECT StoreKey, SUM(Unit_Price_USD * Quantity) AS TotalRevenue
FROM joineddata
GROUP BY StoreKey
ORDER BY TotalRevenue DESC;

-- Sales by Currency
SELECT Currency_Code, SUM(Unit_Price_USD * Quantity) AS TotalRevenue
FROM joineddata
GROUP BY Currency_Code
ORDER BY TotalRevenue DESC;

-- Product Popularity
SELECT Product_Name, SUM(Quantity) AS TotalQuantity
FROM joineddata
GROUP BY Product_Name
ORDER BY TotalQuantity DESC;

-- Profitability Analysis
SELECT Product_Name, (Unit_Price_USD - Unit_Cost_USD) AS ProfitMargin
FROM joineddata
GROUP BY Product_Name;

-- Category Analysis
SELECT Category, SUM(Unit_Price_USD * Quantity) AS TotalRevenue
FROM joineddata
GROUP BY Category;

-- Store Performance
SELECT StoreKey, SUM(Unit_Price_USD * Quantity) AS TotalRevenue, Square_Meters
FROM joineddata
GROUP BY StoreKey, Square_Meters
ORDER BY TotalRevenue DESC;

-- Geographical Analysis
SELECT Country, SUM(Unit_Price_USD * Quantity) AS TotalRevenue
FROM joineddata
GROUP BY Country
ORDER BY TotalRevenue DESC;



