-- =========================================
-- DATA OVERVIEW
-- =========================================
-- 1. Первичный просмотр данных
SELECT *
FROM online_retail
LIMIT 10;
-- 2. Общее количество строк
SELECT COUNT(*) AS total_rows
FROM online_retail;
-- 3. Основные показатели исходных данных
SELECT
    COUNT(DISTINCT "Invoice") AS orders,
    COUNT(DISTINCT "Customer ID") AS customers,
    COUNT(DISTINCT "StockCode") AS products,
    COUNT(DISTINCT "Country") AS countries
FROM online_retail;
-- 4. Период данных
SELECT
    MIN("InvoiceDate") AS first_date,
    MAX("InvoiceDate") AS last_date
FROM online_retail;
-- 5. Общая выручка
SELECT
    ROUND(SUM("Quantity" * "Price")::numeric, 2) AS total_revenue
FROM clean_online_retail;
-- 6. Количество уникальных заказов
SELECT COUNT(DISTINCT "Invoice") AS orders
FROM clean_online_retail;
-- 7. Количество уникальных клиентов
SELECT COUNT(DISTINCT "Customer ID") AS customers
FROM clean_online_retail;
-- 8. Количество уникальных товаров
SELECT COUNT(DISTINCT "StockCode") AS products
FROM clean_online_retail;
-- 9. Количество стран
SELECT COUNT(DISTINCT "Country") AS countries
FROM clean_online_retail;
-- 10. Средний чек
SELECT
    ROUND((SUM("Quantity" * "Price") / COUNT(DISTINCT "Invoice"))::numeric, 2) AS average_check
FROM clean_online_retail;
-- 11. Средняя цена товара
SELECT ROUND(AVG("Price")::numeric, 2) AS average_price
FROM clean_online_retail;
-- 12. Общее количество проданных единиц
SELECT SUM("Quantity") AS total_quantity
FROM clean_online_retail;
-- 13. Выручка по странам
SELECT
    "Country",
    ROUND(SUM("Quantity" * "Price")::numeric, 2) AS revenue
FROM clean_online_retail
GROUP BY "Country"
ORDER BY revenue DESC;
-- 14. Выручка по годам
SELECT
    EXTRACT(YEAR FROM "InvoiceDate") AS year,
    ROUND(SUM("Quantity" * "Price")::numeric, 2) AS revenue
FROM clean_online_retail
GROUP BY EXTRACT(YEAR FROM "InvoiceDate")
ORDER BY year;
-- 15. Выручка по месяцам
SELECT
    DATE_TRUNC('month', "InvoiceDate") AS month,
    ROUND(SUM("Quantity" * "Price")::numeric, 2) AS revenue
FROM clean_online_retail
GROUP BY DATE_TRUNC('month', "InvoiceDate")
ORDER BY month;
-- 16. Top-10 товаров по выручке
SELECT
    "StockCode",
    "Description",
    ROUND(SUM("Quantity" * "Price")::numeric, 2) AS revenue
FROM clean_online_retail
WHERE "StockCode" NOT IN ('M', 'DOT', 'POST')
GROUP BY "StockCode", "Description"
ORDER BY revenue DESC
LIMIT 10;
-- 17. Top-10 товаров по количеству продаж
SELECT
    "StockCode",
    "Description",
    SUM("Quantity") AS quantity_sold
FROM clean_online_retail
WHERE "Quantity" > 0
  AND "StockCode" NOT IN ('M', 'DOT', 'POST')
GROUP BY "StockCode", "Description"
ORDER BY quantity_sold DESC
LIMIT 10;
-- 18. Revenue Share по странам
SELECT
    "Country",
    ROUND(SUM(revenue)::numeric, 2) AS revenue,
    ROUND(SUM(SUM(revenue)) OVER ()::numeric, 2) AS total_revenue,
    ROUND((SUM(revenue) / SUM(SUM(revenue)) OVER () * 100)::numeric, 2) AS revenue_share
FROM sales
GROUP BY "Country"
ORDER BY revenue DESC;
-- 19. Top-10 товаров по выручке с RANK
SELECT
    "StockCode",
    "Description",
    ROUND(SUM(revenue)::numeric, 2) AS revenue,
    RANK() OVER (ORDER BY SUM(revenue) DESC) AS revenue_rank
FROM sales
WHERE "StockCode" NOT IN ('M', 'DOT', 'POST')
GROUP BY "StockCode", "Description"
ORDER BY revenue_rank
LIMIT 10;