-- Сравниваем количество строк Source и Fact
SELECT
(SELECT COUNT(*) FROM public.clean_online_retail) AS source_rows,
(SELECT COUNT(*) FROM public.fact_sales) AS fact_rows;
-- Сравниваем количество заказов
SELECT
(SELECT COUNT(DISTINCT "Invoice") FROM public.clean_online_retail WHERE "Invoice" IS NOT NULL) AS source_orders,
(SELECT COUNT(DISTINCT invoice_no) FROM public.fact_sales) AS fact_orders;
-- Сравниваем количество клиентов
SELECT
(SELECT COUNT(DISTINCT CAST(TRIM("Customer ID") AS NUMERIC)::INTEGER)
FROM public.clean_online_retail
WHERE TRIM("Customer ID") <> ''
AND TRIM("Customer ID") ~ '^[0-9]+(\.0+)?$') AS source_customers,
(SELECT COUNT(DISTINCT customer_id) FROM public.fact_sales) AS fact_customers;
-- Сравниваем выручку
SELECT
(SELECT ROUND(SUM("Quantity"*"Price"),2)
FROM public.clean_online_retail
WHERE "Invoice" IS NOT NULL
AND TRIM("Customer ID") <> ''
AND TRIM("Customer ID") ~ '^[0-9]+(\.0+)?$') AS source_revenue,
(SELECT ROUND(SUM(revenue),2) FROM public.fact_sales) AS fact_revenue;
-- Сравниваем количество возвратов
SELECT
(SELECT COUNT(*) FROM public.clean_online_retail
WHERE "Quantity"<0
AND "Invoice" IS NOT NULL
AND TRIM("Customer ID") <> ''
AND TRIM("Customer ID") ~ '^[0-9]+(\.0+)?$') AS source_returns,
(SELECT COUNT(*) FROM public.fact_sales WHERE quantity<0) AS fact_returns;