-- 함수 -- 필요한 기능이 있으면 만들어서 반복적으로 사용
-- 오라클이 제공하고 있는 내장함수
--1. 문자열함수

--1.1 CONCAT -- '두 개'의 문자열을 합치는 함수
SELECT CONCAT(SNAME, SADDR) FROM STUDENTS;
SELECT SNAME || SADDR FROM STUDENTS;


--1.2 LOWER  -- 모든 영문 문자를 숫자로 바꿔주는 함수
SELECT LOWER('AAAAAAAADFASDG') FROM DUAL;

--1.3 UPPER -- 모든 소문자를 대문자로 치환
SELECT UPPER('aaasdgvbad') FROM DUAL;


--1.4  INITCAP -- 단락별 첫글자를 대문자로 치환
SELECT 'this is a book' FROM DUAL;

--1.5 CHR --아스키 코드값
SELECT CHR(104) FROM DUAL;

--1.6 TRIM, LTRIM, RTRIM /LTRIM은 왼쪽 공백 RTRIM은 오른쪽 공백
SELECT TRIM ('                    공 백   ') FROM DUAL;  --양쪽 공백 제거/ 가운데 띄어쓰기는 제거 X


--1.7 LPAD , RPAD -- 계층형 데이터 다룰 때 사용
SELECT 'AABBBBB' FROM DUAL;
SELECT LPAD('AAABBBB', 10) FROM DUAL; -- 필드값을 무조건 10바이트(입력값)으로 만듬
SELECT LPAD('홍길동아아', 10) FROM DUAL; -- 한글은 2바이트 처리
SELECT LPAD('AAABBBB',10, '@') FROM DUAL;

SELECT RPAD('AAABBBB', 10) FROM DUAL; -- 필드값을 무조건 10바이트(입력값)으로 만듬
SELECT RPAD('AAABBBB',10, '@') FROM DUAL;

--1.8 REPLACE -- 특정 문자열 치환 
SELECT REPLACE('AAA-BBB:CCCC', '-', '!!!') FROM DUAL;
SELECT REPLACE('AAA-BBB:CCCC', '!', '@@@@') FROM DUAL;
SELECT REPLACE(REPLACE('AAA-BBB:CCCC',':','!'), '-', '!!!') FROM DUAL;

--1.9 SUBSTR -- 특정 문자열을 잘라냄
SELECT '1234567890' FROM  DUAL;
SELECT SUBSTR('1234567890', 2, 7) FROM  DUAL;
SELECT SUBSTR(TRIM (BIRTH), 5, 4) FROM PROFESSORS;

--1.10 INSTR --특정 문자열을 찾아주는 함수 (JS의 INDEXOF)
SELECT INSTR('1234567890', '9') FROM DUAL; -- INDEX = 1 시작
SELECT INSTR('!(!@$%$%)(@$)((', '(') FROM DUAL; -- 첫번째값만 찾아옴 

-- 오라클하면 절대 모를 수 없는 함수 
--1.11 TO_CHAR() -- 데이터 타입을 문자열로 변환하는 함수
SELECT TO_CHAR(SAGE, '000') FROM STUDENTS;





