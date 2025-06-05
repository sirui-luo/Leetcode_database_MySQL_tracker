# method 1: multiple ctes
with cte as 
(select 
    min(entry_date) min_day,
    date_add(min(entry_date), interval 6 day) min_day_plus7
from premium_accounts_by_day),
cte_d as (
select 
    account_id,
    entry_date,
    final_price,
    case when final_price <> 0 then 1 else 0 end as cnt
from premium_accounts_by_day 
cross join cte
where entry_date between min_day and min_day_plus7),
cte_cnt as (
select 
    cte_d.account_id,
    cte_d.entry_date,
    cte_d.cnt,
    case WHEN cte_d.final_price <> 0 and p.final_price <> 0 THEN 1 
    ELSE 0 
END AS cnt_7
from cte_d
left join premium_accounts_by_day p on 
p.account_id = cte_d.account_id and 
p.entry_date = date_add(cte_d.entry_date, interval 7 day))
select 
    entry_date, sum(cnt) premium_paid_accounts, sum(cnt_7) premium_paid_accounts_after_7d 
from cte_cnt
group by entry_date;

# method 2: simpler way - find active user first - 2 count + join
with premium_accounts as (
select 
    entry_date,
    account_id,
    final_price
FROM premium_accounts_by_day
WHERE final_price > 0
)
select a.entry_date,
    count(distinct a.account_id) AS premium_paid_accounts,
    COUNT(DISTINCT b.account_id) AS premium_paid_accounts_after_7d
from premium_accounts a
left join premium_accounts b 
on a.account_id = b.account_id and (b.entry_date - a.entry_date) = 7
group by a.entry_date
order by a.entry_date
limit 7;