/* 실행은 ctrl + enter
데이터 베이스 생성 명령
데이터베이스 내부에 테이블들이 적재되기 때문에 먼저
데이터베이스를 생성해야 합니다.
DEFAULT CHARACTER SET UTF8; 을 붙여주면 한글 설정이 된다.alter내가 지정하는 이름 등을 제외한 쿼리문은 대문자로만 작성하는게 일반적이다. */
CREATE DATABASE bitcamp06 DEFAULT CHARACTER SET UTF8;

/* 데이터베이스 조회는 좌측 Schemas를 클릭하고 새로고침 -> bitcamp06이 생성된게 확인되면 우클릭 -> set as default schemas
선택시 볼드처리 되고, 지금부터 적는 쿼리문은 해당 DB에 들어간다는 의미. */
/* 해당 DB에 접근할 수 있는 사용자 계정 생성 
USER - id역할, IDENTIFIED BY - pw역할 */
CREATE USER 'adminid' IDENTIFIED BY '2023502';

/* 사용자에게 권한 부여 : GRANT 주고싶은기능1, 기능2,... 
만약 모든 권한을 주고 싶다면 ALL PRIVELEGES(모든권한) TO 부여받을계정명 */
GRANT ALL PRIVILEGES ON bitcamp06.* to 'adminid';

/* 테이블 생성 명령
PRIMARY KEY : 컬럼의 주요 키를 뜻하고, 중복 데이터 방지도 겸함
모든 테이블의 컬럼 중 하나는 반드시 PK 속성이 부여되어 있어야 함.
NOT NULL : 해당 컬럼을 비워둘 수 없다는 의미
UNIQUE : 중복 데이터가 입력되는 것을 방지함 */
CREATE TABLE users(
	u_number INT(3) PRIMARY KEY,
	u_id VARCHAR(20) UNIQUE NOT NULL,
    u_name VARCHAR(30) NOT NULL,
    email VARCHAR(80)
);

/* 데이터 적재
INSERT INTO 테이블명(컬럼1, 컬럼2...) VALUES(값1, 값2...);
만약 모든 컬럼에 값을 넣는다면 위 구문에서 테이블명 다음 오는 컬럼명을 생략할 수 있음.
*/
INSERT INTO users(u_number, u_id, u_name, email) VALUES
	(1, 'abc1234', '가나다', NULL);
INSERT INTO users VALUES (2, 'abc3456', '마바사', 'abc@ab.com');

/* 데이터 조회
SELECT * FROM 테이블명; 을 적으면
해당 테이블에 적재된 테이터를 조회할 수 있다.
SELECT (컬럼명1, 컬럼명2...) FROM 테이블명;
을 이용해서 특정 컬럼에 적재된 데이터만 조회할 수도 있다.
use 구문으로 데이터베이스를 지정한 경우에는 데이터베이스를 생략할 수 있다. */
SELECT * FROM bitcamp06.users; -- 거의 안씀
SELECT * FROM users;


/* 계정을 하나 더 만들어보겠습니다.
이번 계정은 SELECT 권한 줘보기 */
CREATE USER 'adminid2' IDENTIFIED BY '2023502'; 
GRANT SELECT ON bitcamp06.* to 'adminid2';

/* users 테이블에 주소 컬럼을 추가하기 */
ALTER TABLE users ADD (u_address varchar(30));
SELECT * FROM users;

/* users 테이블에 이메일 컬럼을 삭제하기 */
ALTER TABLE users DROP COLUMN email;
SELECT * FROM users;

/* users 테이블에 address 에 unique 제약조건 걸기 */
ALTER TABLE users ADD CONSTRAINT u_address_unique UNIQUE (u_address);
INSERT INTO users VALUES (7, 'sss22','룰루','강남구');

/* users 테이블에 address 에 unique 제약조건 풀기 */
ALTER TABLE users DROP CONSTRAINT u_address_unique;
INSERT INTO users VALUES (8, 'sss33','팔팔','강남구');
SELECT * FROM users;

/* users 테이블명 바꾸기 */
RENAME TABLE users to members;
SELECT * FROM members;

/* 테이블 내 데이터만 소각, 트랜잭션과 롤백 불가능 */
TRUNCATE TABLE members;
SELECT * FROM members;

/* 테이블 자체를 소각, 트랜잭션과 롤백 가능 */
DROP TABLE members;