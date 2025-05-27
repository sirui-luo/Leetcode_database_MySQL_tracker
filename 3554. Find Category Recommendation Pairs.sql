with ca as (
select 
    distinct user_id,
    category
from ProductPurchases pp
join ProductInfo `pi` using (product_id)),
pair as (
select ca.user_id, ca.category as category1, ca1.category as category2
from ca
join ca as ca1 
on ca.user_id = ca1.user_id and ca.category < ca1.category)
select category1, category2, count(*) as customer_count from pair 
group by category1, category2
having customer_count >= 3
order by customer_count desc, category1, category2