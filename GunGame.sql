CREATE TABLE IF NOT EXISTS `gungame_stats` (
    `identifier` VARCHAR(255) NOT NULL PRIMARY KEY,
    `playername` VARCHAR(255) NOT NULL,
    `kills` INT(11) NOT NULL,
    `deaths` INT(11) NOT NULL
) ENGINE = InnoDB;