SELECT * FROM user_tbl;
SELECT * FROM user_tbl WHERE user_address = '서울' OR user_address = '경기';

-- IN 문법은 조건식을 더 간단하게 해준다.
SELECT * FROM user_tbl WHERE user_address IN ('서울','경기');

-- buy_tbl 유저'번호'(FK)를 -> user_tbl에 동일한 FK 찾아서 출력하는건가???
SELECT * FROM user_tbl WHERE user_num IN (SELECT user_num FROM buy_tbl);

-- like 구문은 패턴 일치 여부를 통해서 조회한다.
-- %는 와일드카드 문자로, 앞에 올 글자수 상관없이 끝자리만 맞으면 됨.
-- _는 와일드카드 문자로, 앞에 올 글자수만큼 _를 붙인다.
SELECT * FROM user_tbl WHERE user_name LIKE '%희';
SELECT * FROM user_tbl WHERE user_address LIKE '%경기';
SELECT * FROM user_tbl WHERE user_name LIKE '_자바';

-- BETWEEN 범위를 지정할 때 사용
SELECT * FROM user_tbl WHERE user_height BETWEEN 170 AND 180;
SELECT * FROM user_tbl WHERE user_height > 169 AND user_height < 181;

-- NULL을 가지는 데이터 생성
INSERT INTO user_tbl VALUES
(NULL, '박진영', 1990, '제주', NULL, '2020-10-01'),
(NULL, '김혜경', 1992, '강원', NULL, '2020-10-02'),
(NULL, '신지수', 1993, '서울', NULL, '2020-10-05');
SELECT * FROM user_tbl WHERE user_height IS NULL;