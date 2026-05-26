CREATE TABLE dm_cohorts AS
WITH first_order AS (
    SELECT 
        user_id, 
        MIN(DATE(created_at)) AS cohort_date
    FROM orders
    WHERE status IN ('Complete', 'Shipped')
    GROUP BY user_id
)
SELECT
    DATE_TRUNC('month', fo.cohort_date) AS cohort_month,
    DATE_TRUNC('month', DATE(o.created_at)) AS activity_month,
    COUNT(DISTINCT o.user_id) AS users
FROM orders o
JOIN first_order fo ON o.user_id = fo.user_id
WHERE o.status IN ('Complete', 'Shipped')
GROUP BY cohort_month, activity_month
ORDER BY cohort_month, activity_month;