-- Table: finance_schema.account

-- DROP TABLE IF EXISTS finance_schema.account;

CREATE TABLE IF NOT EXISTS finance_schema.account
(
    accountid bigint NOT NULL DEFAULT nextval('account_accountid_seq'::regclass),
    userid integer NOT NULL,
    accountnumber character varying(100) COLLATE pg_catalog."default",
    accountname character varying(100) COLLATE pg_catalog."default" NOT NULL,
    bankname character varying(55) COLLATE pg_catalog."default" NOT NULL,
    accounttype character varying(55) COLLATE pg_catalog."default",
    createdby integer NOT NULL,
    createddate timestamp with time zone NOT NULL,
    lastupdatedby integer NOT NULL,
    lastupdateddate timestamp with time zone NOT NULL,
    CONSTRAINT account_pkey PRIMARY KEY (accountid),
    CONSTRAINT account_userid_fkey FOREIGN KEY (userid)
        REFERENCES finance_schema.appuser (userid) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS finance_schema.account
    OWNER to finance_master;

REVOKE ALL ON TABLE finance_schema.account FROM finance_app_role;

GRANT DELETE, INSERT, SELECT, UPDATE ON TABLE finance_schema.account TO finance_app_role;

GRANT ALL ON TABLE finance_schema.account TO finance_master;

COMMENT ON TABLE finance_schema.account
    IS 'Main account table';

COMMENT ON COLUMN finance_schema.account.accountnumber
    IS 'Actual account number in bank';

COMMENT ON COLUMN finance_schema.account.accountname
    IS 'User friendly name for this account. MyAccount, Individual, HSA, 401K, RSU, ESPP';

COMMENT ON COLUMN finance_schema.account.bankname
    IS 'Etrade, Fidelity, Edward Johns, RobinHood';

COMMENT ON COLUMN finance_schema.account.accounttype
    IS 'Type like Trading, HSA, Company Stock Option, VA529';