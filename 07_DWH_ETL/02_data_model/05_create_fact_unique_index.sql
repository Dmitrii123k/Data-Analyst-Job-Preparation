-- Защищаем факты от повторной загрузки
CREATE UNIQUE INDEX IF NOT EXISTS ux_fact_sales_business_key
ON public.fact_sales(
invoice_no,
customer_id,
product_id,
date_id,
country_id,
quantity,
unit_price
);