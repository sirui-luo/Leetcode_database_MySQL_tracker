-- method 1: cte
with cte_cnt as (
select 
    user_id, 
    year(created_at) as yr, 
    count(*) as cnt 
from transactions
group by user_id, year(created_at))
select name as customer_name from cte_cnt as cc1
join cte_cnt as cc2 using (user_id)
join users u on u.id = cc1.user_id
where (cc1.cnt >= 3 and cc1.yr = 2019) and (
cc2.cnt >= 3 and cc2.yr = 2020)

-- method 2: grouping by user (u.id), one user has only one row
SELECT u.name AS customer_name
FROM transactions t
JOIN users u ON t.user_id = u.id
GROUP BY u.id
HAVING 
    SUM(CASE WHEN YEAR(t.created_at) = 2019 THEN 1 ELSE 0 END) > 3
    AND 
    SUM(CASE WHEN YEAR(t.created_at) = 2020 THEN 1 ELSE 0 END) > 3
;

-- method 3: distinct bc of group by id and year, one user has multiple rows (each year one row)
SELECT distinct u.name AS customer_name
FROM transactions t
JOIN users u ON t.user_id = u.id
group by t.user_id, year(t.created_at)
having
    count(case when year(t.created_at) = 2019 then 1 else 0 end) > 3
    and
    count(case when year(t.created_at) = 2020 then 1 else 0 end) > 3