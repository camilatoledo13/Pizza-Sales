SELECT *
FROM pizza_sales;

-- check duplicates

WITH duplicate_cte AS (
SELECT *, ROW_NUMBER() OVER(PARTITION BY pizza_id, order_id, pizza_name_id, quantity) AS row_num
FROM pizza_sales
)
SELECT *
FROM duplicate_cte
WHERE row_num >1
;

-- standardize data
SELECT pizza_name
FROM pizza_sales
GROUP BY pizza_name
ORDER BY pizza_name
;

SELECT pizza_category
FROM pizza_sales
GROUP BY pizza_category
ORDER BY pizza_category
;

-- exploration

SELECT pizza_name, SUM(quantity) AS total_pizza
FROM pizza_sales
GROUP BY pizza_name
ORDER BY total_pizza DESC
;

SELECT pizza_size, SUM(quantity) AS total_size
FROM pizza_sales
GROUP BY pizza_size
ORDER BY total_size DESC
;

SELECT pizza_name,  ROUND(SUM(total_price),2) AS total_sales
FROM pizza_sales
GROUP BY pizza_name
ORDER BY total_sales DESC
;

SELECT order_id, SUM(quantity) AS sum_quantity, order_date
FROM pizza_sales
GROUP BY order_id, order_date
ORDER BY sum_quantity DESC
;

-- KPIs

-- Total Revenue
SELECT ROUND(SUM(total_price),2) AS total_sales
FROM pizza_sales
;

-- Average Order Value
SELECT ROUND(SUM(total_price)/COUNT(DISTINCT order_id),2) AS avg_revenue_order
FROM pizza_sales
;

-- Total Pizzas Sold
SELECT SUM(quantity) AS total_pizza_sold
FROM pizza_sales
;

-- Total Orders
SELECT COUNT(DISTINCT order_id) AS total_orders
FROM pizza_sales
;

-- Average Pizzas Per Order
SELECT ROUND(SUM(quantity)/COUNT(DISTINCT order_id),1) AS avg_pizza_order
FROM pizza_sales
;

-- Daily Trend for Total Orders
SELECT 
    DAYNAME(STR_TO_DATE(order_date, '%d-%m-%Y')) AS order_day,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(COUNT(DISTINCT order_id)*100/SUM(COUNT(DISTINCT order_id)) OVER(),2) AS pct_day
FROM pizza_sales
GROUP BY order_day
ORDER BY total_orders DESC ;

-- Daily Trend for Total Orders

WITH monthly AS (
	SELECT MONTHNAME(str_to_date(order_date, '%d-%m-%Y')) AS month_name,
    COUNT(DISTINCT order_id) as total_orders
	FROM pizza_sales
GROUP BY month_name
)
SELECT month_name, total_orders, ROUND(total_orders * 100 / SUM(total_orders) OVER (),2) AS pct_orders
FROM monthly
ORDER BY total_orders DESC
;

-- % of Sales by Pizza Category
SELECT pizza_category, ROUND(SUM(total_price),2) AS total_sales, ROUND(SUM(total_price) * 100 / (SELECT SUM(total_price) FROM pizza_sales),2) AS PCT
FROM pizza_sales
GROUP BY pizza_category
;

-- same as:
SELECT 
  pizza_category,
 ROUND( SUM(total_price),2) AS total_sales,
 ROUND ( SUM(total_price) * 100.0 / SUM(SUM(total_price)) OVER(),2) AS pct
FROM pizza_sales
GROUP BY pizza_category
ORDER BY PCT DESC
;

-- % of Sales by Pizza Size

SELECT	pizza_size, 
		ROUND(SUM(total_price),2) AS total_sales, 
        ROUND(SUM(total_price) * 100 / (SELECT SUM(total_price) FROM pizza_sales),2) AS PCT
FROM pizza_sales
GROUP BY pizza_size
ORDER BY PCT DESC
;

-- Total Pizzas Sold by Pizza Category

SELECT pizza_category, SUM(quantity)
FROM pizza_sales
GROUP BY pizza_category
;

-- Top 5 Pizzas by Revenue

SELECT pizza_name, SUM(total_price) AS total_sales
FROM pizza_sales
GROUP BY pizza_name
ORDER BY total_sales DESC
LIMIT 5
;

-- Bottom 5 Pizzas by Revenue

SELECT pizza_name, SUM(total_price) AS total_sales
FROM pizza_sales
GROUP BY pizza_name
ORDER BY total_sales ASC
LIMIT 5
;

-- Top 5 Pizzas by Quantity

SELECT pizza_name, SUM(quantity) AS total_sold
FROM pizza_sales
GROUP BY pizza_name
ORDER BY total_sold DESC
LIMIT 5
;

-- Bottom 5 Pizzas by Quantity

SELECT pizza_name, SUM(quantity) AS total_sold
FROM pizza_sales
GROUP BY pizza_name
ORDER BY total_sold ASC
LIMIT 5
;

-- Top 5 Pizzas by Total Orders

SELECT pizza_name, count(DISTINCT order_id) as total_orders
FROM pizza_sales
GROUP BY pizza_name
ORDER BY total_orders DESC
LIMIT 5
;

-- Bottom 5 Pizzas by Total Orders

SELECT pizza_name, count(DISTINCT order_id) as total_orders
FROM pizza_sales
GROUP BY pizza_name
ORDER BY total_orders ASC
LIMIT 5
;

SELECT *
FROM pizza_sales
;