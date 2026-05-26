SELECT
    brand,
    COUNT(DISTINCT product_id) AS product_count,
    SUM(revenue) AS total_revenue,
    SUM(margin) AS total_margin,
    ROUND(AVG(margin_percent)::numeric, 1) AS avg_margin_percent,
    ROUND((100.0 * SUM(margin) / NULLIF(SUM(revenue), 0))::numeric, 1) AS weighted_margin_percent
FROM dm_product_stats
WHERE brand IS NOT NULL
GROUP BY brand
HAVING SUM(revenue) > 1000
ORDER BY weighted_margin_percent DESC;