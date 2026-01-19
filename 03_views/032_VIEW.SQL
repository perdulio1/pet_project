CREATE VIEW v_city_large_orders_stats AS 
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

--SELECT * FROM total