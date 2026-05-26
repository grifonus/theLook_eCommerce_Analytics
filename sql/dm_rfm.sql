CREATE TABLE dm_rfm AS
WITH max_date AS (
    SELECT
        MAX(DATE(created_at)) AS max_order_date
    FROM orders
),
user_stats AS (
    SELECT
        o.user_id,
        MAX(DATE(o.created_at)) AS last_order,
        COUNT(DISTINCT o.order_id) AS frequency,
        SUM(oi.sale_price) AS monetary
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    WHERE o.status IN ('Complete', 'Shipped')
    GROUP BY o.user_id
)
SELECT
    u.user_id,
    m.max_order_date - u.last_order AS recency,
    u.frequency,
    u.monetary,
    NTILE(5) OVER (ORDER BY m.max_order_date - u.last_order ASC) AS r_score,
    NTILE(5) OVER (ORDER BY u.frequency) AS f_score,
    NTILE(5) OVER (ORDER BY u.monetary) AS m_score
FROM user_stats u
CROSS JOIN max_date m;