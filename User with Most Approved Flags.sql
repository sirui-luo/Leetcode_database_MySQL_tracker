with cte_f as (
select 
    concat(user_firstname, ' ', user_lastname) as name,
    u.flag_id,
    video_id,
    reviewed_outcome
from user_flags u
join flag_review f using (flag_id)),
cte_r as 
(select 
    name,
    count(distinct video_id) as cnt,
    dense_rank() over (order by count(distinct video_id) desc) as rnk
from cte_f
where reviewed_outcome = 'Approved'
group by name)
select name from cte_r where rnk = 1
