# method 1: window_function
with cte_s as (
select 
    category, 
    product_id, 
    CASE 
    WHEN MONTH(sale_date) IN (12, 1, 2) THEN 'Winter'
    WHEN MONTH(sale_date) IN (3, 4, 5) THEN 'Spring'
    WHEN MONTH(sale_date) IN (6, 7, 8) THEN 'Summer'
    WHEN MONTH(sale_date) IN (9, 10, 11) THEN 'Fall'
    END AS season, 
    quantity, 
    price
from sales s
join products p using (product_id)),
cte_rnk as 
(select 
    category, 
    season, 
    sum(quantity) as total_quantity, 
    sum(quantity*price) as total_revenue, 
    rank() over (partition by season order by sum(quantity) desc, sum(quantity*price) desc) as rnk
from cte_s
group by season, category
order by season)
select season, category, total_quantity, total_revenue from cte_rnk
where rnk = 1


# method 2: group by... choosing the first row: without aggregating other cols, MySQL picks the first row per group, based on the current ordering
WITH CTE AS (
SELECT
CASE
WHEN MONTH(sale_date) BETWEEN 3 AND 5 THEN 'Spring'
WHEN MONTH(sale_date) BETWEEN 6 AND 8 THEN 'Summer'
WHEN MONTH(sale_date) BETWEEN 9 AND 11 THEN 'Fall'
ELSE 'Winter'
END AS season,
category,
SUM(quantity) AS total_quantity,
SUM(quantity * price) AS total_revenue
from sales s
left join products p using (product_id)
group by category, season
order by season, total_quantity desc, total_revenue desc)
select * from CTE group by season 