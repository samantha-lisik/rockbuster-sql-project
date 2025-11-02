-- ================================================
-- Rockbuster SQL Analysis
-- Query: Finding the average amount paid by the top 5 customers (CTE version)
-- ================================================

WITH top_5_customers AS (
    SELECT 
        c.customer_id,
        c.first_name,
        c.last_name,
        country.country,
        city.city,
        SUM(p.amount) AS total_amount_paid
    FROM customer c
    JOIN payment p ON c.customer_id = p.customer_id
    JOIN address a ON c.address_id = a.address_id
    JOIN city ON a.city_id = city.city_id
    JOIN country ON city.country_id = country.country_id
    WHERE city.city IN (
        SELECT city.city
        FROM customer
        INNER JOIN address ON customer.address_id = address.address_id
        INNER JOIN city ON address.city_id = city.city_id
        INNER JOIN country ON city.country_id = country.country_id
        WHERE country.country IN (
            SELECT country.country
            FROM customer
            INNER JOIN address ON customer.address_id = address.address_id
            INNER JOIN city ON address.city_id = city.city_id
            INNER JOIN country ON city.country_id = country.country_id
            GROUP BY country.country
            ORDER BY COUNT(customer.customer_id) DESC
            LIMIT 10
        )
        GROUP BY city.city, country.country
        ORDER BY COUNT(customer.customer_id) DESC
        LIMIT 10
    )
    GROUP BY 
        c.customer_id, c.first_name, c.last_name, country.country, city.city
    ORDER BY 
        total_amount_paid DESC
    LIMIT 5
)
SELECT 
    AVG(total_amount_paid) AS average
FROM 
    top_5_customers;

-- This version of the query uses a Common Table Expression (CTE) 
-- to make the logic more modular and easier to read. 
-- It calculates the average total amount paid by the top 5 customers 
-- across the top 10 cities and countries, providing insight into 
-- high-value customer spending behavior.
