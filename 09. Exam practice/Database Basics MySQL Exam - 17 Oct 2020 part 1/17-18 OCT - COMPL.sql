

CREATE TABLE `categories` (
`id` INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(40) NOT NULL UNIQUE
);


CREATE TABLE `pictures` (
`id` INT PRIMARY KEY AUTO_INCREMENT,
`url` VARCHAR(100) NOT NULL,
`added_on` DATETIME NOT NULL
);

CREATE TABLE `products`(
`id` INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(40) NOT NULL UNIQUE,
`best_before` DATE,
`price` DECIMAL (10,2) NOT NULL,
`description` TEXT,
`category_id` INT NOT NULL,
`picture_id` INT NOT NULL,
CONSTRAINT fk_products_categories
FOREIGN KEY (`category_id`)
REFERENCES `categories` (`id`),
CONSTRAINT fk_products_pictures
FOREIGN KEY (`picture_id`)
REFERENCES `pictures` (`id`)
);

CREATE TABLE `towns` (
`id` INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(20) NOT NULL UNIQUE
);

CREATE TABLE `addresses` (
`id` INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(50) NOT NULL UNIQUE,
`town_id` INT NOT NULL,
CONSTRAINT fk_addresses_towns
FOREIGN KEY (`town_id`)
REFERENCES `towns` (`id`)
);

CREATE TABLE `stores` (
`id` INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(20) NOT NULL UNIQUE,
`rating` FLOAT,
`has_parking` BOOLEAN DEFAULT FALSE,
`address_id` INT NOT NULL,
CONSTRAINT fk_stores_addresses
FOREIGN KEY (`address_id`)
REFERENCES `addresses` (`id`)
);

CREATE TABLE `products_stores` (
`product_id` INT,
`store_id` INT,
CONSTRAINT pk_products_stores
PRIMARY KEY (`product_id`, `store_id`),
CONSTRAINT fk_products_stores_stores
FOREIGN KEY (`store_id`)
REFERENCES `stores` (`id`),
CONSTRAINT fk_products_stores_products
FOREIGN KEY (`product_id`)
REFERENCES `products` (`id`)
);

CREATE TABLE `employees` (
`id` INT PRIMARY KEY AUTO_INCREMENT,
`first_name` VARCHAR(15) NOT NULL,
`middle_name` CHAR(1),
`last_name` VARCHAR(20) NOT NULL,
`salary` DECIMAL (19,2) NOT NULL DEFAULT 0,
`hire_date` DATE NOT NULL,
`manager_id` INT,
`store_id` INT NOT NULL,
CONSTRAINT sf_employees_managers
FOREIGN KEY (`manager_id`)
REFERENCES `employees`(`id`),
CONSTRAINT fk_employees_stores
FOREIGN KEY (`store_id`)
REFERENCES `stores`(`id`)
);


#2. Insert---------------------------------

INSERT INTO `products_stores` (`product_id`, `store_id`)
SELECT p.`id`,1
FROM `products` AS p
LEFT JOIN `products_stores` AS ps
ON p.`id` = ps.`product_id`
WHERE ps.`product_id` IS NULL;

#3.	Update-------------------------------------

UPDATE `employees` AS e
SET e.`manager_id` = 3 , e.`salary` = e.`salary` - 500
WHERE 
	YEAR(`hire_date`) >= 2003 AND 	
    e.`store_id` NOT IN (5,14);

#4.	Update-------------------------------------
    
SELECT * FROM `employees`;

DELETE FROM `employees` AS e
WHERE e.`manager_id` IS NOT NULL AND e.`salary` >= 6000;

#5.	Employees-------------------

SELECT `first_name`,`middle_name`,`last_name`,`salary`,`hire_date`
FROM `employees`
ORDER BY `hire_date` DESC;

#6.	Products with old pictures----alter

SELECT 
	p.`name`, 
	p.`price`, 
    p.`best_before`, 
    (SELECT CONCAT(LEFT(p.`description`,10),'...')) AS `short_description`, 
    pic.`url` 
FROM `products` as p
JOIN `pictures` AS pic
ON p.`picture_id` = pic.`id`
WHERE 
	CHAR_LENGTH(p.`description`) > 100 
	AND YEAR(pic.`added_on`) < 2019 
	AND p.`price` > 20
ORDER BY p.`price` DESC;

#7.	Counts of products in stores and their average---------

SELECT s.`name`, COUNT(ps.`product_id`) AS `product_count`, ROUND(AVG(p.`price`),2) AS `avg`
FROM `stores` AS s
LEFT JOIN `products_stores` AS ps
ON s.`id` = ps.`store_id`
LEFT JOIN `products` AS p
ON ps.`product_id` = p.`id`
GROUP BY s.`name`
ORDER BY `product_count` DESC, `avg` DESC, s.`id`;

#8. Specific employee---------------------

SELECT 
	CONCAT(e.`first_name`,' ', e.`last_name`) AS `Full_name`,
    s.`name`,
    a.`name`,
    e.`salary`
FROM `employees` AS e
	JOIN `stores` AS s
	ON e.`store_id` = s.`id`
	JOIN `addresses` AS a
	ON s.`address_id` = a.`id`
WHERE 
	e.`salary` < 4000 
    AND a.`name` LIKE '%5%'
    AND CHAR_LENGTH(a.`name`) > 8
    AND RIGHT(e.`last_name`,1) = 'n';
    
    #9. Find all information of stores--------
    
    SELECT 
		REVERSE(s.`name`) AS `reversed_name`, 
        CONCAT(UPPER(t.`name`),'-', a.`name`) AS `full_address`,
        COUNT(e.`id`) AS `employees_count`
	FROM `stores` AS s
		JOIN `addresses` AS a
		ON s.`address_id` = a.`id`
        JOIN `towns` AS t
        ON a.`town_id` = t.`id`
        JOIN `employees` AS e
        ON s.`id` = e.`store_id`
	GROUP BY s.`name`
    ORDER BY `full_address` ASC;
    
#10.Find full name of top paid employee by store name---------

DELIMITER ##
CREATE FUNCTION `udf_top_paid_employee_by_store`(store_name VARCHAR(50))
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN

RETURN
 (
SELECT 
	CONCAT(
			e.`first_name`, ' ',
			e.`middle_name`, '.' ,' ',
            e.`last_name`, ' works in store for ',
            2020 - YEAR(e.`hire_date`),
            ' years')
FROM `employees` AS e
JOIN `stores` AS s
ON s.`id` = e.`store_id`
WHERE s.`name` = store_name
ORDER BY `salary` DESC
LIMIT 1
);
END ##

SELECT udf_top_paid_employee_by_store('Stronghold') as 'full_info';

#11. Update product price by address----------

DELIMITER ##
CREATE PROCEDURE `udp_update_product_price`(address_name VARCHAR (50))
BEGIN 

UPDATE `products` AS p
	JOIN `products_stores` AS ps
	ON p.`id` = ps.`product_id`
	JOIN `stores` AS s
	ON ps.`store_id` = s.`id`
	JOIN `addresses` AS a
	ON s.`address_id` = a.`id`
SET p.`price` = p.`price` + 
(
CASE
WHEN a.`name` LIKE '0%' THEN 100
ELSE 200
END
)
WHERE a.`name` = address_name;


END ##

CALL udp_update_product_price('07 Armistice Parkway');
SELECT name, price FROM products WHERE id = 15;
