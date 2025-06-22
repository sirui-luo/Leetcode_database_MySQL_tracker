SELECT 
    p.product_name,
    s.date,
    sum(sold_count) over (partition by product_name order by s.date) as sales_since_last_restock
FROM products p
left join sales s using (product_id)
left join (
select 
    product_id,
    max(restock_date) as max_rd
from restocking  
group by product_id) r 
using (product_id)
where s.date >= r.max_rd