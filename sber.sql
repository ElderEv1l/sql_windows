-- 1 Найдите среднюю зарплату каждого отдела, а также разницу между зарплатой сотрудника 
-- и средней зарплатой по его отделу.
-- Исходная таблица - employees (employeeid, department, salary)

select employeeid, department, AVG(salary) over w as avg, salary - AVG(salary) over w as diff from employees
window w as (partition by department)
order by employeeid



-- 2 Получить топ-3 клиента с наибольшим количеством покупок, а также общее количество покупок
-- покупок для этих клиентов.
-- Исходная таблица - purchases (client_id, purchase_id, purchase_date)

select distinct client_id, count(*) over (partition by client_id) as counter from purchases
order by counter desc, client_id asc
limit 3



-- 3 Нужно посчитать количество пользователей, у которых была любая активность и в текущем,
-- и в прошлом месяце.
-- Исходная таблица - activity (date_activity, client_id, client_activity_type_id)

with temp as (
  select client_id,
  case when strftime('%m-%Y', date_activity) == strftime('%m-%Y', DATE('now')) then 1 end as this_month, 
  case when strftime('%m-%Y', date_activity) == strftime('%m-%Y', DATE('now', '-1 month')) then 1 end as previous_month
  from activity
)

select client_id from temp
group by client_id
having sum(this_month) <> 0 and sum(previous_month) <> 0
