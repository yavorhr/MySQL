
#01. Employee Address-------------

SELECT e.`employee_id`, e.`job_title`, e.`address_id`, a.`address_text`
FROM `employees` AS e
JOIN `addresses` AS a
USING (`address_id`)
ORDER BY e.`address_id` ASC
LIMIT 5;

#02. Addresses with Towns---------

SELECT e.`first_name`, e.`last_name`, t.`name`, a.`address_text`
FROM `employees` AS e
JOIN `addresses` AS a
USING (`address_id`) 
JOIN `towns` as t
USING (`town_id`)
ORDER BY e.`first_name`, e.`last_name`
LIMIT 5;
 
 #03. Sales Employee--------------
 
 SELECT e.`employee_id`, e.`first_name`, e.`last_name`, d.`name` AS `department_name`
FROM `employees` AS e
JOIN `departments` AS d
USING (`department_id`)
WHERE d.`name` = 'Sales' 
ORDER BY e.`employee_id` DESC;
 
 #04. Employee Departments----------
 
SELECT e.`employee_id`, e.`first_name`, e.`salary`, d.`name` AS `department_name`
FROM `employees` AS e
JOIN `departments` AS d
USING (`department_id`)
WHERE e.`salary` > 15000
ORDER BY d.`department_id` DESC
LIMIT 5;

#05. Employees Without Project-------

SELECT e.`employee_id`, e.`first_name`
FROM `employees` AS e
LEFT JOIN `employees_projects` AS p
USING (`employee_id`)
WHERE p.`project_id` IS NULL
ORDER BY e.`employee_id` DESC
LIMIT 3;

#06. Employees Hired After---------

SELECT e.`first_name`, e.`last_name`, e.`hire_date`, d.`name` AS `dept_name`
FROM `employees` AS e
JOIN `departments` AS d
USING (`department_id`)
WHERE DATE (e.`hire_date`) > '1999-1-1' AND d.`name` IN ('SALES', 'Finance')
ORDER BY e.`hire_date`; 

#07. Employees with Project--------

SELECT e.`employee_id`, e.`first_name`, p.`name`
FROM `employees` AS e
JOIN `employees_projects` AS ep
USING (`employee_id`)
JOIN `projects` AS `p`
USING (`project_id`)
WHERE DATE(p.`start_date`) > '2002-08-13' AND DATE(p.`end_date`) IS NULL
ORDER BY e.`first_name`, p.`name`
LIMIT 5;

# 08. Employee 24----------------

SELECT 
    e.`employee_id`,
    e.`first_name`,
    IF(YEAR(p.`start_date`) > 2004,
        NULL,
        p.`name`) AS `project_name`
FROM
    `employees` AS e
        JOIN
    `employees_projects` AS ep USING (`employee_id`)
        JOIN
    `projects` AS p USING (`project_id`)
WHERE
    e.`employee_id` = 24
ORDER BY `project_name` ASC;

#09. Employee Manager---------------

SELECT e.`employee_id`, e.`first_name`, e.`manager_id`, m.`first_name` AS `manager_name`
FROM `employees` AS e
JOIN `employees` AS m
ON m.`employee_id` =  e.`manager_id`
WHERE e.`manager_id` IN (3,7)
ORDER BY e.`first_name` ASC;

#10. Employee Summary--------------

SELECT e.`employee_id`, CONCAT_WS(' ',e.`first_name`, e.`last_name`) AS `employee_name`, CONCAT_WS(' ', m.`first_name`, m.`last_name`) AS `manager_name`, d.`name` AS `department_name`
FROM `employees` AS e
JOIN `employees` AS m
ON m.`employee_id` =  e.`manager_id`
JOIN `departments` AS d
ON e.`department_id` = d.`department_id`
ORDER BY e.`employee_id`
LIMIT 5;

#11. Min Average Salary------------

SELECT AVG(`salary`) AS `avg_sal`
FROM `employees`
GROUP BY `department_id`
ORDER BY `avg_sal` ASC
LIMIT 1;

#12. Highest Peaks in Bulgaria-------

SELECT c.`country_code`, m.`mountain_range`, p.`peak_name`, p.`elevation`
FROM `countries`  AS c
JOIN `mountains_countries` AS mc
USING (`country_code`)
JOIN `mountains` AS m
ON mc.`mountain_id` = m.`id` 
JOIN `peaks` AS p
ON  m.`id` = p.`mountain_id`
WHERE p.`elevation` > 2835 AND c.`country_code` = 'BG' 
ORDER BY p.`elevation` DESC;

 #13. Count Mountain Ranges---------------
 
SELECT c.`country_code`, COUNT(m.`mountain_range`)
FROM `countries`  AS c
JOIN `mountains_countries` AS mc
USING (`country_code`)
JOIN `mountains` AS m
ON mc.`mountain_id` = m.`id`
WHERE `country_code` IN ('BG', 'RU', 'US')
GROUP BY `country_code`
ORDER BY COUNT(m.`mountain_range`) DESC;
 
#14. Countries with Rivers--------------

SELECT c.`country_name` , r.`river_name`
FROM `countries` AS c
LEFT JOIN `countries_rivers` AS cr
USING (`country_code`)
LEFT JOIN `rivers` AS r
ON cr.`river_id` = r.`id`
WHERE c.`continent_code` = 'AF'
ORDER BY c.`country_name`
LIMIT 5;

#16. Countries without any Mountains-----

SELECT COUNT(*)
FROM `countries` AS c 
WHERE c.`country_code` NOT IN 
(SELECT `country_code` FROM `mountains_countries`);

#17. Highest Peak and Longest River by Country---

SELECT c.`country_name`, MAX(p.`elevation`) AS `highest_peak_elev`, MAX(r.`length`) AS `longest_river`
FROM `countries` AS c
JOIN `mountains_countries` AS mc
USING (`country_code`)
JOIN `mountains` AS m
ON mc.`mountain_id` = m.`id`
JOIN `peaks` AS p
ON m.`id` = p.`mountain_id`
JOIN `countries_rivers` AS cr
USING (`country_code`)
JOIN `rivers` AS r
ON cr.`river_id` = r.`id`
GROUP BY c.`country_name`
ORDER BY `highest_peak_elev` DESC, `longest_river` DESC, c.`country_name` ASC
LIMIT 5;

