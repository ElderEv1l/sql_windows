-- Есть таблица weather — это среднедневная температура в Лондоне за 6 месяцев 2020 года
--Напишите запрос, который рассчитает cume_dist (cd) и percent_rank (pr)
--по температуре для всех дней марта, и вернет пять дней с самой высокой температурой
select
	wdate, wtemp,
    round(cume_dist() over w, 2) as cd,
    round(percent_rank() over w, 2) as pr
from weather
where month(wdate) = 3
window w as (
  order by wtemp 
)
order by wtemp desc
limit 5;


--Продолжаем работать с таблицей температур weather(wdate, wtemp). 
--Хотим для каждого из дней с 1 по 5 марта определить, 
--какой процент дней в марте имеют такую же или меньшую температуру
select
	wdate, wtemp,
    round(cume_dist() over w, 2) as perc
from weather
where month(wdate) = 3
window w as (order by wtemp)
order by wdate
limit 5;


-- Продолжаем работать с таблицей температур weather(wdate, wtemp). 
--Хотим для седьмого числа каждого месяца (7 января, 7 февраля, 7 марта ...) определить, 
--какой процент дней в соответствующем месяце имеют такую же или меньшую температуру
with temp as (
  select
      wdate, wtemp,
      round(cume_dist() over w, 2) as perc
  from weather
  window w as (
    partition by month(wdate)
    order by wtemp
  )
  order by wdate
)

select
	wdate, wtemp, perc
from temp
where day(wdate) = 7
order by wdate;


-- Есть таблица weather — это среднедневная температура в Лондоне за 6 месяцев 2020 года
--Напишите запрос, который рассчитает среднее арифметическое, медиану и 90-й процентиль температуры по каждому месяцу
select
  extract(month from wdate) as wmonth,
  round(avg(wtemp)::decimal, 2) as t_avg,
  percentile_disc(0.50) within group (order by wtemp) as median,
  percentile_disc(0.90) within group (order by wtemp) as p90
from weather
group by extract(month from wdate);
