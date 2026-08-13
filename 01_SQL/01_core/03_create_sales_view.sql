-- =========================================
-- DATA CLEANING
-- SALES DATASET
-- =========================================

CREATE OR REPLACE VIEW sales AS
SELECT
    "Invoice",
    "StockCode",
    "Description",
    "Quantity",
    "InvoiceDate",
    "Price",
    "Customer ID",
    "Country",

    "Quantity" * "Price" AS revenue

FROM clean_online_retail

WHERE
    "Quantity" > 0
    AND "Price" > 0
    AND "Invoice" NOT LIKE 'C%';