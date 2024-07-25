/*
    * 함수(FUNCTION)
      : 전달된 컬럼값을 읽어서 함수를 실행한 결과를 반환
      
      - 단일 행 함수 : N개의 값을 읽어서 N개의 결과값을 리턴 (행마다 실행한 결과를 반환)
      - 그룹 함수 : N개의 값을 읽어서 1개의 결과값을 리턴 (그룹을 지어 그룹별로 함수를 실행한 결과를 반환)
      
      + SELECT절 단일 행 함수와 그룹함수를 함께 사용할 수 없음
       => 결과 행의 개수가 다르기 떄문에
       
       + 함수식을 사용할 수 있는 위치 : SELECT절, WHERE절, ORDER BY절, GROUP BY절, HAVING절
*/
-- ================================ 단일행 함수 =================================
/*
    * 문자타입의 데이터 처리 함수
      => VARCHAR2. CHAR
      
    * LENGTH(컬럼명 | '문자열') : 해당 문자열의 글자수 반환
      LENGTHB(컬럼명 | '문자열') : 해당 문자열의 바이트 수 반환
      
      => 영문자, 숫자, 특수문자 글자당 1byte
         한글은 글자당 3byte '김', 'ㄱ', '나'
*/
-- '오라클' 단어의 글자 수와 바이트 수 확인
SELECT LENGTH('오라클') 글자수, LENGTHB('오라클') 바이트수 
FROM DUAL;
SELECT LENGTH('ORACLE') 글자수, LENGTHB('ORACLE') 바이트수 
FROM DUAL;

-- 사원명, 사원명(글자수), 사원명(바이트수)
-- 이메일, 이메일(글자수), 이메일(바이트수)
SELECT EMP_NAME 이메일, LENGTH(EMP_NAME) 글자수, LENGTHB(EMP_NAME) "바이트 수" 
FROM EMPLOYEE;
SELECT EMAIL 이메일, LENGTH(EMAIL) 글자수, LENGTHB(EMAIL) "바이트 수" 
FROM EMPLOYEE;

SELECT EMP_NAME 이메일, LENGTH(EMP_NAME) 글자수, LENGTHB(EMP_NAME) "바이트 수",
 EMAIL 이메일, LENGTH(EMAIL) 글자수, LENGTHB(EMAIL) "바이트 수"
FROM EMPLOYEE;
-------------------------------------------------------------------------------
/*
    * INSTR : 문자열로부터 특정 문자의 시작위치를 반환
    
    [표현법]
            INSTR(컬럼 | '문자열', '찾고자하는 문자'[, 찾을 위치의 시작값, 순번])
            => 함수 실행 결과는 숫자타입(NUMBER)
*/
SELECT INSTR('AABAACAABBAA', 'B') FROM DUAL; -- 앞쪽에 있는 첫번째 B의 위치 : 3
SELECT INSTR('AABAACAABBAA', 'B', 1) FROM DUAL; -- (기본값) 찾을 위치의 시작값 : 1
SELECT INSTR('AABAACAABBAA', 'B', -1) FROM DUAL; -- (역순) 음수값을 시작값으로 제시하면 뒤에서부터 찾음. 다만, 위치에 대한 값은 앞에서부터 읽어서 결과를 반환
SELECT INSTR('AABAACAABBAA', 'B', 1, 2) FROM DUAL; -- 순번을 제시할 때는 시작값을 제시해야 한다. 앞쪽에 있는 두번째 B의 위치 : 9
-- 사원 정보 중 이메일에 _의 첫번쨰 위치, @의 위치를 조회(이메일, _ 위치, @ 위치)
SELECT EMAIL, INSTR(EMAIL, '_', 1) "_ 첫번째 위치", INSTR(EMAIL, '@', 1) "@ 첫번째 위치" 
FROM EMPLOYEE;
--------------------------------------------------------------------------------
/*
    * SUBSTR : 문자열에서 특정 문자열을 추출해서 반환
    
    [표현법]
            SUBSTR(문자열|컬럼, 시작위치, [길이(갯수)])
            => 3번째 길이 부분을 생략하면 문자열 끝까지 추출
*/
SELECT SUBSTR('ORACLE SQL DEVELOPER', 10) FROM DUAL;    -- 10번째 위치부터 끝까지 추출
SELECT SUBSTR('ORACLE SQL DEVELOPER', 8, 3) FROM DUAL;  -- 8번쨰 위치부터 해서 3글자만 추출 => SQL
SELECT SUBSTR('ORACLE SQL DEVELOPER', -3) FROM DUAL;    -- 뒤에서부터 3번째 위치부터 끝까지 추출 => PER
SELECT SUBSTR('ORACLE SQL DEVELOPER', -9, 3) FROM DUAL; -- 뒤에서부터 9번쨰 위치부터 3글자만 추출 => DEV

-- 사원들 중 여사원들만 조회 (이름, 주민번호)
SELECT EMP_NAME, EMP_NO 
FROM EMPLOYEE 
WHERE SUBSTR(EMP_NO, 8, 1) IN ('2', '4')
ORDER BY EMP_NAME;

-- 사원들 중 남사원들만 조회 (이름, 주민번호)
SELECT EMP_NAME, EMP_NO 
FROM EMPLOYEE 
WHERE SUBSTR(EMP_NO, 8, 1) IN ('1', '3')
ORDER BY EMP_NAME;

-- 
-- 사원 정보 중 사원명, 이메일, 아이디(이메일에서 @ 앞까지의 값) 조회
-- [1] 이메일에서 '@'의 위치를 찾고 => INSTR 함수 사용
-- [2] 이메일 컬럼의 값에서 1번째 위치부터 '@'위치 전까지 추출
SELECT EMP_NAME "이름", EMAIL "이메일", SUBSTR(EMAIL, 1, INSTR(EMAIL, '@', 1, 1)-1) "아이디"
FROM EMPLOYEE;
--------------------------------------------------------------------------------
/*
    * LPAD / RPAB : 문자열을 조회할 때 통일감 있게 조회하고자 할 때 사용
                    문자열에 덧붙이고자 하는 문자를 왼쪽 또는 오른쪽에 붙여서 최종 길이만큼 문자열 반환
                    
    [표현법]
        LPAD(컬럼|'문자열', 최종길이[, 덧붙일 문자])
        RPAD(컬럼|'문자열', 최종길이[, 덧붙일 문자])
        * 덧붙일 문자 생략 시 기본값으로 공백으로 채워진다.
*/
-- 사원 정보 중 사원명을 왼쪽을 공백으로 채워서 총 20길이로 조회
SELECT EMP_NAME, LPAD(EMP_NAME, 20) "이름2"
FROM EMPLOYEE;
SELECT EMP_NAME, RPAD(EMP_NAME, 20) "이름2"
FROM EMPLOYEE;

-- 사원 정보 이름, 이메일 오른쪽정렬 (총 길이:20)하여 조회
SELECT EMP_NAME "이름", LPAD(EMAIL, 20) "이메일"
FROM EMPLOYEE;

-- 사원 정보 이름, 이메일 왼쪽정렬 (총 길이:20)하여 조회
SELECT EMP_NAME "이름", RPAD(EMAIL, 20) "이메일"
FROM EMPLOYEE;

-- 사원 정보 이름, 이메일 왼쪽정렬 (총 길이:20)하여 조회
SELECT EMP_NAME "이름", RPAD(EMAIL, 20, '#') "이메일"
FROM EMPLOYEE;

SELECT RPAD('000202-1', 14, '*') FROM DUAL;

--사원들의 사원명, 주민번호 조회 ('XXXXX - X******' 형식으로 조회)
SELECT EMP_NAME, RPAD(SUBSTR(EMP_NO,1, 8), LENGTH(EMP_NO), '*') "주민번호 앞자리"
FROM EMPLOYEE;
--------------------------------------------------------------------------------
/*
    * LTRIM / RTRIM : 문자열에서 특정 문자를 제거한 후 나머지를 반환
    
    [표현법]
            LTRIM(문자열|컬럼[, 제거하고자 하는 문자들])
            RTRIM(문자열|컬럼[, 제거하고자 하는 문자들])
            * 제거할 문자를 생략할 시 공백이 제거됨
*/

SELECT LTRIM('     H I') FROM DUAL; -- 왼쪽부터(앞에서부터) 다른 문자가 나올 때까지 공백 제거
SELECT RTRIM('H I     ') FROM DUAL; -- 오른쪽에 있는 공백들이 제거

SELECT LTRIM('123123HI123', '123') FROM DUAL;
SELECT LTRIM('321321HI123', '123') FROM DUAL;

SELECT LTRIM('KKHHII', '123') FROM DUAL;

/*
    * TRIM : 문자열 앞/뒤/양쪽에 있는 지정한 문자들을 제거한 후 나머지 값을 반환
    
    [표현법]
            TRIM([LEADING | TRAILING | BOTH] [제거할 문자] FROM 문자열 | 컬럼)
            * 제거할 문자 생략 시 공백 제거
            * 기본 옵션은 BOTH (양쪽)
*/
SELECT TRIM('   H I   ') FROM DUAL;

SELECT TRIM('L' FROM 'LLLLLLHLLLLLL') "값" 
FROM DUAL;

SELECT TRIM(LEADING 'L' FROM 'LLLLLLHLLLLLL') "값"
FROM DUAL;
SELECT TRIM(TRAILING 'L' FROM 'LLLLLLHLLLLLL') "값"
FROM DUAL;
SELECT TRIM(BOTH 'L' FROM 'LLLLLLHLLLLLL') "값"
FROM DUAL;
--------------------------------------------------------------------------------
/*
    * LOWER / UPPER / INITCAP
        - LOWER : 문자열을 모두 소문자로 변경하여 문자열 반환
        - UPPER : 문자열을 모두 대문자로 변경하여 문자열 반환
        - INITCAP : 띄어쓰기 기준으로 첫 글자마다 대문자로 변경하여 문자열 반환
*/

SELECT LOWER('I THINK SO I AM') FROM DUAL;

SELECT INITCAP('I THINK SO I AM') FROM DUAL;

--------------------------------------------------------------------------------
/*
    * CONCAT : 문자열 두 개를 전달받아 하나로 합친 후 합친 문자열 반환
    
    [표현법]
            CONCAT(문자열1, 문자열2)
*/
-- 'KH' 'L강의장' 문자 두개를 하나로 합쳐서 조회
SELECT 'KH' || ' L강의장' FROM DUAL;

SELECT '다운' || 30 FROM DUAL;

-- 사원 번호와 [사원명]님을 하나의 문자열로 조회
SELECT CONCAT(EMP_ID, CONCAT(EMP_NAME, '님')) FROM EMPLOYEE;
--------------------------------------------------------------------------------

/*
    * REPLACE : 특정 문자열에서 특정 부분을 다른 부분으로 교체하여 문자열 반환
    
    [표현법]
            REPLACE(문자열, 찾을 문자열, 변경할 문자열)
*/

SELECT REPLACE('서울시 강남구 역삼동', '역삼동', '삼성동') FROM DUAL;

SELECT * FROM EMPLOYEE;
-- 사원 테이블에서 이메일 정보 중 'or.kr' 부분을 'kh.or.kr' 값으로 변경하여 조회
SELECT EMAIL, REPLACE(EMAIL, '@or.kr', '@kh.or.kr') 이메일
FROM EMPLOYEE;

SELECT EMAIL, REPLACE(EMAIL, '@or.kr', '@gmail.com') 이메일
FROM EMPLOYEE;

--=============================================================================
/*
    [ 숫자 타입의 데이터 처리 함수 ]
*/
/*
    * ABS : 숫자의 절대값을 구해주는 합수
*/
SELECT ABS(-10) "-10의 절대값" FROM DUAL;

SELECT ABS(-7.7) "-7.7의 절대값" FROM DUAL;

--------------------------------------------------------------------------------
/*
    * MOD : 두 수를 나눈 나머지 값을 구해주는 함수
    
    MOD(숫자1, 숫자2) --> 숫자1 % 숫자2
*/
-- 10을 3으로 나눈 나머지를 구해본다면..?

SELECT MOD(10, 3) FROM DUAL;

SELECT MOD(10.9, 3) FROM DUAL;

--------------------------------------------------------------------------------
/*
    * ROUND : 반올림한 값을 구해주는 함수
    
    ROUND(숫자[, 위치]) : 위치 => 소숫점 N번째 자리
*/
SELECT ROUND(123.456) FROM DUAL;    -- 결과 : 123
SELECT ROUND(123.456, 1) FROM DUAL;

SELECT ROUND(123.456, -1) FROM DUAL;
SELECT ROUND(123.456, -2) FROM DUAL;
--------------------------------------------------------------------------------

/*
    * CEIL : 올림처리한 값을 구해주는 함수
    
    CEIL(숫자)
*/
SELECT CEIL(123.456) FROM DUAL;

/*
    * FLOOR : 버림처리한 값을 구해주는 함수
    
    FLOOR(숫자)
*/
SELECT FLOOR(123.456) FROM DUAL;

/*
    * TRUNC : 버림처리한 값을 구해주는 함수(위치 지정 가능)
    0
    TRUNC(숫자[, 위치])
*/
SELECT TRUNC(123.456) FROM DUAL;
SELECT TRUNC(123.456, 1) FROM DUAL;
SELECT TRUNC(123.456, -1) FROM DUAL;
-- =============================================================================
/*
    [ 날짜 데이터 타입 처리 함수 ]
*/
-- SYSDATE : 시스템의 현재 날짜 및 시간을 반환
SELECT SYSDATE FROM DUAL;

-- MONTHS_BETWEEN : 두 날짜 사이의 개월 수를 반환

-- [표현법] MONTHS_BETWEEN(날짜 A, 날짜 B) : 날짜A - 날짜B => 개월 수 계산
SELECT EMP_NAME, HIRE_DATE
    , CONCAT(CEIL(MONTHS_BETWEEN(SYSDATE, HIRE_DATE)), '개월차') "근속 개월 수"
FROM EMPLOYEE;

-- 공부 시작한 지 몇 개월차
SELECT CONCAT(CEIL(MONTHS_BETWEEN(SYSDATE, '24/06/11')), '개월차') "공부"
FROM DUAL;

-- 수료까지 몇개월 남았는지
SELECT CONCAT(FLOOR(MONTHS_BETWEEN('24/11/25', SYSDATE)), '개월 남음') "수료일"
FROM DUAL;
----------

-- ADD_MONTHS : 특정 날짜에 N개월 수를 더해서 반환
-- [표현법] ADD_MONTHS(날짜, 더할 개월 수)

-- 현재 날짜 기준 4개월 후 조회
SELECT SYSDATE 현재날짜, ADD_MONTHS(SYSDATE, 4) "4개월 후 날짜" 
FROM DUAL;

-- 사원 테이블에서 입사일, 입사일+3개월 "수습종료일" 조회
SELECT EMP_NAME, HIRE_DATE "입사일", ADD_MONTHS(HIRE_DATE, 3) "수습 종료일" 
FROM EMPLOYEE;

------------
-- NEXT_DAY : 특정 날짜 이후 가장 가까운 요일의 날짜를 반환
-- [표현범] NEXT_DAY(날짜, 요일(문자|숫자))
--  * 1: 일, 2: 월, 3: 화, 4: 수, 5: 목, 6: 금, 7: 토

-- 현재 날짜 기준 가장 가까운 금요일의 날짜 조회
SELECT NEXT_DAY(SYSDATE, 6) FROM DUAL;

-- 언어 설정 : KOREAN / ANERICAN
ALTER SESSION SET NLS_LANGUAGE = AMERICAN;

SELECT SYSDATE, NEXT_DAY(SYSDATE, '금요일') FROM DUAL;
SELECT SYSDATE, NEXT_DAY(SYSDATE, '금') FROM DUAL;

SELECT SYSDATE, NEXT_DAY(SYSDATE, 6) FROM DUAL;

SELECT SYSDATE, NEXT_DAY(SYSDATE, 'FRIDAY') FROM DUAL;
SELECT SYSDATE, NEXT_DAY(SYSDATE, 'FRI') FROM DUAL;
--------------------------------------
-- LAST_DAY : 해당 월의 마지막 날짜를 구해서 반환
-- [표현법] LAST_DAY(날짜)

-- 이번달의 마지막 날짜 조회
SELECT LAST_DAY(SYSDATE) FROM DUAL;

-- 사원 테이블에서 사원명, 입사일, 입사한 달의 마지막 날짜, 입사한 달의 근무일수 조회
SELECT EMP_NAME "사원명", HIRE_DATE "입사일", LAST_DAY(HIRE_DATE) "입사한 달의 마지막 날", LAST_DAY(HIRE_DATE)-HIRE_DATE + 1 "입사한 달의 근무일수"
FROM EMPLOYEE;

SELECT SYSDATE - SYSDATE + 1 FROM DUAL;

----------------------------------
/*
    * EXTRACT : 특정 날짜데이터로부터 년도/월/일 값을 추출해서 반환해주는 함수
    
    [표현법]
            EXTRACT(YEAR FROM 날짜) : 날짜에서 연도만 추출
            EXTRACT(MONTH FROM 날짜) : 날짜에서 월만 추출
            EXTRACT(DAY FROM 날짜) : 날짜에서 일만 추출
*/
-- 현재 날짜 기준, 연도, 월, 일 각각 추출하여 조회

SELECT SYSDATE
        , EXTRACT(YEAR FROM SYSDATE) 연도
        , EXTRACT(MONTH FROM SYSDATE) 월
        , EXTRACT(DAY FROM SYSDATE) 일
FROM DUAL;
-- 사원 테이블 사원명, 입사년도, 입사월, 입사일 조회
SELECT EMP_NAME "사원명"
        , EXTRACT(YEAR FROM HIRE_DATE) 입사년도
        , EXTRACT(MONTH FROM HIRE_DATE) 입사월
        , EXTRACT(DAY FROM HIRE_DATE) 입사일
FROM EMPLOYEE
ORDER BY 2, 3, 4;
--==============================================================================
/*
    * 형변환 함수 : 데이터타입을 변경해주는 함수
        - 문자 / 숫자 / 날짜
*/
/*
    TO_CHAR : 숫자 또는 날짜 타입의 값을 문자 타입으로 변환시켜주는 함수
    
    [표현법]
        TO_CHAR(숫자|날짜[, 포맷])
*/
-- 숫자타입 --> 문자타입
SELECT 1234 "숫자타입 데이터", TO_CHAR(1234) "문자로 변경한 데이터" FROM DUAL;

SELECT TO_CHAR(1234, '999999') "포맷 사용한 양식" FROM DUAL;
-- => '9' : 개수만큼 자리수를 확보. 오른쪽 정렬. 빈칸은 공백으로 채움

SELECT TO_CHAR(1234, '000000') "포맷데이터" FROM DUAL;
-- => '0' :  개수만큼 자리수를 확보, 오른쪽 정렬, 빈칸을 0으로 채움

SELECT TO_CHAR(1234, 'L999999') "포맷데이터" FROM DUAL;
-- => 현재 설정된 나라의 로컬 화폐단위를 같이 표시 현재 KOEAN이므로 \(원화)로 표시됨

SELECT TO_CHAR(1234, '$999999') "포맷데이터" FROM DUAL;

SELECT TO_CHAR(1000000, 'L9,999,999') "포맷데이터" FROM DUAL;

-- 사원들의 사원명, 월급, 연봉 조회 (화폐단위, 3자씩 구분하여 표시되도록)
SELECT EMP_NAME "사원명", TO_CHAR(SALARY, 'L9,999,999') "월급"
                        , TO_CHAR(SALARY*12, 'L999,999,999') "연봉"
FROM EMPLOYEE;
--------------------------------------------------------------------------------
-- 날짜타입 --> 문자타입
SELECT SYSDATE, TO_CHAR(SYSDATE) "문자로 변환" FROM DUAL;


SELECT TO_CHAR(SYSDATE, 'HH12:MI:SS') FROM DUAL; -- 12시간제
SELECT TO_CHAR(SYSDATE, 'PM HH:MI:SS') FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'HH24:MI:SS') FROM DUAL; -- 24시간제
/*
    * HH : 시 정보 (HOUR) -> 12시간제
        => 24시간제 / HH24
    * MI : 분 정보 (MINUTE)
    * SS : 초 정보 (SECOND)
*/
SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD DAY DY') FROM DUAL;
-- DAY : 요일 정보 (X요일) -> '일요일', '월요일', '화요일', ... '토요일'
-- DY : 요일 정보(X) -> '일', '월', '화', ... '토' 

SELECT TO_CHAR(SYSDATE, 'MONTH') FROM DUAL;
-- MON, MONTH : X월 -> '1월', '2월', ..., '12월'

-- 사원테이블에서 사원명, 입사날짜 조회 (단, 입사날짜 형식 "XXXX년 XX월 XX일 으로 조회)
SELECT EMP_NAME, TO_CHAR(HIRE_DATE, 'YYYY"년" MM"월" DD"일"')
FROM EMPLOYEE;
-- => 표시할 문자(글자)는 큰따옴표("")로 묶어서 포맷에 제시해야함
/*
    * YYYY : 연도를 4자리로 표현 --> 50년 기준 이후 날짜는 2000년대로 인식
        YY : 연도를 2자리로 표현
      RRRR : 연도를 4자리로 표현 --> 1900년대로 인식
        RR : 연도를 2자리로 표현
*/

SELECT TO_CHAR(HIRE_DATE, 'YYYY-MM-DD'), TO_CHAR(HIRE_DATE, 'RRRR-MM-DD') FROM EMPLOYEE;

/* 월과 관련된 포맷
    * MM    : 월 정보를 2자리로 표현 
      MON / MONTH : 월 정보를 'X월', 'JULY' 형식으로 표현 --> 언서 설정에 따라 다를것임
*/
SELECT TO_CHAR(SYSDATE, 'MM') "두자리 표현", TO_CHAR(SYSDATE, 'MON') "월로 표시1"
        , TO_CHAR(SYSDATE, 'MONTH') "월로 표시2"
FROM DUAL;

/*
    일과 관련된 포맷
    * DD : 일 정보를 2자리로 표현
     DDD : 해당 날짜의 당해 기준 몇번째 일수
       D : 요일 정보 => 숫자타입(1: 일요일, ... 7: 토요일)
        -> DAY : "X요일" 표시
           DY  : "X" 표시
*/
SELECT TO_CHAR(SYSDATE, 'DD') "일 정보", TO_CHAR(SYSDATE, 'DDD') "몇번째 일수"
        , TO_CHAR(SYSDATE, 'D') "요일 정보", TO_CHAR(SYSDATE, 'DAY') "요일정보2"
        , TO_CHAR(SYSDATE, 'DY') "요일정보3"
FROM DUAL;
--------------------------------------------------------------------------------
/*
    * TO_DATE : 숫자타입 또는 문자타입을 날짜타입으로 변경하는 함수
    
    [표현법]
            TO_DATE(숫자|문자[, 포맷]) => 날짜타입
*/
SELECT TO_DATE(20240719) FROM DUAL;
SELECT TO_DATE(240719) FROM DUAL;  --> 자동으로 50년 미만은 20XX으로 설정

SELECT TO_DATE(550719) FROM DUAL;  --> 50년 이상은 19xx으로 설정

SELECT TO_DATE(020222) FROM DUAL;  --> 숫자는 0으로 시작하면 안됨
SELECT TO_DATE('020222') FROM DUAL;--> 0으로 시작되는 경우 문자타입으로 제시

SELECT TO_DATE('20240719 104900') FROM DUAL; --> YYYYMMDD HHMISS 이 경우에는 형식을 지정해야함
SELECT TO_DATE('20240719 104900', 'YYYYMMDD HH24MISS') FROM DUAL;

--------------------------------------------------------------------------------
/*
    TO_NUMBER : 문자타입의 데이터를 숫자타입으로 변경시켜주는 함수
    
    [표현법]
            TO_NUMBER(문자[, 포맷])
*/
SELECT TO_NUMBER('0123456789') FROM DUAL;

SELECT '10000' + '500' FROM DUAL; -- 자동으로 문자 -> 숫자타입으로 변환되어 산술연산 수행됨
SELECT '10,000' + '500' FROM DUAL; -->
SELECT TO_NUMBER('10,000', '99,999') + TO_NUMBER('500', '999') FROM DUAL;

--==============================================================================

/*
    NULL 처리 함수
*/
/*
    * NVL : 해당 컬럼의 값이 NULL일 경우 다른 값으로 사용할 수 있도록 변환해주는 함수
    
    [표현법]
            NVL(컬럼, 해당 컬럼의 값이 NULL인 경우 사용할 값)
*/
-- 사원테이블에서 사원명, 보너스 정보를 조회 (단, 보너스 값이 NULL인 경우 0으로 조회)
SELECT EMP_NAME, NVL(BONUS, 0) "BONUS" 
FROM EMPLOYEE;

-- 사원 테이블에서 사원명, 보너스포함 연봉

SELECT EMP_NAME "사원명", SALARY*12, BONUS, (SALARY + SALARY*NVL(BONUS, 0))*12 "보너스 포함연봉" 
FROM EMPLOYEE;

/*
    NVL2 : 해당 컬럼이 NULL일 경우 표시할 값을 지정하고,
                    NULL이 아닐 경우(데이터가 존재하는 경우) 표시할 값을 지정
                    
    [표현법]
            NVL2(컬럼, 데이터가 존재하는 경우 사용할 값, NULL인 경우 사용할 값)
*/
-- 사원명, 보너스 유무(O/X) 조회
SELECT EMP_NAME, NVL2(BONUS, 'O', 'X') "보너스" 
FROM EMPLOYEE;

-- 사원명, 부서코드, 부서배치여부('배정완료', '미배정')
SELECT EMP_NAME "사원명", DEPT_CODE "부서코드", NVL2(DEPT_CODE, '배정완료', '미배정') "부서배치여부"
FROM EMPLOYEE;

-- NULLIF : 두 값이 일치하면 NULL, 일치하지 않는다면 비교대상1 반환
-- [표현법] NULLIF(비교대상1, 비교대상2)

SELECT NULLIF('999', '999') FROM DUAL; -- 결과 : NULL
SELECT NULLIF('999', '555') FROM DUAL; -- 결과 : 999
--==============================================================================



















