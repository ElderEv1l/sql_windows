/* 
Задача 1
Я использовал rank(), который в случае одинаковых результатов может вывести больше 5 товаров,
если важно вывести ровно 5 товаров - нужно использовать row_number()
*/

with temp as ( 
  select o.warehouse_id, ol.product_id, sum(ol.quantity) as quantity,
  rank() over (partition by warehouse_id order by sum(ol.quantity) desc) as rank_desc,
  rank() over (partition by warehouse_id order by sum(ol.quantity)) as rank_asc
  from orders as o join order_lines as ol
  on o.order_id = ol.order_id
  where created_at >= CURRENT_DATE - INTERVAL '1 month'
  group by o.warehouse_id, ol.product_id
)

select warehouse_id, product_id, quantity 
from temp
where rank_desc <= 5 or rank_asc <= 5
order by warehouse_id, rank_desc, product_id


/*
Задача 2 
В зависимости от требований к точности round можно поменять/убрать
*/
  
select date(created_at) as day, round(avg(case when delivered_at - created_at <= interval '15 minutes' then 0 else 1 end), 2) as delay_rate
from orders
group by date(created_at)
