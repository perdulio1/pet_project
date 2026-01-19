SELECT 
      p.category
    , SUM(oi.quantity * oi.price_at_purchase) AS total_revenue
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.category
ORDER BY total_revenue DESC;