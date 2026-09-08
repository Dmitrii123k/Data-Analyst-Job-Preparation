-- Создаём витрину ежедневных продаж по странам
CREATE TABLE IF NOT EXISTS public.mart_daily_sales(
date_id DATE,
country_id INTEGER,
orders_count INTEGER,
customers_count INTEGER,
quantity INTEGER,
revenue NUMERIC(14,2),
PRIMARY KEY(date_id,country_id),
FOREIGN KEY(date_id) REFERENCES public.dim_date(date_id),
FOREIGN KEY(country_id) REFERENCES public.dim_country(country_id)
);
-- Загружаем данные в витрину
INSERT INTO public.mart_daily_sales(date_id,country_id,orders_count,customers_count,quantity,revenue)
SELECT
date_id,
country_id,
COUNT(DISTINCT invoice_no),
COUNT(DISTINCT customer_id),
SUM(quantity),
ROUND(SUM(revenue),2)
FROM public.fact_sales
GROUP BY date_id,country_id
ON CONFLICT(date_id,country_id) DO UPDATE SET
orders_count=EXCLUDED.orders_count,
customers_count=EXCLUDED.customers_count,
quantity=EXCLUDED.quantity,
revenue=EXCLUDED.revenue;