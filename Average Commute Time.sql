with cte_a as (
select 
    floor(avg(timestampdiff(minute, start_dt, end_dt))) as avg_time
from rides r
where city = 'NY')
select 
    commuter_id,
    floor(avg(timestampdiff(minute, start_dt, end_dt))) as avg_commuter_time,
    ca.avg_time
from rides
cross join cte_a ca
where city = 'NY'
group by commuter_id


SELECT
  a.commuter_id,
  a.avg_commuter_time,
  b.avg_time
FROM (
  SELECT
    commuter_id,
    city,
    FLOOR(AVG(TIMESTAMPDIFF(MINUTE, start_dt, end_dt))) AS avg_commuter_time
  FROM rides
  WHERE city = 'NY'
  GROUP BY commuter_id
) a
LEFT JOIN (
  SELECT
    FLOOR(AVG(TIMESTAMPDIFF(MINUTE, start_dt, end_dt))) AS avg_time,
    city
  FROM rides
  WHERE city = 'NY'
) b
ON a.city = b.city