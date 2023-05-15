-- 트랜잭션은 각종 쿼리문의 실행을 되돌리거나 영구히 반영할 때 사용한다.
-- 연습 테이블 생성
CREATE TABLE bank_account(
	act_num INT(5) PRIMARY KEY AUTO_INCREMENT,
    act_owner varchar(10) NOT NULL,
    balance INT(10) NOT NULL
);

-- 계좌 데이터 2개 집어넣기
INSERT INTO bank_account
	VALUES (NULL, '나구매', 50000),
			(NULL, '가판매', 0);
            
-- 트랜잭션 시작 (세이브포인트)
START TRANSACTION;

-- 나구매의 돈 3만원 차감
UPDATE bank_account SET balance = balance - 30000 WHERE act_owner = '나구매';
-- 가판매의 돈 3만원 증가
UPDATE bank_account SET balance = balance + 30000 WHERE act_owner = '가판매';

-- 롤백하면 전체 다 취소됨 -> START TRANSACTION 다시 해야함
ROLLBACK;

SELECT * FROM bank_account;

START TRANSACTION;
UPDATE bank_account SET balance = balance - 25000 WHERE act_owner = '나구매';
UPDATE bank_account SET balance = balance + 25000 WHERE act_owner = '가판매';

COMMIT; -- 최종 반영, 이제 못돌아감

-- SAVEPOINT는 rollback 해당 지점 전까지는 반영, 해당 지점 이후는 반영 안하는 경우 사용한다.
START TRANSACTION;

UPDATE bank_account SET balance = balance - 3000 WHERE act_owner = '나구매';
UPDATE bank_account SET balance = balance + 3000 WHERE act_owner = '가판매';

-- first_tx 라는 세이브파일 새로 생성 -> 로드파일1(위에 업데이트 2개 반영안됨), 로드파일2(위에 업데이트2개 반영됨) 선택할수있음
SAVEPOINT first_tx;

UPDATE bank_account SET balance = balance - 5000 WHERE act_owner = '나구매';
UPDATE bank_account SET balance = balance + 5000 WHERE act_owner = '가판매';

-- first_tx 로드파일 불러오기
ROLLBACK to first_tx;