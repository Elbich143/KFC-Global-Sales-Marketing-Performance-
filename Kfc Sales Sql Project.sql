create database KFC_Sales;
use KFC_Sales;

Select * from kfc_past_sales_dataset;

SELECT Country, COUNT(Country) AS Total_Country
FROM kfc_past_sales_dataset
GROUP BY Country;

-- Which Country Has The Maximum Number of Sales :-
select Country,  Sum(Sales) As Total_Sales
From kfc_past_sales_dataset
group by Country
order by Total_Sales;


-- Top 5 Branches:- Out of 5 Branches  4 Branches are from India
select Branch_Id, Country, sum(Sales) As Total_Sales
from kfc_past_sales_dataset
group by Branch_ID, Country
order by Total_Sales
Limit 5;


-- Monthly Sales Trend:
Select Year, Month, Country, sum(Sales) As Monthly_Sales 
From kfc_past_sales_dataset
group by Year, Month, Country
order by Year, Month;



-- MArketing ROI:- So India Has The Maximum Number of ROI
SELECT 
    Country,
    SUM(Sales) / SUM(Marketing_Spend) AS ROI
FROM kfc_past_sales_dataset
GROUP BY Country
ORDER BY ROI DESC;


-- Sales Per Customer:-
SELECT 
    country,
    SUM(Sales) / SUM(Customers) As Sales_Per_Customer
FROM kfc_past_sales_dataset
GROUP BY Country
ORDER BY Sales_Per_Customer;


-- Corelation Insights:- 
SELECT  Country, Sales, Marketing_Spend
FROM kfc_past_sales_dataset;
    

-- Year Wise Growth Rate:- It shows the business growth trend
SELECT 
    Year,
    SUM(Sales) AS Total_Sales,
    LAG(SUM(Sales)) OVER (ORDER BY Year) AS Previous_Year_Sales,
    ROUND(
        (SUM(Sales) - LAG(SUM(Sales)) OVER (ORDER BY Year)) * 100.0 
        / LAG(SUM(Sales)) OVER (ORDER BY Year), 2
    ) AS Growth_Percentage
FROM kfc_past_sales_dataset
GROUP BY Year;


-- Top Performance Branch by country:- It identifies the beat branch each country
SELECT *
FROM (
    SELECT 
        Country,
        Branch_ID,
        SUM(Sales) AS Total_Sales,
        RANK() OVER (PARTITION BY Country ORDER BY SUM(Sales) DESC) AS Rank_No
    FROM kfc_past_sales_dataset
    GROUP BY Country, Branch_ID
) t
WHERE Rank_No = 1;



-- Month With Heighest sale per year :-
SELECT *
FROM (
    SELECT 
        Year,
        Month,
        SUM(Sales) AS Monthly_Sales,
        RANK() OVER (PARTITION BY Year ORDER BY SUM(Sales) DESC) AS Rank_No
    FROM kfc_past_sales_dataset
    GROUP BY Year, Month
) t
WHERE Rank_No = 1;



-- Customer Segmentation :- This is Godd For Story telling 
SELECT 
	Branch_ID, Sum(Sales) As Total_Sale,
    CASE 
		WHEN Sum(Sales) > 100000 THEN 'High Value'
		WHEN Sum(Sales) BETWEEN 50000 AND 100000 THEN 'Medium Value'
		ELSE 'Low Value'
	END as Category
FROM kfc_past_sales_dataset
GROUP BY Branch_ID;


-- Moving Average: - Sales Trend Smothenning
SELECT 
	 Year, Month, Sum(Sales) AS Total_MonthlySales,
     AVG(SUM(Sales)) OVER (
        ORDER BY Year, Month 
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS Moving_Avg
FROM kfc_past_sales_dataset
GROUP BY Year, Month;