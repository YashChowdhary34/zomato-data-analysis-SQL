# Zomato Data Analysis Using SQL

<div align="center">
    <img src="https://upload.wikimedia.org/wikipedia/commons/thumb/7/75/Zomato_logo.png/320px-Zomato_logo.png" alt="Zomato Logo" height="200" width="400">
</div>

## Overview

This project involves analyzing Zomato's restaurant data using SQL to extract meaningful business insights. The dataset includes information on restaurants, locations, cuisines, ratings, and more, enabling comprehensive analysis of the food delivery market.

---

## Key Business Problems Solved

1. **[Top Cities by Number of Restaurants](#top-cities-by-number-of-restaurants)**: Identify cities with the highest number of listed restaurants.
2. **[Most Popular Cuisines](#most-popular-cuisines)**: Determine the most offered cuisines across restaurants.
3. **[Average Rating by City](#average-rating-by-city)**: Calculate the average restaurant rating for each city.
4. **[Restaurants Offering Online Delivery](#restaurants-offering-online-delivery)**: Find the percentage of restaurants providing online delivery services.
5. **[Top Rated Restaurants](#top-rated-restaurants)**: List the highest-rated restaurants overall.
6. **[Average Cost for Two by City](#average-cost-for-two-by-city)**: Analyze the average dining cost for two people in different cities.
7. **[Restaurants by Price Range](#restaurants-by-price-range)**: Categorize restaurants based on their price range.
8. **[Correlation Between Votes and Ratings](#correlation-between-votes-and-ratings)**: Examine the relationship between the number of votes and average ratings.
9. **[Top Restaurant Chains](#top-restaurant-chains)**: Identify restaurant chains with the most outlets.
10. **[Distribution of Restaurants by Rating](#distribution-of-restaurants-by-rating)**: Analyze how restaurants are distributed across different rating brackets.

---

## Objectives

- Perform exploratory data analysis on Zomato's dataset.
- Utilize SQL queries to derive actionable business insights.
- Enhance skills in data manipulation and analysis using SQL.
- Provide recommendations for business strategy based on data findings.

---

## Dataset Overview

The dataset comprises information about restaurants, including:

- **Restaurant ID**: Unique identifier for each restaurant.
- **Restaurant Name**: Name of the restaurant.
- **City**: Location city of the restaurant.
- **Address**: Physical address.
- **Locality**: Specific locality within the city.
- **Cuisines**: Types of cuisines offered.
- **Average Cost for Two**: Estimated cost for two people.
- **Currency**: Currency of the cost.
- **Has Table Booking**: Indicates if table booking is available.
- **Has Online Delivery**: Indicates if online delivery is available.
- **Is Delivering Now**: Indicates if the restaurant is currently delivering.
- **Switch to Order Menu**: Indicates if there's an option to switch to the order menu.
- **Price Range**: Price range category.
- **Aggregate Rating**: Overall average rating.
- **Rating Color**: Color code representing the rating.
- **Rating Text**: Textual representation of the rating (e.g., Excellent, Good).
- **Votes**: Number of votes received.

---

## Tech Stack Used

- **Database**: MySQL
- **Development Tool**: MySQL Workbench
- **Version Control**: Git and GitHub

---

## List of Business Problems and Solutions

### Top Cities by Number of Restaurants

```sql
SELECT
    city,
    COUNT(restaurant_id) AS number_of_restaurants
FROM restaurants
GROUP BY city
ORDER BY number_of_restaurants DESC;
```

### Most Popular Cuisines

```sql
SELECT
    cuisine,
    COUNT(restaurant_id) AS number_of_restaurants
FROM restaurant_cuisines
GROUP BY cuisine
ORDER BY number_of_restaurants DESC;
```

### Average Rating by City

```sql
SELECT
    city,
    AVG(aggregate_rating) AS average_rating
FROM restaurants
GROUP BY city
ORDER BY average_rating DESC;
```

### Restaurants Offering Online Delivery

```sql
SELECT
    city,
    COUNT(restaurant_id) AS total_restaurants,
    SUM(CASE WHEN has_online_delivery = 'Yes' THEN 1 ELSE 0 END) AS online_delivery_restaurants,
    (SUM(CASE WHEN has_online_delivery = 'Yes' THEN 1 ELSE 0 END) / COUNT(restaurant_id)) * 100 AS online_delivery_percentage
FROM restaurants
GROUP BY city
ORDER BY online_delivery_percentage DESC;
```

### Top Rated Restaurants

```sql
SELECT
    restaurant_name,
    city,
    aggregate_rating
FROM restaurants
ORDER BY aggregate_rating DESC
LIMIT 10;
```

### Average Cost for Two by City

```sql
SELECT
    city,
    AVG(average_cost_for_two) AS avg_cost_for_two
FROM restaurants
GROUP BY city
ORDER BY avg_cost_for_two DESC;
```

### Restaurants by Price Range

```sql
SELECT
    price_range,
    COUNT(restaurant_id) AS number_of_restaurants
FROM restaurants
GROUP BY price_range
ORDER BY price_range;
```

### Correlation Between Votes and Ratings

```sql
SELECT
    aggregate_rating,
    AVG(votes) AS average_votes
FROM restaurants
GROUP BY aggregate_rating
ORDER BY aggregate_rating DESC;
```

### Top Restaurant Chains

```sql
SELECT
    restaurant_name,
    COUNT(restaurant_id) AS number_of_outlets
FROM restaurants
GROUP BY restaurant_name
HAVING number_of_outlets > 1
ORDER BY number_of_outlets DESC;
```

### Distribution of Restaurants by Rating

```sql
SELECT
    aggregate_rating,
    COUNT(restaurant_id) AS number_of_restaurants
FROM restaurants
GROUP BY aggregate_rating
ORDER BY aggregate_rating DESC;
```

---

## Future Work

1. **Predictive Analysis**: Forecasting restaurant ratings based on current data.
2. **Customer Segmentation**: Analyzing customer reviews to segment the market.
3. **Geospatial Analysis**: Mapping restaurant locations to identify high-density areas.
4. **Time Series Analysis**: Studying trends in restaurant ratings over time.

---

## Conclusion

This project showcases the application of SQL in analyzing real-world datasets to extract business insights. By examining various aspects of the Zomato dataset, we've provided valuable information that can aid in strategic decision-making for stakeholders in the food delivery industry.

Feel free to explore the repository and contribute by suggesting new problems or enhancements. Happy analyzing!
