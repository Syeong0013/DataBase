CREATE OR REPLACE
PACKAGE BODY PKG_SALES AS

  PROCEDURE PROC_INS_SALES
  (
        IN_CID          IN      VARCHAR2,
        IN_PID          IN      VARCHAR2,
        IN_SPRICE       IN      NUMBER,
        IN_SQTY         IN      NUMBER,
        IN_SDATE        IN      VARCHAR2
  ) 
  AS
        V_CID_CNT          NUMBER(3);
        V_PID_CNT           NUMBER(3);
  
  BEGIN
    
    --로직을 만들수 있다.
    -- CID가 존재하는지 판단을 해보자
    SELECT COUNT(*)
    INTO V_CID_CNT
    FROM CUSTOMERS
    WHERE CID = IN_CID
    ;
    
    --PID가 존재하는지도 판단을 해야죠
    SELECT COUNT(*)
    INTO V_PID_CNT
    FROM PRODUCTS
    WHERE PID = IN_PID
    ;
    
    
    
    IF(V_CID_CNT > 0 AND V_PID_CNT > 0) THEN
    
        INSERT INTO SALES(CID, PID, SPRICE, SQTY, SDATE) 
        VALUES(IN_CID, IN_PID, IN_SPRICE, IN_SQTY, TO_DATE(IN_SDATE, 'YYYY-MM-DD'));
        
        --1%를 적립한다.
        UPDATE CUSTOMERS
        SET CPOINT = CPOINT + (IN_SPRICE * IN_SQTY * 0.01)
        WHERE CID = IN_CID
        ;
        
    END IF
    ;
    
  END PROC_INS_SALES;

END PKG_SALES;