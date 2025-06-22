WITH cte_d AS (
  SELECT 
    user_id,
    url,
    DATE(created_at) AS d,
    LAG(DATE(created_at)) OVER (
      PARTITION BY user_id, url 
      ORDER BY DATE(created_at)
    ) AS lag_d
  FROM events
),
cte_diff AS (
  SELECT *,
         DATEDIFF(d, lag_d) AS di,
         CASE 
           WHEN lag_d IS NULL OR DATEDIFF(d, lag_d) > 1 THEN 1
           ELSE 0
         END AS is_new_session
  FROM cte_d
),
cte_session_id AS (
  SELECT *,
         SUM(is_new_session) OVER (
           PARTITION BY user_id, url 
           ORDER BY d ROWS UNBOUNDED PRECEDING
         ) AS session_id
  FROM cte_diff
),
cte_numbered AS (
  SELECT *,
         ROW_NUMBER() OVER (
           PARTITION BY user_id, url, session_id 
           ORDER BY d
         ) AS counter_restart_from_1
  FROM cte_session_id
)
SELECT count(distinct user_id) / (select count(distinct user_id) from events) as percent_of_users
FROM cte_numbered
where counter_restart_from_1 = 7
