# --- 01. Table Design

CREATE TABLE `branches`(
`id` INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR(30) NOT NULL UNIQUE
);

CREATE TABLE `employees`(
`id` INT PRIMARY KEY AUTO_INCREMENT,
`first_name` VARCHAR(20) NOT NULL,
`last_name` VARCHAR(20) NOT NULL,
`salary` DECIMAL(10,2) NOT NULL,
`started_on` DATE NOT NULL,
`branch_id` INT NOT NULL,
CONSTRAINT fk_employees_branches
FOREIGN KEY (`branch_id`)
REFERENCES `branches` (`id`)
);

CREATE TABLE `clients`(
`id` INT PRIMARY KEY AUTO_INCREMENT,
`full_name` VARCHAR(50) NOT NULL,
`age` INT NOT NULL
);

CREATE TABLE `bank_accounts`(
`id` INT PRIMARY KEY AUTO_INCREMENT,
`account_number` VARCHAR(10) NOT NULL,
`balance` DECIMAL(10,2) NOT NULL,
`client_id` INT NOT NULL,
CONSTRAINT fk_bank_accounts_clients
FOREIGN KEY (`client_id`)
REFERENCES `clients` (`id`)
);

CREATE TABLE `cards`(
`id` INT PRIMARY KEY AUTO_INCREMENT,
`card_number` VARCHAR(19) NOT NULL,
`card_status` VARCHAR(7) NOT NULL,
`bank_account_id` INT NOT NULL,
CONSTRAINT fk_cards_bank_accounts
FOREIGN KEY (`bank_account_id`)
REFERENCES `bank_accounts` (`id`)
);

CREATE TABLE `employees_clients`(
`employee_id` INT,
`client_id` INT,
KEY (`employee_id`,`client_id`),
CONSTRAINT fk_employees_clients_clients
FOREIGN KEY (`client_id`)
REFERENCES `clients` (`id`),
CONSTRAINT fk_employees_clients_employees
FOREIGN KEY (`employee_id`)
REFERENCES `employees` (`id`)
);

# --- 02. Insert

INSERT INTO `cards` (`card_number`, `card_status`,`bank_account_id`)
SELECT 
(REVERSE(c.`full_name`)) as `card_number`,
'Active',
c.`id`
FROM `clients` as c
WHERE c.`id` BETWEEN 191 AND 200;

# --- 03. Update

UPDATE `employees_client`
SET `employee_id` = ()
WHERE `employee_id` = `client_id`;






