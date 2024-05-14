

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

 # --- 04. Delete
 
 DELETE u 
 FROM `universities` as u
 WHERE u.`number_of_staff` IS NULL;
 
 # --- 05. Cities
  
  SELECT * FROM `cities`
  ORDER BY `population` DESC;
  
# --- 06. Students age

SELECT `first_name`, `last_name`, `age`, `phone`, `email`
FROM `students`
WHERE `age` >= 21
ORDER BY `first_name` DESC, `email` ASC, `id` ASC
LIMIT 10;
  
# --- 07. New students

SELECT 
CONCAT_WS(' ', s.`first_name`, s.`last_name`) as `full_name`,
SUBSTRING(`email`, 2,10) as `username`,
REVERSE(`phone`) as `password`
FROM `students` as s
LEFT JOIN `students_courses` as sc
ON s.`id` = sc.`student_id`
WHERE sc.`course_id` IS NULL
ORDER BY `password` DESC;

# --- 08. Students count

SELECT 
COUNT(sc.`student_id`) as `students_count`,
u.`name` as `university_name`
FROM `universities` as u
JOIN `courses` as c
ON u.`id` = c.`university_id`
JOIN `students_courses` as sc
ON  c.`id` = sc.`course_id`
GROUP BY u.`id`
HAVING `students_count` >= 8
ORDER BY `students_count` DESC, `university_name` DESC;

# --- 09. Price rankings

SELECT u.`name` as `university_name`,
c.`name` as `city_name`, 
u.`address`,
(CASE
    WHEN u.`tuition_fee` < 800 THEN "Cheap"
    WHEN u.`tuition_fee` BETWEEN 800 AND 1200 THEN "normal"
    WHEN u.`tuition_fee` BETWEEN 1200 AND 2500 THEN "high"
    ELSE "expensive"
END) AS `price_rank`, u.`tuition_fee`
FROM `universities` as u
JOIN `cities` as c
ON c.`id` = u.`city_id`
ORDER BY u.`tuition_fee` ASC;

# --- 10.Average grades
DELIMITER $$$

CREATE DEFINER=`root`@`localhost` FUNCTION `udf_average_alumni_grade_by_course_name`(course_name VARCHAR(60)) RETURNS decimal(19,2)
    DETERMINISTIC
BEGIN
DECLARE average_grade DECIMAL(19, 2);
DELIMITER 
SET average_grade := (
	SELECT AVG(sc.`grade`) 
	FROM `courses` as c
	JOIN `students_courses` as sc
	ON c.`id` = sc.`course_id`
	JOIN `students` as s
	ON s.`id` = sc.`student_id`
	WHERE s.`is_graduated` = TRUE AND c.`name` = course_name
	GROUP BY c.`name`
);

RETURN average_grade;
END $$$

DELIMITER ;

SELECT c.`name`, udf_average_alumni_grade_by_course_name('Quantum Physics') as `average_alumni_grade` 
FROM `courses` c 
WHERE c.`name` = 'Quantum Physics';

# --- 11.Average grades

DELIMITER $$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `udp_graduate_all_students_by_year`(year_started INT)
BEGIN
UPDATE `students` as s
	JOIN `students_courses` as sc
    ON s.`id` = sc.`student_id`
    JOIN `courses` as c
    ON c.`id` = sc.`course_id`
SET s.`is_graduated` = TRUE
WHERE YEAR(c.`start_date`) = year_started;
END $$$

DELIMITER ;



CALL udp_graduate_all_students_by_year(2017);
