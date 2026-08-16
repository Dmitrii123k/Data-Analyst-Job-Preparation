-- =========================================================
-- CTE_PRACTICE
-- CTE, SEGMENTATION AND WINDOW FUNCTIONS
-- =========================================================

-- STEP 1. Сегментация клиентов
WITH customer_metrics AS (
    SELECT
        "Customer ID" AS customer_id,
        COUNT(DISTINCT "Invoice") AS orders_count,
        SUM(revenue) AS total_revenue
    FROM sales
    WHERE NULLIF(TRIM("Customer ID"), '') IS NOT NULL
    GROUP BY "Customer ID"
),
customer_segments AS (
    SELECT
        customer_id,
        orders_count,
        total_revenue,
        CASE
            WHEN total_revenue >= 5000
                AND orders_count >= 10
                THEN 'VIP'
            WHEN total_revenue >= 5000
                THEN 'High Value'
            WHEN orders_count >= 10
                THEN 'Loyal'
            ELSE 'Low Value'
        END AS customer_segment
    FROM customer_metrics
)
SELECT
    customer_segment,
    COUNT(*) AS customers,
    ROUND(SUM(total_revenue)::numeric, 2) AS revenue,
    ROUND(AVG(total_revenue)::numeric, 2) AS avg_revenue,
    ROUND(AVG(orders_count)::numeric, 2) AS avg_orders
FROM customer_segments
GROUP BY customer_segment
ORDER BY revenue DESC;

-- STEP 2. Проверяем границы сегментов
WITH customer_metrics AS (
    SELECT
        "Customer ID" AS customer_id,
        COUNT(DISTINCT "Invoice") AS orders_count,
        SUM(revenue) AS total_revenue
    FROM sales
    WHERE NULLIF(TRIM("Customer ID"), '') IS NOT NULL
    GROUP BY "Customer ID"
),
customer_segments AS (
    SELECT
        customer_id,
        orders_count,
        total_revenue,
        CASE
            WHEN total_revenue >= 5000
                AND orders_count >= 10
                THEN 'VIP'
            WHEN total_revenue >= 5000
                THEN 'High Value'
            WHEN orders_count >= 10
                THEN 'Loyal'
            ELSE 'Low Value'
        END AS customer_segment
    FROM customer_metrics
)
SELECT
    customer_segment,
    MIN(total_revenue) AS min_revenue,
    MAX(total_revenue) AS max_revenue,
    MIN(orders_count) AS min_orders,
    MAX(orders_count) AS max_orders
FROM customer_segments
GROUP BY customer_segment
ORDER BY min_revenue DESC;

-- STEP 3. Доля клиентов и выручки по сегментам
WITH customer_metrics AS (
    SELECT
        "Customer ID" AS customer_id,
        COUNT(DISTINCT "Invoice") AS orders_count,
        SUM(revenue) AS total_revenue
    FROM sales
    WHERE NULLIF(TRIM("Customer ID"), '') IS NOT NULL
    GROUP BY "Customer ID"
),
customer_segments AS (
    SELECT
        customer_id,
        orders_count,
        total_revenue,
        CASE
            WHEN total_revenue >= 5000
                AND orders_count >= 10
                THEN 'VIP'
            WHEN total_revenue >= 5000
                THEN 'High Value'
            WHEN orders_count >= 10
                THEN 'Loyal'
            ELSE 'Low Value'
        END AS customer_segment
    FROM customer_metrics
),
segment_summary AS (
    SELECT
        customer_segment,
        COUNT(*) AS customers,
        SUM(total_revenue) AS revenue
    FROM customer_segments
    GROUP BY customer_segment
)
SELECT
    customer_segment,
    customers,
    ROUND(
        customers::numeric / SUM(customers) OVER () * 100,
        2
    ) AS customer_share_pct,
    ROUND(revenue::numeric, 2) AS revenue,
    ROUND(
        revenue::numeric / SUM(revenue) OVER () * 100,
        2
    ) AS revenue_share_pct
FROM segment_summary
ORDER BY revenue DESC;

-- STEP 4. Ранжирование клиентов по выручке
WITH customer_metrics AS (
    SELECT
        "Customer ID" AS customer_id,
        SUM(revenue) AS total_revenue
    FROM sales
    WHERE NULLIF(TRIM("Customer ID"), '') IS NOT NULL
    GROUP BY "Customer ID"
),
customer_ranked AS (
    SELECT
        customer_id,
        total_revenue,
        ROW_NUMBER() OVER (
            ORDER BY total_revenue DESC
        ) AS customer_rank,
        SUM(total_revenue) OVER (
            ORDER BY total_revenue DESC
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS cumulative_revenue,
        SUM(total_revenue) OVER () AS total_revenue_all
    FROM customer_metrics
)
SELECT
    customer_rank,
    customer_id,
    ROUND(total_revenue::numeric, 2) AS total_revenue,
    ROUND(
        (cumulative_revenue / total_revenue_all * 100)::numeric,
        2
    ) AS cumulative_revenue_pct
FROM customer_ranked
WHERE customer_rank <= 20
ORDER BY customer_rank;

-- STEP 5. Месячная выручка
SELECT
    DATE_TRUNC('month', "InvoiceDate") AS month,
    COUNT(DISTINCT "Invoice") AS orders,
    COUNT(
        DISTINCT NULLIF(TRIM("Customer ID"), '')
    ) AS customers,
    ROUND(SUM(revenue)::numeric, 2) AS revenue
FROM sales
GROUP BY DATE_TRUNC('month', "InvoiceDate")
ORDER BY month;

-- STEP 6. Месячная выручка и предыдущий месяц
WITH monthly_sales AS (
    SELECT
        DATE_TRUNC('month', "InvoiceDate") AS month,
        COUNT(DISTINCT "Invoice") AS orders,
        COUNT(
            DISTINCT NULLIF(TRIM("Customer ID"), '')
        ) AS customers,
        SUM(revenue) AS revenue
    FROM sales
    GROUP BY DATE_TRUNC('month', "InvoiceDate")
),
monthly_growth AS (
    SELECT
        month,
        orders,
        customers,
        revenue,
        LAG(revenue) OVER (
            ORDER BY month
        ) AS previous_month_revenue
    FROM monthly_sales
)
SELECT
    month,
    orders,
    customers,
    ROUND(revenue::numeric, 2) AS revenue,
    ROUND(previous_month_revenue::numeric, 2) AS previous_month_revenue
FROM monthly_growth
ORDER BY month;

-- STEP 7. MoM growth
WITH monthly_sales AS (
    SELECT
        DATE_TRUNC('month', "InvoiceDate") AS month,
        COUNT(DISTINCT "Invoice") AS orders,
        COUNT(
            DISTINCT NULLIF(TRIM("Customer ID"), '')
        ) AS customers,
        SUM(revenue) AS revenue
    FROM sales
    GROUP BY DATE_TRUNC('month', "InvoiceDate")
),
monthly_growth AS (
    SELECT
        month,
        orders,
        customers,
        revenue,
        LAG(revenue) OVER (
            ORDER BY month
        ) AS previous_month_revenue
    FROM monthly_sales
)
SELECT
    month,
    orders,
    customers,
    ROUND(revenue::numeric, 2) AS revenue,
    ROUND(previous_month_revenue::numeric, 2) AS previous_month_revenue,
    ROUND(
        (
            (revenue - previous_month_revenue)
            / NULLIF(previous_month_revenue, 0)
            * 100
        )::numeric,
        2
    ) AS mom_growth_pct
FROM monthly_growth
ORDER BY month;

-- STEP 8. Финальный месячный анализ
WITH monthly_sales AS (
    SELECT
        DATE_TRUNC('month', "InvoiceDate") AS month,
        COUNT(DISTINCT "Invoice") AS orders,
        COUNT(
            DISTINCT NULLIF(TRIM("Customer ID"), '')
        ) AS customers,
        SUM(revenue) AS revenue
    FROM sales
    GROUP BY DATE_TRUNC('month', "InvoiceDate")
),
monthly_analysis AS (
    SELECT
        month,
        orders,
        customers,
        revenue,
        LAG(revenue) OVER (
            ORDER BY month
        ) AS previous_month_revenue
    FROM monthly_sales
)
SELECT
    month,
    orders,
    customers,
    ROUND(revenue::numeric, 2) AS revenue,
    ROUND(previous_month_revenue::numeric, 2) AS previous_month_revenue,
    ROUND(
        (
            (revenue - previous_month_revenue)
            / NULLIF(previous_month_revenue, 0)
            * 100
        )::numeric,
        2
    ) AS mom_growth_pct
FROM monthly_analysis
ORDER BY month;

-- STEP 9. Финальная проверка KPI
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT "Invoice") AS total_orders,
    COUNT(
        DISTINCT NULLIF(TRIM("Customer ID"), '')
    ) AS customers,
    COUNT(
        DISTINCT CASE
            WHEN NULLIF(TRIM("Customer ID"), '') IS NOT NULL
            THEN "Invoice"
        END
    ) AS orders_with_customer,
    ROUND(SUM(revenue)::numeric, 2) AS total_revenue,
    ROUND(
        (
            SUM(revenue)
            / COUNT(DISTINCT "Invoice")
        )::numeric,
        2
    ) AS avg_order_value
FROM sales;