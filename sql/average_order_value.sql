CREATE TABLE dm_aov AS
SELECT
    DATE(o.created_at) AS sale_date,
    COUNT(DISTINCT o.order_id) AS orders,
    SUM(oi.sale_price) AS revenue,
    ROUND(
        SUM(oi.sale_price)::numeric 
        / NULLIF(COUNT(DISTINCT o.order_id), 0),
        2
    ) AS aov
FROM orders o
JOIN order_items oi 
    ON o.order_id = oi.order_id
WHERE o.status IN ('Complete', 'Shipped')
GROUP BY DATE(o.created_at)
ORDER BY sale_date;