DROP TRIGGER IF EXISTS InsertQuestion;
DELIMITER $$
	CREATE TRIGGER InsertQuestion
    BEFORE INSERT ON `question`
    FOR EACH ROW
    BEGIN
		-- IF (NEW.CreateDate > NOW()) THEN 
-- 			SET New.CreateDate = NOW();
-- 		END IF;
		IF(NEW.CreateDate > NOW()) THEN
			SIGNAL SQLSTATE '12345'
            SET MESSAGE_TEXT = 'Thời gian nhập vào k đúng';
		END IF;
    END$$
DELIMITER ;
SELECT * FROM `question`;
-- Question 1: Tạo trigger không cho phép người dùng nhập vào Group có ngày tạo
-- trước 1 năm trước
DROP TRIGGER IF EXISTS check_date_group;
DELIMITER $$
	CREATE TRIGGER check_date_group
	BEFORE INSERT ON `Group`
	FOR EACH ROW
	BEGIN
		DECLARE v_CreateDate DATETIME;
        SET v_CreateDate = date_sub(NOW(), interval 1 year);
		IF(NEW.CreateDate <= v_CreateDate) THEN 
			SIGNAL SQLSTATE '12345'
            SET MESSAGE_TEXT = 'Không thể tạo group này';
		END IF;
    END$$
DELIMITER ;
INSERT 
INTO `testing_system_assignment_1`.`group` (`GroupID`, `GroupName`, `CreatorID`, `CreateDate`) 
VALUES ('11', 'Nhom 11', '2', '2019-09-16 00:00:00');
-- Question 2: Tạo trigger Không cho phép người dùng thêm bất kỳ user nào vào
-- department "Sale" nữa, khi thêm thì hiện ra thông báo "Department
-- "Sale" cannot add more user"
DROP TRIGGER IF EXISTS auth_add_user;
DELIMITER $$
	CREATE TRIGGER auth_add_user
	BEFORE INSERT ON `Account`
	FOR EACH ROW
	BEGIN
		DECLARE dID INT;
        SELECT d.DepartmentID INTO dID 
        FROM `Department` d 
        WHERE d.DepartmentName = 'Sale';
        IF(NEW.DepartmentID = dID) THEN 
			SIGNAL SQLSTATE '12345'
            SET MESSAGE_TEXT = 'Department "Sale" cannot add more user';
		END IF;
    END$$
DELIMITER ;
INSERT 
INTO `testing_system_assignment_1`.`account` (`AccountID`, `Email`, `Username`, `Fullname`, `DepartmentID`, `PositionID`, `CreateDate`) 
VALUES ('14', '1231231', '12312312', '12312312', '2', '1', '2021-09-26 20:59:23');

SELECT * FROM `groupAccount`;
-- Question 3: Cấu hình 1 group có nhiều nhất là 5 user
DROP TRIGGER IF EXISTS max_user_inside_group;
DELIMITER $$
CREATE TRIGGER max_user_inside_group
	BEFORE INSERT ON `GroupAccount`
    FOR EACH ROW
    BEGIN
		DECLARE v_countGroup INT;
        SELECT COUNT(ga.GroupID) INTO v_countGroup FROM `GroupAccount` ga
        WHERE ga.GroupID = NEW.GroupID;
		IF(v_countGroup > 5) THEN
			SIGNAL SQLSTATE '12345'
            SET MESSAGE_TEXT = 'Không thể thêm user vào group này nữa';
        END IF;
    END$$
DELIMITER ;
SELECT * FROM `groupAccount`;
INSERT INTO `testing_system_assignment_1`.`groupAccount` (`GroupID`, `AccountID`, `JoinDate`) VALUES ('11', '2', '2021-09-16 17:26:50');

-- Question 4: Cấu hình 1 bài thi có nhiều nhất là 10 Question
DROP TRIGGER IF EXISTS auth_max_question_inside_exam;
DELIMITER $$
	CREATE TRIGGER auth_max_question_inside_exam
	BEFORE INSERT ON `examQuestion`
    FOR EACH ROW
    BEGIN
		DECLARE v_countQuestion INT;
        SELECT COUNT(eq.ExamID) INTO v_countQuestion 
        FROM `examquestion` eq 
        WHERE eq.ExamID = NEW.ExamID;
        IF(v_countQuestion > 10 ) THEN
			SIGNAL SQLSTATE '12345'
            SET MESSAGE_TEXT = '1 bài thi có nhiều nhất 4 câu';
		END IF;
    END$$
DELIMITER ;
INSERT INTO `testing_system_assignment_1`.`examquestion` (`ExamID`, `QuestionID`) VALUES ('1', '5');

-- Question 5: Tạo trigger không cho phép người dùng xóa tài khoản có email là
-- admin@gmail.com (đây là tài khoản admin, không cho phép user xóa),
-- còn lại các tài khoản khác thì sẽ cho phép xóa và sẽ xóa tất cả các thông
-- tin liên quan tới user đó
DROP TRIGGER IF EXISTS auth_delete_user;
DELIMITER $$
	CREATE TRIGGER auth_delete_user
	BEFORE DELETE ON `Account`
	FOR EACH ROW
	BEGIN
		DECLARE emailAdmin VARCHAR(50);
        SET emailAdmin = 'admin@gmail.com';
        IF(OLD.Email = emailAdmin) THEN
			SIGNAL SQLSTATE '12345'
            SET MESSAGE_TEXT = 'Không được phép xóa Admin';
		END IF;
	END$$
DELIMITER ;
SELECT * FROM `account`;
begin work;
DELETE 
FROM `Account`
WHERE AccountID = 13;
rollback;

-- Question 6: Không sử dụng cấu hình default cho field DepartmentID của table
-- Account, hãy tạo trigger cho phép người dùng khi tạo account không điền
-- vào departmentID thì sẽ được phân vào phòng ban "waiting Department"
DROP TRIGGER IF EXISTS create_account_not_dID;
DELIMITER $$
	CREATE TRIGGER create_account_not_dID
	BEFORE INSERT ON `Account`
	FOR EACH ROW
    BEGIN
		DECLARE wait_departmentID INT;
        SELECT d.DepartmentID INTO wait_departmentID FROM `Department` d
        WHERE d.DepartmentName = 'waiting Department';
        IF(NEW.DepartmentID IS NULL) THEN
			SET NEW.DepartmentID = wait_departmentID;
		END IF;
    END$$
DELIMITER ;
INSERT 
INTO `testing_system_assignment_1`.`account` (`AccountID`, `Email`, `Username`, `Fullname`, `PositionID`, `CreateDate`) 
VALUES ('14', 'adasdasasd', '123asdsa', 'adsdasdas', '1', '2021-09-26 20:59:23');

-- Question 7: Cấu hình 1 bài thi chỉ cho phép user tạo tối đa 4 answers cho mỗi
-- question, trong đó có tối đa 2 đáp án đúng.
DROP TRIGGER IF EXISTS auth_create_answer;
DELIMITER $$
	CREATE TRIGGER auth_create_answer
	BEFORE INSERT ON `answer`
	FOR EACH ROW
	BEGIN
		DECLARE v_count_answer INT;
        DECLARE v_count_answer_correct INT;
        SELECT COUNT(a.QuestionID) INTO v_count_answer FROM `Answer` a
        WHERE a.QuestionID = NEW.QuestionID;
        SELECT COUNT(a.isCorrect) INTO v_count_answer_correct FROM `Answer` a
        WHERE a.QuestionID = NEW.QuestionID AND a.isCorrect = NEW.isCorrect;
        IF (v_count_answer > 4 ) OR (v_count_answer_correct >2) THEN
			SIGNAL SQLSTATE '12345'
			SET MESSAGE_TEXT = 'Câu hỏi hoặc câu trả lời đúng vượt quá số lượng cho phép';
		END IF;
	END$$
DELIMITER ;
INSERT INTO `testing_system_assignment_1`.`answer` (`AnswerID`, `Content`, `QuestionID`, `isCorrect`) VALUES ('1', '2', '3', '0');

-- Question 8: Viết trigger sửa lại dữ liệu cho đúng:
-- Nếu người dùng nhập vào gender của account là nam, nữ, chưa xác định
-- Thì sẽ đổi lại thành M, F, U cho giống với cấu hình ở database
DROP TRIGGER IF EXISTS auth_gender;
DELIMITER $$
	CREATE TRIGGER auth_gender
	BEFORE INSERT ON `Account`
	FOR EACH ROW
    BEGIN
		IF NEW.Gender = 'Nam' THEN
			SET NEW.Gender = 'M';
		ELSEIF NEW.Gender = 'Nữ' THEN
			SET NEW.Gender = 'F';
		ELSEIF NEW.Gender = 'Chưa xác định' THEN
			SET NEW.Gender = 'U';
		END IF;
    END$$
DELIMITER ;
-- Question 9: Viết trigger không cho phép người dùng xóa bài thi mới tạo được 2 ngày
DROP TRIGGER IF EXISTS auth_dele_exam;
DELIMITER $$
	CREATE TRIGGER auth_dele_exam
	BEFORE DELETE ON `exam`
	FOR EACH ROW
	BEGIN		
		DECLARE v_date_create_exam DATETIME;
        SET v_date_create_exam = DATE_SUB(NOW(), interval 2 DAY );
        IF(OLD.CreateDate > v_date_create_exam) THEN 
			SIGNAL SQLSTATE '12345'
            SET MESSAGE_TEXT = 'Không được phép xòa bài thi này';
		END IF;
	END$$
DELIMITER ;
SELECT * FROM `exam`;
DELETE FROM `exam` WHERE ExamID = 9;
-- Question 10: Viết trigger chỉ cho phép người dùng chỉ được update, delete các
-- question khi question đó chưa nằm trong exam nào
DROP TRIGGER IF EXISTS auth_update_question;
DELIMITER $$
CREATE TRIGGER auth_update_question
	BEFORE UPDATE ON `question`
	FOR EACH ROW
	BEGIN
		DECLARE v_id_exam TINYINT;
        SET v_id_exam = -1;
        SELECT DISTINCT eq.QuestionID INTO v_id_exam 
        FROM `examquestion` eq 
        WHERE eq.QuestionID = NEW.QuestionID;
        IF(v_id_exam != -1) THEN
			SIGNAL SQLSTATE '12345'
            SET MESSAGE_TEXT = 'Không thể update question này1';
		END IF;
	END$$
DELIMITER ;


DROP TRIGGER IF EXISTS auth_delete_question;
DELIMITER $$
CREATE TRIGGER auth_delete_question
	BEFORE DELETE ON `question`
	FOR EACH ROW
	BEGIN
		DECLARE v_id_exam TINYINT;
        SET v_id_exam = -1;
        SELECT DISTINCT eq.QuestionID INTO v_id_exam 
        FROM `examquestion` eq 
        WHERE eq.QuestionID = OLD.QuestionID;
        IF(v_id_exam != -1) THEN
			SIGNAL SQLSTATE '12345'
            SET MESSAGE_TEXT = 'Không thể delete question này';
		END IF;
	END$$
DELIMITER ;
DELETE FROM `question`
WHERE QuestionID = 1;
-- Question 12: Lấy ra thông tin exam trong đó:
-- Duration <= 30 thì sẽ đổi thành giá trị "Short time"
-- 30 < Duration <= 60 thì sẽ đổi thành giá trị "Medium time"
-- Duration > 60 thì sẽ đổi thành giá trị "Long time"
SELECT e.ExamID, e.`Code`, e.Title, CASE 
	WHEN e.Duration <= 30 THEN 'Short time'
    WHEN e.Duration <= 60 THEN 'Medium time'
    ELSE 'Long time' END AS `Duration`, e.CreatorID, e.CreateDate
FROM `Exam` e;


-- Question 13: Thống kê số account trong mỗi group và in ra thêm 1 column nữa có tên
-- là the_number_user_amount và mang giá trị được quy định như sau:
-- Nếu số lượng user trong group =< 5 thì sẽ có giá trị là few
-- Nếu số lượng user trong group <= 20 và > 5 thì sẽ có giá trị là normal
-- Nếu số lượng user trong group > 20 thì sẽ có giá trị là higher
-- Question 14: Thống kê số mỗi phòng ban có bao nhiêu user, nếu phòng ban nào
-- không có user thì sẽ thay đổi giá trị 0 thành "Không có User"