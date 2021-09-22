-- Question 1: Tạo view có chứa danh sách nhân viên thuộc phòng ban sale
-- CTE
WITH CTE_Account_Sale AS (SELECT a.AccountID, a.Fullname, a.DepartmentID, d.DepartmentName
FROM `Account` a
JOIN `Department` d
ON a.DepartmentID = d.DepartmentID
WHERE d.DepartmentName ='Sale')
SELECT * FROM CTE_Account_Sale;

-- VIEW
CREATE OR REPLACE VIEW view_account_sale AS(
SELECT a.AccountID, a.Fullname, a.DepartmentID, d.DepartmentName
FROM `Account` a
JOIN `Department` d ON a.DepartmentID = d.DepartmentID
WHERE d.DepartmentName = 'Sale');
SELECT * FROM view_account_sale;



-- Question 2: Tạo view có chứa thông tin các account tham gia vào nhiều group nhất
-- VIEW
CREATE OR REPLACE VIEW view_account_max_group AS
(SELECT * FROM `Account`
WHERE AccountID IN (SELECT a.AccountID FROM `Account` a
JOIN `GroupAccount` ga ON a.AccountID = ga.AccountID
GROUP BY ga.AccountID
HAVING COUNT(ga.AccountID) = (SELECT COUNT(AccountID) AS Amounts FROM `groupAccount`
GROUP BY AccountID
ORDER BY Amounts DESC
LIMIT 1)));
SELECT * FROM view_account_max_group;

-- Question 3:Tạo view có chứa câu hỏi có những content quá dài (content quá 300 từ được coi là quá dài) và xóa nó đi
CREATE OR REPLACE VIEW content_max_length AS
(SELECT QuestionID
FROM `question`
WHERE character_length(Content) >  300);
DELETE
FROM `question`
WHERE QuestionID IN (SELECT * FROM content_max_length);

-- CTE
WITH CTE_content_max AS (SELECT QuestionID
FROM `question`
WHERE character_length(Content) >  300)
DELETE
FROM `question`
WHERE QuestionID IN (SELECT * FROM CTE_content_max);

-- Question 4: Tạo view có chứa danh sách các phòng ban có nhiều nhân viên nhất
CREATE OR REPLACE VIEW view_department_account AS (
WITH CTE_Count_max_emp AS (SELECT COUNT(DepartmentID) FROM `Account`
GROUP BY DepartmentID
ORDER BY DepartmentID DESC LIMIT 1)
SELECT d.*, COUNT(a.DepartmentID) AS Employees FROM `department` d
JOIN `Account` a ON d.DepartmentID = a.DepartmentID
GROUP BY d.DepartmentID
HAVING Employees = (SELECT * FROM CTE_Count_max_emp));
SELECT * FROM view_department_account;


-- Question 5: Tạo view có chứa tất các các câu hỏi do user họ Nguyễn tạo
SELECT * FROM `question`;
CREATE OR REPLACE VIEW view_question_account AS (
WITH CTE_question_account AS (
SELECT q.CategoryID, q.Content, a.Fullname FROM `question` q
JOIN `Account` a ON q.CreatorID = a.AccountID
WHERE SUBSTRING_INDEX(a.Fullname,' ',1) = "Nguyễn")
SELECT * FROM CTE_question_account);
SELECT * FROM view_question_account;
