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
/*
			  사학과(COM0007)
			  영어영문학과(COM0008)
			  철학과(COM0009)
		   자연과학대학(COM0002)
			  물리학과(COM0010)
			  화학과(COM0011)
			  수학과(COM0012)
			  식품영양학과(COM0013)
			  컴퓨터통계학과(COM0014)
			  금속재료공학과(COM0023)
			  기계공학과(COM0024)
			  선박해양공학과(COM0025)
			  신소재공학과(COM0026)
			  원자력공학과(COM0027)
			  재료공학과(COM0028)
			  건축공학과(COM0029)
		   법학대학(COM0003)
			  법학과(COM0015)
			  경찰행정학과(COM0016)
		   사회과학대학(COM0004)
			  신문방송학과(COM0017)
			  정치외교학과(COM0018)
		   경상대학(COM0005)
			  경영학과(COM0020)
			  경제학과(COM0021)
			  무역학과(COM0022)
		   공과대학(COM0019)
			  금속재료공학과(COM0023)
			  기계공학과(COM0024)
			  선박해양공학과(COM0025)
			  신소재공학과(COM0026)
			  원자력공학과(COM0027)
			  재료공학과(COM0028)
			  건축공학과(COM0029)
*/
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
/*
		   서울(COM0001)
		   부산(COM0002)
			  동래구(COM0019)
				 명륜동(COM0029)
				 망미동(COM0030)
				 연산1동(COM0031)
				 연산3동(COM0032)
				 칠산동(COM0033)
			  금정구(COM0020)
				 장전동(COM0034)
				 구서동(COM0035)
				 남산동(COM0036)
				 청룡동(COM0037)
			  해운대구(COM0021)
				 우동(COM0038)
				 좌동(COM0039)
		   대구(COM0003)
		   대전(COM0004)
		   울산(COM0005)
			  동구(COM0049)
				 전하동(COM0050)
		   세종(COM0006)
		   광주(COM0007)
		   인천(COM0008)
		   강원(COM0009)
		   경기(COM0011)
		   충북(COM0012)
		   충남(COM0013)
		   경북(COM0014)
			  안동(COM0027)
			  포항(COM0028)
		   경남(COM0015)
			  창원(COM0022)
				 창원구(COM0040)
					상남동(COM0043)
					중앙동(COM0044)
					사파정동(COM0045)
				 마산구(COM0041)
					덕동(COM0047)
					합포동(COM0048)
				 진해구(COM0042)
			  양산(COM0023)
			  김해(COM0025)
			  창녕(COM0026)
		   전북(COM0016)
		   전남(COM0017)
		   제주(COM0018)
*/