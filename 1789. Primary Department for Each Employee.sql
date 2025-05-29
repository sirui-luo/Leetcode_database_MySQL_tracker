# method 1: using cte
with cte_n as (
select 
    row_number() over (partition by employee_id order by employee_id) as num,
    employee_id,
    department_id,
    primary_flag
from Employee e)
select 
    employee_id,
    department_id
from cte_n
group by employee_id
having max(num) = 1
union all
select 
    employee_id,
    department_id
from cte_n
where primary_flag = 'Y'
order by employee_id asc;

# method 2: where, or
select employee_id, department_id from Employee
where primary_flag = 'Y' or
employee_id in (
    select employee_id from Employee
    group by employee_id
    having count(*) = 1
)