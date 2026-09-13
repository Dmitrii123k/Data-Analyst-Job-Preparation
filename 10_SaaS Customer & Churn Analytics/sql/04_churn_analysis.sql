-- =========================================
-- 04 АНАЛИЗ ОТТОКА
-- =========================================

-- 1. Причины оттока клиентов
SELECT reason_code,COUNT(*) AS churn_events,SUM(refund_amount_usd) AS total_refund,ROUND(AVG(refund_amount_usd),2) AS average_refund
FROM churn_events
GROUP BY reason_code
ORDER BY churn_events DESC;

-- 2. Отток после повышения и понижения тарифа
SELECT SUM(CASE WHEN preceding_upgrade_flag THEN 1 ELSE 0 END) AS churn_after_upgrade,SUM(CASE WHEN preceding_downgrade_flag THEN 1 ELSE 0 END) AS churn_after_downgrade,COUNT(*) AS total_churn_events
FROM churn_events;

-- 3. Реактивации после оттока
SELECT SUM(CASE WHEN is_reactivation THEN 1 ELSE 0 END) AS reactivation_events,COUNT(*) AS total_churn_events,ROUND(SUM(CASE WHEN is_reactivation THEN 1 ELSE 0 END) * 100.0 / COUNT(*),2) AS reactivation_rate_pct
FROM churn_events;

-- 4. Отток по месяцам
SELECT DATE_TRUNC('month',churn_date)::DATE AS month,COUNT(*) AS churn_events,SUM(refund_amount_usd) AS total_refund
FROM churn_events
GROUP BY DATE_TRUNC('month',churn_date)
ORDER BY month;