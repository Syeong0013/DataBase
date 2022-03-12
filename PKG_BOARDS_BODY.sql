CREATE OR REPLACE
PACKAGE BODY PKG_BOARDS AS

  PROCEDURE PROC_INS_BOARDS
  (
        IN_TITLE            IN  VARCHAR2,
        IN_CONTENT          IN  VARCHAR2,
        IN_STU_ID           IN  VARCHAR2
  ) 
  AS
  
    V_NEW_IDX           NUMBER;
  
  BEGIN
  
        --IN_STU_ID값이  STUDENTS_TBL에 있는 값이냐 확인 필요
  
        SELECT NVL(MAX(IDX), 0) + 1
        INTO V_NEW_IDX
        FROM BOARDS
        ;
  
        INSERT INTO BOARDS(IDX, TITLE, CONTENT, REGDATE, STU_ID) 
        VALUES(V_NEW_IDX, IN_TITLE, IN_CONTENT, SYSDATE, IN_STU_ID);
        
  END PROC_INS_BOARDS;

  --게시판 리스트를 보는 SELECT
  PROCEDURE  PROC_SEL_BOARDS
  (
        IN_TITLE            IN  VARCHAR2,
        O_CUR               OUT     SYS_REFCURSOR
  ) AS
  BEGIN
    
    OPEN O_CUR FOR
    SELECT *
    FROM BOARDS
    WHERE TITLE LIKE '%' || IN_TITLE || '%'
    ORDER BY IDX DESC
    ;
    
  END PROC_SEL_BOARDS;
  
  
    --게시판에서 해당 글을 클릭하면 그 글을 보여주는 SELECT
  PROCEDURE   PROC_SEL_CONTNET
  (
        IN_IDX             IN       VARCHAR2,
        IN_STU_ID          IN       VARCHAR2,
        O_CUR              OUT      SYS_REFCURSOR
  )
  AS
  
  BEGIN
  
    OPEN O_CUR FOR
    SELECT * FROM BOARDS
    WHERE IDX = IN_IDX
    ;
  
  END PROC_SEL_CONTNET;
  
  

  PROCEDURE  PROC_UP_BOARDS
  (
        IN_TITLE            IN   VARCHAR2,
        IN_CONTENT          IN   VARCHAR2,
        IN_IDX              IN   VARCHAR2
  ) AS
  BEGIN
    
        UPDATE BOARDS
        SET TITLE = IN_TITLE, CONTENT = IN_CONTENT
        WHERE IDX = IN_IDX
        ;
    
  END PROC_UP_BOARDS;

  PROCEDURE PROC_DEL_BOARDS
  (
        IN_IDX              IN   VARCHAR2,
        IN_STU_ID           IN   VARCHAR2
  ) AS
  BEGIN
    
        --본인이 작성한 글이 아니면 예외처리
       
        DELETE FROM BOARDS
        WHERE IDX = IN_IDX AND STU_ID = IN_STU_ID
        ;
    
    
  END PROC_DEL_BOARDS;

END PKG_BOARDS;