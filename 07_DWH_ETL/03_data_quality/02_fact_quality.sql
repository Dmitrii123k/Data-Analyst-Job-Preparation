-- Проверяем количество строк в фактах
SELECT COUNT(*) AS fact_sales_count
FROM public.fact_sales;
-- Проверяем NULL в ключевых полях
SELECT
COUNT(*) FILTER(WHERE customer_id IS NULL) AS null_customer,
COUNT(*) FILTER(WHERE product_id IS NULL) AS null_product,
COUNT(*) FILTER(WHERE date_id IS NULL) AS null_date,
COUNT(*) FILTER(WHERE country_id IS NULL) AS null_country
FROM public.fact_sales;
-- Проверяем отрицательное количество
SELECT COUNT(*) AS negative_quantity
FROM public.fact_sales
WHERE quantity<0;
-- Проверяем отрицательную выручку
SELECT COUNT(*) AS negative_revenue
FROM public.fact_sales
WHERE revenue<0;
-- Проверяем корректность расчёта выручки
SELECT COUNT(*) AS revenue_errors
FROM public.fact_sales
WHERE revenue<>quantity*unit_price;