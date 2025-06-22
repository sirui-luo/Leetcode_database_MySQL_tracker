with cte_interact as (
SELECT user_id, count(action) as inter_cnt FROM events
where action in ('like', 'comment')
group by user_id),
cte_overall as (
SELECT user_id, count(*) as tot FROM events
group by user_id
),
trans as (
select user_id, sum(quantity) as vol
from transactions
group by user_id
)
select 
    u.id, 
    inter_cnt/tot as interaction_rate, 
    1 - inter_cnt/tot as non_interaction_rate,
    vol
from cte_interact ci 
join cte_overall co using (user_id)
left join trans t using (user_id)
right join users u on u.id = co.user_id
where inter_cnt/tot is not null
order by u.id asc

-- summary of interaction_rate
-- max, min of interaction _rate and split them into two groups (high interaction_rate and low interaction_rate)
-- t.test: is there difference in avg vol of the two groups 



-- user_id(pk)
-- interaction_rate 
-- non_interaction_rate
-- count_of_transactions



with user_engagement as (
SELECT users.id,
          coalesce(count(events.action), 0) AS num_engagements
   FROM users
   LEFT JOIN EVENTS ON users.id = events.user_id
   AND events.action in ('like',
                         'comment')
   GROUP BY 1),
user_engagement_tran as (
select 
    ue.id,
    if(num_engagements > 0, 'engaged', 'not engaged') as engaged,
    coalesce(sum(t.quantity), 0) as transaction_quantity,
    coalesce(count(distinct t.id), 0) as num_transactions
from user_engagement ue
left join transactions t on ue.id = t.user_id
group by 1)
select 
    engaged,
    count(distinct id) as num_users,
    avg(transaction_quantity) AS avg_transaction_quantity,
    avg(num_transactions) as avg_num_transactions
from user_engagement_tran
group by 1
-- use Welch's t-test