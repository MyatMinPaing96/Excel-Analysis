-- KPI's -- 

-- 1. Total Revenue:
-- 2. Average Order Value
-- 3. Total Pizzas Sold
-- 4. Total Orders
-- 5. Average Pizzas Per Order

-- -------------------------------------------
-- 1. Total Revenue:

SELECT SUM(total_price) AS Total_Revenue 
FROM pizza_sales;

-- 2. Average Order Value

SELECT (SUM(total_price) / COUNT(DISTINCT order_id)) AS Avg_order_Value 
FROM pizza_sales;

-- 3. Total Pizzas Sold

SELECT SUM(quantity) AS Total_pizza_sold 
FROM pizza_sales;

-- 4. Total Orders

SELECT COUNT(DISTINCT order_id) AS Total_Orders 
FROM pizza_sales;

-- 5. Average Pizzas Per Order

SELECT ROUND(SUM(quantity)/COUNT(DISTINCT order_id), 1)
FROM pizza_sales;

-- -----------------------------------------------------------------

DESCRIBE pizza_sales;

ALTER TABLE pizza_sales
ADD COLUMN orderdate DATE;

UPDATE pizza_sales
SET orderdate = str_to_date(order_date,'%d/%m/%Y');

-- Drop Old Column

ALTER TABLE pizza_sales
DROP COLUMN order_date; 

-- Add a column for days_name

ALTER TABLE pizza_sales
ADD COLUMN day_names VARCHAR(20);

UPDATE pizza_sales
SET day_names = dayname(orderdate);

-- DAILY TREND FOR TOTAL ORDER

SELECT day_names , COUNT(DISTINCT order_id) AS Total_Order
FROM pizza_sales
GROUP BY day_names 
ORDER BY Total_Order DESC;

-- -----------------------------------------------------------------
--  Hourly Trend for Orders

SELECT hour(order_time) as order_hour,COUNT(DISTINCT order_id) AS Total_order
FROM pizza_sales
GROUP BY order_hour;

-- -----------------------------------------------------------------

-- % of Sales by Pizza Category

SELECT pizza_category,
ROUND(SUM(total_price),2) AS Total_Sales,
ROUND((SUM(total_price) * 100) / (SELECT SUM(total_price) FROM pizza_sales), 2) As PCT
FROM pizza_sales
GROUP BY pizza_category;


-- % of Sales by Pizza Size

SELECT pizza_size,
ROUND(SUM(total_price),2) AS Total_Sales,
ROUND((SUM(total_price) * 100) / (SELECT SUM(total_price) FROM pizza_sales), 2) As PCT
FROM pizza_sales
GROUP BY pizza_size;


-- Total Pizzas Sold by Pizza Category

SELECT pizza_category,
SUM(quantity) as Total_Quantity
FROM pizza_sales
GROUP BY pizza_category;

-- --------------------------------------------------

-- Top 5 Best Sellers by Total Pizzas Sold

SELECT pizza_name,
SUM(quantity) as Total_Quantity
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Quantity DESC
LIMIT 5;

-- Bottom 5 Best Sellers by Total Pizzas Sold

SELECT pizza_name,
SUM(quantity) as Total_Quantity
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Quantity ASC
LIMIT 5;
