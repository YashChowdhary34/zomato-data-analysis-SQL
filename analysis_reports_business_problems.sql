-- Analysis & Reports

-- 1. Write a query to find the top 5 most frequently ordered dishes by customer called "Arjun Mehta"
-- in the last 1 year.

SELECT *
FROM 
(
	SELECT 
		customers.customer_id,
		customers.customer_name,
		orders.order_item AS dishes,
		COUNT(*) AS total_orders,
		DENSE_RANK() OVER(ORDER BY COUNT(*) DESC) AS ranking,
		DATEDIFF(CURRENT_DATE, MAX(orders.order_date)) AS days_since_last_ordered
	FROM orders 
	JOIN 
	customers 
	ON orders.customer_id = customers.customer_id
	WHERE
		orders.order_date >= CURRENT_DATE - INTERVAL 1 YEAR -- DATE_SUB('2015-04-22', INTERVAL 10 DAY)
		AND
		customers.customer_name = 'Arjun Mehta'
	GROUP BY 
		customers.customer_id,
		customers.customer_name,
		orders.order_item
	ORDER BY 1, 4 DESC
) AS t1
WHERE ranking <= 5;

-- 2. Popular Time Slots
-- Identify the time slots during which the most orders are placed, based on 2-hour intervals.

SELECT
	CASE
		WHEN EXTRACT(HOUR FROM order_time) BETWEEN 0 AND 1 THEN '00:00 - 02:00' -- 00:59:59am extract - 0 and 01:59:59am - 1 
		WHEN EXTRACT(HOUR FROM order_time) BETWEEN 2 AND 3 THEN '02:00 - 04:00'
        WHEN EXTRACT(HOUR FROM order_time) BETWEEN 4 AND 5 THEN '04:00 - 06:00'
        WHEN EXTRACT(HOUR FROM order_time) BETWEEN 6 AND 7 THEN '06:00 - 08:00'
        WHEN EXTRACT(HOUR FROM order_time) BETWEEN 8 AND 9 THEN '08:00 - 10:00'
        WHEN EXTRACT(HOUR FROM order_time) BETWEEN 10 AND 11 THEN '10:00 - 12:00'
        WHEN EXTRACT(HOUR FROM order_time) BETWEEN 12 AND 13 THEN '12:00 - 14:00'
        WHEN EXTRACT(HOUR FROM order_time) BETWEEN 14 AND 15 THEN '14:00 - 15:00'
        WHEN EXTRACT(HOUR FROM order_time) BETWEEN 16 AND 17 THEN '16:00 - 18:00'
        WHEN EXTRACT(HOUR FROM order_time) BETWEEN 18 AND 19 THEN '18:00 - 20:00'
        WHEN EXTRACT(HOUR FROM order_time) BETWEEN 20 AND 21 THEN '20:00 - 22:00'
        WHEN EXTRACT(HOUR FROM order_time) BETWEEN 22 AND 23 THEN '22:00 - 00:00'
	END AS time_slot,
    COUNT(order_id) AS order_count
FROM Orders
GROUP BY time_slot
ORDER BY order_count DESC;  

SELECT 
	FLOOR(EXTRACT(HOUR FROM order_time)/2)*2 AS start_time, -- will floor the time value giving the starting time
    FLOOR(EXTRACT(HOUR FROM order_time)/2)*2 + 2 AS end_time, -- add 2 to the floor value so that now it's in 2 hour interval range
    COUNT(*) AS total_orders
FROM orders
GROUP BY 1, 2
ORDER BY 3 DESC;

-- 3. Order Value Analysis
-- Find the average order value per customer who has placed more that 750 orders.
-- return customer_name, and aov(average order value)

SELECT 
	customers.customer_name,
    AVG(orders.total_amount) AS average_order_value
FROM orders 
JOIN
customers
ON orders.customer_id = customers.customer_id
GROUP BY 1
HAVING COUNT(orders.order_id) > 5;

-- 4. High-Value Customers
-- List the customers who have spent more than 100k in total on food orders
-- return customer_name and customer_id

SELECT 
	orders.customer_id,
    customers.customer_name
FROM orders
JOIN
customers
ON orders.customer_id = customers.customer_id
GROUP BY 1, 2
HAVING SUM(orders.total_amount) > 250;

-- 5. Orders without delivery
-- write a query to find orders that were placed but not delivered
-- return each restaurant name, city and number of not delivered orders

SELECT 
	restaurants.restaurant_name,
    restaurants.city,
    COUNT(*) AS num_not_delivered_orders
FROM orders
LEFT JOIN 
restaurants 
ON orders.restaurant_id = restaurants.restaurant_id
LEFT JOIN
deliveries 
ON orders.order_id = deliveries.order_id
WHERE deliveries.delivery_id IS NULL
GROUP BY 1, 2;

SELECT
	restaurants.restaurant_name,
    restaurants.city,
    COUNT(*) AS num_not_delivered_orders
FROM orders
LEFT JOIN
restaurants
ON orders.restaurant_id = restaurants.restaurant_id
WHERE orders.order_id NOT IN (SELECT order_id FROM deliveries)
GROUP BY 1, 2;

-- 6. Restaurant Revenue Ranking
-- Rank restaurants by their total revenue from the last year, including their name
-- total revenue, and rank within their city

WITH ranking_table
AS 
	(SELECT 
		restaurants.restaurant_id,
		restaurants.restaurant_name,
		restaurants.city,
		ROUND(SUM(orders.total_amount), 2) AS total_revenue,
		RANK() OVER(PARTITION BY restaurants.city ORDER BY SUM(orders.total_amount) DESC) AS city_rank,
		RANK() OVER(ORDER BY SUM(orders.total_amount) DESC) AS overall_rank
	FROM orders 
	JOIN
	restaurants 
	ON orders.restaurant_id = restaurants.restaurant_id
	WHERE orders.order_date >= DATE_SUB(CURRENT_DATE, INTERVAL 1 YEAR)
	GROUP BY 1, 2
	ORDER BY total_revenue DESC
	)

-- we can't filter the rank column in this query because we are using window function so use CTEs
SELECT *
FROM ranking_table
WHERE city_rank <= 10;

-- 7. Most popular dish by city
-- identify the most popular dish in each city based on the number of orders

SELECT *
FROM 
	(SELECT 
		restaurants.city,
		orders.order_item,
		COUNT(*) AS number_of_orders,
		DENSE_RANK() OVER(PARTITION BY restaurants.city ORDER BY COUNT(*) DESC) AS dish_ranking_by_city
	FROM orders
	JOIN 
	restaurants ON orders.restaurant_id = restaurants.restaurant_id
	GROUP BY 1, 2
	ORDER BY 4 ) AS popular_dish_foreach_city
WHERE dish_ranking_by_city <= 4;

-- 8. Customer Churn
-- Find customers who haven't placed an order in 2023 but did in 2022

SELECT DISTINCT customer_id FROM orders
WHERE EXTRACT(YEAR FROM order_date) = 2022
	AND
    customer_id NOT IN 
		(SELECT DISTINCT customer_id FROM orders
		WHERE EXTRACT(YEAR FROM order_date) =2023);

-- 9. Cancellation Rate Comparasion
--  calculate and compare the order's that were placed for each restaurant but not delivered 
-- between the current year and the previous year

WITH orders_curr_year AS (
    SELECT 
        orders.restaurant_id,
        COUNT(orders.order_id) AS total_orders,
        COUNT(CASE WHEN deliveries.delivery_id IS NULL THEN 1 END) AS not_delivered
    FROM orders
    LEFT JOIN deliveries ON orders.order_id = deliveries.order_id
    WHERE EXTRACT(YEAR FROM orders.order_date) = YEAR(CURDATE())
    GROUP BY orders.restaurant_id
),
orders_prev_year AS (
    SELECT 
        orders.restaurant_id,
        COUNT(orders.order_id) AS total_orders,
        COUNT(CASE WHEN deliveries.delivery_id IS NULL THEN 1 END) AS not_delivered
    FROM orders
    LEFT JOIN deliveries ON orders.order_id = deliveries.order_id
    WHERE EXTRACT(YEAR FROM orders.order_date) = YEAR(CURDATE()) - 1
    GROUP BY orders.restaurant_id
)
SELECT 
    curr.restaurant_id,
    curr.total_orders AS orders_curr_year,
    curr.not_delivered AS not_delivered_orders_curr_year,
    prev.total_orders AS orders_prev_year,
    prev.not_delivered AS not_delivered_orders_prev_year,
    (curr.not_delivered * 1.0 / curr.total_orders) * 100 AS cancellation_rate_curr_year,
    (prev.not_delivered * 1.0 / prev.total_orders) * 100 AS cancellation_rate_prev_year
FROM 
    orders_curr_year curr
LEFT JOIN 
    orders_prev_year prev ON curr.restaurant_id = prev.restaurant_id
ORDER BY 
    curr.restaurant_id;

-- 10. Rider Average Delivery Time
-- determine each rider's average delivery time

SELECT 
	d.rider_id,
    AVG(d.delivery_time - o.order_time) AS average_delivery_time -- we'll get negative values (date rollovers) which is incorrect
FROM deliveries AS d
JOIN orders AS o
ON d.order_id = o.order_id
WHERE d.delivery_status = 'Delivered'
GROUP BY 1
ORDER BY 2;

SELECT 
	d.rider_id,
    AVG(
		TIMESTAMPDIFF(
				MINUTE,
                o.order_time,
                CASE
					WHEN d.delivery_time < o.order_time THEN ADDTIME(d.delivery_time, '24:00:00')
                    ELSE d.delivery_time
				END
            )
        ) AS avg_delivery_time_mins
FROM deliveries AS d
JOIN orders AS o
ON d.order_id = o.order_id
WHERE d.delivery_status = 'Delivered'
GROUP BY 1
ORDER BY avg_delivery_time_mins;

-- 11. Monthly Restaurant Growth Ratio
-- calculate each restaurant's growth ratio based on the total number of delivered orders since its joining
-- growth ratio per month (currMonthOrders - prevMonthOrders) / prevMonthOrders  *= 100

WITH orders_per_month AS 
	(SELECT
		orders.restaurant_id,
		DATE_FORMAT(orders.order_date, '%m-%y') AS curr_order_month,
		COUNT(orders.order_id) AS curr_month_orders
	FROM orders
	JOIN deliveries ON orders.order_id = deliveries.delivery_id
	WHERE deliveries.delivery_status = 'Delivered'
	GROUP BY 1, 2),
orders_per_month_with_lag AS 
	(SELECT
		restaurant_id,
        curr_order_month,
        curr_month_orders,
        LAG(curr_month_orders, 1) OVER(PARTITION BY restaurant_id ORDER BY curr_order_month)
        AS prev_month_orders -- partition by because we want local lag specific to each restaurant
	FROM orders_per_month)
SELECT 
	restaurants.restaurant_id,
    restaurants.restaurant_name,
    opm.curr_order_month,
    ((opm.curr_month_orders - COALESCE(opm.prev_month_orders, 0)) / COALESCE(opm.prev_month_orders, 1)) * 100  AS growth_ratio
FROM orders_per_month_with_lag AS opm
JOIN restaurants ON opm.restaurant_id = restaurants.restaurant_id
WHERE opm.prev_month_orders IS NOT NULL
ORDER BY 4;

-- 12.customer segmentation
-- segment customers into 'gold' or 'silver' groups based on their total spending compared to the average order
-- value (AOV). If a customer's total spending exceeds the AOV label them 'gold' otherwise 'silver'
-- write sql query to determine each segment's total number of orders and total revenue

SELECT
	segment,
    SUM(total_spent) AS total_revenue,
    SUM(total_orders) AS total_orders
FROM
	(SELECT 
		customer_id,
		SUM(total_amount) AS total_spent,
		COUNT(order_id) AS total_orders,
		CASE
			WHEN SUM(total_amount) > (SELECT AVG(total_amount) FROM orders) THEN 'Gold'
			ELSE 'Silver'
			END AS segment
	FROM orders
	GROUP BY 1) AS t1
GROUP BY 1;

-- 13. Rider Montly Earnings
-- calculate each rider's total monthly earnings assuming they earn 8% of the order amount

SELECT
	deliveries.rider_id,
    DATE_FORMAT(orders.order_date, '%m-%y') AS month,
    ROUND(SUM(orders.total_amount) * 0.08, 3) AS monthly_earnings
FROM deliveries
JOIN
orders ON deliveries.order_id = orders.order_id
GROUP BY 1, 2
ORDER BY 1, 2, 3 DESC;

-- 14. Rider Ratings Analysis
-- Find the number of 5-star, 4-star, and 3-star ratings each rider has
-- riders receive ratings based on delivery time
-- if orders are delivered less than 15 mins of order received time then rider gets 5 star rating
-- if they deliver between 15 to 20 minutes they get 4 star rating
-- else they get 3 star rating

-- case when we need to give the rider a rating based on overall performace
SELECT 
	rider_id,
    avg_delivery_time,
    CASE 
		WHEN avg_delivery_time < 15 THEN 5
        WHEN avg_delivery_time BETWEEN 15 AND 20 THEN 4
        ELSE 3
	END AS rating
FROM
	(SELECT
		deliveries.rider_id,
		AVG(TIMESTAMPDIFF(
							MINUTE,
							orders.order_time,
							CASE
								WHEN orders.order_time > deliveries.delivery_time THEN ADDTIME(deliveries.delivery_time,
								'24:00:00')
								ELSE
								deliveries.delivery_time
							END
							)) AS avg_delivery_time
	FROM orders
	JOIN deliveries ON orders.order_id = deliveries.order_id
	WHERE deliveries.delivery_status = 'Delivered'
	GROUP BY 1) AS adt;
    
-- case where we calculate rating for each order delivered and then count the total times the rider
-- received that perticular rating

SELECT 
    rider_id,
    rating,
    COUNT(*) AS number_of_ratings
FROM (
    SELECT 
        deliveries.rider_id,
        CASE 
            WHEN TIMESTAMPDIFF(MINUTE, orders.order_time, deliveries.delivery_time) < 15 THEN 5
            WHEN TIMESTAMPDIFF(MINUTE, orders.order_time, deliveries.delivery_time) BETWEEN 15 AND 20 THEN 4
            ELSE 3
        END AS rating
    FROM orders
    JOIN deliveries ON orders.order_id = deliveries.delivery_id
    WHERE deliveries.delivery_status = 'Delivered'
) AS subquery
GROUP BY rider_id, rating
ORDER BY rider_id, rating DESC;

-- 15. Order Frequency By Day
-- analyze order frequency per day of the week and identify the peak day for each restaurant

SELECT
	restaurant_id,
    restaurant_name,
    day AS peak_day,
    num_orders
FROM 
	(SELECT 
		orders.restaurant_id,
		restaurants.restaurant_name,
		DATE_FORMAT(orders.order_date, '%W') AS day,
		COUNT(orders.order_id) AS num_orders,
		MAX(COUNT(orders.order_id)) OVER (PARTITION BY restaurants.restaurant_id) AS max_orders
	FROM orders
	JOIN restaurants ON orders.restaurant_id = restaurants.restaurant_id
	GROUP BY 1, 2, 3) AS orders_per_day
WHERE num_orders = max_orders
ORDER BY restaurant_id;
-- can also be done using rank function where we select the tuples with rank 1 in the outer query

-- 16. Customer lifetime value (CLV)
-- calculate the total revenue generated by each customer over all their orders

SELECT 
	customers.customer_id,
	customers.customer_name,
    ROUND(SUM(orders.total_amount), 2) AS CLV
FROM orders
JOIN customers ON orders.customer_id = customers.customer_id
JOIN deliveries ON orders.order_id = deliveries.order_id
WHERE deliveries.delivery_status = 'Delivered'
GROUP BY 1, 2;

-- 17. Monthly sales trends
-- identify sales trends by comparing each month's total sales to the previous month

SELECT 
	year,
    month,
    total_sale,
    LAG(total_sale, 1) OVER(ORDER BY year, month) AS prev_month_total_sale
FROM 
	(SELECT
		EXTRACT(YEAR FROM order_date) AS year,
		EXTRACT(MONTH FROM order_date) AS month,
		SUM(total_amount) AS total_sale
	FROM orders
	GROUP BY 1, 2) AS total_sale;

-- 18. Rider efficiency
-- evaluate rider efficiency by determining average delivery times and identifying those with the lowest
-- and highest average delivery times

SELECT 
    MAX(average_delivery_time) AS highest_avg_delivery_time,
    MIN(average_delivery_time) AS lowest_avg_delivery_time
FROM (SELECT 
		riders.rider_id,
		riders.rider_name,
		AVG( 
				CASE
					WHEN TIMEDIFF(orders.order_time, deliveries.delivery_time) < 0
					THEN TIMESTAMPDIFF(MINUTE, orders.order_time, ADDTIME(deliveries.delivery_time, '24:00:00'))
					ELSE TIMESTAMPDIFF(MINUTE, orders.order_time, deliveries.delivery_time)
				END
				) AS average_delivery_time
	FROM orders
	JOIN deliveries ON orders.order_id = deliveries.order_id
	JOIN riders ON deliveries.rider_id = riders.rider_id
	WHERE deliveries.delivery_status = 'Delivered'
	GROUP BY 1, 2) AS riders_avg_delivery_time;

-- 19. Order Item Popularity
-- track the popularity of specific order items over time and identify seasonal demand spikes

SELECT
	order_item,
    CASE
		WHEN EXTRACT(MONTH FROM order_date) BETWEEN 4 AND 6 THEN 'Spring'
        WHEN EXTRACT(MONTH FROM order_date) BETWEEN 7 AND 9 THEN 'Summer'
        ELSE 'Winter'
	END AS seasons,
    COUNT(order_id) AS times_ordered
FROM orders
GROUP BY 1, 2;

-- 20. Monthly restaurant growth ratio
-- calculate each restaurant's growth ratio based on the total number of delivered orders since its joining

WITH delivered_orders AS
	(SELECT 
		orders.restaurant_id,
		EXTRACT(MONTH FROM orders.order_date) AS delivery_month,
		COUNT(orders.order_id) AS orders_delivered
	FROM orders
	JOIN deliveries ON orders.order_id = deliveries.order_id
	WHERE deliveries.delivery_status = 'Delivered'
	GROUP BY 1, 2),
delivered_orders_with_lag AS
	(SELECT 
		*,
		LAG(orders_delivered, 1) OVER(PARTITION BY restaurant_id ORDER BY delivery_month) AS prev_month_orders
	FROM delivered_orders
    )
SELECT 
	restaurant_id,
    delivery_month,
    ROUND((prev_month_orders / COALESCE(orders_delivered, 1)) * 100, 2) AS growth_ratio
FROM delivered_orders_with_lag
ORDER BY 3;











