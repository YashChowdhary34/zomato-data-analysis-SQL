# Zomato Data Analysis - SQL

![Zomato_logo](https://github.com/user-attachments/assets/18a9229f-5b67-48c6-8ed2-6644954544ae)

## Project Overview

This repository showcases a comprehensive **data analysis project** for a Zomato-like food delivery platform, aimed at solving real-world business problems using SQL. 

The dataset used in this project is **realistic and tailored to reflect the operations of an Indian food delivery company**. It contains:
- **5 tables**: Customers, Restaurants, Orders, Riders, and Deliveries.
- **Over 5,000 records**, including customer demographics, restaurant information, orders, deliveries, and more.

The database was built and queried using **MySQL**, and the analyses cover a wide range of **business problems specific to Zomato’s operations**.

---

## Key Business Problems Solved

This project demonstrates the ability to analyze and provide actionable insights into real-world business challenges. Some of the specific analyses performed include:

1. **Top Ordered Dishes**: Finding the top 5 most frequently ordered dishes by specific customers (e.g., Arjun Mehta) over the last year.
2. **Popular Time Slots**: Identifying the most active time slots (2-hour intervals) for placing orders.
3. **Order Value Analysis**: Calculating the average order value (AOV) for high-volume customers.
4. **High-Value Customers**: Identifying customers who have spent over ₹100,000 on the platform.
5. **Orders Without Deliveries**: Analyzing undelivered orders by city and restaurant.
6. **Restaurant Revenue Rankings**: Ranking restaurants based on total revenue generated.
7. **Rider Performance Metrics**:
   - Finding the most active riders.
   - Identifying riders generating the most revenue.
   - Calculating the average delivery time for each rider.
8. **Cancellation Rate Comparison**: Comparing cancellation rates across different restaurants and customers.
9. **Monthly Growth Rates**: Measuring the monthly growth rate of restaurants on the platform.

These insights provide actionable recommendations for business decisions like customer retention, operational efficiency, and revenue optimization.

---

## ER Diagram

Below is the ER diagram for the project, which outlines the relationships between the tables in the database:

![ER_diagram](https://github.com/user-attachments/assets/25012be6-a913-48f0-93fc-b9c614ea28f6)

---

## Tech Stack

- **Database**: MySQL
- **Languages**: SQL
- **Tools**: MySQL Workbench, DataGrip (optional for visualization)

---

## Dataset Overview

The dataset contains the following tables and attributes:

### 1. **Customers**
| Column Name   | Data Type | Description                     |
|---------------|-----------|---------------------------------|
| `customer_id` | INT       | Unique ID for each customer    |
| `customer_name` | VARCHAR  | Name of the customer           |
| `reg_date`    | DATE      | Registration date of the customer |

### 2. **Restaurants**
| Column Name       | Data Type | Description                         |
|-------------------|-----------|-------------------------------------|
| `restaurant_id`   | INT       | Unique ID for each restaurant       |
| `restaurant_name` | VARCHAR   | Name of the restaurant              |
| `city`            | VARCHAR   | City where the restaurant is located|
| `opening_hours`   | VARCHAR   | Operating hours of the restaurant   |

### 3. **Orders**
| Column Name       | Data Type | Description                             |
|-------------------|-----------|-----------------------------------------|
| `order_id`        | INT       | Unique ID for each order                |
| `customer_id`     | INT       | ID of the customer who placed the order |
| `restaurant_id`   | INT       | ID of the restaurant fulfilling the order|
| `order_item`      | VARCHAR   | Name of the ordered item                |
| `order_date`      | DATE      | Date when the order was placed          |
| `order_time`      | TIME      | Time when the order was placed          |
| `order_status`    | VARCHAR   | Status of the order (e.g., Delivered)   |
| `total_amount`    | FLOAT     | Total amount paid for the order         |

### 4. **Riders**
| Column Name   | Data Type | Description                  |
|---------------|-----------|------------------------------|
| `rider_id`    | INT       | Unique ID for each rider     |
| `rider_name`  | VARCHAR   | Name of the rider            |
| `sign_up`     | DATE      | Date when the rider signed up|

### 5. **Deliveries**
| Column Name      | Data Type | Description                               |
|------------------|-----------|-------------------------------------------|
| `delivery_id`    | INT       | Unique ID for each delivery               |
| `order_id`       | INT       | ID of the order being delivered           |
| `delivery_status`| VARCHAR   | Status of the delivery (e.g., Completed)  |
| `delivery_time`  | TIME      | Time taken to deliver the order           |
| `rider_id`       | INT       | ID of the rider handling the delivery     |

---

## Conclusion

This project demonstrates the effective use of SQL for data analysis in a food delivery platform context. 
By solving practical business challenges, it provides a foundation for making data-driven decisions to improve customer satisfaction, 
operational efficiency, and revenue growth.
