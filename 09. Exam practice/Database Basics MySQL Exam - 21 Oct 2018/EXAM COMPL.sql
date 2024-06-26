CREATE TABLE `planets` (
`id` INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(30) NOT NULL
);

CREATE TABLE `spaceports` (
`id` INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(50) NOT NULL,
`planet_id` INT,
CONSTRAINT fk_spaceports_planets
FOREIGN KEY (`planet_id`)
REFERENCES `planets` (`id`)
);

CREATE TABLE `colonists` (
`id` INT PRIMARY KEY AUTO_INCREMENT,
`first_name` VARCHAR(20)  NOT NULL,
`last_name` VARCHAR(20)  NOT NULL,
`ucn` CHAR(10) NOT NULL UNIQUE,
`birth_date` DATE NOT NULL
);

CREATE TABLE `spaceships` (
`id` INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(50)  NOT NULL,
`manufacturer` VARCHAR(30)  NOT NULL,
`light_speed_rate` INT DEFAULT 0
);

CREATE TABLE `journeys` (
`id` INT PRIMARY KEY AUTO_INCREMENT,
`journey_start` DATETIME NOT NULL,
`journey_end` DATETIME NOT NULL,
`purpose` ENUM('Medical', 'Technical', 'Educational', 'Military'),
`destination_spaceport_id` INT,
`spaceship_id` INT,
CONSTRAINT fk_journeys_spaceports
FOREIGN KEY (`destination_spaceport_id`)
REFERENCES `spaceports`(`id`),
CONSTRAINT fk_journeys_spaceships
FOREIGN KEY (`spaceship_id`)
REFERENCES `spaceships`(`id`)
);

CREATE TABLE `travel_cards`(
`id` INT PRIMARY KEY AUTO_INCREMENT,
`card_number` CHAR(10) UNIQUE NOT NULL,
`job_during_journey` ENUM('Pilot', 'Engineer', 'Trooper', 'Cleaner', 'Cook'),
`colonist_id` INT,
`journey_id` INT,
CONSTRAINT fk_travel_cards_colonists
FOREIGN KEY (`colonist_id`)
REFERENCES `colonists`(`id`),
CONSTRAINT fk_travel_cards_journeys
FOREIGN KEY (`journey_id`)
REFERENCES `journeys`(`id`)
);

# --- 01. Data Insertion

INSERT INTO `travel_cards` (`card_number`, `job_during_journey`, `colonist_id`, `journey_id`)
    SELECT
      (
        CASE
          WHEN c.`birth_date` > '1980-01-01' THEN CONCAT_WS('', YEAR(c.`birth_date`), DAY(c.`birth_date`), SUBSTR(c.`ucn`, 1, 4))
          ELSE CONCAT_WS('', year(c.`birth_date`), MONTH(c.`birth_date`), SUBSTR(c.`ucn`, 7, 10))
        END
      ) AS `card_number`,
      (
        CASE
          WHEN c.`id` % 2 = 0 THEN 'Pilot'
          WHEN c.`id` % 3 = 0 THEN 'Cook'
          ELSE 'Engineer'
        END
      ) AS `job_during_journey`,
      c.`id`,
      (
        SUBSTR(c.`ucn`, 1,1)
      ) AS `journey_id`
    FROM `colonists` c
    WHERE c.`id` between 96 AND 100;

# --- 02. Data Update

UPDATE `journeys`
SET `purpose` = (
  CASE
		  WHEN id % 2 = 0 THEN 'Medical'
          WHEN id % 3 = 0 THEN 'Technical'
          WHEN id % 5 = 0 THEN 'Educational'
          WHEN id % 7 = 0 THEN 'Military'
          ELSE `purpose`
        END
);

# --- 03. Data Deletion

DELETE FROM `colonists` AS c
  WHERE c.`id` NOT IN (
    SELECT tc.`colonist_id` 
    FROM `travel_cards` AS tc
  );

# --- 04.Extract all travel cards

SELECT `card_number`, `job_during_journey`
FROM `travel_cards`
ORDER BY `card_number` ASC;

# --- 05. Extract all colonists

SELECT 
    c.`id`,
    CONCAT_WS(' ', c.`first_name`, c.`last_name`) AS `full_name`,
    c.`ucn`
FROM
    `colonists` AS c
ORDER BY c.`first_name` ASC , c.`last_name` ASC , c.`id` ASC;

# --- 06.	Extract all military journeys

SELECT 
    j.`id`, j.`journey_start`, j.`journey_end`
FROM
    `journeys` AS j
WHERE
    j.`purpose` = 'Military'
ORDER BY j.`journey_start` ASC;

# --- 07. Extract all pilots

SELECT 
    c.`id`,
    CONCAT_WS(' ', c.`first_name`, c.`last_name`) AS `full_name`
FROM
    `colonists` AS c
        JOIN
    `travel_cards` AS tc ON tc.`colonist_id` = c.`id`
WHERE
    tc.`job_during_journey` = 'Pilot'
ORDER BY c.`id` ASC;

# --- 08. Count all colonists that are on technical journey

SELECT 
    COUNT(c.`id`) AS `count`
FROM
    `colonists` AS c
        JOIN
    `travel_cards` AS tc ON tc.`colonist_id` = c.`id`
        JOIN
    `journeys` AS j ON j.`id` = tc.`journey_id`
WHERE j.`purpose` = 'Technical';

# --- 09.Extract the fastest spaceship

SELECT s.`name` AS `spaceship_name`, port.`name` AS `spaceport_name`
FROM `spaceships` AS s
JOIN `journeys` AS j
ON j.`spaceship_id` = s.`id`
JOIN `spaceports` as port
ON j.`destination_spaceport_id` = port.`id`
ORDER BY s.`light_speed_rate` DESC
LIMIT 1;

# --- 10.Extract spaceships with pilots younger than 30 years

SELECT s.`name`, s.`manufacturer`, tc.`id`
FROM `spaceships` as s
JOIN `journeys` as j
ON j.`spaceship_id` = s.`id`
JOIN `travel_cards` as tc
ON tc.`journey_id` = j.`id`
JOIN `colonists` as c
ON c.`id` = tc.`colonist_id`
WHERE tc.`job_during_journey` = 'Pilot' AND YEAR(c.`birth_date`) > YEAR(DATE_SUB('2019-01-01', INTERVAL 30 YEAR))
ORDER BY s.`name`;

# --- 11. Extract all educational mission planets and spaceports

SELECT p.`name` as `planet_name`, sp.`name` as `spaceport_name`, j.`id`
FROM `planets` as p
JOIN `spaceports` as sp
ON p.`id` = sp.`planet_id`
JOIN `journeys` as j
ON j.`destination_spaceport_id` = sp.`id`
WHERE j.`purpose` = 'Educational'
ORDER BY sp.`name` DESC;

# --- 12. Extract all planets and their journey count

SELECT p.`name` as `planet_name`, COUNT(j.`id`) as `journeys_count`
FROM `planets` as p
JOIN `spaceports` as sp
ON p.`id` = sp.`planet_id`
JOIN `journeys` as j
ON j.`destination_spaceport_id` = sp.`id`
GROUP BY p.`name`
ORDER BY `journeys_count` DESC ,p.`name` DESC;

# --- 13. Extract the shortest journey

SELECT j.`id`, p.`name` as `planet_name`, sp.`name` as `spaceport_name`, j.`purpose` as `journey_purpose`
FROM `journeys` as j
JOIN `spaceports` as sp
ON j.`destination_spaceport_id` = sp.`id`
JOIN `planets` as p
ON p.`id` = sp.`planet_id`
ORDER BY (DATEDIFF(j.`journey_end`,j.`journey_start` )) ASC
LIMIT 1;

# --- 14. Extract the shortest journey

SELECT tc.`job_during_journey`
FROM `travel_cards` as tc
WHERE tc.`journey_id` =  (
  SELECT j.`id`
  FROM `journeys` as j
  ORDER BY DATEDIFF(j.journey_end, j.journey_start) DESC
  LIMIT 1
)
GROUP BY tc.`job_during_journey`
ORDER BY COUNT(tc.`job_during_journey`)
LIMIT 1;
 
# --- 15. Get colonists count

DELIMITER //
CREATE DEFINER=`root`@`localhost` FUNCTION `udf_count_colonists_by_destination_planet`(planet_name VARCHAR (30)) RETURNS int
    DETERMINISTIC
BEGIN

RETURN (
	  SELECT COUNT(c.`id`)
	  FROM `colonists` as c
      JOIN `travel_cards` as tc on c.`id` = tc.`colonist_id`
      JOIN `journeys` as j on tc.`journey_id` = j.`id`
      JOIN `spaceports` s on j.`destination_spaceport_id` = s.`id`
      JOIN `planets` as p on s.`planet_id` = p.`id`
      WHERE p.`name` = planet_name
);
END //
DELIMITER ;

# --- 16. Modify spaceship

DELIMITER //
CREATE PROCEDURE udp_modify_spaceship_light_speed_rate(spaceship_name VARCHAR(50), light_speed_rate_increse INT(11))
  BEGIN
    if (SELECT COUNT(ss.`name`) FROM `spaceships` as ss WHERE ss.`name` = spaceship_name > 0) 
    THEN
      UPDATE `spaceships` as ss
        SET ss.`light_speed_rate` = ss.`light_speed_rate` + light_speed_rate_increse
        WHERE ss.`name` = spaceship_name;
    ELSE
      SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Spaceship you are trying to modify does not exists.';
      ROLLBACK;
    END IF;
  END //
  
DELIMITER ;


