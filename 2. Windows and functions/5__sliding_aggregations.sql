-- Есть таблица доходов-расходов expenses. 
--Мы хотим рассчитать скользящее среднее по доходам за предыдущий и текущий месяц:
select
  year, month, income,
  avg(income) over w as roll_avg
from expenses
window w as (
  order by year, month
  rows between 1 preceding and current row
)
order by year, month;


-- Вернемся к таблице employees. 
--Мы хотим посчитать фонд оплаты труда нарастающим итогом независимо для каждого департамента
select
  id, name, department, salary,
  sum(salary) over w as total
from employees
window w as (
  partition by department
  order by salary
  rows between unbounded preceding and current row
)
order by department, salary, id;
