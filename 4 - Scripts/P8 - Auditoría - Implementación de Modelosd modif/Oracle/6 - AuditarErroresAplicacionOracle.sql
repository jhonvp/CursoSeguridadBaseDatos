CREATE TABLE CUSTOMERS
(
    ID NUMBER,
    NAME VARCHAR2(10),
    CREDIT_LIMIT NUMBER
);

------------------------------------------------------

INSERT INTO CUSTOMERS(ID, NAME, CREDIT_LIMIT)
              VALUES (1, 'Tom Jones', 1000);

COMMIT;

------------------------------------------------------

CREATE TABLE APP_AUDIT_ERRORS
(
    TABLE_NAME VARCHAR2(30) NOT NULL,
    ERROR_CODE NUMBER NOT NULL,
    ERROR_MSG VARCHAR2(2000) NOT NULL,
    ROW_VALUES VARCHAR2(4000) NOT NULL,
    CTL_INS_DTTM DATE,
    CTL_INS_USER VARCHAR2(30),
    CTL_OPS_USER VARCHAR2(30),
    CTL_IP_ADDR VARCHAR2(255)
);

------------------------------------------------------

CREATE OR REPLACE PACKAGE APP_AUDIT_DML IS
    PROCEDURE CUSTOMERS_UPDATE(
        P_ID NUMBER,
        P_NAME VARCHAR2,
        P_CREDIT_LIMIT NUMBER,
        P_COMMIT BOOLEAN DEFAULT TRUE
    );

END;
/

------------------------------------------------------

CREATE OR REPLACE PACKAGE BODY APP_AUDIT_DML IS

    --
    -- INSERT ERROR CAUSED BY DML INTO APP_AUDIT_ERRORS
    --

    PROCEDURE INSERT_ERROR(
        P_TABLE VARCHAR2,
        P_CODE NUMBER,
        P_MSG VARCHAR2,
        P_VALS VARCHAR2
    ) IS 

    PRAGMA AUTONOMOUS_TRANSACTION;

    BEGIN

        INSERT INTO APP_AUDIT_ERRORS(
            TABLE_NAME, ERROR_CODE, ERROR_MSG, ROW_VALUES, CTL_INS_DTTM, CTL_INS_USER, CTL_OPS_USER, CTL_IP_ADDR
        ) VALUES (
            P_TABLE, P_CODE, P_MSG, P_VALS, SYSDATE, USER,
            (SELECT SYS_CONTEXT('USERENV', 'OS_USER') FROM DUAL),
            (SELECT SYS_CONTEXT('USERENV', 'IP_ADDRESS') FROM DUAL)
        );
    COMMIT;

    END;

    --

    --
    -- PERFORMS UPDATE OPERATION.
    --
    PROCEDURE CUSTOMERS_UPDATE(
        P_ID NUMBER,
        P_NAME VARCHAR2,
        P_CREDIT_LIMIT NUMBER,
        P_COMMIT BOOLEAN DEFAULT TRUE
    ) IS

    V_STMT VARCHAR2(4000);
    E_ID_NULL EXCEPTION;

    PRAGMA EXCEPTION_INIT(E_ID_NULL, -200001);

BEGIN

        IF P_ID IS NULL THEN
        RAISE E_ID_NULL;

    END IF;

        UPDATE CUSTOMERS SET
            ID = NVL(P_ID, ID),
            NAME = NVL(P_NAME, NAME),
            CREDIT_LIMIT = NVL(P_CREDIT_LIMIT, CREDIT_LIMIT)
            WHERE ID = P_ID;

        IF P_COMMIT THEN
            COMMIT;
        END IF;

    EXCEPTION
        WHEN E_ID_NULL THEN
        V_STMT := P_ID || '|' ||
                  P_NAME || '|' ||
                  P_CREDIT_LIMIT;

            INSERT_ERROR('CUSTOMERS', SQLCODE, SQLERRM, V_STMT);
            RAISE_APPLICATION_ERROR(-20001, 'Error: ' || SQLERRM);
        WHEN OTHERS THEN
            V_STMT := P_ID || '|' ||
                      P_NAME || '|' ||
                      P_CREDIT_LIMIT;

                INSERT_ERROR('CUSTOMERS', SQLCODE, SQLERRM, V_STMT);
                RAISE_APPLICATION_ERROR(-20002, 'Error: ' || SQLERRM);
        END;
        ------

    END;
    /

------------------------------------------------------

EXEC APP_AUDIT_DML.CUSTOMERS_UPDATE(1, 'Tom Jones Jr.', null)
BEGIN APP_AUDIT_DML.CUSTOMERS_UPDATE(1, 'Tom Jones Jr.', null); END;
*

EXEC APP_AUDIT_DML.CUSTOMERS_UPDATE(1, NULL, 10000)

------------------------------------------------------

SELECT TABLE_NAME,
       ERROR_MSG,
       ROW_VALUES,
       TO_CHAR(CTL_INS_DTTM, 'DD-MON-YYYY HH24:MI:SS') DATE_CREATED,
       CTL_IP_ADDR
    FROM APP_AUDIT_ERRORS
/

------------------------------------------------------