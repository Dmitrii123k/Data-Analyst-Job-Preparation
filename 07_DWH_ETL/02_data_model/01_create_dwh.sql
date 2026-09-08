-- Удаляем таблицы DWH, если они существуют
DROP TABLE IF EXISTS fact_sales;
DROP TABLE IF EXISTS dim_customer;
DROP TABLE IF EXISTS dim_product;
DROP TABLE IF EXISTS dim_date;
DROP TABLE IF EXISTS dim_country;
-- Создаём измерение клиентов
CREATE TABLE public.dim_customer(
customer_id INTEGER PRIMARY KEY
);
-- Создаём измерение товаров
CREATE TABLE public.dim_product(
product_id SERIAL PRIMARY KEY,
stock_code VARCHAR(50) UNIQUE,
description TEXT
);
-- Создаём измерение дат
CREATE TABLE public.dim_date(
date_id DATE PRIMARY KEY,
year INTEGER,
month INTEGER,
month_name VARCHAR(20),
quarter INTEGER
);
-- Создаём измерение стран
CREATE TABLE public.dim_country(
country_id SERIAL PRIMARY KEY,
country_name VARCHAR(100) UNIQUE
);
-- Создаём таблицу фактов продаж
CREATE TABLE public.fact_sales(
sale_id BIGSERIAL PRIMARY KEY,
invoice_no VARCHAR(50),
customer_id INTEGER,
product_id INTEGER,
date_id DATE,
country_id INTEGER,
quantity INTEGER,
unit_price NUMERIC(12,2),
revenue NUMERIC(14,2),
FOREIGN KEY(customer_id) REFERENCES public.dim_customer(customer_id),
FOREIGN KEY(product_id) REFERENCES public.dim_product(product_id),
FOREIGN KEY(date_id) REFERENCES public.dim_date(date_id),
FOREIGN KEY(country_id) REFERENCES public.dim_country(country_id)
);