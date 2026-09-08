# DWH Architecture

## DWH

**Data Warehouse (DWH)** — централизованное хранилище данных для аналитики и отчётности.

В отличие от операционной базы данных, DWH ориентирован на:

* аналитику;
* исторические данные;
* агрегации;
* отчётность;
* BI.

## OLTP

**OLTP (Online Transaction Processing)** — системы, предназначенные для операционных транзакций.

Примеры:

* создание заказа;
* изменение клиента;
* проведение платежа.

Основные операции:

```text
INSERT
UPDATE
DELETE
```

## OLAP

**OLAP (Online Analytical Processing)** — аналитическая обработка данных.

Основные операции:

```text
SELECT
GROUP BY
SUM
COUNT
AVG
```

## Staging

**Staging Layer** — промежуточный слой между источником и DWH.

Используется для:

* временного хранения данных;
* очистки;
* преобразования;
* проверки качества.

## ETL

**ETL = Extract → Transform → Load**

### Extract

Получение данных из источника.

### Transform

Очистка и преобразование данных.

### Load

Загрузка данных в DWH.

## ELT

**ELT = Extract → Load → Transform**

В отличие от ETL, сначала данные загружаются в хранилище, а преобразование выполняется уже внутри DWH.

## Data Mart

**Data Mart** — аналитическая витрина для конкретной задачи.

Например:

```text
DWH
 ↓
Sales Data Mart
 ↓
Power BI
```

## Data Pipeline

Типичный pipeline проекта:

```text
Source
 ↓
Staging
 ↓
DWH
 ↓
Data Mart
 ↓
BI
```
