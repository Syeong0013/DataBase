CREATE OR REPLACE 
PACKAGE PKG_SALES AS 

  PROCEDURE PROC_INS_SALES
  (
        IN_CID          IN      VARCHAR2,
        IN_PID          IN      VARCHAR2,
        IN_SPRICE       IN      NUMBER,
        IN_SQTY         IN      NUMBER,
        IN_SDATE        IN      VARCHAR2
  );

END PKG_SALES;