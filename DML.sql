/* 좌측의 schemas의 DATABASE는 use DB명; 으로 호출할 수 있다. */
use bitcamp06;

/* DATABASE 정보 조회 */
SHOW DATABASES;
SELECT * FROM user_tbl;
SELECT * FROM user_tbl2;

/* 함부로 삭제할 수 없거나 하는 장치 */
set sql_Safe_updates = 0;

/* 테이블 생성 */
CREATE TABLE user_tbl (
	user_num int(5) PRIMARY KEY AUTO_INCREMENT, -- INSERT시 유저넘버 자동 배정
    user_name varchar(10) NOT NULL,
    user_birth_year int NOT NULL,
    user_address char(5) NOT NULL,
    user_height int, -- 자리 수 제한 없음
    entry_date date -- 회원가입
);

/* 새로운 데이터 추가 */
INSERT INTO user_tbl VALUES(NULL, '김자바', 1987, '서울', 180, '2020-05-03');
INSERT INTO user_tbl VALUES(NULL, '이연희', 1992, '경기', 164, '2020-05-12');
INSERT INTO user_tbl VALUES(NULL, '박종현', 1990, '부산', 177, '2020-06-01');
INSERT INTO user_tbl (user_name, user_birth_year, user_address, user_height, entry_date)
VALUES ('유정원', 1999, '경기', 160, '2023-03-12');

/* 특정 조건에 해당하는 것만 조회하기 */
SELECT * FROM user_tbl WHERE user_height < 175;

/* AND, OR 이중 조건 걸기 */
SELECT * FROM user_tbl WHERE user_num > 2 OR user_height < 178;

/* 컬럼 내 데이터 싹다 하나로 통일하기 */
UPDATE user_tbl SET user_address = '서울';

/* 테이블이 존재하지 않다면 삭제구문을 실행하지 않아 에러를 발생시키지 않음 */
DROP TABLE IF EXISTS user_tbl;

/* 특정 데이터 수정하기 */
UPDATE user_tbl SET user_address = '강원' WHERE user_num = 1;

/* 데이터 삭제하기 */
DELETE FROM user_tbl WHERE user_name = '박종현';
DELETE FROM user_tbl;	-- where 없이 삭제시 truncate 처럼 다 삭제됨
DELETE FROM user_tbl2;

/* 다중 INSERT 구문 */
INSERT INTO user_tbl
	VALUES (NULL, '김개발', 1994, '경북', 178, '2020-08-02'),
			(NULL, '최자바', 1998, '서울', 170, '2021-04-23'),
			(NULL, '이미소', 2000, '경기', 165, '2023-06-05');
            
            
/* INSERT~SELECT 를 위해 테이블을 하나 더 만들기 */            
CREATE TABLE user_tbl2 (
	user_num int(5) PRIMARY KEY AUTO_INCREMENT, -- INSERT시 유저넘버 자동 배정
    user_name varchar(10) NOT NULL,
    user_birth_year int NOT NULL,
    user_address char(5) NOT NULL,
    user_height int, -- 자리 수 제한 없음
    entry_date date -- 회원가입
);

/* user_tbl 중에서 생년1995 이후만 복사해서 삽입하기 */
INSERT INTO user_tbl2
	SELECT * FROM user_tbl
    WHERE user_birth_year > 1995;

/* 구매내역 테이블 생성, user_tbl에 존재하는 유저만 추가할 수 이씀 */
CREATE TABLE buy_tbl (
	buy_num INT AUTO_INCREMENT PRIMARY KEY,
    user_num INT(5) NOT NULL,
    prod_name varchar(10) NOT NULL,
    prod_cate varchar(10) NOT NULL,
    price INT NOT NULL,
    amount INT NOT NULL
);

/* 외래 키 없이 추가하면 있지도 않은 이상한 회원이 추가될 수 있다. */
INSERT INTO buy_tbl VALUES(NULL, 4, '아이패드', '전자기기', 100, 1);
INSERT INTO buy_tbl VALUES(NULL, 4, '애플펜슬', '전자기기', 15, 1);
INSERT INTO buy_tbl VALUES
	(NULL, 6, '트레이닝복', '의류', 10, 1),
    (NULL, 5, '안마의자', '의료기기', 400, 1),
    (NULL, 2, 'SQL책', '도서', 2, 1);
INSERT INTO buy_tbl VALUES(NULL, 99, '핵미사일', '전략무기', 1000000, 5);
DELETE FROM buy_tbl WHERE buy_num = 6;

/* 외래 키 설정하면, user_tbl에 존재하지 않는 유저는 추가될 수 없다. */
ALTER TABLE buy_tbl ADD CONSTRAINT FK_buy_tbl
	FOREIGN KEY (user_num) REFERENCES user_tbl(user_num);

/* 만약 buy_tbl에 구매내역이 남은 회원인데, user_tbl 회원을 삭제한다면 참조 무결성 원칙에 위배되어 삭제가 안됨. */
DELETE FROM user_tbl WHERE user_num = 4;

/* 그렇다면, buy_tbl 유저넘을 먼저 삭제하고, user_tbl 유저넘을 삭제하면 된다. */
DELETE FROM buy_tbl WHERE buy_num = 1;
DELETE FROM buy_tbl WHERE buy_num = 2;
DELETE FROM user_tbl WHERE user_num = 4;

SELECT * FROM user_tbl;
SELECT * FROM buy_tbl;


