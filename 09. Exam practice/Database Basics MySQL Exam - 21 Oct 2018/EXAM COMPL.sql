

CREATE TABLE `countries`(
`id` INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(40) NOT NULL UNIQUE
);

CREATE TABLE `cities`(
`id` INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(40) NOT NULL UNIQUE,
`population` INT,
`country_id` INT NOT NULL,
CONSTRAINT fk_cities_countries
FOREIGN KEY (`country_id`)
REFERENCES `countries` (`id`)
);

CREATE TABLE `universities`(
`id` INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(60) NOT NULL UNIQUE,
`address` VARCHAR(60) NOT NULL UNIQUE,
`tuition_fee` DECIMAL(19,2) NOT NULL,
`number_of_staff` INT,
`city_id` INT,
CONSTRAINT fk_universities_cities
FOREIGN KEY (`city_id`)
REFERENCES `cities` (`id`)
);

CREATE TABLE `courses`(
`id` INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(40) NOT NULL UNIQUE,
`duration_hours` DECIMAL(19,2),
`start_date` DATE,
`teacher_name` VARCHAR(60) NOT NULL UNIQUE,
`description` TEXT,
`university_id` INT,
CONSTRAINT fk_courses_universities
FOREIGN KEY (`university_id`)
REFERENCES `universities` (`id`)
);

CREATE TABLE `students`(
`id` INT PRIMARY KEY AUTO_INCREMENT,
`first_name` VARCHAR(40) NOT NULL,
`last_name` VARCHAR(40) NOT NULL,
`age` INT,
`phone` VARCHAR(20) NOT NULL UNIQUE,
`email` VARCHAR(255) NOT NULL UNIQUE,
`is_graduated` BOOLEAN NOT NULL,
`city_id` INT,
CONSTRAINT fk_students_courses
FOREIGN KEY (`city_id`)
REFERENCES `cities` (`id`)
);

CREATE TABLE `students_courses` (
`grade` DECIMAL(19,2) NOT NULL,
`student_id` INT NOT NULL,
`course_id` INT NOT NULL,
KEY pk_students_courses (`student_id`,`course_id`),
CONSTRAINT fk_students_courses_students
FOREIGN KEY (`student_id`) 
REFERENCES `students` (`id`),
CONSTRAINT fk_students_courses_courses
FOREIGN KEY (`course_id`)
REFERENCES `courses`(`id`)
);

# --- 02. Insert

 INSERT INTO `courses` (`name`, `duration_hours`, `start_date`, `teacher_name`, `description`, `university_id`)
 SELECT (CONCAT(c.`teacher_name`, ' course')) as `name`,
 CHAR_LENGTH(`name`)/10 as `duration_hours`, 
 DATE(c.`start_date`+5) as `start_date`,
 REVERSE(c.`teacher_name`) as `teacher_name` ,
 CONCAT('Course ', c.`teacher_name`, REVERSE(c.`description`)) as `description`, 
 DAY(`start_date`) as `university_id` 
 FROM `courses` as c
 WHERE c.`id` <= 5;
 
 # --- 03. Update
 
UPDATE `universities` as u
SET u.`tuition_fee` =  u.`tuition_fee` + 300
WHERE u.`id`BETWEEN 5 AND 12;
