-- DECODE
/*
	DECODE(열, 값이 이거면, 이걸 출력, 아니면 이걸 출력)
*/
SELECT SID, SNAME, SGENDER, DECODE(SGENDER, 'M', '남자', '여자')
FROM STUDENTS;


INSERT INTO STUDENTS VALUES('S011', '김디우', '11111', 'A', 22, 'C009');


SELECT SID, SNAME, SGENDER, DECODE(SGENDER, 'M', '남자', 'F', '여자', '몰라')
FROM STUDENTS;
