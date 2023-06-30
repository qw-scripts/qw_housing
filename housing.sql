CREATE TABLE IF NOT EXISTS `houses` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `owned` tinyint(1) DEFAULT 0,
    `owner` varchar(255) DEFAULT NULL,
    `x` FLOAT(10) NOT NULL,
    `y` FLOAT(10) NOT NULL,
    `z` FLOAT(10) NOT NULL,
    `shell` varchar(255) NOT NULL,
    `price` int(11) DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=1;

CREATE TABLE `housing_props` (
	`id` int(11) NOT NULL AUTO_INCREMENT,
	`model` varchar(50) NOT NULL,
	`x` FLOAT(10) NOT NULL,
    `y` FLOAT(10) NOT NULL,
    `z` FLOAT(10) NOT NULL,
    `rx` FLOAT(10) NOT NULL,
    `ry` FLOAT(10) NOT NULL,
    `rz` FLOAT(10) NOT NULL,
    `propSettings` varchar(255) DEFAULT '[]',
    `houseId` int(11) NOT NULL,
	PRIMARY KEY (`id`) USING BTREE,
    KEY `FK_housing_props` (`houseId`) USING BTREE,
    CONSTRAINT `FK_housing_props` FOREIGN KEY (`houseId`) REFERENCES `houses` (`id`) ON UPDATE CASCADE ON DELETE CASCADE
) COLLATE='utf8mb4_general_ci' ENGINE=InnoDB AUTO_INCREMENT=1;