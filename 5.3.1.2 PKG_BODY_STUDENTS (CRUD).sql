create or replace NONEDITIONABLE PACKAGE BODY PKG_STUDENTS AS
	-- 1. 삽입
	PROCEDURE PROC_INS_STUDENTS
	(
		  IN_STU_NAME		IN VARCHAR2
		, IN_STU_TEL		IN VARCHAR2
		, IN_STU_ADDR_GRP	IN VARCHAR2
		, IN_STU_ADDR		IN VARCHAR2
		, IN_STU_DEPT_GRP	IN VARCHAR2
		, IN_STU_DEPT		IN VARCHAR2
		, IN_STU_ADDR2		IN VARCHAR2
	)
	AS
		--변수 선언
		V_NEW_STU_ID		VARCHAR(6);

	BEGIN
		--새로운 아이디값을 찾아서 생성 후 V_NEW_STU_ID에 할당
		SELECT 'STU'|| TO_CHAR(TO_NUMBER(SUBSTR(MAX(STU_ID),4,3)) +1, 'FM000')
		INTO V_NEW_STU_ID
		FROM STUDENTS_TBL;

		INSERT INTO STUDENTS_TBL(STU_ID, STU_NAME, STU_TEL, STU_ADDR_GRP, STU_ADDR, STU_DEPT_GRP, STU_DEPT, STU_ADDR2)
		VALUES(
            V_NEW_STU_ID
            , IN_STU_NAME
            , IN_STU_TEL
            , IN_STU_ADDR_GRP
            , IN_STU_ADDR
            , IN_STU_DEPT_GRP
            , IN_STU_DEPT
            , IN_STU_ADDR2
    );
	END PROC_INS_STUDENTS;
	
	
	--2. 조회
	PROCEDURE PROC_SEL_STUDENTS
	(
		  IN_STU_ID			IN	 VARCHAR2
		, IN_STU_NAME		IN 	 VARCHAR2
		, O_CURSOR			OUT	 SYS_REFCURSOR
	)AS
	
	BEGIN
		OPEN O_CURSOR FOR
		SELECT * FROM STUDENTS_TBL
		WHERE STU_ID LIKE '%' || IN_STU_ID || '%'
		AND STU_NAME LIKE '%' || IN_STU_NAME || '%'
		;
		
	END PROC_SEL_STUDENTS;
	
	-- 3. 수정 
	PROCEDURE PROC_UP_STUDENTS
	(
		  IN_STU_ID			IN VARCHAR2
		, IN_STU_NAME		IN VARCHAR2
		, IN_STU_TEL		IN VARCHAR2
		, IN_STU_ADDR_GRP	IN VARCHAR2
		, IN_STU_ADDR		IN VARCHAR2
		, IN_STU_DEPT_GRP	IN VARCHAR2
		, IN_STU_DEPT		IN VARCHAR2
		, IN_STU_ADDR2		IN VARCHAR2
		, IN_STU_PASS		IN VARCHAR2
	)
	AS
	
	BEGIN
	    UPDATE STUDENTS_TBL 
		SET STU_NAME = IN_STU_NAME, STU_TEL = IN_STU_TEL, STU_ADDR_GRP = IN_STU_ADDR_GRP,
		STU_ADDR = IN_STU_ADDR, STU_ADDR2=IN_STU_ADDR2, STU_DEPT_GRP = IN_STU_DEPT_GRP, 
		STU_DEPT = IN_STU_DEPT,STU_PASS = IN_STU_PASS
    WHERE STU_ID = IN_STU_ID;

	END PROC_UP_STUDENTS;


	-- 4. 삭제 
	PROCEDURE PROC_DEL_STUDENTS
	(
		  IN_STU_ID			IN VARCHAR2
		  ,O_ERRCODE		OUT	VARCHAR2
		  ,O_ERRMSG			OUT	VARCHAR2
	)
	AS
		V_STUDENTS_CNT		NUMBER(1);
		V_STUTIME_CNT		NUMBER(1);
		V_SCORE_CNT		NUMBER(1);
		
		-- 예외처리 변수 
		STUDENTS_DEL_EXCEPTION		EXCEPTION;
		STUTIME_DEL_EXCEPTION		EXCEPTION;
		SCORE_DEL_EXCEPTION			EXCEPTION;
		
	BEGIN
	
		-- 아래 세 개의 업무가 반드시 동시에 발생 ( ALL OR NOTHING )
			-- 1. 학생 데이터를 지운다
			-- 2. 시간표 데이터를 삭제 
			-- 3. 성적 데이터 삭제 
--------------------------------------------------------------------------------

		-- 1. 학생 데이터를 지운다
			-- 1.1 데이터가 존재하는 지 확인 ( 나중에는 MERGE INTO 사용 )
			SELECT DECODE(MAX(STU_ID), NULL, 0, 1)
			INTO V_STUDENTS_CNT
			FROM STUDENTS_TBL 
			WHERE STU_ID = IN_STU_ID
			;
			
		IF V_STUDENTS_CNT = 0 THEN
			-- 에러 발생 ( 사용자 예외처리 )
			RAISE STUDENTS_DEL_EXCEPTION ;
		ELSE
			DELETE FROM STUDENTS_TBL 
			WHERE STU_ID = IN_STU_ID
			;
		END IF;
		
--------------------------------------------------------------------------------		
		
		-- 2. 시간표 데이터를 삭제 
			-- 2.1 데이터가 존재하는 지 확인 ( 나중에는 MERGE INTO 사용 )
			SELECT DECODE(MAX(STU_ID), NULL, 0, 1)
			INTO V_STUTIME_CNT
			FROM STUDENTS_TIME_TBL 
			WHERE STU_ID = IN_STU_ID
			;
		IF V_STUTIME_CNT = 0 THEN
			RAISE STUTIME_DEL_EXCEPTION;
		ELSE
			DELETE FROM STUDENTS_TIME_TBL
			WHERE STU_ID = IN_STU_ID
			;
		END IF;
		
--------------------------------------------------------------------------------		
		-- 3. 성적 데이터 삭제 
			-- 3.1 데이터가 존재하는 지 확인 ( 나중에는 MERGE INTO 사용 )
			SELECT MAX(STU_ID)
			INTO V_SCORE_CNT
			FROM SCORES_TBL
			WHERE STU_ID = IN_STU_ID
			;
			/* -- 다른 예시
			SELECT COUNT(*) INTO V_SCORE_CNT
			FROM SCORES_TBL
			WHERE STU_ID = IN_STU_ID 
			
			IF V_SCORE_CNT = 0 THEN
				RAISE STUTIME_DEL_EXCEPTION;
			*/
			
		IF V_SCORE_CNT = 0 THEN
			RAISE SCORE_DEL_EXCEPTION;
		ELSE
			DELETE FROM SCORES_TBL
			WHERE STU_ID = IN_STU_ID
			;
		END IF;
--------------------------------------------------------------------------------		
		-- 각각에 대해서 삭제할 데이터가 존재하지 않는다면 ROLLBACK 
		
		EXCEPTION
			----------------------- 로직에러 
			WHEN STUDENTS_DEL_EXCEPTION THEN
			O_ERRCODE :='ERR001';
			O_ERRMSG := '삭제하려는 학생의 데이터가 존재하지 않습니다.';
			ROLLBACK;
		
			WHEN STUTIME_DEL_EXCEPTION THEN
			O_ERRCODE :='ERR002';
			O_ERRMSG := '삭제하려는 학생의 데이터가 존재하지 않습니다.';
			ROLLBACK;
			
			WHEN SCORE_DEL_EXCEPTION THEN
			O_ERRCODE :='ERR003';
			O_ERRMSG := '삭제하려는 학생의 데이터가 존재하지 않습니다.';
			ROLLBACK;
			----------------------- 로직에러 
			
			WHEN OTHERS THEN
			O_ERRCODE :=SQLCODE;
			O_ERRMSG := SQLERRM;
			ROLLBACK;
	
	END PROC_DEL_STUDENTS;
END PKG_STUDENTS;
