	
------------Cleaning table customer_orders--------------
UPDATE pizza_runner.customer_orders
SET extras = '' 
WHERE extras = 'null' OR extras IS NULL;

UPDATE pizza_runner.customer_orders
SET exclusions = '' 
WHERE exclusions = 'null' OR exclusions IS NULL;

------------Cleaning table runner_orders-----------------

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
