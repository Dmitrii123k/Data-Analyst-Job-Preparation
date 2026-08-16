-- =========================================================
-- JOINS_PRACTICE
-- CUSTOMER ANALYSIS AND DATA QUALITY
-- =========================================================

-- STEP 1. Проверяем количество клиентов
SELECT
    COUNT(*) AS customer_count
FROM (
    SELECT
        "Customer ID"
    FROM sales
    WHERE "Customer ID" IS NOT NULL
    GROUP BY "Customer ID"
) t;

-- STEP 2. Проверяем все заказы и заказы с Customer ID
SELECT
    COUNT(DISTINCT "Invoice") AS all_orders,
    COUNT(DISTINCT CASE
        WHEN "Customer ID" IS NOT NULL
        THEN "Invoice"
    END) AS orders_with_customer
FROM sales;

-- STEP 3. Строим метрики клиентов
-- NULL и пустая строка '' считаются отдельно.
-- NULLIF(TRIM()) превращает пустую строку в NULL.
WITH customer_metrics AS (
    SELECT
        "Customer ID" AS customer_id,
        COUNT(DISTINCT "Invoice") AS orders_count,
        SUM(revenue) AS total_revenue,
        SUM(revenue) / COUNT(DISTINCT "Invoice") AS avg_order_value
    FROM sales
    WHERE NULLIF(TRIM("Customer ID"), '') IS NOT NULL
    GROUP BY "Customer ID"
)
SELECT
    *
FROM customer_metrics
ORDER BY total_revenue DESC;

-- STEP 4. Проверяем пустые Customer ID
SELECT
    COUNT(*) AS empty_customer_rows,
    COUNT(DISTINCT "Invoice") AS empty_customer_orders,
    ROUND(SUM(revenue)::numeric, 2) AS empty_customer_revenue
FROM sales
WHERE TRIM("Customer ID") = '';

-- STEP 5. Проверяем конкретного клиента
SELECT
    "Customer ID",
    COUNT(DISTINCT "Invoice") AS orders_count,
    COUNT(*) AS rows_count,
    ROUND(SUM(revenue)::numeric, 2) AS total_revenue,
    MIN("InvoiceDate") AS first_order,
    MAX("InvoiceDate") AS last_order
FROM sales
WHERE "Customer ID" = '13108.0'
GROUP BY "Customer ID";

-- STEP 6. Сравниваем AVG и MEDIAN
WITH customer_metrics AS (
    SELECT
        "Customer ID" AS customer_id,
        SUM(revenue) AS total_revenue
    FROM sales
    WHERE NULLIF(TRIM("Customer ID"), '') IS NOT NULL
    GROUP BY "Customer ID"
)
SELECT
    ROUND(AVG(total_revenue)::numeric, 2) AS avg_customer_revenue,
    ROUND(
        PERCENTILE_CONT(0.5)
        WITHIN GROUP (ORDER BY total_revenue)::numeric,
        2
    ) AS median_customer_revenue
FROM customer_metrics;

-- STEP 7. Финальные customer KPI
WITH customer_metrics AS (
    SELECT
        "Customer ID" AS customer_id,
        COUNT(DISTINCT "Invoice") AS orders_count,
        SUM(revenue) AS total_revenue
    FROM sales
    WHERE NULLIF(TRIM("Customer ID"), '') IS NOT NULL
    GROUP BY "Customer ID"
)
SELECT
    COUNT(*) AS customers,
    SUM(orders_count) AS total_orders,
    ROUND(SUM(total_revenue)::numeric, 2) AS total_revenue,
    ROUND(AVG(total_revenue)::numeric, 2) AS avg_customer_revenue,
    ROUND(
        PERCENTILE_CONT(0.5)
        WITHIN GROUP (ORDER BY total_revenue)::numeric,
        2
    ) AS median_customer_revenue
FROM customer_metrics;