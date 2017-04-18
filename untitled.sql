DROP DATABASE `united_base`;
CREATE DATABASE `united_base`;
USE `united_base`;
CREATE TABLE `association`
(
    `id` BIGINT AUTO_INCREMENT,
    `official_id` TINYTEXT,
    `name` TINYTEXT,
    `address` TINYTEXT,
    `description` TEXT,
    `passwordh` BINARY(64),
    PRIMARY KEY (`id`)
);
CREATE TABLE `projet`
(
    `id` BIGINT AUTO_INCREMENT,
    `official_id` TINYTEXT,
    `name` TINYTEXT,
    `description` TEXT,
    `association_id` BIGINT,
    PRIMARY KEY (`id`)
);

CREATE PROCEDURE `get_projects` 
(
	`p_name` TINYTEXT
)
BEGIN 
SELECT `projet`.`name`
FROM `projet`
INNER JOIN `association` ON `association_id` = `association`.`id`
WHERE `association`.`name` = 'p_name';
END;
