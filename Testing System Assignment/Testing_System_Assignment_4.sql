-- Question 1: Viết lệnh để lấy ra danh sách nhân viên và thông tin phòng ban của họ
SELECT a.*, d.DepartmentName 
FROM `account` a
JOIN `department` d
ON a.DepartmentID = d.DepartmentID;

-- Question 2: Viết lệnh để lấy ra thông tin các account được tạo sau ngày 20/12/2010
SELECT * FROM `Account`
WHERE CreateDate > '2010-12-20';

-- Question 3: Viết lệnh để lấy ra tất cả các developer
SELECT a.*, p.PositionName
FROM `Account` a
JOIN `Position` p
ON a.PositionID = p.PositionID
WHERE p.PositionName = 'Dev';

-- Question 4: Viết lệnh để lấy ra danh sách các phòng ban có >3 nhân viên
SELECT d.*, COUNT(d.DepartmentID) AS Amount FROM `Department` d
JOIN `Account` a ON d.DepartmentID = a.DepartmentID
GROUP BY d.DepartmentName
HAVING Amount > 3;

-- Question 5: Viết lệnh để lấy ra danh sách câu hỏi được sử dụng trong đề thi nhiều nhất
SELECT q.QuestionID, q.Content, COUNT(q.QuestionID) AS Amount 
FROM `question` q
	JOIN `examquestion` eq
		ON q.QuestionID = eq.QuestionID
GROUP BY q.QuestionID
HAVING Amount  =
	(SELECT COUNT(QuestionID) AS Amount FROM `examquestion`
	GROUP BY QuestionID
	ORDER BY Amount DESC
	LIMIT 1 
);

-- Question 6: Thông kê mỗi category Question được sử dụng trong bao nhiêu Question
SELECT cs.*, COUNT(cs.CategoryID) AS Amount 
FROM `categoryquestion` cs
JOIN `question` q
    ON cs.CategoryID = q.CategoryID
GROUP BY cs.CategoryID;

-- Question 7: Thông kê mỗi Question được sử dụng trong bao nhiêu Exam
SELECT q.Content, COUNT(eq.ExamID) Amount
FROM `question` q
LEFT JOIN `examquestion` eq
ON q.QuestionID = eq.QuestionID
GROUP BY q.QuestionID;

-- Question 8: Lấy ra Question có nhiều câu trả lời nhất
SELECT q.QuestionID, q.Content, COUNT(q.QuestionID) AS Amount
FROM `question` q
	JOIN `answer` a ON q.QuestionID = a.QuestionID
GROUP BY q.QuestionID
HAVING Amount = (SELECT COUNT(QuestionID) AS Amount FROM Answer
	GROUP BY QuestionID
	ORDER BY Amount DESC
	LIMIT 1);

-- Question 9: Thống kê số lượng account trong mỗi group
SELECT g.GroupName, COUNT(a.AccountID) AS `Amount Member`
FROM `group` g 
	JOIN `groupaccount` a
	ON g.GroupID = a.GroupID
GROUP BY g.GroupID;

-- Question 10: Tìm chức vụ có ít người nhất
SELECT p.PositionID, p.PositionName, COUNT(p.PositionName) AS Amount FROM `position` p
JOIN
	`Account` a
    ON p.PositionID = a.PositionID
GROUP BY p.PositionName
HAVING Amount = (SELECT  COUNT(PositionID) FROM `account`
	GROUP BY PositionID
	ORDER BY PositionID DESC
	LIMIT 1);

-- Question 11: Thống kê mỗi phòng ban có bao nhiêu dev, test, scrum master, PM
SELECT d.DepartmentID, d.DepartmentName, p.PositionName, COUNT(p.PositionID) AS AMOUNT 
FROM account a
JOIN department d
    ON a.DepartmentID = d.DepartmentID
JOIN position p
    WHERE a.PositionID = p.PositionID
GROUP BY p.PositionID, d.DepartmentID;

-- Question 12: Lấy thông tin chi tiết của câu hỏi bao gồm: thông tin cơ bản của 
-- question, loại câu hỏi, ai là người tạo ra câu hỏi, câu trả lời là gì, ...
SELECT * FROM question;
SELECT q.QuestionID, q.Content, tq.TypeName AS Author, a.Fullname, an.Content
FROM `question` q
	 JOIN categoryquestion cq ON q.CategoryID = cq.CategoryID
	 JOIN typequestion tq ON q.TypeID = tq.TypeID
	 JOIN account a ON a.AccountID = q.CreatorID
	 JOIN Answer AS an ON q.QuestionID = an.QuestionID
ORDER BY q.QuestionID ASC;

-- Question 13: Lấy ra số lượng câu hỏi của mỗi loại tự luận hay trắc nghiệm
SELECT tq.*, COUNT(q.TypeID) AS Amount
FROM `typequestion` tq
JOIN  `question` q
	ON tq.TypeID = q.TypeID
GROUP BY q.TypeID;

-- Question 14:Lấy ra group không có account nào
SELECT g.GroupID, g.GroupName
FROM `group` g
LEFT JOIN `groupAccount` ga
	ON g.GroupID = ga.GroupID
WHERE ga.AccountID IS NULL;


-- Question 15: Lấy ra group không có account nào
SELECT * FROM `Group`
WHERE GroupID NOT IN (SELECT GroupID
FROM GroupAccount);

-- Question 16: Lấy ra question không có answer nào
SELECT q.* FROM `question` q
WHERE q.QuestionID NOT IN (SELECT an.QuestionID FROM `Answer` an);

-- Question 17:
-- a) Lấy các account thuộc nhóm thứ 1
SELECT a.* FROM `account` a
JOIN `groupAccount` ga
	ON a.AccountID = ga.AccountID
WHERE ga.GroupID = 1;

-- b) Lấy các account thuộc nhóm thứ 2
SELECT a.* FROM `account` a
JOIN `groupAccount` ga
	ON a.AccountID = ga.AccountID
WHERE ga.GroupID = 2;

-- c) Ghép 2 kết quả từ câu a) và câu b) sao cho không có record nào trùng nhau
SELECT a.* FROM `account` a
JOIN `groupAccount` ga
	ON a.AccountID = ga.AccountID
WHERE ga.GroupID = 1
UNION
SELECT a.* FROM `account` a
JOIN `groupAccount` ga
	ON a.AccountID = ga.AccountID
WHERE ga.GroupID = 2;

-- Question 18:
-- a) Lấy các group có lớn hơn 5 thành viên
SELECT g.GroupID, g.GroupName, COUNT(ga.AccountID) AS Amount
FROM `group` g
JOIN `groupaccount` ga 
	ON g.GroupID = ga.GroupID
GROUP BY g.GroupID
HAVING Amount >= 5;

-- b) Lấy các group có nhỏ hơn 7 thành viên
SELECT g.GroupID, g.GroupName, COUNT(ga.AccountID) AS Amount
FROM `group` g
JOIN `groupaccount` ga 
	ON g.GroupID = ga.GroupID
GROUP BY g.GroupID
HAVING Amount < 7;

-- c) Ghép 2 kết quả từ câu a) và câu b)
SELECT g.GroupID, g.GroupName, COUNT(ga.AccountID) AS Amount
FROM `group` g
JOIN `groupaccount` ga 
	ON g.GroupID = ga.GroupID
GROUP BY g.GroupID
HAVING Amount >= 5
UNION
SELECT g.GroupID, g.GroupName, COUNT(ga.AccountID) AS Amount
FROM `group` g
JOIN `groupaccount` ga 
	ON g.GroupID = ga.GroupID
GROUP BY g.GroupID
HAVING Amount < 7;