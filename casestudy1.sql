Tools : PostgreSQL

/* --------------------
   Case Study Questions
   --------------------*/

-- 1. What is the total amount each customer spent at the restaurant?
SELECT
	ds.customer_id, 
    SUM(dm.price) AS "total amount"
FROM dannys_diner.sales ds 
INNER JOIN dannys_diner.menu dm
ON ds.product_id = dm.product_id
GROUP BY customer_id
ORDER BY customer_id ASC;

-- 2. How many days has each customer visited the restaurant?
SELECT 
	customer_id, 
    COUNT(DISTINCT order_date) AS "number of days customer visited"
FROM dannys_diner.sales
GROUP BY customer_id
ORDER BY customer_id ASC;

-- 3. What was the first item from the menu purchased by each customer?
SELECT
	DISTINCT ds.customer_id,
    dm.product_name
FROM dannys_diner.sales ds
INNER JOIN c.menu dm
ON ds.product_id = dm.product_id
WHERE order_date=(
  SELECT MIN(order_date) FROM dannys_diner.sales)
ORDER BY customer_id;
    
-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?
SELECT 
	dm.product_name,
	COUNT(ds.product_id) AS "total purchased"
FROM dannys_diner.sales ds
INNER JOIN dannys_diner.menu dm
ON ds.product_id=dm.product_id
GROUP BY dm.product_name
ORDER BY "total purchased" DESC
LIMIT 1;

-- 5. Which item was the most popular for each customer?
SELECT customer_id, product_id, total_item 
FROM (
SELECT RANK () OVER ( 
		PARTITION BY customer_id
		ORDER BY total_item DESC
	) price_rank,  customer_id, product_id, total_item from
(SELECT customer_id, product_id, COUNT (*) AS total_item
FROM dannys_diner.sales
GROUP BY customer_id, product_id
ORDER BY customer_id, total_item DESC) AS t1) as t2
WHERE t2.price_rank = 1;

-- 6. Which item was purchased first by the customer after they became a member?
SELECT * FROM (
SELECT RANK () OVER ( 
		PARTITION BY customer_id
		ORDER BY MIN(order_date)
	) order_rank, customer_id, product_id, MIN(order_date) AS first_order
FROM 
  	(SELECT ds.*, dmm.join_date
	FROM dannys_diner.sales ds
	LEFT JOIN dannys_diner.members dmm
	ON ds.customer_id = dmm.customer_id) AS y
WHERE order_date >= join_date
GROUP BY customer_id, product_id
) AS ty
WHERE order_rank = 1;

-- 7. Which item was purchased just before the customer became a member?
SELECT ds.*
FROM dannys_diner.sales ds
LEFT JOIN dannys_diner.members dmm
ON ds.customer_id = dmm.customer_id
WHERE ds.order_date < dmm.join_date;

-- 8. What is the total items and amount spent for each member before they became a member?
SELECT 
	ds.customer_id,
	COUNT(ds.product_id) AS "total items",
	SUM(dm.price) AS "total amount spent"
FROM dannys_diner.sales ds
INNER JOIN dannys_diner.menu dm
ON ds.product_id = dm.product_id
INNER JOIN dannys_diner.members dmm
ON ds.customer_id = dmm.customer_id
WHERE order_date < join_date
GROUP BY ds.customer_id
ORDER BY ds.customer_id;

-- 9.  If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
WITH extra_points AS 
(SELECT *,
	(CASE WHEN product_name = 'sushi' THEN price * 20
	ELSE price * 10
	END) AS points
FROM dannys_diner.menu)

SELECT 
	ds.customer_id,
	SUM(points) AS total_points
FROM extra_points ext 
INNER JOIN dannys_diner.sales ds
ON ds.product_id = ext.product_id 
GROUP BY customer_id
ORDER BY customer_id;

-- 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?
WITH ext AS
(SELECT ds.customer_id,
	(CASE
	WHEN DATE_PART ('day', order_date::timestamp-join_date::timestamp) >=0 AND
 	DATE_PART ('day', order_date::timestamp-join_date::timestamp) < 7 AND
	product_name != 'sushi' THEN price * 20
 	WHEN product_name != 'sushi' THEN price * 10
 	ELSE price * 20 END)AS points
FROM dannys_diner.sales ds
INNER JOIN dannys_diner.menu dm
ON ds.product_id = dm.product_id
INNER JOIN dannys_diner.members dmm
ON ds.customer_id = dmm.customer_id)


SELECT customer_id, SUM(points) AS "total points"
FROM ext
GROUP BY customer_id;
