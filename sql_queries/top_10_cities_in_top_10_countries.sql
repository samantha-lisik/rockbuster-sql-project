-- ================================================
-- Rockbuster SQL Analysis
-- Query: Top 10 cities that fall within the top 10 countries by customer count
-- ================================================

SELECT 
    ci.city AS city,
    co.country AS country,
    COUNT(c.customer_id) AS customer_count
FROM customer c
INNER JOIN address a ON c.address_id = a.address_id
INNER JOIN city ci ON a.city_id = ci.city_id
INNER JOIN country co ON ci.country_id = co.country_id
WHERE co.country IN (
    SELECT 
        co2.country
    FROM customer c2
    INNER JOIN address a2 ON c2.address_id = a2.address_id
    INNER JOIN city ci2 ON a2.city_id = ci2.city_id
    INNER JOIN country co2 ON ci2.country_id = co2.country_id
    GROUP BY co2.country
    ORDER BY COUNT(c2.customer_id) DESC
    LIMIT 10
)
GROUP BY ci.city, co.country
ORDER BY customer_count DESC
LIMIT 10;

-- This query identifies the top 10 cities located within the top 10 countries 
-- by Rockbuster’s customer count, providing insights into high-concentration customer areas.
