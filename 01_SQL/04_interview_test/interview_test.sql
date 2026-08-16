-- =========================================
-- INTERVIEW TEST
-- WINDOW FUNCTIONS
-- SALES DATASET
-- =========================================


-- 1. 
-- Три лучших клиента по выручке в каждой стране

WITH customer_revenue AS (
    SELECT
        "Country",
        "CustomerID",
        SUM("Quantity" * "Price") AS total_revenue
    FROM sales
    WHERE "CustomerID" IS NOT NULL
    GROUP BY
        "Country",
        "CustomerID"
),
ranked_customers AS (
    SELECT
        "Country",
        "CustomerID",
        total_revenue,
        ROW_NUMBER() OVER (
            PARTITION BY "Country"
            ORDER BY total_revenue DESC
        ) AS rank
    FROM customer_revenue
)
SELECT
    "Country",
    "CustomerID",
    ROUND(total_revenue::numeric, 2) AS total_revenue,
    rank
FROM ranked_customers
WHERE rank <= 3
ORDER BY
    "Country",
    rank;


-- 2. 
-- Ранжирование клиентов по выручке внутри страны

WITH customer_revenue AS (
    SELECT
        "Country",
        "CustomerID",
        SUM("Quantity" * "Price") AS total_revenue
    FROM sales
    WHERE "CustomerID" IS NOT NULL
    GROUP BY
        "Country",
        "CustomerID"
)
SELECT
    "Country",
    "CustomerID",
    ROUND(total_revenue::numeric, 2) AS total_revenue,
    RANK() OVER (
        PARTITION BY "Country"
        ORDER BY total_revenue DESC
    ) AS rank
FROM customer_revenue
ORDER BY
    "Country",
    rank;


-- 3. 
-- Сравнение текущей покупки с предыдущей покупкой клиента

WITH customer_orders AS (
    SELECT
        "CustomerID",
        "Invoice",
        "InvoiceDate",
        SUM("Quantity" * "Price") AS order_revenue
    FROM sales
    WHERE "CustomerID" IS NOT NULL
    GROUP BY
        "CustomerID",
        "Invoice",
        "InvoiceDate"
)
SELECT
    "CustomerID",
    "Invoice",
    "InvoiceDate",
    ROUND(order_revenue::numeric, 2) AS order_revenue,
    ROUND(
        LAG(order_revenue) OVER (
            PARTITION BY "CustomerID"
            ORDER BY "InvoiceDate"
        )::numeric,
        2
    ) AS previous_revenue
FROM customer_orders
ORDER BY
    "CustomerID",
    "InvoiceDate";


-- 4. 
-- Определить следующую покупку клиента

WITH customer_orders AS (
    SELECT
        "CustomerID",
        "Invoice",
        "InvoiceDate",
        SUM("Quantity" * "Price") AS order_revenue
    FROM sales
    WHERE "CustomerID" IS NOT NULL
    GROUP BY
        "CustomerID",
        "Invoice",
        "InvoiceDate"
)
SELECT
    "CustomerID",
    "Invoice",
    "InvoiceDate",
    ROUND(order_revenue::numeric, 2) AS order_revenue,
    LEAD("InvoiceDate") OVER (
        PARTITION BY "CustomerID"
        ORDER BY "InvoiceDate"
    ) AS next_purchase_date,
    ROUND(
        LEAD(order_revenue) OVER (
            PARTITION BY "CustomerID"
            ORDER BY "InvoiceDate"
        )::numeric,
        2
    ) AS next_purchase_revenue
FROM customer_orders
ORDER BY
    "CustomerID",
    "InvoiceDate";


-- 5. 
-- Изменение текущей покупки относительно предыдущей в процентах

WITH customer_orders AS (
    SELECT
        "CustomerID",
        "Invoice",
        "InvoiceDate",
        SUM("Quantity" * "Price") AS order_revenue
    FROM sales
    WHERE "CustomerID" IS NOT NULL
    GROUP BY
        "CustomerID",
        "Invoice",
        "InvoiceDate"
),
purchases AS (
    SELECT
        "CustomerID",
        "Invoice",
        "InvoiceDate",
        order_revenue,
        LAG(order_revenue) OVER (
            PARTITION BY "CustomerID"
            ORDER BY "InvoiceDate"
        ) AS previous_revenue
    FROM customer_orders
)
SELECT
    "CustomerID",
    "Invoice",
    "InvoiceDate",
    ROUND(previous_revenue::numeric, 2) AS previous_revenue,
    ROUND(order_revenue::numeric, 2) AS current_revenue,
    ROUND(
        (
            (order_revenue - previous_revenue)
            / NULLIF(previous_revenue, 0) * 100
        )::numeric,
        2
    ) AS revenue_growth_percent
FROM purchases
WHERE previous_revenue IS NOT NULL
ORDER BY
    "CustomerID",
    "InvoiceDate";


-- 6. 
-- Найти клиентов, у которых текущая покупка больше предыдущей

WITH customer_orders AS (
    SELECT
        "CustomerID",
        "Invoice",
        "InvoiceDate",
        SUM("Quantity" * "Price") AS order_revenue
    FROM sales
    WHERE "CustomerID" IS NOT NULL
    GROUP BY
        "CustomerID",
        "Invoice",
        "InvoiceDate"
),
purchases AS (
    SELECT
        "CustomerID",
        "Invoice",
        "InvoiceDate",
        order_revenue,
        LAG(order_revenue) OVER (
            PARTITION BY "CustomerID"
            ORDER BY "InvoiceDate"
        ) AS previous_revenue
    FROM customer_orders
)
SELECT
    "CustomerID",
    "Invoice",
    "InvoiceDate",
    ROUND(previous_revenue::numeric, 2) AS previous_revenue,
    ROUND(order_revenue::numeric, 2) AS current_revenue,
    ROUND(
        (
            (order_revenue - previous_revenue)
            / NULLIF(previous_revenue, 0) * 100
        )::numeric,
        2
    ) AS revenue_growth_percent
FROM purchases
WHERE previous_revenue IS NOT NULL
  AND order_revenue > previous_revenue
ORDER BY
    revenue_growth_percent DESC;