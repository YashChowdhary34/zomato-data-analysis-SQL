-- Analysis & Reports

-- 1. Write a query to find the top 5 most frequently ordered dishes by customer called "Christopher Watkins"
-- in the last 1 year.

SELECT 
	customers.customer_id,
    customers.customer_name,
    orders.order_item AS dishes,
    COUNT(*) AS total_orders,
    (CURRENT_DATE - orders.order_date) AS days_since_last_ordered
FROM orders 
JOIN 
customers 
ON orders.customer_id = customers.customer_id
WHERE
	orders.order_date >= CURRENT_DATE - INTERVAL 1 YEAR -- DATE_SUB('2015-04-22", INTERVAL 10 DAY)
GROUP BY 
	customers.customer_id,
	customers.customer_name,
    orders.order_item

