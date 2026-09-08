-- Проверяем количество клиентов
SELECT COUNT(*) AS customers_count
FROM public.dim_customer;
-- Проверяем количество товаров
SELECT COUNT(*) AS products_count
FROM public.dim_product;
-- Проверяем количество дат
SELECT COUNT(*) AS dates_count
FROM public.dim_date;
-- Проверяем количество стран
SELECT COUNT(*) AS countries_count
FROM public.dim_country;
-- Проверяем дубликаты клиентов
SELECT customer_id,COUNT(*)
FROM public.dim_customer
GROUP BY customer_id
HAVING COUNT(*)>1;
-- Проверяем дубликаты товаров
SELECT stock_code,COUNT(*)
FROM public.dim_product
GROUP BY stock_code
HAVING COUNT(*)>1;
-- Проверяем дубликаты дат
SELECT date_id,COUNT(*)
FROM public.dim_date
GROUP BY date_id
HAVING COUNT(*)>1;
-- Проверяем дубликаты стран
SELECT country_name,COUNT(*)
FROM public.dim_country
GROUP BY country_name
HAVING COUNT(*)>1;