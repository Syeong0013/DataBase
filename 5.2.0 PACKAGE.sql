-- 패키지 = 프로시저의 모음 
/*
	패키지
	- 프로시저, 함수 등을 집합해놓은 객체


	선언부, 본문으로 이루어져있음
	
	
	[구문형식]
	-선언부
	CREATE OR REPLACE PACKAGE 패키지명
	IS
	패키지 내 전역 변수 선언;
	PROCEDURE 프로시저 1( 매개변수 1, ...);
	~~
	FUNTION 함수(매개변수 1,...2)RETURN 타입;
	
	END;
	
	-본문
	CREATE OR REPLACE PACKAGE BODY 패키지명
	IS
	PROCEDURE 프로시저 이름
	SUBPROGRAM BODIS : 실제 동작하게 될 서브프로그램( 프로시저, 함수 )
	END;
*/

SELECT * FROM  STUDENTS_TBL 
WHERE STU_ID =:IN_STU_ID
AND STU_NAME =:IN_STU_NAME
;

-- 아이디에 9 포함되거나 이름에 김 포함되는 경우를 출력
SELECT * FROM STUDENTS_TBL 
WHERE STU_ID LIKE '%9%'
OR STU_NAME LIKE '%김%'
;

-- 아이디에 특정 문자 검색하고 싶을 때
SELECT * FROM STUDENTS_TBL 
WHERE STU_ID LIKE '%' || :IN_STU_ID || '%'
AND STU_NAME LIKE '%' || :IN_STU_NAME || '%'
;


