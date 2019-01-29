CREATE TABLE DEPARTMENTS(
    DEPARTMENT_ID NUMBER(2) PRIMARY KEY,
    DEPARTMENT_NAME VARCHAR(20),
    CITY VARCHAR(30),
    STATE CHAR(2)
);

CREATE TABLE APP_AUDIT_DATA(
    AUDIT_DATA_ID NUMBER PRIMARY KEY,
    AUDIT_OBJECT VARCHAR2(30),
    AUDIT_OPERATION VARCHAR2(20),
    AUD_INS_DTTM DATE,
    AUD_UPD_USER VARCHAR2(30),
    AUD_REC_STAT VARCHAR2(1)
);

------------------------------------------------------

CREATE SEQUENCE SEQ_APP_AUDIT_DATA
    INCREMENT BY 1
    START WITH 1
    MINVALUE 1
    NOCYCLE
    CACHE 20
    NOORDER;

CREATE TRIGGER TRG_DEPARTMENT_AIUD
    AFTER INSERT OR UPDATE OR DELETE
    ON DEPARTMENTS
DECLARE

    V_OPR VARCHAR2(20);

BEGIN

    IF INSERTING THEN
        V_OPR := 'INSERT';
    ELSIF UPDATING THEN
        V_OPR := 'UPDATE';
    ELSE
        V_OPR := 'DELETE';
    END IF;

    INSERT INTO APP_AUDIT_DATA(
        AUDIT_DATA_ID, 
        AUDIT_OBJECT, 
        AUDIT_OPERATION, 
        AUD_INS_DTTM, 
        AUD_UPD_USER, 
        AUD_REC_STAT) VALUES (
            SEQ_APP_AUDIT_DATA.NEXTVAL,
            'DEPARTMENTS',
            V_OPR,
            SYSDATE,
            USER,
            'A'
        );

EXCEPTION WHEN OTHERS THEN

    -- TO SURPRESS THE ERROR IN CASE YOU DON'T
    -- WANT ANYONE TO KNOW THAT TABLE IS BEING AUDITED
    NULL;

END;
/

------------------------------------------------------

INSERT INTO DEPARTMENTS (
    DEPARTMENT_ID,
    DEPARTMENT_NAME,
    CITY,
    STATE) VALUES (
        10,
        'Accounting',
        'Boston',
        'NV'
    );

INSERT INTO DEPARTMENTS (
    DEPARTMENT_ID,
    DEPARTMENT_NAME,
    CITY,
    STATE) VALUES (
        11,
        'Production',
        'Redlands',
        'CA'
    );    

COMMIT;

------------------------------------------------------

UPDATE DEPARTMENTS SET
    CITY = 'Dallas',
    STATE = 'TX'
WHERE DEPARTMENT_ID = 1O;

COMMIT;

------------------------------------------------------

DELETE FROM DEPARTMENTS
WHERE DEPARTMENT_ID = 11;

COMMIT;

------------------------------------------------------

SELECT AUDIT_DATA_ID,
    AUDIT_OBJECT TABLE_NAME,
    AUDIT_OPERATION OPERATION,
    TO_CHAR (AUD_INS_DTTM, 'DD-MON-YYYY HH24:MI:SS') CREATE_DATE,
    AUD_UPD_USER USERNAME,
    AUD_REC_STAT ROW_STATUS
FROM APP_AUDIT_DATA
/

------------------------------------------------------