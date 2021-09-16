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
    CONSTRAINT answer_ibfk_1 FOREIGN KEY(`QuestionID`) 	REFERENCES Question(`QuestionID`)
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
   ('vti_account1@vtiacademy.com', 'vti1', 'Nguyen Van Tinh', 1, 1, '2019-12-01'),
   ('vti_account2@vtiacademy.com', 'vti2', 'Trinh Hoai Linh', 1, 2, '2020-12-01'),
   ('vti_account3@vtiacademy.com', 'vti3', 'Nguyen Van Test', 1, 1, '2020-07-01'),
   ('vti_account4@vtiacademy.com', 'vti4', 'Tran Van Tinh', 1, 2, '2019-09-01'),
   ('vti_account5@vtiacademy.com', 'account5', 'Ho Van Tinh', 3, 2, '2021-07-01'),
   ('vti_account6@vtiacademy.com', 'account_vti6', 'Cao Thai Son', 3, 1, NOW()),
   ('vti_7@vtiacademy.com', 'account_vti7', 'Tam Thất Tùng', 3, 3, '2020-10-01'),
   ('vti_8@vtiacademy.com', 'account_vti8', 'Nguyen Quynh Thu', 3, 4, '2019-04-01'),
   ('vti_9@vtiacademy.com', 'account_vti9', 'Tran Kim Tuyen', 2, 1, NOW()),
   ('vti_account10@vtiacademy.com', 'account_vti10', 'Nguyen Ba Dao', 1, 4, '2019-10-01'),
   ('vti_account11@vtiacademy.com', 'account_vti11', 'Nguyen Van Binh', 1, 3, '2020-12-01');
INSERT INTO `Group`(GroupName, CreatorID, CreateDate)
VALUES
	('Nhom 1', '3', '2021-04-03'),
   ('Nhom 2', '3', '2019-01-03'),
   ('Nhom 3', '2', '2020-04-03'),
   ('Nhom 4', '1', NOW()),
   ('Nhom 5', '3', '2021-06-03'),
   ('Nhom 6', '1', '2020-04-03'),
   ('Nhom 7', '5', '2021-04-03'),
   ('Nhom 8', '5', '2019-05-03'),
   ('Nhom 9', '3', '2019-01-03'),
   ('Nhom 10', '1', NOW());



INSERT INTO `GroupAccount`(AccountID, JoinDate)
VALUES
	('1', '2021-06-01'),
   ('3', '2020-01-01'),
   ('2', NOW()),
   ('4', '2021-06-01'),
   ('1', '2021-06-01'),
   ('10', '2019-05-01'),
   ('1', '2021-06-01'),
   ('3', '2020-01-01'),
   ('4', '2021-07-01'),
   ('1', '2021-06-01'),
   ('2', '2021-06-01'),
   ('1', NOW());

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
	('Câu hỏi SQL 1', 2, 2, 1, '2021-04-01'),
   ('Câu hỏi SQL 2', 2, 2, 2, '2020-01-01'),
   ('Câu hỏi JAVA 1', 1, 1, 10, '2021-07-01'),
   ('Câu hỏi JAVA 2', 1, 2, 5, '2021-06-01'),
   ('Câu hỏi HTML 1', 3, 1, 2, NOW()),
   ('Câu hỏi HTML 2', 3, 2, 2, NOW());

INSERT INTO `Answer`(Content, QuestionID, isCorrect)
VALUES 
	('Câu trả lời 1 - question SQL 1', 1, '1'),
       ('Câu trả lời 2 - question SQL 1', 1, '0'),
       ('Câu trả lời 3 - question SQL 1', 1, '1'),
       ('Câu trả lời 4 - question SQL 1', 1, '0'),
       ('Câu trả lời 1 - question SQL 2', 2, '1'),
       ('Câu trả lời 2 - question SQL 2', 2, '0'),
       ('Câu trả lời 3 - question SQL 2', 2, '1'),
       ('Câu trả lời 4 - question SQL 2', 2, '1'),
       ('Câu trả lời 1 - question JAVA 1', 3, '0'),
       ('Câu trả lời 2 - question JAVA 1', 3, '1'),
       ('Câu trả lời 1 - question JAVA 2', 4, '0'),
       ('Câu trả lời 2 - question JAVA 2', 4, '0'),
       ('Câu trả lời 3 - question JAVA 2', 4, '0'),
       ('Câu trả lời 4 - question JAVA 2', 4, '1'),
       ('Câu trả lời 1 - question HTML 1', 5, '1'),
       ('Câu trả lời 2 - question HTML 2', 5, '1');


INSERT INTO `Exam`(Code, Title, CategoryID, Duration, CreatorID, CreateDate)
VALUES 
	('MS_01', 'De thi 01', 1, 90, 1, NOW()),
   ('MS_02', 'De thi 02', 1, 60, 5, NOW()),
   ('MS_03', 'De thi 03', 2, 60, 9, NOW()),
   ('MS_04', 'De thi 04', 2, 90, 1, NOW()),
   ('MS_05', 'De thi 05', 1, 60, 2, NOW()),
   ('MS_06', 'De thi 06', 2, 90, 2, NOW()),
   ('MS_07', 'De thi 07', 1, 60, 1, NOW());
   
   
   
INSERT INTO `ExamQuestion`(ExamID, QuestionID)
VALUES 
   (1, 1),
   (2, 1),
   (3, 1),
   (4, 1),
   (1, 2),
   (6, 2),
   (7, 2),
   (5, 2),
   (6, 3),
   (1, 3),
   (2, 4),
   (3, 4),
   (4, 4),
   (5, 4),
   (1, 5),
   (2, 5);