-- ================================================
-- Rockbuster SQL Analysis
-- Query: Top 5 customers from the top 10 cities
-- ================================================

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
LIMIT 5;

-- This query lists the top 5 customers based on total payments made 
-- within the top 10 cities identified earlier. 
-- It helps Rockbuster identify high-value customers in its key markets.
