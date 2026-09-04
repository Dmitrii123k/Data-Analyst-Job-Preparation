import pandas as pd
from scipy.stats import ttest_ind

# Данные двух групп
data = {
    "group": ["A", "A", "A", "A", "A", "B", "B", "B", "B", "B"],
    "sales": [100, 110, 105, 95, 100, 120, 125, 115, 130, 110]
}

# Создаём DataFrame
df = pd.DataFrame(data)

print(df)
# Средние значения по группам
mean_a = df[df["group"] == "A"]["sales"].mean()
mean_b = df[df["group"] == "B"]["sales"].mean()

print("Среднее A:", mean_a)
print("Среднее B:", mean_b)
print("Разница:", mean_b - mean_a)
# Уровень значимости
alpha = 0.05

print("Уровень значимости:", alpha)
print("Уровень значимости (%):", alpha * 100)

# Данные групп
group_a = df[df["group"] == "A"]["sales"]
group_b = df[df["group"] == "B"]["sales"]

# t-test
test_result = ttest_ind(group_a, group_b)

print("t-statistic:", test_result.statistic)
print("p-value:", test_result.pvalue)

# Проверяем статистическую значимость
if test_result.pvalue < alpha:
    print("Результат статистически значим")
else:
    print("Результат статистически незначим")
    # Статистическая значимость
if test_result.pvalue < alpha:
    significant = True
else:
    significant = False

print("Статистически значимо:", significant)