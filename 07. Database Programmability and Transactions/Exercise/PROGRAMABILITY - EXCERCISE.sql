

#01. Employees with Salary Above 35000-----------------------------

DELIMITER $$

CREATE PROCEDURE `usp_get_employees_salary_above_35000` ()
BEGIN

SELECT e.`first_name`, e.`last_name`
	FROM `employees` AS e
WHERE e.`salary` > 35000
ORDER BY e.`first_name`, e.`employee_id`;

END $$
DELIMITER ;

#02. Employees with Salary Above Number---------------------------

DELIMITER $
CREATE PROCEDURE `usp_get_employees_salary_above` (salary_level DECIMAL(19,4))
BEGIN

SELECT e.`first_name`, e.`last_name` FROM `employees` AS e
	WHERE e.`salary` >= salary_level
ORDER BY e.`first_name`, e.`last_name`, e.`employee_id`;

END $$
DELIMITER ;

#03. Town Names Starting With---------------

DELIMITER $$

CREATE PROCEDURE `usp_get_towns_starting_with` (start_str VARCHAR(30))
BEGIN

SELECT `name` AS `town_name` 
FROM `towns` 
    WHERE lower(`name`) LIKE lower(CONCAT(start_str, '%'))
ORDER BY `name`;

END $$
DELIMITER ;

CALL `usp_get_towns_starting_with`(45000);

#04. Employees from Town--------------------

DELIMITER $$

CREATE PROCEDURE `usp_get_employees_from_town` (town_name VARCHAR(50))
BEGIN

SELECT  e.`first_name`, e.`last_name`
	FROM `towns` AS t
    JOIN `addresses` AS a
    ON t.`town_id` = a.`town_id`
    JOIN `employees` e 
    ON e.`address_id` = a.`address_id`
    WHERE t.`name` = town_name
    ORDER BY e.`first_name`, e.`last_name`,e.`employee_id`;

END $$

DELIMITER ;

#05. Salary Level Function-------------------------------------------

DELIMITER $$
CREATE FUNCTION ufn_get_salary_level(salary DECIMAL)
RETURNS VARCHAR(10)
DETERMINISTIC
BEGIN

RETURN (CASE
   WHEN salary < 30000 THEN'Low'
   WHEN salary BETWEEN 30000 AND 50000 THEN 'Average'
   WHEN salary > 50000 THEN'High'
   END
   );
   
END $$

DELIMITER ;

SELECT ufn_get_salary_level (1000)

#06. Employees by Salary Level------------------------------------------------

DELIMITER $$

CREATE FUNCTION ufn_get_salary_level(salary DECIMAL)
RETURNS VARCHAR(10)
DETERMINISTIC
BEGIN

RETURN (CASE
   WHEN salary < 30000 THEN'Low'
   WHEN salary BETWEEN 30000 AND 50000 THEN 'Average'
   WHEN salary > 50000 THEN'High'
   END
   );
   
END;

CREATE PROCEDURE usp_get_employees_by_salary_level(s_level VARCHAR(10))
BEGIN
	SELECT `first_name`, `last_name`
    FROM `employees`
    WHERE ufn_get_salary_level(salary_amount) = s_level
    ORDER BY `first_name` DESC, `last_name` DESC;
END;

DELIMITER ;

#07. Define Function-------------------

DELIMITER $$
CREATE FUNCTION `ufn_is_word_comprised`(set_of_letters varchar(50), word varchar(50))  
RETURNS BIT
BEGIN

RETURN (SELECT word REGEXP(CONCAT('^[',set_of_letters,']+$')));
END $$


#08. Find Full Name--------------------

DELIMITER $$
CREATE PROCEDURE `usp_get_holders_full_name`()

BEGIN

SELECT CONCAT(`first_name`,' ', `last_name`) AS `full_name`
FROM `account_holders`
ORDER BY `full_name`, `id`;

END $$

DELIMITER ;

#10. Future Value Function-------------------------

DELIMITER $$
CREATE FUNCTION `ufn_calculate_future_value` (sum DECIMAL (19,4),interest DOUBLE, years INT)
RETURNS DECIMAL (19,4)
DETERMINISTIC
BEGIN
	RETURN (sum*POW(1+interest,years));
END $$
DELIMITER ;

SELECT `ufn_calculate_future_value`(1000,0.5,5);

#11. Calculating Interest---------------------------
#66 pts Judge

DELIMITER $$
CREATE PROCEDURE `usp_calculate_future_value_for_account` (acc_id INT, interest DOUBLE)
BEGIN

SELECT a.`id`, ah.`first_name`, ah.`last_name`, a.`balance`, 
ufn_calculate_future_value(a.`balance`,interest,5)
FROM `accounts` AS a
JOIN `account_holders` AS ah
ON a.`account_holder_id` = ah.`id`
WHERE a.`id` = acc_id;

END $$
DELIMITER ;

CALL `usp_calculate_future_value_for_account`(1,0.1);

#12.Deposit Money----------------------------------

DELIMITER $$
CREATE PROCEDURE usp_deposit_money(account_id INT, money_amount DECIMAL(19,4))
BEGIN 

	START TRANSACTION;
    IF (SELECT COUNT(*)FROM `accounts` WHERE `id` = account_id) = 0
		OR (money_amount <=0)
		THEN ROLLBACK;
    ELSE
		UPDATE `accounts`
        SET `balance` = `balance` + money_amount
        WHERE `id` = account_id;
    END IF;

END $$
DELIMITER ;

CALL usp_deposit_money(1,10);

#13. Withdraw Money-------------------------

DELIMITER $$
CREATE PROCEDURE usp_withdraw_money(account_id INT, money_amount DECIMAL(20,4))
BEGIN
	START TRANSACTION;
		CASE WHEN money_amount < 0 
				OR money_amount > 
					(SELECT a.balance 
                     FROM accounts as a
					 WHERE a.id = account_id)
		THEN ROLLBACK;
	ELSE 
		UPDATE accounts a
		SET a.balance = a.balance - money_amount
        WHERE a.id = account_id;
	END CASE;
	COMMIT;
END $$

CALL usp_withdraw_money(1, 10);

SELECT a.id, h.id, a.balance
FROM account_holders AS h
JOIN accounts AS a ON a.account_holder_id = h.id
WHERE a.id = 1;

#14. Money Transfer------------------------------------

DELIMITER $$
CREATE PROCEDURE usp_transfer_money(from_account_id INT, to_account_id INT, amount DECIMAL(20, 4))
BEGIN
	START TRANSACTION;
		CASE WHEN 
			(SELECT a.id FROM accounts as a WHERE a.id = from_account_id) IS NULL
            OR (SELECT a.id FROM accounts as a WHERE a.id = to_account_id) IS NULL
            OR from_account_id = to_account_id
            OR amount < 0
            OR (SELECT a.balance FROM accounts as a WHERE a.id = from_account_id) < amount
		THEN ROLLBACK;
	ELSE 
		UPDATE accounts a
		SET a.balance = a.balance - amount
        WHERE a.id = from_account_id;
        
        UPDATE accounts a
		SET a.balance = a.balance + amount
        WHERE a.id = to_account_id;
	END CASE;
	COMMIT;
END $$

CALL usp_transfer_money(1, 2, 10);

SELECT a.id, h.id, a.balance
FROM account_holders AS h
JOIN accounts AS a ON a.account_holder_id = h.id
WHERE a.id IN (1, 2);


#*15. Log Accounts Trigger-----------------------------

CREATE TABLE `logs` 
(
`log_id` INT PRIMARY KEY AUTO_INCREMENT,
 `account_id` INT, 
 `old_sum` DECIMAL(19,4), 
 `new_sum` DECIMAL (19,4)
 ); 
 
 DELIMITER $$
 CREATE TRIGGER `tr_update_accounts`  
 AFTER UPDATE
 ON `accounts`
 FOR EACH ROW 
 BEGIN
 
 INSERT INTO `logs` (`account_id`, `old_sum`, `new_sum`)
VALUES
(OLD.`id`, OLD.`balance`, NEW.`balance`);
 
 END $$
 DELIMITER ;