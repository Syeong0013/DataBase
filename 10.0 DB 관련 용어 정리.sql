--1. 정규화
--제1정규화 -- 하나의 테이블  - 테이블 만들 때 모든 필드는 어떠한 필드 값에도 연관 되어서는 안 된다.
--제2정규화 -- 고객, 상품, 주문 -- 2개의 엔터티가 다 대 다를 형성하면 반드시 1 대 다의 새로운 테이블 행위를 표현
--제3정규화 -- 코드성, 대상 없는 행위
--제4정규화 역정규화 -- COMMONS_TBL, 답변형 게시판, 메뉴

--CRUD -- INSERT, SELECT, UPDATE, DELETE
--고치다, 수정하다. --MODIFY, ALTER, .... UPDATE

--JOIN -- 1 대 다의 관계를 가지는 필드끼리
-- PROCEDURE --
-- PACKAGE -- PROCEDURE -- APPLICATION -- TRANSACTION -- 업무의 최소 단위
-- TRANSACTION -- EXCEPTION -- 사용자 정의 예외
-- TRIGGER -- 테이블에 이벤트 (DELETE, UPDATE, INSERT)가 발생하면 자동으로 실행되는 프로시져
-- FUNCTION -- ORACLE 내부에서 사용 가능 -- 기능

-- VIEW -- 메모리에 존재하는 가상 테이블 -- 일반 테이블이랑 같다. INSERT, UPDATE, DELETE 제한
--TYPE, ... 명시적 커서 FOR CUR IN (SELECT * FROM TBL) LOOP END LOOP;  -- 커서를 쓸 때, 값이 많으면 속도가 느려져서 MERGE INTO를 씀.
--MERGE INTO -- UPDATE, INSERT를 위한 JOIN

-- data type -- 유형
-- USER DEFINED TYPE
-- 사용자 정의 타입

--VARCHAR2, INTEGER, NUMBER, CHAR <-- 오라클이 제공하고 있는 데이터 타입
-- 개발자가 필요하면 개발자가 정의해서 사용

-- 전역이라고 생각하면 편함. 모든 유형에서 사용 가능함.


