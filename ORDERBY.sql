-- ORDER BY 는 SELECT문의 질의 결과를 '정렬'할 때 사용한다.
-- ORDER BY 절 다음에는 어떤 컬럼을 기준으로 어떤 방식으로 정렬할지 적어줘야 한다.

SELECT * FROM user_tbl ORDER BY user_height DESC;

SELECT user_height, user_weight
FROM user_tbl
ORDER BY user_height ASC, user_weight DESC;

-- 이름 가나다라 순으로 정렬하고, un 이라는 별칭을 사용해보자.
SELECT user_num, user_name AS un, user_birth_year, user_address
	FROM user_tbl
	ORDER BY un ASC;
    
-- 컬럼 번호를 이용해서도 정렬 가능 (user_num = 1, user_name = 2, user_birth_year = 3, user_address = 4)
SELECT user_num, user_name AS un, user_birth_year, user_address
	FROM user_tbl
	ORDER BY 3 ASC;
    
-- 지역별 키 평균을 내림차순으로 정렬해라
SELECT user_address, AVG(user_height) AS average_height
FROM user_tbl
GROUP BY user_address
ORDER BY average_height DESC;

-- '특정 조건에만' 오름차순이나 내림차순 정렬 적용하기 / 지역 컬럼에서 '경기만 user height 기준'으로 정렬해라.
SELECT user_name, user_birth_year, user_address, user_height, user_weight
	FROM user_tbl 
ORDER BY
	CASE user_address
    WHEN '경기' THEN user_height
    ELSE NULL
END DESC;

-- 문제 1992 사람은 키 오름차순, 1998 사람은 이름 오름차순
SELECT user_name, user_height, user_birth_year
	FROM user_tbl
ORDER BY
	CASE user_birth_year
    WHEN 1992 THEN user_height
    WHEN 1998 THEN user_name
    ELSE NULL
END ASC;