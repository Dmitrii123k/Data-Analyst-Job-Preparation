-- =========================================
-- DATA QUALITY
-- =========================================
-- 1. Проверка StockCode -> Description
SELECT
    "StockCode",
    COUNT(DISTINCT "Description") AS descriptions_count
FROM clean_online_retail
GROUP BY "StockCode"
HAVING COUNT(DISTINCT "Description") > 1
ORDER BY descriptions_count DESC;
-- 2. Статусы / служебные описания
SELECT
    "Description",
    COUNT(*) AS rows_count
FROM clean_online_retail
WHERE "Description" IS NOT NULL
GROUP BY "Description"
ORDER BY rows_count DESC;
-- 3. Проверка Price = 0
SELECT
    "StockCode",
    "Description",
    COUNT(*) AS rows_count,
    SUM("Quantity") AS total_quantity
FROM clean_online_retail
WHERE "Price" = 0
GROUP BY "StockCode", "Description"
ORDER BY rows_count DESC;
-- 4. Проверка отрицательных Quantity
SELECT
    COUNT(*) AS negative_rows,
    SUM(ABS("Quantity")) AS negative_quantity
FROM clean_online_retail
WHERE "Quantity" < 0;
-- 5. Аномально большие Quantity
SELECT
    "Invoice",
    "StockCode",
    "Description",
    "Quantity",
    "InvoiceDate",
    "Price",
    "Customer ID",
    "Country"
FROM clean_online_retail
WHERE ABS("Quantity") > 10000
ORDER BY ABS("Quantity") DESC;
-- 6. Top-10 товаров по отрицательному Quantity
SELECT
    "StockCode",
    "Description",
    SUM(ABS("Quantity")) AS returned_qty
FROM clean_online_retail
WHERE "Quantity" < 0
  AND "StockCode" NOT IN ('M', 'DOT', 'POST')
GROUP BY "StockCode", "Description"
ORDER BY returned_qty DESC
LIMIT 10;
-- 7. Возвратные заказы
SELECT
    COUNT(DISTINCT "Invoice") AS return_orders,
    SUM(ABS("Quantity")) AS returned_quantity,
    ROUND(SUM(ABS("Quantity") * "Price")::numeric, 2) AS returned_value
FROM clean_online_retail
WHERE "Invoice" LIKE 'C%';
-- 8. Проверка количества возвратов
SELECT
    COUNT(*) AS negative_rows,
    SUM(
        CASE
            WHEN "Quantity" < 0 THEN ABS("Quantity")
            ELSE 0
        END
    ) AS returned_quantity
FROM clean_online_retail;
-- 9. Проверка служебных позиций
SELECT
    "StockCode",
    "Description",
    COUNT(*) AS rows_count,
    ROUND(SUM("Quantity" * "Price")::numeric, 2) AS revenue
FROM clean_online_retail
WHERE "StockCode" IN ('M', 'DOT', 'POST')
GROUP BY "StockCode", "Description"
ORDER BY revenue DESC;