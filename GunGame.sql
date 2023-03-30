CREATE TABLE `gungame_stats` (
    `identifier` VARCHAR(255) NOT NULL PRIMARY KEY,
    `kills` INT(11) NOT NULL, 
    `deaths` INT(11) NOT NULL 
) ENGINE = InnoDB;