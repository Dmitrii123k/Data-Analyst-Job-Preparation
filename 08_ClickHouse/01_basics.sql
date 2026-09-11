-- =========================================
-- ClickHouse Basics
-- =========================================

-- Создание базы данных
CREATE DATABASE IF NOT EXISTS analytics;

-- Создание основной аналитической таблицы
CREATE TABLE IF NOT EXISTS analytics.sales
(
	order_id UInt64,
	customer_id UInt64,
	country String,
	product String,
	quantity UInt32,
	price Float64,
	order_date Date
)
ENGINE = MergeTree
ORDER BY order_date;

-- =========================================
-- Тестовые данные
-- =========================================

INSERT INTO analytics.sales VALUES
(1,101,'United Kingdom','Laptop',2,500,'2026-01-10'),
(2,102,'Germany','Mouse',5,25,'2026-01-11'),
(3,101,'United Kingdom','Keyboard',2,70,'2026-01-12'),
(4,103,'France','Laptop',1,500,'2026-01-13'),
(5,104,'Germany','Monitor',2,300,'2026-01-14'),
(6,105,'France','Mouse',10,25,'2026-01-15'),
(7,101,'United Kingdom','Monitor',1,300,'2026-01-16');

-- =========================================
-- Проверка данных
-- =========================================

SELECT *
FROM analytics.sales;

-- =========================================
-- Агрегации
-- =========================================

-- Количество заказов
SELECT
	count() AS orders
FROM analytics.sales;

-- Общая выручка
SELECT
	sum(quantity * price) AS total_revenue
FROM analytics.sales;

-- Средняя цена
SELECT
	avg(price) AS avg_price
FROM analytics.sales;

-- Минимальная и максимальная цена
SELECT
	min(price) AS min_price,
	max(price) AS max_price
FROM analytics.sales;

-- Количество уникальных клиентов
SELECT
	uniqExact(customer_id) AS customers
FROM analytics.sales;

-- =========================================
-- Анализ по странам
-- =========================================

SELECT
	country,
	count() AS orders,
	uniqExact(customer_id) AS customers,
	sum(quantity) AS total_quantity,
	sum(quantity * price) AS total_revenue
FROM analytics.sales
GROUP BY country
ORDER BY total_revenue DESC;

-- =========================================
-- argMax
-- =========================================

-- Товар с максимальной ценой
SELECT
	argMax(product, price) AS most_expensive_product,
	max(price) AS max_price
FROM analytics.sales;

-- =========================================
-- WITH и CTE
-- =========================================

WITH sales_data AS
(
	SELECT
		country,
		customer_id,
		quantity,
		price,
		quantity * price AS revenue
	FROM analytics.sales
)
SELECT
	country,
	count() AS orders,
	uniqExact(customer_id) AS customers,
	sum(quantity) AS total_quantity,
	sum(revenue) AS total_revenue
FROM sales_data
GROUP BY country
ORDER BY total_revenue DESC;
