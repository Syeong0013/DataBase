-- 현재 날짜를 반환
SELECT 
	SYSDATE
FROM DUAL;

-- 현재 날짜 - 1 반환
SELECT 
	SYSDATE -1
FROM DUAL;

-- 현재 날짜 + 1 반환
SELECT 
	SYSDATE +1
FROM DUAL;

-- 현재 달에서 마지막 날짜를 반환 
SELECT 
	LAST_DAY(SYSDATE) 
FROM DUAL;

-- 현재 날짜에서 지정된 개월수만큼 경과된 일자를 반환
SELECT 
	ADD_MONTHS(SYSDATE,3)
FROM DUAL;

-- 현재 날짜 이후 지정된 다음 요일이 되는 일자를 반환
SELECT
	NEXT_DAY(SYSDATE, '일요일'),
	NEXT_DAY(SYSDATE, '일'),
	/*
	1: 일 2: 월 3: 화 4: 수 5: 목 6: 금 7: 토
	*/
	NEXT_DAY(SYSDATE, 7)
FROM DUAL;

-- 두 개의 날짜 사이의 개월 수를 반환
SELECT
	MONTHS_BETWEEN(SYSDATE,'20221001'),
	MONTHS_BETWEEN(SYSDATE,'20220101')
FROM DUAL;

-- TRUNC를 이용한 날짜 버림
SELECT 
	TRUNC(TO_DATE('18-03-02','YY-MM-DD'),'MM')
FROM DUAL;