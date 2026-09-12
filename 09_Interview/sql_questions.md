# SQL Interview Questions

## 1. SQL Core

### 1. Чем отличаются WHERE и HAVING?

**WHERE** фильтрует строки **до группировки**.

**HAVING** фильтрует результаты **после GROUP BY**.

```sql
SELECT country, SUM(revenue) AS revenue
FROM sales
WHERE revenue > 0
GROUP BY country
HAVING SUM(revenue) > 10000;
```

На собеседовании важно сказать:

> WHERE применяется к отдельным строкам, HAVING — к агрегированным результатам.

---

### 2. Чем отличаются INNER JOIN и LEFT JOIN?

**INNER JOIN** возвращает только строки, для которых есть совпадение в обеих таблицах.

**LEFT JOIN** возвращает все строки из левой таблицы, даже если соответствия в правой таблице нет.

```sql
SELECT c.customer_id, o.order_id
FROM customers c
LEFT JOIN orders o
ON c.customer_id = o.customer_id;
```

Если заказов у клиента нет, значения из `orders` будут `NULL`.

---

### 3. Когда использовать LEFT JOIN вместо INNER JOIN?

Когда нужно сохранить **все записи основной таблицы**, даже если связанной записи может не существовать.

Пример:

> Нужно найти всех клиентов и количество их заказов, включая клиентов без заказов.

В таком случае используется `LEFT JOIN`.

---

### 4. Что такое GROUP BY?

`GROUP BY` объединяет строки в группы по указанным полям и обычно используется вместе с агрегатными функциями.

```sql
SELECT country, COUNT(*) AS orders
FROM sales
GROUP BY country;
```

Результат — одна строка на каждую страну.

---

### 5. Что такое агрегатные функции?

Агрегатные функции рассчитывают значение для набора строк.

Основные:

* `COUNT()`
* `SUM()`
* `AVG()`
* `MIN()`
* `MAX()`

Пример:

```sql
SELECT
    COUNT(*) AS orders,
    SUM(revenue) AS revenue,
    AVG(revenue) AS avg_revenue
FROM sales;
```

---

### 6. Чем COUNT(*) отличается от COUNT(column)?

`COUNT(*)` считает строки.

`COUNT(column)` считает только строки, где `column IS NOT NULL`.

Например:

```sql
COUNT(*)
```

считает все строки.

```sql
COUNT(customer_id)
```

не считает строки, где `customer_id` равен `NULL`.

---

### 7. Чем COUNT(column) отличается от COUNT(DISTINCT column)?

```sql
COUNT(customer_id)
```

считает количество непустых значений.

```sql
COUNT(DISTINCT customer_id)
```

считает количество **уникальных** клиентов.

Для метрики Customers обычно нужен:

```sql
COUNT(DISTINCT customer_id)
```

---

### 8. Что делает DISTINCT?

`DISTINCT` убирает дубликаты из результата.

```sql
SELECT DISTINCT country
FROM sales;
```

Вернёт список уникальных стран.

---

### 9. Что такое NULL?

`NULL` означает отсутствие значения.

Это не:

* `0`
* пустая строка `''`
* `FALSE`

Для проверки используется:

```sql
WHERE customer_id IS NULL
```

или:

```sql
WHERE customer_id IS NOT NULL
```

---

### 10. Что делает COALESCE?

`COALESCE()` возвращает первое значение, которое не является `NULL`.

```sql
SELECT COALESCE(customer_name, 'Unknown')
FROM customers;
```

Если `customer_name` равен `NULL`, будет возвращено `Unknown`.

---

### 11. Что такое CASE WHEN?

`CASE` используется для условной логики в SQL.

```sql
SELECT
    customer_id,
    CASE
        WHEN revenue >= 1000 THEN 'High'
        WHEN revenue >= 500 THEN 'Medium'
        ELSE 'Low'
    END AS customer_segment
FROM sales;
```

На собеседовании часто используется для:

* сегментации;
* категоризации;
* расчёта флагов;
* бизнес-логики.

---

### 12. Что такое CTE?

CTE — Common Table Expression.

Создаётся через `WITH` и позволяет временно определить результат запроса.

```sql
WITH customer_sales AS (
    SELECT
        customer_id,
        SUM(revenue) AS revenue
    FROM sales
    GROUP BY customer_id
)
SELECT *
FROM customer_sales
WHERE revenue > 1000;
```

Преимущества:

* читаемость;
* разбиение сложного запроса на этапы;
* повторное использование результата внутри одного запроса.

---

### 13. Что такое подзапрос?

Подзапрос — SQL-запрос внутри другого SQL-запроса.

Пример:

```sql
SELECT *
FROM customers
WHERE customer_id IN (
    SELECT customer_id
    FROM orders
    WHERE revenue > 1000
);
```

CTE часто используется как более читаемая альтернатива сложным подзапросам.

---

### 14. Что такое оконная функция?

Оконная функция выполняет расчёт по связанному набору строк, **не объединяя строки в одну**, в отличие от `GROUP BY`.

Пример:

```sql
SELECT
    customer_id,
    order_date,
    revenue,
    SUM(revenue) OVER (
        PARTITION BY customer_id
    ) AS customer_revenue
FROM sales;
```

Каждая исходная строка сохраняется, но к ней добавляется рассчитанное значение.

---

### 15. Чем GROUP BY отличается от оконной функции?

`GROUP BY` уменьшает количество строк.

Оконная функция сохраняет исходные строки.

Например:

```sql
SELECT customer_id, SUM(revenue)
FROM sales
GROUP BY customer_id;
```

даёт одну строку на клиента.

А:

```sql
SELECT
    customer_id,
    revenue,
    SUM(revenue) OVER (PARTITION BY customer_id)
FROM sales;
```

сохраняет каждую транзакцию и добавляет общую выручку клиента.

---

### 16. Чем ROW_NUMBER отличается от RANK и DENSE_RANK?

`ROW_NUMBER()` присваивает уникальный порядковый номер каждой строке.

`RANK()` даёт одинаковый ранг одинаковым значениям, но оставляет пропуски.

`DENSE_RANK()` тоже даёт одинаковый ранг одинаковым значениям, но без пропусков.

Пример значений:

```text
100
100
90
```

Результат:

```text
ROW_NUMBER: 1, 2, 3
RANK:       1, 1, 3
DENSE_RANK: 1, 1, 2
```

---

### 17. Как найти топ-3 товара по выручке?

Один из вариантов:

```sql
SELECT
    product,
    SUM(revenue) AS revenue
FROM sales
GROUP BY product
ORDER BY revenue DESC
LIMIT 3;
```

Если требуется учитывать одинаковые места в рейтинге, лучше использовать оконную функцию.

---

### 18. Как найти клиентов, которые сделали больше одного заказа?

```sql
SELECT
    customer_id,
    COUNT(DISTINCT order_id) AS orders
FROM sales
GROUP BY customer_id
HAVING COUNT(DISTINCT order_id) > 1;
```

---

### 19. Как найти дубликаты?

Например, по `customer_id`:

```sql
SELECT
    customer_id,
    COUNT(*) AS cnt
FROM customers
GROUP BY customer_id
HAVING COUNT(*) > 1;
```

Это показывает значения, которые встречаются больше одного раза.

---

### 20. Как найти строки без соответствия в другой таблице?

Например, клиентов без заказов:

```sql
SELECT c.customer_id
FROM customers c
LEFT JOIN orders o
ON c.customer_id = o.customer_id
WHERE o.customer_id IS NULL;
```

Это классический паттерн:

**LEFT JOIN + IS NULL**.

---

## 2. Типовые вопросы на собеседовании

Перед собеседованием нужно уметь без подсказки объяснить:

* `WHERE` vs `HAVING`
* `INNER JOIN` vs `LEFT JOIN`
* `COUNT(*)` vs `COUNT(column)`
* `COUNT()` vs `COUNT(DISTINCT)`
* `NULL`
* `COALESCE`
* `CASE`
* CTE
* подзапросы
* `GROUP BY`
* оконные функции
* `ROW_NUMBER` / `RANK` / `DENSE_RANK`
* поиск дубликатов
* поиск отсутствующих записей
* топ-N
* агрегирование по клиенту / товару / месяцу

## 3. Что важно показать на собеседовании

При решении SQL-задачи важно не только написать запрос.

Нужно уметь объяснить:

1. Какие таблицы используются.
2. Как связаны таблицы.
3. Почему выбран именно этот тип JOIN.
4. На каком этапе выполняется фильтрация.
5. Где происходит агрегация.
6. Нужно ли считать уникальные значения.
7. Как обрабатываются `NULL`.
8. Почему выбран `GROUP BY`, CTE или оконная функция.
9. Как проверить корректность результата.
10. Какие дополнительные бизнес-выводы можно получить из результата.
