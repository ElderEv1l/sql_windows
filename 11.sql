-- Напишите запрос, с помощью которого можно найти дубли в поле email из таблицы Sfaff.

with Counter as (
	select email, count(email) as counter
	from Staff
	group by email
	having count(email) > 1
)

select * from Staff where email in (select email from Counter)



-- Напишите запрос, с помощью которого можно определить возраст 
-- каждого сотрудника из таблицы Staff на момент запроса.

select staff_id, name, 
	date_part('year', age(birthday)) as age
from Staff



-- Напишите запрос, с помощью которого можно определить должность (Jobtitles.name)
-- со вторым по величине уровнем зарплаты.

select jt.name 
from (select jobtitle_id, salary from Staff order by salary desc limit 2) as st left join Jobtitles as jt
on jt.jobtitle_id = st.jobtitle_id
order by salary asc
limit 1

-- С использованием оконных функций

select name
from (select jobtitle_id, 
dense_rank() over(order by salary desc) as rank
from Staff) as sub join Jobtitles as jt
on jt.jobtitle_id = sub.jobtitle_id
where rank = 2;
