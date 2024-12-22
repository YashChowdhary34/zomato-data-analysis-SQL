SELECT * FROM customers;
SELECT * FROM restaurants;
SELECT * FROM orders;
SELECT * FROM riders;
SELECT * FROM deliveries;

SELECT COUNT(*) FROM customers
WHERE customer_id IS NULL
	OR 
    customer_name IS NULL
    OR 
    reg_date IS NULL;

SELECT COUNT(*) FROM restaurants
WHERE restaurant_id IS NULL
	OR 
    restaurant_name IS NULL
    OR 
    city IS NULL
    OR 
    opening_hours IS NULL;
    
SELECT COUNT(*) FROM restaurants
WHERE restaurant_id IS NULL
	OR 
    restaurant_name IS NULL
    OR 
    city IS NULL
    OR 
    opening_hours IS NULL;

SELECT COUNT(*) FROM orders
WHERE order_item IS NULL
	OR 
    order_date IS NULL
    OR 
    order_time IS NULL
    OR 
    order_status IS NULL
    OR 
    total_amount IS NULL;

