create or replace NONEDITIONABLE PACKAGE BODY PKG_COMMONS AS

-------------------------------------------------------------------------------
		-- INSERT 프로시저
  PROCEDURE PROC_INS_GRPCOMMONS
    (
        IN_GRP_NAME     IN  VARCHAR2
    ) AS
    
    V_NEW_GRP_ID        CHAR(6);
    
  BEGIN
    
    --새로운 아이디 만들기
    SELECT 'GRP' || TO_CHAR(NVL(TO_NUMBER(SUBSTR(MAX(GRP_ID), 4, 3)), 0) + 1, 'FM000')
    INTO V_NEW_GRP_ID
    FROM GRPCOMMONS_TBL
    ;
    
    INSERT INTO GRPCOMMONS_TBL(GRP_ID, GRP_NAME)
    VALUES(V_NEW_GRP_ID, IN_GRP_NAME);
       
  END PROC_INS_GRPCOMMONS;
  
-------------------------------------------------------------------------------
		-- SELECT 프로시저
  PROCEDURE PROC_SEL_GRPCOMMONS
	(
		  IN_GRP_ID		IN	VARCHAR2
		, IN_GRP_NAME	IN	VARCHAR2
		, O_CUR		OUT	SYS_REFCURSOR
	) AS
  BEGIN
  
	--커서 오픈
	OPEN O_CUR FOR
	SELECT * FROM GRPCOMMONS_TBL
	WHERE GRP_ID LIKE '%' || IN_GRP_ID || '%' -- : 제거
	AND GRP_NAME LIKE '%' || IN_GRP_NAME || '%' 
	;

  
  END PROC_SEL_GRPCOMMONS;
-------------------------------------------------------------------------------
	-- UPDATE 프로시저
  PROCEDURE PROC_UP_GRPCOMMONS
	(
		  IN_GRP_ID		IN	VARCHAR2
		, IN_GRP_NAME	IN	VARCHAR2
	) AS
  BEGIN
    
	UPDATE GRPCOMMONS_TBL
	SET -- GRP_ID =: IN_GRP_ID > PK를 바꾸는 경우 X
		GRP_NAME = IN_GRP_NAME
	WHERE GRP_ID = IN_GRP_ID
	;

  END PROC_UP_GRPCOMMONS;
-------------------------------------------------------------------------------
		-- DELETE 프로시저  
  PROCEDURE PROC_DEL_GRPCOMMONS
	(
		  IN_GRP_ID 	IN 	VARCHAR2
	) AS
  BEGIN
   
    DELETE FROM GRPCOMMONS_TBL
	WHERE GRP_ID = IN_GRP_ID
	;
	
  END PROC_DEL_GRPCOMMONS;
  
  
  
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------



	-- COMMONS INSERT
	PROCEDURE PROC_INS_COMMONS
	(
	 --	 IN_COM_ID 		IN 	VARCHAR2	> 마지막 값을 찾아내어 그 뒤에 오도록 할당할 것이기 때문에 변수로 선언
		 IN_GRP_ID		IN 	VARCHAR2
		,IN_COM_VAL		IN	VARCHAR2
		,IN_COM_LVL		IN 	VARCHAR2
		,IN_PARENT_ID	IN	VARCHAR2
	)
	AS
		-- 변수 선언 구간
		V_NEW_ROOT_ID	CHAR(7); -- EX) COM1000 > CHAR(7)
		V_NEW_COM_ID	CHAR(7); -- EX) COM0001 > CHAR(7)
		V_GRP_CNT		NUMBER;
		
	BEGIN
		-- 입력받아온 GRP_ID에 데이터가 존재하는지 COUNT(*)로 확인
		SELECT COUNT(*)
		INTO V_GRP_CNT
		FROM COMMONS_TBL 
		WHERE GRP_ID = IN_GRP_ID --'GRP003'
		;
		
		-- 만약 V_GRP_CNT( 해당 GRP_ID에 데이터가 존재하지 않는다면 )
		IF V_GRP_CNT = 0 THEN 
		
			-----------------------------------------------------------------------
			-- V_NEW_ROOT_ID 할당
			SELECT 'COM' || TO_CHAR(NVL(TO_NUMBER(SUBSTR(MAX(COM_ID),4,1)), 0) +1) || '000'
			INTO V_NEW_ROOT_ID
			FROM COMMONS_TBL
			;
			
			-- ROOT 데이터 INSERT
			INSERT INTO COMMONS_TBL(COM_ID, GRP_ID, COM_VAL, COM_LVL, PARENT_ID)
			VALUES(V_NEW_ROOT_ID, IN_GRP_ID, 'ROOT', 0, 'ROOT')
			;
			-----------------------------------------------------------------------
			-- V_NEW_COM_ID 할당
			SELECT 
				'COM' || TO_CHAR(NVL(TO_NUMBER(SUBSTR(MAX(COM_ID), 4, 4)), 0) +1, 'FM0000')
			INTO V_NEW_COM_ID
			FROM COMMONS_TBL
			WHERE GRP_ID = IN_GRP_ID	--'GRP003'
			AND PARENT_ID != 'ROOT' 	-- 이 조건을 주지 않으면 COM1000을 반환
			;
			-- ROOT 하위 데이터 INSERT
			INSERT INTO COMMONS_TBL(COM_ID, GRP_ID, COM_VAL, COM_LVL, PARENT_ID)
			VALUES(V_NEW_COM_ID, IN_GRP_ID, IN_COM_VAL, IN_COM_LVL, V_NEW_ROOT_ID)
			;
			-----------------------------------------------------------------------
		ELSE --( 데이터가 하나라도 존재한다면 ) ROOT는 생성 불필요, 새로 만들 하위 데이터 생성
			SELECT 
				'COM' || TO_CHAR(NVL(TO_NUMBER(SUBSTR(MAX(COM_ID), 4, 4)), 0) +1, 'FM0000')
			INTO V_NEW_COM_ID
			FROM COMMONS_TBL
			WHERE GRP_ID = IN_GRP_ID
			AND PARENT_ID != 'ROOT' 	-- 이 조건을 주지 않으면 COM1000을 반환
			;
			-- ROOT 하위 데이터 INSERT
			INSERT INTO COMMONS_TBL(COM_ID, GRP_ID, COM_VAL, COM_LVL, PARENT_ID)
			VALUES(V_NEW_COM_ID, IN_GRP_ID, IN_COM_VAL, IN_COM_LVL, IN_PARENT_ID)
			;
		END IF;
			
	END PROC_INS_COMMONS;
-------------------------------------------------------------------------------
	-- COMMONS SELECT
	PROCEDURE PROC_SEL_COMMONS
	(
		  IN_COM_ID		IN	VARCHAR2
		, IN_GRP_ID		IN 	VARCHAR2
		, IN_COM_VAL	IN	VARCHAR2
		, IN_COM_LVL	IN	VARCHAR2
		-- , IN_PARENT_ID	IN	VARCHAR2
		, O_CUR			OUT	SYS_REFCURSOR
	)
	AS
	BEGIN
	
	OPEN O_CUR FOR
	SELECT COM_ID, GRP_ID, COM_VAL, COM_LVL, PARENT_ID FROM COMMONS_TBL 
	WHERE	COM_ID LIKE '%' || IN_COM_ID || '%'
		AND GRP_ID LIKE '%' || IN_GRP_ID || '%'
		AND COM_VAL LIKE '%' || IN_COM_VAL || '%'
		AND COM_LVL LIKE '%' || IN_COM_LVL || '%'
		-- AND PARENT_ID LIKE '%' || IN_PARENT_ID || '%'
	START WITH PARENT_ID = 'ROOT' AND GRP_ID = IN_GRP_ID
	CONNECT BY PRIOR COM_ID = PARENT_ID AND GRP_ID = IN_GRP_ID
	;
	
	END PROC_SEL_COMMONS;
	
	-- COMMONS UPDATE
	PROCEDURE PROC_UP_COMMONS
	(
		  IN_COM_ID		IN	VARCHAR2
		, IN_GRP_ID		IN 	VARCHAR2
		, IN_COM_VAL	IN	VARCHAR2
		, IN_COM_LVL	IN	VARCHAR2
		, IN_PARENT_ID	IN	VARCHAR2
	)
	AS
	
	BEGIN
	
		UPDATE COMMONS_TBL
		SET COM_VAL = IN_COM_VAL
			,COM_LVL = IN_COM_LVL
			,PARENT_ID = IN_PARENT_ID
		WHERE 
			COM_ID = IN_COM_ID
			AND GRP_ID = IN_GRP_ID
		;
			
	END PROC_UP_COMMONS;
	
	
	-- COMMONS DELETE
	-- ! 삭제하려는 COM_ID가 PARENT_ID인 컬럼도 함께 삭제해야함 
	PROCEDURE PROC_DEL_COMMONS
	(
		 IN_COM_ID		IN	VARCHAR2
		,IN_GRP_ID		IN 	VARCHAR2
	)
	AS
	BEGIN
	 
	 DELETE FROM COMMONS_TBL
	 WHERE COM_ID IN -- IN연산자는 VARCHAR
	 (
		 SELECT COM_ID
		 FROM COMMONS_TBL
		 START WITH COM_ID = IN_COM_ID AND GRP_ID = IN_GRP_ID
		 CONNECT BY PRIOR COM_ID = PARENT_ID AND GRP_ID = IN_GRP_ID
	 )
	 AND GRP_ID = IN_GRP_ID
	 ;
	 
	END PROC_DEL_COMMONS;
	
	
END PKG_COMMONS;