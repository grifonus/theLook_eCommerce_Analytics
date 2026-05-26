WITH revenue_share AS (
    SELECT
        category,
        SUM(revenue) AS revenue,
        SUM(SUM(revenue)) OVER () AS total_revenue,
        SUM(SUM(revenue)) OVER (
            ORDER BY SUM(revenue) DESC
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS cumulative_revenue
    FROM dm_product_stats
    GROUP BY category
)
SELECT
    category,
    revenue,
    ROUND((100.0 * revenue / total_revenue)::numeric, 1) AS revenue_percent,
    ROUND((100.0 * cumulative_revenue / total_revenue)::numeric,1) AS cumulative_percent,
    CASE
        WHEN cumulative_revenue <= 0.80 * total_revenue THEN 'A'
        WHEN cumulative_revenue <= 0.95 * total_revenue THEN 'B'
        ELSE 'C'
    END AS abc_category
FROM revenue_share
ORDER BY revenue DESC;