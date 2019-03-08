CONNECT SYSTEM@ORCL

AUDIT TABLE BY PEDRO
/

---------------------------------------------------

CONN PEDRO@ORCL

CREATE TABLE TEMP(NUM NUMBER)
/

INSERT INTO TEMP VALUES (1000)
/

SELECT * FROM TEMP
/

    

DROP TABLE TEMP
/

---------------------------------------------------

SELECT OS_USERNAME, USERNAME, TIMESTAMP, OWNER, OBJ_NAME, ACTION_NAME
 FROM DBA_AUDIT_TRAIL WHERE USERNAME ='PEDRO' AND OBJ_NAME='TEMP'
/

---------------------------------------------------

NOAUDIT TABLE BY PEDRO
/

---------------------------------------------------