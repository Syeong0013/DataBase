create or replace TYPE ARR_TYPE 
AS VARRAY(5) OF VARCHAR2(30);

create or replace PROCEDURE PROC_TYPE_TEST
(
    O_CUR       OUT     SYS_REFCURSOR
)
AS

    V_ARR_STUDENTS_NAME     ARR_TYPE;
    V_SUM                   NUMBER(10) := 0;

BEGIN
    --배열 타입
    --TEACHARS_NAME := VARRY_TYPE('222', '333', '444');
    
    V_ARR_STUDENTS_NAME := ARR_TYPE('LEE', 'KIM', 'PARK', 'JUNG', 'KWON');
    
    FOR I IN 1..5
    LOOP
        V_SUM := V_SUM + I;
       -- DBMS_OUTPUT.PUT_LINE(V_SUM);
    END LOOP;
    
    OPEN O_CUR FOR
    SELECT
    V_ARR_STUDENTS_NAME(1),
    V_ARR_STUDENTS_NAME(2),
    V_ARR_STUDENTS_NAME(3),
    V_ARR_STUDENTS_NAME(4),
    V_ARR_STUDENTS_NAME(5)
    FROM DUAL;
    
END PROC_TYPE_TEST;