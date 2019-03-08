CONN SYSTEM@ORCL

DELETE SYS.AUD$
/

COMMIT
/

AUDIT GRANT ON PEDRO.TEMP
/

---------------------------------------------------

CONN PEDRO@ORCL

GRANT SELECT ON TEMP TO SYSTEM
/

GRANT UPDATE ON TEMP TO SYSTEM
/

---------------------------------------------------

SELECT USERNAME, TIMESTAMP, OWNER, OBJ_NAME
    FROM DBA_AUDIT_TRAIL
/

---------------------------------------------------