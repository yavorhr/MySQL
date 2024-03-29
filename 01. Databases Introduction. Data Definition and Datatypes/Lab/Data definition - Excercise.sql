#01.Create new Database ------------------------------------------------------------------------

CREATE SCHEMA `gamebar`;
USE gamebar;

#02.Create tables ------------------------------------------------------------------------

CREATE TABLE `employees` (
`id` INT PRIMARY KEY AUTO_INCREMENT,
`first_name` VARCHAR(40) NOT NULL,
`last_name` VARCHAR(40) NOT NULL
);

CREATE TABLE `categories` (
`id` INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(40) NOT NULL
);

CREATE TABLE `products` (
`id` INT PRIMARY KEY NOT NULL,
`name` VARCHAR(40) NOT NULL,
`category_id` INT
);
 
#03. Insert Data in Tables ----------------------------------------------------------------------

INSERT INTO `employees` (`first_name`, `last_name`)
VALUES
('Ivan', 'Ivanov'),
('Dragan', 'Ivanov'),
('Georgi', 'Ivanov');

#04. Alter Tables --------------------------------------------------------------------------------

ALTER TABLE `employees`
ADD COLUMN `middle_name` VARCHAR(20);

#04. Adding Constraints ---------------------------------------------------------------------------

ALTER TABLE `products`
ADD CONSTRAINT fk_products_categories
FOREIGN KEY (`category_id`)
REFERENCES `categories`(`id`);

#05. Modifying columns ---------------------------------------------------------------------------

ALTER TABLE `employees`
CHANGE COLUMN `middle_name` `middle_name` VARCHAR(100);

#06. Drop Database ---------------------------------------------------------------------------

DROP SCHEMA gamebar;

# ADDITIONAL OPERATIONS

#1.Select Employee Information------------------------------------------------------------------------

SELECT `id`, `first_name`, `last_name`, `job_title`
FROM `employees`
ORDER BY `id`;

#2.Select Employees with Filter------------------------------------------------------------------------

SELECT `id`, concat(`first_name`,' ', `last_name`) AS `full_name`, `job_title`, `salary`
FROM `employees`
WHERE salary>1000
ORDER  BY `id`; 

#3. Update Employees Salary--------------------------------------------------------------------------

UPDATE employees
SET salary = salary + 100
WHERE job_title = 'Manager';
SELECT salary
FROM employees;

#4: Top Paid Employee-----------------------------------------------------------------------------------

CREATE VIEW `v_top_paid_employee` AS (
    SELECT * FROM `employees`
    ORDER BY `salary` DESC LIMIT 1);
    
SELECT * FROM `v_top_paid_employee`;

#5. Select Employees by Multiple Filters------------------------------------------------------------------

SELECT * FROM `employees`
WHERE `department_id` = 4 AND `salary`>=1000
ORDER BY `id`;

#6. Select Employees by Multiple Filters--------------------------------------------------------------------

DELETE FROM `employees`
WHERE `department_id` IN (1,2);

SELECT * FROM `employees`
ORDER BY `id`;


