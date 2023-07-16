-- Есть таблица сотрудников employees. Мы хотим для каждого сотрудника увидеть, 
--сколько процентов составляет его зарплата от общего фонда труда по городу
select
  name, city, salary,
  sum(salary) over w as fund,
  round(salary * 100.0 / sum(salary) over w) as perc
from employees
window w as (partition by city)
order by city, salary, id;


-- Есть таблица сотрудников employees. Мы хотим для каждого сотрудника увидеть:

--сколько человек трудится в его отделе (emp_cnt);
--какая средняя зарплата по отделу (sal_avg);
--на сколько процентов отклоняется его зарплата от средней по отделу (diff)
select
  name, department, salary,
  count(*) over w as emp_cnt,
  round(avg(salary) over w) as sal_avg,
  round((salary - avg(salary) over w) * 100.0 / avg(salary) over w) as diff
from employees
window w as (partition by department)
order by department, salary, id;


-- Есть такой запрос. Что вернут столбцы x и y? (Суммарную зарплату по городу и по таблице соответственно)
select
  city,
  department,
  sum(salary) as dep_salary,
  sum(sum(salary)) over (partition by city) as x,
  sum(sum(salary)) over () as y
from employees
group by city, department
order by city, department;
