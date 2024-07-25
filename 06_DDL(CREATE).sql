/*
    DDL : 데이터 정의 언어
    
    오라클에서 제공하는 객체를 새로 만들고(CREATE)
                        구조를 변경하고(ALTER)
                        구조 자체를 삭제하는 언어(DROP)
    => 실제 데이터가 아닌 규칙을 정의하는 언어
    
    * 오라클에서의 객체(구조) : 테이블, 뷰, 시퀀스
                             인덱스, 패키지, 트리거,
                             프로시저, 함수, 동의어, 사용자
                             
                             
*/
-- * CREATE : 객체를 새로 생성하는 구문
/*
    테이블 생성하기
    => 테이블: 행과 열로 구성되는 가장 기본적인 데이터베이스 객체
              모든 데이터들은 테이블을 통해 저장됨
              
    CREATE TABLE 테이블명(
        컬럼명 자료형(크기),
        컬럼명 자료형,
        컬럼명 자료형,
        ...
    )
    
    - 자료형
            * 문자 => 반드시 크기 지정을 해줘야 함
                + CHAR(바이트 크기) : 고정 길이(고정된 길이의 데이터를 담을 경우)
                                    -> 지정한 길이보다 작은 값이 들어올 경우 공백으로 채워서 저장
                                    최대 2000바이트까지 지정 가능
                + VARCHAR2(바이트 크기) : 가변 길이(데이터의 길이가 정해져있지 않는 경우)
                                    -> 저장되는 데이터 길이만큼만 공간 크기가 사용됨
                                    최대 4000바이트까지 지정 가능
            * 숫자 : NUMBER
            * 날짜 : DATE
*/
-- 회원 정보를 저장할 테이블 : MEMBER
/*
    - 회원번호          : 숫자(NUMBER)
    - 회원아이디         : 문자(VARCHAR2(20))
    - 회원 비밀번호       : ANSWK (VARCHAR2(20))
    - 회원이름           : 문자(VARCHAR2(20))
    - 성별               : 문자 - '남'/'여' (CHAR(3))
    - 연락처              : 문자 - (CHAR(13))
    - 이메일               : 문자 - (VARCHAR2(50))
    - 가입일               : 날짜 - (DATE)
*/
CREATE TABLE MEMBER (
    MEM_NO NUMBER,
    MEM_ID VARCHAR2(20),
    MEM_PWD VARCHAR2(20),
    MEM_NAME VARCHAR2(20),
    GENDER CHAR(3),
    PHONE CHAR(13),
    EMAIL VARCHAR2(50),
    JOIN_DATE DATE
);



-- MEMBER 테이블 조회
SELECT * FROM MEMBER;
--------------------------------------------------------------------------------
/*
    컬럼에 설명 추가하기
    
    COMMENT ON COLUM 테이블명.컬럼명 IS '설명내용';
    * 잘못 작성했을 경우 다시 작성 후 실행 => 덮어씌워짐
*/
COMMENT ON COLUMN MEMBER.MEM_NO IS '회원번호';
COMMENT ON COLUMN MEMBER.MEM_ID IS '회원아이디';
COMMENT ON COLUMN MEMBER.MEM_PWD IS '회원비밀번호';
COMMENT ON COLUMN MEMBER.MEM_NAME IS '회원이름';
COMMENT ON COLUMN MEMBER.GENDER IS '성별';
COMMENT ON COLUMN MEMBER.PHONE IS '연락처';
COMMENT ON COLUMN MEMBER.EMAIL IS '이메일';
COMMENT ON COLUMN MEMBER.JOIN_DATE IS '가입일';

-- 테이블 삭제하기 : DROP TABLE 테이블명;
-- DROP TABLE MEMBER;

-- 테이블에 데이터 추가하기 : INSERT INTO 테이블명 VALUES(값, 값, 값, ...)
INSERT INTO MEMBER VALUES (1, 'YSL', '1234', '이요셉', '남', '010-1234-1234', 'twwt0912@naver.com', SYSDATE);

SELECT * FROM MEMBER;

INSERT INTO MEMBER VALUES(2, 'DAWUN', '1234','기다운' ,'남', NULL, NULL, SYSDATE);

INSERT INTO MEMBER VALUES(NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

COMMIT;
--------------------------------------------------------------------------------
/*
    제약조건 : 원하는 데이터값만 유지하기 위해서 특정 컬럼에 설정하는 제약
              데이터 무결성을 보장하기 위한 목적
              
    * 설정 방식 : 컬럼레벨방식 / 테이블레벨방식
              
    * 종류 : NOT NULL, UNIQUE, CHECK, PRIMARY KEY, FOREIGN KEY
*/

/*
    NOT NULL 제약조건
    : 해당 컬럼에 반드시 값이 존재해야 하는 경우 설정하는 제약
      => 절대로 NULL값이 저장되면 안되는 경우
      
    * 데이터 추가(삽입) / 수정 시 NULL값을 허용하지 않음
    * 컬럼 레벨 방식으로만 설정 가능
*/
-- NOT NULL 조건을 추가한 회원 테이블 : MEMBER_NOTNULL
-- 회원 번호, 아이디, 비밀번호, 이름에 대한 데이터는 NULL값을 저장하지 않음
CREATE TABLE MEMBER_NOTNULL (
    MEM_NO NUMBER NOT NULL,
    MEM_ID VARCHAR2(20) NOT NULL,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3),
    PHONE CHAR(13),
    EMAIL VARCHAR2(50),
    JOIN_DATE DATE
);

SELECT * FROM MEMBER_NOTNULL;

INSERT INTO MEMBER_NOTNULL
    VALUES (1, 'DAWUN', '1234', '기다운', '남', '010-1234-1234', 'DAWUNI@GMAIL.COM', SYSDATE);


INSERT INTO MEMBER_NOTNULL
    VALUES (2, 'QWER', '1234', 'QWER', '여', NULL, NULL, NULL);

INSERT INTO MEMBER_NOTNULL
    VALUES (3, NULL, '1234', 'QQQ', '남', NULL, NULL, NULL);
--> 설정한대로 회원아이디 부분에 데이터가 NULL값이라서 오류가 발생! (제약조건이 위배됨)

INSERT INTO MEMBER_NOTNULL
    VALUES (1, 'DAWUN', '1234', '기다운', '남', '010-1234-1234', 'DAWUNI@GMAIL.COM', SYSDATE);
--> 중복되는 데이터가 있음에도 추가가 잘 되었다.... (곤란하다..)
--------------------------------------------------------------------------------
/*
    UNIQUE 제약 조건
    : 해당 컬럼에 중복된 값이 있을 경우 제한하는 제약조건
    
    * 데이터 추가(삽입)/수정 시 기존에 있는 데이터 값 중에 중복되는 값이 있을 경우 오류 발생시킴
*/

CREATE TABLE MEMBER_UNIQUE (
    MEM_NO NUMBER NOT NULL,
    MEM_ID VARCHAR2(20) NOT NULL UNIQUE, -- 컬럼 레벨 방식
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3),
    PHONE CHAR(13),
    EMAIL VARCHAR2(50),
    JOIN_DATE DATE
    
   -- , UNIQUE(MEM_ID) -- 테이블 레벨 방식
);

SELECT * FROM MEMBER_UNIQUE;


INSERT INTO MEMBER_UNIQUE
    VALUES (1, 'KIDAWUN', '1234', '기다운', '남', '010-1234-1234', 'DAWUNI@GMAIL.COM', SYSDATE);
    
INSERT INTO MEMBER_UNIQUE
    VALUES (2, 'KIDAWUN', '9999', '다우니', '여', NULL, NULL, NULL);
-- UNIQUE 제약조건에 위배되어 데이터 추가 실패
--> 오류 내용에 제약조건명으로 알려줌(알아보기가 어렵다..)
--> 제약조건 설정 시 제약조건명을 지정하지 않으면 시스템에서 알아서 이름을 부여함
--------------------------------------------------------------------------------
/*
    제약 조건명 설정하기
    * 컬럼 레벨 방식
        CREATE TABLE 테이블명 (
            컬럼명 자료형 [CONSTRAINT 제약조건명] 제약조건
        );
    * 테이블 레벨 방식
        CREATE TABLE 테이블명 (
            컬럼명 자료형,
            컬럼명 자료형,
            컬럼명, 자료형
            
            [CONSTRAINT 제약조건명] 제약조건 (컬럼명)
        );
*/
-- MEMBER_UNIQUE 테이블 삭제

DROP TABLE MEMBER_UNIQUE;


CREATE TABLE MEMBER_UNIQUE (
    MEM_NO NUMBER CONSTRAINT MEM_NO_NT NOT NULL,
    MEM_ID VARCHAR2(20) CONSTRAINT MEMID_NT NOT NULL, -- 컬럼 레벨 방식
    MEM_PWD VARCHAR2(20) CONSTRAINT MEMPWD_NT NOT NULL,
    MEM_NAME VARCHAR2(20) CONSTRAINT MEMNAME_NT NOT NULL,
    GENDER CHAR(3),
    PHONE CHAR(13),
    EMAIL VARCHAR2(50),
    JOIN_DATE DATE
    
    , CONSTRAINT MEMID_UQ UNIQUE(MEM_ID) -- 테이블 레벨 방식
);

INSERT INTO MEMBER_UNIQUE
    VALUES (1, 'DAWUNI', '1234', '기다운', '남', '010-1234-1234', 'KIDAWUN@GMAIL.COM', SYSDATE);

INSERT INTO MEMBER_UNIQUE
    VALUES (2, 'QWER', '1234', 'QWER', '여', NULL, NULL, NULL);

INSERT INTO MEMBER_UNIQUE
    VALUES (3, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

INSERT INTO MEMBER_UNIQUE
    VALUES (4, 'DAWUNI', '1234', '기다운', '여', NULL, NULL, NULL);

------------------------------ 24 / 07 / 25  복습 -------------------------------

-- 다음 사용자 계정 접속 후 아래 내용을 작성해주세요.
-- ID/PW  :  C##TESTUSER / 1234
CREATE USER "C##TESTUSER" IDENTIFIED BY 1234;


-- 아래 내용을 추가하기 위한 테이블을 생성해주세요.
-- 각 컬럼별 설명을 추가해주세요.
--=========================================================
/*
	- 학생 정보 테이블 : STUDENT
	- 제약 조건
	  - 학생 이름, 생년월일은 NULL값을 허용하지 않는다.
	  - 이메일은 중복을 허용하지 않는다.
	- 저장 데이터
		+ 학생 번호 ex) 1, 2, 3, ...
		+ 학생 이름 ex) '김말똥', '아무개', ...
		+ 이메일    ex) 'kim12@kh.or.kr', 'dogdog@kh.or.kr', ...
		+ 생년월일  ex) '24/07/25', '00/02/20', '88/12/25', ...
*/
CREATE TABLE STUDENT (
    STD_ID NUMBER,
    STD_NAME VARCHAR2(100) NOT NULL,
    EMAIL VARCHAR2(100),
    BIRTH DATE NOT NULL,
    
    UNIQUE(EMAIL)
);
COMMENT ON COLUMN STUDENT.STD_ID IS '학생 번호';
COMMENT ON COLUMN STUDENT.STD_NAME IS '학생 이름';
COMMENT ON COLUMN STUDENT.EMAIL IS '이메일';
COMMENT ON COLUMN STUDENT.BIRTH IS '생년월일';

INSERT INTO STUDENT VALUES (1, '기다운', 'KIDAWUN@KH.OR.KR', '95/04/01');

INSERT INTO STUDENT VALUES (2, NULL, 'INCHANG@KH.OR.KR', NULL);

INSERT INTO STUDENT VALUES (1, '조건웅', 'KIDAWUN@KH.OR.KR', '99/09/28');

DROP TABLE STUDENT;
------------------------------------------------------------
/*
	- 도서 정보 테이블 : BOOK
	- 제약 조건
	  - 제목과 저자명은 NULL값을 허용하지 않는다.
	  - ISBN 번호는 중복을 허용하지 않는다.
	- 저장 데이터
	  + 도서 번호 ex) 1, 2, 3, ...
	  + 제목 ex) '삼국지', '어린왕자', '코스모스', ...
	  + 저자 ex) '지연', '생텍쥐페리', '칼 세이건', ...
	  + 출판일 ex) '14/02/14', '22/09/19', ...
	  + ISBN번호 ex) '9780394502946', '9780152048044', ...
*/
CREATE TABLE BOOK (
    
    BK_NO NUMBER,
    BK_TITLE VARCHAR2(200) NOT NULL,
    AUTHOR VARCHAR2(200) NOT NULL,
    PUB_DATE DATE,
    ISBN VARCHAR2(20) CONSTRAINT ISBN_UQ UNIQUE
);

COMMENT ON COLUMN BOOK.BK_NO IS '도서 번호';
COMMENT ON COLUMN BOOK.BK_TITLE IS '도서 제목';
COMMENT ON COLUMN BOOK.AUTHOR IS '저자명';
COMMENT ON COLUMN BOOK.PUB_DATE IS '출판일';
COMMENT ON COLUMN BOOK.ISBN IS '일련 번호(ISBN)';

INSERT INTO BOOK VALUES(1, '어린왕자', '생텍쥐페리', '24/07/25', '9780394502946');

INSERT INTO BOOK VALUES(1, '어린왕자2', '생텍쥐페리', '34/07/25', '9780394502946');

DROP TABLE BOOK;

-- COMMIT;      -- 데이터 저장
-- ROLLBACK;    -- 데이터 저장하지 않음
--------------------------------------------------------------------------------
/*
    CHECK(조건식) : 해당 컬럼에 저장할 수 있는 값에 대한 조건을 제시
                   조건에 만족하는 값만을 저장할 수 있음
                   => 정해진 값만을 저장하고자 할 때 사용
*/
-- 성별에 대한 컬럼에 데이터 저장 시 '남', '여' 값만을 저장
CREATE TABLE MEMBER_CHECK (

    MEM_NO NUMBER NOT NULL,
    MEM_ID VARCHAR2(20) NOT NULL,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3) CHECK(GENDER IN ('남', '여')),
    PHONE CHAR(13),
    EMAIL VARCHAR2(50),
    JOIN_DATE DATE,

    UNIQUE(MEM_ID)
    -- , CHECH(GENDER IN('남', '여'))
);

INSERT INTO MEMBER_CHECK VALUES (1, 'hong', '1234', '홍길동', '남', NULL, NULL, SYSDATE);

INSERT INTO MEMBER_CHECK VALUES (2, 'wan00', '1234', '허완', 'qqq', NULL, NULL, NULL);
-- > 성별이 CHECK 제약조건에 위배됨
INSERT INTO MEMBER_CHECK VALUES (2, 'wan00', '1234', '허완', '남', NULL, NULL, NULL);
-- > CHECK 조건에 맞는 값만 저장 가능

INSERT INTO MEMBER_CHECK VALUES (3, 'seoeun02', '1234', '최서은', NULL, NULL, NULL, NULL);
-- > 성별(GENDER) 컬럼에 NULL값을 저장했음
--> NULL값은 값이 없다는 뜻이기 때문에 저장이 가능!
--> => NULL값을 허용하지 않고자 한다면 NOT NULL 제약조건을 추가해야함

--------------------------------------------------------------------------------
/*
    PRIMARY KEY(기본키)
    : 테이블에서 각 행을 식별하기 위해 사용되는 컬럼에 부여하는 제약조건
    
    ex) 회원번호, 학번, 제품코드, 주문번호, 예약번호, 군번, ...
    
    PRIMARY KEY => NOT NULL + UNIQUE
    
    * 주의할 점 : 테이블 당 오직 한 개만 설정 가능
*/
CREATE TABLE MEMBER_PRI (  
    MEM_NO NUMBER CONSTRAINT MEMNO_PK PRIMARY KEY,
    MEM_ID VARCHAR2(20) NOT NULL,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3) CHECK(GENDER IN ('남', '여')),
    PHONE CHAR(13),
    EMAIL VARCHAR2(50),
    JOIN_DATE DATE,

    UNIQUE(MEM_ID)
);

INSERT INTO MEMBER_PRI VALUES (1, 'jy999', '1234', '최재영', '남', NULL, NULL, SYSDATE);

INSERT INTO MEMBER_PRI VALUES (1, 'ys333', '1234', '이요셉', '남', NULL, NULL, SYSDATE);
-- > 기본키(MEM_NO)에 중복된 값을 저장하려고 할 때 제약조건 위배됨( => UNIQUE 제약조건 위배)

INSERT INTO MEMBER_PRI VALUES (NULL, 'ey777', '1234', '정은유', '남', NULL, NULL, SYSDATE);
--> 기본키(MEM_NO)에 NULL 값을 저장하려고 할 때 제약 조건 위배됨 (=> NOT NULL 제약조건 위배)

INSERT INTO MEMBER_PRI VALUES (2, 'ys333', '1234', '이요셉', '남', NULL, NULL, SYSDATE);

INSERT INTO MEMBER_PRI VALUES (3, 'ey777', '1234', '정은유', '남', NULL, NULL, SYSDATE);

SELECT * FROM MEMBER_PRI;

--------------------------------------------------------------------------------

-- 회원번호(MEM_NO), 회원 아이디(MEM_ID)를 기본키로 가지는 테이블

CREATE TABLE MEMBER_PRI2 (  
    MEM_NO NUMBER,
    MEM_ID VARCHAR2(20) NOT NULL,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3) CHECK(GENDER IN ('남', '여')),
    PHONE CHAR(13),
    EMAIL VARCHAR2(50),
    JOIN_DATE DATE,

    CONSTRAINT MEMPRI2_PK PRIMARY KEY(MEM_NO, MEM_ID)
);
--> 복합키 : 두개의 컬럼을 동시에 하나의 기본키로 지정하는 것
INSERT INTO MEMBER_PRI2 VALUES (1, 'JG555', '1234','최종군', '남', NULL, NULL, SYSDATE);
INSERT INTO MEMBER_PRI2 VALUES (1, 'HY666', '1234','엄희윤', '남', NULL, NULL, SYSDATE);
-- > 회원번호(MEM_NO)는 동일하나 회원아이디(MEM_ID) 값이 다르기 때문에 추가해야함

SELECT * FROM MEMBER_PRI2;


-- 어떤 회원이 제품을 장바구니에 담는 정보를 저장하는 테이블
CREATE TABLE MEMBER_LIKE (
    MEM_NO NUMBER,
    PRODUCT_NAME VARCHAR2(50),
    LIKE_DATE DATE,
    
    PRIMARY KEY (MEM_NO, PRODUCT_NAME)
);

INSERT INTO MEMBER_LIKE VALUES (1, '라디오', '24/07/24');
INSERT INTO MEMBER_LIKE VALUES (1, '아메리카노', '24/07/25');

SELECT * FROM MEMBER_LIKE;
INSERT INTO MEMBER_LIKE VALUES(2, '고양이 사료', '24/07/14');

INSERT INTO MEMBER_LIKE VALUES(2, '고양이 모래', '24/07/15');

INSERT INTO MEMBER_LIKE VALUES(2, '아메리카노', '24/07/15');


INSERT INTO MEMBER_LIKE VALUES(3, '삼계탕', '24/07/25');

SELECT MEM_NAME, PRODUCT_NAME
FROM MEMBER_PRI2
    JOIN MEMBER_LIKE USING(MEM_NO);
    
--------------------------------------------------------------------------------

/*
    FOREIGN KEY(외래키)
    : 다른 테이블에 존재하는 값을 저장하고자 할 때 사용되는 제약조건 
     -> 다른 테이블을 참조한다고 표현
     -> 주로 외래키를 통해 테이블 간의 관계가 형성
     
    - 컬럼레벨방식
    컬럼명 자료형 REFERENCES 참조할 테이블명[(참조할 컬럼명)]
    
    - 테이블레벨방식
    FOREIGN KEY (컬럼명) REFERENCES 참조할 테이블명[(참조할 컬럼명)]
    
    => 참조할 컬럼명을 생략할 경우 참조하는 테이블의 기본키 컬럼이 매칭됨!
*/

-- MEMBER 테이블 삭제
DROP TABLE MEMBER;

-- 회원 등급 정보를 저장할 테이블
CREATE TABLE MEMBER_GRADE (
    GRADE_NO NUMBER PRIMARY KEY,
    GRADE_NAME VARCHAR2(20) NOT NULL
);

INSERT INTO MEMBER_GRADE VALUES (100, '일반회원');
INSERT INTO MEMBER_GRADE VALUES (200, 'VIP회원');
INSERT INTO MEMBER_GRADE VALUES (300, 'VVIP회원');

CREATE TABLE MEMBER (
    MEM_NO NUMBER PRIMARY KEY,
    MEM_ID VARCHAR2(20) NOT NULL UNIQUE,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CAHR(3) CHECK(GENDER IN ('남', '여')),
    JOIN_DATE DATE,
    MEM_GRADEID NUMBER REFERENCES MEMBER_GRADE(GRADE_NO)
);    

INSERT INTO MEMBER VALUES (1, 'WHDRNS456' '0780', '최종군', '남', SYSDATE, 100);

INSERT INTO MEMBER VALUES (2, 'JGW456' '1234', '조건웅', '남', SYSDATE, 200);

INSERT INTO MEMBER VALUES (3, 'HH00' 'QWER', '임현호', '남', SYSDATE, NULL);
--> 외래키로 설정된 컬럼에는 기본적으로 NULL값은 저장 가능

INSERT INTO MEMBER VALUES (4, 'JW33', '0987', '이주원', '여', SYSDATE, 400);
--> 부모키를 찾을 수 없음
-- MEMBER_GRADE (부모테이블) <------------ MEMBER(자식테이블)
--  1:N 관계 1 (부모테이블:MEMBBER_GRADE), N (자식테이블:MEMBER)
INSERT INTO MEMBER VALUES (4, 'JW33', '0987', '이주원', '여', SYSDATE, 100);

SELECT * FROM MEMBER_GRADE;
SELECT * FROM MEMBER;

--> 부모테이블에서 데이터를 하나 삭제한다면
-- 데이터 삭제 : DELETE FROM 테이블명 WHERE 조건;

-- MEMBER_GRADE 테이블에서 100번째 해당하는 등급 데이터 삭제
DELETE FROM MEMBER_GRADE
WHERE GRADE_NO = 100;
--> 자식 테이블에서 100이라는 값을 사용하고 있기 때문에 삭제 불가

DELETE FROM MEMBER_GRADE
WHERE GRADE_NO = 300;
--> 자식테이블에서 300이라는 값은 사용하지 않았기 때문에 삭제 가능

-- *자식테이블에서 이미 사용하고 있는 값이 있을 경우
--      부모테이블로부터 무조건 삭제가 되지 않는 "삭제옵션"이 있음

ROLLBACK; -- 데이터 변경사항을 원래대로 돌려놓는 것
--------------------------------------------------------------------------------
/*
    외래키 제약조건 삭제 옵션
    : 부모테이블의 데이터 삭제 시 해당 데이터를 사용하고 있는 자식테이블의 값을
      어떻게 할 것인지에 대한 옵션
      
    - (기본값) ON DELETE RESTRICTED : 자식데이터로부터 사용중인 값이 있으면 부모테이블에서 데이터 삭제 불가
    - ON DELETE SET NULL : 부모테이블에 있는 데이터 삭제 시 해당 데이터를 사용 중인 자식테이블의 값을 NULL로 변경
    - ON DELETE CASCADE : 부모테이블에 있는 데이터 삭제 시 해당 데이터를 사용중인 자식테이블의 값도 삭제
*/
-- MEMBER테이블 삭제
DROP TABLE MEMBER;

CREATE TABLE MEMBER (
    MEM_NO NUMBER PRIMARY KEY,
    MEM_ID VARCHAR2(20) NOT NULL UNIQUE,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CAHR(3) CHECK(GENDER IN ('남', '여')),
    JOIN_DATE DATE,
    MEM_GRADEID NUMBER REFERENCES MEMBER_GRADE(GRADE_NO) ON DELETE SET NULL
); 

INSERT INTO MEMBER VALUES (1, 'WHDRNS456' '0780', '최종군', '남', SYSDATE, 100);

INSERT INTO MEMBER VALUES (2, 'JGW456' '1234', '조건웅', '남', SYSDATE, 200);

INSERT INTO MEMBER VALUES (3, 'HH00' 'QWER', '임현호', '남', SYSDATE, NULL);

-- 100번 등급에 대한 데이터 삭제 (MEMBER_GRADE)
DELETE FROM MEMBER_GRADE
WHERE GRADE_NO = 100;
--> 자식테이블에서 100번 등급이 사용된 데이터가 NULL로 변경되며
    -- 부모테이블에서는 데이터가 삭제됨

ROLLBACK;
--------
DROP TABLE MEMBER;

CREATE TABLE MEMBER (
    MEM_NO NUMBER PRIMARY KEY,
    MEM_ID VARCHAR2(20) NOT NULL UNIQUE,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3) CHECK (GENDER IN ('남', '여')),
    JOIN_DATE DATE,
    MEM_GRADEID NUMBER REFERENCES MEMBER_GRADE(GRADE_NO) ON DELETE CASCADE
);


INSERT INTO MEMBER VALUES (1, 'WHDRNS456' '0780', '최종군', '남', SYSDATE, 100);

INSERT INTO MEMBER VALUES (2, 'JGW456' '1234', '조건웅', '남', SYSDATE, 200);

INSERT INTO MEMBER VALUES (3, 'HH00' 'QWER', '임현호', '남', SYSDATE, NULL);

SELECT * FROM MEMBER;

DELETE FROM MEMBER_GRADE
WHERE GRADE_NO = 100;
--> 자식테이블에서 100번이 사용된 행(데이터) 자체가 삭제됨

--------------------------------------------------------------------------------
/*
    DEFAULT
    : 제약조건은 아님..
      컬럼을 선정하지 않고 데이터 추가 시 NULL값이 아닌 기본적인 값을 저장하고자 할 때
*/

DROP TABLE MEMBER;

CREATE TABLE MEMBER (
    MEM_NO NUMBER PRIMARY KEY, -- 회원번호
    MEM_NAME VARCHAR2(20) NOT NULL, -- 회원이름
    AGE NUMBER, -- 나이
    HOBBY VARCHAR2(20) DEFAULT '없음', -- 취미
    JOIN_DATE DATE DEFAULT SYSDATE
);


INSERT INTO MEMBER VALUES (1, '짱구', 5, '엉덩이춤', '24/07/01');
INSERT INTO MEMBER VALUES (2, '맹구', 5, '코하기..', NULL);
INSERT INTO MEMBER VALUES (3, '훈이', 5, NULL, NULL);

SELECT * FROM MEMBER;

INSERT INTO MEMBER(MEM_NO, MEM_NAME) VALUES (4, '유리');
--> 지정하지 않은 컬럼에 대한 값은 기본적으로 NULL값이 저장됨
--> 단, 해당 컬럼에 기본값이 설정되어 있으면 NULL이 아닌 기본값으로 저장됨.
--------------------------------------------------------------------------------
-- 테이블 복제하기
CREATE TABLE MEMBER_COPY
AS (SELECT * FROM MEMBER);
--------------------------------------------------------------------------------
/*
    * ALTER TABLE : 테이블에 변경사항을 적용하고자 할 때 사용
    
    ALTER TABLE 테이블명 변경할 내용
    
    - NOT NULL : ALTER TABLE 테이블명 MODIFY 컬럼명 NOT NULL;
    
    - UNIQUE    : ALTER TABLE 테이블명 ADD UNIQUE(컬럼명);
    - CHECK     : ALTER TABLE 테이블명 ADD CHECK(컬럼에 대한 조건식);
    - PRIMARY KEY   : ALTER TABLE 테이블명 ADD PRIMARY KEY(컬럼명);
    - ROREIGN KEY   : ALTER TABLE 테이블명 ADD FOREIGN KEY(컬럼명) REFERENCES 참조할 테이블명 [(참조할 컬럼명)];
    ---
    - DEFAULT 옵션 : ALTER TABLE 테이블명 MODIFY 컬럼명 DEFAULT 기본값;
*/

-- 
ALTER TABLE MEMBER_COPY ADD PRIMARY KEY(MEM_NO);

-- EMPLOYEE 테이블에서 부서코드(DEPT_CODE) 컬럼에 외래키 지정 -> DEPARTMENT 테이블의 DEPT_ID(기본키)
ALTER TABLE EMPLOYEE ADD FOREIGN KEY(DEPT_CODE) REFERENCES DEPARTMENT(DEPT_ID);

-- EMPLOYEE 테이블에서 직급코드(JOB_CODE) 컬럼에 외래키 지정 -> JOB테이블의 JOB_CODE(기본키)
ALTER TABLE EMPLOYEE ADD FOREIGN KEY(JOB_CODE) REFERENCES JOB;

