--SECTION 2
--02 Insert
INSERT INTO items (name, quantity, price, description, brand_id, classification_id)
SELECT
    'Item' || created_at,
    customer_id,
    rating * 5,
    NULL,
    item_id,
    (SELECT MIN(item_id) FROM reviews)
FROM reviews
ORDER BY item_id
LIMIT 10;

SELECT * FROM items;

--03 Update
UPDATE reviews
SET rating = CASE
    WHEN customer_id = item_id THEN 10.0
    WHEN customer_id > item_id THEN 5.5
    ELSE rating
END;

--04 Delete 
DELETE FROM customers AS c
WHERE NOT EXISTS (
    SELECT 1
    FROM orders AS o
    WHERE o.customer_id = c.id
);
