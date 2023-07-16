-- Есть таблица продаж sales. Посчитайте выручку для тарифа gold по месяцам 2020 года.

--Для каждого месяца дополнительно укажите:

--выручку за предыдущий месяц (prev);
--процент, который составляет выручка текущего месяца от prev (perc).
--Процент округлите до целого.
select
  year, month, revenue,
  lag(revenue) over () as prev,
  round(revenue * 100.0 / lag(revenue) over ()) as perc
from sales
where year = 2020 and plan = 'gold'
order by month;


-- Есть таблица продаж sales. 
--Посчитайте выручку нарастающим итогом по каждому тарифному плану за первые три месяца 2020 года.
select
  plan, year, month, revenue,
  sum(revenue) over w as total
from sales
where year = 2020 and month between 1 and 3
window w as (
  partition by plan
  order by month
)
order by plan, month;


-- Есть таблица продаж sales. Посчитайте скользящую среднюю выручку за 3 месяца для тарифа platinum в 2020 году.
--Округлите среднюю выручку до целого.
select
  year, month, revenue,
  avg(revenue) over w as avg3m
from sales
where year = 2020 and plan = 'platinum'
window w as (
  rows between 1 preceding and 1 following
)
order by month;


-- Есть таблица продаж sales. Посчитайте выручку по месяцам для тарифа silver.

--Для каждого месяца дополнительно укажите:

--выручку за декабрь этого же года (december);
--процент, который составляет выручка текущего месяца от december (perc).
--Процент округлите до целого.
select
  year, month, revenue,
  last_value(revenue) over w as december,
  round(revenue * 100.0 / last_value(revenue) over w) as perc
from sales
where plan = 'silver'
window w as (
  partition by year
  order by month
  rows between unbounded preceding and unbounded following
)
order by year, month;


-- Есть таблица продаж sales. Посчитайте, какой вклад (в процентах) внес каждый из тарифов в общую выручку за год.
--Процент округлите до целого.
select
  year, plan,
  sum(revenue) as revenue,  
  sum(sum(revenue)) over w as total,
  round(sum(revenue) * 100.0 / sum(sum(revenue)) over w) as perc
from sales
group by year, plan
window w as (partition by year)
order by year, plan;


-- Есть таблица продаж sales. Разбейте месяцы 2020 года на три группы по выручке:
--tile = 1 — высокая,
--tile = 2 — средняя,
--tile = 3 — низкая.
with temp as (
  select distinct
    year, month, 
    sum(revenue) over w as revenue
  from sales
  where year = 2020
  window w as (partition by month)
)

select
  year, month, revenue,
  ntile(3) over (order by revenue desc) as tile
from temp
order by revenue desc;


-- Есть таблица продаж sales. Посчитайте выручку по кварталам 2020 года.

--Для каждого квартала дополнительно укажите:

--выручку за аналогичный квартал 2019 года (prev);
--процент, который составляет выручка текущего квартала от prev (perc).
--Процент округлите до целого.
with temp as(
  select
    year, quarter, 
    sum(case when year = 2020 then revenue end) as revenue_20s,
    lag(sum(case when year = 2019 then revenue end), 4) over () as revenue_19s
  from sales
  group by year, quarter
)

select
  year, quarter, 
  revenue_20s as revenue,
  revenue_19s as prev,
  round(revenue_20s * 100.0 / revenue_19s) as perc
from temp
where revenue_20s is not null
order by quarter;


-- Есть таблица продаж sales.
--Составьте рейтинг месяцев 2020 года с точки зрения количества продаж (quantity) по каждому из тарифов. 
--Чем больше подписок тарифа P было продано в месяц M, тем выше место M в рейтинге по тарифу P
with data as (
  select
    year, month, plan,
    (case when plan = 'silver' then quantity end) as silver_qty,
    lag(case when plan = 'gold' then quantity end, 2) over w as gold_qty,
    lag(case when plan = 'platinum' then quantity end) over w as platinum_qty
  from sales
  where year = 2020
  window w as (
    partition by month
    order by plan
  ) 
)

select 
  year, month,
  rank() over (order by silver_qty desc) as silver,
  rank() over (order by gold_qty desc) as gold,
  rank() over (order by platinum_qty desc) as platinum
from data
where silver_qty is not null
order by month;
