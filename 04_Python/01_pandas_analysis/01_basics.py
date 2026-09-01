import pandas as pd

# 1. Загружаем данные
df = pd.read_csv("data/retail/online_retail_II.csv")

# 2. Общая информация
print(df.head())
print(df.shape)
print(df.info())

# 3. Проверяем пропуски
print(df.isna().sum())

# 4. Процент пропусков
print(df.isna().mean() * 100)

# 5. Уникальные клиенты
print(df["Customer ID"].nunique())

# 6. Количество строк без Customer ID
print(df["Customer ID"].isna().sum())

# 7. Оставляем только строки с известным клиентом
df_customers = df.dropna(subset=["Customer ID"])

print(df_customers.shape)
print(df_customers["Customer ID"].nunique())

# 8. Создаём Revenue
df_customers["Revenue"] = (
    df_customers["Quantity"] * df_customers["Price"]
)

print(df_customers[["Quantity", "Price", "Revenue"]].head())

# 9. Выручка по клиентам
customer_revenue = (
    df_customers
    .groupby("Customer ID")["Revenue"]
    .sum()
    .sort_values(ascending=False)
)

print(customer_revenue.head(10))

# 10. Статистика клиентов
customer_stats = (
    df_customers
    .groupby("Customer ID")
    .agg(
        revenue=("Revenue", "sum"),
        orders=("Invoice", "nunique")
    )
)

# 11. Средний чек
customer_stats["avg_check"] = (
    customer_stats["revenue"] / customer_stats["orders"]
)

print(
    customer_stats
    .sort_values("avg_check", ascending=False)
    .head(10)
)

# 12. Очищаем данные от отрицательных и нулевых продаж
df_sales = df_customers[
    (df_customers["Quantity"] > 0) &
    (df_customers["Price"] > 0)
].copy()

print(df_sales.shape)
print(df_sales["Revenue"].sum())

# 13. Пересчитываем статистику клиентов после очистки
customer_stats = (
    df_sales
    .groupby("Customer ID")
    .agg(
        revenue=("Revenue", "sum"),
        orders=("Invoice", "nunique")
    )
)

# 14. Средний чек после очистки
customer_stats["avg_check"] = (
    customer_stats["revenue"] / customer_stats["orders"]
)

# 15. TOP-10 клиентов по выручке
print(
    customer_stats
    .sort_values("revenue", ascending=False)
    .head(10)
)

top_customers = customer_stats.sort_values(
    "revenue",
    ascending=False
).head(10)

print(top_customers)

# 16. Клиенты с высоким средним чеком и небольшим количеством заказов
high_check_customers = customer_stats[
    (customer_stats["avg_check"] > 5000) &
    (customer_stats["orders"] <= 5)
]

print(
    high_check_customers.sort_values(
        "avg_check",
        ascending=False
    )
)
print()

#17. TOP-10 клиентов по среднему чеку
top_avg_check = customer_stats.sort_values(
    "avg_check",
    ascending=False
).head(10)

print(top_avg_check)

# 18. Выручка по странам
country_revenue = df_sales.groupby("Country")["Revenue"].sum().sort_values(
    ascending=False
)

print(country_revenue.head(10))
print()
print()
# 19. TOP-10 товаров по выручке
top_products = df_sales.groupby("Description")["Revenue"].sum().sort_values(
    ascending=False
).head(10)

print(top_products)
print()
print()
# 20. Финальные показатели анализа
print("Количество клиентов:", df_sales["Customer ID"].nunique())
print("Количество строк:", len(df_sales))
print("Общая выручка:", df_sales["Revenue"].sum())
print("Средний чек:", df_sales["Revenue"].sum() / df_sales["Invoice"].nunique())
print("Количество заказов:", df_sales["Invoice"].nunique())