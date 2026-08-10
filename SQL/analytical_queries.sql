-- 01: Revenue and profit by month
SELECT DATE_TRUNC('month', order_date) AS month,
       SUM(net_sales) AS revenue,
       SUM(gross_profit) AS gross_profit
FROM orders
GROUP BY 1 ORDER BY 1;

-- 02: Top customers by CLV proxy
WITH customer_value AS (
    SELECT customer_id,
           SUM(net_sales) AS revenue,
           COUNT(DISTINCT order_id) AS orders,
           AVG(net_sales) AS aov
    FROM orders GROUP BY customer_id
)
SELECT *, ROUND(aov * orders * 2.2 * 0.65, 2) AS estimated_clv
FROM customer_value
ORDER BY estimated_clv DESC
LIMIT 20;

-- 03: RFM base metrics
SELECT customer_id,
       MAX(order_date) AS last_purchase,
       COUNT(DISTINCT order_id) AS frequency,
       SUM(net_sales) AS monetary
FROM orders
GROUP BY customer_id;

-- 04: Category performance
SELECT p.category,
       SUM(o.net_sales) AS revenue,
       SUM(o.gross_profit) AS profit,
       SUM(o.quantity) AS units
FROM orders o JOIN products p ON o.product_id=p.product_id
GROUP BY p.category ORDER BY revenue DESC;

-- 05: Inventory stock-out risk
SELECT i.product_id, p.category,
       AVG(i.closing_stock) AS avg_closing_stock,
       SUM(i.units_sold) AS units_sold
FROM inventory_monthly i
JOIN products p ON i.product_id=p.product_id
GROUP BY i.product_id,p.category
HAVING AVG(i.closing_stock) < 40
ORDER BY avg_closing_stock;

-- 06: Cohort retention
WITH first_purchase AS (
  SELECT customer_id, DATE_TRUNC('month', MIN(order_date)) cohort_month
  FROM orders GROUP BY customer_id
),
activity AS (
  SELECT DISTINCT customer_id, DATE_TRUNC('month', order_date) order_month
  FROM orders
)
SELECT f.cohort_month, a.order_month,
       COUNT(DISTINCT a.customer_id) AS active_customers
FROM first_purchase f JOIN activity a USING(customer_id)
GROUP BY 1,2 ORDER BY 1,2;

-- 07: Channel economics
SELECT c.acquisition_channel,
       COUNT(DISTINCT c.customer_id) customers,
       SUM(o.net_sales) revenue,
       SUM(o.gross_profit) profit
FROM customers c JOIN orders o USING(customer_id)
GROUP BY c.acquisition_channel
ORDER BY revenue DESC;

-- 08: Repeat purchase rate
SELECT
  COUNT(DISTINCT CASE WHEN order_count > 1 THEN customer_id END)::DECIMAL
  / COUNT(DISTINCT customer_id) AS repeat_purchase_rate
FROM (
  SELECT customer_id, COUNT(DISTINCT order_id) order_count
  FROM orders GROUP BY customer_id
) x;

-- 09: AOV by category
SELECT p.category, ROUND(SUM(o.net_sales)/NULLIF(COUNT(DISTINCT o.order_id),0),2) AS aov
FROM orders o JOIN products p USING(product_id)
GROUP BY p.category ORDER BY aov DESC;

-- 10: High-value customers at risk
SELECT customer_id, MAX(order_date) last_purchase,
       SUM(net_sales) revenue
FROM orders
GROUP BY customer_id
HAVING CURRENT_DATE - MAX(order_date) > 120
   AND SUM(net_sales) > 5000
ORDER BY revenue DESC;
