-- =========================================
-- 02 АНАЛИЗ КЛИЕНТОВ
-- =========================================

-- 1. Общий показатель оттока клиентов
SELECT COUNT(*) AS total_customers,SUM(CASE WHEN churn_flag THEN 1 ELSE 0 END) AS churned_customers,ROUND(SUM(CASE WHEN churn_flag THEN 1 ELSE 0 END) * 100.0 / COUNT(*),2) AS churn_rate_pct
FROM accounts;

-- 2. Показатель оттока по тарифам
SELECT plan_tier,COUNT(*) AS total_customers,SUM(CASE WHEN churn_flag THEN 1 ELSE 0 END) AS churned_customers,ROUND(SUM(CASE WHEN churn_flag THEN 1 ELSE 0 END) * 100.0 / COUNT(*),2) AS churn_rate_pct
FROM accounts
GROUP BY plan_tier
ORDER BY churn_rate_pct DESC;

-- 3. Показатель оттока по отраслям
SELECT industry,COUNT(*) AS total_customers,SUM(CASE WHEN churn_flag THEN 1 ELSE 0 END) AS churned_customers,ROUND(SUM(CASE WHEN churn_flag THEN 1 ELSE 0 END) * 100.0 / COUNT(*),2) AS churn_rate_pct
FROM accounts
GROUP BY industry
ORDER BY churn_rate_pct DESC;

-- 4. Показатель оттока по странам
SELECT country,COUNT(*) AS total_customers,SUM(CASE WHEN churn_flag THEN 1 ELSE 0 END) AS churned_customers,ROUND(SUM(CASE WHEN churn_flag THEN 1 ELSE 0 END) * 100.0 / COUNT(*),2) AS churn_rate_pct
FROM accounts
GROUP BY country
ORDER BY churn_rate_pct DESC;