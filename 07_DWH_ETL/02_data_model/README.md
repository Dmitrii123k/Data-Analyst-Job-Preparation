# DWH Data Model

## Star Schema

В проекте используется **Star Schema**.

В центре находится таблица фактов:

```text
                 dim_customer
                      |
                      |
dim_product — fact_sales — dim_date
                      |
                      |
                 dim_country
```

## Fact Table

`fact_sales` содержит события продаж.

Основные поля:

* `sale_id`;
* `invoice_no`;
* `customer_id`;
* `product_id`;
* `date_id`;
* `country_id`;
* `quantity`;
* `unit_price`;
* `revenue`.

## Grain

**Grain** — уровень детализации факта.

В нашем проекте:

> одна строка `fact_sales` = одна товарная позиция в заказе.

## Dimension Tables

### dim_customer

Содержит уникальных клиентов.

Primary Key:

```text
customer_id
```

### dim_product

Содержит товары.

Primary Key:

```text
product_id
```

Business identifier:

```text
stock_code
```

### dim_date

Календарное измерение.

Содержит:

* дату;
* год;
* месяц;
* название месяца;
* квартал.

### dim_country

Содержит страны.

Primary Key:

```text
country_id
```

## Primary Key

**Primary Key (PK)** — уникальный идентификатор записи.

## Foreign Key

**Foreign Key (FK)** — ссылка из одной таблицы на другую.

Например:

```text
fact_sales.customer_id
        ↓
dim_customer.customer_id
```

## Business Key

Business Key — набор полей, идентифицирующий бизнес-запись.

Для `fact_sales` используется комбинация:

```text
invoice_no
customer_id
product_id
date_id
country_id
quantity
unit_price
```
