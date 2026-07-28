/*M!999999\- enable the sandbox mode */ 
-- MariaDB dump 10.19  Distrib 10.11.14-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: ps_db
-- ------------------------------------------------------
-- Server version	10.11.14-MariaDB-0ubuntu0.24.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `cart`
--

DROP TABLE IF EXISTS `cart`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `cart` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `nama_makanan` varchar(255) DEFAULT NULL,
  `harga` int(11) DEFAULT NULL,
  `jumlah` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `cart_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cart`
--

LOCK TABLES `cart` WRITE;
/*!40000 ALTER TABLE `cart` DISABLE KEYS */;
/*!40000 ALTER TABLE `cart` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `chats`
--

DROP TABLE IF EXISTS `chats`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `chats` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `is_admin` int(11) DEFAULT NULL,
  `message` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `chats_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `chats`
--

LOCK TABLES `chats` WRITE;
/*!40000 ALTER TABLE `chats` DISABLE KEYS */;
/*!40000 ALTER TABLE `chats` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `menus`
--

DROP TABLE IF EXISTS `menus`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `menus` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nama` varchar(255) NOT NULL,
  `kategori` varchar(100) NOT NULL,
  `harga` int(11) NOT NULL,
  `rating` varchar(10) DEFAULT '4.5',
  `image` varchar(255) NOT NULL,
  `deskripsi` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=61 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `menus`
--

LOCK TABLES `menus` WRITE;
/*!40000 ALTER TABLE `menus` DISABLE KEYS */;
INSERT INTO `menus` VALUES
(1,'Nasi Ponggol Setan Spesial','Terlaris',15000,'4.9','uploads/menus/ponggol.jpg','Nasi Ponggol dengan sambal setan ekstra pedas dan telur dadar.','2026-07-31 18:33:09'),
(2,'Nasi Ponggol Ayam Suwir','Terlaris',18000,'4.8','uploads/menus/ayam.jpg','Perpaduan nasi ponggol dengan ayam suwir bumbu bali yang meresap.','2026-07-31 18:33:09'),
(3,'Nasi Ponggol Telur Puyuh','Terlaris',14000,'4.7','uploads/menus/ponggol.jpg','Menu favorit dengan tambahan sate telur puyuh kecap.','2026-07-31 18:33:09'),
(4,'Ponggol Setan Orek Tempe Kering','Terlaris',12000,'4.8','uploads/menus/ponggol.jpg','Klasik khas Tegal dengan orek tempe super renyah dan sambal pedas.','2026-07-31 18:33:09'),
(5,'Nasi Ponggol Sate Kikil','Terlaris',16000,'4.9','uploads/menus/ponggol.jpg','Kikil sapi empuk bumbu kuning melengkapi hidangan ponggol.','2026-07-31 18:33:09'),
(6,'Nasi Ponggol Balado Teri','Terlaris',15000,'4.7','uploads/menus/ponggol.jpg','Ponggol dengan taburan teri medan balado yang gurih.','2026-07-31 18:33:09'),
(7,'Nasi Ponggol Paru Mercon','Terlaris',20000,'4.9','uploads/menus/ponggol.jpg','Bagi pecinta ekstrem, paru mercon super pedas siap meledak di mulut.','2026-07-31 18:33:09'),
(8,'Paket Ponggol Setan Komplit','Terlaris',25000,'5.0','uploads/menus/ponggol.jpg','Nasi, tempe, telur dadar, ayam suwir, dan sambal porsi jumbo.','2026-07-31 18:33:09'),
(9,'Nasi Ponggol Cumi Asin','Terlaris',22000,'4.8','uploads/menus/ponggol.jpg','Gurihnya cumi asin cabai ijo dipadu nasi pulen khas Ponggol.','2026-07-31 18:33:09'),
(10,'Ponggol Setan Ati Ampela','Terlaris',17000,'4.6','uploads/menus/ponggol.jpg','Sate ati ampela pedas manis teman sejati nasi ponggol.','2026-07-31 18:33:09'),
(11,'Ayam Goreng Bawang','Lauk',10000,'4.8','uploads/menus/ayam.jpg','Ayam goreng rempah dengan taburan bawang putih krispi.','2026-07-31 18:33:09'),
(12,'Telur Dadar Crispy','Lauk',5000,'4.7','uploads/menus/telur.jpg','Telur dadar khas warkop yang digoreng garing pinggirannya.','2026-07-31 18:33:09'),
(13,'Sate Usus Bumbu Kuning','Lauk',3000,'4.6','uploads/menus/sate.jpg','Usus ayam bersih dimasak kuning gurih.','2026-07-31 18:33:09'),
(14,'Sate Telur Puyuh Kecap','Lauk',4000,'4.8','uploads/menus/telur.jpg','Telur puyuh bumbu kecap manis legit isi 4 butir.','2026-07-31 18:33:09'),
(15,'Orek Tempe Basah','Lauk',4000,'4.7','uploads/menus/tempe.jpg','Orek tempe bumbu kecap pedas manis porsi ekstra.','2026-07-31 18:33:09'),
(16,'Perkedel Kentang Kornet','Lauk',5000,'4.9','uploads/menus/default.jpg','Perkedel kentang padat dengan isian kornet sapi.','2026-07-31 18:33:09'),
(17,'Gorengan Bakwan Jagung','Lauk',2500,'4.8','uploads/menus/bakwan.jpg','Bakwan jagung manis digoreng dadakan.','2026-07-31 18:33:09'),
(18,'Tahu Isi Sayur Pedas','Lauk',3000,'4.5','uploads/menus/tahu.jpg','Tahu isi tauge dan wortel dengan irisan cabai rawit.','2026-07-31 18:33:09'),
(19,'Ikan Tongkol Balado','Lauk',8000,'4.7','uploads/menus/tongkol.jpg','Irisan ikan tongkol segar berbumbu merah merona.','2026-07-31 18:33:09'),
(20,'Kikil Mercon','Lauk',8000,'4.9','uploads/menus/kikil.jpg','Kikil potong dadu dengan sambal super pedas.','2026-07-31 18:33:09'),
(21,'Nasi Ponggol Gila Pedas','Pedas',18000,'4.9','uploads/menus/ponggol.jpg','Varian dengan level kepedasan maksimum dari Nasi Ponggol biasa.','2026-07-31 18:33:09'),
(22,'Mie Nyemek Setan','Pedas',15000,'4.8','uploads/menus/mie.jpg','Mie instan rebus kuah kental dengan sambal setan khas Ponggol.','2026-07-31 18:33:09'),
(23,'Ceker Mercon Kuah','Pedas',12000,'4.7','uploads/menus/ceker.jpg','Ceker ayam presto super empuk berkuah cabai merah pedas gila.','2026-07-31 18:33:09'),
(24,'Bakso Pentol Mercon','Pedas',10000,'4.8','uploads/menus/bakso.jpg','Bakso daging sapi kecil-kecil yang dilumuri sambal mercon.','2026-07-31 18:33:09'),
(25,'Oseng Mercon Daging','Pedas',22000,'4.9','uploads/menus/default.jpg','Tetelan sapi dimasak oseng mercon khas Jogja x Tegal.','2026-07-31 18:33:09'),
(26,'Ayam Geprek Setan','Pedas',16000,'4.6','uploads/menus/ayam.jpg','Ayam krispi digeprek hancur bersama sambal bawang setan.','2026-07-31 18:33:09'),
(27,'Seblak Seafood Pedas','Pedas',18000,'4.7','uploads/menus/seblak.jpg','Seblak kuah merah menyala dengan toping cumi dan kerang.','2026-07-31 18:33:09'),
(28,'Tahu Gejrot Tegal','Pedas',8000,'4.5','uploads/menus/tahu.jpg','Tahu pong disiram kuah asam pedas manis rawit melimpah.','2026-07-31 18:33:09'),
(29,'Makaroni Bantet Pedas Daun Jeruk','Pedas',5000,'4.6','uploads/menus/jeruk.jpg','Cemilan makaroni renyah bumbu tabur pedas wangi daun jeruk.','2026-07-31 18:33:09'),
(30,'Nasi Bakar Tongkol Pedas','Pedas',15000,'4.8','uploads/menus/tongkol.jpg','Nasi bakar aroma kemangi dengan isian tongkol suwir pedas.','2026-07-31 18:33:09'),
(31,'Lontong Opor Ayam Kampung','Opor',25000,'4.9','uploads/menus/ayam.jpg','Lontong dengan ayam kampung empuk kuah santan kuning.','2026-07-31 18:33:09'),
(32,'Nasi Opor Ayam Potong','Opor',18000,'4.8','uploads/menus/ayam.jpg','Nasi putih hangat disiram kuah opor legit.','2026-07-31 18:33:09'),
(33,'Opor Telur Bulat','Opor',8000,'4.7','uploads/menus/telur.jpg','Telur rebus dalam kuah opor santan kental.','2026-07-31 18:33:09'),
(34,'Opor Tahu Tempe','Opor',6000,'4.5','uploads/menus/tempe.jpg','Tahu tempe putih berenang di kuah opor.','2026-07-31 18:33:09'),
(35,'Opor Ati Ampela Spesial','Opor',10000,'4.6','uploads/menus/opor.jpg','Ati ampela direbus perlahan bersama bumbu opor medok.','2026-07-31 18:33:09'),
(36,'Lontong Sayur Opor','Opor',15000,'4.8','uploads/menus/opor.jpg','Paduan lontong, sayur labu siam, dan kuah opor.','2026-07-31 18:33:09'),
(37,'Opor Ceker Ayam','Opor',10000,'4.7','uploads/menus/ayam.jpg','Ceker lumer dimulut dengan balutan bumbu santan kuning.','2026-07-31 18:33:09'),
(38,'Opor Ayam Suwir','Opor',12000,'4.5','uploads/menus/ayam.jpg','Tanpa tulang, mudah disantap dengan nasi atau lontong.','2026-07-31 18:33:09'),
(39,'Ketupat Opor Lebaran','Opor',20000,'5.0','uploads/menus/opor.jpg','Menu edisi spesial ketupat asli janur dengan opor komplit.','2026-07-31 18:33:09'),
(40,'Kuah Opor Ekstra','Opor',3000,'4.9','uploads/menus/opor.jpg','Hanya kuah opor kental untuk tambahan siraman nasi Ponggol.','2026-07-31 18:33:09'),
(41,'Es Teh Manis Jumbo','Minuman',5000,'4.8','uploads/menus/teh.jpg','Es teh kental wangi melati porsi gelas besar.','2026-07-31 18:33:09'),
(42,'Es Jeruk Peras Murni','Minuman',8000,'4.9','uploads/menus/jeruk.jpg','Perasan jeruk asli segar pelepas dahaga pedas.','2026-07-31 18:33:09'),
(43,'Es Kopi Susu Tegal','Minuman',12000,'4.8','uploads/menus/kopi.jpg','Kopi hitam lokal campur susu kental manis dingin.','2026-07-31 18:33:09'),
(44,'Air Mineral Dingin','Minuman',4000,'4.5','uploads/menus/air.jpg','Air mineral 600ml super dingin dari kulkas.','2026-07-31 18:33:09'),
(45,'Teh Botol Sosro Dingin','Minuman',6000,'4.7','uploads/menus/teh.jpg','Teh kemasan botol kaca favorit legendaris.','2026-07-31 18:33:09'),
(46,'Nutrisari Jeruk Es','Minuman',5000,'4.6','uploads/menus/jeruk.jpg','Minuman serbuk rasa jeruk nipis dan sweet orange blended.','2026-07-31 18:33:09'),
(47,'Kopi Hitam Panas (Poci)','Minuman',8000,'4.9','uploads/menus/kopi.jpg','Teh poci gula batu / Kopi murni Tegal diseduh mendidih.','2026-07-31 18:33:09'),
(48,'Es Cincau Susu Gula Aren','Minuman',10000,'4.8','uploads/menus/cincau.jpg','Cincau hitam lembut disiram susu evaporasi dan aren.','2026-07-31 18:33:09'),
(49,'Susu Soda Gembira','Minuman',12000,'4.7','uploads/menus/soda.jpg','Fanta merah dicampur kental manis penuh es batu.','2026-07-31 18:33:09'),
(50,'Lemon Tea Mint Dingin','Minuman',9000,'4.8','uploads/menus/default.jpg','Teh rasa lemon asli dengan sensasi daun mint penurun panas perut.','2026-07-31 18:33:09'),
(51,'Kerupuk Bawang (Isi 3)','Pendamping',3000,'4.8','uploads/menus/kerupuk.jpg','Kerupuk putih keriting rasa bawang renyah.','2026-07-31 18:33:09'),
(52,'Kerupuk Kulit Sapi (Rambak)','Pendamping',6000,'4.9','uploads/menus/kerupuk.jpg','Rambak asli gurih krispi cocok dicocol kuah opor.','2026-07-31 18:33:09'),
(53,'Emping Melinjo Asli','Pendamping',7000,'4.8','uploads/menus/emping.jpg','Emping renyah berbalut sedikit garam gurih.','2026-07-31 18:33:09'),
(54,'Rempeyek Kacang','Pendamping',5000,'4.7','uploads/menus/rempeyek.jpg','Peyek kacang tanah tipis garing beraroma daun jeruk.','2026-07-31 18:33:09'),
(55,'Rempeyek Rebon Teri','Pendamping',5000,'4.6','uploads/menus/teri.jpg','Rempeyek bertabur rebon laut yang asin gurih.','2026-07-31 18:33:09'),
(56,'Sambal Terasi Ekstra','Pendamping',3000,'4.9','uploads/menus/sambal.jpg','Bungkus kecil ekstra sambal terasi matang pedas nendang.','2026-07-31 18:33:09'),
(57,'Bawang Goreng Tabur','Pendamping',2000,'4.8','uploads/menus/default.jpg','Tambahan bawang goreng sumenep asli wangi.','2026-07-31 18:33:09'),
(58,'Acar Timun Wortel Nanas','Pendamping',3000,'4.5','uploads/menus/acar.jpg','Acar penyegar rasa untuk penawar pedas dan lemak.','2026-07-31 18:33:09'),
(59,'Gorengan Tempe Mendoan','Pendamping',2500,'4.8','uploads/menus/tempe.jpg','Tempe mendoan setengah matang khas Tegal/Purwokerto.','2026-07-31 18:33:09'),
(60,'Tahu Crispy Tepung','Pendamping',5000,'4.7','uploads/menus/tahu.jpg','Satu porsi isi 5 potong tahu dadu goreng tepung renyah.','2026-07-31 18:33:09');
/*!40000 ALTER TABLE `menus` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_details`
--

DROP TABLE IF EXISTS `order_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_details` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `order_id` int(11) NOT NULL,
  `nama_makanan` varchar(255) NOT NULL,
  `harga` int(11) NOT NULL,
  `jumlah` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `order_id` (`order_id`),
  CONSTRAINT `order_details_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_details`
--

LOCK TABLES `order_details` WRITE;
/*!40000 ALTER TABLE `order_details` DISABLE KEYS */;
INSERT INTO `order_details` VALUES
(1,1,'Tahu Crispy Tepung',5000,1),
(2,1,'Gorengan Tempe Mendoan',2500,1),
(3,2,'Tahu Crispy Tepung',5000,1),
(4,2,'Gorengan Tempe Mendoan',2500,1),
(5,2,'Ponggol Setan Ati Ampela',17000,1);
/*!40000 ALTER TABLE `order_details` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `orders` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `nama_penerima` varchar(100) NOT NULL,
  `phone_penerima` varchar(20) NOT NULL,
  `gps_location` varchar(255) NOT NULL,
  `payment_method` varchar(50) NOT NULL,
  `payment_proof` varchar(255) DEFAULT NULL,
  `total_harga` int(11) NOT NULL,
  `status` varchar(20) DEFAULT 'Menunggu',
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
INSERT INTO `orders` VALUES
(1,2,'irsyad ','085865826621','7C27+FM7, Wedomartani, Kecamatan Ngemplak','E-Wallet (OVO/GoPay/Dana)',NULL,7500,'Selesai','2026-07-31 18:50:22'),
(2,2,'adam','085865826621','7C27+HMH, Wedomartani, Kecamatan Ngemplak','Transfer Bank','1785525365_176543.jpg',24500,'Diproses','2026-07-31 19:16:05');
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nama` varchar(100) NOT NULL,
  `phone` varchar(20) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `role` varchar(20) DEFAULT 'user',
  `profile_pic` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES
(1,'Administrator','081234567890','admin@gmail.com','$2y$10$DvcTFizvAixKYtBryMdNr.oN5GXPfxOL.JFzrZrswIvwOF1wHHcLi','2026-07-31 18:35:25','admin',NULL),
(2,'Pelanggan Setia','089876543210','customer@gmail.com','$2y$10$FtQPvy/FkzJMhBPBnsLvl.iby.Fe9dgjBTHkaDMF2RSFdjwrmOe4u','2026-07-31 18:35:25','user',NULL);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-08-01  3:23:42
