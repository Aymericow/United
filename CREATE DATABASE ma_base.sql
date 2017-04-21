drop DATABASE `PSTE_united`;

CREATE DATABASE `PSTE_united`;

USE `PSTE_united`; 

CREATE TABLE `associations`
(
	`iD` UNSIGNED BIGINT AUTO_INCREMENT,
	`official_id` CHAR(255),
	`name` TINYTEXT,
	`address` TINYTEXT,
	`password_hash` BINARY(64),
	`description` TEXT,
	PRIMARY KEY ('iD')
);


CREATE TABLE 'account'
(
	`iD` UNSIGNED BIGINT AUTO_INCREMENT,
	`value` FLOAT,
	PRIMARY KEY ('iD')
);


CREATE TABLE 'projects'
(
	`iD` UNSIGNED BIGINT AUTO_INCREMENT,
	`official_id` CHAR(255),
	`type1` TINYTEXT,
	`name` TINYTEXT,
	`association_iD` UNSIGNED BIGINT,
	`description` TEXT,
	`account_id`UNSIGNED BIGINT,
	PRIMARY KEY ('iD')
);


CREATE TABLE 'likes'
(
	`iD` UNSIGNED BIGINT AUTO_INCREMENT,
	`user_iD` UNSIGNED BIGINT,
	`project_iD` UNSIGNED BIGINT,
	PRIMARY KEY ('iD')
);


CREATE TABLE 'favorites'
(
	`iD` UNSIGNED BIGINT AUTO_INCREMENT,
	`user_iD` UNSIGNED BIGINT,
	`project_iD` UNSIGNED BIGINT,
	PRIMARY KEY ('iD')
);


CREATE TABLE 'volunteers'
(
	`iD` UNSIGNED BIGINT AUTO_INCREMENT,
	`user_iD` UNSIGNED BIGINT,
	`project_iD` UNSIGNED BIGINT,
	PRIMARY KEY ('iD')
);


CREATE TABLE 'transaction'
(
	`iD` UNSIGNED BIGINT AUTO_INCREMENT,
	`account_id` UNSIGNED BIGINT,
	`value` FLOAT,
	`description` TINYTEXT,
	PRIMARY KEY ('iD')
);


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
	PRIMARY KEY (`account_id`),
);


CREATE TABLE `images` (
    `img_id` INT NOT NULL AUTO_INCREMENT ,
    `img_nom` VARCHAR( 50 ) NOT NULL ,
    `img_taille` VARCHAR( 25 ) NOT NULL ,
    `img_type` VARCHAR( 25 ) NOT NULL ,
    `img_desc` VARCHAR( 100 ) NOT NULL ,
    `img_blob` BLOB NOT NULL ,
    PRIMARY KEY ( `img_id` )
)


CREATE TABLE `categories`
(
`id` BIGINT UNSIGNED AUTO_INCREMENT,
`nom` TINYTEXT,
);


CREATE TABLE `account`
(
`id` BIGINT UNSIGNED AUTO_INCREMENT,
`value` FLOAT ,
)


--PROCÉDURE POUR COMPTER LE NOMBRE DE LIKES SUR UN PROJET
CREATE PROCEDURE `get_likes_count` (IN `p_id` BIGINT UNSIGNED)
BEGIN
	SELECT COUNT(*) AS `like_count` ;
	FROM `likes`;
	INNER JOIN `projects` ON `project_iD`=`projects`.`iD`;
	WHERE `projects`.`iD`=`p_id`;
END;


--PROCÉDURE POUR RÉCUPÉRER TOUT LES PROJETS LIÉS À UNE ASSOCIATION
CREATE PROCEDURE `get_projects` (IN `p_id` BIGINT UNSIGNED) 
BEGIN
    SELECT `projects`.`name` AS `nom_du_projet`;
    FROM `projects`;
    INNER JOIN `associations` ON `association_iD` = `associations`.`iD`;
    WHERE `associations`.`id` = `p_id`;
END;


--PROCÉDURE POUR COMPTER LE NOMBRE DE FAVORIS SUR UN PROJET
CREATE PROCEDURE `get_favorite_project_count`(IN `p_id` BIGINT UNSIGNED)
BEGIN
	SELECT COUNT (*) AS `projet_favori`
	FROM `favorites`
	INNER JOIN `projects` ON `project_id`=`projects`.`id`
	WHERE `projects`.`id`=`p_id`;
END;


--PROCEDURE POUR RECUPERER TOUT LES NOMS DES PROJETS LIES A UNE CATEGORIE 
CREATE PROCEDURE `get_projects_for_category` (IN `p_type` TINYTEXT)
BEGIN
	SELECT `projects`.`id` 
	FROM `projects`
	INNER JOIN `categories` ON `nom`=`projects`.`type0` OR `nom`=`projects`.`type1`
	WHERE `projects`.`type0`=`p_type`;
END;


--PROCEDURE POUR RECUPERER LA DESCRIPTION D'UN PROJET
CREATE PROCEDURE `get_description` (IN `p_id` BIGINT UNSIGNED)
BEGIN
	SELECT `projects`.`description`
	FROM `projects`	
	WHERE `projects`.`id`=`p_id`
END;


--PROCEDURE POUR RECUPERER LES PROJETS LIKÉS PAR UN UTILISATEUR
CREATE PROCEDURE `get_projects_liked_by_user`(IN `p_id` BIGINT UNSIGNED)
BEGIN
	SELECT `project_id`
	FROM `likes`
	INNER JOIN `user` ON `user`.`id`=`user_id`
	WHERE `user_id`=`p_id`
END;


--Procédure pour liker 
CREATE PROCEDURE `like_project` (IN `p_iD`BIGINT UNSIGNED,IN `p_uiD`BIGINT UNSIGNED)
BEGIN
	INSERT INTO `likes`(`project_id`, `user_id`) VALUES(`p_iD`, `p_uiD`);
END;


--Procédure pour favoriser
CREATE PROCEDURE `favorise_project` (IN `p_iD` BIGINT UNSIGNED ,IN `p_uiD` BIGINT UNSIGNED)
BEGIN
	INSERT INTO `favorites`(`project_id`, `user_id`) VALUES(`p_iD`, `p_uiD`);
END;


--Procédure pour modifier la description d'un projet
CREATE PROCEDURE `update_project_description` (IN `p_iD` BIGINT UNSIGNED ,IN `p_desc` TEXT)
BEGIN
	UPDATE `projects` SET `description` = `p_desc` WHERE `iD` = `p_iD`;
END;


--Prcoédure pour modifier la somme d'argent 
CREATE PROCEDURE `donate` (IN `p_iduser` BIGINT UNSIGNED, IN `p_idproject` BIGINT UNSIGNED, IN `p_value` FLOAT)

BEGIN
	DECLARE `v_desc` TEXT;
	DECLARE `v_user` TEXT;
	DECLARE `v_user_value` FLOAT;
	DECLARE `v_project_value` FLOAT;

	SELECT CONCAT_WS(`first_name`, ' ', `last_name`) INTO `v_user` FROM `user` WHERE `id` = `p_iduser`;
	SELECT CONCAT_WS(`associations`.`name`, ' ', `projects`.`name`, ' ', `v_user`) INTO `v_desc` FROM `associations` INNER JOIN `projects` ON `projects`.`association_id` = `associations`.`id` WHERE `project`.`id` = `p_id`; 

	INSERT INTO `transaction`(`account_id`, `value`,`description`) VALUES(`p_iduser`, `p_value`, `v_desc`);

	SELECT `value` INTO `v_user_value` FROM `account` WHERE `id` = (SELECT `account_id` FROM `users` WHERE `id` = `p_iduser`);
	SELECT `value` INTO `v_project_value` FROM `account` WHERE `id` = (SELECT `account_id` FROM `projects` WHERE `id` = `p_idproject`);

	SET `v_user_value` = `v_user_value` - `p_value`;
	SET `v_project_value` = `v_project_value` + `p_value`;


	UPDATE `account` SET `value` = `v_user_value` WHERE `id` = (SELECT `account_id` FROM `users` WHERE `id` = `p_iduser`);
	UPDATE `account` SET `value` = `v_project_value` WHERE `id` = (SELECT `account_id` FROM `projects` WHERE `id` = `p_idproject`);


END;



	




DROP USER 'website'@'localhost';
CREATE USER 'website'@'localhost'IDENTIFIED BY 'new_password';
GRANT EXECUTE ON PROCEDURE `get_projects` TO 'website'@'localhost';
GRANT EXECUTE ON PROCEDURE `get_likes_count` TO 'website'@'localhost';
GRANT EXECUTE ON PROCEDURE `get_favorite_project_count` TO 'website'@'localhost';






