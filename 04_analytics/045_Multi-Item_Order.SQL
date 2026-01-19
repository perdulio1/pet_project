SELECT 
      u.first_name
    , u.last_name
    , o.order_date
    , oi.quantity
    , oi.price_at_purchase
FROM users u
JOIN orders o ON u.user_id = o.user_id
JOIN order_items oi ON o.order_id = oi.order_id;