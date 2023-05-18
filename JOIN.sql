-- JOIN 2개 이상의 테이블을 결합, 같은 내용의 컬럼이 존재해야만 사용할 수 있다.
CREATE TABLE member_tbl (
	mem_num INT PRIMARY KEY AUTO_INCREMENT,
    mem_name VARCHAR(10) NOT NULL,
    mem_addr VARCHAR(10) NOT NULL
);

CREATE TABLE purchase_tbl (
	pur_num INT PRIMARY KEY AUTO_INCREMENT,
    mem_num INT,
    pur_date DATETIME DEFAULT now(),
    pur_price INT
);

INSERT INTO member_tbl VALUES
	(NULL, '김회원', '서울'),
    (NULL, '박회원', '경기'),
    (NULL, '최회원', '제주'),
	(NULL, '박성현', '경기'),
    (NULL, '이성민', '서울'),
    (NULL, '강영호', '충북');
    
INSERT INTO purchase_tbl VALUES
	(NULL, 1, '2023-05-12', 50000 ),
    (NULL, 3, '2023-05-12', 20000 ),
    (NULL, 4, '2023-05-12', 10000 ),
    (NULL, 1, '2023-05-13', 40000 ),
    (NULL, 1, '2023-05-14', 30000 ),
    (NULL, 3, '2023-05-14', 30000 ),
    (NULL, 5, '2023-05-14', 50000 ),
    (NULL, 5, '2023-05-15', 60000 ),
    (NULL, 1, '2023-05-15', 15000 );
    
SELECT * FROM member_tbl;
SELECT * FROM purchase_tbl;

-- JOIN 하기
SELECT member_tbl.mem_num, member_tbl.mem_name, member_tbl.mem_addr,
	purchase_tbl.pur_date, purchase_tbl.pur_num, purchase_tbl.pur_price
FROM member_tbl INNER JOIN purchase_tbl
ON member_tbl.mem_num = purchase_tbl.mem_num;

SELECT user_tbl.user_name, user_tbl.user_address, user_tbl.user_num,
	buy_tbl.buy_num, buy_tbl.prod_name, buy_tbl.prod_cate, buy_tbl.price, buy_tbl.amount
FROM user_tbl INNER JOIN buy_tbl
ON user_tbl.user_num = buy_tbl.user_num;

-- 테이블명을 전부 적으면 귀찮기 떄문에, 테이블명을 별칭으로 줄여서 써보자.
-- FROM 절에서 테이블명을 지정할 때, ' FROM 테이블명 별칭1 JOIN 테이블명 별칭2 '
SELECT m.mem_num, m.mem_name, m.mem_addr,
	p.pur_date, p.pur_num, p.pur_price
FROM member_tbl m INNER JOIN purchase_tbl p
ON m.mem_num = p.mem_num;

SELECT u.user_name, u.user_address, u.user_num,
	b.buy_num, b.prod_name, b.prod_cate, b.price, b.amount
FROM user_tbl u INNER JOIN buy_tbl b
ON u.user_num = b.user_num;

-- LEFT JOIN : 왼쪽테이블 모든 데이터 + 반대쪽 테이블 교집합만
SELECT m.mem_num, m.mem_name, m.mem_addr,
	p.pur_date, p.pur_num, p.pur_price
FROM member_tbl m RIGHT JOIN purchase_tbl p
ON m.mem_num = p.mem_num;

INSERT INTO purchase_tbl VALUES
	(NULL, 8, '2023-05-16', 25000),
    (NULL, 9, '2023-05-16', 25000),
    (NULL, 8, '2023-05-17', 35000);
    
SELECT * FROM purchase_tbl;

-- RIGHT JOIN 데이터 생성
INSERT INTO purchase_tbl VALUES
	(NULL, 8, '2023-05-16', 25000),
    (NULL, 9, '2023-05-16', 25000),
    (NULL, 8, '2023-05-17', 35000);
    
-- MySQL에서는 FULL OUTER JOIN을 지원하지 않는다.
-- 따라서 UNION 이라는 구문을 이용해 처리한다.

-- 조인할 컬럼 명이 동일하다면, ON 대신 USING(공통컬럼명) 구문을 대신 써도 된다.
SELECT m.mem_num, m.mem_name, m.mem_addr,
	p.pur_date, p.pur_num, p.pur_price
FROM member_tbl m RIGHT JOIN purchase_tbl p
USING (mem_num);

-- CROSS JOIN은 조인 대상인 테이블1과 테이블2간의 모든 ROW 조합쌍 (경우의 수)을 출력한다.
-- ROW 개수 : (테이블1 ROW 개수) * (테이블2 ROW 개수)
SELECT * FROM
	user_tbl, buy_tbl;
    
-- user_tbl 로우 10개, buy_tbl 로우 3개 -> 크로스조인 로우 30개
SELECT COUNT(*) FROM
	user_tbl CROSS JOIN buy_tbl;

CREATE TABLE phone_volume (
	volume VARCHAR(5),
    model_name VARCHAR(10)
);

CREATE TABLE phone_color (
	color VARCHAR(5)
);

INSERT INTO phone_volume VALUES
	(128, 'galaxy'),
    (256, 'galaxy'),
    (512, 'galaxy'),
    (128, 'iphone'),
    (256, 'iphone'),
    (512, 'iphone');
    
INSERT INTO phone_color VALUES
	('빨간색'),    
    ('파란색'),
    ('노란색'), 
    ('회색');
    
SELECT * FROM phone_volume CROSS JOIN phone_color;

-- SELF 조인은 자기 테이블 내부 자료를 참조하는 컬럼이 있을 때 사용함.
CREATE TABLE staff (
	staff_num INT AUTO_INCREMENT PRIMARY KEY,
    staff_name VARCHAR(20),
    staff_job VARCHAR(20),
    staff_salary INT,
    staff_supervisor INT
);

INSERT INTO staff VALUES
	(NULL, '설민경', '개발', 30000, NULL),
    (NULL, '윤동석', '총무', 25000, NULL),
    (NULL, '하영선', '인사', 18000, NULL),
    (NULL, '오진호', '개발', 5000, 1),
    (NULL, '류민지', '개발', 4500, 4),
    (NULL, '권기남', '총무', 4000, 2),
    (NULL, '조예지', '인사', 3200, 3),
    (NULL, '배성은', '개발', 3500, 5);

-- SELF JOIN 을 이용해 직원 이름과 상사 이름을 같이 나오게 만들어보겠습니다.
SELECT
	l.staff_name as 상급자이름, r.staff_name as 하급자이름
FROM
	staff as l INNER JOIN staff as r
ON
	l.staff_num = r.staff_supervisor; -- 이게 JOIN 조건임
    
