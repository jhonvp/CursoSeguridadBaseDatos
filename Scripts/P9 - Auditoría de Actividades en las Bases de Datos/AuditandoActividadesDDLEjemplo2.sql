CONNECT SYSTEM@SEC

AUDIT TABLE BY DBSEC
/

---------------------------------------------------

CONN DBSEC@SEC

CREATE TABLE TEMP(NUM NUMBER)
/

INSERT INTO TEMP VALUES (1000)
/

SELECT * FROM TEMP
/

    NUM

DROP TABLE TEMP
/

---------------------------------------------------

SELECT OS_USERNAME, USERNAME, TIMESTAMP, OWNER, OBJ_NAME, ACTION_NAME
 FROM DBA_AUDIT_TRAIL
/

---------------------------------------------------

NOAUDIT TABLE BY DBSEC
/

---------------------------------------------------