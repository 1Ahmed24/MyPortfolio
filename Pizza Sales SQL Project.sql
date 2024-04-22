
select*
from pizza_sales

-- (1-KPI)
--
--
--Total revenue 
select sum(total_price) as Total_revenue
from pizza_sales

--Average Order value
select sum(total_price)/ count(distinct order_id) as Avg_Order_Value
from pizza_sales

--Total Pizzas Sold
select sum(quantity) as Total_Pizzas_sold
from pizza_sales

--Total Orders
select count(Distinct order_id) as Total_Orders
from pizza_sales

--Average Pizzas Per Order
select cast(
cast (sum(quantity) as decimal(10,2)) /
cast (count(distinct order_id)as decimal(10,2)) as decimal(10,2)) as Average_Pizzas_Per_Order
from pizza_sales


--(2-chats)
--
--
--daily trend for total orders
select DATENAME(DW, order_date) as order_day, count(distinct order_id) as total_orders_by_day
from pizza_sales
group by DATENAME(DW, order_date)

--monthly trend total orders
select DATENAME(MONTH, order_date) as Month_Name, COUNT(distinct order_id) as total_order_by_month
from pizza_sales
group by DATENAME(MONTH, order_date)
order by total_order_by_month desc

--Percentage of sales by pizza category
select pizza_category,
cast(sum(total_price)as decimal(10,2)) as Total_Sales,
cast(sum(total_price) *100 /
(select sum(total_price)
from pizza_sales)as decimal(10,2)) as total_Sales_percentage
from pizza_sales
group by pizza_category
order by total_Sales_percentage desc
-- NOTE: here i made it only show the Percsntage sales only in October
select pizza_category,
cast(sum(total_price)as decimal(10,2)) as Total_Sales,
cast(sum(total_price) *100 /
(select sum(total_price)
from pizza_sales WHERE MONTH(order_date) = 10)as decimal(10,2)) as total_Sales_percentage
from pizza_sales
WHERE MONTH(order_date) = 10
group by pizza_category
order by total_Sales_percentage desc

--Percentage of sales by pizza size
SELECT pizza_size, CAST(SUM(total_price) AS DECIMAL(10,2)) as Total_Sales,
CAST(SUM(total_price) * 100 / (SELECT SUM(total_price) from pizza_sales) AS DECIMAL(10,2)) AS total_Sales_percentage
FROM pizza_sales
GROUP BY pizza_size
ORDER BY pizza_size desc
-- NOTE: here i made it only show the percentage sales for only the second Quarter
SELECT pizza_size, CAST(SUM(total_price) AS DECIMAL(10,2)) as Total_Sales,
CAST(SUM(total_price) * 100 / (SELECT SUM(total_price) from pizza_sales 
where DATEPART(QUARTER, order_date)=2) AS DECIMAL(10,2)) AS total_Sales_percentage
FROM pizza_sales
where DATEPART(QUARTER, order_date)=2
GROUP BY pizza_size
ORDER BY pizza_size desc

--total pizzas sold by pizza category
SELECT pizza_category, SUM(quantity) as Total_Quantity_Sold
FROM pizza_sales
GROUP BY pizza_category
ORDER BY Total_Quantity_Sold DESC
-- NOTE: here i made it only shows the total pizzas sold in October
SELECT pizza_category, SUM(quantity) as Total_Quantity_Sold
FROM pizza_sales
WHERE MONTH(order_date) = 10
GROUP BY pizza_category
ORDER BY Total_Quantity_Sold DESC

--top5 pizza sellers 
select top 5 pizza_name, sum(total_price) as total_revenue
from pizza_sales
group by pizza_name
order by total_revenue desc

--bottom 5 pizza sellers
SELECT Top 5 pizza_name, SUM(total_price) AS Total_Revenue
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Revenue ASC

--top5 pizza by Quantity 
select top 5 pizza_name, sum(quantity) as total_Quantity
from pizza_sales
group by pizza_name
order by total_Quantity desc

--bottom 5 pizza by Quantity
select top 5 pizza_name, sum(quantity) as total_Quantity
from pizza_sales
group by pizza_name
order by total_Quantity asc

--Top 5 Pizzas by Total Orders
SELECT Top 5 pizza_name, COUNT(DISTINCT order_id) AS Total_Orders
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Orders DESC

--Borrom 5 Pizzas by Total Orders
SELECT Top 5 pizza_name, COUNT(DISTINCT order_id) AS Total_Orders
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Orders asc