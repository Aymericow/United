DROP DATABASE `united`;
CREATE DATABASE `united`;
USE `united`;
CREATE TABLE `association`
(
`id` BIGINT UNSIGNED AUTO_INCREMENT,
`official_id` TINYTEXT,
`name` TINYTEXT,
`address` TINYTEXT,
`description` TEXT,
`hash` BINARY(64),
PRIMARY KEY (`id`),
);

CREATE TABLE `project`
(
`association_id` BIGINT UNSIGNED,
`id` BIGINT UNSIGNED AUTO_INCREMENT,
`name` TINYTEXT,
`description` TEXT,
PRIMARY KEY (`id`),
);

CREATE PROCEDURE `get_projects`
(IN `p_name` TINYTEXT)
SQL SECURITY DEFINER
BEGIN
SELECT `project`.`name` AS `projets de l association`
FROM `project`
INNER JOIN `association` ON `association_id`=`association`.`id`
WHERE `association`.`name`=`p_name`
END;
DROP USER 'website'@'localhost';
CREATE USER 'website'@'localhost' IDENTIFIED BY 'password';
GRANT EXECUTE ON PROCEDURE `get_projects` TO 'website'@'localhost'

CREATE TABLE `member`
(
`id` BIGINT UNSIGNED AUTO_INCREMENT,
`name` TINYTEXT,
`first_name` TINYTEXT,

);
