CREATE TABLE finance_schema.mstoptionprice (
    contractid bigint NOT NULL,
    optionprice numeric(15,4),
    openinterest integer,
    volume integer,
    lastupdateddate timestamp with time zone NOT NULL
);

ALTER TABLE finance_schema.mstoptionprice OWNER TO finance_master;

COMMENT ON TABLE finance_schema.mstoptionprice IS 'Current price snapshot for each option contract. One row per contract, overwritten on each price refresh.';

COMMENT ON COLUMN finance_schema.mstoptionprice.contractid IS 'Option contract this price row belongs to. References mstoptioncontract.';

COMMENT ON COLUMN finance_schema.mstoptionprice.optionprice IS 'Current market price (premium) of the option contract.';

COMMENT ON COLUMN finance_schema.mstoptionprice.openinterest IS 'Total number of outstanding open contracts.';

COMMENT ON COLUMN finance_schema.mstoptionprice.volume IS 'Number of contracts traded during the current session.';

COMMENT ON COLUMN finance_schema.mstoptionprice.lastupdateddate IS 'Timestamp when this price row was last refreshed.';

ALTER TABLE ONLY finance_schema.mstoptionprice
    ADD CONSTRAINT mstoptionprice_pkey PRIMARY KEY (contractid);

ALTER TABLE ONLY finance_schema.mstoptionprice
    ADD CONSTRAINT mstoptionprice_contractid_fkey FOREIGN KEY (contractid) REFERENCES finance_schema.mstoptioncontract(contractid) ON UPDATE RESTRICT ON DELETE RESTRICT;

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE finance_schema.mstoptionprice TO finance_app_role;
