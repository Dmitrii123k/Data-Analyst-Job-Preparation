-- =========================================
-- 05 АНАЛИЗ ПРОДУКТА И ПОДДЕРЖКИ
-- =========================================

-- 1. Использование функций продукта
SELECT feature_name,SUM(usage_count) AS total_usage,SUM(usage_duration_secs) AS total_duration_secs,SUM(error_count) AS total_errors,COUNT(DISTINCT subscription_id) AS subscriptions_using_feature
FROM feature_usage
GROUP BY feature_name
ORDER BY total_usage DESC;

-- 2. Ошибки и эффективность использования функций
SELECT feature_name,SUM(usage_count) AS total_usage,SUM(error_count) AS total_errors,ROUND(SUM(error_count) * 100.0 / NULLIF(SUM(usage_count),0),2) AS error_rate_pct
FROM feature_usage
GROUP BY feature_name
ORDER BY error_rate_pct DESC;

-- 3. Основные показатели работы поддержки
SELECT COUNT(*) AS total_tickets,ROUND(AVG(resolution_time_hours),2) AS average_resolution_hours,ROUND(AVG(first_response_time_minutes),2) AS average_first_response_minutes,ROUND(AVG(satisfaction_score),2) AS average_satisfaction,SUM(CASE WHEN escalation_flag THEN 1 ELSE 0 END) AS escalated_tickets
FROM support_tickets;

-- 4. Обращения в поддержку по приоритетам
SELECT priority,COUNT(*) AS total_tickets,ROUND(AVG(resolution_time_hours),2) AS average_resolution_hours,ROUND(AVG(satisfaction_score),2) AS average_satisfaction,SUM(CASE WHEN escalation_flag THEN 1 ELSE 0 END) AS escalated_tickets
FROM support_tickets
GROUP BY priority
ORDER BY total_tickets DESC;

