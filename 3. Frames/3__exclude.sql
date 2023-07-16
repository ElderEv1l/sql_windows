-- Есть таблица сотрудников employees. Предположим, 
--для каждого человека мы хотим посчитать среднюю зарплату сотрудников, 
--которые получают столько же или больше, чем он — но не более чем +20 тыс. ₽ (p20_sal). 
--При этом зарплату самого сотрудника учитывать не следует
select
  id, name, salary,
  round(avg(salary) over w) as p20_sal
from employees
window w as (
  order by salary
  range between current row and 20 following
  exclude current row
)
order by salary, id;
