# ClickHouse + DataLens — Sales Analytics

## Описание проекта

Учебный аналитический проект по работе с **ClickHouse** и **Yandex DataLens** в рамках подготовки к собеседованию на позицию Data Analyst.

Цель проекта — показать полный аналитический цикл: работа с аналитической СУБД, хранение и агрегация данных, подключение BI-инструмента, создание вычисляемых показателей, визуализация данных и построение аналитического Dashboard.

## Стек

* **ClickHouse** — аналитическая OLAP СУБД
* **Docker** — запуск ClickHouse в контейнере
* **Yandex DataLens** — BI и визуализация
* **SQL** — работа с данными и расчёт показателей
* **DBeaver** — выполнение и проверка SQL
* **VS Code** — хранение SQL и документации
* **Git / GitHub** — версионирование проекта

## Что изучено в ClickHouse

* Что такое ClickHouse
* OLAP и колоночное хранение
* `MergeTree`
* `ORDER BY`
* `PARTITION BY`
* `SELECT`
* `WHERE`
* `GROUP BY`
* `LIMIT`
* `COUNT`
* `SUM`
* `AVG`
* `MIN` / `MAX`
* `uniq`
* `uniqExact`
* `argMax`
* `WITH`
* CTE
* Оконные функции
* `row_number()`
* `rank()`
* `dense_rank()`
* Накопительная сумма через `sum() OVER`

## Где выполнять SQL

SQL сначала проверяется в **DBeaver** в SQL-редакторе ClickHouse.

После проверки рабочая версия сохраняется в соответствующий `.sql` файл в VS Code.

## Архитектура

```text
ClickHouse
    ↓
analytics.sales
    ↓
DataLens Dataset
    ↓
Calculated Fields
    ↓
Charts
    ↓
Dashboard
```

## Источник данных

Для анализа используется таблица:

```text
analytics.sales
```

Основные поля:

* `order_id` — идентификатор заказа
* `customer_id` — идентификатор клиента
* `country` — страна
* `product` — продукт
* `quantity` — количество
* `price` — цена
* `order_date` — дата заказа

## Вычисляемое поле

В DataLens создано поле `revenue`:

```text
[quantity] * [price]
```

Поле используется для расчёта общей выручки и аналитических визуализаций.

## KPI

На Dashboard рассчитаны основные показатели:

| KPI             | Расчёт                            |
| --------------- | --------------------------------- |
| Total Revenue   | `SUM(revenue)`                    |
| Orders          | `COUNTD(order_id)`                |
| Customers       | `COUNTD(customer_id)`             |
| Quantity        | `SUM(quantity)`                   |
| Avg Order Value | `SUM(revenue) / COUNTD(order_id)` |

## Визуализации

### Revenue by Country

Показывает распределение выручки по странам.

Используется для анализа географии продаж и определения наиболее значимых рынков.

### Revenue Trend

Показывает изменение выручки во времени.

Используется для анализа динамики продаж и выявления периодов роста или снижения.

### Orders by Month

Показывает количество уникальных заказов по месяцам.

Позволяет анализировать изменение активности покупателей во времени.

### Revenue by Product

Показывает выручку по продуктам.

Используется для определения продуктов с наибольшим вкладом в общую выручку.

## Dashboard

Создан Dashboard:

**Sales & Customer Analysis**

Dashboard объединяет KPI и основные аналитические визуализации в одном интерфейсе.

Структура:

```text
Total Revenue | Orders | Customers | Quantity | Avg Order Value

Revenue Trend | Orders by Month

Revenue by Country

Revenue by Product
```

## Работа с ClickHouse

ClickHouse запускается в Docker-контейнере.

Используемые порты:

```text
8123 — HTTP
9000 — native protocol
```

Для подключения DataLens используется:

```text
Host: host.docker.internal
Port: 8123
Database: default
User: default
SSL: disabled
```

`host.docker.internal` используется потому, что DataLens и ClickHouse работают в разных Docker-контейнерах.

## Результат

В результате проекта создан аналитический контур:

```text
ClickHouse → DataLens → Dashboard
```

Проект демонстрирует практические навыки работы с:

* аналитическими базами данных;
* ClickHouse;
* Docker;
* SQL;
* CTE;
* оконными функциями;
* агрегатными функциями;
* calculated fields;
* KPI;
* BI-инструментами;
* визуализацией данных;
* Dashboard design.

## Что демонстрирует проект

Проект показывает способность аналитика не только написать SQL-запрос, но и построить полный аналитический процесс:

1. Подготовить источник данных.
2. Подключить аналитическую СУБД.
3. Настроить BI-подключение.
4. Создать вычисляемые показатели.
5. Рассчитать KPI.
6. Построить визуализации.
7. Объединить результаты в аналитический Dashboard.
8. Представить результаты в форме, удобной для бизнес-анализа.

## Структура проекта

```text
08_ClickHouse/

├── README.md
├── 01_basics.sql
├── 02_window_functions.sql
├── ClickHouse Sales Dashboard.json
├── Sales & Customer Analysis.pdf
└── Sales & Customer Analysis.png
```
