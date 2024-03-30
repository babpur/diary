-- --------------------------------------------------------
-- 호스트:                          127.0.0.1
-- 서버 버전:                        10.5.24-MariaDB - mariadb.org binary distribution
-- 서버 OS:                        Win64
-- HeidiSQL 버전:                  12.6.0.6765
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- diary 데이터베이스 구조 내보내기
DROP DATABASE IF EXISTS `diary`;
CREATE DATABASE IF NOT EXISTS `diary` /*!40100 DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci */;
USE `diary`;

-- 테이블 diary.comment 구조 내보내기
CREATE TABLE IF NOT EXISTS `comment` (
  `comment_no` int(11) NOT NULL AUTO_INCREMENT,
  `diary_date` date NOT NULL,
  `memo` text NOT NULL,
  `update_date` datetime NOT NULL,
  `create_date` datetime NOT NULL,
  PRIMARY KEY (`comment_no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- 테이블 데이터 diary.comment:~0 rows (대략적) 내보내기
DELETE FROM `comment`;

-- 테이블 diary.diary 구조 내보내기
CREATE TABLE IF NOT EXISTS `diary` (
  `diary_date` date NOT NULL,
  `feeling` varchar(50) NOT NULL,
  `title` text CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `weather` enum('맑음','흐림','비','눈') CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `content` text CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `update_date` datetime NOT NULL,
  `create_date` datetime NOT NULL,
  PRIMARY KEY (`diary_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 테이블 데이터 diary.diary:~2 rows (대략적) 내보내기
DELETE FROM `diary`;
INSERT INTO `diary` (`diary_date`, `feeling`, `title`, `weather`, `content`, `update_date`, `create_date`) VALUES
	('2024-03-28', '😂', '어렵다', '비', '어렵다 어려워', '2024-03-28 22:49:18', '2024-03-28 22:49:18'),
	('2024-03-29', '😂', 'ㅁㄴㅇㅁㄴㅇ', '맑음', 'ㅁㄴㅇㅁㄴㅇ', '2024-03-28 22:39:19', '2024-03-28 22:39:19');

-- 테이블 diary.login 구조 내보내기
CREATE TABLE IF NOT EXISTS `login` (
  `my_session` enum('ON','OFF') NOT NULL,
  `on_date` datetime DEFAULT NULL,
  `off_date` datetime DEFAULT NULL,
  PRIMARY KEY (`my_session`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- 테이블 데이터 diary.login:~1 rows (대략적) 내보내기
DELETE FROM `login`;
INSERT INTO `login` (`my_session`, `on_date`, `off_date`) VALUES
	('ON', '2024-03-28 20:30:07', '2024-03-28 20:23:19');

-- 테이블 diary.lunch 구조 내보내기
CREATE TABLE IF NOT EXISTS `lunch` (
  `lunch_date` date NOT NULL,
  `menu` varchar(50) NOT NULL,
  `update_date` datetime NOT NULL,
  `create_date` datetime NOT NULL,
  PRIMARY KEY (`lunch_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- 테이블 데이터 diary.lunch:~0 rows (대략적) 내보내기
DELETE FROM `lunch`;

-- 테이블 diary.member 구조 내보내기
CREATE TABLE IF NOT EXISTS `member` (
  `member_id` varchar(50) NOT NULL,
  `member_pw` varchar(50) NOT NULL,
  PRIMARY KEY (`member_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- 테이블 데이터 diary.member:~1 rows (대략적) 내보내기
DELETE FROM `member`;
INSERT INTO `member` (`member_id`, `member_pw`) VALUES
	('admin', '1234');

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
