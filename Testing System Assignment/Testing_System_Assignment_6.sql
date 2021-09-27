-- Question 1: Tạo store để người dùng nhập vào tên phòng ban và in ra tất cả các
-- account thuộc phòng ban đó
DROP PROCEDURE IF EXISTS output_account_d;
DELIMITER $$
CREATE PROCEDURE output_account_d(IN dName VARCHAR(50))
	BEGIN
		SELECT a.* FROM `Account` a
        JOIN `Department` d USING(DepartmentID)
        WHERE d.DepartmentName = dName;
    END$$
DELIMITER ;
call output_account_d('CEO');

-- Question 2: Tạo store để in ra số lượng account trong mỗi group
DROP PROCEDURE IF EXISTS count_account_inside_gr;
DELIMITER $$
CREATE PROCEDURE count_account_inside_gr(IN NGroup VARCHAR(50))
	BEGIN
		SELECT g.GroupName, COUNT(ga.AccountID) AS `SL`
        FROM `groupaccount` ga 
        JOIN `Group` g USING(GroupID)
        WHERE g.GroupName = NGroup
        GROUP BY g.GroupID;
    END$$
DELIMITER ;
call count_account_inside_gr('Nhom 1');

-- Question 3: Tạo store để thống kê mỗi type question có bao nhiêu question được tạo trong tháng hiện tại
DROP PROCEDURE IF EXISTS questions_created_in_month;
DELIMITER $$
CREATE PROCEDURE questions_created_in_month(IN TQuestion VARCHAR(50))
	BEGIN
		SELECT tq.TypeName, COUNT(q.TypeID) AS `SL`
		FROM `typequestion` tq JOIN `question` q USING(TypeID)
		WHERE month(q.CreateDate) = month(NOW()) AND tq.TypeName = TQuestion
		GROUP BY tq.TypeName;
    END$$
DELIMITER ;
call questions_created_in_month('Essay');


-- Question 4: Tạo store để trả ra id của type question có nhiều câu hỏi nhất
SELECT * FROM question;

DROP PROCEDURE IF EXISTS return_id_max_question;
DELIMITER $$
CREATE PROCEDURE return_id_max_question(OUT id INT)
	BEGIN
		WITH CTE_count_qs AS(
			SELECT COUNT(TypeID) AS `SL`
			FROM question
			GROUP BY TypeID)
		SELECT tq.TypeID INTO id 
        FROM `typequestion` tq
			JOIN `question` q USING(TypeID)
        GROUP BY tq.TypeID 
        HAVING COUNT(q.TypeID) = (SELECT MAX(`SL`) FROM CTE_count_qs);
    END$$
DELIMITER ;
call return_id_max_question(@id);
SELECT @id;

-- Question 5: Sử dụng store ở question 4 để tìm ra tên của type question
SET @id = 1;
DROP PROCEDURE IF EXISTS find_name_tqs;
DELIMITER $$
	CREATE PROCEDURE find_name_tqs()
		BEGIN
			WITH CTE_count_qs AS(
			SELECT COUNT(TypeID) AS `SL`
			FROM question
			GROUP BY TypeID)
			SELECT tq.TypeName, COUNT(q.TypeID) AS `SL`
			FROM `typequestion` tq
				JOIN `question` q USING(TypeID)
			GROUP BY q.TypeID 
			HAVING COUNT(q.TypeID) = (SELECT MAX(`SL`) FROM CTE_count_qs);
		END$$
DELIMITER ; 
call find_name_tqs();

-- Question 6: Viết 1 store cho phép người dùng nhập vào 1 chuỗi và trả về group có tên
-- chứa chuỗi của người dùng nhập vào hoặc trả về user có username chứa
-- chuỗi của người dùng nhập vào
SELECT * FROM `account`;
DROP PROCEDURE IF EXISTS get_name_group_or_user;
DELIMITER $$
CREATE PROCEDURE get_name_group_or_user(IN str VARCHAR(50), IN tmp INT)
	BEGIN
    IF tmp = 1 THEN 
		SELECT GroupName FROM `group`  WHERE GroupName LIKE CONCAT('%',str,'%');
    ELSE
		SELECT Username FROM `Account` WHERE Username LIKE CONCAT('%',str,'%');
	END IF;
    END$$
DELIMITER ; 
call get_name_group_or_user('1', 0);


-- Question 7: Viết 1 store cho phép người dùng nhập vào thông tin fullName, email và
-- trong store sẽ tự động gán:
-- username sẽ giống email nhưng bỏ phần @..mail đi
-- positionID: sẽ có default là developer
-- departmentID: sẽ được cho vào 1 phòng chờ
-- Sau đó in ra kết quả tạo thành công
DROP PROCEDURE IF EXISTS create_account;
DELIMITER $$
CREATE PROCEDURE create_account(IN fullName VARCHAR(50), IN email VARCHAR(50))
	BEGIN
		DECLARE v_userName VARCHAR(50) DEFAULT SUBSTRING_INDEX(email,'@',1);
        DECLARE v_positionID INT DEFAULT 1;
        DECLARE v_departmentID INT DEFAULT 6;
        INSERT INTO `Account`(Email, Username, Fullname, DepartmentID, PositionID, CreateDate)
        VALUES(email, v_userName, fullName, v_departmentID, v_positionID, NOW());
    END$$
DELIMITER ;
call create_account('Le Van Ha', 'birtday11111@gmail.com');

-- Question 8: Viết 1 store cho phép người dùng nhập vào Essay hoặc Multiple-Choice
-- để thống kê câu hỏi essay hoặc multiple-choice nào có content dài nhất
DROP PROCEDURE IF EXISTS max_content_qs;
DELIMITER $$
CREATE PROCEDURE max_content_qs(IN typeQS VARCHAR(50))
	BEGIN
		WITH CTE_get_content AS(
			SELECT LENGTH(q.Content) AS `length` FROM `Question` q)
		SELECT q.* FROM question q 
        JOIN `typeQuestion` tq USING(TypeID)
        WHERE LENGTH(Content) = (SELECT MAX(`length`) FROM CTE_get_content) AND tq.TypeName = typeQS;
    END$$
DELIMITER ;
call max_content_qs('Essay');


-- Question 9: Viết 1 store cho phép người dùng xóa exam dựa vào ID
DROP PROCEDURE IF EXISTS delete_exam;
DELIMITER $$
CREATE PROCEDURE delete_exam(IN id_del TINYINT UNSIGNED)
	BEGIN
		DELETE FROM `examquestion` WHERE ExamID = id_del;
		DELETE FROM `exam` WHERE ExamID = id_del;
    END$$
DELIMITER ;
call delete_exam(8);

-- Question 10: Tìm ra các exam được tạo từ 3 năm trước và xóa các exam đó đi (sử
-- dụng store ở câu 9 để xóa)
-- Sau đó in số lượng record đã remove từ các table liên quan trong khi
-- removing
DROP PROCEDURE IF EXISTS SP_DeleteExamBefore3Year;
DELIMITER $$
CREATE PROCEDURE SP_DeleteExamBefore3Year()
	BEGIN
	DECLARE v_ExamID TINYINT UNSIGNED;
	DECLARE v_CountExam TINYINT UNSIGNED DEFAULT 0;
	DECLARE v_CountExamquestion TINYINT UNSIGNED DEFAULT 0;
	DECLARE i TINYINT UNSIGNED DEFAULT 1;
	DECLARE v_print_Del_info_Exam VARCHAR(50) ;
	DROP TABLE IF EXISTS ExamIDBefore3Year_Temp;
	CREATE TABLE ExamIDBefore3Year_Temp(
		ID INT PRIMARY KEY AUTO_INCREMENT,
		ExamID INT);
	INSERT INTO ExamIDBefore3Year_Temp(ExamID)
	SELECT e.ExamID FROM exam e WHERE (year(now()) - year(e.CreateDate)) >2;
	SELECT count(1) INTO v_CountExam FROM ExamIDBefore3Year_Temp;
	SELECT count(1) INTO v_CountExamquestion FROM examquestion ex
	INNER JOIN ExamIDBefore3Year_Temp et ON ex.ExamID = et.ExamID;
	WHILE (i <= v_CountExam) DO
		SELECT ExamID INTO v_ExamID FROM ExamIDBefore3Year_Temp WHERE ID=i;
		CALL sp_DeleteExamWithID(v_ExamID);
		SET i = i +1;
	END WHILE;
	SELECT CONCAT("DELETE ",v_CountExam," IN Exam AND ", v_CountExamquestion ," IN
	ExamQuestion") INTO v_print_Del_info_Exam;
	SIGNAL SQLSTATE '45000'
	SET MESSAGE_TEXT = v_print_Del_info_Exam ;
	DROP TABLE IF EXISTS ExamIDBefore3Year_Temp;
END$$
DELIMITER ;
Call SP_DeleteExamBefore3Year();
-- Question 11: Viết store cho phép người dùng xóa phòng ban bằng cách người dùng
-- nhập vào tên phòng ban và các account thuộc phòng ban đó sẽ được
-- chuyển về phòng ban default là phòng ban chờ việc
-- Question 12: Viết store để in ra mỗi tháng có bao nhiêu câu hỏi được tạo trong năm
-- nay
-- 2
-- Question 13: Viết store để in ra mỗi tháng có bao nhiêu câu hỏi được tạo trong 6
-- tháng gần đây nhất
-- (Nếu tháng nào không có thì sẽ in ra là "không có câu hỏi nào trong
-- tháng")