WITH first_visit AS (
    SELECT
        user_id,
        traffic_source,
        created_at,
        ROW_NUMBER() OVER (
            PARTITION BY user_id
            ORDER BY created_at
        ) AS rn
    FROM events
)
SELECT
    traffic_source,
    COUNT(user_id) AS users
FROM first_visit
WHERE rn = 1
GROUP BY traffic_source
ORDER BY users DESC;