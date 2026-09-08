-- ETL: загрузка измерения клиентов
INSERT INTO public.dim_customer(customer_id)
SELECT DISTINCT CAST(TRIM("Customer ID") AS NUMERIC)::INTEGER
FROM public.clean_online_retail
WHERE "Customer ID" IS NOT NULL
AND TRIM("Customer ID") <> ''
AND TRIM("Customer ID") ~ '^[0-9]+(\.0+)?$'
ON CONFLICT(customer_id) DO NOTHING;
-- ETL: загрузка измерения товаров
INSERT INTO public.dim_product(stock_code,description)
SELECT DISTINCT "StockCode","Description"
FROM public.clean_online_retail
WHERE "StockCode" IS NOT NULL
ON CONFLICT(stock_code) DO NOTHING;
-- ETL: загрузка измерения дат
INSERT INTO public.dim_date(date_id,year,month,month_name,quarter)
SELECT DISTINCT
"InvoiceDate"::DATE,
EXTRACT(YEAR FROM "InvoiceDate")::INTEGER,
EXTRACT(MONTH FROM "InvoiceDate")::INTEGER,
TO_CHAR("InvoiceDate",'Month'),
EXTRACT(QUARTER FROM "InvoiceDate")::INTEGER
FROM public.clean_online_retail
WHERE "InvoiceDate" IS NOT NULL
ON CONFLICT(date_id) DO NOTHING;
-- ETL: загрузка измерения стран
INSERT INTO public.dim_country(country_name)
SELECT DISTINCT "Country"
FROM public.clean_online_retail
WHERE "Country" IS NOT NULL
ON CONFLICT(country_name) DO NOTHING;