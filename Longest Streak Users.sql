with cte_d as (select 
    distinct user_id,
    date(created_at) as d
from events),
cte_dsub as (select 
    *,
    rank() over (partition by user_id order by d asc) rnk,
    date_sub(d, interval rank() over (partition by user_id order by d asc) day) as d_sub
from cte_d
order by d),
cte_cnt as (
select user_id, d_sub, count(d_sub) as cnt
from cte_dsub
group by user_id, d_sub
order by user_id, d_sub)
select max(cnt) as streak_length, user_id
from cte_cnt
group by user_id
order by streak_length desc
limit 5


-- user_id	platform 	datetime	RANK	
-- 1	A	10-Apr	1	
-- 1	A	11-Apr	2	
-- 1	A	12-Apr	3	
-- 1	A	13-Apr	4	
-- 1	B	14-Apr	1	
-- 1	B	15-Apr	2	
-- 1	B	16-Apr	3	
-- 1	C	17-Apr	1	
-- 1	C	18-Apr	2	
-- 2	A	10-Apr	1	9-Apr
-- 2	A	11-Apr	2	9-Apr
-- 2	A	12-Apr	3	9-Apr
-- 2	A	13-Apr	4	9-Apr
-- 2	A	13-Apr	4	9-Apr
-- 2	A	14-Apr	5	
-- 2	A	15-Apr	6	
