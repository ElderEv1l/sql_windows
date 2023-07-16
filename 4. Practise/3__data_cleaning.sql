-- Напишите запрос, который выбирает апрельские данные без повторений осадков. 
--Если в дни D1 и D2 выпало N осадков, то в результаты должен попасть только один из этих дней (более поздний).
with temp as (
  select
    wdate, wtemp, precip,
    row_number() over w as rownum
  from weather
  where wdate between '2020-04-01' and '2020-04-30'
  window w as (
    partition by precip
    order by wdate desc
  )
)

select
  wdate, wtemp, precip
from temp
where rownum = 1
order by wdate;


-- Для некоторых дней не указаны осадки (precip). 
--Заполните их как среднее арифметическое значение осадков от предыдущего и следующего дней.
--Включите в ответ дни с 6 по 11 марта и с 1 по 6 июня.
select
  wdate, precip,
  coalesce(precip, round((lag(precip) over w + lead(precip) over w) / 2, 2)) as fixed
from weather
where wdate between '2020-03-06' and '2020-03-11' or 
      wdate between '2020-06-01' and '2020-06-06'
window w as (order by wdate)
order by wdate;


-- Для каждого месяца посчитайте количество дат, которые попадают в верхние 10% по значению pressure для этого месяца.
with boundary as (
  select
    extract(month from wdate) as wmonth,
    percentile_cont(0.90) within group (order by pressure) as p90
  from weather
  group by extract(month from wdate)
)

select
  extract(month from wdate) as wmonth,
  count(*) filter (where pressure > boundary.p90) as over_count
from weather
  join boundary on extract(month from wdate) = boundary.wmonth
group by extract(month from wdate)
order by wmonth;
