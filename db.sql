-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               8.0.12 - MySQL Community Server - GPL
-- Server OS:                    Win64
-- HeidiSQL Version:             11.2.0.6213
-- --------------------------------------------------------

-- Dumping structure for table pos.appdata
CREATE TABLE IF NOT EXISTS `appdata` (
    `dataKey` char(50) DEFAULT NULL,
    `dataValue` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dumping data for table pos.appdata: ~2 rows (approximately)
INSERT INTO `appdata` (`dataKey`, `dataValue`) VALUES
('lastOrder', 1000),
('lastSale', 1000);

-- Dumping structure for table pos.positions
CREATE TABLE IF NOT EXISTS `positions` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `name` varchar(50) NOT NULL,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dumping data for table pos.positions: ~0 rows (approximately)
INSERT INTO `positions` (`id`, `name`) VALUES
(1, 'CEO');

-- Dumping structure for table pos.employee
CREATE TABLE IF NOT EXISTS `employee` (
    `empID` int(11) NOT NULL AUTO_INCREMENT,
    `fName` varchar(50) NOT NULL,
    `lName` varchar(50) NOT NULL,
    `password` varchar(50) NOT NULL DEFAULT 'user',
    `dob` date NOT NULL,
    `nic` varchar(12) NOT NULL,
    `gender` enum('m','f') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
    `position` int(11) NOT NULL,
    `phone` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
    `address` varchar(255) NOT NULL,
    `regDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `status` int(11) NOT NULL DEFAULT '0',
    PRIMARY KEY (`empID`) USING BTREE,
    UNIQUE KEY `nic` (`nic`),
    KEY `FK_employee_positions` (`position`),
    CONSTRAINT `FK_employee_positions` FOREIGN KEY (`position`) REFERENCES `positions` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dumping data for table pos.employee: ~0 rows (approximately)
INSERT INTO `employee` (`empID`, `fName`, `lName`, `password`, `dob`, `nic`, `gender`, `position`, `phone`, `address`, `regDate`, `status`) VALUES
(1, 'Admin', '', 'admin', '2021-02-22', '000000000V', 'm', 1, '', '', '2021-02-22 21:08:45', 1);

-- Dumping structure for table pos.accessstructure
CREATE TABLE IF NOT EXISTS `accessstructure` (
    `main` int(11) NOT NULL,
    `sub` int(11) NOT NULL DEFAULT '0',
    `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
    `code` varchar(50) NOT NULL,
    `icon` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dumping data for table pos.accessstructure: ~29 rows (approximately)
INSERT INTO `accessstructure` (`main`, `sub`, `name`, `code`, `icon`) VALUES
(1, 0, 'Users', 'users', 'users'),
(1, 1, 'New', 'new', ''),
(1, 2, 'Update', 'update', ''),
(1, 3, 'Disable', 'disable', ''),
(1, 4, 'Delete', 'delete', ''),
(2, 0, 'Items', 'items', 'cubes'),
(2, 1, 'New', 'new', ''),
(2, 2, 'Update', 'update', ''),
(2, 3, 'Disable', 'disable', ''),
(2, 4, 'Delete', 'delete', ''),
(4, 0, 'Stock', 'stock', 'layer-group'),
(3, 0, 'Suppliers', 'suppliers', 'truck'),
(6, 0, 'Sales', 'sales', 'cash-register'),
(5, 0, 'Purchases', 'purchases', 'shopping-cart'),
(7, 0, 'Access Control', 'access', 'user-shield far'),
(3, 1, 'New', 'new', ''),
(3, 2, 'Update', 'update', ''),
(3, 3, 'Disable', 'disable', ''),
(3, 4, 'Delete', 'delete', ''),
(4, 1, 'New', 'new', ''),
(4, 2, 'Delete', 'delete', ''),
(4, 3, 'Change', 'change', ''),
(5, 1, 'New', 'new', ''),
(5, 2, 'Complete', 'update', ''),
(5, 3, 'Delete', 'delete', ''),
(8, 0, 'Preferences', 'preferences', 'cogs'),
(6, 1, 'New', 'new', ''),
(6, 2, 'Delete', 'delete', ''),
(9, 0, 'Logs', 'logs', 'newspaper');

-- Dumping structure for table pos.access
CREATE TABLE IF NOT EXISTS `access` (
    `empID` int(11) NOT NULL,
    `type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
    `option` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
    PRIMARY KEY (`empID`,`option`,`type`),
    CONSTRAINT `FK__employee` FOREIGN KEY (`empID`) REFERENCES `employee` (`empid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dumping data for table pos.access: ~29 rows (approximately)
INSERT INTO `access` (`empID`, `type`, `option`) VALUES
(1, 'view', 'access'),
(1, 'stock', 'change'),
(1, 'items', 'delete'),
(1, 'purchases', 'delete'),
(1, 'sales', 'delete'),
(1, 'stock', 'delete'),
(1, 'suppliers', 'delete'),
(1, 'users', 'delete'),
(1, 'items', 'disable'),
(1, 'suppliers', 'disable'),
(1, 'users', 'disable'),
(1, 'view', 'items'),
(1, 'view', 'logs'),
(1, 'items', 'new'),
(1, 'purchases', 'new'),
(1, 'sales', 'new'),
(1, 'stock', 'new'),
(1, 'suppliers', 'new'),
(1, 'users', 'new'),
(1, 'view', 'preferences'),
(1, 'view', 'purchases'),
(1, 'view', 'sales'),
(1, 'view', 'stock'),
(1, 'view', 'suppliers'),
(1, 'items', 'update'),
(1, 'purchases', 'update'),
(1, 'suppliers', 'update'),
(1, 'users', 'update'),
(1, 'view', 'users');

-- Dumping structure for table pos.category
CREATE TABLE IF NOT EXISTS `category` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `name` varchar(50) NOT NULL,
    `desc` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
    `regDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `status` int(11) NOT NULL DEFAULT '0',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dumping structure for table pos.items
CREATE TABLE IF NOT EXISTS `items` (
    `itemCode` int(11) NOT NULL AUTO_INCREMENT,
    `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
    `desc` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '',
    `size` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '',
    `category` int(11) NOT NULL DEFAULT '0',
    `unit` varchar(50) NOT NULL DEFAULT 'i',
    `regDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `status` int(11) NOT NULL DEFAULT '0',
    PRIMARY KEY (`itemCode`),
    KEY `FK_items_category` (`category`),
    CONSTRAINT `FK_items_category` FOREIGN KEY (`category`) REFERENCES `category` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1001 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dumping structure for table pos.stock
CREATE TABLE IF NOT EXISTS `stock` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `itemCode` int(11) NOT NULL,
    `price` decimal(10,2) NOT NULL DEFAULT '0.00',
    `qty` float NOT NULL DEFAULT '0',
    PRIMARY KEY (`id`),
    UNIQUE KEY `itemCode_price` (`itemCode`,`price`),
    CONSTRAINT `FK_stock_items` FOREIGN KEY (`itemCode`) REFERENCES `items` (`itemcode`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dumping structure for table pos.suppliers
CREATE TABLE IF NOT EXISTS `suppliers` (
    `supID` int(11) NOT NULL AUTO_INCREMENT,
    `name` varchar(50) NOT NULL,
    `address` varchar(50) NOT NULL,
    `email` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
    `phone` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
    `mobile` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
    `regDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `status` int(11) NOT NULL DEFAULT '0',
    PRIMARY KEY (`supID`)
) ENGINE=InnoDB AUTO_INCREMENT=1001 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dumping structure for table pos.purchases
CREATE TABLE IF NOT EXISTS `purchases` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `orderId` int(11) NOT NULL DEFAULT '0',
    `itemCode` int(11) NOT NULL,
    `price` decimal(10,2) NOT NULL DEFAULT '0.00',
    `sPrice` decimal(10,2) NOT NULL DEFAULT '0.00',
    `qty` float NOT NULL DEFAULT '0',
    `supID` int(11) NOT NULL,
    `ordDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `purDate` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
    `expectDate` datetime DEFAULT NULL,
    `status` int(11) NOT NULL DEFAULT '0',
    PRIMARY KEY (`id`),
    KEY `FK_purchases_items` (`itemCode`),
    KEY `FK_purchases_suppliers` (`supID`),
    CONSTRAINT `FK_purchases_items` FOREIGN KEY (`itemCode`) REFERENCES `items` (`itemcode`),
    CONSTRAINT `FK_purchases_suppliers` FOREIGN KEY (`supID`) REFERENCES `suppliers` (`supid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dumping structure for table pos.sales
CREATE TABLE IF NOT EXISTS `sales` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `saleId` int(11) NOT NULL DEFAULT '0',
    `itemCode` int(11) NOT NULL,
    `price` decimal(10,2) NOT NULL DEFAULT '0.00',
    `qty` float NOT NULL DEFAULT '0',
    `user` int(11) NOT NULL,
    `salesDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `FK_sales_employee` (`user`),
    KEY `FK_sales_items` (`itemCode`),
    CONSTRAINT `FK_sales_employee` FOREIGN KEY (`user`) REFERENCES `employee` (`empid`),
    CONSTRAINT `FK_sales_items` FOREIGN KEY (`itemCode`) REFERENCES `items` (`itemcode`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

