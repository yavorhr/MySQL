CREATE DATABASE camp;
use camp;


#01. Mountains and Peaks----------------------------------

CREATE TABLE `mountains` (
`id` INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(30)
);

CREATE TABLE `peaks` (
`id` INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(30),
`mountain_id` INT NOT NULL
);

ALTER TABLE `peaks`
ADD CONSTRAINT  `fk_peaks_mountains`
FOREIGN KEY (`mountain_id`)
REFERENCES  `mountains` (`id`);

#02. Trip Organization---------------------------------

SELECT c.`id` AS `driver_id`, v.`vehicle_type`,CONCAT(`first_name`,' ',`last_name` )
FROM `campers` AS c
JOIN `vehicles` AS v
ON v.`driver_id` = c.`id`;

#03. SoftUni Hiking----------------------------------

DROP TABLE `mountains`;
DROP TABLE `peaks`;

CREATE TABLE `mountains` (
`id` INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(30)
);

CREATE TABLE `peaks` (
`id` INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(30),
`mountain_id` INT NOT NULL
);

ALTER TABLE `peaks`
ADD CONSTRAINT  `fk_peaks_mountains`
FOREIGN KEY (`mountain_id`)
REFERENCES  `mountains` (`id`)
ON DELETE CASCADE;


