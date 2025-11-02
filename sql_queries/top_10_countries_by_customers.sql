-- ================================================
-- Rockbuster SQL Analysis
-- Query: Top 10 countries where Rockbuster customers are based
-- ================================================

SELECT 
    D.country,
    COUNT(A.customer_id) AS customer_count
FROM customer A
INNER JOIN address B ON A.address_id = B.address_id
INNER JOIN city C ON B.city_id = C.city_id
INNER JOIN country D ON C.country_id = D.country_id
GROUP BY D.country
ORDER BY customer_count DESC
LIMIT 10;

-- This query identifies the top 10 countries where Rockbuster’s customers are located,
-- helping the company understand key geographic markets.
