# Резюме

Вот задачи, которые решаются с помощью оконных функций в SQL:

  1. Ранжирование (всевозможные рейтинги).
  2. Сравнение со смещением (соседние элементы и границы).
  3. Агрегация (количество, сумма и среднее).
  4. Скользящие агрегаты (сумма и среднее в динамике).
  5. Статистика (относительные ранги и сводные показатели).

  
Оконные функции вычисляют результат по строкам, которые попали в окно. 
Определение окна указывает, как выглядит окно:

  1. Из каких секций состоит (`partition by`).
  2. Как отсортированы строки внутри секции (`order by`).
  3. Как выглядит фрейм внутри секции (`rows between`).

```
window w as (
  partition by ...
  order by ...
  rows between ... and ...
)
```

`partition by` поддерживается всеми оконными функциями и всегда необязательно. Если не указать — будет одна секция.

`order by` поддерживается всеми оконными функциями (кроме процентилей). Для функций ранжирования и смещения оно обязательно, для агрегации — нет. Если не указать order by для функции агрегации — она посчитает обычный агрегат, если указать — скользящий.

Фрейм поддерживается только некоторыми функциями:

  * `first_value(), last_value(), nth_value();`
  * функции агрегации.

Остальные функции фреймы не поддерживают.

![image](https://github.com/ElderEv1l/sql_windows/assets/95085670/4246e09a-06f0-457f-b38f-0cfcbf235b09)
![image](https://github.com/ElderEv1l/sql_windows/assets/95085670/8423799c-d1c8-493b-b7e1-c87861497e86)
![image](https://github.com/ElderEv1l/sql_windows/assets/95085670/fe651658-7721-40f8-b7c3-ae8483b0aaa3)


