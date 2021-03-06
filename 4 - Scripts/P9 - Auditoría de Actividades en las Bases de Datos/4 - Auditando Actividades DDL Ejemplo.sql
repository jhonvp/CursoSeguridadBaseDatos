CREATE TABLE CUSTOMER
(
    ID NUMBER,
    NAME VARCHAR2(20),
    CR_LIMIT NUMBER
)
/

---------------------------------------------------

CONNECT SYSTEM@ORCL

AUDIT ALTER ON PEDRO.CUSTOMERS BY ACCESS WHENEVER SUCCESSFUL
/

AUDIT DELETE ON PEDRO.CUSTOMERS BY ACCESS WHENEVER SUCCESSFUL
/

---------------------------------------------------

CONNECT PEDRO@ORCL

DELETE FROM CUSTOMERS WHERE ID = 2
/

ALTER TABLE CUSTOMERS MODIFY NAME VARCHAR2(30)
/

---------------------------------------------------

NOAUDIT ALTER ON PEDRO.CUSTOMER
/

NOAUDIT DELETE ON PEDRO.CUSTOMER
/

---------------------------------------------------

SELECT USERNAME, OBJ_NAME, ACTION_NAME FROM DBA_AUDIT_TRAIL WHERE USERNAME='PEDRO';