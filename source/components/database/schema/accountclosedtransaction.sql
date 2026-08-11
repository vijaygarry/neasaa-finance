-- Table: finance_schema.accountclosedtransaction
-- This table will list open/close transaction combination with gain/loss. This is a derived table from accountactivity and accounttxnlot.
-- It will be used to generate tax report for the user.

-- Table: finance_schema.accountclosedtransaction

-- DROP TABLE IF EXISTS finance_schema.accountclosedtransaction;

CREATE TABLE IF NOT EXISTS finance_schema.accountclosedtransaction
(
    accountid bigint NOT NULL,
    opentxnid character varying(55) COLLATE pg_catalog."default" NOT NULL,
    openlotid integer NOT NULL,
    opendate date NOT NULL,
    closetxnid character varying(55) COLLATE pg_catalog."default" NOT NULL,
    closelotid integer NOT NULL,
    closedate date NOT NULL,
    quantity numeric(12,4) NOT NULL,
    symbol character varying(25) COLLATE pg_catalog."default" NOT NULL,
    investmentid character varying(25) COLLATE pg_catalog."default" NOT NULL,
    opentxntype character varying(55) COLLATE pg_catalog."default" NOT NULL,
    closetxntype character varying(55) COLLATE pg_catalog."default" NOT NULL,
    costbasisper numeric(15,4) NOT NULL,
    proceedsper numeric(15,4) NOT NULL,
    totalcostbasis numeric(15,4) NOT NULL,
    totalproceeds numeric(15,4) NOT NULL,
    gainloss numeric(15,4) NOT NULL,
    gaintype character varying(25) COLLATE pg_catalog."default" NOT NULL,
    createdby integer NOT NULL,
    createddate timestamp with time zone NOT NULL,
    lastupdatedby integer NOT NULL,
    lastupdateddate timestamp with time zone NOT NULL,
    CONSTRAINT accountclosedtransaction_pkey PRIMARY KEY (accountid, opentxnid, openlotid),
    CONSTRAINT accountclosedtransaction_accountid_closetxnid_closelotid_fkey FOREIGN KEY (accountid, closetxnid, closelotid)
        REFERENCES finance_schema.accounttxnlot (accountid, txnid, lotid) MATCH SIMPLE
        ON UPDATE RESTRICT
        ON DELETE RESTRICT
        NOT VALID,
    CONSTRAINT accountclosedtransaction_accountid_opentxnid_openlotid_fkey FOREIGN KEY (accountid, opentxnid, openlotid)
        REFERENCES finance_schema.accounttxnlot (accountid, txnid, lotid) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS finance_schema.accountclosedtransaction
    OWNER to finance_master;

COMMENT ON COLUMN finance_schema.accountclosedtransaction.costbasisper
    IS 'Cost basis per share for this transaction. costbasisper = (total lot price including fees and commission)/ quantity.';

COMMENT ON COLUMN finance_schema.accountclosedtransaction.proceedsper
    IS 'Total proceed per share for this transaction. proceed per = (total lot price including fees and commission)/ quantity.';

COMMENT ON COLUMN finance_schema.accountclosedtransaction.totalcostbasis
    IS 'Total cost for this transaction.';

COMMENT ON COLUMN finance_schema.accountclosedtransaction.totalproceeds
    IS 'Total proceed for this transaction.';

COMMENT ON COLUMN finance_schema.accountclosedtransaction.gainloss
    IS '+ve value indicate profit and -ve value indicate loss.';

COMMENT ON COLUMN finance_schema.accountclosedtransaction.gaintype
    IS 'Possible values: LONG_TERM, SHORT_TERM, QUALIFIED_DIVIDEND, NON_QUALIFIED_DIVIDEND, INTEREST_INCOME. DIVIDEND received on Money market is considered as NON_QUALIFIED_DIVIDEND.';