CREATE DATABASE zomato_db;
SHOW DATABASES;
USE zomato_db;

-- first create the child tables before the parent tables
DROP TABLE IF EXISTS customers;
CREATE TABLE customers (
						customer_id INT PRIMARY KEY,
                        customer_name VARCHAR(25),
                        reg_date DATE -- format YY/MM/DD
						);
                        
DROP TABLE IF EXISTS restaurants;
CREATE TABLE restaurants (
							restaurant_id INT PRIMARY KEY,
                            restaurant_name VARCHAR(55),
                            city VARCHAR(25),
                            opening_hours VARCHAR(55) -- example - 10:00 AM - 11:00 PM
						);
                        

DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
						order_id INT PRIMARY KEY,
                        customer_id INT, -- this is coming from customer table
                        restaurant_id INT, -- this is coming from restaurant table
                        order_item VARCHAR(55),
                        order_date DATE, -- 24-hour format, example - 23:59:58
                        order_time TIME,
                        order_status VARCHAR(25),
                        total_amount FLOAT
					);

DROP TABLE IF EXISTS riders;
CREATE TABLE riders (
						rider_id INT PRIMARY KEY,
                        rider_name VARCHAR(55),
                        sign_up DATE -- again the same format as before
					);

-- child to rider, orders
DROP TABLE IF EXISTS deliveries;
CREATE TABLE deliveries (
							delivery_id INT PRIMARY KEY,
                            order_id INT, -- this is coming from orders table
                            delivery_status VARCHAR(35),
                            delivery_time TIME,
                            rider_id INT, -- this is coming from riders
                            CONSTRAINT fk_orders FOREIGN KEY (order_id)
							REFERENCES orders(order_id),
                            CONSTRAINT fk_riders FOREIGN KEY (rider_id)
                            REFERENCES riders(rider_id)
						);
                        
-- adding fk constraints
ALTER TABLE orders
ADD CONSTRAINT fk_customers
FOREIGN KEY (customer_id)
REFERENCES customers(customer_id);

ALTER TABLE orders
ADD CONSTRAINT fk_restaurants
FOREIGN KEY (restaurant_id)
REFERENCES restaurants(restaurant_id);
 -- end of schemas