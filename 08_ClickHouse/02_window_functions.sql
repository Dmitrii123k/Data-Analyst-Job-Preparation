-- =========================================
-- ClickHouse Window Functions
-- =========================================

-- =========================================
-- ROW_NUMBER
-- =========================================

-- Нумерация строк по цене от большей к меньшей
SELECT
    order_id,
    product,
    price,
    row_number() OVER
    (
        ORDER BY price DESC
    ) AS price_rank
FROM analytics.sales;

-- =========================================
-- RANK
-- =========================================

-- Ранжирование товаров отдельно внутри каждой страны
SELECT
    country,
    product,
    price,
    rank() OVER
    (
        PARTITION BY country
        ORDER BY price DESC
    ) AS product_rank
FROM analytics.sales;

-- =========================================
-- DENSE_RANK
-- =========================================

-- Ранжирование без пропусков в нумерации
SELECT
    country,
    product,
    price,
    dense_rank() OVER
    (
        PARTITION BY country
        ORDER BY price DESC
    ) AS product_rank
FROM analytics.sales;

-- =========================================
-- CUMULATIVE SUM
-- =========================================

-- Накопительная выручка по датам
SELECT
    order_date,
    quantity * price AS revenue,
    sum(quantity * price) OVER
    (
        ORDER BY order_date
    ) AS cumulative_revenue
FROM analytics.sales
ORDER BY order_date;