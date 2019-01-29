CREATE TABLE APP_AUDIT_SQLS
(
    TABLE_NAME VARCHAR2(30) NOT NULL,
    SQL_STATEMENT VARCHAR2(4000) NOT NULL,
    SQL_TYPE VARCHAR2(10) NOT NULL,
    CTL_INS_DTTM DATE,
    CTL_INS_USER VARCHAR2(30),
    CTL_OPS_USER VARCHAR2(30),
    CTL_IP_ADDR VARCHAR2(255)
);

---------------------------------------------------

CREATE TABLE CUSTOMERS
(
    ID NUMBER,
    NAME VARCHAR2(10),
    CREDIT_LIMIT NUMBER
);

INSERT INTO CUSTOMERS (ID, NAME, CREDIT_LIMIT) VALUES (1, 'Tom Jones', 2);

INSERT INTO CUSTOMERS (ID, NAME, CREDIT_LIMIT) VALUES (10, 'BLA AFENDI', 500);

---------------------------------------------------

CREATE OR REPLACE TRIGGER TRG_CUSTOMER_BDIUR
    BEFORE UPDATE OR INSERT OR DELETE
    ON CUSTOMERS
    FOR EACH ROW
DECLARE
    V_STMT VARCHAR2(4000);
    V_OPER VARCHAR2(10);
BEGIN

    IF INSERTING THEN
        V_OPER := 'INSERT';
    ELSIF UPDATING THEN
        V_OPER := 'UPDATE';
    ELSE
        V_OPER := 'DELETE';
    END IF;

    SELECT Q.SQL_TEXT
        INTO V_STMT
        FROM V$SQL Q, V$SESSION S
    WHERE S.audsid = SYS_CONTEXT('USERENV', 'SESSIONID')
        AND Q.PARSING_USER_ID = SYS_CONTEXT('USERENV', 'CURRENT_USERID')
        AND Q.LAST_LOAD_TIME = (SELECT MAX(LAST_LOAD_TIME)
                                FROM V$SQL
                                WHERE PARSING_USER_ID = Q.PARSING_USER_ID
                                 AND UPPER(SQL_TEXT) LIKE '%' || V_OPER || '%'
                                 AND UPPER(SQL_TEXT) NOT LIKE 'SELECT' || '%')
        AND UPPER(SQL_TEXT) NOT LIKE 'SELECT' || '%'
        AND UPPER(SQL_TEXT) LIKE '%' || V_OPER || '%';

    INSERT INTO APP_AUDIT_SQLS (TABLE_NAME, SQL_STATEMENT, SQL_TYPE,
                                CTL_INS_DTTM, CTL_INS_USER, CTL_OPS_USER, CTL_IP_ADDR)
                                VALUES ('CUSTOMERS', V_STMT, V_OPER, SYSDATE, USER,
                                    SYS_CONTEXT('USERENV', 'OS_USER'),
                                    SYS_CONTEXT('USERENV', 'IP_ADDRESS'));
END;
/

---------------------------------------------------

UPDATE CUSTOMERS SET 
    CREDIT_LIMIT = 1000
/

COMMIT;

---------------------------------------------------

SELECT TABLE_NAME, SQL_STATEMENT
    FROM APP_AUDIT_SQLS
/

---------------------------------------------------