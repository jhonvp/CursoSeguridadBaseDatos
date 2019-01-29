CREATE TABLE CUSTOMER
(
    ID NUMBER,
    NAME VARCHAR2(20),
    CR_LIMIT NUMBER
)
/

---------------------------------------------------

CONNECT SYSTEM@SEC

AUDIT ALTER ON DBSEC.CUSTOMER BY ACCESS WHENEVER SUCCESSFUL
/

AUDIT DELETE ON DBSEC.CUSTOMER BY ACCESS WHENEVER SUCCESSFUL
/

---------------------------------------------------

CONNECT SYSTEM@SEC

DELETE FROM CUSTOMER WHERE ID = 2
/

ALTER TABLE CUSTOMER MODIFY NAME VARCHAR2(30)
/

---------------------------------------------------

NOAUDIT ALTER ON DBSEC.CUSTOMER
/

NOAUDIT DELETE ON DBSEC.CUSTOMER
/

---------------------------------------------------

