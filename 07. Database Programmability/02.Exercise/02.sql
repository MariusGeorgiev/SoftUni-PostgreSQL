--07.00
CREATE DATABASE bank_db;
--07 Retrieving Account Holders**
CREATE OR REPLACE PROCEDURE sp_retrieving_holders_with_balance_higher_than(
	searched_balance NUMERIC
) 
AS
$$
DECLARE holder_info RECORD;
BEGIN
	FOR holder_info IN 
		SELECT 
			first_name || ' ' || last_name AS full_name,
			SUM(balance) AS total_balance
		FROM 
			account_holders AS ah
		JOIN accounts AS a
		ON a.account_holder_id = ah.id
		GROUP BY full_name
		HAVING 
		SUM(a.balance) > searched_balance
		ORDER BY full_name
	LOOP
		RAISE NOTICE '% - %', holder_info.full_name, holder_info.total_balance;
	END LOOP;
END;
$$
LANGUAGE plpgsql;

CALL sp_retrieving_holders_with_balance_higher_than(200000);

--08 Deposit Money
CREATE OR REPLACE PROCEDURE sp_deposit_money (
account_id INT,
money_amount NUMERIC(4)
) 
AS 
$$
BEGIN 
	UPDATE accounts
	SET balance = balance + money_amount
	WHERE id = account_id;
END;
$$
LANGUAGE plpgsql;

SELECT * FROM accounts WHERE id = 1;
CALL sp_deposit_money(1, 200);

--9 Withdraw Money
CREATE OR REPLACE PROCEDURE sp_withdraw_money (
account_id INT,
money_amount NUMERIC(4)
) 
AS 
$$
DECLARE current_balance NUMERIC;
BEGIN 
	current_balance := (SELECT balance FROM accounts WHERE id = account_id);

	IF current_balance - money_amount < 0 THEN
		RAISE NOTICE 'Insufficient balance to withdraw %', money_amount;
	ELSE
		UPDATE accounts
		SET balance = balance - money_amount
		WHERE id = account_id;
	END IF;

END;
$$
LANGUAGE plpgsql;

SELECT * FROM accounts WHERE id = 1;
CALL sp_withdraw_money(1, 200);

--10 Money Transfer
CREATE OR REPLACE PROCEDURE sp_transfer_money (
sender_id INT,
receiver_id INT,
amount NUMERIC(4)
) 
AS 
$$
DECLARE current_balance NUMERIC;
BEGIN 
	SELECT balance INTO current_balance FROM accounts WHERE id = sender_id;

	IF current_balance - amount >= 0 THEN
		CALL sp_withdraw_money(sender_id, amount);
		CALL sp_deposit_money(receiver_id, amount);
	ELSE
		RAISE NOTICE 'Insufficient balance to withdraw %', amount;
	END IF;

END;
$$
LANGUAGE plpgsql;

SELECT * FROM accounts WHERE id IN(5, 1);
CALL sp_transfer_money(10, 2, 1043.9000);

--11 Delete Procedure
DROP PROCEDURE sp_retrieving_holders_with_balance_higher_than;

--12 Log Accounts Trigger
CREATE TABLE IF NOT EXISTS logs(
id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
accound_id INT,
old_sum NUMERIC,
new_sum NUMERIC
);

CREATE OR REPLACE FUNCTION trigger_fn_insert_new_entry_into_logs(
) 
RETURNS TRIGGER AS
$$
BEGIN
	INSERT INTO logs(accound_id, old_sum, new_sum)
	VALUES
	(OLD.id, OLD.balance, NEW.balance);

	RETURN NEW;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER tr_account_balance_change
AFTER UPDATE OF balance ON accounts
FOR EACH ROW
WHEN (NEW.balance <> OLD.balance)
EXECUTE FUNCTION trigger_fn_insert_new_entry_into_logs();
--
UPDATE accounts SET balance = balance +1;

SELECT * FROM logs;

--13 Notification Email on Balance Change
CREATE TABLE IF NOT EXISTS notification_emails(
id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
recipient_id INT,
subject VARCHAR,
body TEXT
);

CREATE OR REPLACE FUNCTION trigger_fn_send_email_on_balance_change()
RETURNS TRIGGER AS
$$
BEGIN
	INSERT INTO notification_emails(recipient_id,subject,body)
	VALUES
	(
	NEW.accound_id,
	'Balance change for account: ' || NEW.accound_id,
	'On ' || DATE(NOW()) || ' your balance was changed from ' || NEW.old_sum || ' to ' || NEW.new_sum || '.'
	);
	RETURN NEW;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER tr_send_email_on_balance_change
AFTER UPDATE ON 
	logs
FOR EACH ROW
EXECUTE FUNCTION trigger_fn_send_email_on_balance_change();

--
UPDATE logs
SET old_sum = old_sum - 10;

SELECT * FROM notification_emails;
