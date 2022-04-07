#01. One-To-One Relationship----------------------

CREATE TABLE `passports` (
`passport_id` INT PRIMARY KEY AUTO_INCREMENT,
`passport_number` VARCHAR (20) UNIQUE
);

ALTER TABLE `passports` AUTO_INCREMENT = 101;
INSERT INTO `passports` (`passport_number`)
VALUES
('N34FG21B'),
('K65LO4R7'),
('ZE657QP2');

CREATE TABLE `people` (
`person_id` INT PRIMARY KEY AUTO_INCREMENT,
`first_name` VARCHAR (30) NOT NULL,
`salary` DECIMAL(10,2) NOT NULL,
`passport_id` INT UNIQUE,
CONSTRAINT fk_people_passports
FOREIGN KEY (`passport_id`)
REFERENCES `passports`(`passport_id`)
);

INSERT INTO `people`
VALUES
(1, 'Roberto', 	43300.00,102),
(2,'Tom',56100,103),
(3,'Yana',60200.00,101);

#02. One-To-Many Relationship---------------------

CREATE TABLE `manufacturers`(
`manufacturer_id` INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
`name` VARCHAR(25),
`established_on` DATE 
);

INSERT INTO `manufacturers` (`name`,`established_on`)
VALUES
('BMW','1916-03/01'),
('Tesla','2003-01-01'),
('Lada','1966-05-01');

CREATE TABLE `models` (
`model_id` INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
`name` VARCHAR (20) NOT NULL,
`manufacturer_id` INT,
CONSTRAINT fk_models_manufacturers
FOREIGN KEY (`manufacturer_id`)
REFERENCES `manufacturers` (`manufacturer_id`)
);

INSERT INTO `models` 
VALUES
(101, 'X1', 1),
(102, 'i6', 1),
(103, 'Model S', 2),
(104, 'Model X', 2),
(105, 'Model 3', 2),
(106, 'Nova', 3);

#03. Many-To-Many Relationship------------------------

CREATE TABLE `students` (
`student_id` INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
`name` VARCHAR (20) NOT NULL 
);

INSERT INTO `students`(`name`)
VALUES
('Mila'),
('Toni'),
('Ron');

CREATE TABLE `exams` (
`exam_id` INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
`name` VARCHAR (30) NOT NULL 
);

ALTER TABLE `exams` AUTO_INCREMENT = 101;
INSERT INTO `exams`(`name`)
VALUES
('Spring MVC'),
('Neo4j'),
('Oracle 11g');

CREATE TABLE `students_exams` (
`student_id` INT,
`exam_id` INT,
CONSTRAINT pk_students_exams
PRIMARY KEY (`student_id`, `exam_id`),
CONSTRAINT fk_students_exam_students
FOREIGN KEY (`student_id`)
REFERENCES `students`(`student_id`),
CONSTRAINT fk_students_exam_exams
FOREIGN KEY (`exam_id`)
REFERENCES `exams`(`exam_id`)
);

INSERT INTO `students_exams` 
VALUES
(1,101),
(1,102),
(2,101),
(3,103),
(2,102),
(2,103);

#04. Self-Referencing ---------------------

CREATE TABLE `teachers` (
`teacher_id` INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
`name`VARCHAR(30) NOT NULL,
`manager_id` INT );

ALTER TABLE `teachers` AUTO_INCREMENT = 101;
INSERT INTO `teachers` (`name`,`manager_id`)
VALUES 
('Jonh', NULL),
('Maya', 106),
('Silvia', 106),
('Ted', 105),
('Mark', 101),
('Greta', 101);

ALTER TABLE `teachers`
ADD CONSTRAINT fk_teachers_managers
FOREIGN KEY (`manager_id`)
REFERENCES `teachers` (`teacher_id`);

#05. Online Store Database-----------------------------

CREATE TABLE `cities` (
`city_id` INT(11) PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(50)
);

CREATE TABLE `customers` (
`customer_id` INT(11) PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(50),
`birthday` DATE,
`city_id` INT(11),
CONSTRAINT fk_customers_cities
FOREIGN KEY (`city_id`)
REFERENCES `cities` (`city_id`)
);

CREATE TABLE `orders` (
`order_id` INT(11) PRIMARY KEY AUTO_INCREMENT,
`customer_id` INT(11),
CONSTRAINT fk_orders_customers
FOREIGN KEY (`customer_id`)
REFERENCES `customers` (`customer_id`)
);

CREATE TABLE `item_types` (
`item_type_id` INT(11) PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(50)
);
 
 CREATE TABLE `items` (
`item_id` INT(11) PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(50),
`item_type_id` INT(11),
CONSTRAINT fk_items_item_types
FOREIGN KEY (`item_type_id`)
REFERENCES `item_types` (`item_type_id`)
);

CREATE TABLE `order_items`(
`order_id` INT (11),
`item_id` INT (11),
CONSTRAINT pk_order_itemms
PRIMARY KEY (`order_id`, `item_id`),
CONSTRAINT fk_order_items_orders
FOREIGN KEY (`order_id`)
REFERENCES `orders`(`order_id`),
CONSTRAINT fk_order_items_items
FOREIGN KEY (`item_id`)
REFERENCES `items`(`item_id`)
);


#06. University Database--------------------

CREATE TABLE `payments` (
`payment_id` INT PRIMARY KEY AUTO_INCREMENT,
`payment_date` DATE,
`payment_amount` DECIMAL(8,2),
`student_id` INT
);

CREATE TABLE `majors` (
`major_id` INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(50));

CREATE TABLE `students`(
`student_id` INT PRIMARY KEY AUTO_INCREMENT,
`student_number` VARCHAR(12),
`student_name` VARCHAR(50),
`major_id` INT,
CONSTRAINT fk_students_majors
FOREIGN KEY (`major_id`)
REFERENCES `majors`(`major_id`)
);

ALTER TABLE `payments`
ADD CONSTRAINT fk_payments_students
FOREIGN KEY (`student_id`)
REFERENCES `students` (`student_id`);

CREATE TABLE `subjects` (
`subject_id` INT PRIMARY KEY AUTO_INCREMENT,
`subject_name` VARCHAR(50));

CREATE TABLE `agenda` (
`student_id` INT,
`subject_id` INT,
CONSTRAINT pk_students_agenda
PRIMARY KEY (`student_id`,`subject_id`),
CONSTRAINT fk_agenda_students
FOREIGN KEY (`student_id`)
REFERENCES `students`(`student_id`),
CONSTRAINT fk_agenda_subjects
FOREIGN KEY (`subject_id`)
REFERENCES `subjects` (`subject_id`)
);


#09. Peaks in Rila-------------------------

SELECT m.`mountain_range`, p.`peak_name`, p.`elevation` FROM `mountains` AS m
JOIN `peaks` AS p
ON p.`mountain_id` = m.`id`
WHERE m.`mountain_range` = 'Rila'
ORDER BY p.`elevation` DESC;

