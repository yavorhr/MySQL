
#1.Create Tables-------------------------------------------------------------------------------------------

CREATE DATABASE `minions`;
USE MINIONS;

CREATE TABLE `minions` (
`id` INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR (50) NOT NULL,
`age` INT
);

CREATE TABLE `towns` (
`town_id` INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR (30) NOT NULL
);

#2.Alter Minions Table-----------------------------------------------------------------------------------

ALTER TABLE `minions` 
ADD COLUMN `town_id` INT,
ADD CONSTRAINT fk_minions_towns
FOREIGN KEY (`town_id`) 
REFERENCES `towns`(`id`);

#3.Insert Records in Both Tables-------------------------------------------------------------------------

INSERT INTO `towns`
VALUES
 (1, 'Sofia'),
 (2, 'Plovdiv'),
 (3, 'Varna');
 
 INSERT INTO `minions`
 VALUES
 (1, 'Kevin', 22,1),
 (2, 'Bob', 15,3),
 (3, 'Steward', NULL,2);
 
 #4.Truncate Table Minions----------------------------------------------------------------------------
 
 TRUNCATE `minions`;
 
#5.Drop All Tables------------------------------------------------------------------------------------

 DROP TABLE `minions`;
 DROP TABLE `towns`;
 
 #6.Create Table People--------------------------------------------------------------------------------
 
 CREATE TABLE `people` (
 `id` INT PRIMARY KEY AUTO_INCREMENT,
 `name` VARCHAR(200) NOT NULL,
 `picture` BLOB,
 `height` FLOAT(5,2),
 `weight` FLOAT (5,2),
 `gender` CHAR(1) NOT NULL,
`birthdate` DATE NOT NULL,
`biography` TEXT
 );

INSERT INTO `people`
VALUES
(1,'Ivan',1,2,200,'m',13/04/1989,'Hello, Im Ivan'),
(2,'Dragan',1,2,200,'m','19890414','Hello, Im Dragan'),
(3,'Petkan',1,2,200,'m','19890414','Hello, Im Petkan'),
(4,'Ivailo',1,2,200,'m','19890414','Hello, Im Ivailo'),
(5,'Gosho',1,2,200,'m','19890414','Hello, Im Gosho');
 
#7.	Create Table Users-----------------------------------------------------------------------------------
 
 CREATE TABLE `users`(
 `id` INT PRIMARY KEY AUTO_INCREMENT,
 `username` VARCHAR (30) NOT NULL,
 `password` VARCHAR (26) NOT NULL,
 `profile_picture` BLOB,
 `last_login_time` DATETIME,
 `is_deleted` BOOLEAN
 );
 
INSERT INTO `users`
 VALUES
 (1, 'user1', '123', '1','9999-12-31 23:59:59',true),
 (2, 'user2', '1234', '1','9999-12-31 23:59:59',false),
 (3, 'user3', '1234', '1','9999-12-31 23:59:59',true),
 (4, 'user4', '12345', '1','9999-12-31 23:59:59',true),
 (5, 'user5', '123456', '1','9999-12-31 23:59:59',true);
 
#8.Change Primary Key----------------------------------------------------------------------------------
  ALTER TABLE `users`
 DROP PRIMARY KEY,
 ADD CONSTRAINT pk_users
 PRIMARY KEY (`id`,`username`);
 
#9.Set Default Value of a Field-------------------------------------------------------------------------
 
ALTER TABLE `users`
CHANGE COLUMN `last_login_time` `last_login_time` DATETIME NULL DEFAULT CURRENT_TIMESTAMP;

#10.Set Unique Field----------------------------------------------------------------------------------

 ALTER TABLE `users`
 CHANGE COLUMN `username` `username` VARCHAR (30) NOT NULL UNIQUE;
 
#11.Movies Database------------------------------------------------------------------------------------
 
 CREATE DATABASE `movies`;
 USE `movies`;
 
 CREATE TABLE `directors` (
 `id` INT PRIMARY KEY AUTO_INCREMENT,
 `director_name` VARCHAR (30) NOT NULL,
 `notes` TEXT);
 
 CREATE TABLE `genres` (
  `id` INT PRIMARY KEY AUTO_INCREMENT,
  `genre_name` VARCHAR(30) NOT NULL,
  `notes` TEXT
  );
  
   CREATE TABLE `categories` (
  `id` INT PRIMARY KEY AUTO_INCREMENT,
  `category_name` VARCHAR(30) NOT NULL,
  `notes` TEXT
  );
  
CREATE TABLE `movies` (
`id` INT PRIMARY KEY AUTO_INCREMENT,
`title` VARCHAR (40) NOT NULL,
`director_id` INT,
CONSTRAINT fk_movies_directors
FOREIGN KEY (`director_id`)
REFERENCES `directors`(`id`),
`copyright_year` YEAR,
`length` INT,
`genre_id` INT,
CONSTRAINT fk_movies_genres
FOREIGN KEY (`genre_id`)
REFERENCES `genres` (`id`),
`category_id` INT,
CONSTRAINT fk_movies_categories
FOREIGN KEY (`category_id`)
REFERENCES `categories` (`id`),
`rating` INT,
`notes` TEXT
);

INSERT INTO `directors` 
VALUES
(1,'Steven', 'A lot of nonsence notes'),
(2,'Steward', 'Some nonsence notes'),
(3,'Peter', Null),
(4,'Hannah', 'Great nonsence notes'),
(5,'Montana', Null);

INSERT INTO `genres` 
VALUES
(1,'Horror', 'Scary as shit'),
(2,'Comedy', 'Fun is fun'),
(3,'Drama', Null),
(4,'Thriller', 'Its okay'),
(5,'Mixed', Null);

INSERT INTO `categories` 
VALUES
(1,'Horror_cat', 'Scary as shit'),
(2,'Comedy_cat', 'Fun is fun'),
(3,'Drama_cat', Null),
(4,'Thriller_cat', 'Its okay'),
(5,'Mixed_cat', Null);

 INSERT INTO `movies` 
 VALUES
 (1, 'The great Gatsby',2,1989,130,4,4,6,'The movie is awesome'),
 (2, 'Rambo',5,2018,130,5,5,5,'The movie is action movie'),
 (3, 'Batman',1,2013,155,3,3,6,'The movie is a thrilogy'),
 (4, 'I care a lot',3,2020,160,2,2,6,'The movie is not worthing'),
 (5, 'The Matrix',3,2000,135,1,1,6,'The movie is crazy');
 
#12. Car Rental Database---------------------------------------------------------------------------------

CREATE SCHEMA `car_rental`;
USE `car_rental`;

CREATE TABLE `categories` (
`id` INT PRIMARY KEY AUTO_INCREMENT,
`category` VARCHAR (50),
`daily_rate` FLOAT (2,2),
`weekly_rate` FLOAT (2,2),
`monthly_rate` FLOAT (2,2),
`weekend_rate` FLOAT (2,2)
);

CREATE TABLE `cars` (
`id` INT PRIMARY KEY AUTO_INCREMENT,
`plate_number` VARCHAR(10) NOT NULL UNIQUE,
`make` VARCHAR (20),
`model` VARCHAR (50) NOT NULL,
`car_year` INT NOT NULL,
`category_id` INT,
CONSTRAINT fk_cars_categories
FOREIGN KEY (`category_id`)
REFERENCES `categories` (`id`),
`doors` INT NOT NULL,
`picture` BLOB,
`condition` VARCHAR (10) NOT NULL,
`available` BOOLEAN NOT NULL
);

 CREATE TABLE `employees`
 (`id` INT PRIMARY KEY AUTO_INCREMENT,
 `first_name` VARCHAR (30) NOT NULL,  
 `last_name` VARCHAR (30) NOT NULL,
 `title` VARCHAR (20) NOT NULL,
 `notes` TEXT
 );
 
 CREATE TABLE `customers` (
 `id` INT PRIMARY KEY AUTO_INCREMENT,
 `driver_licence_number` VARCHAR(10) NOT NULL,
 `full_name` VARCHAR (50) NOT NULL,
 `address` TEXT NOT NULL,
 `city` VARCHAR (20),
 `zip_code` INT NOT NULL,
 `notes` TEXT);

 CREATE TABLE `rental_orders` (
 `id` INT PRIMARY KEY AUTO_INCREMENT,
 `employee_id` INT NOT NULL,
 CONSTRAINT fk_rental_orders_employees
 FOREIGN KEY (`employee_id`)
 REFERENCES `employees` (`id`),
 `customer_id` INT NOT NULL,
CONSTRAINT fk_rental_orders_customers
 FOREIGN KEY (`customer_id`)
 REFERENCES `customers` (`id`),
 `car_id` INT NOT NULL,
  CONSTRAINT fk_rental_orders_cars
 FOREIGN KEY (`car_id`)
 REFERENCES `cars` (`id`),
 `car_condition` VARCHAR (30) NOT NULL,
 `tank_level` INT (10) NOT NULL,
 `kilometrage_start` INT NOT NULL,
 `kilometrage_end` INT NOT NULL,
 `total_kilometrage` INT NOT NULL,
 `start_date` DATE NOT NULL,
 `end_date` DATE NOT NULL,
 `total_days` INT NOT NULL,
 `rate_applied` FLOAT (2,2) NOT NULL,
 `tax_rate` FLOAT (2,2) NOT NULL,
 `order_status` VARCHAR (10) NOT NULL,
 `notes`TEXT
 );
 
 ALTER TABLE `rental_orders`
 CHANGE COLUMN `rate_applied` `rate_applied` FLOAT (5,2) NOT NULL,
 CHANGE COLUMN `tax_rate` `tax_rate` FLOAT (5,2) NOT NULL;
 
 INSERT INTO `categories` 
 VALUES
 (1, 'car', 21.5,10.40,10,50.20),
 (2, 'bus', 40.5,20.40,12,55.20),
 (3, 'motorcycle', 11.5,50.40,60,30.10);
 
 INSERT INTO `cars`
 VALUES
 (1,'SU3121BU','some','BMW',2012,1,4,'n/a','used',true),
 (2,'SU3513BU','some','Peugeot',2015,1,4,'n/a','used',true),
 (3,'SU1111BU','some','Ferrari',2021,1,4,'n/a','used',true);
 
 INSERT INTO `employees` 
 VALUES
 (1,'Ivan', 'Ivanov', 'Mechanik',NULL),
 (2,'Gregary', 'Petkov', 'CEO',NULL),
 (3,'Pao', 'Draganov', 'CFO',NULL);
 
 
 INSERT INTO `customers` 
 VALUES 
 (1,'SW1313BU','Ivan Petakonov Draganov','USA','Kanzas',2100,NULL),
 (2,'SW1323BU','George Mishu Mouse','Germany','Koeln',3100,NULL),
 (3,'SW1521BU','Turtle Turt Turtelov','Pakistan','Jakarta',4100,NULL);
 
 
 INSERT INTO `rental_orders`
 VALUES
(1,1,1,1,'new',30,130,150,'2021-05-20','2021-05-21',1,312.20,10.20,'finished',NULL,20),
(2,2,2,2,'new',30,130,150,'2021-05-20','2021-05-21',1,312.20,10.20,'finished',NULL,20),
(3,3,3,3,'new',30,130,150,'2021-05-20','2021-05-21',1,312.20,10.20,'finished',NULL,20);
 
#13. Basic Insert--------------------------------------------------------------------------------------
#--Do not submit creation of database only the insert statements.
    
 CREATE DATABASE `soft_uni`;
 USE `soft_uni`;
 
 CREATE TABLE `towns` (
 `id` INT PRIMARY KEY auto_increment,
 `name` VARCHAR (30) NOT NULL
 );
 
 CREATE TABLE `addresses` (
  `id` INT PRIMARY KEY AUTO_INCREMENT,
  `address_text` VARCHAR(100),
  `town_id` INT NOT NULL,
  CONSTRAINT fk_addresses_towns
  FOREIGN KEY (`town_id`) 
  REFERENCES `towns`(`id`)
 );
 
 CREATE TABLE `departments` (
   `id` INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR (30) NOT NULL
 );
 
 CREATE TABLE `employees` (
  `id` INT PRIMARY KEY auto_increment,
  `first_name` VARCHAR (30) NOT NULL,
   `middle_name` VARCHAR (30) NOT NULL,
  `last_name` VARCHAR (30) NOT NULL,
  `job_title` VARCHAR (30),
  `department_id` INT,
  CONSTRAINT fk_employees_departments
  FOREIGN KEY (`department_id`)
  REFERENCES `departments` (`id`),
  `hire_date` DATE,
  `salary` DECIMAL (10,2),
  `address_id` INT,
  CONSTRAINT fk_employees_addresses
  FOREIGN KEY (`address_id`)
  REFERENCES `addresses` (`id`)
 );
 
  INSERT INTO `towns` 
 VALUES
 (1,'Sofia'),
 (2,'Plovdiv'), 
 (3,'Varna'), 
 (4,'Burgas'); 
 
  INSERT INTO `departments` 
 VALUES
 (1,'Engineering'),
 (2,'Sales'), 
 (3,'Marketing'), 
 (4,'Software Development'),
 (5,'Quality Assurance');
 
 INSERT INTO `employees` 
 VALUES
 (1,'Ivan', 'Ivanov', 'Ivanov','.NET Developer',4,'2013-02-01',3500.00,NULL),
 (2,'Petar', 'Petrov', 'Petrov','Senior Engineer',1,'2004-03-02',4000.00,NULL),
 (3,'Maria', 'Petrova', 'Ivanova','Intern',5,'2016-08-28',525.25,NULL),
 (4,'Georgi', 'Terziev', 'Ivanov','CEO',2,'2007-12-09',3000.00,NULL),
 (5,'Peter', 'Pan', 'Pan','Intern',3,'2016-08-28',599.88,NULL);
 
 
#14.Basic Select All Fields----------------------------------------------------------------------------------
 
SELECT * FROM `towns`;
SELECT * FROM `departments`;
SELECT * FROM `employees`;

#15.Basic Select All Fields and Order Them-----------------------------------------------------------------

SELECT `name` FROM `towns` 
ORDER BY `name`;
 
SELECT `name` FROM `departments` 
ORDER BY `name`;

SELECT * FROM `employees`
ORDER BY `salary` DESC;
 
#16.Basic Select Some Fields--------------------------------------------------------------------------------

 SELECT `name` FROM `towns` 
 ORDER BY `name`;
 
SELECT `name` FROM `departments` 
 ORDER BY `name`;
 
SELECT `first_name`, `last_name`,`job_title`,`salary` FROM `employees` 
 ORDER BY `salary` DESC;
 
 #17.Increase Employees Salary------------------------------------------------------------------------------

 UPDATE `employees`
 SET `salary` = `salary` * 1.1;
 
 SELECT `salary` FROM `employees`;

#18.Delete All Records--------------------------------------------------------------------------------------
  
DELETE FROM `employees`;
DELETE FROM `addresses`;


UPDATE `employees`
SET `first_name` = NULL;

UPDATE `employees`
SET `last_name` = NULL;

UPDATE `employees`
SET `middle_name` = NULL;

