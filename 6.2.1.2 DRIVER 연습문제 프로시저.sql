
--B. 패키지 프로시져 - 각 5점
SELECT * FROM DR_MEMBER_TBL;		--R_TEL, MEM_POINT
SELECT * FROM DRIVER_RST_TBL;		--R_ID, DR_ID, RST_DATE
SELECT * FROM DRIVERS_TBL;			--DR_ID, DR_NAME, DR_TEL, DR_GENDER
SELECT * FROM FINISH_DRIVE_TBL;	--IDX, R_ID, DR_ID, F_DATE, F_GUBUN
SELECT * FROM RESERVATION_TBL;		--R.ID, R_TEL, R_STR, R_DEST, R_PAY


--1. 대리운전의 업무를 위한 패키지를 하나 만들어주세요 패키지 이름 : PKG_DRIVER  

--2. 위의 패키지에 첫번째 프로시저를 하나 만들어주세요 - 
        --새로운 대리운전 기사를 등록하는 프로시저를 만들어주세요
        --대리기사 아이디는 따로 함수로 만들지 말고 프로시저 내부에 로직을 포함시켜주세요
	SELECT 'DR' || TO_CHAR(NVL(TO_NUMBER(SUBSTR(MAX(DR_ID), 3,3)) ,0) +1, 'FM000')
	-- INTO V_NEW_DR_ID
	FROM DRIVERS_TBL;
   
    INSERT INTO DRIVERS_TBL(DR_ID, DR_NAME, DR_TEL, DR_GENDER)
	VALUES(V_NEW_DR_ID, IN_DR_NAME, IN_DR_TEL, IN_DR_GENDER);
        
--3. 위의 패키지에 두번째 프로시저를 만들어주세요
       --현재 불특정 회원의 POINT가 모두 0원입니다.
       --프로시저를 사용하여 POINT가 모두 계산 되도록 해주세요
	--FOR
	SELECT
		R_TEL
		,SUM(POINT) AS MEM_POINT
	FROM
	(
		-- 건 당 포인트 적립
		SELECT T1.R_TEL, T1.MEM_POINT, T3.R_PAY, (T3.R_PAY / 100 ) * 3 AS POINT
		FROM DR_MEMBER_TBL T1
			 ,FINISH_DRIVE_TBL T2
			 ,RESERVATION_TBL T3
		WHERE T1.R_TEL = T3.R_TEL
			AND T2.R_ID = T3.R_ID
			AND T2.F_GUBUN = 1
	)
	GROUP BY R_TEL
	;
	--LOOP
	UPDATE DR_MEMBER_TBL
	SET MEM_POINT = I.MEM_POINT
	WHERE R_TEL = I.R_TEL;
	
	
--4. 위의 패키지에 세번째 프로시저를 만들어주세요
      -- 이용자가 대리운전을 요청하는 전화를 하면
      -- 입력하는 직원은 해당 프로시저에 이용자 연락처만 입력하고 저장하면
      -- 새로운 이용자이면 DR_MEMBER_TBL에 새롭게 추가하고
      -- 이미 등록된 이용자이면 사용자 예외처리를 활용하여 에러처리를 해 주세요
----------------------------
	  
	  
	  
	  
--5   위의 패키지에 네번째 프로시저를 만들어주세요
      -- 각 요일별로 대리운전 총 매출액을 계산해서 보여주는 프로시저를 만들어 주세요
      
--6. 위의 패키지에 다섯번째 프로시저를 만들어주세요
     --2018년 5월 2일 부터 5월5일까지 회사와 대리운전기사가 벌어들인 금액을 각각 표시하는 프로시저를 만들어주세요
     
     -------------------------------------
     --    DRDATE       COMAPNY   DRIVER -----------
     --  2018-05-02      8000      2000
     --  2018-05-03      20000     5000
     --  2018-05-04      32000     8000
     --  2018-05-05      16000     2000
     -- 위와 같은 형식으로 결과가 보여지도록 해 주세요
	
	
	-- 2018년 5월 2일부터 5월 5일까지의 날짜 테이블
	SELECT TO_CHAR(LEVEL + TO_DATE('20180501','YYYYMMDD'))
	FROM DUAL
	CONNECT BY LEVEL < 5
	;
	
	-- 대리기사가 벌어들인 금액 
	SELECT *
	FROM FINISH_DRIVE_TBL T1, RESERVATION_TBL T2
	WHERE T1.R_ID = T2.R_ID
	AND T1.F_GUBUN = 1
	;
	
	/*
	18/05/02	25000
	18/05/02	15000
	18/05/03	15000
	18/05/03	17000
	18/05/03	20000
	18/05/03	15000
	18/05/04	30000
	18/05/04	20000
	18/05/05	23000
	18/05/05	18000
	*/
	
	SELECT 
			T2.DR_ID
			,T1.R_PAY
			,TO_CHAR(T2.F_DATE,'YYYY-MM-DD') AS D_DATE
			,CASE WHEN T1.R_PAY >=20000 THEN (T1.R_PAY / 100) * 80
										 ELSE (T1.R_PAY / 100) * 90 
				   END AS D_PAY
			,CASE WHEN T1.R_PAY >=20000 THEN (T1.R_PAY / 100) * 20
										 ELSE (T1.R_PAY / 100) * 10 
				   END AS C_PAY
		FROM 
			RESERVATION_TBL T1
			,FINISH_DRIVE_TBL T2
		WHERE	T1.R_ID = T2.R_ID
		AND T2.F_GUBUN = 1;
	-- 회사에서 벌어들인 돈 // 대리금액 2만원 이상 = 금액의 20%, 2만원 이하 = 금액의 10%
	-- 1) 건수 별 