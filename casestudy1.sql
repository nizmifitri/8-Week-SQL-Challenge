/* --------------------
   Case Study Questions
   --------------------*/

-- 1. What is the total amount each customer spent at the restaurant?
SELECT
	dd.sales.customer_id, 
    SUM(dd.menu.price) AS "Total amount"
FROM dd.sales 
INNER JOIN dd.menu 
ON dd.sales.product_id=dd.menu.product_id
GROUP BY customer_id
ORDER BY customer_id ASC;

-- 2. How many days has each customer visited the restaurant?
SELECT 
	customer_id, 
    COUNT(DISTINCT order_date) AS "Number of days customer visited"
FROM dd.sales
GROUP BY customer_id
ORDER BY customer_id ASC;

-- 3. What was the first item from the menu purchased by each customer?
SELECT
	DISTINCT dd.sales.customer_id,
    dd.menu.product_name
FROM dd.sales
INNER JOIN dd.menu
ON dd.sales.product_id=dd.menu.product_id
WHERE order_date=(
  SELECT MIN(order_date) FROM dd.sales);
    
-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?
SELECT 
	dd.menu.product_name,
	COUNT(dd.sales.product_id) AS "Total purchased"
FROM dd.sales
INNER JOIN dd.menu
ON dd.sales.product_id=dd.menu.product_id
GROUP BY dd.menu.product_name
ORDER BY "Total purchased" DESC
LIMIT 1;

-- 5. Which item was the most popular for each customer?

-- 6. Which item was purchased first by the customer after they became a member?
-- 7. Which item was purchased just before the customer became a member?
-- 8. What is the total items and amount spent for each member before they became a member?
-- 9.  If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
-- 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?

-- Example Query:
SELECT
  	product_id,
    product_name,
    price
FROM dd.menu
ORDER BY price DESC
LIMIT 5;