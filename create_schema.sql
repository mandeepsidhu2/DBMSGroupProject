CREATE DATABASE  IF NOT EXISTS `final_project` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `final_project`;
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
CREATE TABLE `amenities` (
                             `name` varchar(15) NOT NULL,
                             `description` varchar(45) DEFAULT NULL,
                             `id` int NOT NULL AUTO_INCREMENT,
                             PRIMARY KEY (`id`),
                             UNIQUE KEY `name_UNIQUE` (`name`),
                             UNIQUE KEY `description_UNIQUE` (`description`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `amenities`
--

LOCK TABLES `amenities` WRITE;
/*!40000 ALTER TABLE `amenities` DISABLE KEYS */;
INSERT INTO `amenities` VALUES ('Swimming pool','Exquisite swimming pool',1),('Heating','Heating available 24*7',2),('Bar','In house bar!',3),('Dining','Best room service!',4);
/*!40000 ALTER TABLE `amenities` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `amenitiesathotel`
--

DROP TABLE IF EXISTS `amenitiesathotel`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `amenitiesathotel` (
                                    `hotelid` int NOT NULL,
                                    `amenityId` int NOT NULL,
                                    PRIMARY KEY (`hotelid`,`amenityId`),
                                    KEY `amenity_fk_idx` (`amenityId`),
                                    CONSTRAINT `a_hotel_fk` FOREIGN KEY (`hotelid`) REFERENCES `hotel` (`id`),
                                    CONSTRAINT `amenity_fk` FOREIGN KEY (`amenityId`) REFERENCES `amenities` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `amenitiesathotel`
--

LOCK TABLES `amenitiesathotel` WRITE;
/*!40000 ALTER TABLE `amenitiesathotel` DISABLE KEYS */;
INSERT INTO `amenitiesathotel` VALUES (1,1),(2,1),(1,2),(1,3),(2,3),(1,4);
/*!40000 ALTER TABLE `amenitiesathotel` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `booking`
--

DROP TABLE IF EXISTS `booking`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `booking` (
                           `customer` int NOT NULL,
                           `bookingId` int NOT NULL AUTO_INCREMENT,
                           `hotel` int NOT NULL,
                           `checkedInByStaffId` int DEFAULT NULL,
                           `isCheckedIn` tinyint NOT NULL DEFAULT '0',
                           `isCheckedOut` tinyint DEFAULT '0',
                           `startDate` datetime NOT NULL,
                           `endDate` datetime NOT NULL,
                           `rating` float DEFAULT NULL,
                           `ratingDescription` varchar(45) DEFAULT NULL,
                           `roomNo` int NOT NULL,
                           `checkedOutByStaffId` int DEFAULT NULL,
                           PRIMARY KEY (`bookingId`,`isCheckedIn`),
                           KEY `customer_fk_idx` (`customer`),
                           KEY `hotel_fk_idx` (`hotel`),
                           KEY `staff_fk_idx` (`checkedInByStaffId`),
                           KEY `room_fk_idx` (`roomNo`),
                           KEY `staff_checkout_fk_idx` (`checkedOutByStaffId`),
                           CONSTRAINT `booking_hotel_fk` FOREIGN KEY (`hotel`) REFERENCES `hotel` (`id`),
                           CONSTRAINT `customer_fk` FOREIGN KEY (`customer`) REFERENCES `customer` (`customer_id`),
                           CONSTRAINT `room_fk` FOREIGN KEY (`roomNo`) REFERENCES `rooms` (`roomNo`),
                           CONSTRAINT `staff_checkin_fk` FOREIGN KEY (`checkedInByStaffId`) REFERENCES `staff` (`staffid`),
                           CONSTRAINT `staff_checkout_fk` FOREIGN KEY (`checkedOutByStaffId`) REFERENCES `staff` (`staffid`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `booking`
--

LOCK TABLES `booking` WRITE;
/*!40000 ALTER TABLE `booking` DISABLE KEYS */;
INSERT INTO `booking` VALUES (1,1,1,1,1,1,'2022-12-09 00:00:00','2022-12-11 00:00:00',NULL,NULL,1,2);
/*!40000 ALTER TABLE `booking` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `bookingCreatedTrigger` AFTER INSERT ON `booking` FOR EACH ROW begin
        insert into booking_log (`action`,bookingId,customerId,hotelId,metaData) values
        ("BOOKING_CREATED",new.bookingId,new.customer,new.hotel,concat("roomNo:",new.roomNo));
    end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `updateHotelAverageRating` AFTER UPDATE ON `booking` FOR EACH ROW begin
		declare bookingRatedCount int default 0;
		declare totalRating float default 0;
		declare hotelIdVar int default -1;
        select new.hotel into hotelIdVar;
        select count(*) into bookingRatedCount from booking where rating is not null and hotel=hotelIdVar;
		select sum(rating) into totalRating from booking where rating is not null  and hotel=hotelIdVar group by hotel;
        if(bookingRatedCount!=0) then
        update hotel set avgrating=(totalRating/bookingRatedCount) where id=hotelIdVar;
        end if;
    end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `bookingUpdatedTrigger` AFTER UPDATE ON `booking` FOR EACH ROW begin
		if new.startDate != old.startDate or new.endDate != old.endDate then
			insert into booking_log (`action`,bookingId,customerId,hotelId,metaData) values
			("BOOKING_UPDATED",new.bookingId,new.customer,new.hotel,
			concat("{'roomNo':",new.roomNo,",","'startDate':",new.startDate,",","'endDate':",new.endDate,"}"));
        end if;
    end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `bookingCheckedInTrigger` AFTER UPDATE ON `booking` FOR EACH ROW begin
    if(new.isCheckedIn = 1 and old.isCheckedIn = 0) then
        insert into booking_log (`action`,bookingId,customerId,hotelId,metaData) values
        ("CHECKED_IN",new.bookingId,new.customer,new.hotel,concat("roomNo:",new.roomNo));
	end if;
    end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `bookingCheckedOutTrigger` AFTER UPDATE ON `booking` FOR EACH ROW begin
    if(new.isCheckedOut = 1 and old.isCheckedOut = 0) then
        insert into booking_log (`action`,bookingId,customerId,hotelId,metaData) values
        ("CHECKED_OUT",new.bookingId,new.customer,new.hotel,concat("roomNo:",new.roomNo));
	end if;
    end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `booking_log`
--

DROP TABLE IF EXISTS `booking_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `booking_log` (
                               `action` enum('BOOKING_CREATED','OCCUPANT_ADDED','OCCUPANT_DELETED','BOOKING_UPDATED','CHECKED_IN','CHECKED_OUT') NOT NULL,
                               `bookingId` int NOT NULL,
                               `customerId` int NOT NULL,
                               `metaData` varchar(100) DEFAULT NULL,
                               `hotelId` int DEFAULT NULL,
                               KEY `fkBooking_idx` (`bookingId`),
                               KEY `fkCustomer_idx` (`customerId`),
                               KEY `fkHotel_idx` (`hotelId`),
                               CONSTRAINT `fkBooking` FOREIGN KEY (`bookingId`) REFERENCES `booking` (`bookingId`),
                               CONSTRAINT `fkCustomer` FOREIGN KEY (`customerId`) REFERENCES `customer` (`customer_id`),
                               CONSTRAINT `fkHotel` FOREIGN KEY (`hotelId`) REFERENCES `hotel` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `booking_log`
--

LOCK TABLES `booking_log` WRITE;
/*!40000 ALTER TABLE `booking_log` DISABLE KEYS */;
INSERT INTO `booking_log` VALUES ('CHECKED_IN',1,1,'roomNo:1',1),('CHECKED_OUT',1,1,'roomNo:1',1);
/*!40000 ALTER TABLE `booking_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customer`
--

DROP TABLE IF EXISTS `customer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customer` (
                            `customer_id` int NOT NULL AUTO_INCREMENT,
                            `ssn` varchar(45) NOT NULL,
                            `name` varchar(45) DEFAULT NULL,
                            `phone` varchar(45) NOT NULL,
                            `email` varchar(45) DEFAULT NULL,
                            `age` int DEFAULT NULL,
                            PRIMARY KEY (`customer_id`),
                            UNIQUE KEY `ssn_UNIQUE` (`ssn`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customer`
--

LOCK TABLES `customer` WRITE;
/*!40000 ALTER TABLE `customer` DISABLE KEYS */;
INSERT INTO `customer` VALUES (1,'SSN58534','Arun','2323232','da@j.com',12),(2,'SSN13987','Pde','kjwn!lmk','238928',13),(3,'SSN82402','Mandora','kdsl@jn.ciom','313981',23),(5,'SSN2929','Paul','mwkjn@jkn.com','3989283',23),(6,'SSN0182398','Laura','la@uwd.com','12793109',42),(7,'SSN12345','Ujwal','uj@g.com','4982977',25);
/*!40000 ALTER TABLE `customer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hotel`
--

DROP TABLE IF EXISTS `hotel`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hotel` (
                         `id` int NOT NULL AUTO_INCREMENT,
                         `name` varchar(45) NOT NULL,
                         `street` varchar(45) DEFAULT NULL,
                         `town` varchar(45) DEFAULT NULL,
                         `state` varchar(2) DEFAULT NULL,
                         `zip` varchar(45) DEFAULT NULL,
                         `avgrating` float DEFAULT NULL,
                         `phone` varchar(20) DEFAULT NULL,
                         `email` varchar(45) DEFAULT NULL,
                         PRIMARY KEY (`id`),
                         UNIQUE KEY `email_UNIQUE` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hotel`
--

LOCK TABLES `hotel` WRITE;
/*!40000 ALTER TABLE `hotel` DISABLE KEYS */;
INSERT INTO `hotel` VALUES (1,'Hotel Plaza','Symphony Street','Truro','MA','02115',4.46667,'+1 656-334-6296','plaza@hmz.com'),(2,'Hotel Banquet','Harrison Street','Truro','MA','02115',0,'+1 616-334-6296','banquet@hmz.com');
/*!40000 ALTER TABLE `hotel` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mytemp`
--

DROP TABLE IF EXISTS `mytemp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mytemp` (
                          `hotelId` int DEFAULT NULL,
                          `category` char(50) DEFAULT NULL,
                          `availability` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mytemp`
--

LOCK TABLES `mytemp` WRITE;
/*!40000 ALTER TABLE `mytemp` DISABLE KEYS */;
/*!40000 ALTER TABLE `mytemp` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `occupant`
--

DROP TABLE IF EXISTS `occupant`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `occupant` (
                            `ssn` varchar(20) NOT NULL,
                            `name` varchar(45) NOT NULL,
                            `age` int DEFAULT NULL,
                            PRIMARY KEY (`ssn`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `occupant`
--

LOCK TABLES `occupant` WRITE;
/*!40000 ALTER TABLE `occupant` DISABLE KEYS */;
/*!40000 ALTER TABLE `occupant` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `occupantsinorder`
--

DROP TABLE IF EXISTS `occupantsinorder`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `occupantsinorder` (
                                    `bookingId` int NOT NULL,
                                    `occuppantSSN` varchar(45) NOT NULL,
                                    PRIMARY KEY (`bookingId`,`occuppantSSN`),
                                    KEY `occupant_ssn_idx` (`occuppantSSN`),
                                    CONSTRAINT `booking_id` FOREIGN KEY (`bookingId`) REFERENCES `booking` (`bookingId`),
                                    CONSTRAINT `occupant_ssn` FOREIGN KEY (`occuppantSSN`) REFERENCES `occupant` (`ssn`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `occupantsinorder`
--

LOCK TABLES `occupantsinorder` WRITE;
/*!40000 ALTER TABLE `occupantsinorder` DISABLE KEYS */;
/*!40000 ALTER TABLE `occupantsinorder` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `occupantCreatedTrigger` AFTER INSERT ON `occupantsinorder` FOR EACH ROW begin
		declare bookingIdVar int default 0;
        declare hotelIdVar int default 0;
		declare customerIdVar int default 0;
		declare occupantNameVar varchar(45) default null;
		declare occupantAgeVar int default 0;

		select booking.bookingId ,booking.hotel,booking.customer,occupant.age,occupant.name into hotelIdVar,bookingIdVar,customerIdVar,occupantAgeVar,occupantNameVar
        from booking inner join occupantsinorder using(bookingId) inner join occupant on occupant.ssn=occupantsinorder.occuppantSSN
        where occupant.ssn=new.occuppantSSN;
        insert into booking_log (`action`,bookingId,customerId,hotelId,metaData) values
        ("OCCUPANT_ADDED",bookingIdVar,customerIdVar,hotelIdVar,
        concat("{'occuppantSSN':",new.occuppantSSN,",","'occupantName':",occupantNameVar,",","'occupantAge':",occupantAgeVar,"}"));
    end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `occupantDeletedTrigger` BEFORE DELETE ON `occupantsinorder` FOR EACH ROW begin
		declare bookingIdVar int default 0;
        declare hotelIdVar int default 0;
		declare customerIdVar int default 0;
		declare occupantNameVar varchar(45) default null;
		declare occupantAgeVar int default 0;

		select booking.bookingId ,booking.hotel,booking.customer,occupant.age,occupant.name into hotelIdVar,bookingIdVar,customerIdVar,occupantAgeVar,occupantNameVar
        from booking inner join occupantsinorder using(bookingId) inner join occupant on occupant.ssn=occupantsinorder.occuppantSSN
        where occupant.ssn=old.occuppantSSN;
        insert into booking_log (`action`,bookingId,customerId,hotelId,metaData) values
        ("OCCUPANT_DELETED",bookingIdVar,customerIdVar,hotelIdVar,
        concat("{'occuppantSSN':",old.occuppantSSN,",","'occupantName':",occupantNameVar,",","'occupantAge':",occupantAgeVar,"}"));
    end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `roomcategory`
--

DROP TABLE IF EXISTS `roomcategory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `roomcategory` (
                                `category` enum('Deluxe','Ultra','Suite') NOT NULL,
                                `hasFridge` tinyint DEFAULT '0',
                                `hasBalcony` tinyint DEFAULT '0',
                                `description` varchar(128) DEFAULT NULL,
                                `hasBathtub` tinyint DEFAULT '0',
                                PRIMARY KEY (`category`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roomcategory`
--

LOCK TABLES `roomcategory` WRITE;
/*!40000 ALTER TABLE `roomcategory` DISABLE KEYS */;
INSERT INTO `roomcategory` VALUES ('Deluxe',1,0,'Enjoy Deluxe previlige, clean rooms with built in fridge',0),('Ultra',1,1,'Enjoy Ultra previlige, clean rooms with a balcony and built in fridge!',0),('Suite',1,1,'Enjoy our best Suite previlige, clean rooms with  a balcony, bathtub and built in fridge',1);
/*!40000 ALTER TABLE `roomcategory` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rooms`
--

DROP TABLE IF EXISTS `rooms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rooms` (
                         `roomNo` int NOT NULL,
                         `hotelId` int NOT NULL,
                         `category` enum('Deluxe','Ultra','Suite') NOT NULL,
                         `floor` int NOT NULL,
                         `capacity` int NOT NULL,
                         PRIMARY KEY (`roomNo`,`hotelId`),
                         KEY `hotel_fk_idx` (`hotelId`),
                         KEY `category_fk_idx` (`category`),
                         CONSTRAINT `category_fk` FOREIGN KEY (`category`) REFERENCES `roomcategory` (`category`),
                         CONSTRAINT `hotel_fk` FOREIGN KEY (`hotelId`) REFERENCES `hotel` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rooms`
--

LOCK TABLES `rooms` WRITE;
/*!40000 ALTER TABLE `rooms` DISABLE KEYS */;
INSERT INTO `rooms` VALUES (1,1,'Deluxe',1,5),(2,1,'Deluxe',1,3),(3,1,'Deluxe',1,3),(4,1,'Deluxe',1,3),(5,1,'Ultra',1,4),(6,1,'Ultra',1,4),(7,1,'Ultra',1,4),(8,2,'Ultra',1,4),(9,2,'Ultra',1,4),(10,2,'Ultra',1,4),(11,2,'Suite',2,4),(12,2,'Suite',2,4),(13,2,'Suite',2,4);
/*!40000 ALTER TABLE `rooms` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `staff`
--

DROP TABLE IF EXISTS `staff`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `staff` (
                         `staffid` int NOT NULL AUTO_INCREMENT,
                         `name` varchar(45) NOT NULL,
                         `phone` varchar(45) NOT NULL,
                         `email` varchar(45) DEFAULT NULL,
                         `ssn` varchar(45) NOT NULL,
                         `ismanager` tinyint NOT NULL,
                         `contractstartdate` date DEFAULT NULL,
                         `contractenddate` date DEFAULT NULL,
                         `hotelid` int NOT NULL,
                         PRIMARY KEY (`staffid`),
                         UNIQUE KEY `ssn_UNIQUE` (`ssn`),
                         KEY `staff_fk_hotel_idx` (`hotelid`),
                         CONSTRAINT `staff_fk_hotel` FOREIGN KEY (`hotelid`) REFERENCES `hotel` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `staff`
--

LOCK TABLES `staff` WRITE;
/*!40000 ALTER TABLE `staff` DISABLE KEYS */;
INSERT INTO `staff` VALUES (1,'Arun','+1767-287-4851','arun@hms.coom','ssn13',0,NULL,NULL,1),(5,'Mandeep','+1767-287-4851','arun@hms.coom','ssn15',1,NULL,NULL,1),(6,'Ujwal','+1767-287-4851','arun@hms.coom','ssn14',1,NULL,NULL,1);
/*!40000 ALTER TABLE `staff` ENABLE KEYS */;
UNLOCK TABLES;

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
CREATE DEFINER=`root`@`localhost` FUNCTION `getTotalRoomsAvailableForHotel`(
	hotelIdInput int,dateInput date) RETURNS int
    READS SQL DATA
    DETERMINISTIC
begin
		declare totalAvailableRooms int default 0;
select  sum(availableRooms) into totalAvailableRooms  from
    (	select hotel.id ,category as roomCategory,(count(roomno) -
                                                    (select count(*) from booking inner join rooms using(roomNo) where hotel=hotelIdInput
                                                                                                                   and dateInput between startDate and endDate
                                                                                                                   and rooms.category=roomCategory))
                                   as availableRooms
         from hotel inner join rooms on hotel.id = rooms.hotelid
         where hotel.id=hotelIdInput group by hotel.id,category) as t;
return totalAvailableRooms;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `addOccupantToBooking` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `addOccupantToBooking`(
	in bookingIdInput int,
	in ssnI varchar(45) ,
    in nameI varchar(45) ,
    in ageI int)
begin
    declare bookedRoomCapacity int default 0;
	declare currentNumberOfOccupants int default 0;
    declare occupantSSNExists varchar(45) default null;
	declare exit handler for SQLEXCEPTION
begin
rollback;
SIGNAL SQLSTATE 'ERR0R' SET MESSAGE_TEXT = 'Unable to create occupant, rolling back transaction';
end;
select capacity into bookedRoomCapacity from booking inner join rooms on  booking.roomNo=rooms.roomno where bookingId=bookingIdInput;
if(bookedRoomCapacity is null) then
		SIGNAL SQLSTATE 'ERR0R' SET MESSAGE_TEXT = 'Invalid booking id has been entered';
end if;
	if(currentNumberOfOccupants = bookedRoomCapacity) then
		SIGNAL SQLSTATE 'ERR0R' SET MESSAGE_TEXT = 'No more occupants can be added to this room type';
end if;

start transaction;
-- todo check if occupant already exists
select ssn into occupantSSNExists from occupant where ssn=ssnI;
if(occupantSSNExists is null) then
        		insert into occupant (ssn,name,age) values (ssnI,nameI,ageI);
end if;
insert into occupantsinorder (bookingId,occuppantSSN) values (bookingIdInput,ssnI);
commit;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `addRatingForBooking` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `addRatingForBooking`(
	in bookingIdInput int,
	in ratingInput float
	)
begin

	   declare isCheckedOurVar int default -1;
select isCheckedOut into  isCheckedOurVar from booking where bookingId=bookingIdInput;
if(isCheckedOurVar=-1) then
       			SIGNAL SQLSTATE 'ERR0R' SET MESSAGE_TEXT = 'Booking not found';
end if;
		if(isCheckedOurVar=0) then
       			SIGNAL SQLSTATE 'ERR0R' SET MESSAGE_TEXT = 'Booking has to be in checked out status to mark rating';
end if;
       if(ratingInput < 0 or ratingInput >5) then
				SIGNAL SQLSTATE 'ERR0R' SET MESSAGE_TEXT = 'Rating has to be between 0 and 5';
end if;
update booking set rating=ratingInput where bookingId=bookingIdInput;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `checkinBooking` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkinBooking`(
	in bookingIdInput int,
    in staffIdInput int)
begin
	   declare isCheckedInVar int default -1;
	   declare isCheckedOutVar int default -1;
select isCheckedIn,isCheckedOut into isCheckedInVar,isCheckedOutVar from booking where bookingId = bookingIdInput;
if( isCheckedInVar =-1 or isCheckedOutVar =-1) then
       			SIGNAL SQLSTATE 'ERR0R' SET MESSAGE_TEXT = 'Booking not found';
end if;
	  if( isCheckedInVar =1 or isCheckedOutVar =1) then
       			SIGNAL SQLSTATE 'ERR0R' SET MESSAGE_TEXT = 'Invalid action, booking already checked in/out';
end if;
update booking set isCheckedIn=1 ,checkedInByStaffId=staffIdInput where bookingId=bookingIdInput;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `checkoutBooking` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkoutBooking`(
	in bookingIdInput int,
       in staffIdInput int)
begin
	   declare isCheckedInVar int default -1;
	   declare isCheckedOutVar int default -1;
select isCheckedIn,isCheckedOut into isCheckedInVar,isCheckedOutVar from booking where bookingId = bookingIdInput;
if( isCheckedInVar =-1 or isCheckedOutVar =-1) then
       			SIGNAL SQLSTATE 'ERR0R' SET MESSAGE_TEXT = 'Booking not found';
end if;
	  if( isCheckedInVar !=1 ) then
       			SIGNAL SQLSTATE 'ERR0R' SET MESSAGE_TEXT = 'Invalid action, booking is not checked in';
end if;

		if( isCheckedOutVar =1 ) then
       			SIGNAL SQLSTATE 'ERR0R' SET MESSAGE_TEXT = 'Invalid action, booking is already checked out';
end if;

update booking set isCheckedOut=1,checkedOutByStaffId=staffIdInput where bookingId=bookingIdInput;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `createBooking` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `createBooking`(
in hotelIdInput int,
in customerIdInput int,
in startDateInput date,
in endDateInput date,
in roomCategory char(50),
in roomNoInput int
)
begin
    -- check if room no and hotel id is valid

	   declare countOfRoomsWithGivenInfo int default 0;
	   declare bookingsCountOfRoomNoWithinStartAndEndDate int default 0;
	   declare availableRoomNo int default roomNoInput;

       if(datediff(startDateInput, curdate())< 0 ) then
				SIGNAL SQLSTATE 'ERR0R' SET MESSAGE_TEXT = 'Booking has to be made in future or for today';
end if;

       if(datediff(endDateInput,startDateInput)< 1 ) then
				SIGNAL SQLSTATE 'ERR0R' SET MESSAGE_TEXT = 'You have to book a room for atleast a day';
end if;

        if(roomNoInput is not null) then -- check for other bookings of the same room if booking is to be made for a specific room

select count(*) into countOfRoomsWithGivenInfo  from rooms
                                                         inner join hotel on hotel.id=rooms.hotelid where hotelid=hotelIdInput and roomno=roomNoINput;

if (countOfRoomsWithGivenInfo !=1) then
					SIGNAL SQLSTATE 'ERR0R' SET MESSAGE_TEXT = 'Hotel and room id combination is invalid';
end if;

select count(*) into bookingsCountOfRoomNoWithinStartAndEndDate from booking where (endDate between
                                                                                        startDateInput and endDateInput or startDate between startDateInput and endDateInput)
                                                                               and hotel=hotelIdInput and roomNo=roomNoInput;
if(bookingsCountOfRoomNoWithinStartAndEndDate!=0) then
				SIGNAL SQLSTATE 'ERR0R' SET MESSAGE_TEXT = 'Room already booked in the requested date frame';
end if;
else -- choise first available room, if a specific room was not requested by the function call
select roomNo into availableRoomNo from rooms where rooms.hotelid=hotelIdInput and rooms.category=roomCategory and not exists(
        select * from booking where roomNo=rooms.roomNo and (endDate between
                                                                 startDateInput and endDateInput or startDate between startDateInput and endDateInput)
    ) limit 1;

if(availableRoomNo is null) then
				SIGNAL SQLSTATE 'ERR0R' SET MESSAGE_TEXT = 'No room is found, please try again';
end if;

end if;

insert into booking (customer,hotel,startDate,endDate,roomNo) values (customerIdInput,hotelIdInput,startDateInput,endDateInput,availableRoomNo);
select bookingId from booking where customer=customerIdInput and hotel=hotelIdInput and startDate=startDateInput
                                and endDate=endDateInput and roomNo=availableRoomNo;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `createStaff` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `createStaff`(
	in nameInput varchar(45),
    in phoneInput varchar(45),
    in emailInput varchar(45),
	in ssnInput varchar(45),
	in ismanagerInput tinyint,
    in contractStartDateInput date,
	in contractEndDateInput date,
	in hotelidInput int
    )
begin
insert into staff (name,phone,email,ssn,ismanager,contractstartdate,contractenddate,hotelid)
values
    (nameInput,phoneInput,emailInput,ssnInput,ismanagerInput,contractStartDateInput,contractEndDateInput,hotelidInput);
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
CREATE DEFINER=`root`@`localhost` PROCEDURE `createUser`(
	in ssnI varchar(45) ,
    in nameI varchar(45) ,
    in phoneI varchar(45) ,
    in emailI varchar(45) ,
	in ageI int
    )
begin
insert into customer (ssn,name,phone,email,age) values(ssnI,nameI,phoneI,emailI,ageI);
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `deleteBooking` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteBooking`(in bookingIdIn int)
begin
		declare isCheckedInVar int default 0;
	   declare isCheckedOurVar int default 0;
       declare bookingIdVar int default -1;

select bookingId,isCheckedIn,isCheckedOut into bookingIdVar,isCheckedInVar, isCheckedOurVar from
    booking where bookingId=bookingIdIn;
if(bookingIdVar = -1) then
			SIGNAL SQLSTATE 'ERR0R' SET MESSAGE_TEXT = 'Booking not found';
end if;
       if(isCheckedInVar or isCheckedOurVar) then
       SIGNAL SQLSTATE 'ERR0R' SET MESSAGE_TEXT = 'Booking is checked in/out, cannot modify';
end if;
delete from booking where bookingId=bookingIdIn;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `deleteOccupantFromBooking` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteOccupantFromBooking`(in ssnI varchar(45),in bookingIdI int)
begin
	declare occupantBookingCount int default 0;
	declare exit handler for SQLEXCEPTION
begin
rollback;
SIGNAL SQLSTATE 'ERR0R' SET MESSAGE_TEXT = 'Unable to delete occupant from booking';
end;
start transaction;
select count(*) into  occupantBookingCount from occupantsinorder where occuppantSSN=ssnI;
delete from occupantsinorder where occuppantSSN=ssnI;
if(occupantBookingCount = 0) then
			SIGNAL SQLSTATE 'ERR0R' SET MESSAGE_TEXT = 'Occupant not found';
end if;
        if (occupantBookingCount = 1) then
delete from occupant where ssn=ssnI;
end if;
commit;
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
CREATE DEFINER=`root`@`localhost` PROCEDURE `getAvailableHotels`(
		in  dateInput date
    )
begin
select hotel.id,hotel.name,hotel.phone,hotel.email,street,town,state,getTotalRoomsAvailableForHotel(hotel.id,dateInput) as totalAvailableRooms,
       zip,avgrating,group_concat(amenities.name) as amenities,group_concat(amenities.description) as amenitiesDescription from hotel
                                                                                                                                    inner join amenitiesathotel on hotel.id=amenitiesathotel.hotelid
                                                                                                                                    inner join amenities on amenities.id=amenitiesathotel.amenityid
group by hotel.id,hotel.name,hotel.phone,hotel.email,street,town,state,zip,avgrating;
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
CREATE DEFINER=`root`@`localhost` PROCEDURE `getHotelCategoryWiseAvailability`(in hotelIdInput int,in reqStartDate date,in reqEndDate date)
begin
		if(datediff(reqEndDate,reqStartDate)< 1 ) then
				SIGNAL SQLSTATE 'ERR0R' SET MESSAGE_TEXT = 'Enter days atleast 1 day apart';
end if;

select hotel.id ,category as roomCategory,(count(roomno) -
                                           (select count(*) from booking inner join rooms using(roomNo) where hotel=hotelIdInput
                                                                                                          and (
                                                       reqStartDate between startDate and endDate
                                                       or
                                                       reqEndDate between startDate and endDate
                                                   )

                                                                                                          and rooms.category=roomCategory))
                          as availableRooms
from hotel inner join rooms on hotel.id = rooms.hotelid
where hotel.id=hotelIdInput group by hotel.id,category;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `getOccupantDetailsForBooking` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `getOccupantDetailsForBooking`(in bookingIdIn int)
begin
select * from occupantsinorder inner join occupant on occupant.ssn=occupantsinorder.occuppantSSN where bookingid=bookingIdIn;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `getTotalRoomsAvailableForHotel` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `getTotalRoomsAvailableForHotel`(in hotelIdInput int,in dateInput date)
begin

       -- select hotelCate;
       -- declare row_not_found tinyint default false;
		-- create  table mytemp (hotelId int,category char(50)   ,availability int );
       --  INSERT INTO mytemp

call getHotelCategoryWiseAvailability(1,CURDATE()) ;

select * from mytemp;

end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `getUserBookings` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `getUserBookings`(in customerId int)
begin
select * from booking  inner join hotel on hotel.id = booking.hotel where customer=customerId;
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
CREATE DEFINER=`root`@`localhost` PROCEDURE `getUserBySSN`(
	in ssnI varchar(45) )
begin
select * from customer where ssn =ssnI;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `updateBooking` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateBooking`(
	in startDateInput date,
	in endDateInput date,
    in bookingIdInput int
	)
begin
	   declare isCheckedInVar int default 0;
	   declare isCheckedOurVar int default 0;
	   declare roomNoBooked int default -1;
		declare bookingIdVar int default -1;
	   declare conflictingBookings int default -1;

select bookingId,isCheckedIn,isCheckedOut,roomNo into bookingIdVar,isCheckedInVar, isCheckedOurVar,roomNoBooked from
    booking where bookingId=bookingIdInput;

if(bookingIdVar = -1) then
			SIGNAL SQLSTATE 'ERR0R' SET MESSAGE_TEXT = 'Booking not found';
end if;

select count(*) into conflictingBookings from booking where bookingId!=bookingIdInput
       and roomNo=roomNoBooked and ((startDate between startDateInput
       and endDateInput) or (endDate between startDateInput and endDateInput));

if(conflictingBookings>0) then
       SIGNAL SQLSTATE 'ERR0R' SET MESSAGE_TEXT = 'Sorry, room already booked for these dates';
end if;

       if(isCheckedInVar or isCheckedOurVar) then
       SIGNAL SQLSTATE 'ERR0R' SET MESSAGE_TEXT = 'Booking is checked in/out, cannot modify';
end if;

       if(datediff(startDateInput, curdate())< 0 ) then
				SIGNAL SQLSTATE 'ERR0R' SET MESSAGE_TEXT = 'Booking has to be made in future or for today';
end if;

       if(datediff(endDateInput,startDateInput)< 1 ) then
				SIGNAL SQLSTATE 'ERR0R' SET MESSAGE_TEXT = 'You have to book a room for atleast a day';
end if;
update booking set startDate=startDateInput , endDate=endDateInput where bookingId=bookingIdInput;
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

-- Dump completed on 2022-12-02 20:13:20
