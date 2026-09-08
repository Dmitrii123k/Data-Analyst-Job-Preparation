-- Финальная проверка DWH
-- Проверяем количество клиентов
SELECT COUNT(*) AS customers
FROM public.dim_customer;
-- Проверяем количество товаров
SELECT COUNT(*) AS products
FROM public.dim_product;
-- Проверяем количество дат
SELECT COUNT(*) AS dates
FROM public.dim_date;
-- Проверяем количество стран
SELECT COUNT(*) AS countries
FROM public.dim_country;
-- Проверяем количество фактов
SELECT COUNT(*) AS facts
FROM public.fact_sales;
-- Проверяем количество строк в витрине
SELECT COUNT(*) AS daily_sales_rows
FROM public.mart_daily_sales;
-- Проверяем количество KPI
SELECT COUNT(*) AS kpi_count
FROM public.mart_sales_kpi;
-- Проверяем NULL в фактах
SELECT COUNT(*) AS invalid_facts
FROM public.fact_sales
WHERE customer_id IS NULL
OR product_id IS NULL
OR date_id IS NULL
OR country_id IS NULL;