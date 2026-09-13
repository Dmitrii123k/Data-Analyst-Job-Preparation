-- =========================================
-- 01 ОБЗОР ДАННЫХ
-- =========================================

-- 1. Количество клиентов
SELECT COUNT(*) AS total_customers
FROM accounts;

-- 2. Количество подписок
SELECT COUNT(*) AS total_subscriptions
FROM subscriptions;

-- 3. Количество событий оттока
SELECT COUNT(*) AS total_churn_events
FROM churn_events;

-- 4. Количество записей использования функций
SELECT COUNT(*) AS total_feature_usage_records
FROM feature_usage;

-- 5. Количество обращений в поддержку
SELECT COUNT(*) AS total_support_tickets
FROM support_tickets;

-- 6. Период регистрации клиентов
SELECT MIN(signup_date) AS first_signup_date,MAX(signup_date) AS last_signup_date
FROM accounts;

-- 7. Период подписок
SELECT MIN(start_date) AS first_subscription_date,MAX(end_date) AS last_subscription_end_date
FROM subscriptions;

-- 8. Текущий MRR и ARR
SELECT SUM(mrr_amount) AS active_mrr,SUM(arr_amount) AS active_arr
FROM subscriptions
WHERE end_date IS NULL;

-- 9. Распределение клиентов по тарифам
SELECT plan_tier,COUNT(*) AS customers,ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (),2) AS customer_share_pct
FROM accounts
GROUP BY plan_tier
ORDER BY customers DESC;