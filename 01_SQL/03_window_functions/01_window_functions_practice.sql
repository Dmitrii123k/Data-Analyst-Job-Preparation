-- =========================================
-- WINDOW FUNCTIONS
-- SALES DATASET
-- =========================================

-- 1. OVER()
-- Общая выручка по всему dataset

SELECT
    "Country",
    "Invoice",
    revenue,
    SUM(revenue) OVER() AS total_revenue
FROM sales
LIMIT 20;


-- 2. PARTITION BY
-- Выручка отдельно по каждой стране
-- Строки сохраняются

SELECT
    "Country",
    "Invoice",
    revenue,
    SUM(revenue) OVER(
        PARTITION BY "Country"
    ) AS country_revenue
FROM sales
LIMIT 20;


-- 3. ROW_NUMBER()
-- Нумерация продаж по выручке

SELECT
    "Country",
    "Invoice",
    revenue,
    ROW_NUMBER() OVER(
        ORDER BY revenue DESC
    ) AS sale_rank
FROM sales
LIMIT 20;


-- 4. ROW_NUMBER() + PARTITION BY
-- Нумерация продаж отдельно внутри каждой страны

SELECT
    "Country",
    "Invoice",
    revenue,
    ROW_NUMBER() OVER(
        PARTITION BY "Country"
        ORDER BY revenue DESC
    ) AS country_sale_number
FROM sales;


-- 5. RANK()
-- Рейтинг продаж с одинаковыми позициями
-- Одинаковые значения получают одинаковый ранг
-- Пропуски в нумерации сохраняются

SELECT
    "Country",
    "Invoice",
    revenue,
    RANK() OVER(
        PARTITION BY "Country"
        ORDER BY revenue DESC
    ) AS revenue_rank
FROM sales
WHERE "Country" = 'Australia'
LIMIT 20;


-- 6. DENSE_RANK()
-- Рейтинг без пропусков после одинаковых значений

SELECT
    "Country",
    "Invoice",
    revenue,
    DENSE_RANK() OVER(
        PARTITION BY "Country"
        ORDER BY revenue DESC
    ) AS revenue_rank
FROM sales
WHERE "Country" = 'Australia'
LIMIT 20;


-- 7. LAG()
-- Получение значения предыдущей строки

SELECT
    "Country",
    "Invoice",
    revenue,
    LAG(revenue) OVER(
        PARTITION BY "Country"
        ORDER BY revenue
    ) AS previous_revenue
FROM sales
WHERE "Country" = 'Australia'
LIMIT 20;


-- 8. LEAD()
-- Получение значения следующей строки

SELECT
    "Country",
    "Invoice",
    revenue,
    LEAD(revenue) OVER(
        PARTITION BY "Country"
        ORDER BY revenue
    ) AS next_revenue
FROM sales
WHERE "Country" = 'Australia'
LIMIT 20;


-- 9. НАКОПИТЕЛЬНЫЙ ИТОГ
-- Накопительная выручка внутри каждой страны

SELECT
    "Country",
    "Invoice",
    revenue,
    SUM(revenue) OVER(
        PARTITION BY "Country"
        ORDER BY revenue
    ) AS cumulative_revenue
FROM sales
WHERE "Country" = 'Australia'
LIMIT 20;


-- 10. ФИНАЛЬНАЯ ПРАКТИКА
-- Top-3 продажи внутри каждой страны
-- CTE + ROW_NUMBER()

WITH ranked_sales AS (
    SELECT
        "Country",
        "Invoice",
        revenue,
        ROW_NUMBER() OVER(
            PARTITION BY "Country"
            ORDER BY revenue DESC
        ) AS sale_rank
    FROM sales
)
SELECT
    "Country",
    "Invoice",
    revenue,
    sale_rank
FROM ranked_sales
WHERE sale_rank <= 3
ORDER BY
    "Country",
    sale_rank;