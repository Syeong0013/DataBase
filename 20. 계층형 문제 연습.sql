-- 계층형 연습 문제 

-- 학과 LPAD
SELECT 
	LPAD(' ', COM_LVL * 3) || COM_VAL || '(' || COM_ID || ')'
FROM 
	COMMONS_TBL
WHERE 
	GRP_ID = 'GRP002'
START WITH 
	PARENT_ID = 'COM1000'
CONNECT BY PRIOR 
	COM_ID = PARENT_ID
;

-- 도시 LPAD // 인라인 쿼리를 안하면 PARENT_ID를 찾을 때 GRP_ID = GRP002 값도 포함해서 나오는 문제가 있음
SELECT 
	LPAD(' ', A.COM_LVL * 3) || A.COM_VAL || '(' || A.COM_ID || ')'
FROM 
(
	SELECT 
		* 
	FROM 
		COMMONS_TBL
	WHERE 
		GRP_ID = 'GRP001'
)A
START WITH 
	A.PARENT_ID = 'COM0000'
CONNECT BY PRIOR
	A.COM_ID = A.PARENT_ID
; 