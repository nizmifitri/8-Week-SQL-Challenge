-- Cleaning table customer_orders
UPDATE pizza_runner.customer_orders
SET extras = '' 
WHERE extras = 'null' OR extras IS NULL;

UPDATE pizza_runner.customer_orders
SET exclusions = '' 
WHERE exclusions = 'null' OR exclusions IS NULL;

-- Cleaning table runner_orders

-- Replacing entri null
UPDATE pizza_runner.runner_orders
SET cancellation = '' 
WHERE cancellation = 'null' OR cancellation IS NULL;

UPDATE pizza_runner.runner_orders 
SET duration = '' 
WHERE duration = 'null' OR duration IS NULL;

UPDATE pizza_runner.runner_orders 
SET distance = '' 
WHERE distance = 'null' OR distance IS NULL;

UPDATE pizza_runner.runner_orders 
SET pickup_time = '' 
WHERE pickup_time = 'null' OR pickup_time IS NULL;

-- Replacing entri on duration and distance
UPDATE pizza_runner.runner_orders 
SET duration = REPLACE(REPLACE(REPLACE(duration, 'mins', ''), 'minute', ''), 's', '');

UPDATE pizza_runner.runner_orders 
SET distance = REPLACE(distance, 'km', '');


SELECT * FROM pizza_runner.customer_orders
ORDER BY customer_orders.order_id;
SELECT * FROM pizza_runner.runner_orders
ORDER BY runner_orders.order_id;

SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'customer_orders';

--How many pizzas were ordered?
SELECT COUNT(order_id) AS "Amount of Pizzas Ordered"
FROM pizza_runner.customer_orders;

--How many unique customer orders were made?
SELECT COUNT(DISTINCT order_id) AS "Amount of Unique Customer Orders"
FROM pizza_runner.customer_orders;

--How many successful orders were delivered by each runner?
SELECT 
	runner_id,
    COUNT(runner_id) AS "Amount of Successful Orders"
FROM pizza_runner.runner_orders
WHERE cancellation = ''
GROUP BY runner_id
ORDER BY runner_id;

--How many of each type of pizza was delivered?
SELECT 
	pizza_id,
    COUNT(pizza_id) AS "Amount Delivered"
FROM pizza_runner.runner_orders ro
FULL OUTER JOIN pizza_runner.customer_orders co
ON ro.order_id = co.order_id
WHERE cancellation = ''
GROUP BY pizza_id;

--How many Vegetarian and Meatlovers were ordered by each customer?
SELECT 
	customer_id,
    pizza_name,
    COUNT(customer_id) AS "Amount Ordered"
FROM pizza_runner.customer_orders co
FULL OUTER JOIN pizza_runner.pizza_names pn
ON co.pizza_id = pn.pizza_id
GROUP BY customer_id, pizza_name
ORDER BY customer_id;

--What was the maximum number of pizzas delivered in a single order?
WITH pizza_delivered
AS
(SELECT co.order_id, COUNT(co.order_id) AS count_order
FROM pizza_runner.customer_orders co
FULL OUTER JOIN pizza_runner.runner_orders ro
ON co.order_id = ro.order_id
WHERE cancellation = ''
GROUP BY co.order_id)

SELECT MAX(count_order) AS "Max Number of Pizzas Delivered in Single Order"
FROM pizza_delivered;

--For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
SELECT co.customer_id,
SUM(CASE
	WHEN co.exclusions <> '' or co.extras <> '' THEN 1
    ELSE 0
    END) AS "1 or more change",
SUM(CASE
	WHEN co.exclusions = '' AND co.extras = '' THEN 1
    ELSE 0
    END) AS "no changes"
FROM pizza_runner.customer_orders co
INNER JOIN pizza_runner.runner_orders ro
ON co.order_id = ro.order_id
WHERE ro.distance <> ''
GROUP BY co.customer_id;

--How many pizzas were delivered that had both exclusions and extras?
WITH extras
AS
(SELECT *,
	CASE
    	WHEN exclusions <> '' AND extras <> '' THEN 1
        ELSE 0
    END AS "count_extras"
FROM pizza_runner.customer_orders co
FULL OUTER JOIN pizza_runner.runner_orders ro
ON co.order_id = ro.order_id
WHERE cancellation = ''
ORDER BY co.order_id)

SELECT SUM(count_extras) AS "Amount of pizzas delivered that had both exclusions and extras"
FROM extras;


--What was the total volume of pizzas ordered for each hour of the day?
SELECT
	EXTRACT(HOUR FROM order_time) AS "Hour Of The Day",
	COUNT(EXTRACT(HOUR FROM order_time))
FROM pizza_runner.customer_orders
GROUP BY EXTRACT(HOUR FROM order_time)
ORDER BY EXTRACT(HOUR FROM order_time);


--What was the volume of orders for each day of the week?
SELECT
	EXTRACT(DOW FROM order_time) AS "Day Of The Week",
	COUNT(EXTRACT(DOW FROM order_time))
FROM pizza_runner.customer_orders
GROUP BY EXTRACT(DOW FROM order_time)
ORDER BY EXTRACT(DOW FROM order_time);
