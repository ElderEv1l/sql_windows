# Резюме
В общем случае определение фрейма выглядит так:

`{ ROWS | GROUPS | RANGE } BETWEEN frame_start AND frame_end [ EXCLUDE exclusion ]`

Фрейм по умолчанию:
`RANGE BETWEEN unbounded preceding AND current row EXCLUDE no others`

Только у некоторых функций фрейм настраивается:
  * функции смещения `first_value(), last_value(), nth_value();`
  * все функции агрегации: `count(), avg(), sum(), ...`

У остальных функций фрейм всегда равен секции.

## Тип фрейма

Строковые (rows) оперируют отдельными записями.
Групповые (groups) оперируют группами записей с одинаковым набором значений столбцов из `order by`;
Диапазонные (range) оперируют группами записей, у которых значение столбца из `order by` попадает в указанный диапазон.

## Границы фрейма (frame_start / frame_end)

```
unbounded preceding
N preceding
current row
N following
unbounded following
```

Инструкции `unbounded preceding` и `unbounded following` всегда означают границы секции. `current row` для строковых фреймов означает текущую запись, а для груповых и диапазонных — текущую запись и все равные ей (по значениям из order by). `N preceding` и `N following` означают:
  * для строковых фреймов — количество записей до / после текущей;
  * для групповых фреймов — количество групп до / после текущей;
  * для диапазонных фреймов — диапазон значений относительно текущей записи.
    
## Исключения (exclusion)

  * NO OTHERS. Ничего не исключать. Вариант по умолчанию.
  * CURRENT ROW. Исключить текущую запись.
  * GROUP. Исключить текущую запись и все равные ей (по значению столбцов из order by).
  * TIES. Оставить текущую запись, но исключить равные ей.
    
## Фильтрация

Отфильтровать фрейм для отдельной оконной функции можно через инструкцию FILTER или вложенный CASE:
```
func(column) FILTER (WHERE condition) OVER window

func(
  CASE WHEN condition THEN expression ELSE other END
) OVER window
```
