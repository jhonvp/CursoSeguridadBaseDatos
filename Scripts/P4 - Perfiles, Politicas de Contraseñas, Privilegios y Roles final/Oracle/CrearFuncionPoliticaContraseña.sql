CREATE OR REPLACE FUNCTION digitonly_password (
    USERNAME    VARCHAR2,
    PASSWORD    VARCHAR2,
    OLD_PASSWORD    VARCHAR2
) RETURN BOOLEAN IS
BEGIN
    IF LENGTH(PASSWORD)<10 THEN
        RETURN FALSE;
    END IF;

    FOR I IN 1..LENGTH(PASSWORD) LOOP
        IF INSTR('1234567890',SUBSTR(PASSWORD,I,1)) = 0 THEN
            RETURN FALSE;
        END IF;
    END LOOP;
END;