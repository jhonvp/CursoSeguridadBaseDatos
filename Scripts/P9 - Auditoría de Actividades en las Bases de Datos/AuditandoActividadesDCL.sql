CONN SYSTEM

DELETE SYS.AUD$
/

COMMIT
/

AUDIT GRANT ON DBSEC.TEMP
/

---------------------------------------------------

CONN DBSEC

GRANT SELECT ON TEMP TO SYSTEM
/

GRANT UPDATE ON TEMP TO SYSTEM
/

---------------------------------------------------

SELECT USERNAME, TIMESTAMP, OWNER, OBJ_NAME
    FROM DBA_AUDIT_TRAIL
/

---------------------------------------------------