DROP DATABASE IF EXISTS Testing_System_Assignment_1 ;
CREATE DATABASE Testing_System_Assignment_1;
USE `Testing_System_Assignment_1`;

DROP TABLE IF EXISTS `Department`;
CREATE TABLE `Department`(
	`DepartmentID` 				TINYINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    `DepartmentName` 			VARCHAR(50) NOT NULL UNIQUE KEY
);

DROP TABLE IF EXISTS `Position`;
CREATE TABLE `Position`(
	`PositionID` 				TINYINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    `PositionName` 				ENUM('Dev', 'Tes', 'Scrum Master', 'PM') NOT NULL UNIQUE KEY
);

DROP TABLE IF EXISTS `Account`;
CREATE TABLE `Account`(
	`AccountID` 				INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    `Email`						VARCHAR(50) NOT NULL UNIQUE KEY,
    `Username`					VARCHAR(30) NOT NULL UNIQUE KEY,
    `Fullname`					VARCHAR(30) NOT NULL,
    `DepartmentID`				TINYINT UNSIGNED NOT NULL,
    `PositionID`				TINYINT UNSIGNED NOT NULL,
    `CreateDate`				DATETIME DEFAULT NOW(),
	CONSTRAINT FOREIGN KEY(`DepartmentID`) REFERENCES Department(`DepartmentID`),
    CONSTRAINT FOREIGN KEY(`PositionID`) 	REFERENCES `Position`(`PositionID`)
);

DROP TABLE IF EXISTS `Group`;
CREATE TABLE `Group`(
	`GroupID` 					TINYINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    `GroupName` 				VARCHAR(70) UNIQUE KEY,
    `CreatorID` 				INT UNSIGNED,
    `CreateDate` 				DATETIME DEFAULT NOW(),
    FOREIGN KEY(`CreatorID`) 	REFERENCES Account(`AccountID`)
);

DROP TABLE IF EXISTS `GroupAccount`;
CREATE TABLE `GroupAccount`(
	`GroupID` 					TINYINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    `AccountID` 				INT UNSIGNED NOT NULL,
    `JoinDate` 					DATETIME DEFAULT NOW(),
    FOREIGN KEY(`AccountID`) 	REFERENCES Account(`AccountID`)
);

DROP TABLE IF EXISTS `TypeQuestion`;
CREATE TABLE `TypeQuestion`(
	`TypeID` 					INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    `TypeName` 					ENUM('Essay', 'Multiple-Choice') NOT NULL
);

DROP TABLE IF EXISTS `CategoryQuestion`;
CREATE TABLE `CategoryQuestion`(
	`CategoryID` 				INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    `CategoryName` 				ENUM('Java', '.NET', 'SQL', 'POSTMAN', 'Ruby') NOT NULL
);

DROP TABLE IF EXISTS `Question`;
CREATE TABLE `Question`(
	`QuestionID` 				INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    `Content` 					VARCHAR(100) NOT NULL,
    `CategoryID` 				INT UNSIGNED NOT NULL,
    `TypeID` 					INT UNSIGNED NOT NULL,
    `CreatorID` 				INT UNSIGNED NOT NULL,
    `CreateDate` 				DATETIME DEFAULT NOW(),
    FOREIGN KEY(`CategoryID`) 	REFERENCES CategoryQuestion(`CategoryID`),
    FOREIGN KEY(`TypeID`) 		REFERENCES TypeQuestion(`TypeID`),
    FOREIGN KEY(`CreatorID`) 	REFERENCES Account(`AccountID`)
);

DROP TABLE IF EXISTS `Answer`;
CREATE TABLE `Answer`(
	`AnswerID` 					INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    `Content` 					VARCHAR(100) NOT NULL,
    `QuestionID` 				INT UNSIGNED NOT NULL,
    `isCorrect` 				ENUM('1','0') NOT NULL,
    CONSTRAINT FOREIGN KEY(`QuestionID`) 	REFERENCES Question(`QuestionID`)
);

DROP TABLE IF EXISTS `Exam`;
CREATE TABLE `Exam`(
	`ExamID` 					INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    `Code` 						VARCHAR(20) NOT NULL,
    `Title` 					VARCHAR(50) NOT NULL,
    `CategoryID` 				INT UNSIGNED NOT NULL,
    `Duration` 					TINYINT UNSIGNED NOT NULL,
    `CreatorID` 				INT UNSIGNED NOT NULL,
    `CreateDate` 				DATETIME DEFAULT NOW(),
     FOREIGN KEY(`CategoryID`) 	REFERENCES CategoryQuestion(`CategoryID`),
     FOREIGN KEY(`CreatorID`)	REFERENCES Account(`AccountID`)
);

DROP TABLE IF EXISTS `ExamQuestion`;
CREATE TABLE `ExamQuestion`(
	`ExamID` 					INT UNSIGNED NOT NULL,
    `QuestionID` 				INT UNSIGNED NOT NULL,
    FOREIGN KEY(`ExamID`) 		REFERENCES Exam(`ExamID`),
	FOREIGN KEY(`QuestionID`) 	REFERENCES Question(`QuestionID`),
    PRIMARY KEY(`ExamID`, `QuestionID`)
);
