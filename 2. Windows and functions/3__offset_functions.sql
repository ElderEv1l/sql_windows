--Есть таблица сотрудников employees. Мы хотим для каждого сотрудника увидеть зарплаты предыдущего и следующего коллеги
select 
  name, department,
  lag(salary, 1) over w as prev,
  salary,
  lead(salary, 1) over w as next
from employees
window w as (order by salary, id)
order by salary, id;


--Есть таблица сотрудников employees. Мы хотим для каждого сотрудника увидеть, 
--сколько процентов составляет его зарплата от максимальной в городе
select
  name, city, salary,
  round(salary * 100.0 / last_value(salary) over w) as percent
from employees
window w as (
  partition by city
  order by salary
  rows between unbounded preceding and unbounded following
)
order by city, salary, id;
