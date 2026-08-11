CREATE TABLE IF NOT EXISTS finance_schema.accountsnapshot
(
    accountid bigint NOT NULL,
    snapshotdate date NOT NULL,
    symbol character varying(25) COLLATE pg_catalog."default" NOT NULL,
    optionsymbol character varying(55) COLLATE pg_catalog."default" NOT NULL,
    description character varying(255) COLLATE pg_catalog."default" NOT NULL,
    quantity numeric(12,2),
    lastprice numeric(12,3),
    lastpricechange numeric(12,3),
    currentvalue numeric(15,3),
    averagecostbasis numeric(12,3),
    totalcostbasis numeric(15,3),
    todaygainloss numeric(15,3),
    totalgainloss numeric(15,3),
    percentofaccount numeric(12,3),
    createdby integer NOT NULL,
    createddate timestamp with time zone NOT NULL,
    lastupdatedby integer NOT NULL,
    lastupdateddate timestamp with time zone NOT NULL,
    CONSTRAINT accountsnapshot_pkey PRIMARY KEY (accountid, snapshotdate, symbol, optionsymbol),
    CONSTRAINT accountsnapshot_accountid_fkey FOREIGN KEY (accountid)
        REFERENCES finance_schema.account (accountid) MATCH SIMPLE
        ON UPDATE RESTRICT
        ON DELETE RESTRICT
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS finance_schema.accountsnapshot
    OWNER to finance_master;

COMMENT ON TABLE finance_schema.accountsnapshot
    IS 'This table holds account snapshot for a given date.';

COMMENT ON COLUMN finance_schema.accountsnapshot.accountid
    IS 'Application account Id';

COMMENT ON COLUMN finance_schema.accountsnapshot.snapshotdate
    IS 'Date this snapshot is taken. This date will be in EST in dd-mmm-yyyy format.';

COMMENT ON COLUMN finance_schema.accountsnapshot.symbol
    IS 'Ticker Symbol. For options this will be the underlying symbol';

COMMENT ON COLUMN finance_schema.accountsnapshot.optionsymbol
    IS 'For option this will be option symbol like TSLA240119C200. Not non option investment, this will be same as symbol.';

COMMENT ON COLUMN finance_schema.accountsnapshot.currentvalue
    IS 'Current value of this investment as per price during snapshot';

COMMENT ON COLUMN finance_schema.accountsnapshot.averagecostbasis
    IS 'Average cost of this investment';

COMMENT ON COLUMN finance_schema.accountsnapshot.totalcostbasis
    IS 'Total cost of this investment';

COMMENT ON COLUMN finance_schema.accountsnapshot.todaygainloss
    IS 'Todays gain or loss';

COMMENT ON COLUMN finance_schema.accountsnapshot.totalgainloss
    IS 'Total gain loss for this investment';