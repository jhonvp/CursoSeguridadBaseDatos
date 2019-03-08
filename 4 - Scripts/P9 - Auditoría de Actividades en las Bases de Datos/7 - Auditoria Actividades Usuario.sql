CONN SYSTEM@ORCL

DELETE SYS.AUD$
/


AUDIT ALL BY PEDRO
/

DELETE SYS.AUD$
/

---------------------------------------------------

CONN PEDRO@ORCL

CREATE TABLE TEMP2(NUM NUMBER)
/


SELECT USERNAME, TIMESTAMP, OWNER, OBJ_NAME
    FROM DBA_AUDIT_TRAIL
/
---------------------------------------------------