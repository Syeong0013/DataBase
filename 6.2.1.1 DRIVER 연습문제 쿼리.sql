SELECT * FROM DR_MEMBER_TBL;		--R_TEL, MEM_POINT
SELECT * FROM DRIVER_RST_TBL;		--R_ID, DR_ID, RST_DATE
SELECT * FROM DRIVERS_TBL;			--DR_ID, DR_NAME, DR_TEL, DR_GENDER
SELECT * FROM FINISH_DRIVE_TBL;	--IDX, R_ID, DR_ID, F_DATE, F_GUBUN
SELECT * FROM RESERVATION_TBL;		--R.ID, R_TEL, R_STR, R_DEST, R_PAY

--A. 쿼리

--1. 대리운전 '이용자의 예약 현황'을 보여주세요 (5점)
       --(이용자 연락처, 출발지, 도착지, 대리운전비)
	-- 전화 접수
	SELECT 
		R_TEL, R_STR, R_DEST, R_PAY
	FROM 
		RESERVATION_TBL
	;
	
	-- 전화 접수 + 기사 결정
	SELECT 
		T1.R_TEL, T1.R_STR, T1.R_DEST, T1.R_PAY
		, DECODE(T2.DR_ID, NULL, '가능', '불가') AS 결정가능여부
	FROM 
		RESERVATION_TBL T1, DRIVER_RST_TBL T2
	WHERE 
		T1.R_ID = T2.R_ID(+)
	;
	
		
--2. '대리기사가 선택'한 대리운전 결정 리스트를 보여주세요(5점)
        --(대리운전기사 아이디, 대리운전기사 이름, 이용자연락처, 출발지, 도착지 대리운전비)
	SELECT 
		T1.DR_ID, T1.DR_NAME, T3.R_TEL, T3.R_STR, T3.R_DEST, T3.R_PAY
	FROM 
		DRIVERS_TBL T1, DRIVER_RST_TBL T2, RESERVATION_TBL T3
	WHERE T1.DR_ID = T2.DR_ID(+)		--(+) 예약을 한 건도 받지 않은 대리기사도
	AND T2.R_ID = T3.R_ID(+)
	ORDER BY T1.DR_ID
	;

	
--3. 이용자중 가장많이 대리운전을 예약한 사용자의 연락처를 찾아주세요 (5점) // 010-2222-1111은 취소가 2번임.
	--3.1 이용자중 가장 많이 대리운전을 예약한 사용자 
	SELECT 
		R_TEL
		,COUNT(R_ID)
		,DENSE_RANK() OVER(ORDER BY COUNT(R_ID) DESC) AS RNK
	FROM
		RESERVATION_TBL
	GROUP BY R_TEL
	;
	--3.2 취소, 기사 미할당 여부 포함하여 최종저가으로 대리운전을 가장 많이 예약한 사용자 
	SELECT
		T1.R_TEL
		, COUNT(T1.R_ID)
		,DENSE_RANK() OVER(ORDER BY COUNT(T1.R_ID) DESC) AS RNK
	FROM
		RESERVATION_TBL T1
		,FINISH_DRIVE_TBL T2
	WHERE
		T1.R_ID = T2.R_ID
		AND T2.F_GUBUN = 1					-- 대리 운전 수행된 건
	GROUP BY T1.R_TEL
	;
	
--4. 대리운전 기사들의 수익을 가장많은 기사 부터 차례대로 순위를 붙여서 보여 주세요(5점)
	-- 4.1 수익 따져보기 (순수익X)
	SELECT 
		T1.DR_ID
		,SUM(T2.R_PAY)
		,DENSE_RANK() OVER(ORDER BY SUM(T2.R_PAY) DESC) AS RNK
	FROM 
		FINISH_DRIVE_TBL T1
		,RESERVATION_TBL T2
	WHERE	T1.R_ID = T2.R_ID
		AND T1.F_GUBUN = 1
	GROUP BY T1.DR_ID
	;
	
	-- 4.2 수익은 20000원 이상이면 대리기사 80% 회사 20%를 그 미만이면 대리기사 90% 회사 10%를 가져간다.
		-- 4.2.1 회사랑 돈 나눈 후의 수익
	SELECT 
		T2.DR_ID
		,T1.R_PAY
		,CASE WHEN T1.R_PAY >=20000 THEN (T1.R_PAY / 100) * 80
									 ELSE (T1.R_PAY / 100) * 90 
			   END AS R_PAY1
	FROM 
		RESERVATION_TBL T1
		,FINISH_DRIVE_TBL T2
	WHERE	T1.R_ID = T2.R_ID
		AND T2.F_GUBUN = 1
	;
		-- 4.2.2 대리기사별 회사랑 돈 나눈 후의 수익 랭크
	SELECT
		DR_ID
		,SUM(R_PAY1)
		,DENSE_RANK() OVER(ORDER BY SUM(R_PAY1) DESC) AS RNK
	FROM
	(
		SELECT 
			T2.DR_ID
			,T1.R_PAY
			,CASE WHEN T1.R_PAY >=20000 THEN (T1.R_PAY / 100) * 80
										 ELSE (T1.R_PAY / 100) * 90 
				   END AS R_PAY1
		FROM 
			RESERVATION_TBL T1
			,FINISH_DRIVE_TBL T2
		WHERE	T1.R_ID = T2.R_ID
			AND T2.F_GUBUN = 1
	)
	GROUP BY DR_ID
	;
	
--5. 이용자들중에 대리운전 예약을 한 후 취소를 가장 많이 한 이용자의 핸드폰번호를 보여주세요(5점)
	SELECT 
		T1.R_TEL
		,COUNT(T1.R_ID)
	FROM 
		RESERVATION_TBL T1
		,FINISH_DRIVE_TBL T2
	WHERE 
		T1.R_ID = T2.R_ID
		AND T2.F_GUBUN = 2
	GROUP BY T1.R_TEL
	;
	
--6. 대리운전 기사들의 성별로 대리운전결정 건수를 보여주세요(5점)
	SELECT
		DR_GENDER
		,COUNT(R_ID)
	FROM 
		DRIVER_RST_TBL T1
		,DRIVERS_TBL T2
	WHERE
		T1.DR_ID(+) = T2.DR_ID
	GROUP BY DR_GENDER
	;
--7. 2018년 5월 2일부터 5월 5일까지 대리기사가 결정된 건수, 정상적으로 완료된 건수, 취소된 건수를 보여주세요(5점)
	-- 2018년 5월 2일부터 5일까지의 LEVEL TABLE
	SELECT
		A.DR_DATE, B.DR_RE
		,COUNT(*)
	FROM
	(
	SELECT 
		TO_CHAR(LEVEL + '20180501') AS DR_DATE
	FROM DUAL
	CONNECT BY LEVEL < 5
	)A,
	-----------------------------------------------------------------------
	(
	SELECT 
		TO_CHAR(T1.RST_DATE,'YYYYMMDD') AS RST_DATE
		,DECODE(T2.F_GUBUN,1,'운행완료','운행취소') AS DR_RE
		,COUNT(T2.R_ID) AS DR_CNT
	FROM 
		DRIVER_RST_TBL T1
		,FINISH_DRIVE_TBL T2
	WHERE 
		T1.R_ID = T2.R_ID
	GROUP BY T1.RST_DATE,T2.F_GUBUN
	)B
	WHERE A.DR_DATE = B.RST_DATE
	GROUP BY A.DR_DATE, B.DR_RE
	ORDER BY A.DR_DATE
	;
	
----------------------------------------------------------------------------------
	-- 가로로
	SELECT 
		  A.DR_DATE
		, A.RST_CNT AS 예약건
		, B.S_CNT AS 완료건
		, NVL(C.C_CNT,0) AS 취소건
	FROM 
	(
		SELECT 
			TO_CHAR(LEVEL + '20180501') AS DR_DATES
		FROM DUAL
		CONNECT BY LEVEL < 5
	)D,
	(
	-- 날짜별 예약 완료된 건수
		SELECT 
			TO_CHAR(T1.RST_DATE,'YYYYMMDD') AS DR_DATE
			,COUNT(T2.R_ID) AS RST_CNT
		FROM
			DRIVER_RST_TBL T1
			,FINISH_DRIVE_TBL T2
		WHERE
			T1.R_ID = T2.R_ID
		GROUP BY TO_CHAR(T1.RST_DATE,'YYYYMMDD')
	)A,
	(
	-- 날짜별 정상 운행된 건수
		SELECT 
			TO_CHAR(T1.RST_DATE,'YYYYMMDD') AS DR_DATE
			,COUNT(T2.R_ID) AS S_CNT
		FROM
			DRIVER_RST_TBL T1
			,FINISH_DRIVE_TBL T2
		WHERE
			T1.R_ID = T2.R_ID
			AND T2.F_GUBUN = 1
		GROUP BY TO_CHAR(T1.RST_DATE,'YYYYMMDD')
	)B,
	(
	-- 날짜별 취소된 건수
		SELECT 
			TO_CHAR(T1.RST_DATE,'YYYYMMDD') AS DR_DATE
			,COUNT(T2.R_ID) AS C_CNT
		FROM
			DRIVER_RST_TBL T1
			,FINISH_DRIVE_TBL T2
		WHERE
			T1.R_ID = T2.R_ID
			AND T2.F_GUBUN = 2
		GROUP BY TO_CHAR(T1.RST_DATE,'YYYYMMDD')
	)C
	WHERE 
		D.DR_DATES = A.DR_DATE(+) 
		AND D.DR_DATES = B.DR_DATE(+) 
		AND D.DR_DATES = C.DR_DATE(+)
	ORDER BY A.DR_DATE
	;
	
	
--8. 이용자는 대리운전 신청을 하였으나 '대리기사가 결정되지 않아서' 취소된 대리운전 건을 보여주세요(5점)
    --(이용자핸드폰번호, 출발지, 도착지, 금액)
	--R0007, R0009 접수는 됐지만 대리기사가 할당되지않은 데이터
	SELECT 
		T1.R_TEL, T1.R_STR, T1.R_DEST, T1.R_PAY
	FROM
		RESERVATION_TBL T1
		,DRIVER_RST_TBL T2
	WHERE
		T1.R_ID = T2.R_ID(+)
		AND T2.R_ID IS NULL
	;
	
--9. 정상적으로 완료된 대리운전중에 가장 시간이 많이 걸린 대리운전 건을 보여주세요(5점)
	SELECT 
		A.R_ID, A.DR_ID, B.R_TEL, B.R_STR, B.R_DEST
		, TO_CHAR(A.RST_DATE,'YYYY-MM-DD HH24:MI:SS') AS 예약시간
		, TO_CHAR(A.F_DATE,'YYYY-MM-DD HH24:MI:SS') AS 완료시간
		, A.OVERTIME
	FROM
	(
		SELECT 
			T1.R_ID, T1.DR_ID, T1.RST_DATE, T2.F_DATE
			,ROUND((TO_DATE(TO_CHAR(T2.F_DATE,'YYYYMMDD HH24:MI:SS'),'YYYYMMDD HH24:MI:SS')
			-TO_DATE(TO_CHAR(T1.RST_DATE,'YYYYMMDD HH24:MI:SS'),'YYYYMMDD HH24:MI:SS'))*24*60*60,2) || '초' AS OVERTIME
			,DENSE_RANK() OVER(ORDER BY 
				ROUND((TO_DATE(TO_CHAR(T2.F_DATE,'YYYYMMDD HH24:MI:SS'),'YYYYMMDD HH24:MI:SS')
				-TO_DATE(TO_CHAR(T1.RST_DATE,'YYYYMMDD HH24:MI:SS'),'YYYYMMDD HH24:MI:SS'))*24*60*60,2) DESC) AS RNK
		FROM 
			DRIVER_RST_TBL T1
			,FINISH_DRIVE_TBL T2
		WHERE
			T1.R_ID = T2.R_ID
			AND T2.F_GUBUN = 1
	)A, RESERVATION_TBL B
	WHERE A.R_ID = B.R_ID
	AND A.RNK = 1
	;
	
--10. 대리운전비가 가장 비싼 대리운전을 보여주세요(5점)
       --(대리기사이름, 출발지, 목적지, 이용자핸드폰, 금액, 완료여부)
	-- 가장 비싼 대리운전 건
	SELECT 
		NVL(T3.DR_NAME,'기사미정')
		, T1.R_STR, T1.R_DEST, T1.R_TEL, T1.R_PAY
		,DECODE(T2.F_GUBUN, 1, '완료', 2, '취소', '운행전') AS 완료여부
		,DENSE_RANK() OVER(ORDER BY T1.R_PAY DESC) AS PAY_RANK
	FROM
		 RESERVATION_TBL T1
		,FINISH_DRIVE_TBL T2
		,DRIVERS_TBL T3
	WHERE
		T1.R_ID = T2.R_ID(+)
		AND T2.DR_ID = T3.DR_ID(+)
	;
