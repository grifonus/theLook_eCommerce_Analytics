SELECT
    DATE(created_at) AS event_date,
    COUNT(DISTINCT user_id) AS active_users
FROM events
GROUP BY DATE(created_at)
ORDER BY event_date;