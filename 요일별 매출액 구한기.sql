-- 요일 별 매출액 
SELECT A.DAY, NVL(B.TLTPAY, 0)
FROM
(
	SELECT 
		TO_CHAR(TO_DATE('20180501', 'YYYYMMDD')+ LEVEL, 'DAY') AS DAY
		,TO_CHAR(TO_DATE('20180501', 'YYYYMMDD')+ LEVEL, 'D') AS D
	FROM DUAL
	CONNECT BY LEVEL <=7
)A,
(
	SELECT 
		  TO_CHAR(T1.F_DATE,'DAY') AS F_DAY
		  ,SUM(T2.R_PAY) AS TLTPAY
	FROM FINISH_DRIVE_TBL T1, RESERVATION_TBL T2
	WHERE T1.R_ID = T2.R_ID
	AND T1.F_GUBUN = 1
	GROUP BY TO_CHAR(T1.F_DATE,'DAY')
)B
WHERE A.DAY = B.F_DAY(+)
ORDER BY A.D
;