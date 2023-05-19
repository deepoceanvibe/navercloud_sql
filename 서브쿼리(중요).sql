-- 서브쿼리란 SQL문장 내에 SQL문을 포함하는 구조이다.
-- 기본적으로 SELECT문 범위를 좁힐 때 많이 사용한다.

-- 회원별 평균 키를 구하기

-- GROUP BY는 우선 동명이인을 하나의 집단으로 보기 때문에 문제가 되고, 전체 평균을 넣을 수 없어 문제가 된다.
SELECT user_name, AVG(user_height) FROM user_tbl
GROUP BY user_name;

-- 서브 쿼리를 이용하면, 해결!
SELECT user_name, (SELECT AVG(user_height) FROM user_tbl) as avg_height
FROM user_tbl;

-- FROM절 서브쿼리를 활용한 범위좁힌 시트만 뽑아냄
SELECT A.* FROM
	(SELECT * FROM user_tbl WHERE user_height < 170) A;

-- 최자바보다 키 큰 사람을 한 줄로 결과 얻기
-- 1. 최자바의 키를 WHERE절을 이용해서 확인
SELECT user_height FROM user_tbl WHERE user_name = '최자바';

-- 2. 170보다 큰 사람을 조회
SELECT * FROM user_tbl WHERE user_height > 170;

-- 3. 최자바의 키를 구해서, -> 그거보다 더 큰 사람들을 뽑기
SELECT * FROM user_tbl WHERE user_height > 
	(SELECT user_height FROM user_tbl WHERE user_name = '최자바');
    
SELECT * FROM user_tbl WHERE user_weight <
	(SELECT AVG(user_weight) FROM user_tbl);
    
SELECT * FROM user_tbl WHERE user_height >
	(SELECT max(user_height) FROM user_tbl WHERE user_address = '경기');
    
-- 전체 평균보다 키가 큰 지역에 속하는 유저만 출력하기
SELECT * FROM user_tbl -- 전체 테이블에서
	WHERE user_address IN -- user_address가 속하는
    (SELECT user_address FROM user_tbl -- 키가 큰 지역
    WHERE user_height > (SELECT AVG(user_height) FROM user_tbl) -- 전체 키 평균보다
	GROUP BY user_address);