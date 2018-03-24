``--Creating Application Owner
CREATE USER APP_OWNER IDENTIFIED BY APP_OWNER
DEFAULT TABLESPACE USERS
TEMPORARY TABLESPACE TEMP QUOTA UNLIMITED ON USERS

GRANT RESOURCE, CREATE SESSION TO APP_OWNER

-- Creatin Proxy User
CREATE USER APP_PROXY IDENTIFIED BY APP_PROXY
DEFAULT TABLESPACE USERS
TEMPORARY TABLESPACE TEMP

GRANT CREATE SESSION TO APP_PROXY

CONN APP_OWNER@SEC

--Creating application tables
CREATE TABLE CUSTOMERS
( 
    CUSTOMER_ID NUMBER,
    CUSTOMER_NAME VARCHAR2(50)
)

CREATE TABLE AUTH_TABLE
( 
    APP_USER_ID NUMBER,
    APP_USERNAME VARCHAR2(20),
    APP_PASSWORD VARCHAR2(20),
    APP_ROLE VARCHAR2(30)
)


CONN SYSTEM@SEC
--Creating Application Roles
CREATE ROLE APP_MGR;
CREATE ROLE APP_SUP;
CREATE ROLE APP_CLERK;
GRANT APP_MGR, APP_SUP, APP_CLERK TO APP_PROXY;


CONN APP_OWNER@SEC

GRANT SELECT, INSERT, UPDATE, DELETE ON CUSTOMERS TO APP_MGR;

GRANT SELECT, INSERT, UPDATE ON CUSTOMERS TO APP_SUP;

GRANT SELECT ON CUSTOMERS TO APP_CLERK;

GRANT SELECT ON AUTH_TABLE TO APP_PROXY;

-- Assign Grants
CONN APP_OWNER@SEC;
 INSERT INTO CUSTOMERS VALUES(1,'TOM VERENDA');
 INSERT INTO CUSTOMERS VALUES(2,'LINDA BELLA');
 COMMIT;

 INSERT INTO AUTH_TABLE VALUES (100,'APP_USER','D323DEQW4DF55FWE','APP_CLERK');


SELECT APP_ROLE FROM AUTH_TABLE
WHERE APP_USERNAME = 'APP_USER';

CONN APP_PROXY@SEC;

SET ROLE APP_CLERK;

SELECT * FROM SESSION_ROLES;