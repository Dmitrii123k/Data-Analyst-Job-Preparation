import pandas as pd
from scipy import stats

# Данные
sales = [100, 110, 105, 95, 100, 120, 125, 115, 130, 110]

# Создаём DataFrame
df = pd.DataFrame({
    "sales": sales
})

# Среднее
mean_sales = df["sales"].mean()

print("Среднее:", mean_sales)

# 95% доверительный интервал
confidence_interval = stats.t.interval(
    confidence=0.95,
    df=len(df["sales"]) - 1,
    loc=mean_sales,
    scale=stats.sem(df["sales"])
)

print("95% доверительный интервал:", confidence_interval)

# Данные для корреляции
df = pd.DataFrame({
    "advertising": [10, 20, 30, 40, 50],
    "sales": [100, 120, 150, 180, 210],
    "customers": [20, 25, 30, 38, 45]
})

# Корреляция между рекламой и продажами
correlation = df["advertising"].corr(df["sales"])

print("Корреляция advertising и sales:", correlation)

# Корреляционная матрица
correlation_matrix = df.corr()

print("Корреляционная матрица:")
print(correlation_matrix)