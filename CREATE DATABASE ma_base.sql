drop DATABASE `PSTE_united`;

CREATE DATABASE `PSTE_united`;

USE `PSTE_united`; 
CREATE TABLE `Associations`
(
	`iD` UNSIGNED BIGINT AUTO_INCREMENT,
	`official_id` CHAR(255),
	`name` TINYTEXT,
	`address` TINYTEXT,
	`password_hash` BINARY(64),
	PRIMARY KEY ('iD')
);


CREATE TABLE 'Projects'
(
	`iD` UNSIGNED BIGINT AUTO_INCREMENT,
	`official_id` CHAR(255),
	`name` TINYTEXT,
	`association_iD` UNSIGNED BIGINT,
	PRIMARY KEY ('iD')
);



CREATE PROCEDURE 'get_projects' (IN `p_name` TINYTEXT) 
SQL SECURITY DEFINER
BEGIN
-- DECLARE (pour variables)
-- INTO 
    SELECT `Projects`.`name` AS `nom_du_projet`
    FROM `Projects`
    INNER JOIN `Associations` ON `association_iD` = `Associations`.`iD`
    WHERE `Associations`.`name` = `p_name`;
END;



DROP USER 'website'@'localhost';
CREATE USER 'website'@'localhost'IDENTIFIED BY 'new_password';
GRANT EXECUTE ON PROCEDURE `get_projects` TO 'website'@'localhost';







