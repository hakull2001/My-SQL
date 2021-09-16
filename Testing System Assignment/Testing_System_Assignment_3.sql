-- Question 1: Thêm ít nhất 10 record vào mỗi table
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
-- Question 2: lấy ra tất cả các phòng ban
SELECT DepartmentName FROM `department`;

-- Question 3: lấy ra id của phòng ban "Sale"
SELECT DepartmentID AS ID 
FROM `department`
WHERE DepartmentName = 'Sale';

-- Question 4: lấy ra thông tin account có full name dài nhất
SELECT * FROM `account`
WHERE character_length(Fullname) = (SELECT MAX(character_length(Fullname))
FROM `account`);

-- Question 5: Lấy ra thông tin account có full name dài nhất và thuộc phòng ban có id = 3
SELECT * FROM `account`
WHERE character_length(Fullname) = (SELECT MAX(character_length(Fullname))
FROM `account`)
AND DepartmentID = 3;

-- Question 6: Lấy ra tên group đã tham gia trước ngày 20/12/2019
SELECT GroupName 
FROM `group`
WHERE CreateDate < '2019-12-20';


-- Question 7: Lấy ra ID của question có >= 4 câu trả lời
SELECT QuestionID
FROM `answer`
GROUP BY QuestionID
HAVING COUNT(QuestionID) >= 4;

-- Question 8: Lấy ra các mã đề thi có thời gian thi >= 60 phút và được tạo trước ngày 20/12/2019
SELECT Code
FROM `Exam`
WHERE Duration >= 60 AND CreateDate <= '2019-12-20';

-- Question 9: Lấy ra 5 group được tạo gần đây nhất
SELECT * FROM `group`
ORDER BY CreateDate DESC
LIMIT 5;

-- Question 10: Đếm số nhân viên thuộc department có id = 2
SELECT COUNT(AccountID) AS Amount
FROM `account`
WHERE DepartmentID = 2;

-- Question 11: Lấy ra nhân viên có tên bắt đầu bằng chữ "D" và kết thúc bằng chữ "o"
SELECT *
FROM `Account`
WHERE (SUBSTRING_INDEX(FullName, ' ', -1)) LIKE 'D%o' ;

-- Question 12: Xóa tất cả các exam được tạo trước ngày 20/12/2019
DELETE 
FROM `exam`
WHERE CreateDate < '2019-12-20';

-- Question 13: Xóa tất cả các question có nội dung bắt đầu bằng từ "câu hỏi"
DELETE 
FROM `question`
WHERE (SUBSTRING_INDEX(Content,' ',2)) = 'Câu hỏi';

-- Question 14: Update thông tin của account có id = 5 thành tên "Nguyễn Bá Lộc" và email thành loc.nguyenba@vti.com.vn
UPDATE `Account`
SET Fullname = 'Nguyễn Bá Lộc', Email = 'loc.nguyenba@vti.com.vn'
WHERE AccountID = 5;

-- Question 15: update account có id = 5 sẽ thuộc group có id = 4
UPDATE `groupaccount`
SET AccountID = 5
WHERE GroupID = 5;
