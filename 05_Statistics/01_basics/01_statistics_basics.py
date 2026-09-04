import pandas as pd

# Данные
data = {
    "sales": [100, 120, 120, 130, 200]
}

# Создаём DataFrame
df = pd.DataFrame(data)

# Проверяем данные
print(df)
print()

# Среднее значение
mean_sales = df["sales"].mean()

print("Среднее:", mean_sales)

# Количество наблюдений
sample_size = len(df)

print("Размер выборки:", sample_size)

# Медиана
median_sales = df["sales"].median()

print("Медиана:", median_sales)

# Мода
mode_sales = df["sales"].mode()

print("Мода:", mode_sales.tolist())

# Минимум
min_sales = df["sales"].min()

# Максимум
max_sales = df["sales"].max()

# Размах
range_sales = max_sales - min_sales

print("Минимум:", min_sales)
print("Максимум:", max_sales)
print("Размах:", range_sales)

# Дисперсия
variance_sales = df["sales"].var()

print("Дисперсия:", variance_sales)

# Стандартное отклонение
std_sales = df["sales"].std()

print("Стандартное отклонение:", std_sales)


# Итоговая статистика
print()
print("=== Итоговая статистика ===")
print("Количество:", df["sales"].count())
print("Среднее:", df["sales"].mean())
print("Медиана:", df["sales"].median())
print("Мода:", df["sales"].mode().tolist())
print("Минимум:", df["sales"].min())
print("Максимум:", df["sales"].max())
print("Размах:", df["sales"].max() - df["sales"].min())
print("Дисперсия:", df["sales"].var())
print("Стандартное отклонение:", df["sales"].std())