/*
    DDL : 데이터 정의언어 
    
    객체 생성(CREATE), 변경(ALTER), 삭제(DROP)하는 구문    
*/
/*
    ALTER : 객체를 변경하는 구문
    
    ALTER TABLE 테이블명 변경할 내용
    
    * 변경되는 내용 *
      - 제약조건 추가/수정(삭제 -> 추가)/삭제
      - 컬럼명/제약조건명/테이블명 변경
      - 컬럼 추가/수정/삭제
*/
/*
    * 컬럼 추가/수정/삭제
    
    - 컬럼 추가 : ALTER TABLE 테이블명 ADD 컬럼명 자료형 [기본값|제약조건];
*/
-- DEPT_TABLE 테이블에 CNAME VARCHAR2(20) 컬럼 추가
ALTER TABLE DEPT_TABLE ADD CNAME VARCHAR2(20);
SELECT * FROM DEPT_TABLE;

ALTER TABLE DEPT_TABLE ADD LNAME VARCHAR2(20) DEFAULT '한국';
SELECT * FROM DEPT_TABLE;

/*
    컬럼 수정 (MODIFY)
    - 데이터 타입 수정 ; ALTER TABLE 테이블명 MODIFY 컬럼명 변경할데이터타입
    - 기본값 수정 : ALTER TABLE 테이블명 MODIFY 컬럼명 DEFAULT 변경할 기본값
*/

-- DEPT_TABLE 테이블의 DEPT_ID 컬럼을 변경
ALTER TABLE DEPT_TABLE MODIFY DEPT_ID CHAR(5);

-- * 숫자 타입으로 변경
-- ALTER TABLE DEPT_TABLE MODIFY DEPT_ID NUMBER; --> 형식 오류 발생 (기존: 문자타입, 변경: 숫자타입) X
-- DEPT_TABLE 테이블의 DEPT_TITLE 컬럼을 변경
-- * 크기를 35바이트 -> 10바이트로 변경
-- ALTER TABLE DEPT_TABLE MODIFY DEPT_TITLE VARCHAR(10); --> 크기 오류 발생!

-- * 크기를 35바이트 -> 50바이트로 변경
ALTER TABLE DEPT_TABLE MODIFY DEPT_TITLE VARCHAR(50);

-- EMP_TABLE 테이블의 SALARY 컬럼을 VARCHAR2(50)으로 변경
-- ALTER TABLE EMP_TABLE MODIFY SALARY VARCHAR2(50); --> 형식 오류 발생

-- 여러 개의 컬럼 변경 가능
ALTER TABLE DEPT_TABLE
    MODIFY DEPT_TITLE VARCHAR2(55)
    MODIFY LNAME DEFAULT '코리아';

/*
    컬럼 삭제 : DROP COLUMN
    
    ALTER TABLE 테이블명 DROP COLUMN 컬럼명
*/
CREATE TABLE DEPT_COPY
AS SELECT * FROM DEPT_TABLE;

SELECT * FROM DEPT_COPY;

ALTER TABLE DEPT_COPY DROP COLUMN LNAME;
SELECT * FROM DEPT_COPY;
ALTER TABLE DEPT_COPY DROP COLUMN CNAME;
SELECT * FROM DEPT_COPY;
ALTER TABLE DEPT_COPY DROP COLUMN LOCATION_ID;
SELECT * FROM DEPT_COPY;
ALTER TABLE DEPT_COPY DROP COLUMN DEPT_TITLE;
SELECT * FROM DEPT_COPY;
ALTER TABLE DEPT_COPY DROP COLUMN DEPT_ID; -- 오류 발생!
--> 테이블에는 최소한 한 개의 컬럼은 존재해야 함
--------------------------------------------------------------------------------
-- 제약조건 추가/삭제 (수정 : 삭제 -> 추가)
/*
    * 기본키 (PRIMARY KEY) : ALTER TABLE 테이블명 ADD PRIMARY KEY (컬럼명)
    * 외래키 (FROEIGN KEY) : ALTER TABLE 테이블명 ADD FOREIGN KEY (컬럼명) REFERENCES 참조할 테이블명[(참조할 컬럼명)]
    * UNIQUE (중복을 허용하지 않는 제약조건) : ALTER TABLE 테이블명 ADD UNIQUE(컬럼명)
    * CHECK (특정 값들만 저장하고자 할 때 사용하는 제약조건, NULL값 가능) : ALTER TABLE 테이블명 ADD CHECK(컬럼에 대한 조건식)
    * NOT NULL (NULL 값을 허용하지 않는 제약조건) : ALTER TABLE 테이블명 MODIFY 컬럼명 NOT NULL
*/
-- DEPT_TABLE 테이블에 아래 제약조건 추가
-- * DEPT_ID 컬럼에 PRIMARY KEY(기본키) 제약조건 추가
-- * DEPT_TITLE 컬럼에 UNIQUE 제약조건 추가
-- * LNAME 컬럼에 NOT NULL 제약조건 추가

ALTER TABLE DEPT_TABLE
    ADD CONSTRAINT DT_PK PRIMARY KEY (DEPT_ID)
    ADD CONSTRAINT DT_UQ UNIQUE (DEPT_TITLE)
    MODIFY LNAME NOT NULL;
    
/*
    [제약조건 삭제]
    ALTER TABLE 테이블명 DROP CONSTRAINT 제약조건명 / NOT NULL은 예외
    ALTER TABLE 테이블명 MODIFY 컬럼명 NULL
*/

ALTER TABLE DEPT_TABLE DROP CONSTRAINT SYS_C008480;
ALTER TABLE DEPT_TABLE DROP CONSTRAINT SYS_C008481;
ALTER TABLE DEPT_TABLE MODIFY LNAME NULL;

--------------------------------------------------------------------------------

-- 테이블 삭제...!
-- DROP TABLE 테이블명
DROP TABLE DEPT_TABLE;
--> 어딘가에 참조되고 있는 부모테이블은 삭제가되지 않음
-- 지우고자 할 경우, 1) 자식테이블을 먼저 삭제한 후 부모테이블을 삭제
--                  2) 부모테이블만 삭제하는데, 제약조건까지 삭제
--                      DROP TABLE 테이블명 CASCADE CONSTRAINT
--------------------------------------------------------------------------------
CREATE TABLE DEPT_TABLE
AS SELECT * FROM DEPARTMENT;

/*
    컬럼명, 제약조건명, 테이블명 변경 (RENAME)
*/

-- 1) 컬럼명 변경 : RENAME COLUMN 기존컬럼명 TO 바꿀컬럼명
-- DEPT_TITLE --> DEPT_NAME 변경
ALTER TABLE DEPT_TABLE  RENAME COLUMN DEPT_TITLE TO DEPT_NAME;

SELECT * FROM DEPT_TABLE;

-- 2) 제약조건명 변경 : RENAME CONSTRAINT 기존 제약조건명 TO 바꿀 제약조건명 
ALTER TABLE DEPT_TABLE RENAME CONSTRAINT SYS_C008482 TO DT_DEPTID_NN;


-- 3) 테이블명 변경 : RENAME TO 바꿀 테이블명
ALTER TABLE DEPT_TABLE RENAME TO DEPT_END;
--------------------------------------------------------------------------------
-- * TRUNCATE : 테이블 초기화
--   => DROP과는 다르게 테이블의 데이터만을 전부 삭제하여 테이블의 초기상태로 돌려주는 것
SELECT * FROM DEPT_END;
TRUNCATE TABLE DEPT_END;










