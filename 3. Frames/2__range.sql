-- Есть таблица сотрудников employees. Предположим, для каждого человека мы хотим посчитать
--количество сотрудников, которые получают такую же или большую зарплату, но не более чем +10 тыс. ₽ (p10_cnt)
select
  id, name, salary,
  count(*) over w as p10_cnt
from employees
window w as (
  order by salary
  range between current row and 10 following
)
order by salary, id;


-- Есть таблица сотрудников employees. Предположим, 
--для каждого человека мы хотим определить максимальную зарплату среди тех, 
--у кого зарплата на 10–30 тыс. ₽ меньше чем у него:
select
  id, name, salary,
  max(salary) over w as lower_sal
from employees
window w as (
  order by salary
  range between 30 preceding and 10 preceding
)
order by salary, id;
