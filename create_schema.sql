-- MySQL dump 10.13  Distrib 8.0.30, for macos12 (x86_64)
--
-- Host: localhost    Database: final_project
-- ------------------------------------------------------
-- Server version	8.0.28

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `amenities`
--

DROP TABLE IF EXISTS `amenities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `amenities`
(
    `name`        varchar(15) NOT NULL,
    `description` varchar(45) DEFAULT NULL,
    `id`          int         NOT NULL AUTO_INCREMENT,
    PRIMARY KEY (`id`),
    UNIQUE KEY `name_UNIQUE` (`name`),
    UNIQUE KEY `description_UNIQUE` (`description`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `amenities`
--

LOCK
TABLES `amenities` WRITE;
/*!40000 ALTER TABLE `amenities` DISABLE KEYS */;
INSERT INTO `amenities`
VALUES ('Swimming pool', 'Exquisite swimming pool', 1),
       ('Heating', 'Heating available 24*7', 2),
       ('Bar', 'In house bar!', 3),
       ('Dining', 'Best room service!', 4);
/*!40000 ALTER TABLE `amenities` ENABLE KEYS */;
UNLOCK
TABLES;

--
-- Table structure for table `amenitiesathotel`
--

DROP TABLE IF EXISTS `amenitiesathotel`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `amenitiesathotel`
(
    `hotelid`   int NOT NULL,
    `amenityId` int NOT NULL,
    PRIMARY KEY (`hotelid`, `amenityId`),
    KEY         `amenity_fk_idx` (`amenityId`),
    CONSTRAINT `a_hotel_fk` FOREIGN KEY (`hotelid`) REFERENCES `hotel` (`id`),
    CONSTRAINT `amenity_fk` FOREIGN KEY (`amenityId`) REFERENCES `amenities` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `amenitiesathotel`
--

LOCK
TABLES `amenitiesathotel` WRITE;
/*!40000 ALTER TABLE `amenitiesathotel` DISABLE KEYS */;
INSERT INTO `amenitiesathotel`
VALUES (1, 1),
       (2, 1),
       (1, 2),
       (1, 3),
       (2, 3),
       (1, 4);
/*!40000 ALTER TABLE `amenitiesathotel` ENABLE KEYS */;
UNLOCK
TABLES;

--
-- Table structure for table `booking`
--

DROP TABLE IF EXISTS `booking`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `booking`
(
    `customer`          int NOT NULL,
    `bookingId`         int NOT NULL,
    `hotel`             int NOT NULL,
    `bookedByStaffId`   int NOT NULL,
    `isCheckedIn`       tinyint     DEFAULT '0',
    `isCheckedOut`      tinyint     DEFAULT '0',
    `startDate`         datetime    DEFAULT NULL,
    `endDate`           datetime    DEFAULT NULL,
    `rating`            varchar(45) DEFAULT NULL,
    `ratingDescription` varchar(45) DEFAULT NULL,
    `roomNo`            int NOT NULL,
    PRIMARY KEY (`bookingId`),
    UNIQUE KEY `startDate_UNIQUE` (`startDate`),
    UNIQUE KEY `endDate_UNIQUE` (`endDate`),
    KEY                 `customer_fk_idx` (`customer`),
    KEY                 `hotel_fk_idx` (`hotel`),
    KEY                 `staff_fk_idx` (`bookedByStaffId`),
    KEY                 `room_fk_idx` (`roomNo`),
    CONSTRAINT `booking_hotel_fk` FOREIGN KEY (`hotel`) REFERENCES `hotel` (`id`),
    CONSTRAINT `customer_fk` FOREIGN KEY (`customer`) REFERENCES `customer` (`customer_id`),
    CONSTRAINT `occupant_fk` FOREIGN KEY (`bookingId`) REFERENCES `occupantsinorder` (`bookingId`),
    CONSTRAINT `room_fk` FOREIGN KEY (`roomNo`) REFERENCES `rooms` (`roomNo`),
    CONSTRAINT `staff_fk` FOREIGN KEY (`bookedByStaffId`) REFERENCES `staff` (`staffid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `booking`
--

LOCK
TABLES `booking` WRITE;
/*!40000 ALTER TABLE `booking` DISABLE KEYS */;
/*!40000 ALTER TABLE `booking` ENABLE KEYS */;
UNLOCK
TABLES;

--
-- Table structure for table `customer`
--

DROP TABLE IF EXISTS `customer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customer`
(
    `customer_id` int         NOT NULL AUTO_INCREMENT,
    `ssn`         varchar(45) NOT NULL,
    `name`        varchar(45) DEFAULT NULL,
    `phone`       varchar(45) NOT NULL,
    `email`       varchar(45) DEFAULT NULL,
    `age`         int         DEFAULT NULL,
    PRIMARY KEY (`customer_id`),
    UNIQUE KEY `ssn_UNIQUE` (`ssn`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customer`
--

LOCK
TABLES `customer` WRITE;
/*!40000 ALTER TABLE `customer` DISABLE KEYS */;
INSERT INTO `customer`
VALUES (1, 'SSN58534', 'Arun', '2323232', 'da@j.com', 12),
       (2, 'SSN13987', 'Pde', 'kjwn!lmk', '238928', 13),
       (3, 'SSN82402', 'Mandora', 'kdsl@jn.ciom', '313981', 23),
       (5, 'SSN2929', 'Paul', 'mwkjn@jkn.com', '3989283', 23),
       (6, 'SSN0182398', 'Laura', 'la@uwd.com', '12793109', 42);
/*!40000 ALTER TABLE `customer` ENABLE KEYS */;
UNLOCK
TABLES;

--
-- Table structure for table `hotel`
--

DROP TABLE IF EXISTS `hotel`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hotel`
(
    `id`        int         NOT NULL AUTO_INCREMENT,
    `name`      varchar(45) NOT NULL,
    `street`    varchar(45) DEFAULT NULL,
    `town`      varchar(45) DEFAULT NULL,
    `state`     varchar(2)  DEFAULT NULL,
    `zip`       varchar(45) DEFAULT NULL,
    `avgrating` float       DEFAULT NULL,
    `phone`     varchar(20) DEFAULT NULL,
    `email`     varchar(45) DEFAULT NULL,
    PRIMARY KEY (`id`),
    UNIQUE KEY `email_UNIQUE` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hotel`
--

LOCK
TABLES `hotel` WRITE;
/*!40000 ALTER TABLE `hotel` DISABLE KEYS */;
INSERT INTO `hotel`
VALUES (1, 'Hotel Plaza', 'Symphony Street', 'Truro', 'MA', '02115', 0, '+1 656-334-6296',
        'plaza@hmz.com'),
       (2, 'Hotel Banquet', 'Harrison Street', 'Truro', 'MA', '02115', 0, '+1 616-334-6296',
        'banquet@hmz.com');
/*!40000 ALTER TABLE `hotel` ENABLE KEYS */;
UNLOCK
TABLES;

--
-- Table structure for table `occupant`
--

DROP TABLE IF EXISTS `occupant`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `occupant`
(
    `ssn`  varchar(20) NOT NULL,
    `name` varchar(45) NOT NULL,
    `age`  int DEFAULT NULL,
    PRIMARY KEY (`ssn`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `occupant`
--

LOCK
TABLES `occupant` WRITE;
/*!40000 ALTER TABLE `occupant` DISABLE KEYS */;
/*!40000 ALTER TABLE `occupant` ENABLE KEYS */;
UNLOCK
TABLES;

--
-- Table structure for table `occupantsinorder`
--

DROP TABLE IF EXISTS `occupantsinorder`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `occupantsinorder`
(
    `bookingId`    int         NOT NULL,
    `occuppantSSN` varchar(45) NOT NULL,
    `age`          int DEFAULT NULL,
    PRIMARY KEY (`bookingId`, `occuppantSSN`),
    KEY            `occupant_ssn_idx` (`occuppantSSN`),
    CONSTRAINT `occupant_ssn` FOREIGN KEY (`occuppantSSN`) REFERENCES `occupant` (`ssn`),
    CONSTRAINT `order_id` FOREIGN KEY (`bookingId`) REFERENCES `order` (`orderid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `occupantsinorder`
--

LOCK
TABLES `occupantsinorder` WRITE;
/*!40000 ALTER TABLE `occupantsinorder` DISABLE KEYS */;
/*!40000 ALTER TABLE `occupantsinorder` ENABLE KEYS */;
UNLOCK
TABLES;

--
-- Table structure for table `roomcategory`
--

DROP TABLE IF EXISTS `roomcategory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `roomcategory`
(
    `category`    enum('Deluxe','Ultra','Suite') NOT NULL,
    `hasFridge`   tinyint      DEFAULT '0',
    `hasBalcony`  tinyint      DEFAULT '0',
    `description` varchar(128) DEFAULT NULL,
    `hasBathtub`  tinyint      DEFAULT '0',
    PRIMARY KEY (`category`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roomcategory`
--

LOCK
TABLES `roomcategory` WRITE;
/*!40000 ALTER TABLE `roomcategory` DISABLE KEYS */;
INSERT INTO `roomcategory`
VALUES ('Deluxe', 1, 0, 'Enjoy Deluxe previlige, clean rooms with built in fridge', 0),
       ('Ultra', 1, 1, 'Enjoy Ultra previlige, clean rooms with a balcony and built in fridge!', 0),
       ('Suite', 1, 1,
        'Enjoy our best Suite previlige, clean rooms with  a balcony, bathtub and built in fridge',
        1);
/*!40000 ALTER TABLE `roomcategory` ENABLE KEYS */;
UNLOCK
TABLES;

--
-- Table structure for table `rooms`
--

DROP TABLE IF EXISTS `rooms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rooms`
(
    `roomNo`   int NOT NULL,
    `hotelId`  int NOT NULL,
    `category` enum('Deluxe','Ultra','Suite') NOT NULL,
    `floor`    int NOT NULL,
    `capacity` int NOT NULL,
    PRIMARY KEY (`roomNo`, `hotelId`),
    KEY        `hotel_fk_idx` (`hotelId`),
    KEY        `category_fk_idx` (`category`),
    CONSTRAINT `category_fk` FOREIGN KEY (`category`) REFERENCES `roomcategory` (`category`),
    CONSTRAINT `hotel_fk` FOREIGN KEY (`hotelId`) REFERENCES `hotel` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rooms`
--

LOCK
TABLES `rooms` WRITE;
/*!40000 ALTER TABLE `rooms` DISABLE KEYS */;
INSERT INTO `rooms`
VALUES (1, 1, 'Deluxe', 1, 5),
       (2, 1, 'Deluxe', 1, 3),
       (3, 1, 'Deluxe', 1, 3),
       (4, 1, 'Deluxe', 1, 3),
       (5, 1, 'Ultra', 1, 4),
       (6, 1, 'Ultra', 1, 4),
       (7, 1, 'Ultra', 1, 4),
       (8, 2, 'Ultra', 1, 4),
       (9, 2, 'Ultra', 1, 4),
       (10, 2, 'Ultra', 1, 4),
       (11, 2, 'Suite', 2, 4),
       (12, 2, 'Suite', 2, 4),
       (13, 2, 'Suite', 2, 4);
/*!40000 ALTER TABLE `rooms` ENABLE KEYS */;
UNLOCK
TABLES;

--
-- Table structure for table `staff`
--

DROP TABLE IF EXISTS `staff`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `staff`
(
    `staffid`           int         NOT NULL,
    `name`              varchar(45) NOT NULL,
    `phone`             varchar(45) NOT NULL,
    `email`             varchar(45) DEFAULT NULL,
    `ssn`               varchar(45) NOT NULL,
    `ismanager`         tinyint     NOT NULL,
    `iscontractstaff`   tinyint     NOT NULL,
    `contractstartdate` date        DEFAULT NULL,
    `contractenddate`   date        DEFAULT NULL,
    `hotelid`           int         NOT NULL,
    PRIMARY KEY (`staffid`),
    UNIQUE KEY `ssn_UNIQUE` (`ssn`),
    KEY                 `staff_fk_hotel_idx` (`hotelid`),
    CONSTRAINT `staff_fk_hotel` FOREIGN KEY (`hotelid`) REFERENCES `hotel` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `staff`
--

LOCK
TABLES `staff` WRITE;
/*!40000 ALTER TABLE `staff` DISABLE KEYS */;
/*!40000 ALTER TABLE `staff` ENABLE KEYS */;
UNLOCK
TABLES;

--
-- Dumping events for database 'final_project'
--

--
-- Dumping routines for database 'final_project'
--
/*!50003 DROP FUNCTION IF EXISTS `getTotalRoomsAvailableForHotel` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE
DEFINER=`root`@`localhost` FUNCTION `getTotalRoomsAvailableForHotel`(
	hotelIdInput int) RETURNS int
    READS SQL DATA
    DETERMINISTIC
begin
		declare
totalAvailableRooms int default 0;

select sum(availableRooms)
into totalAvailableRooms
from (select hotel.id,
             category as roomCategory,
             (count(roomno) -
              (select count(*)
               from booking
                        inner join rooms using (roomNo)
               where hotel = hotelIdInput
                 and rooms.category = roomCategory))
                      as availableRooms
      from hotel
               inner join rooms on hotel.id = rooms.hotelid
      where hotel.id = hotelIdInput
      group by hotel.id, category) as t;
return totalAvailableRooms;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `createUser` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE
DEFINER=`root`@`localhost` PROCEDURE `createUser`(
	in ssnI varchar(45) ,
    in nameI varchar(45) ,
    in phoneI varchar(45) ,
    in emailI varchar(45) ,
	in ageI int 
    )
begin
insert into customer (ssn, name, phone, email, age)
values (ssnI, nameI, phoneI, emailI, ageI);
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `getAvailableHotels` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE
DEFINER=`root`@`localhost` PROCEDURE `getAvailableHotels`(
    )
begin
select hotel.id,
       getTotalRoomsAvailableForHotel(hotel.id) as totalAvailableRooms,
       hotel.name,
       hotel.phone,
       hotel.email,
       street,
       town,
       state,
       zip,
       avgrating,
       group_concat(amenities.name)             as amenities,
       group_concat(amenities.description)      as amenitiesDescription
from hotel
         inner join amenitiesathotel on hotel.id = amenitiesathotel.hotelid
         inner join amenities on amenities.id = amenitiesathotel.amenityid
group by hotel.id, hotel.name, hotel.phone, hotel.email, street, town, state, zip, avgrating;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `getHotelCategoryWiseAvailability` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE
DEFINER=`root`@`localhost` PROCEDURE `getHotelCategoryWiseAvailability`(in hotelIdInput int)
begin
select hotel.id,
       category as roomCategory,
       (count(roomno) -
        (select count(*)
         from booking
                  inner join rooms using (roomNo)
         where hotel = hotelIdInput
           and rooms.category = roomCategory))
                as availableRooms
from hotel
         inner join rooms on hotel.id = rooms.hotelid
where hotel.id = hotelIdInput
group by hotel.id, category;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `getUserBySSN` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE
DEFINER=`root`@`localhost` PROCEDURE `getUserBySSN`(
	in ssnI varchar(45) )
begin
select *
from customer
where ssn = ssnI;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-11-19 18:38:08
