-- TO_CHAR 날짜 포맷


--1. 세기
SELECT TO_CHAR(SYSDATE, 'CC') FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'SCC') FROM DUAL;


--2. 분기 (중요)
SELECT TO_CHAR(SYSDATE, 'Q') FROM DUAL;
SELECT TO_CHAR(TO_DATE('2021-04-05','YYYY-MM-DD'), 'Q') FROM DUAL;
SELECT TO_CHAR(TO_DATE('2021-07-15','YYYY-MM-DD'), 'Q') FROM DUAL;
SELECT TO_CHAR(TO_DATE('2021-11-05','YYYY-MM-DD'), 'Q') FROM DUAL;

--년도별 분기
SELECT TO_CHAR(TO_DATE(BIRTH, 'YYYYMMDD'),'Q') FROM PROFESSORS;


--영문으로 월을 표시할 때 
SELECT BIRTH, TO_CHAR(TO_DATE(BIRTH, 'YYYYMMDD'), 'MM'),					 -- 달을 숫자로 
			  TO_CHAR(TO_DATE(BIRTH, 'YYYYMMDD'), 'MONTH') FROM PROFESSORS;  -- 달 뒤에 월을 붙여서, 영어의 경우 영문으로 표기
			  

--해당 연도의 몇 주차인지 (중요) 										--20210221 기준
SELECT TO_CHAR(SYSDATE, 'WW') FROM DUAL;							-- 08 출력	// 연도별 주차
SELECT TO_CHAR(SYSDATE, 'W') FROM DUAL;								-- 3 출력	// 월별 주차

SELECT TO_CHAR(TO_DATE('20220101', 'YYYYMMDD'), 'WW')FROM DUAL;		-- 01 출력
SELECT TO_CHAR(TO_DATE('20211231', 'YYYYMMDD'), 'WW')FROM DUAL;		-- 53 출력

			-- ! 통계적으로 주차를 나눌때 위 두 날짜가 같은 주에 들어가야하므로 주의할 것
			
SELECT TO_CHAR(TO_DATE('20220101', 'YYYYMMDD'), 'IW')FROM DUAL;		-- 52 출력
SELECT TO_CHAR(TO_DATE('20211231', 'YYYYMMDD'), 'IW')FROM DUAL;		-- 52 출력

--해당 년, 월, 주의 며칠 차인지 표시 
SELECT TO_CHAR(SYSDATE, 'DDD') FROM DUAL;							-- 연중 며칠 차인지
SELECT TO_CHAR(SYSDATE, 'DD') FROM DUAL;							-- 월중 며칠 차인지
SELECT TO_CHAR(SYSDATE, 'D') FROM DUAL;								-- 주중 며칠 차인지( 일요일부터  
SELECT TO_CHAR(SYSDATE, 'D')-1 FROM DUAL;								-- 주중 며칠 차인지( 월요일부터  

--주를 영어(한글)로 표시 
SELECT TO_CHAR(SYSDATE, 'DY') FROM DUAL;							-- 월 출력
SELECT TO_CHAR(SYSDATE, 'DAY') FROM DUAL;							-- 월 출력
SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD ') || TO_CHAR(SYSDATE, 'DAY') FROM DUAL;	-- 날짜와 요일 출력


--년도 표시방법
SELECT TO_CHAR(SYSDATE, 'YYYY') FROM DUAL;							-- 2022 출력
------------------------------------------- 년도를 맨 뒤에서부터 잘라온다.
SELECT TO_CHAR(SYSDATE, 'I') FROM DUAL;								-- 2 출력
SELECT TO_CHAR(SYSDATE, 'IY') FROM DUAL;							-- 22 출력
SELECT TO_CHAR(SYSDATE, 'IYY') FROM DUAL;							-- 022 출력
SELECT TO_CHAR(SYSDATE, 'IYYY') FROM DUAL;							-- 2022 출력
------------------------------------------- 년도 맨 뒷 두 자리/ 네 자리 표기 
SELECT TO_CHAR(SYSDATE, 'RR') FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'RRRR') FROM DUAL;

-- 시간 오전 오후 표시
SELECT TO_CHAR(SYSDATE, 'AM HH24:MI:SS') FROM DUAL;					-- AM /PM 뭘 적든 올바른 결과 출력
SELECT TO_CHAR(SYSDATE, 'AM HH:MI:SS') FROM DUAL;


-- 로마자 표시
SELECT TO_CHAR(SYSDATE, 'RM') FROM DUAL;							-- RM 달을 로마자로 표기 
SELECT TO_CHAR(SYSDATE, 'RR') FROM DUAL;

-- 초 표시 
SELECT TO_CHAR(SYSDATE, 'SS') FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'SSSSS') FROM DUAL;							-- 오늘 자정을 기준으로 지나간 초를 세어준다.


--TO_CHAR 문자열로서의 사용법
SELECT TO_CHAR(1, '000') FROM DUAL;									-- 맨 앞에 공백이생김
SELECT TO_CHAR(1, 'FM000') FROM DUAL;								-- 맨 앞에 공백 제거


--다음 회원 회원가입시 몇 번 -- S011

--1. 첫번째 ID값의 MAX값을 찾는다.
SELECT MAX(SID) FROM STUDENTS;

--2. 찾은 MAX값에서 숫자만 분리
SELECT SUBSTR(MAX(SID), 2,3)
FROM STUDENTS;

--3. 자른 값을 숫자로 변환
SELECT TO_NUMBER(SUBSTR(MAX(SID),2,3))
FROM STUDENTS;

--4. 숫자값에 +1
SELECT TO_NUMBER(SUBSTR(MAX(SID),2,3)) +1
FROM STUDENTS;

--5. TO_CHAR을 사용해서 문자로 000형태로 변환
SELECT 'S'|| TO_CHAR(TO_NUMBER(SUBSTR(MAX(SID),2,3)) +1, 'FM000')
FROM STUDENTS;

--다른방법 : LPAD
SELECT 'S'|| LPAD(TO_NUMBER(SUBSTR(MAX(SID),2,3)) +1, 3, '0')FROM STUDENTS;


-- 숫자값 3번째마다 반점을 넣는 방법
SELECT 214137892398 FROM DUAL;

SELECT TO_CHAR(214137892398, 'FM999,999,999,999') FROM DUAL;
