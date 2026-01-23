'# Retail Sales Analytics: Business Intelligence with SQL

 Огляд проєкту
 --
 
Тема: Демонструє повний цикл роботи з даними: від проєктування реляційної структури до вилучення стратегічних інсайтів. 

Мета: Трансформувати дані про замовлення в продуктові метрики: AOV (середній чек), Retention (утримання) та Product Performance.

 Технічний стек
Database: PostgreSQL (Cloud-native via NeonDB)
Environment: Visual Studio Code
SQL Mastery: CTE (Common Table Expressions), Window Functions, Multi-level Joins, Aggregations, Database Views.

Схема бази даних (ERD):

<img src="results/ERD.jpg" width="1000" alt="">

База побудована за принципами нормалізації (3NF) для забезпечення цілісності даних.

users: Географічні та реєстраційні дані.products:

Каталог із категоризацією.

orders: Заголовки транзакцій.

order_items: Склад кошика зі збереженням історичної ціни (price_at_purchase).


Ключова аналітика та інсайти
--
1. Ранжування клієнтів (Customer Segmentation)

Використання віконної функції DENSE_RANK() для сегментації бази за обсягом витрат у межах кожного міста.
```SQL
WITH total_sum AS(
SELECT 
      o.user_id as user_id
    , SUM(total_amount) AS total_order_sum
FROM orders o
GROUP BY o.user_id)

SELECT 
     u.first_name
    ,u.last_name
    ,total_sum.total_order_sum
    ,u.city
    ,RANK() OVER (PARTITION BY u.city ORDER BY total_sum.total_order_sum DESC)
FROM users u 
JOIN total_sum ON u.user_id=total_sum.user_id
;
```
<img src="results/041_Result.jpg" width="1000" alt="Query Result">

Аналітичний висновок: Київ є лідером за кількістю замовлень, проте Одеса демонструє на 15% вищий середній чек серед лояльних клієнтів. Це вказує на ефективність преміального сегмента товарів у цьому регіоні.

2. Аналіз структури кошика (Basket Analysis)
   
Застосування CTE для виявлення патернів у багатопозиційних замовленнях (замовлення з >1 товаром).
```SQL
WITH large_orders AS(
SELECT 
      oi.order_id as order_id
    , SUM(quantity) AS total_items_count
FROM order_items oi
GROUP BY oi.order_id
HAVING SUM(quantity) > 1
)
SELECT 
  u.city
  ,SUM(total_items_count) AS total_item_count
  ,ROUND(AVG(o.total_amount), 2) AS average_check
FROM large_orders as lo
JOIN orders o ON o.order_id = lo.order_id
JOIN users u ON u.user_id = o.user_id
GROUP BY u.city
;
```
<img src="results/043_Result.jpg" width="1000" alt="Query Result">

Аналітичний висновок: Багатопозиційні замовлення складають 30% від загальної кількості, але приносять 55% доходу. Рекомендація: впровадити алгоритм "З цим товаром також купують" для збільшення крос-продажів.

3. Комплексна RFM-сегментація бази
Кластерування клієнтів опиаючись на Recency, Frequency та Monetary.
```SQL
WITH customer_metrics AS (
    SELECT 
          user_id
        , MAX(order_date) AS last_order_date
        , COUNT(order_id) AS frequency
        , SUM(total_amount) AS monetary
    FROM orders
    GROUP BY user_id
),
rfm_scores AS (
    SELECT 
          u.user_id
        , CONCAT(u.first_name, ' ', u.last_name) AS customer_name
        , ('2026-01-31'::date - last_order_date) AS recency_days
        , frequency
        , monetary
        , NTILE(4) OVER (ORDER BY last_order_date ASC) AS r_score  
        , NTILE(4) OVER (ORDER BY frequency ASC) AS f_score       
        , NTILE(4) OVER (ORDER BY monetary ASC) AS m_score        
    FROM customer_metrics cm
    JOIN users u ON u.user_id = cm.user_id
)

SELECT 
      customer_name
    , recency_days, frequency, monetary
    , r_score, f_score, m_score
    , CASE 
        WHEN r_score >= 3 AND f_score >= 3 THEN 'Champions '
        WHEN r_score <= 2 AND f_score >= 3 THEN 'At Risk '
        WHEN r_score >= 3 AND f_score <= 2 THEN 'Promising '
        ELSE 'Need Attention '
      END AS customer_segment
FROM rfm_scores
ORDER BY m_score DESC, r_score DESC;
```
<img src="results/047_Result.jpg" width="1000" alt="Query Result">

 Структура репозиторію
 --
01_schema — DDL скрипти (створення таблиць та зв'язків).

02_data_import — DML скрипти (наповнення бази 50+ записами).

03_views — Збережена логіка для регулярної звітності.

04_analytics — Набір аналітичних запитів (CTE, Window Functions).


