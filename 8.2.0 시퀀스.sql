-- 시퀀스
CREATE TABLE TEST_TBL 
(
	IDX		INTEGER		PRIMARY KEY
	,NAME	VARCHAR2(40)	NOT NULL
);

INSERT INTO TEST_TBL VALUES(1, '홍길동');
INSERT INTO TEST_TBL VALUES(2, '홍길동');
INSERT INTO TEST_TBL VALUES(3, '홍길동');
INSERT INTO TEST_TBL VALUES(4, '홍길동');
INSERT INTO TEST_TBL VALUES(5, '홍길동');

-- PROCEDURE
	SELECT NVL(MAX(IDX),0) +1
	INTO V_NEW_IDX
	FROM TEST_TBL
	;
	 
-- SEQ
	SELECT SEQ_TEST_TBL.NEXTVAL
	FROM DUAL
	;
	
	/*
		1. INSERT, UPDATE 가 몇 번 날라오는 지 확인하고 싶을 때 
			변수로 선언하여 그 값을 가져온다.
		2. 홀수로 증가하는 
		
		-- 한 번 사용한 수에 대해서 다시 돌아오지 않음. 
	*/