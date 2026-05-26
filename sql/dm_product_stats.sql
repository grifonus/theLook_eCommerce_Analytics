CREATE TABLE dm_product_stats AS
WITH product_metrics AS (
    SELECT
        p.id AS product_id,
        p.name AS product_name,
        p.category,
        p.brand,
        p.retail_price,
        AVG(ii.cost) AS avg_cost, -- стоимость товара (из inventory_items)
        SUM(oi.sale_price) AS revenue, -- выручка и маржа
        SUM(oi.sale_price) - SUM(ii.cost) AS margin,
        COUNT(DISTINCT oi.order_id) AS order_count, -- количество заказов и покупателей
        COUNT(DISTINCT oi.user_id) AS buyer_count
    FROM products p
    JOIN order_items oi ON p.id = oi.product_id
    JOIN inventory_items ii ON oi.inventory_item_id = ii.id
    JOIN orders o ON oi.order_id = o.order_id
    WHERE o.status IN ('Complete', 'Shipped')
    GROUP BY p.id, p.name, p.category, p.brand, p.retail_price
)
SELECT
    product_id,
    product_name,
    category,
    brand,
    retail_price,
    ROUND(avg_cost::numeric, 2) AS avg_cost,
    revenue,
    margin,
    order_count,
    buyer_count,
    ROUND(((margin * 100) / NULLIF(revenue, 0))::numeric, 1) AS margin_percent
FROM product_metrics
ORDER BY revenue DESC;