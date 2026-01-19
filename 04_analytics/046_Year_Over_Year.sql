
SELECT 
    EXTRACT(YEAR FROM order_date) AS sales_year,
    SUM(total_amount) AS yearly_revenue
FROM orders
WHERE EXTRACT(MONTH FROM order_date) = 1
GROUP BY sales_year;