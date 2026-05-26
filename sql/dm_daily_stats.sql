CREATE TABLE dm_daily_stats AS
WITH order_level AS (
    SELECT
        oi.order_id,
        SUM(oi.sale_price) AS revenue,
        SUM(oi.sale_price - ii.cost) AS margin
    FROM order_items oi
    JOIN inventory_items ii ON oi.inventory_item_id = ii.id
    GROUP BY oi.order_id
),
first_order AS (
    SELECT 
        user_id,
        MIN(DATE(created_at)) AS first_order_date
    FROM orders
    WHERE o.status IN ('Complete', 'Shipped')
    GROUP BY user_id
)
SELECT
    DATE(o.created_at) AS sale_date,
    u.state,
    p.category,
    COUNT(DISTINCT o.order_id) AS orders,
    COUNT(DISTINCT o.user_id) AS buyers,
    COUNT(DISTINCT CASE 
        WHEN fo.first_order_date = DATE(o.created_at) 
        THEN o.user_id END) AS new_users,
    SUM(ol.revenue) AS revenue,
    SUM(ol.margin) AS margin,
    SUM(ol.revenue) / NULLIF(COUNT(DISTINCT o.order_id), 0) AS aov
FROM orders o
JOIN order_level ol ON o.order_id = ol.order_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.id
JOIN users u ON o.user_id = u.id
JOIN first_order fo ON o.user_id = fo.user_id
WHERE o.status IN ('Complete', 'Shipped')
GROUP BY DATE(o.created_at), u.state, p.category;