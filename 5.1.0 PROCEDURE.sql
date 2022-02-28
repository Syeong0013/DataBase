-- 프로시저 PROCEDURE
-- 업무의 최소단위 , 트랜잭션 TRANSACTION 
-- ALL OR NOTHING  EX) 이체업무처럼 출/입금이 동시에 일어나거나 아예 일어나지 않아야하는 단위 (최소단위)
-- 함수가 아니다.  어플리케이션에서 불러서 사용할 수 없음
-- 내부에서 사용 

SELECT * FROM STUDENTS_TBL;

INSERT INTO STUDENTS_TBL (STU_ID, STU_NAME, STU_TEL, STU_ADDR_GRP, STU_ADDR, STU_ADDR2, STU_DEPT_GRP, STU_DEPT)
VALUES ('STU091' , '감득실', '010-9999-8888', 'GRP001', 'COM0038', 'GRP002', 'COM0013', 'COM0002')
;

-- 반복작업  -> 트랜잭션 --> 업무 