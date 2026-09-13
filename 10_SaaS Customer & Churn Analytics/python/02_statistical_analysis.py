# =========================================
# 01 СТАТИСТИЧЕСКИЙ АНАЛИЗ
# =========================================

import pandas as pd
from scipy.stats import chi2_contingency

accounts = pd.read_csv("data/saas/accounts.csv")
subscriptions = pd.read_csv("data/saas/subscriptions.csv")

# Проверка связи между тарифом и churn
plan_table = pd.crosstab(
    accounts["plan_tier"],
    accounts["churn_flag"]
)

chi2_plan, p_value_plan, dof_plan, expected_plan = chi2_contingency(plan_table)

print("Связь между тарифом и churn:")
print(plan_table)
print(f"\nChi-square statistic: {chi2_plan:.4f}")
print(f"P-value: {p_value_plan:.4f}")

if p_value_plan < 0.05:
    print("Вывод: существует статистически значимая связь между тарифом и churn.")
else:
    print("Вывод: статистически значимой связи между тарифом и churn не обнаружено.")

# Проверка связи между отраслью и churn
industry_table = pd.crosstab(
    accounts["industry"],
    accounts["churn_flag"]
)

chi2_industry, p_value_industry, dof_industry, expected_industry = chi2_contingency(
    industry_table
)

print("\nСвязь между отраслью и churn:")
print(industry_table)

print(f"\nChi-square statistic: {chi2_industry:.4f}")
print(f"P-value: {p_value_industry:.4f}")

if p_value_industry < 0.05:
    print("Вывод: существует статистически значимая связь между отраслью и churn.")
else:
    print("Вывод: статистически значимой связи между отраслью и churn не обнаружено.")

# Проверка связи между страной и churn
country_table = pd.crosstab(
    accounts["country"],
    accounts["churn_flag"]
)

chi2_country, p_value_country, dof_country, expected_country = chi2_contingency(
    country_table
)

print("\nСвязь между страной и churn:")
print(country_table)

print(f"\nChi-square statistic: {chi2_country:.4f}")
print(f"P-value: {p_value_country:.4f}")

if p_value_country < 0.05:
    print("Вывод: существует статистически значимая связь между страной и churn.")
else:
    print("Вывод: статистически значимой связи между страной и churn не обнаружено.")    

from scipy.stats import mannwhitneyu

# Проверка различий в размере клиентов между churn и non-churn
churned_seats = accounts.loc[
    accounts["churn_flag"],
    "seats"
]

active_seats = accounts.loc[
    ~accounts["churn_flag"],
    "seats"
]

statistic_seats, p_value_seats = mannwhitneyu(
    churned_seats,
    active_seats,
    alternative="two-sided"
)

print("\nСвязь размера клиента (seats) и churn:")
print(f"Медиана seats у churn клиентов: {churned_seats.median():.2f}")
print(f"Медиана seats у non-churn клиентов: {active_seats.median():.2f}")
print(f"Mann-Whitney U statistic: {statistic_seats:.2f}")
print(f"P-value: {p_value_seats:.4f}")

if p_value_seats < 0.05:
    print("Вывод: размер клиента статистически значимо различается между churn и non-churn.")
else:
    print("Вывод: статистически значимого различия в размере клиентов не обнаружено.")

# Проверка MRR и churn

customer_mrr = (
    subscriptions.groupby("account_id")["mrr_amount"]
    .sum()
    .reset_index()
)

customer_mrr = customer_mrr.merge(
    accounts[["account_id","churn_flag"]],
    on="account_id",
    how="left"
)

churned_mrr = customer_mrr.loc[
    customer_mrr["churn_flag"],
    "mrr_amount"
]

non_churn_mrr = customer_mrr.loc[
    ~customer_mrr["churn_flag"],
    "mrr_amount"
]

statistic_mrr, p_value_mrr = mannwhitneyu(
    churned_mrr,
    non_churn_mrr,
    alternative="two-sided"
)

print("\nСвязь MRR и churn:")
print(f"Медиана MRR у churn клиентов: ${churned_mrr.median():,.2f}")
print(f"Медиана MRR у non-churn клиентов: ${non_churn_mrr.median():,.2f}")
print(f"Mann-Whitney U statistic: {statistic_mrr:.2f}")
print(f"P-value: {p_value_mrr:.4f}")

if p_value_mrr < 0.05:
    print("Вывод: MRR статистически значимо различается между churn и non-churn.")
else:
    print("Вывод: статистически значимого различия MRR не обнаружено.")