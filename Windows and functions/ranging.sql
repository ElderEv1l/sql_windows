-- Ранжирование сотрудников по имени (по алфавиту от А к Я):
select
  dense_rank() over w as rank,
  name, department, salary
from employees
window w as (order by name)
order by rank, id;


-- В компании работают сотрудники из Москвы и Самары. Предположим, мы решили ранжировать их по зарплате внутри каждого города, от меньшей зарплаты к большей.
-- Посчитаем рейтинг:
select
  dense_rank() over w as rank,
  city, name, salary
from employees
window w as (partition by city order by salary)
order by city, rank, id;


-- Есть таблица сотрудников employees. В компании работают сотрудники из Москвы и Самары.
-- Мы хотим разбить их на две группы по зарплате в каждом из городов
select
  ntile(2) over w as tile,
  name, city, salary
from employees
window w as (
  partition by city
  order by salary asc
)
order by city, salary, id;


-- Есть таблица сотрудников employees. Мы хотим узнать самых высокооплачиваемых людей по каждому департаменту
with ranking as (
  select dense_rank() over w as ranking,
  id, name, department, salary
  from employees
  window w as (
    partition by department
    order by salary desc
  )
)

select id, name, department, salary
from ranking
where ranking = 1;