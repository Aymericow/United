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
`type0` TINYTEXT,
`type1` TINYTEXT,
PRIMARY KEY (`id`),
);

CREATE TABLE `projects`
(
`association_id` BIGINT UNSIGNED,
`id` BIGINT UNSIGNED AUTO_INCREMENT,
`name` TINYTEXT,
`description` TEXT,
`type0` TINYTEXT,
`type1` TINYTEXT,
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

CREATE TABLE `user`
(
`id` BIGINT UNSIGNED AUTO_INCREMENT,
`last_name` TINYTEXT,
`first_name` TINYTEXT,
`email` TINYTEXT,
`phone` TINYTEXT,
`hash` BINARY(64),
`account_id` BIGINT UNSIGNED,
`favorite_project_id` BIGINT UNSIGNED NULL,
`monthly_donation` FLOAT,
PRIMARY KEY (`id`),
);

CREATE TABLE 'favorites'
(
`id` UNSIGNED BIGINT AUTO_INCREMENT,
`user_id` UNSIGNED BIGINT,
`project_id` UNSIGNED BIGINT,
PRIMARY KEY ('id')
);

CREATE PROCEDURE `get_favorite_project_count`
(IN `p_id` BIGINT UNSIGNED)
BEGIN
SELECT COUNT (*) AS `projet_favori`
FROM `favorites`
INNER JOIN `projects` ON `project_id`=`projects`.`id`
WHERE `projects`.`id`=`p_id`
END;
GRANT EXECUTE ON PROCEDURE `get_favorite_project_count` TO 'website'@'localhost';

CREATE TABLE `categories`
(
`id` BIGINT UNSIGNED AUTO_INCREMENT,
`nom` TINYTEXT,
);

CREATE PROCEDURE `get_projects_for_category`
(IN `p_type` TINYTEXT)
BEGIN
SELECT `projects`.`id`
FROM `projects`
INNER JOIN `categories` ON `nom`=`projects`.`type0` OR `nom`=`projects`.`type1`
WHERE `projects`.`type0`=`p_type` OR `projects`.`type1`=`p_type`
END;
GRANT EXECUTE ON PROCEDURE `get_projects_for_category` TO 'website'@'localhost';

CREATE TABLE 'likes'
(
`id` UNSIGNED BIGINT AUTO_INCREMENT,
`user_id` UNSIGNED BIGINT,
`project_id` UNSIGNED BIGINT,
PRIMARY KEY ('iD')
);

CREATE PROCEDURE `get_projects_liked_by_user`
(IN `p_id` BIGINT UNSIGNED)
BEGIN
SELECT `project_id`
FROM `likes`
INNER JOIN `user` ON `user`.`id`=`users_id`
WHERE `user_id`=`p_id`
END;
GRANT EXECUTE ON PROCEDURE `get_projects_liked_by_user` TO 'website'@'localhost';

