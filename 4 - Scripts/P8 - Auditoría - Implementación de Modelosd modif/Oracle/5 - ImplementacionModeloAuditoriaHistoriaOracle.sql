CREATE TABLE CUSTOMERS
(
    CUSTOMER_ID NUMBER(8) NOT NULL,
    CUSTOMER_SSN VARCHAR2(9),
    FIRST_NAME VARCHAR2(20),
    LAST_NAME VARCHAR2(20),
    SALES_REP_ID NUMBER(4),
    ADDR_LINE VARCHAR2(80),
    CITY VARCHAR2(30),
    STATE VARCHAR2(30),
    ZIP_CODE VARCHAR2(9),
    CTL_INS_DTTM DATE,
    CTL_UPD_DTTM DATE,
    CTL_UPD_USER VARCHAR2(30),
    CTL_REC_STAT VARCHAR2(1)
);

ALTER TABLE CUSTOMERS ADD PRIMARY KEY (CUSTOMER_ID);

------------------------------------------------------

CREATE TABLE CUSTOMERS_HISTORY
(
    CUSTOMER_ID NUMBER(8) NOT NULL,
    CUSTOMER_SSN VARCHAR2(9),
    FIRST_NAME VARCHAR2(20),
    LAST_NAME VARCHAR2(20),
    SALES_REP_ID NUMBER(4),
    ADDR_LINE VARCHAR2(80),
    CITY VARCHAR2(30),
    STATE VARCHAR2(30),
    ZIP_CODE VARCHAR2(9),
    CTL_INS_DTTM DATE,
    CTL_UPD_DTTM DATE,
    CTL_UPD_USER VARCHAR2(30),
    CTL_REC_STAT VARCHAR2(1),
    HST_INS_DTTM DATE,
    HST_OPR_TYPE VARCHAR2(20)
);

------------------------------------------------------

CREATE OR REPLACE TRIGGER TRG_CUSTOMERS_BIUR BEFORE
UPDATE OR
INSERT OR
DELETE ON CUSTOMERS FOR EACH ROW
DECLARE
    V_CUSTOMER_ID       CUSTOMERS_HISTORY.CUSTOMER_ID%TYPE;
    V_CUSTOMER_SSN      CUSTOMERS_HISTORY.CUSTOMER_SSN%TYPE;
    V_FIRST_NAME        CUSTOMERS_HISTORY.FIRST_NAME%TYPE;
    V_LAST_NAME         CUSTOMERS_HISTORY.LAST_NAME%TYPE;
    V_SALES_REP_ID      CUSTOMERS_HISTORY.SALES_REP_ID%TYPE;
    V_ADDR_LINE         CUSTOMERS_HISTORY.ADDR_LINE%TYPE;
    V_CITY              CUSTOMERS_HISTORY.CITY%TYPE;
    V_STATE             CUSTOMERS_HISTORY.STATE%TYPE;
    V_ZIP_CODE          CUSTOMERS_HISTORY.ZIP_CODE%TYPE;
    V_CTL_INS_DTTM      CUSTOMERS_HISTORY.CTL_INS_DTTM%TYPE;
    V_CTL_UPD_DTTM      CUSTOMERS_HISTORY.CTL_UPD_DTTM%TYPE;
    V_CTL_UPD_USER      CUSTOMERS_HISTORY.CTL_UPD_USER%TYPE;
    V_CTL_REC_STAT      CUSTOMERS_HISTORY.CTL_REC_STAT%TYPE;
    V_HST_INS_DTTM      CUSTOMERS_HISTORY.HST_INS_DTTM%TYPE;
    V_HST_OPR_TYPE      CUSTOMERS_HISTORY.HST_OPR_TYPE%TYPE;
BEGIN
    IF INSERTING THEN
        :NEW.CTL_INS_DTTM := SYSDATE;
        :NEW.CTL_UPD_DTTM := NULL;
        :NEW.CTL_REC_STAT := 'N';
        V_HST_OPR_TYPE := 'INSERT';
    ELSIF UPDATING THEN
        :NEW.CTL_UPD_DTTM := SYSDATE;
        V_CTL_UPD_DTTM := :NEW.CTL_UPD_DTTM;
        V_HST_OPR_TYPE := 'UPDATE';
    ELSIF DELETING THEN
        V_CUSTOMER_ID   := :OLD.CUSTOMER_ID;
        V_CUSTOMER_SSN  := :OLD.CUSTOMER_SSN;
        V_FIRST_NAME    := :OLD.FIRST_NAME;
        V_LAST_NAME     := :OLD.LAST_NAME;
        V_SALES_REP_ID  := :OLD.SALES_REP_ID;
        V_ADDR_LINE     := :OLD.ADDR_LINE;
        V_CITY          := :OLD.CITY;
        V_STATE         := :OLD.STATE;
        V_ZIP_CODE      := :OLD.ZIP_CODE;
        V_CTL_INS_DTTM  := :OLD.CTL_INS_DTTM;
        V_CTL_UPD_DTTM  := :OLD.CTL_UPD_DTTM;
        V_CTL_UPD_USER  := :OLD.CTL_UPD_USER;
        V_CTL_REC_STAT  := :OLD.CTL_REC_STAT;
        V_HST_OPR_TYPE  := 'DELETE';
    END IF;
    IF INSERTING OR UPDATING THEN
        :NEW.CTL_UPD_USER := USER;
        V_CUSTOMER_ID   := :NEW.CUSTOMER_ID;
        V_CUSTOMER_SSN  := :NEW.CUSTOMER_SSN;
        V_FIRST_NAME    := :NEW.FIRST_NAME;
        V_LAST_NAME     := :NEW.LAST_NAME;
        V_SALES_REP_ID  := :NEW.SALES_REP_ID;
        V_ADDR_LINE     := :NEW.ADDR_LINE;
        V_CITY          := :NEW.CITY;
        V_STATE         := :NEW.STATE;
        V_ZIP_CODE      := :NEW.ZIP_CODE;
        V_CTL_INS_DTTM  := :NEW.CTL_INS_DTTM;
        V_CTL_UPD_DTTM  := :NEW.CTL_UPD_DTTM;
        V_CTL_UPD_USER  := :NEW.CTL_UPD_USER;
        V_CTL_REC_STAT  := :NEW.CTL_REC_STAT;
    END IF;
    INSERT INTO CUSTOMERS_HISTORY
    (
        CUSTOMER_ID,
        CUSTOMER_SSN,
        FIRST_NAME,
        LAST_NAME,
        SALES_REP_ID,
        ADDR_LINE,
        CITY,
        STATE,
        ZIP_CODE,
        CTL_INS_DTTM,
        CTL_UPD_DTTM,
        CTL_UPD_USER,
        CTL_REC_STAT,
        HST_INS_DTTM,
        HST_OPR_TYPE
    )
    VALUES
    (
        V_CUSTOMER_ID,
        V_CUSTOMER_SSN,
        V_FIRST_NAME,
        V_LAST_NAME,
        V_SALES_REP_ID,
        V_ADDR_LINE,
        V_CITY,
        V_STATE,
        V_ZIP_CODE,
        V_CTL_INS_DTTM,
        V_CTL_UPD_DTTM,
        V_CTL_UPD_USER,
        V_CTL_REC_STAT,
        SYSDATE,
        V_HST_OPR_TYPE
    );
EXCEPTION WHEN OTHERS THEN
    RAISE_APPLICATION_ERROR(-20000,SQLERRM);
END;
/

------------------------------------------------------

INSERT INTO CUSTOMERS (
    CUSTOMER_ID,
    CUSTOMER_SSN,
    FIRST_NAME,
    LAST_NAME,
    SALES_REP_ID,
    ADDR_LINE,
    CITY,
    STATE,
    ZIP_CODE
)
VALUES(
    201340,
    '969996970',
    'Jeffrey',
    'Antoine',
    6459,
    '9938 Moreno St.',
    'Champagne',
    'SD',
    '43172'
);

INSERT INTO CUSTOMERS (
    CUSTOMER_ID,
    CUSTOMER_SSN,
    FIRST_NAME,
    LAST_NAME,
    SALES_REP_ID,
    ADDR_LINE,
    CITY,
    STATE,
    ZIP_CODE
)
VALUES(
    801349,
    '716647546',
    'Cordell',
    'Ayres',
    2200,
    '37 Noyes Street',
    'Narod',
    'NC',
    '15199'
);

------------------------------------------------------

SELECT CUSTOMER_ID CUS_ID, FIRST_NAME, LAST_NAME,
    TO_CHAR(CTL_INS_DTTM, 'DD-MON-YYYY HH24:MI:SS') CTL_INS_DTTM,
    CTL_UPD_DTTM, CTL_UPD_USER, CTL_REC_STAT
    FROM CUSTOMERS;

SELECT CUSTOMER_ID AS  CUS_ID, FIRST_NAME, LAST_NAME,
    TO_CHAR(CTL_INS_DTTM, 'DD-MON-YYYY HH24:MI:SS') AS CTL_INS_DTTM,
    CTL_UPD_DTTM, CTL_UPD_USER,
    TO_CHAR(HST_INS_DTTM, 'DD-MON-YYYY HH24:MI:SS') AS HST_INS_DTTM,
    HST_OPR_TYPE AS OPER   
    FROM CUSTOMERS_HISTORY;

------------------------------------------------------

UPDATE CUSTOMERS SET
    ADDR_LINE = '123 Hello Street'
WHERE CUSTOMER_ID = 201340
/

COMMIT;

------------------------------------------------------

SELECT CUSTOMER_ID CUS_ID, ADDR_LINE,
    TO_CHAR(CTL_INS_DTTM, 'DD-MON-YYYY HH24:MI:SS') CTL_INS_DTTM,
    TO_CHAR(CTL_UPD_DTTM, 'DD-MON-YYYY HH24:MI:SS') CTL_UPD_DTTM,
    CTL_UPD_USER, CTL_REC_STAT
FROM CUSTOMERS
WHERE CUSTOMER_ID = 201340
/

SELECT CUSTOMER_ID CUS_ID, ADDR_LINE,
    TO_CHAR(CTL_INS_DTTM, 'DD-MON-YYYY HH24:MI:SS') CTL_INS_DTTM,
    TO_CHAR(CTL_UPD_DTTM, 'DD-MON-YYYY HH24:MI:SS') CTL_UPD_DTTM,
    TO_CHAR(HST_INS_DTTM, 'DD-MON-YYYY HH24:MI:SS') HST_INS_DTTM,
    CTL_UPD_USER USERNAME, HST_OPR_TYPE OPER 
FROM CUSTOMERS_HISTORY
WHERE CUSTOMER_ID = 201340
ORDER BY HST_INS_DTTM
/

------------------------------------------------------

DELETE CUSTOMERS WHERE CUSTOMER_ID = 201340;

COMMIT;

SELECT * FROM CUSTOMERS WHERE CUSTOMER_ID = 201340;

SELECT CUSTOMER_ID, ADDR_LINE,
    TO_CHAR(CTL_INS_DTTM, 'DD-MON-YYYY HH24:MI:SS') CTL_INS_DTTM,
    TO_CHAR(CTL_UPD_DTTM, 'DD-MON-YYYY HH24:MI:SS') CTL_UPD_DTTM,
    CTL_UPD_USER USERNAME,
    TO_CHAR(HST_INS_DTTM, 'DD-MON-YYYY HH24:MI:SS') HST_INS_DTTM,
    HST_OPR_TYPE
FROM CUSTOMERS_HISTORY
WHERE CUSTOMER_ID = 201340
ORDER BY HST_INS_DTTM
/

------------------------------------------------------