-- CURSOR 
/*
	SQL 문장을 처리한 결과를 담고있는 메모리 영역을 가르키는 일종의 포인터
	
	묵시적 커서 : 오라클 내부에서 자동으로 생성되어 SQL문장이 실행될 때마다 자동으로 만들어져 실행되는 커서 
	명시적 커서 : 사용자가 직접 정의해서 사용하는 커서
	
	
	
	커서 선언 
	CURSOR 커서명 (매개변수1, 매개변수2 ... )
	IS
	SELECT 문;
	
	커서 열기 
	OPEN 커서명 (매개변수1, 매개변수2 ...)
	
	커서 사용
	LOOP
	FETCH 커서명  INTO 변수1, 변수2...
	EXIT WHEN 커서명%NOTFOUND;
	END LOOP;
	
	커서 닫기 ㅇ
	CLOSE 커서명;
*/

DECLARE
	STU_ID 		VARCHAR2(100);
	STU_NAME 	VARCHAR2(100);
	
	CURSOR EX_CUR
	IS
	SELECT
	STU_ID,
	STU_NAME
	FROM
	STUDENTS_TBL;
	
	BEGIN
	OPEN EX_CUR;
	
	
	LOOP 
	FETCH EX_CUR INTO STU_ID, STU_NAME;  --커서에서 데이터 가져오기 
	EXIT WHEN EX_CUR %NOTFOUND; -- 커서가 없을 경우 종
	END LOOP;
	
	CLOSE EX_CUR;
	END;