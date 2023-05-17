-- user_tbl에 소수점 아래를 저장받을수 있는 컬럼을 추가해보겠습니다.
-- DECIMAL은 고정자리수이므로 반드시 소수점 아래 2자리까지 표시해야 합니다.
-- 전체 3자리중 소수점아래에 두 자리를 배정하겠다.
ALTER TABLE user_tbl ADD (user_weight DECIMAL(3, 2));
ALTER TABLE user_tbl MODIFY user_weight DECIMAL(5, 2);


SELECT * FROM user_tbl;

UPDATE user_tbl SET user_weight = 52.12 WHERE user_num=10;

-- 숫자 함수 사용 예제
SELECT
	user_name, user_weight,
    ROUND(user_weight, 0) AS 키반올림,
    TRUNCATE(user_weight, 1) AS 키소수점아래_1자리절사,
    MOD(user_height, 150) AS 키_150으로나눈나머지,
    CEIL(user_weight) AS 키올림,
    FLOOR(user_weight) AS 키내림,
    SIGN(user_weight) AS 양수음수_0여부,
    SQRT(user_height) AS 키_제곱근
FROM
	user_tbl;

-- user_tbl의 날짜를 확인합니다.
SELECT * FROM user_tbl;

-- 날짜함수를 활용한 예제
SELECT
	user_name, entry_date,
    DATE_ADD(entry_date, INTERVAL 50 DAY) AS _3개월후,
    LAST_DAY(entry_date) AS 해당월마지막날짜,
    TIMESTAMPDIFF(YEAR, entry_date, STR_TO_DATE('2020-08-01')) AS 오늘과의개월수차이
FROM
	user_tbl;
-- 현재 시각을 조회하는 구문
SELECT now();

SELECT * FROM user_tbl;

-- 변환함수를 활용한 예제
SELECT
	user_num, user_name, entry_date,
    DATE_FORMAT(entry_date, '%Y%m%d') AS 일자표현변경,
    CAST(user_num AS CHAR) AS 문자로바꾼회원번호
FROM
	user_tbl;

-- user_height, user_weight이 NULL인 자료를 추가해보겠습니다.
INSERT INTO user_tbl VALUES(null, '임쿼리', 1986, '제주', null, '2021-01-03', null);	

SELECT * FROM user_tbl;

-- NULL에다가 특정 숫자 곱하기
SELECT 0 * null; -- 일반직군
SELECT 10000000 * 0.1; -- 영업직군

-- 최종수령금액은 기본급 + 인센
SELECT null + 5000000;
SELECT 1000000 + 5000000;

-- user_tbl 테이블 조회
SELECT * FROM user_tbl;

-- ifnull() 을 이용해서 특정 컬럼이 null인경우 대체값으로 표현하는 예제
SELECT
	user_name, 
    ifnull(user_height, 167) as _null대체값넣은키, 
    ifnull(user_weight, 65) as _null대체값넣은체중
FROM 
	user_tbl;

-- SQL에서 0으로 나누면 무슨일이 벌어지는지 보겠습니다.
SELECT 3 / 0;

SELECT * FROM user_tbl;
-- user_tbl의 회원들 중 키 기준으로 
-- 165 미만은 평균미만, 165는 평균, 165이상은 평균이상으로 출력해보겠습니다.
SELECT
	user_name,
    user_height,
    CASE
		WHEN user_height < 164 THEN '평균미만'
        WHEN user_height = 164 THEN '평균'
        WHEN user_height > 164 THEN '평균이상'
	END AS 키분류,
    user_weight
FROM user_tbl;

-- 문제
-- user_tbl에 대해서, BMI지수를 구해주세요.
-- BMI지수는 (체중 / 키M의제곱)으로 구할 수 있습니다.
-- BMI 지수의 결과를 18 미만이면 '저체중', 18 ~ 24면 '일반체중', 25이상이면 '고체중' 으로
-- CASE 구문을 이용해서 출력해주세요.
-- BMI 지수를 나타내는 컬럼은 BMI_RESULT이고, BMI 분류를 나타내는 컬럼은 BMI_CASE입니다.
SELECT
	user_name, user_height, user_weight,
    user_weight / POW(user_height / 100, 2) as BMI_RESULT,
    CASE
		WHEN user_weight / POW(user_height / 100, 2) < 18 THEN '저체중'
        WHEN user_weight / POW(user_height / 100, 2) BETWEEN 18 AND 24 THEN '일반체중'
        WHEN user_weight / POW(user_height / 100, 2) > 24 THEN '고체중'
	END AS BMI_CASE
FROM
	user_tbl;


-- GROUP BY는 기준컬럼을 하나 이상 제시할 수 있고, 기준컬럼에서 동일한 값을 가지는 것 끼리
-- 같은 집단으로 보고 집계하는 쿼리문입니다.
-- SELECT 집계컬럼명 FROM 테이블명 GROUP BY 기준컬럼명;

-- 지역별 평균 키를 구해보겠습니다(지역정보 : user_address)
SELECT
	user_address AS 지역명,
	AVG(user_height) AS 평균키
FROM 
	user_tbl
GROUP BY
	user_address;

-- 생년별 인원수와 체중 평균을 구해주세요.
-- 생년, 인원수, 체중평균 컬럼이 노출되어야 합니다.
SELECT 
	user_birth_year,
    COUNT(user_num) as 인원수, -- COUNT는 컬럼 내부의 열 개수만 세기때문에 어떤 컬럼을 넣어도 동일합니다.
    avg(user_weight) as 체중평균
FROM
	user_tbl
GROUP BY
	user_birth_year;

-- user_tbl의 가장 큰 키, 가장 빠른출생년도가 각각 무슨값인지 구해주세요.
SELECT
	max(user_height) AS 가장큰키수치,
    min(user_birth_year) AS 가장빨리태어난사람년도,
    min(entry_date) AS 가입일자가장빠른사람
FROM 
	user_tbl;

-- HAVING을 써서 거주자가 2명이상인 지역만 카운팅
-- 거주지별 생년평균을 보여주겠습니다.
SELECT 
	user_address,
	AVG(user_birth_year) as 생년평균,
    COUNT(*) as 거주자수
FROM
	user_tbl
GROUP BY
	user_address
HAVING
	COUNT(*) > 1;

-- HAVING 사용 문제
-- 생년 기준으로 평균 키가 160 이상인 생년만 출력해주세요.
-- 생년별 평균 키도 같이 출력해주세요.
SELECT
	user_birth_year,
	AVG(user_height) as 평균키
FROM
	user_tbl
GROUP BY
	user_birth_year
HAVING
	AVG(user_height) >= 160;
