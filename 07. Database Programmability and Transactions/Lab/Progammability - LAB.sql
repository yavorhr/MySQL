

#01. Count Employees by Town--------------

DELIMITER ###
CREATE FUNCTION ufn_count_employees_by_town(town_name_param VARCHAR(20))
RETURNS INTEGER
DETERMINISTIC

BEGIN
	RETURN (SELECT COUNT(*)
	 FROM employees AS e
	 JOIN addresses AS a 
	 USING(`address_id`)
	JOIN towns AS t
	USING (`town_id`)
	WHERE t.`name` = town_name_param
    GROUP BY t.`name`);
    
END  ###

#02. Employees Promotion----------------

DELIMITER ##
CREATE PROCEDURE `usp_raise_salaries`(department_name VARCHAR (40))
BEGIN
	UPDATE `employees` AS e
		JOIN `departments` AS d
		USING (`department_id`)
	SET e.`salary` = e.`salary` * 1.05
	WHERE d.`name` = department_name;
END

#03. Employees Promotion By ID-------------

DELIMITER ##
CREATE PROCEDURE `usp_raise_salary_by_id`(id INT) 
BEGIN
UPDATE `employees` 
SET `salary` = `salary` * 1.05
WHERE `employee_id` = id AND id IS NOT NULL;
END



