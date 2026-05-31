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

ALTER TABLE ONLY finance_schema.otpverificationhistory ALTER COLUMN seqid SET DEFAULT nextval('finance_schema.otpverificationhistory_seqid_seq'::regclass);

ALTER TABLE ONLY finance_schema.otpverificationhistory
    ADD CONSTRAINT otpverificationhistory_pkey PRIMARY KEY (seqid);

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE finance_schema.otpverificationhistory TO finance_app_role;

GRANT ALL ON SEQUENCE finance_schema.otpverificationhistory_seqid_seq TO finance_app_role;
