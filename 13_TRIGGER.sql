/*
    * 트리거 (TRIGGER)
      : 지정한 테이블에 DML(INSERT, UPDATE, DELETE)문에 의해 변경사항이 있을 때 (테이블에 이벤트가 발생했을 때)
        자동으로 매번 실행할 내용을 미리 정의해두는 것
        
    ex) 회원 탈퇴 시 기존 회원테이블에서 데이터 삭제(DELETE)하고
        탈퇴 회원 테이블에 데이터 추가(INSERT) 해야할 때 자동으로 실행
        
    ex) 신고횟수가 특정 값을 넘어갔을 때 해당 회원을 블랙리스트 처리
    
    ex) 입출고에 대한 데이터를 기록할 때 해당 상품의 재고 수량을 갱신해야 할 때
*/
/*
    * 트리거의 종류 *
    
    - SQL문의 실행 시기에 따른 분류
        + BEFORE TRIGGER : 지정한 테이블에 이벤트가 발생하기 전에 트리거 실행
        + AFTER TRIGGER : 지정한 테이블에 이벤트가 발생한 후에 트리거 실행
        
        
        
    - SQL문에 의해 영향을 받는 각 행에 따른 분류
        + 문장 트리거 : 이벤트가 발생한 SQL문에 대해 딱 한번만 트리거 실행
        + 행 트리거   : 해당 SQL문이 실행 될때마다 매번 트리거 실행
                       FOR EACH ROW 옵션 설정 필요
                       
                      :OLD - BEFORE UPDATE (수정 전 자료), BEFORE DELETE (삭제 전 자료)
                      :NEW - AFTER INSERT (추가된 자료), AFTER UPDATE (수정 후 자료)
*/
/*
    * 트리거 생성하기 *
    
    CREATE [OR REPLACE] TRIGGER 트리거이름               -- 트리거 기본정보(이름)
    BEFORE|AFTER INSERT|UPDATE|DELETE ON 테이블명       -- 이벤트 관련 정보
    [FOR EACH ROW]                                      -- 매번 트리거를 실행할 것인지에 대한 옵션
    [DECLARE]       -- 변수/상수 선언 및 초기화
    BEGIN           -- 실행부 (SQL문, 조건문, 반복문, ...)
                        이벤트 발생 시 자동으로처리할 구문
    [EXCEPTION]     -- 예외처리부
    END;
    /
*/
-- EMPLOYEE 테이블에 데이터가 추가될 때마다 '신입사원님 환영합니다 ^^' 출력

CREATE OR REPLACE TRIGGER WELLCOME
AFTER INSERT ON EMPLOYEE
FOR EACH ROW
BEGIN
    DBMS_OUTPUT.PUT_LINE('신입사원님 환영합니다 ^^');
END;
/

INSERT INTO EMPLOYEE (EMP_ID, EMP_NAME, EMP_NO, DEPT_CODE, JOB_CODE, HIRE_DATE)
    VALUES(500, '양준혁', '000501-3000000', 'D4', 'J4', SYSDATE);

INSERT INTO EMPLOYEE (EMP_ID, EMP_NAME, EMP_NO, DEPT_CODE, JOB_CODE, HIRE_DATE)
    VALUES(501, '김인창', '950704-1000000', 'D6', 'J5', SYSDATE);

--------------------------------------------------------------------------------
-- 상품 입고 및 출고 관련

-- * 테이블, 시퀀스 생성
--   상품을 저장하기 위한 테이블
CREATE TABLE TB_PRODUCT (
    PNO NUMBER PRIMARY KEY,      --상품번호
    PNAME VARCHAR2(30) NOT NULL, --상품명
    BRAND VARCHAR2(30) NOT NULL, --브랜드
    PRICE NUMBER DEFAULT 0,      --가격
    STOCK NUMBER DEFAULT 0       --재고수량
);

CREATE SEQUENCE SEQ_PNO
START WITH 200
INCREMENT BY 5
NOCACHE;

-- 샘플데이터 추가
INSERT INTO TB_PRODUCT (PNO, PNAME, BRAND) VALUES (SEQ_PNO.NEXTVAL, '아이폰15', '사과');
INSERT INTO TB_PRODUCT VALUES (SEQ_PNO.NEXTVAL, '갤럭시 폴드6', '샘송', 2000000, 50);
INSERT INTO TB_PRODUCT VALUES (SEQ_PNO.NEXTVAL, '샤오미폰', '샤우미', 8000, 500);

SELECT * FROM TB_PRODUCT;
COMMIT;         -- DB에 반영하기

-- 상품 입출고 내역을 저장하기 위한 테이블
CREATE TABLE TB_PDETAIL (
    DNO NUMBER PRIMARY KEY,                     -- 내역 번호
    PNO NUMBER REFERENCES TB_PRODUCT,           -- 상품번호
    DDATE DATE DEFAULT SYSDATE,                 -- 입출고일
    AMOUNT NUMBER NOT NULL,                     -- 입출고 수량
    TYPE CHAR(6) CHECK(TYPE IN ('입고', '출고')) -- 입출고 상태 
);

-- 입출고 내역에 대한 시퀀스(내역번호)
CREATE SEQUENCE SEQ_DNO
NOCACHE;

-- 205번 상품, 오늘날짜, 5개 출고
INSERT INTO TB_PDETAIL VALUES (SEQ_DNO.NEXTVAL, 205, DEFAULT, 5, '출고');

-- * TB_PRODUCT 테이블에 업데이트

UPDATE TB_PRODUCT
    SET STOCK = STOCK - 5
WHERE PNO = 205;

COMMIT;

SELECT * FROM TB_PDETAIL;
SELECT * FROM TB_PRODUCT;



-- 200번(아이폰15) 상품의 재고를 10개 입고
INSERT INTO TB_PDETAIL VALUES (SEQ_DNO.NEXTVAL, 200, DEFAULT, 10, '입고');
UPDATE TB_PRODUCT
    SET STOCK = STOCK + 10
WHERE PNO = 200;

COMMIT;

--------------------------------------------------------------------------------
/*
    TB_PDETAIL (입출고 이력) 테이블에 데이터 추가(INSERT) 이벤트 발생 시
    TB_PRODUCT (상품) 테이블에 재고 수량이 갱신(UPDATE) 되어야 함! => 자동으로 처리할 수 있도록 트리거 생성!
    
    - UPDATE 조건
        * 상품이 입고된 경우=> 해당 상품을 찾아서 재고 수량을 증가
            UPDATE TB_PRODUCT
                SET STOCK = STOCK + 입고수량(TB_PDETAIL.AMOUNT) --> :NEW.AMOUNT
            WHERE PNO = 입고된 상품번호(TB_PDETAIL.PNO)           --> :NEW.PNO
            
            * 상품이 출고된 경우 => 해당 상품을 찾아서 재고수량 감소
             UPDATE TB_PRODUCT
                SET STOCK = STOCK - 출고수량(TB_PDETAIL.AMOUNT) --> :NEW.AMOUNT
            WHERE PNO = 출고된 상품번호(TB_PDETAIL.PNO)           --> :NEW.PNO
*/


CREATE TRIGGER TRG_02
BEFORE UPDATE ON TB_PDETAIL
FOR EACH ROW
BEGIN
    IF :NEW.TYPE LIKE '입고'
        THEN UPDATE TB_PRODUCT SET STOCK = STOCK + :NEW.AMOUNT;
    ELSIF :NEW.TYPE LIKE '출고'
        THEN UPDATE TB_PRODUCT SET STOCK = STOCK - :NEW.AMOUNT;
    END IF;
END;
/
/*
    * 트리거의 종류 *
    
    - SQL문의 실행 시기에 따른 분류
        + BEFORE TRIGGER : 지정한 테이블에 이벤트가 발생하기 전에 트리거 실행
        + AFTER TRIGGER : 지정한 테이블에 이벤트가 발생한 후에 트리거 실행
        
        
        
    - SQL문에 의해 영향을 받는 각 행에 따른 분류
        + 문장 트리거 : 이벤트가 발생한 SQL문에 대해 딱 한번만 트리거 실행
        + 행 트리거   : 해당 SQL문이 실행 될때마다 매번 트리거 실행
                       FOR EACH ROW 옵션 설정 필요
                       
                      :OLD - BEFORE UPDATE (수정 전 자료), BEFORE DELETE (삭제 전 자료)
                      :NEW - AFTER INSERT (추가된 자료), AFTER UPDATE (수정 후 자료)
*/
/*
    * 트리거 생성하기 *
    
    CREATE [OR REPLACE] TRIGGER 트리거이름               -- 트리거 기본정보(이름)
    BEFORE|AFTER INSERT|UPDATE|DELETE ON 테이블명       -- 이벤트 관련 정보
    [FOR EACH ROW]                                      -- 매번 트리거를 실행할 것인지에 대한 옵션
    [DECLARE]       -- 변수/상수 선언 및 초기화
    BEGIN           -- 실행부 (SQL문, 조건문, 반복문, ...)
                        이벤트 발생 시 자동으로처리할 구문
    [EXCEPTION]     -- 예외처리부
    END;
    /
*/