
#01. Table Design--------------------------------------------------

CREATE TABLE `countries` (
`id` INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(45) NOT NULL
);

CREATE TABLE `towns`(
`id` INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(45) NOT NULL,
`country_id` INT NOT NULL,
CONSTRAINT fk_towns_countries
FOREIGN KEY (`country_id`)
REFERENCES `countries` (`id`)
);

CREATE TABLE `stadiums` (
`id` INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(45) NOT NULL,
`capacity` INT NOT NULL,
`town_id` INT NOT NULL,
CONSTRAINT fk_stadiums_towns
FOREIGN KEY (`town_id`)
REFERENCES `towns` (`id`)
);

CREATE TABLE `teams` (
`id` INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(45) NOT NULL,
`established` DATE NOT NULL,
`fan_base` BIGINT NOT NULL DEFAULT 0,
`stadium_id` INT NOT NULL,
CONSTRAINT fk_teams_stadiums
FOREIGN KEY (`stadium_id`)
REFERENCES `stadiums` (`id`)
);

CREATE TABLE `skills_data` (
`id` INT PRIMARY KEY AUTO_INCREMENT,
`dribbling` INT DEFAULT 0,
`pace` INT DEFAULT 0,
`passing` INT DEFAULT 0,
`shooting` INT DEFAULT 0,
`speed` INT DEFAULT 0,
`strength` INT DEFAULT 0
);

CREATE TABLE `players` (
`id` INT PRIMARY KEY AUTO_INCREMENT,
`first_name` VARCHAR(10) NOT NULL,
`last_name` VARCHAR(20) NOT NULL,
`age` INT DEFAULT 0 NOT NULL,
`position` CHAR(1) NOT NULL,
`salary` DECIMAL(10,2) DEFAULT 0 NOT NULL,
`hire_date` DATETIME,
`skills_data_id` INT NOT NULL,
`team_id` INT,
CONSTRAINT fk_players_skills_data
FOREIGN KEY (`skills_data_id`)
REFERENCES `skills_data` (`id`),
CONSTRAINT fk_players_teams
FOREIGN KEY (`team_id`)
REFERENCES `teams` (`id`)
);

CREATE TABLE `coaches` (
`id` INT PRIMARY KEY AUTO_INCREMENT,
`first_name` VARCHAR(10) NOT NULL,
`last_name` VARCHAR(20) NOT NULL,
`salary` DECIMAL(10,2) DEFAULT 0 NOT NULL,
`coach_level` INT NOT NULL DEFAULT 0
);

CREATE TABLE `players_coaches` (
`player_id` INT,
`coach_id` INT,
CONSTRAINT pk_players_coaches
PRIMARY KEY (`player_id`, `coach_id`),
CONSTRAINT fk_players_coaches_players
FOREIGN KEY (`player_id`) 
REFERENCES `players` (`id`),
CONSTRAINT fk_players_coaches_coaches
FOREIGN KEY (`coach_id`) 
REFERENCES `coaches` (`id`)
);

#02. Insert----------------------------------------

INSERT INTO `coaches`  (`first_name`, `last_name`, `salary`, `coach_level`)
SELECT `first_name`, `last_name`, `salary` * 2, CHAR_LENGTH (`first_name`)
FROM `players`
WHERE `age` >= 45;

#03. Update-----------------------------------------

UPDATE `coaches` AS c
JOIN `players_coaches` AS pc
ON c.`id` = pc.`coach_id`
SET c.`coach_level` = c.`coach_level` +1
WHERE c.`first_name` LIKE 'A%';

#04.Delete---------------------------------------

DELETE FROM `players`
WHERE `age` >=45;

#05. Players-----------------------------------

SELECT `first_name`, `age`, `salary`
FROM `players`
ORDER BY `salary` DESC; 

#06. Young offense players without contract-----

SELECT p.`id`, CONCAT(p.`first_name`,' ',  p.`last_name`) AS `full_name`, p.`age`,p.`position`, p.`hire_date`
FROM `players` AS p
JOIN `skills_data` AS sd
ON p.`skills_data_id` = sd.`id`
WHERE 
	`age` < 23 AND 
	`position` = 'A' AND
	`hire_date` IS NULL AND 
     sd.`strength` > 50
ORDER BY `salary`, `age`;

#07. Detail info for all teams------------//SUBQUERY mode

SELECT t.`name`, t.`established`, t.`fan_base`, 
(SELECT COUNT(*) FROM `players` AS p
WHERE p.`team_id` = t.`id`
) AS `players_count`
FROM `teams` AS t
ORDER BY `players_count` DESC, t.`fan_base` DESC;

#08.The fastest player by towns-----------

SELECT MAX(sd.`speed`) AS `max_speed`, towns.`name`
FROM `players` AS p 
JOIN `skills_data` AS sd
ON p.`skills_data_id` = sd.`id`
RIGHT JOIN `teams` AS t 
ON t.`id`  = p.`team_id`
RIGHT JOIN `stadiums` AS s
ON t.`stadium_id` = s.`id`
RIGHT JOIN `towns` AS towns
ON s.`town_id` = towns.`id`
WHERE t.`name` != 'Devify'
GROUP BY towns.`name`
ORDER BY `max_speed` DESC, towns.`name`;

#9.	Total salaries and players by country----------

SELECT c.`name`, COUNT(p.`id`) AS `total_count_of_players`, SUM(`salary`) AS `total_sum_of_salaries`
FROM `players` AS p 
JOIN `skills_data` AS sd
ON p.`skills_data_id` = sd.`id`
RIGHT JOIN `teams` AS t 
ON t.`id`  = p.`team_id`
JOIN `stadiums` AS s
ON t.`stadium_id` = s.`id`
JOIN `towns` AS towns
ON s.`town_id` = towns.`id`
RIGHT JOIN `countries` AS c
ON towns.`country_id` = c.`id`
GROUP BY c.`name`
ORDER BY `total_count_of_players` DESC, c.`name`;

#10. Find all players that play on stadium--------------------

DELIMITER ##
CREATE FUNCTION `udf_stadium_players_count` (stadium_name VARCHAR(30))
RETURNS INT
DETERMINISTIC
BEGIN

RETURN
(
SELECT IF(COUNT(p.`id`) > 0, COUNT(p.`id`), 0)
FROM `players` AS p 
RIGHT JOIN `teams` AS t 
ON t.`id`  = p.`team_id`
RIGHT JOIN `stadiums` AS s
ON t.`stadium_id` = s.`id`
WHERE s.`name` = stadium_name
GROUP BY s.`name`
);
END ##

SELECT `udf_stadium_players_count`('Linklinks');

#11.Find good playmaker by teams---------

DELIMITER ##
CREATE PROCEDURE udp_find_playmaker(min_dribble_points INT, team_name VARCHAR(45))
BEGIN

SELECT CONCAT(p.`first_name`,' ', p.`last_name`) AS `full_name`, p.`age`, p.`salary`, sd.`dribbling`, sd.`speed`, t.`name`
FROM `players` AS p
JOIN `skills_data` AS sd
ON p.`skills_data_id` = sd.`id`
JOIN `teams` AS t 
ON t.`id`  = p.`team_id` 
WHERE
	t.`name` = team_name AND
	sd.`dribbling` > min_dribble_points AND	
    sd.`speed` > (SELECT AVG(`speed`) FROM `skills_data`)
ORDER BY `speed` DESC
LIMIT 1;

END ##

CALL `udp_find_playmaker`(20, 'Skyble');




