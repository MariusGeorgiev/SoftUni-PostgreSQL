--SECTION 3
--05 
SELECT
	id,
	last_name,
	loyalty_card
FROM
	customers
WHERE
	(
		last_name LIKE '%m%'
		OR last_name LIKE '%M%'
	)
	AND loyalty_card = TRUE
ORDER BY
	last_name DESC,
	id ASC;

--06
SELECT
	id,
	TO_CHAR(created_at, 'DD-MM-YYYY') AS created_at,
	customer_id
FROM
	orders
WHERE
	(customer_id BETWEEN 15 AND 30) AND created_at > DATE('2025-01-01')
ORDER BY created_at, customer_id DESC, id
LIMIT 5;

--07
SELECT 
	i.name,
	CONCAT(UPPER(b.name), '/', LOWER(c.name)) AS promotion,
	CONCAT('On sale: ', i.description) AS description,
	i.quantity
FROM items AS i
LEFT JOIN orders_items AS ot ON ot.item_id = i.id
JOIN classifications AS c ON c.id = i.classification_id
JOIN brands AS b ON b.id = i.brand_id
WHERE order_id IS NULL
ORDER BY i.quantity DESC, i.name ASC;

--08
SELECT 
	c.id AS customer_id,
	CONCAT(first_name, ' ', last_name) AS full_name,
	COUNT(c.id) AS total_orders,
	CASE 
		WHEN c.loyalty_card = TRUE THEN 'Loyal Customer'
		ELSE 'Regular Customer'
	END AS loyalty_status
FROM customers AS c
LEFT JOIN reviews AS r ON r.customer_id = c.id
JOIN orders AS o ON o.customer_id = c.id
WHERE r.customer_id IS NULL
GROUP BY c.id
ORDER BY total_orders DESC, customer_id;

--09
SELECT i.name AS item_name,
	ROUND(AVG(r.rating), 2) AS average_rating,
	COUNT(r.item_id) AS total_reviews,
	b.name AS brand_name,
	c.name AS classification_name
FROM items AS i
JOIN reviews AS r ON r.item_id = i.id
JOIN classifications AS c ON c.id = i.classification_id
JOIN brands AS b ON b.id = i.brand_id
GROUP BY i.id, i.name, c.name, b.name
HAVING COUNT(r.item_id) >= 3
ORDER BY average_rating DESC, i.name
LIMIT 3;

SELECT * FROM reviews;