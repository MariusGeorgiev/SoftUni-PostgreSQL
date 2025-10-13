--SECTION 4
--10
CREATE OR REPLACE FUNCTION udf_classification_items_count(
classification_name VARCHAR(30) 
)
RETURNS TEXT
AS
$$
DECLARE message_count TEXT;
BEGIN
message_count :=
	(SELECT 
		CASE
		WHEN COUNT(*) >= 1 THEN CONCAT('Found ', COUNT(*), ' items.')
		ELSE 'No items found.'
		END
	FROM items AS i
	JOIN classifications AS c ON c.id = i.classification_id
	WHERE c.name = classification_name
	);
	RETURN message_count;
	 
END;
$$
LANGUAGE plpgsql;

SELECT udf_classification_items_count('Nonexistent') AS message_text;
SELECT udf_classification_items_count('Laptops') AS message_text;

    --11
CREATE OR REPLACE PROCEDURE udp_update_loyalty_status(
min_orders INT
)
AS
$$
BEGIN
	UPDATE customers
	SET loyalty_card = TRUE
	WHERE customers.id IN (SELECT customer_id
			        FROM orders
			        GROUP BY customer_id
			        HAVING COUNT(*) >= min_orders);
	
END;
$$
LANGUAGE plpgsql;

CALL udp_update_loyalty_status(4);