SELECT
     users.user_id
    ,CONCAT(users.first_name, ' ', users.last_name) AS full_name
    ,COUNT(o.order_id) AS count_orders
    ,SUM(o.total_amount) AS total
    ,ROUND(AVG(o.total_amount), 2) as average
FROM orders o
JOIN users ON users.user_id = o.user_id
GROUP BY users.user_id
ORDER BY total DESC
;
