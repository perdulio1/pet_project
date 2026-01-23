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