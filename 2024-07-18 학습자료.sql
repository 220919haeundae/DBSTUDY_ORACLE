-- 사원 정보 중 사원번호, 이름, 월급을 조회
select EMP_ID, EMP_NAME, SALARY
FROM EMPLOYEE;

-- 부서코드가 'D9'인 사원의 이름, 부서코드 조회
SELECT EMP_NAME, DEPT_CODE "부서코드" -- (3)
FROM EMPLOYEE            -- (1)
WHERE DEPT_CODE = 'D9';  -- (2)

-- 연락처의 4번째자리가 7인 직원의 이름, 연락처 조회
SELECT EMP_NAME, PHONE
FROM EMPLOYEE
WHERE PHONE LIKE '___7%';

-- 직급코드가 'J7'인 직원 중 급여가 200만원 이상인 직원의 이름, 급여, 직급코드 조회
SELECT EMP_NAME, SALARY, JOB_CODE
FROM EMPLOYEE
WHERE JOB_CODE IN 'J7' AND SALARY >= 2000000;

-- 전체 사원 정보를 최근 입사일 기준으로 정렬하여 조회
SELECT *
FROM EMPLOYEE
ORDER BY HIRE_DATE DESC;
-- "기본값" ASC NULLS LAST -- NULL 값을 뒤쪽에 배치하여 조회
-- "역순" DESC NULLFIRST -- NULL 값을 앞쪽 배치하여 조회

