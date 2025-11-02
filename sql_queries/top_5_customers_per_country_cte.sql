-- ================================================
-- Rockbuster SQL Analysis
-- Query: How many of the top 5 customers are based within each country (CTE version)
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
    country.country,
    COUNT(DISTINCT customer.customer_id) AS all_customer_count,
    COUNT(DISTINCT top_5_customers.customer_id) AS top_customer_count
FROM customer
JOIN address ON customer.address_id = address.address_id
JOIN city ON address.city_id = city.city_id
JOIN country ON city.country_id = country.country_id
LEFT JOIN top_5_customers
    ON top_5_customers.country = country.country
GROUP BY 
    country.country
ORDER BY 
    all_customer_count DESC;

-- This query uses a Common Table Expression (CTE) to identify the top 5 
-- customers by total amount paid, then compares those customers across 
-- all countries to see how many are based within each one. 
-- It provides insight into which markets hold Rockbuster's most valuable customers.
