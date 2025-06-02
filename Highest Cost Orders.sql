# Highest Cost Orders
# method 1
select 
    first_name,
    order_date, 
    sc as max_cost
from (
select 
    cust_id, 
    order_date, 
    sum(total_order_cost) as sc
from orders o
where order_date between '2019-02-01' and '2019-05-01'
group by cust_id, order_date) s
join customers c on c.id = s.cust_id
order by sc desc
limit 1

# method 2: 2 cte and join
WITH cte AS (
    SELECT 
        cust_id, 
        order_date, 
        SUM(total_order_cost) AS sc
    FROM orders o
    WHERE order_date BETWEEN '2019-02-01' AND '2019-05-01'
    GROUP BY cust_id, order_date
),
max_cte AS (
    SELECT MAX(sc) AS max_cost FROM cte
)
SELECT 
    c.first_name,
    cte.order_date,
    cte.sc AS max_cost
FROM cte
JOIN customers c ON c.id = cte.cust_id
JOIN max_cte ON cte.sc = max_cte.max_cost;

