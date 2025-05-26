-- method 1: filtered out person without 'free_trial' and 'paid'
with cte_f as (
select 
    user_id, 
    avg(activity_duration) trial_avg_duration
from UserActivity
where activity_type = 'free_trial'
group by user_id),
cte_p as (
select 
    user_id, 
    avg(activity_duration) paid_avg_duration
from UserActivity
where activity_type = 'paid'
group by user_id
)
select cf.user_id, round(trial_avg_duration, 2) as trial_avg_duration, round(paid_avg_duration, 2) as paid_avg_duration
from cte_f cf
join cte_p cp using (user_id);

-- method 2: use case when - Users without any paid activity will get NULL for paid_avg_duration.
with cte_f as (
    select 
        user_id,
        avg(case when activity_type = 'free_trial' then activity_duration end) as trial_avg_duration
from UserActivity
group by user_id)
select ua.user_id, round(trial_avg_duration, 2) as trial_avg_duration, round(avg(case when activity_type = 'paid' then activity_duration end), 2) as paid_avg_duration
from UserActivity ua
join cte_f using (user_id)
group by ua.user_id
having paid_avg_duration is not null -- manually filter out