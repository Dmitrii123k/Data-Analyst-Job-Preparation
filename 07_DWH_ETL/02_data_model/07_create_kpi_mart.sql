-- Создаём витрину основных KPI
CREATE TABLE IF NOT EXISTS public.mart_sales_kpi(
metric_name VARCHAR(100) PRIMARY KEY,
metric_value NUMERIC(18,2)
);
-- Загружаем основные KPI
INSERT INTO public.mart_sales_kpi(metric_name,metric_value)
SELECT 'Total Revenue',ROUND(SUM(revenue),2)
FROM public.fact_sales
ON CONFLICT(metric_name) DO UPDATE SET metric_value=EXCLUDED.metric_value;
INSERT INTO public.mart_sales_kpi(metric_name,metric_value)
SELECT 'Orders',COUNT(DISTINCT invoice_no)::NUMERIC
FROM public.fact_sales
ON CONFLICT(metric_name) DO UPDATE SET metric_value=EXCLUDED.metric_value;
INSERT INTO public.mart_sales_kpi(metric_name,metric_value)
SELECT 'Customers',COUNT(DISTINCT customer_id)::NUMERIC
FROM public.fact_sales
ON CONFLICT(metric_name) DO UPDATE SET metric_value=EXCLUDED.metric_value;
INSERT INTO public.mart_sales_kpi(metric_name,metric_value)
SELECT 'Quantity',SUM(quantity)::NUMERIC
FROM public.fact_sales
ON CONFLICT(metric_name) DO UPDATE SET metric_value=EXCLUDED.metric_value;
INSERT INTO public.mart_sales_kpi(metric_name,metric_value)
SELECT 'Average Order Value',ROUND(SUM(revenue)/COUNT(DISTINCT invoice_no),2)
FROM public.fact_sales
ON CONFLICT(metric_name) DO UPDATE SET metric_value=EXCLUDED.metric_value;