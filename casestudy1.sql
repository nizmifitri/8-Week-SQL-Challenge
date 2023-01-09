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
SELECT customer_id, product_id, total_item 
FROM (
SELECT RANK () OVER ( 
		PARTITION BY customer_id
		ORDER BY total_item DESC
	) price_rank,  customer_id, product_id, total_item from
(SELECT customer_id, product_id, COUNT (*) AS total_item
FROM dd.sales
GROUP BY customer_id, product_id
ORDER BY CUSTOMER_ID, TOTAL_ITEM DESC) AS t1) as t2
WHERE t2.price_rank = 1;

-- 6. Which item was purchased first by the customer after they became a member?
SELECT * FROM (
SELECT RANK () OVER ( 
		PARTITION BY customer_id
		ORDER BY MIN(order_date)
	) order_rank, customer_id, product_id, MIN(order_date) AS first_order
FROM 
  	(SELECT t1.*, t2.join_date
	FROM dd.sales AS t1
	LEFT JOIN dd.members AS t2
	ON t1.customer_id=t2.customer_id) AS y
WHERE order_date >= join_date
GROUP BY customer_id, product_id
) AS ty
WHERE order_rank = 1;

-- 7. Which item was purchased just before the customer became a member?
-- 8. What is the total items and amount spent for each member before they became a member?
-- 9.  If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
-- 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?
