CREATE OR REPLACE 
PACKAGE PKG_BOARDS AS 

  PROCEDURE PROC_INS_BOARDS
  (
        IN_TITLE            IN  VARCHAR2,
        IN_CONTENT          IN  VARCHAR2,
        IN_STU_ID           IN  VARCHAR2
  );
  
  --게시판의 리스트를 보여주는 SELECT
  PROCEDURE  PROC_SEL_BOARDS
  (
        IN_TITLE            IN  VARCHAR2,
        O_CUR               OUT     SYS_REFCURSOR
  );
  
  --게시판에서 해당 글을 클릭하면 그 글을 보여주는 SELECT
  PROCEDURE   PROC_SEL_CONTNET
  (
        IN_IDX             IN       VARCHAR2,
        IN_STU_ID          IN       VARCHAR2,
        O_CUR              OUT      SYS_REFCURSOR
  );
  
  PROCEDURE  PROC_UP_BOARDS
  (
        IN_TITLE            IN   VARCHAR2,
        IN_CONTENT          IN   VARCHAR2,
        IN_IDX              IN   VARCHAR2
  );
  
  PROCEDURE PROC_DEL_BOARDS
  (
        IN_IDX              IN   VARCHAR2,
        IN_STU_ID           IN   VARCHAR2
  );

END PKG_BOARDS;