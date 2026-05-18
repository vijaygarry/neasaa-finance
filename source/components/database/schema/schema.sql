SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

CREATE SCHEMA finance_schema;
ALTER SCHEMA finance_schema OWNER TO finance_master;
COMMENT ON SCHEMA finance_schema IS 'Schema specific to neasaa finance application';


SET default_tablespace = '';
SET default_table_access_method = heap;

CREATE TABLE finance_schema.appuser (
    userid integer NOT NULL,
    logonname character varying(255) NOT NULL,
    hashpassword character varying(1024) NOT NULL,
    firstname character varying(64) NOT NULL,
    lastname character varying(64) NOT NULL,
    emailid character varying(255),
    phone character varying(20),
    authenticationtype character varying(100) DEFAULT 'DB_PWD'::character varying NOT NULL,
    singlesignonid character varying(100),
    invalidloginattempts integer,
    lastlogintime timestamp with time zone,
    lastpasswordchangetime timestamp with time zone,
    status character(1) NOT NULL,
    createdby integer NOT NULL,
    createddate timestamp with time zone NOT NULL,
    lastupdatedby integer NOT NULL,
    lastupdateddate timestamp with time zone NOT NULL
);

ALTER TABLE finance_schema.appuser OWNER TO finance_master;
COMMENT ON TABLE finance_schema.appuser IS 'Table for application users';
COMMENT ON COLUMN finance_schema.appuser.userid IS 'Unique numeric id for user. This value will be used by other tables for reference.';
COMMENT ON COLUMN finance_schema.appuser.logonname IS 'Unique logon name to identify the user. This can be alphanumaric id or email id';
COMMENT ON COLUMN finance_schema.appuser.hashpassword IS 'Encrypted (one way hash) password for this user';
COMMENT ON COLUMN finance_schema.appuser.firstname IS 'Users first name';
COMMENT ON COLUMN finance_schema.appuser.lastname IS 'Users last name';
COMMENT ON COLUMN finance_schema.appuser.emailid IS 'Unique User emailid';
COMMENT ON COLUMN finance_schema.appuser.authenticationtype IS 'How this user is authenticated in application. Options are DB_PWD, LDAP, OAUTH';
COMMENT ON COLUMN finance_schema.appuser.singlesignonid IS 'Is used to authenticate user with single sign on application like Free IPA or Active Directory. In most case, this will be same as logonname';
COMMENT ON COLUMN finance_schema.appuser.invalidloginattempts IS 'This columns maintain number of invalid attempts for this user.
On every successful login this number get reset to zero.
If this number goes above threshold invalid login attempt, user status will get updtaed to locked.';
COMMENT ON COLUMN finance_schema.appuser.lastlogintime IS 'Time when this user is successfully login to application';
COMMENT ON COLUMN finance_schema.appuser.status IS 'Status of the user.
A - Active
I - Inactive
L - Lock
Only active user can login and perform transactions.';
COMMENT ON COLUMN finance_schema.appuser.createdby IS 'User id for user who created this record';
COMMENT ON COLUMN finance_schema.appuser.createddate IS 'Time when this record was created';
COMMENT ON COLUMN finance_schema.appuser.lastupdatedby IS 'User id for user who last updated this record';
COMMENT ON COLUMN finance_schema.appuser.lastupdateddate IS 'Time when this record was last updated';


CREATE SEQUENCE finance_schema.appuser_userid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE finance_schema.appuser_userid_seq OWNER TO finance_master;

ALTER SEQUENCE finance_schema.appuser_userid_seq OWNED BY finance_schema.appuser.userid;



CREATE TABLE finance_schema.lkpconfig (
    configname character varying(255) NOT NULL,
    paramname character varying(255) NOT NULL,
    paramvalue character varying(500) NOT NULL,
    enable boolean DEFAULT true NOT NULL,
    listorderseq smallint,
    createdby integer NOT NULL,
    createddate timestamp with time zone NOT NULL,
    lastupdatedby integer NOT NULL,
    lastupdateddate timestamp with time zone NOT NULL
);


ALTER TABLE finance_schema.lkpconfig OWNER TO finance_master;

COMMENT ON COLUMN finance_schema.lkpconfig.configname IS 'Main config name e.g. COUNTRYNAME';
COMMENT ON COLUMN finance_schema.lkpconfig.paramname IS 'config parameter name e.g. HINDI. This will be the same as config name if no sub config name';
COMMENT ON COLUMN finance_schema.lkpconfig.paramvalue IS 'Config value for config name and config param name';
COMMENT ON COLUMN finance_schema.lkpconfig.enable IS 'Y means enabled and should be pickup by application';
COMMENT ON COLUMN finance_schema.lkpconfig.listorderseq IS 'If config has multiple param, then this will be order of config.';
COMMENT ON COLUMN finance_schema.lkpconfig.createdby IS 'User id for user who created this record';
COMMENT ON COLUMN finance_schema.lkpconfig.createddate IS 'Time when this record was created';
COMMENT ON COLUMN finance_schema.lkpconfig.lastupdatedby IS 'User id for user who last updated this record';
COMMENT ON COLUMN finance_schema.lkpconfig.lastupdateddate IS 'Time when this record was last updated';



CREATE TABLE finance_schema.lkpoperation (
    operationid character varying(55) NOT NULL,
    description character varying(255) NOT NULL,
    isauthorizationrequired boolean DEFAULT true NOT NULL,
    isauditrequired boolean DEFAULT true NOT NULL,
    authorizationtype character varying(100) DEFAULT 'ROLE_BASE'::character varying NOT NULL,
    active boolean DEFAULT true NOT NULL,
    createdby integer NOT NULL,
    createddate timestamp with time zone NOT NULL,
    lastupdatedby integer NOT NULL,
    lastupdateddate timestamp with time zone NOT NULL
);


ALTER TABLE finance_schema.lkpoperation OWNER TO finance_master;

COMMENT ON TABLE finance_schema.lkpoperation IS 'Main operation table which mapped to one API call to application.';
COMMENT ON COLUMN finance_schema.lkpoperation.operationid IS 'Unique alpha numeric opearation id';
COMMENT ON COLUMN finance_schema.lkpoperation.description IS 'Operation description';
COMMENT ON COLUMN finance_schema.lkpoperation.isauthorizationrequired IS 'True indicate user authentication/authorization is required to execute this operation.';
COMMENT ON COLUMN finance_schema.lkpoperation.isauditrequired IS 'True indicate audit this transaction';
COMMENT ON COLUMN finance_schema.lkpoperation.authorizationtype IS 'Type of authorization required for this operation. Possible values are NO_AUTHORIZATION, IP_BASE, ROLE_BASE';
COMMENT ON COLUMN finance_schema.lkpoperation.active IS 'If this value is true, then application will load this operation, if this flag is false, then application won''t recognize this operation.';
COMMENT ON COLUMN finance_schema.lkpoperation.createdby IS 'User id for user who created this record';
COMMENT ON COLUMN finance_schema.lkpoperation.createddate IS 'Time when this record was created';
COMMENT ON COLUMN finance_schema.lkpoperation.lastupdatedby IS 'User id for user who last updated this record';
COMMENT ON COLUMN finance_schema.lkpoperation.lastupdateddate IS 'Time when this record was last updated';


CREATE TABLE finance_schema.lkprole (
    roleid character varying(55) NOT NULL,
    roledesc character varying(255) NOT NULL,
    enable boolean DEFAULT true NOT NULL,
    createdby integer NOT NULL,
    createddate timestamp with time zone NOT NULL,
    lastupdatedby integer NOT NULL,
    lastupdateddate timestamp with time zone NOT NULL
);


ALTER TABLE finance_schema.lkprole OWNER TO finance_master;

COMMENT ON TABLE finance_schema.lkprole IS 'Role table';
COMMENT ON COLUMN finance_schema.lkprole.roleid IS 'Unique alphanumeric role id';
COMMENT ON COLUMN finance_schema.lkprole.roledesc IS 'Desc for this role';
COMMENT ON COLUMN finance_schema.lkprole.enable IS 'This flag indicate if this role is active.';


CREATE TABLE finance_schema.lkproleoperationmap (
    roleid character varying(55) NOT NULL,
    operationid character varying(55) NOT NULL,
    createdby integer NOT NULL,
    createddate timestamp with time zone NOT NULL,
    lastupdatedby integer NOT NULL,
    lastupdateddate timestamp with time zone NOT NULL
);


ALTER TABLE finance_schema.lkproleoperationmap OWNER TO finance_master;

COMMENT ON TABLE finance_schema.lkproleoperationmap IS 'Role Operation link table. This will have list of operation mapped to a role.';
COMMENT ON COLUMN finance_schema.lkproleoperationmap.roleid IS 'Role Id';
COMMENT ON COLUMN finance_schema.lkproleoperationmap.operationid IS 'Operation id assign to role';



CREATE TABLE finance_schema.mstuserrolemap (
    userid integer NOT NULL,
    roleid character varying(100) NOT NULL,
    createdby integer NOT NULL,
    createddate timestamp with time zone NOT NULL,
    lastupdatedby integer NOT NULL,
    lastupdateddate timestamp with time zone NOT NULL
);


ALTER TABLE finance_schema.mstuserrolemap OWNER TO finance_master;

COMMENT ON TABLE finance_schema.mstuserrolemap IS 'User role link table. This table will have list of roles assign to user.';
COMMENT ON COLUMN finance_schema.mstuserrolemap.userid IS 'User Id';
COMMENT ON COLUMN finance_schema.mstuserrolemap.roleid IS 'Role Id';


CREATE TABLE finance_schema.otpverification (
    emailid character varying(255) NOT NULL,
    otptype character varying(50) NOT NULL,
    hashotpcode character varying(1024) NOT NULL,
    requestid character varying(55) NOT NULL,
    status character varying(20) DEFAULT 'Pending'::character varying NOT NULL,
    verifiedat timestamp with time zone,
    expirydate timestamp with time zone NOT NULL,
    attempts integer DEFAULT 0 NOT NULL,
    lastattemptdate timestamp with time zone,
    createddate timestamp with time zone NOT NULL,
    lastupdateddate timestamp with time zone NOT NULL
);


ALTER TABLE finance_schema.otpverification OWNER TO finance_master;

COMMENT ON TABLE finance_schema.otpverification IS 'Table for storing OTP verification details';
COMMENT ON COLUMN finance_schema.otpverification.emailid IS 'Email address associated with the OTP';
COMMENT ON COLUMN finance_schema.otpverification.otptype IS 'Type of OTP (e.g., SignUp, ForgotPassword)';
COMMENT ON COLUMN finance_schema.otpverification.hashotpcode IS 'Encrypted (one way hash) OTP code for this user';
COMMENT ON COLUMN finance_schema.otpverification.requestid IS 'Identifier for the OTP request';
COMMENT ON COLUMN finance_schema.otpverification.status IS 'Current status of the OTP (e.g., Pending, Verified, Expired)';
COMMENT ON COLUMN finance_schema.otpverification.verifiedat IS 'Timestamp when the OTP was verified';
COMMENT ON COLUMN finance_schema.otpverification.expirydate IS 'Timestamp when the OTP expires';
COMMENT ON COLUMN finance_schema.otpverification.attempts IS 'Number of attempts made to verify the OTP';
COMMENT ON COLUMN finance_schema.otpverification.lastattemptdate IS 'Timestamp of the last attempt to verify the OTP';
COMMENT ON COLUMN finance_schema.otpverification.createddate IS 'Timestamp when the OTP verification entry was created';
COMMENT ON COLUMN finance_schema.otpverification.lastupdateddate IS 'Timestamp when the OTP verification entry was last updated';


CREATE TABLE finance_schema.otpverificationhistory (
    seqid bigint NOT NULL,
    emailid character varying(255) NOT NULL,
    otptype character varying(50) NOT NULL,
    hashotpcode character varying(1024) NOT NULL,
    requestid character varying(55) NOT NULL,
    status character varying(20) DEFAULT 'Pending'::character varying NOT NULL,
    verifiedat timestamp with time zone,
    expirydate timestamp with time zone NOT NULL,
    attempts integer DEFAULT 0 NOT NULL,
    lastattemptdate timestamp with time zone,
    createddate timestamp with time zone NOT NULL,
    lastupdateddate timestamp with time zone NOT NULL
);


ALTER TABLE finance_schema.otpverificationhistory OWNER TO finance_master;
COMMENT ON TABLE finance_schema.otpverificationhistory IS 'Table for storing OTP verification details';
COMMENT ON COLUMN finance_schema.otpverificationhistory.seqid IS 'Unique identifier for each OTP verification entry';
COMMENT ON COLUMN finance_schema.otpverificationhistory.emailid IS 'Email address associated with the OTP';
COMMENT ON COLUMN finance_schema.otpverificationhistory.otptype IS 'Type of OTP (e.g., SignUp, ForgotPassword)';
COMMENT ON COLUMN finance_schema.otpverificationhistory.hashotpcode IS 'Encrypted (one way hash) OTP code for this user';
COMMENT ON COLUMN finance_schema.otpverificationhistory.requestid IS 'Identifier for the OTP request';
COMMENT ON COLUMN finance_schema.otpverificationhistory.status IS 'Current status of the OTP (e.g., Pending, Verified, Expired)';
COMMENT ON COLUMN finance_schema.otpverificationhistory.verifiedat IS 'Timestamp when the OTP was verified';
COMMENT ON COLUMN finance_schema.otpverificationhistory.expirydate IS 'Timestamp when the OTP expires';
COMMENT ON COLUMN finance_schema.otpverificationhistory.attempts IS 'Number of attempts made to verify the OTP';
COMMENT ON COLUMN finance_schema.otpverificationhistory.lastattemptdate IS 'Timestamp of the last attempt to verify the OTP';
COMMENT ON COLUMN finance_schema.otpverificationhistory.createddate IS 'Timestamp when the OTP verification entry was created';
COMMENT ON COLUMN finance_schema.otpverificationhistory.lastupdateddate IS 'Timestamp when the OTP verification entry was last updated';

CREATE SEQUENCE finance_schema.otpverificationhistory_seqid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE finance_schema.otpverificationhistory_seqid_seq OWNER TO finance_master;

ALTER SEQUENCE finance_schema.otpverificationhistory_seqid_seq OWNED BY finance_schema.otpverificationhistory.seqid;



CREATE TABLE finance_schema.txtsession (
    sessionid bigint NOT NULL,
    userid integer,
    channelid character varying(64) NOT NULL,
    active boolean DEFAULT true NOT NULL,
    authenticated boolean DEFAULT false NOT NULL,
    sessioncreationtime timestamp with time zone NOT NULL,
    logouttime timestamp with time zone,
    lastaccesstime timestamp with time zone,
    exitcode smallint DEFAULT 1,
    apphostname character varying(80) NOT NULL,
    clientipaddress character varying(55) NOT NULL,
    user_agent text
);


ALTER TABLE finance_schema.txtsession OWNER TO finance_master;

COMMENT ON TABLE finance_schema.txtsession IS 'Maintain session created in application';
COMMENT ON COLUMN finance_schema.txtsession.sessionid IS 'Unique session id.';
COMMENT ON COLUMN finance_schema.txtsession.userid IS 'User this session belongs to';
COMMENT ON COLUMN finance_schema.txtsession.channelid IS 'Channel this session is created for. E.g. Server, Browser, Mobile';
COMMENT ON COLUMN finance_schema.txtsession.active IS 'Flag indicate if this is active session.';
COMMENT ON COLUMN finance_schema.txtsession.authenticated IS 'Flag indicate if this is authenticated session.';
COMMENT ON COLUMN finance_schema.txtsession.sessioncreationtime IS 'Session creation time';
COMMENT ON COLUMN finance_schema.txtsession.logouttime IS 'Session logout time';
COMMENT ON COLUMN finance_schema.txtsession.lastaccesstime IS 'Last access session time to see if session should be kept active.';
COMMENT ON COLUMN finance_schema.txtsession.exitcode IS 'How the session is terminated. Possible values 1-> User Logout, 2-> Session Timeout, 3-> Override by new session, 4-> Kill by Admin';
COMMENT ON COLUMN finance_schema.txtsession.apphostname IS 'application Hostname or IP of Application from where this session is created';
COMMENT ON COLUMN finance_schema.txtsession.clientipaddress IS 'Client IP address';
COMMENT ON COLUMN finance_schema.txtsession.user_agent IS 'Client user agent including browser name and version, client OS name and version. Obtain from user-agent header of HTTP request. This may not be accurate.';

CREATE SEQUENCE finance_schema.txtsession_sessionid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE finance_schema.txtsession_sessionid_seq OWNER TO finance_master;

ALTER SEQUENCE finance_schema.txtsession_sessionid_seq OWNED BY finance_schema.txtsession.sessionid;


CREATE TABLE finance_schema.txtsessiontxn (
    txnid bigint NOT NULL,
    sessionid bigint NOT NULL,
    operationid character varying(55) NOT NULL,
    userid integer,
    txnstarttime timestamp with time zone NOT NULL,
    txnlatencymillis bigint,
    httpresponsecode integer,
    request text,
    response text
);


ALTER TABLE finance_schema.txtsessiontxn OWNER TO finance_master;

COMMENT ON TABLE finance_schema.txtsessiontxn IS 'Table holds list of transactions perform in session';
COMMENT ON COLUMN finance_schema.txtsessiontxn.txnid IS 'Unique transaction id.';
COMMENT ON COLUMN finance_schema.txtsessiontxn.sessionid IS 'Session id.';
COMMENT ON COLUMN finance_schema.txtsessiontxn.operationid IS 'Operation id';
COMMENT ON COLUMN finance_schema.txtsessiontxn.userid IS 'User who performaing this operation';
COMMENT ON COLUMN finance_schema.txtsessiontxn.txnstarttime IS 'Transaction start time';
COMMENT ON COLUMN finance_schema.txtsessiontxn.txnlatencymillis IS 'Time took to process request in millis';
COMMENT ON COLUMN finance_schema.txtsessiontxn.httpresponsecode IS 'HTTP response code for this operation';
COMMENT ON COLUMN finance_schema.txtsessiontxn.request IS 'Request object. This can be complete json object';
COMMENT ON COLUMN finance_schema.txtsessiontxn.response IS 'Response object. This can be complete json object';

CREATE SEQUENCE finance_schema.txtsessiontxn_txnid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE finance_schema.txtsessiontxn_txnid_seq OWNER TO finance_master;

ALTER SEQUENCE finance_schema.txtsessiontxn_txnid_seq OWNED BY finance_schema.txtsessiontxn.txnid;


ALTER TABLE ONLY finance_schema.appuser ALTER COLUMN userid SET DEFAULT nextval('finance_schema.appuser_userid_seq'::regclass);

ALTER TABLE ONLY finance_schema.otpverificationhistory ALTER COLUMN seqid SET DEFAULT nextval('finance_schema.otpverificationhistory_seqid_seq'::regclass);

ALTER TABLE ONLY finance_schema.txtsession ALTER COLUMN sessionid SET DEFAULT nextval('finance_schema.txtsession_sessionid_seq'::regclass);

ALTER TABLE ONLY finance_schema.txtsessiontxn ALTER COLUMN txnid SET DEFAULT nextval('finance_schema.txtsessiontxn_txnid_seq'::regclass);


ALTER TABLE ONLY finance_schema.appuser
    ADD CONSTRAINT appuser_emailid_key UNIQUE (emailid);

ALTER TABLE ONLY finance_schema.appuser
    ADD CONSTRAINT appuser_logonname_key UNIQUE (logonname);

ALTER TABLE ONLY finance_schema.appuser
    ADD CONSTRAINT appuser_phone_key UNIQUE (phone);

ALTER TABLE ONLY finance_schema.appuser
    ADD CONSTRAINT appuser_pkey PRIMARY KEY (userid);


ALTER TABLE ONLY finance_schema.lkpconfig
    ADD CONSTRAINT lkpconfig_pkey PRIMARY KEY (configname, paramname);


ALTER TABLE ONLY finance_schema.lkpoperation
    ADD CONSTRAINT lkpoperation_pkey PRIMARY KEY (operationid);

ALTER TABLE ONLY finance_schema.lkprole
    ADD CONSTRAINT lkprole_pkey PRIMARY KEY (roleid);

ALTER TABLE ONLY finance_schema.lkproleoperationmap
    ADD CONSTRAINT lkproleoperationmap_pkey PRIMARY KEY (roleid, operationid);

ALTER TABLE ONLY finance_schema.mstuserrolemap
    ADD CONSTRAINT mstuserrolemap_pkey PRIMARY KEY (userid, roleid);

ALTER TABLE ONLY finance_schema.otpverification
    ADD CONSTRAINT otpverification_pkey PRIMARY KEY (emailid, otptype);

ALTER TABLE ONLY finance_schema.otpverificationhistory
    ADD CONSTRAINT otpverificationhistory_pkey PRIMARY KEY (seqid);

ALTER TABLE ONLY finance_schema.txtsession
    ADD CONSTRAINT txtsession_pkey PRIMARY KEY (sessionid);

ALTER TABLE ONLY finance_schema.txtsessiontxn
    ADD CONSTRAINT txtsessiontxn_pkey PRIMARY KEY (txnid);


ALTER TABLE ONLY finance_schema.lkpconfig
    ADD CONSTRAINT lkpconfig_createdby_fkey FOREIGN KEY (createdby) REFERENCES finance_schema.appuser(userid) ON UPDATE RESTRICT ON DELETE RESTRICT;


ALTER TABLE ONLY finance_schema.lkpconfig
    ADD CONSTRAINT lkpconfig_lastupdatedby_fkey FOREIGN KEY (lastupdatedby) REFERENCES finance_schema.appuser(userid) ON UPDATE RESTRICT ON DELETE RESTRICT;


ALTER TABLE ONLY finance_schema.lkpoperation
    ADD CONSTRAINT lkpoperation_createdby_fkey FOREIGN KEY (createdby) REFERENCES finance_schema.appuser(userid) ON UPDATE RESTRICT ON DELETE RESTRICT;


ALTER TABLE ONLY finance_schema.lkpoperation
    ADD CONSTRAINT lkpoperation_lastupdatedby_fkey FOREIGN KEY (lastupdatedby) REFERENCES finance_schema.appuser(userid) ON UPDATE RESTRICT ON DELETE RESTRICT;


ALTER TABLE ONLY finance_schema.lkprole
    ADD CONSTRAINT lkprole_createdby_fkey FOREIGN KEY (createdby) REFERENCES finance_schema.appuser(userid) ON UPDATE RESTRICT ON DELETE RESTRICT;

ALTER TABLE ONLY finance_schema.lkprole
    ADD CONSTRAINT lkprole_lastupdatedby_fkey FOREIGN KEY (lastupdatedby) REFERENCES finance_schema.appuser(userid) ON UPDATE RESTRICT ON DELETE RESTRICT;

ALTER TABLE ONLY finance_schema.lkproleoperationmap
    ADD CONSTRAINT lkproleoperationmap_createdby_fkey FOREIGN KEY (createdby) REFERENCES finance_schema.appuser(userid) ON UPDATE RESTRICT ON DELETE RESTRICT;

ALTER TABLE ONLY finance_schema.lkproleoperationmap
    ADD CONSTRAINT lkproleoperationmap_lastupdatedby_fkey FOREIGN KEY (lastupdatedby) REFERENCES finance_schema.appuser(userid) ON UPDATE RESTRICT ON DELETE RESTRICT;

ALTER TABLE ONLY finance_schema.lkproleoperationmap
    ADD CONSTRAINT lkproleoperationmap_operationid_fkey FOREIGN KEY (operationid) REFERENCES finance_schema.lkpoperation(operationid) ON UPDATE RESTRICT ON DELETE RESTRICT;

ALTER TABLE ONLY finance_schema.lkproleoperationmap
    ADD CONSTRAINT lkproleoperationmap_roleid_fkey FOREIGN KEY (roleid) REFERENCES finance_schema.lkprole(roleid) ON UPDATE RESTRICT ON DELETE RESTRICT;


ALTER TABLE ONLY finance_schema.mstuserrolemap
    ADD CONSTRAINT mstuserrolemap_createdby_fkey FOREIGN KEY (createdby) REFERENCES finance_schema.appuser(userid) ON UPDATE RESTRICT ON DELETE RESTRICT;

ALTER TABLE ONLY finance_schema.mstuserrolemap
    ADD CONSTRAINT mstuserrolemap_lastupdatedby_fkey FOREIGN KEY (lastupdatedby) REFERENCES finance_schema.appuser(userid) ON UPDATE RESTRICT ON DELETE RESTRICT;

ALTER TABLE ONLY finance_schema.mstuserrolemap
    ADD CONSTRAINT mstuserrolemap_roleid_fkey FOREIGN KEY (roleid) REFERENCES finance_schema.lkprole(roleid) ON UPDATE RESTRICT ON DELETE RESTRICT;

ALTER TABLE ONLY finance_schema.mstuserrolemap
    ADD CONSTRAINT mstuserrolemap_userid_fkey FOREIGN KEY (userid) REFERENCES finance_schema.appuser(userid) ON UPDATE RESTRICT ON DELETE RESTRICT;

ALTER TABLE ONLY finance_schema.txtsession
    ADD CONSTRAINT txtsession_userid_fkey FOREIGN KEY (userid) REFERENCES finance_schema.appuser(userid) ON UPDATE RESTRICT ON DELETE RESTRICT;

ALTER TABLE ONLY finance_schema.txtsessiontxn
    ADD CONSTRAINT txtsessiontxn_operationid_fkey FOREIGN KEY (operationid) REFERENCES finance_schema.lkpoperation(operationid) ON UPDATE RESTRICT ON DELETE RESTRICT;

ALTER TABLE ONLY finance_schema.txtsessiontxn
    ADD CONSTRAINT txtsessiontxn_sessionid_fkey FOREIGN KEY (sessionid) REFERENCES finance_schema.txtsession(sessionid) ON UPDATE RESTRICT ON DELETE RESTRICT;

ALTER TABLE ONLY finance_schema.txtsessiontxn
    ADD CONSTRAINT txtsessiontxn_userid_fkey FOREIGN KEY (userid) REFERENCES finance_schema.appuser(userid) ON UPDATE RESTRICT ON DELETE RESTRICT;



GRANT USAGE ON SCHEMA finance_schema TO finance_app_role;

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE finance_schema.appuser TO finance_app_role;

GRANT ALL ON SEQUENCE finance_schema.appuser_userid_seq TO finance_app_role;

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE finance_schema.lkpconfig TO finance_app_role;

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE finance_schema.lkpoperation TO finance_app_role;

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE finance_schema.lkprole TO finance_app_role;

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE finance_schema.lkproleoperationmap TO finance_app_role;

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE finance_schema.mstuserrolemap TO finance_app_role;

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE finance_schema.otpverification TO finance_app_role;

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE finance_schema.otpverificationhistory TO finance_app_role;

GRANT ALL ON SEQUENCE finance_schema.otpverificationhistory_seqid_seq TO finance_app_role;

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE finance_schema.txtsession TO finance_app_role;

GRANT ALL ON SEQUENCE finance_schema.txtsession_sessionid_seq TO finance_app_role;

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE finance_schema.txtsessiontxn TO finance_app_role;

GRANT ALL ON SEQUENCE finance_schema.txtsessiontxn_txnid_seq TO finance_app_role;
