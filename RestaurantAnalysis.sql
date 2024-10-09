-- 1. Which menu items generate the most revenue for the restaurant?
SELECT * FROM menu_items;
SELECT * FROM order_details;

SELECT mi.item_name, SUM(mi.price) AS total_revenue
FROM order_details od
JOIN menu_items mi ON od.item_id = mi.menu_item_id
GROUP BY mi.item_name
ORDER BY total_revenue DESC
LIMIT 5;

-- 2. What is the average revenue per order?
SELECT AVG(order_total) AS avg_revenue_per_order
FROM (
  SELECT od.order_id, SUM(mi.price) AS order_total
  FROM order_details od
  JOIN menu_items mi ON od.item_id = mi.menu_item_id
  GROUP BY od.order_id
) AS subquery;

-- 3. What is the restaurant's monthly revenue trend?
SELECT MONTHNAME(od.order_date) AS month, SUM(mi.price) AS total_revenue
FROM order_details od
JOIN menu_items mi ON od.item_id = mi.menu_item_id
GROUP BY month
ORDER BY FIELD(month, 'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December');

-- 4. Are there any items with high sales but low revenue (potential loss leaders?)
SELECT mi.item_name, COUNT(od.item_id) AS total_sold, SUM(mi.price) AS total_revenue
FROM order_details od
JOIN menu_items mi ON od.item_id = mi.menu_item_id
GROUP BY mi.item_name
HAVING total_revenue < 100
ORDER BY total_sold DESC;

-- 5. What percentage of total revenue comes from each item category?
SELECT mi.category, SUM(mi.price) AS category_revenue,
       (SUM(mi.price) / (SELECT SUM(price) FROM order_details od JOIN menu_items mi ON od.item_id = mi.menu_item_id)) * 100 AS revenue_percentage
FROM order_details od
JOIN menu_items mi ON od.item_id = mi.menu_item_id
GROUP BY mi.category
ORDER BY revenue_percentage DESC;

-- 6. Which items have seen a decline in sales over the last 6 months?
SELECT mi.item_name, COUNT(od.item_id) AS total_sold
FROM order_details od
JOIN menu_items mi ON od.item_id = mi.menu_item_id
WHERE od.order_date BETWEEN CURDATE() - INTERVAL 6 MONTH AND CURDATE()
GROUP BY mi.item_name
HAVING total_sold < 10
ORDER BY total_sold ASC;


