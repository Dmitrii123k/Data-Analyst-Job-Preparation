import pandas as pd

# =========================================
# 01 ЗАГРУЗКА И ПЕРВИЧНАЯ ПРОВЕРКА ДАННЫХ
# =========================================

# Загрузка данных
accounts = pd.read_csv("data/saas/accounts.csv")
churn_events = pd.read_csv("data/saas/churn_events.csv")
feature_usage = pd.read_csv("data/saas/feature_usage.csv")
subscriptions = pd.read_csv("data/saas/subscriptions.csv")
support_tickets = pd.read_csv("data/saas/support_tickets.csv")

# Преобразование дат
accounts["signup_date"] = pd.to_datetime(accounts["signup_date"])
churn_events["churn_date"] = pd.to_datetime(churn_events["churn_date"])
feature_usage["usage_date"] = pd.to_datetime(feature_usage["usage_date"])
subscriptions["start_date"] = pd.to_datetime(subscriptions["start_date"])
subscriptions["end_date"] = pd.to_datetime(subscriptions["end_date"])
support_tickets["submitted_at"] = pd.to_datetime(support_tickets["submitted_at"])
support_tickets["closed_at"] = pd.to_datetime(support_tickets["closed_at"])

# Размеры таблиц
print("Размеры таблиц:")
print("Accounts:", accounts.shape)
print("Churn events:", churn_events.shape)
print("Feature usage:", feature_usage.shape)
print("Subscriptions:", subscriptions.shape)
print("Support tickets:", support_tickets.shape)

# Информация о типах данных
print("\nТипы данных accounts:")
print(accounts.dtypes)

print("\nТипы данных subscriptions:")
print(subscriptions.dtypes)

# Проверка пропусков
print("\nПропуски:")
print("Accounts:")
print(accounts.isnull().sum())

print("\nSubscriptions:")
print(subscriptions.isnull().sum())

print("\nChurn events:")
print(churn_events.isnull().sum())

print("\nFeature usage:")
print(feature_usage.isnull().sum())

print("\nSupport tickets:")
print(support_tickets.isnull().sum())

# Проверка дубликатов
print("\nДубликаты:")
print("Accounts:", accounts.duplicated().sum())
print("Churn events:", churn_events.duplicated().sum())
print("Feature usage:", feature_usage.duplicated().sum())
print("Subscriptions:", subscriptions.duplicated().sum())
print("Support tickets:", support_tickets.duplicated().sum())

# =========================================
# БАЗОВАЯ СТАТИСТИКА
# =========================================

print("\nБазовая статистика клиентов:")
print(accounts[["seats"]].describe())

print("\nБазовая статистика подписок:")
print(subscriptions[["seats","mrr_amount","arr_amount"]].describe())

print("\nБазовая статистика использования функций:")
print(feature_usage[["usage_count","usage_duration_secs","error_count"]].describe())

print("\nБазовая статистика поддержки:")
print(support_tickets[["resolution_time_hours","first_response_time_minutes","satisfaction_score"]].describe())

# =========================================
# ОСНОВНЫЕ БИЗНЕС-МЕТРИКИ
# =========================================

total_customers = len(accounts)
churned_customers = accounts["churn_flag"].sum()
churn_rate = churned_customers / total_customers * 100

active_subscriptions = subscriptions["end_date"].isna().sum()
active_mrr = subscriptions.loc[subscriptions["end_date"].isna(), "mrr_amount"].sum()
active_arr = subscriptions.loc[subscriptions["end_date"].isna(), "arr_amount"].sum()

total_refunds = churn_events["refund_amount_usd"].sum()
reactivation_rate = churn_events["is_reactivation"].mean() * 100

average_satisfaction = support_tickets["satisfaction_score"].mean()
escalation_rate = support_tickets["escalation_flag"].mean() * 100

print("\nОсновные бизнес-метрики:")
print(f"Клиенты: {total_customers}")
print(f"Отток клиентов: {churned_customers}")
print(f"Churn rate: {churn_rate:.2f}%")
print(f"Активные подписки: {active_subscriptions}")
print(f"Active MRR: ${active_mrr:,.2f}")
print(f"Active ARR: ${active_arr:,.2f}")
print(f"Возвраты: ${total_refunds:,.2f}")
print(f"Reactivation rate: {reactivation_rate:.2f}%")
print(f"Средняя удовлетворённость: {average_satisfaction:.2f}")
print(f"Доля эскалаций: {escalation_rate:.2f}%")

# =========================================
# АНАЛИЗ CHURN ПО СЕГМЕНТАМ
# =========================================

print("\nChurn по тарифам:")
print(
    accounts.groupby("plan_tier")["churn_flag"]
    .agg(["count","sum","mean"])
    .assign(churn_rate_pct=lambda x: x["mean"] * 100)
    .sort_values("churn_rate_pct",ascending=False)
)

print("\nChurn по отраслям:")
print(
    accounts.groupby("industry")["churn_flag"]
    .agg(["count","sum","mean"])
    .assign(churn_rate_pct=lambda x: x["mean"] * 100)
    .sort_values("churn_rate_pct",ascending=False)
)

print("\nChurn по странам:")
print(
    accounts.groupby("country")["churn_flag"]
    .agg(["count","sum","mean"])
    .assign(churn_rate_pct=lambda x: x["mean"] * 100)
    .sort_values("churn_rate_pct",ascending=False)
)

# =========================================
# ПРИЧИНЫ ОТТОКА
# =========================================

print("\nПричины оттока:")
print(
    churn_events.groupby("reason_code")
    .agg(
        churn_events=("churn_event_id","count"),
        total_refund=("refund_amount_usd","sum"),
        average_refund=("refund_amount_usd","mean")
    )
    .sort_values("churn_events",ascending=False)
)

print("\nОтток после изменения тарифа:")
print(
    churn_events[
        ["preceding_upgrade_flag","preceding_downgrade_flag"]
    ].sum()
)

print("\nРеактивации:")
print(
    churn_events["is_reactivation"]
    .value_counts()
)
# =========================================
# ФИНАНСОВОЕ ВЛИЯНИЕ CHURN
# =========================================

churned_accounts = accounts[accounts["churn_flag"]].copy()

churned_subscriptions = subscriptions[
    subscriptions["account_id"].isin(churned_accounts["account_id"])
].copy()

churned_mrr = churned_subscriptions["mrr_amount"].sum()
churned_arr = churned_subscriptions["arr_amount"].sum()

total_mrr = subscriptions.loc[
    subscriptions["end_date"].isna(),
    "mrr_amount"
].sum()

print("\nФинансовое влияние churn:")
print(f"MRR клиентов с churn: ${churned_mrr:,.2f}")
print(f"ARR клиентов с churn: ${churned_arr:,.2f}")
print(f"Доля MRR клиентов с churn: {churned_mrr / total_mrr * 100:.2f}%")