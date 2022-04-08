
#01. Managers----------------------- 

SELECT e.`employee_id`, CONCAT(`first_name`, ' ', `last_name`) AS `full_name`, d.`department_id`, d.`name`
FROM `departments` AS d
LEFT JOIN `employees` AS e
ON d.`manager_id` = e.`employee_id`
ORDER BY e.employee_id
LIMIT 5;

#02. Towns and Addresses-----------

SELECT t.`town_id`, t.`name`, a.`address_text`
FROM `addresses` AS a
LEFT JOIN `towns` AS t
ON t.`town_id` = a.`town_id`
WHERE t.`name` IN ('Sofia', 'San Francisco', 'Carnation')
ORDER BY t.`town_id`, a.`address_id`;

#03. Employees Without Managers---

SELECT `employee_id`, `first_name`, `last_name`, `department_id`, `salary`
FROM `employees`
WHERE `manager_id` IS NULL;

#04. High Salary-------------------

SELECT count(*) AS `count` 
FROM `employees`
WHERE `salary` > 
(
SELECT AVG(`salary`) FROM `employees`
);