SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;


INSERT INTO finance_schema.appuser (userid, logonname, hashpassword, firstname, lastname, emailid, phone, authenticationtype, singlesignonid, invalidloginattempts, lastlogintime, lastpasswordchangetime, status, createdby, createddate, lastupdatedby, lastupdateddate) 
VALUES (1, 'system', 'unknown pwd', 'System', 'User', 'system@finance.neasaa.com', NULL, 'DB_PWD', NULL, NULL, NULL, NULL, 'I', 1, '2026-05-18 00:00:00-04', 1, '2026-05-18 00:00:00-04');


INSERT INTO finance_schema.lkpoperation (operationid, description, isauthorizationrequired, isauditrequired, authorizationtype, active, createdby, createddate, lastupdatedby, lastupdateddate) 
VALUES ('LOGIN', 'Login to application - authenticate user and create session', false, true, 'NO_AUTHORIZATION', true, 1, '2026-05-18 00:00:00-04', 1, '2026-05-18 00:00:00-04');
INSERT INTO finance_schema.lkpoperation (operationid, description, isauthorizationrequired, isauditrequired, authorizationtype, active, createdby, createddate, lastupdatedby, lastupdateddate) 
VALUES ('LOGOUT', 'Logout User - Destroy the current session', false, true, 'NO_AUTHORIZATION', true, 1, '2026-05-18 00:00:00-04', 1, '2026-05-18 00:00:00-04');
INSERT INTO finance_schema.lkpoperation (operationid, description, isauthorizationrequired, isauditrequired, authorizationtype, active, createdby, createddate, lastupdatedby, lastupdateddate) 
VALUES ('WHO_AM_I', 'Get session details with member Id', true, true, 'ROLE_BASE', true, 1, '2026-05-18 00:00:00-04', 1, '2026-05-18 00:00:00-04');
INSERT INTO finance_schema.lkpoperation (operationid, description, isauthorizationrequired, isauditrequired, authorizationtype, active, createdby, createddate, lastupdatedby, lastupdateddate) 
VALUES ('CHANGE_PASSWORD', 'Change user password', true, true, 'ROLE_BASE', true, 1, '2026-05-18 00:00:00-04', 1, '2026-05-18 00:00:00-04');
INSERT INTO finance_schema.lkpoperation (operationid, description, isauthorizationrequired, isauditrequired, authorizationtype, active, createdby, createddate, lastupdatedby, lastupdateddate) 
VALUES ('FORGOT_PASSWORD_REQUEST_OTP', 'Request OTP for forgot password', false, true, 'NO_AUTHORIZATION', true, 1, '2026-05-18 00:00:00-04', 1, '2026-05-18 00:00:00-04');
INSERT INTO finance_schema.lkpoperation (operationid, description, isauthorizationrequired, isauditrequired, authorizationtype, active, createdby, createddate, lastupdatedby, lastupdateddate) 
VALUES ('RESET_FORGOT_PASSWORD', 'Reset forgot password', false, true, 'NO_AUTHORIZATION', true, 1, '2026-05-18 00:00:00-04', 1, '2026-05-18 00:00:00-04');
INSERT INTO finance_schema.lkpoperation (operationid, description, isauthorizationrequired, isauditrequired, authorizationtype, active, createdby, createddate, lastupdatedby, lastupdateddate) 
VALUES ('SIGN_UP_REQUEST_OTP', 'Request OTP for Sign Up', false, true, 'NO_AUTHORIZATION', true, 1, '2026-05-18 00:00:00-04', 1, '2026-05-18 00:00:00-04');
INSERT INTO finance_schema.lkpoperation (operationid, description, isauthorizationrequired, isauditrequired, authorizationtype, active, createdby, createddate, lastupdatedby, lastupdateddate) 
VALUES ('SIGN_UP', 'Sign Up User', false, true, 'NO_AUTHORIZATION', true, 1, '2026-05-18 00:00:00-04', 1, '2026-05-18 00:00:00-04');

INSERT INTO finance_schema.lkpoperation (operationid, description, isauthorizationrequired, isauditrequired, authorizationtype, active, createdby, createddate, lastupdatedby, lastupdateddate)
VALUES ('STOCK_SUGGESTION', 'Get stock suggestions', false, true, 'NO_AUTHORIZATION', true, 1, '2026-05-19 00:00:00-04', 1, '2026-05-19 00:00:00-04');


INSERT INTO finance_schema.lkprole (roleid, roledesc, enable, createdby, createddate, lastupdatedby, lastupdateddate) 
VALUES ('CUSTOMER_ROLE', 'Generic role for customers', true, 1, '2026-05-18 00:00:00-04', 1, '2026-05-18 00:00:00-04');
INSERT INTO finance_schema.lkprole (roleid, roledesc, enable, createdby, createddate, lastupdatedby, lastupdateddate) 
VALUES ('APPLICATION_ADMIN_ROLE', 'Application Admin Role', true, 1, '2026-05-18 00:00:00-04', 1, '2026-05-18 00:00:00-04');
INSERT INTO finance_schema.lkprole (roleid, roledesc, enable, createdby, createddate, lastupdatedby, lastupdateddate) 
VALUES ('SUPER_ADMIN_ROLE', 'Super Admin', true, 1, '2026-05-18 00:00:00-04', 1, '2026-05-18 00:00:00-04');


INSERT INTO finance_schema.lkproleoperationmap (roleid, operationid, createdby, createddate, lastupdatedby, lastupdateddate) VALUES ('SUPER_ADMIN_ROLE', 'WHO_AM_I', 1, '2026-05-18 00:00:00-04', 1, '2026-05-18 00:00:00-04');
INSERT INTO finance_schema.lkproleoperationmap (roleid, operationid, createdby, createddate, lastupdatedby, lastupdateddate) VALUES ('SUPER_ADMIN_ROLE', 'CHANGE_PASSWORD', 1, '2026-05-18 00:00:00-04', 1, '2026-05-18 00:00:00-04');
INSERT INTO finance_schema.lkproleoperationmap (roleid, operationid, createdby, createddate, lastupdatedby, lastupdateddate) VALUES ('SUPER_ADMIN_ROLE', 'FORGOT_PASSWORD_REQUEST_OTP', 1, '2026-05-18 00:00:00-04', 1, '2026-05-18 00:00:00-04');
INSERT INTO finance_schema.lkproleoperationmap (roleid, operationid, createdby, createddate, lastupdatedby, lastupdateddate) VALUES ('SUPER_ADMIN_ROLE', 'RESET_FORGOT_PASSWORD', 1, '2026-05-18 00:00:00-04', 1, '2026-05-18 00:00:00-04');
INSERT INTO finance_schema.lkproleoperationmap (roleid, operationid, createdby, createddate, lastupdatedby, lastupdateddate) VALUES ('SUPER_ADMIN_ROLE', 'SIGN_UP_REQUEST_OTP', 1, '2026-05-18 00:00:00-04', 1, '2026-05-18 00:00:00-04');
INSERT INTO finance_schema.lkproleoperationmap (roleid, operationid, createdby, createddate, lastupdatedby, lastupdateddate) VALUES ('SUPER_ADMIN_ROLE', 'SIGN_UP', 1, '2026-05-18 00:00:00-04', 1, '2026-05-18 00:00:00-04');


INSERT INTO finance_schema.mstuserrolemap (userid, roleid, createdby, createddate, lastupdatedby, lastupdateddate) VALUES (1, 'SUPER_ADMIN_ROLE', 1, '2026-05-18 00:00:00-04', 1, '2026-05-18 00:00:00-04');
