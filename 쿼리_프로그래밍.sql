-- 쿼리로 프로그래밍하기^^ 반복문,조건문 등등 다 집어넣을수있다

-- 변수 사용하기
SET @myVar1 = 5;
SET @myVar2 = 3;
SET @myVar3 = 4.25;
SET @myVar4 = '유저명 : ';
SET myVar5 = 50;

-- 출력은 SELECT @변수명; 을 사용
SELECT @myVar1 + @myVar2 - @myVar3;

-- 테이블 조회하던 SELECT 구문처럼 ,로 여러 데이터를 반환 가능
SELECT @myVar4, user_name FROM user_tbl;

-- PREPARE 구문
SET @myVar5 = 3;

PREPARE myQuery
	FROM 'SELECT user_name, user_height FROM user_tbl LIMIT ?'; -- ?에 들어가는 것은 밑에 using 값
    
SELECT user_name, user_height FROM user_tbl LIMIT 5;	-- LIMIT : 상위 n개만 보여주기

EXECUTE myQuery USING @myVar5;

-- 조건문
SELECT IF(100>200, 'TRUE', 'FALSE') AS 판단;

-- SQL 프로그래밍과 프로시저
-- 함수 : 대체로 매개변수와 반환값을 모두 가지면 함수로 선언
-- 프로시저 : 매개변수는 존재하나 반환값이 없고, 특정 로직만 처리할 때 주로 선언
-- DELIMITER : JAVA 메인메서드 같은거

DELIMITER $$
CREATE PROCEDURE ifProc()
BEGIN
	DECLARE var1 INT;
    SET var1 = 100;
    
    IF var1 = 100 THEN
		SELECT 'THIS IS 100';
	ELSE
		SELECT 'THIS IS NOT 100';
	END IF;
END $$
DELIMITER ;

CALL ifProc();

-- 테이블 호출 구문을 프로시저로 생성
DELIMITER $$
CREATE PROCEDURE getUser()
BEGIN
	SELECT * FROM user_tbl;
END $$
DELIMITER ;

CALL getUser();

-- 
DELIMITER $$
CREATE PROCEDURE getOverAvgHeight()
BEGIN
	SELECT * FROM user_tbl WHERE user_height >
	(SELECT AVG(user_height) FROM user_tbl);
END $$
DELIMITER ;

CALL getOverAvgHeight();

-- 프로시저 삭제
DROP PROCEDURE getOverAvgHeight;
DROP PROCEDURE getUser;
DROP PROCEDURE ifProc;

-- 프로시저 상태
SHOW PROCEDURE status;
SHOW PROCEDURE status WHERE db = 'bitcamp06';

-- 2번 회원 회원가입일 3년 경과 여부 확인하기
DELIMITER $$
CREATE PROCEDURE getThree()
BEGIN
	DECLARE entryDate DATE;
    DECLARE todayDate DATE;
    DECLARE days INT;

	SELECT entry_date INTO entryDate
		FROM user_tbl WHERE user_num = 2;

	SET todayDate = CURRENT_DATE();
	SET days = DATEDIFF(todayDate, entryDate);

	IF(days/365) >= 3 THEN
		SELECT CONCAT('입사한지', days, '일이 경과했습니다.');
	ELSE
		SELECT CONCAT('3년 미만이며', days, '일이 경과했습니다.');
	END IF;
END $$
DELIMITER ;

CALL getThree();

/* IF THEN 구문 이후에 ELSE 가 아닌 ELSEIF ~ THEN 을 작성하면 두 개 이상의 조건을 입력할 수 있음
getScore 프로시저 생성
변수 point(INT)는 점수를 입력받는데, 77점을 입력하고
변수 ranking(CHAR)는
	90점 이상이면 'A'를 저장
    80점 이상이면 'B'를 저장
    70점 이상이면 'C'를 저장
    60점 이상이면 'D'를 저장
    그 이하 점수는 'F'를 저장
IF 구문 종료 후 SELECT 구문과 CONCAT()을 활용해서
취득점수: 77, 학점: C라는 구문을 콘솔에 출력 */

DELIMITER $$
CREATE PROCEDURE getScore()
BEGIN
    DECLARE point_ INT;
    DECLARE ranking CHAR;

	SELECT * FROM user_tbl;

	SET point_ = 77;

	IF point_ >= 90 THEN
		SET ranking = 'A';
	ELSEIF point_ >= 80 THEN
		SET ranking = 'B';
	ELSEIF point_ >= 70 THEN
		SET ranking = 'C';
	ELSEIF point_ >= 60 THEN
		SET ranking = 'D';
	
    END IF;
    
	SELECT CONCAT('취득점수 : ', point_, '학점 : ', ranking);
END $$
DELIMITER ;

CALL getScore();

-- WHILE 반복문
DELIMITER $$
CREATE PROCEDURE whileProc()
BEGIN
	DECLARE i INT;
    SET i = 1;
    
    WHILE(i <= 30) DO
		SET i = i + 1;
	END WHILE;
    
	SELECT i;
END $$
DELIMITER ;

CALL whileProc();

-- FOR 반복문
DELIMITER $$
CREATE PROCEDURE sum3nProc()
BEGIN
	DECLARE i INT;
    DECLARE total INT;
    
    SET i = 1;
    SET total = 0;
    
	WHILE(i < 100) DO
		IF (i % 3 = 0 ) THEN
		SET total = total + i;
		END IF;
        SET i = i + 1;
	END WHILE;
    
    SELECT total;
END $$
DELIMITER ;

CALL sum3nProc();

-- 프로시저가 수정될 때, 해당 프로시저를 삭제하고 수정해야 하므로 번거롭다.
-- 그래서 호출시 번호를 가변적으로 받는 형식으로 변환해주자.
-- CREATE PROCEDURE 프로시저명(IN 파라미터명 데이터타입(크기))
DELIMITER $$
CREATE PROCEDURE getThreeArgu(IN user_number INT)
BEGIN
	DECLARE entryDate DATE;
    DECLARE todayDate DATE;
    DECLARE days INT;

	SELECT entry_date INTO entryDate
		FROM user_tbl WHERE user_num = 3;
	
	SET todayDate = CURRENT_DATE();
    SET days = DATEDIFF(todayDate, entryDate);
    
    IF(days/365) >= 3 THEN
		SELECT CONCAT('가입한지', days, '일이 경과했습니다.');
	ELSE
		SELECT CONCAT('가입일은 3년 미만이며', days, '일이 경과했습니다.');
	END IF;
END $$
DELIMITER ;

CALL getThreeArgu(5);

/* <트리거>
특정 테이블에 명령이 내려지면 자동으로 연동된 명령을 수행하도록 구문을 걸어줌
예) 회원 탈퇴시 탛퇴한 회원을 DB에서 바로 삭제하지 하지 않고 탈퇴보류 테이블에 INSERT를 하거나
	수정이 일어나면 수정 전 내역을 따로 다른 테이블에 저장하거나
	특정 테이블 대상으로 실행되는 구문 이전이나 이후에 추가로 실핼할 명령어를 지정 
문법은 프로시저와 유사(달러자리에 슬래시로 입력)
DELIMITER //
CREATE TRIGGER 트리거명
	실행시점(BEFORE / AFTER) 실행로직(어떤 구문이 들어오면 실행할지 작성)
	ON 트리거적용테이블
	FOR EACH ROW
BEGIN
	트리거 실행시 작동코드
END //
DELIMITER ;
*/

CREATE TABLE game_list (
	id INT AUTO_INCREMENT PRIMARY KEY,
    game_name VARCHAR(10)
);

INSERT INTO game_list VALUES
	(1, '바람의나라'),
    (2, '리그오브레전드'),
    (3, '동물의숲'),
    (4, '젤다의전설');
    
-- 삭제할때마다 게임이 삭제되었다는 메세지 추가하기
DELIMITER //
CREATE TRIGGER testTrg
	AFTER DELETE
    ON game_list
    FOR EACH ROW
BEGIN
	SET @msg = CONCAT(OLD.game_name, '게임이 삭제되었습니다.');
END //
DELIMITER ;

DELETE FROM game_list WHERE id = 3;
SELECT @msg;