-- =========================================
-- 03 АНАЛИЗ ВЫРУЧКИ И ПОДПИСОК
-- =========================================

-- 1. Текущий MRR и ARR по активным подпискам
SELECT COUNT(*) AS active_subscriptions,SUM(mrr_amount) AS active_mrr,SUM(arr_amount) AS active_arr
FROM subscriptions
WHERE end_date IS NULL;

-- 2. Средний MRR на активную подписку
SELECT ROUND(AVG(mrr_amount),2) AS average_mrr_per_subscription
FROM subscriptions
WHERE end_date IS NULL;

-- 3. Текущий MRR по тарифам
SELECT plan_tier,COUNT(*) AS active_subscriptions,SUM(mrr_amount) AS active_mrr,ROUND(AVG(mrr_amount),2) AS average_mrr
FROM subscriptions
WHERE end_date IS NULL
GROUP BY plan_tier
ORDER BY active_mrr DESC;

-- 4. Доля текущего MRR по тарифам
SELECT plan_tier,SUM(mrr_amount) AS active_mrr,ROUND(SUM(mrr_amount) * 100.0 / SUM(SUM(mrr_amount)) OVER (),2) AS mrr_share_pct
FROM subscriptions
WHERE end_date IS NULL
GROUP BY plan_tier
ORDER BY active_mrr DESC;

-- 5. Динамика MRR по месяцам начала подписок
SELECT DATE_TRUNC('month',start_date)::DATE AS month,SUM(mrr_amount) AS mrr
FROM subscriptions
GROUP BY DATE_TRUNC('month',start_date)
ORDER BY month;