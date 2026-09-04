import pandas as pd
from statsmodels.stats.proportion import proportions_ztest
from statsmodels.stats.proportion import confint_proportions_2indep

# Загружаем данные
df = pd.read_csv("data/ab_testing/AB Testing Data.csv")

# Первые строки
print(df.head())

# Размер данных
print("Размер данных:", df.shape)

# Информация о данных
print(df.info())

# Проверяем пропуски
print("\nПропуски:")
print(df.isna().sum())

# Проверяем дубликаты пользователей
print("\nДубликаты user_id:", df["user_id"].duplicated().sum())

# Проверяем группы
print("\nГруппы:")
print(df["group"].value_counts())

# Проверяем landing_page
print("\nLanding page:")
print(df["landing_page"].value_counts())

# Проверяем converted
print("\nConverted:")
print(df["converted"].value_counts())

# Conversion Rate по группам
conversion_by_group = df.groupby("group")["converted"].mean()

print("\nConversion Rate:")
print(conversion_by_group)

# В процентах
print("\nConversion Rate (%):")
print(conversion_by_group * 100)

from scipy.stats import chi2_contingency

# Таблица конверсий
conversion_table = pd.crosstab(
    df["group"],
    df["converted"]
)

print("\nТаблица конверсий:")
print(conversion_table)

# Chi-square test
chi2, p_value, dof, expected = chi2_contingency(conversion_table)

print("\nChi-square statistic:", chi2)
print("p-value:", p_value)

# Проверяем статистическую значимость
alpha = 0.05

if p_value < alpha:
    print("Результат статистически значим")
else:
    print("Результат статистически незначим")

# Количество конверсий
conversions = df.groupby("group")["converted"].sum()

# Количество пользователей
users = df.groupby("group")["converted"].count()

# Конверсии
count = [
    conversions["control"],
    conversions["treatment"]
]

# Размер групп
nobs = [
    users["control"],
    users["treatment"]
]

# Z-test для двух пропорций
z_stat, p_value = proportions_ztest(count, nobs)

print("\nZ-statistic:", z_stat)
print("p-value:", p_value)

# 95% доверительный интервал для разницы конверсий
ci_low, ci_high = confint_proportions_2indep(
    count1=count[1],
    nobs1=nobs[1],
    count2=count[0],
    nobs2=nobs[0],
    method="wald"
)

print("95% CI для разницы treatment - control:")
print(ci_low, ci_high)

# Выручка по группам
revenue_by_group = df.groupby("group")["purchase_amount"].sum()

print("\nRevenue by group:")
print(revenue_by_group)

# Средняя покупка
avg_purchase_by_group = df.groupby("group")["purchase_amount"].mean()

print("\nAverage purchase amount:")
print(avg_purchase_by_group)

# Средний чек только среди покупателей
avg_check = (
    df[df["converted"] == 1]
    .groupby("group")["purchase_amount"]
    .mean()
)

print("\nAverage check among converted users:")
print(avg_check)

# Conversion Rate по устройствам и группам
conversion_by_device = (
    df.groupby(["device_type", "group"])["converted"]
    .mean()
    .reset_index()
)

conversion_by_device["conversion_percent"] = (
    conversion_by_device["converted"] * 100
)

print("\nConversion Rate by device:")
print(conversion_by_device)

# Conversion Rate по странам и группам
conversion_by_location = (
    df.groupby(["location", "group"])["converted"]
    .mean()
    .reset_index()
)

conversion_by_location["conversion_percent"] = (
    conversion_by_location["converted"] * 100
)

print("\nConversion Rate by location:")
print(conversion_by_location)