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

# --- 07.	Extract all pilots

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

