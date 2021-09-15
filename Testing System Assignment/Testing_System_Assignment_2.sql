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
    CONSTRAINT FOREIGN KEY(`CreatorID`) 	REFERENCES Account(`AccountID`)
);

DROP TABLE IF EXISTS `GroupAccount`;
CREATE TABLE `GroupAccount`(
	`GroupID` 					TINYINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    `AccountID` 				INT UNSIGNED NOT NULL,
    `JoinDate` 					DATETIME DEFAULT NOW(),
    CONSTRAINT FOREIGN KEY(`AccountID`) 	REFERENCES Account(`AccountID`)
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
    CONSTRAINT FOREIGN KEY(`CategoryID`) 	REFERENCES CategoryQuestion(`CategoryID`),
    CONSTRAINT FOREIGN KEY(`TypeID`) 		REFERENCES TypeQuestion(`TypeID`),
    CONSTRAINT FOREIGN KEY(`CreatorID`) 	REFERENCES Account(`AccountID`)
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
    CONSTRAINT FOREIGN KEY(`CategoryID`) 	REFERENCES CategoryQuestion(`CategoryID`),
    CONSTRAINT FOREIGN KEY(`CreatorID`)	REFERENCES Account(`AccountID`)
);

DROP TABLE IF EXISTS `ExamQuestion`;
CREATE TABLE `ExamQuestion`(
	`ExamID` 					INT UNSIGNED NOT NULL,
    `QuestionID` 				INT UNSIGNED NOT NULL,
    CONSTRAINT FOREIGN KEY(`ExamID`) 		REFERENCES Exam(`ExamID`),
    CONSTRAINT FOREIGN KEY(`QuestionID`) 	REFERENCES Question(`QuestionID`),
    CONSTRAINT PRIMARY KEY(`ExamID`, `QuestionID`)
);

INSERT INTO `Department`(DepartmentName)
VALUES
	('Makerting'),
    ('Sale'),
    ('CEO'),
    ('Bảo vệ'),
    ('Nhân sự'),
    ('Kỹ thuật'),
    ('Tài chính'),
    ('Phó giám đốc'),
    ('Thư kí');
    
INSERT INTO `Position`(PositionName)
VALUES
	('Dev'),
    ('Tes'),
    ('PM'),
    ('Scrum Master');


INSERT INTO Account(Email, Username, Fullname, DepartmentID, PositionID, CreateDate)
VALUES
	('levanha1@gmail.com', 'hakull1', 'Le Van Ha 1', 1, 12, '2021-09-15'),
    ('levanha2@gmail.com', 'hakull2', 'Le Van Ha 2', 2, 11, '2021-09-14'),
    ('levanha3@gmail.com', 'hakull3', 'Le Van Ha 3', 1, 13, '2021-07-15'),
    ('levanha4@gmail.com', 'hakull4', 'Le Van Ha 4', 2, 12, '2021-09-15'),
    ('levanha5@gmail.com', 'hakull5', 'Le Van Ha 5', 1, 13, '2021-09-15'),
    ('levanha6@gmail.com', 'hakull6', 'Le Van Ha 6', 1, 12, '2021-03-15');


INSERT INTO `Group`(GroupName, CreatorID, CreateDate)
VALUES
	('VTI 1', 13, '2021-05-15'),
    ('VTI 2', 14, '2021-05-13'),
    ('VTI 3', 15, '2021-03-19'),
    ('VTI 4', 13, '2023-05-19'),
    ('VTI 5', 16, '2020-05-19'),
    ('VTI 6', 18, '2021-05-19');


INSERT INTO `GroupAccount`(AccountID, JoinDate)
VALUES
	(13, '2020-11-26'),
    (14,'2021-12-30'),
    (15,'2022-11-29'),
    (16, '2020-05-12'),
    (17,'2019-05-13');

INSERT INTO `TypeQuestion`(TypeName)
VALUES
	('Essay'),
	('Multiple-Choice');


INSERT INTO `CategoryQuestion`(CategoryName)
VALUES
	('Java'),
    ('.NET'), 
    ('SQL'),
    ('POSTMAN'),
    ('Ruby');
    

INSERT INTO `Question`(Content, CategoryID, TypeID, CreatorID, CreateDate)
VALUES 
	('Hello my friend 1', 1, 1, 13, '2020-11-18'),
    ('Hello my friend 2', 5, 2, 14, '2021-12-18'),
    ('Hello my friend 3', 4, 1, 15, '2020-11-19'),
    ('Hello my friend 4', 3, 1, 16, '2022-09-19'),
    ('Hello my friend 5', 2, 2, 17, '2020-11-15');
    
INSERT INTO `Answer`(Content, QuestionID, isCorrect)
VALUES 
	('very hansome', 6, '1'),
    ('very kind', 6, '1'),
    ('hehehe', 7, '0'),
    ('Hoi gi do ?', 8, '1'),
    ('Ban hoi hay do', 9, '0'),
    ('Cau nay toi khong biet', 10, '1');
    
INSERT INTO `Exam`(Code, Title, CategoryID, Duration, CreatorID, CreateDate)
VALUES 
	('11A', 'OOP', 1, 90, 13, '2021-09-15'),
    ('11AB', 'C#', 2, 90, 14, '2021-09-15'),
    ('11C', 'SQL', 3, 60, 15, '2021-09-15'),
    ('11ACS', 'Java', 4, 90, 16, '2021-09-15'),
    ('11AAS', 'Java basic', 5, 90, 13, '2021-09-15');
    
INSERT INTO `ExamQuestion`(ExamID, QuestionID)
VALUES 
	(1, 6),
    (1,7),
    (2,6),
    (2,8),
    (3,9),
    (4,10),
    (3,6);
