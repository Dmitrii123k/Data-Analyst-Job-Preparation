-- Идемпотентная загрузка таблицы фактов
-- Повторный запуск не должен создавать дубликаты
INSERT INTO public.fact_sales(invoice_no,customer_id,product_id,date_id,country_id,quantity,unit_price,revenue)
SELECT DISTINCT
r."Invoice",
c.customer_id,
p.product_id,
d.date_id,
co.country_id,
r."Quantity",
r."Price",
r."Quantity"*r."Price"
FROM (
SELECT *
FROM public.clean_online_retail
WHERE "Invoice" IS NOT NULL
AND TRIM("Customer ID") <> ''
AND TRIM("Customer ID") ~ '^[0-9]+(\.0+)?$'
) r
JOIN public.dim_customer c
ON CAST(TRIM(r."Customer ID") AS NUMERIC)::INTEGER=c.customer_id
JOIN public.dim_product p
ON r."StockCode"=p.stock_code
JOIN public.dim_date d
ON r."InvoiceDate"::DATE=d.date_id
JOIN public.dim_country co
ON r."Country"=co.country_name
ON CONFLICT(invoice_no,customer_id,product_id,date_id,country_id,quantity,unit_price) DO NOTHING;