 create or replace PACKAGE BODY PKG_BANK AS


------------------------------------------------------------------------------
	-- 회원별 계좌 리스트 조회
	 PROCEDURE PROC_SEL_BANKLIST
	 (
		IN_MID			IN	VARCHAR2
		,O_CUR			OUT	SYS_REFCURSOR
	 )AS
		
	 BEGIN
	 
		OPEN O_CUR FOR
			SELECT T2.MID, T2.MNAME, T1.BID, T1.BNAME
			FROM BANKBOOK T1, BANK_MEMBERS T2
			WHERE T1.MID = T2.MID
			AND T1.MID LIKE '%' || IN_MID || '%'	-- NULL 입력시 모든 회원 조회 
			ORDER BY T1.MID
			;
		
	 END PROC_SEL_BANKLIST;

------------------------------------------------------------------------------
	-- 이체 하기 // 출금 입금
	
	PROCEDURE PROC_INS_TRANS
	(
		 IN_SEND_BID	IN	VARCHAR2		-- 송금통장
		,IN_REC_BID		IN	VARCHAR2		-- 입금통장
		,IN_PRICE		IN	VARCHAR2
		,O_ERRCODE		OUT	VARCHAR2
		,O_ERRMSG		OUT	VARCHAR2
		
	)AS
	
		V_CNT_SEND_BID		NUMBER(1);
		V_CNT_REC_BID		NUMBER(1);
		V_TLTPRICE		NUMBER(10);
		V_IDX			NUMBER(5);
		
		
		CNT_SEND_BID_EXCEPTION	EXCEPTION;
		CNT_REC_BID_EXCEPTION	EXCEPTION;
		SAME_BID_EXCEPTION		EXCEPTION;
		TLTPRICE_EXCEPTION	EXCEPTION;
	 
	 BEGIN
		
		-- 출금 (송금) 
		-- 송금할 계좌 존재 여부 학인 > 없다면 EXCEPTION 처리
		SELECT COUNT(BID)
		INTO V_CNT_SEND_BID
		FROM BANKBOOK
		WHERE BID = IN_SEND_BID;
		
		-- 입금할 계좌 존재 여부 확인
		SELECT COUNT(BID)
		INTO V_CNT_REC_BID
		FROM BANKBOOK
		WHERE BID = IN_REC_BID;
		
		-- 송금할 금액과 계좌 잔고를 비교 
		SELECT NVL(SUM(PRICE), 0)
		INTO V_TLTPRICE
		FROM
		(
		SELECT IDX, BID, PRICE * DECODE(GBN,'I', 1, -1) AS PRICE
		FROM SAVE_TBL
		WHERE BID = IN_SEND_BID
		)
		;
		
		-- 송금하게 된다면 INDEX 번호 생성 
		SELECT NVL(MAX(IDX), 0) +1
		INTO V_IDX
		FROM SAVE_TBL
		;
		
		
		IF V_CNT_SEND_BID = 0 THEN -- 계좌가 없다면 
			RAISE CNT_SEND_BID_EXCEPTION;
		
		ELSIF V_CNT_REC_BID = 0 THEN
			RAISE CNT_REC_BID_EXCEPTION;
		
		ELSIF	IN_SEND_BID = IN_REC_BID THEN
			RAISE SAME_BID_EXCEPTION;
			
		ELSIF V_TLTPRICE < IN_PRICE THEN					-- 계좌가 존재한다면 입력받은 송금금액과 계좌 잔고를 비교
			RAISE TLTPRICE_EXCEPTION;
		
		ELSIF V_TLTPRICE > IN_PRICE THEN					-- 계좌잔고가 송금할 금액보다 많다면 이체 실행
			INSERT INTO SAVE_TBL (IDX, BID, PRICE, GBN)
			VALUES(V_IDX, IN_SEND_BID, IN_PRICE, 'O')
			;
			
			INSERT INTO SAVE_TBL(IDX, BID, PRICE, GBN)
			VALUES(V_IDX +1, IN_REC_BID, IN_PRICE, 'I')
			;
			
		END IF;
		
-------------------------------------------------------------------------------

		EXCEPTION
		WHEN CNT_SEND_BID_EXCEPTION THEN
			O_ERRCODE := 'ERROR-001';
			O_ERRMSG := '출금할 계좌가 존재하지 않습니다.';
			ROLLBACK;
		
		WHEN CNT_REC_BID_EXCEPTION THEN
			O_ERRCODE := 'ERROR-002';
			O_ERRMSG := '예금주가 존재하지 않습니다.';
			ROLLBACK;
			
		WHEN SAME_BID_EXCEPTION THEN
			O_ERRCODE := 'ERROR-003';
			O_ERRMSG := '출금 계좌와 예금 계좌가 동일합니다.';
			
		WHEN TLTPRICE_EXCEPTION THEN
			O_ERRCODE := 'ERROR-004';
			O_ERRMSG := '잔고가 부족합니다.';
			ROLLBACK;
		
		
	 END PROC_INS_TRANS;
 
 ------------------------------------------------------------------------------
	
	-- 계좌개설
	PROCEDURE PROC_INS_BANKBOOK
	(
		IN_MID			IN	VARCHAR2
		,IN_BID			IN	VARCHAR2
		,IN_BNAME		IN	VARCHAR2
		
		,O_ERRCODE		OUT	VARCHAR2
		,O_ERRMSG		OUT	VARCHAR2
	)
	AS
	
		V_CNT_MID		CHAR(4);
		V_CNT_BID		CHAR(4);
		
		MID_EXCEPTION	EXCEPTION;
		BID_EXCEPTION	EXCEPTION;
		
	BEGIN
		-- 해당 MID가 존재하는 지 확인
		SELECT COUNT(MID)
		INTO V_CNT_MID
		FROM BANK_MEMBERS
		WHERE MID = IN_MID
		;
		
		-- 해당 BID가 존재하는 지 확인
		SELECT COUNT(BID)
		INTO V_CNT_BID
		FROM BANKBOOK
		WHERE BID = IN_BID
		;
		
		IF V_CNT_MID = 0 THEN							-- 회원전화번호가 존재하지 않으면 예외처리 
			RAISE MID_EXCEPTION;
						
		ELSIF V_CNT_BID = 1 THEN						-- 계좌번호가 존재하면 예외처리
			RAISE BID_EXCEPTION;	
		
		ELSE
			INSERT INTO BANKBOOK(BID, BNAME, MID)
			VALUES(IN_BID, IN_BNAME, IN_MID)
			;
		
		END IF;
		
		
		EXCEPTION
		WHEN MID_EXCEPTION THEN
			O_ERRCODE := 'ERROR-001';
			O_ERRMSG := '회원 아이디가 존재하지 않습니다.';
		
		WHEN BID_EXCEPTION THEN
			O_ERRCODE := 'ERROR-002';
			O_ERRMSG := '계좌번호가 이미 존재합니다.';
		
		WHEN OTHERS THEN
			O_ERRCODE := SQLCODE;
			O_ERRMSG := SQLERRM;
			
	END PROC_INS_BANKBOOK;

-----------------------------------------------------------------------------
	PROCEDURE PROC_INS_MEMBER
	(
		IN_MNAME		IN	VARCHAR2
		,IN_MTEL		IN	VARCHAR2
		
		,O_ERRCODE		OUT	VARCHAR2
		,O_ERRMSG		OUT	VARCHAR2
	)
	AS
	
		V_CNT_MEM		NUMBER(1);
		V_NEW_MID		CHAR(4);
		
		MEM_EXCEPTION	EXCEPTION;
		
	BEGIN
	
		-- 회원이 존재하는 지 확인 (이름과 전화번호로 확인)
		SELECT COUNT(*)
		INTO V_CNT_MEM
		FROM BANK_MEMBERS
		WHERE MNAME = IN_MNAME
			AND MTEL = IN_MTEL
		;
		
		-- 회원 아이디 생성
		SELECT 'M'|| TO_CHAR(TO_NUMBER(NVL(SUBSTR(MAX(MID),2,3),0)) +1, 'FM000')
		INTO V_NEW_MID
		FROM BANK_MEMBERS
		;
		
		IF V_CNT_MEM = 1 THEN
			RAISE MEM_EXCEPTION;
		
		ELSE
			INSERT INTO BANK_MEMBERS(MID, MNAME, MTEL)
			VALUES(V_NEW_MID, IN_MNAME, IN_MTEL);
		
		END IF;
		
		EXCEPTION 
			WHEN MEM_EXCEPTION THEN
				O_ERRCODE := 'ERROR-001';
				O_ERRMSG := '이미 존재하는 회원입니다.';
				ROLLBACK;
		
			WHEN OTHERS THEN
				O_ERRCODE := SQLCODE;
				O_ERRMSG := SQLERRM;
				
	END PROC_INS_MEMBER;
	
END PKG_BANK;