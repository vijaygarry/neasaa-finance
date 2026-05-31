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

ALTER TABLE ONLY finance_schema.otpverification
    ADD CONSTRAINT otpverification_pkey PRIMARY KEY (emailid, otptype);

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE finance_schema.otpverification TO finance_app_role;
