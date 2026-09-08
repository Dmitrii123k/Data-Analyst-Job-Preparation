# DWH & ETL

## Цель проекта

Практическое построение небольшого аналитического хранилища данных (DWH) на PostgreSQL на основе данных интернет-магазина.

В проекте реализованы:

* архитектура DWH;
* измерения (Dimensions);
* таблица фактов (Fact Table);
* ETL-процесс;
* проверки качества данных;
* контроль дубликатов;
* проверка Referential Integrity;
* идемпотентная загрузка;
* аналитические витрины (Data Marts);
* KPI-витрина.

## Архитектура

```text
clean_online_retail
        ↓
      ETL
        ↓
    Dimensions
        ↓
    fact_sales
        ↓
  Data Quality
        ↓
    Data Marts
        ↓
   BI / Analytics
```

## DWH-модель

Использована схема типа Star Schema.

### Dimensions

* `dim_customer` — клиенты;
* `dim_product` — товары;
* `dim_date` — даты;
* `dim_country` — страны.

### Fact

`fact_sales` — таблица фактов продаж.

Одна строка факта соответствует одной товарной позиции в заказе.

## ETL

Основной процесс:

```text
Extract → Transform → Load
```

### Extract

Источник данных:

`clean_online_retail`

### Transform

В процессе преобразования:

* очищаются значения Customer ID;
* выполняется преобразование типов;
* связываются факты с измерениями;
* рассчитывается `revenue = quantity × unit_price`.

### Load

Данные загружаются:

1. в Dimensions;
2. затем в `fact_sales`;
3. затем агрегируются в Data Marts.

## Data Quality

Выполнены проверки:

* количество строк;
* NULL в ключевых полях;
* дубликаты;
* отрицательные значения;
* корректность расчёта выручки;
* соответствие Source и DWH;
* Referential Integrity;
* повторный запуск ETL.

## Idempotency

Для защиты от повторной загрузки реализован Business Key:

```text
invoice_no
customer_id
product_id
date_id
country_id
quantity
unit_price
```

На основе Business Key создан UNIQUE INDEX.

Для повторной загрузки используется:

```text
ON CONFLICT DO NOTHING
```

В результате повторный запуск ETL не увеличивает количество записей.

## Data Marts

### mart_daily_sales

Витрина ежедневных продаж по странам.

Grain:

```text
1 строка = 1 дата + 1 страна
```

Содержит:

* количество заказов;
* количество клиентов;
* количество проданных единиц;
* выручку.

### mart_sales_kpi

Витрина основных бизнес-показателей.

Содержит:

* Total Revenue;
* Orders;
* Customers;
* Quantity;
* Average Order Value.

## Результаты

После загрузки DWH:

| Объект           | Количество |
| ---------------- | ---------: |
| Customers        |      5 942 |
| Products         |      5 305 |
| Dates            |        604 |
| Countries        |         43 |
| Fact rows        |    797 881 |
| Daily Sales rows |      3 172 |
| KPI              |          5 |

## Основные KPI

| KPI                 |      Значение |
| ------------------- | ------------: |
| Total Revenue       | 16 289 405.82 |
| Orders              |        44 876 |
| Customers           |         5 942 |
| Quantity            |    10 055 418 |
| Average Order Value |        362.99 |

## Итог

В рамках проекта построено аналитическое DWH на PostgreSQL с использованием Star Schema.

Реализованы ETL-загрузки Dimensions и Fact Table, проверки качества данных, защита от повторной загрузки и аналитические витрины.

Следующим этапом данные из Data Marts могут использоваться для построения BI-дашбордов в Power BI.
