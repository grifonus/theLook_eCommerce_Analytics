CREATE TABLE dm_delivery_returns AS
SELECT
    o.order_id,
    o.user_id,
    u.state,
    o.shipped_at,
    o.delivered_at,
    EXTRACT(EPOCH FROM (o.delivered_at - o.shipped_at)) / 3600 AS delivery_hours,
    CASE WHEN o.returned_at IS NOT NULL THEN 1 ELSE 0 END AS is_returned,
    MAX(dc.id) AS dc_id,
    MAX(dc.name) AS dc_name,
    MAX(dc.latitude) AS dc_latitude,
    MAX(dc.longitude) AS dc_longitude
FROM orders o
JOIN users u ON o.user_id = u.id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN inventory_items ii ON oi.inventory_item_id = ii.id
JOIN distribution_centers dc ON ii.product_distribution_center_id = dc.id
WHERE o.status IN ('Complete', 'Shipped')
GROUP BY o.order_id, o.user_id, u.state, o.shipped_at, o.delivered_at, o.returned_at;