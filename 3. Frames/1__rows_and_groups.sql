-- Есть таблица сотрудников employees. Напишите запрос, который для каждого сотрудника выведет:
--   размер з/п предыдущего по зарплате сотрудника (среди коллег по департаменту);
--   максимальную з/п по департаменту.
select
  id, name, department, salary,
  min(salary) over w as prev_salary,
  max(salary) over w as max_salary
from employees
window w as (
  partition by department
  order by salary
  rows between 1 preceding and unbounded following
)
order by department, salary, id;


-- Есть таблица сотрудников employees. Для каждого человека мы хотим посчитать количество сотрудников,
-- которые получают такую же или большую зарплату (ge_cnt)
select
  id, name, salary,
  count(*) over w as ge_cnt
from employees
window w as (
  order by salary
  groups between current row and unbounded following
)
order by salary, id;


-- Есть таблица сотрудников employees. Для каждого человека мы хотим увидеть ближайшую большую зарплату (next_salary)
select
  id, name, salary,
  first_value(salary) over w as next_salary
from employees
window w as (
  order by salary
  groups between 1 following and 1 following
)
order by salary, id;
