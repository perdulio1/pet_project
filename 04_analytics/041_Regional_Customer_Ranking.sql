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