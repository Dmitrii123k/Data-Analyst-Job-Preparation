import pandas as pd

# Данные
data = {
    "sales": [100, 120, 120, 130, 200]
}

# Создаём DataFrame
df = pd.DataFrame(data)

# Основная статистика
print(df["sales"].describe())
print()
# Квартили
q1 = df["sales"].quantile(0.25)
q2 = df["sales"].quantile(0.50)
q3 = df["sales"].quantile(0.75)

print("Q1:", q1)
print("Q2:", q2)
print("Q3:", q3)

# Межквартильный размах
iqr = q3 - q1

print("IQR:", iqr)
# Границы выбросов
lower_bound = q1 - 1.5 * iqr
upper_bound = q3 + 1.5 * iqr

print("Нижняя граница:", lower_bound)
print("Верхняя граница:", upper_bound)
# Выбросы
outliers = df[
    (df["sales"] < lower_bound) |
    (df["sales"] > upper_bound)
]

print("Выбросы:")
print(outliers)

import pandas as pd

# Данные
data = {
    "customer": ["A", "B", "C", "D", "E"],
    "purchase": [1, 0, 1, 1, 0]
}

# Создаём DataFrame
df = pd.DataFrame(data)

print(df)
# Вероятность покупки
purchase_probability = df["purchase"].sum() / len(df)

print("Вероятность покупки:", purchase_probability)
print("Вероятность покупки (%):", purchase_probability * 100)
# Вероятность отсутствия покупки
no_purchase_probability = (df["purchase"] == 0).sum() / len(df)

print("Вероятность без покупки:", no_purchase_probability)
print("Вероятность без покупки (%):", no_purchase_probability * 100)
# Количество каждого события
print(df["purchase"].value_counts())
# Доля каждого события
print(df["purchase"].value_counts(normalize=True))
# Тип клиента
df["segment"] = ["new", "new", "old", "old", "old"]

print(df)
# Old-клиенты
old_customers = df[df["segment"] == "old"]

# Вероятность покупки среди old-клиентов
old_purchase_probability = old_customers["purchase"].mean()

print("Вероятность покупки среди old:", old_purchase_probability)
print("Вероятность покупки среди old (%):", old_purchase_probability * 100)
# Вероятность покупки по сегментам
purchase_by_segment = df.groupby("segment")["purchase"].mean()

print("Вероятность покупки по сегментам:")
print(purchase_by_segment)
# Финальный анализ
total_customers = len(df)
total_purchases = df["purchase"].sum()
overall_probability = df["purchase"].mean()

print("Всего клиентов:", total_customers)
print("Всего покупок:", total_purchases)
print("Общая вероятность покупки:", overall_probability)
print("Общая вероятность покупки (%):", overall_probability * 100)