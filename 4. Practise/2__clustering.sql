-- Найти все острова и количество значений в каждом из таблицы numbers.
with ngroups as (
  select
    num,
    num - dense_rank() over w as group_id
  from numbers
  window w as (order by num)
)
  
select
  min(num) as n_start,
  max(num) as n_end,
  count(*) as n_count
from ngroups
group by group_id;


-- Есть таблица activity, которая хранит баллы, набранные пользователями в конкретные дни
--Посчитайте острова по дате для каждого пользователя — то есть периоды, 
--в которые пользователь набирал хотя бы один балл каждый день без перерыва. Серия из одного дня тоже считается.
with agroups as (
  select
    user_id, adate,
    to_days(adate)- dense_rank() over w as group_id
  from activity
  window w as (partition by user_id order by adate)
)

select
  user_id,
  min(adate) as day_start,
  max(adate) as day_end,
  count(*) as day_count
from agroups
group by user_id, group_id;


-- Есть таблица activity, которая хранит баллы, набранные пользователями в конкретные дни
--Серией в этой задаче будем считать последовательность дней, в которых количество набранных пользователем очков
--в каждый следующий день не меньше, чем в предыдущий. 
--При этом между предыдущим и следующим днем может быть любой промежуток времени, это не прерывает серию. Серии из одного дня не учитываем.
with group_diff as (
  select
    user_id, adate, points,
    points - lag(points) over w as point_lag
  from activity
  window w as (
    partition by user_id
    order by adate
  )
),

set_groups as (
  select
    user_id, adate, points,
    sum(case when point_lag < 0 then 1 else 0 end) over w as group_id
  from group_diff
  window w as (
    partition by user_id
    order by adate
  )
)

select 
  user_id,
  min(adate) as day_start,
  max(adate) as day_end,
  count(*) as day_count,
  sum(points) as p_total
from set_groups
group by user_id, group_id
having count(*) <> 1
order by user_id, day_start;
