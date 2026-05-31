CREATE TABLE finance_schema.txtoptionpricehistory (
    historyid bigint NOT NULL,
    contractid bigint NOT NULL,
    tradedate date NOT NULL,
    optionprice numeric(15,4) NOT NULL,
    openinterest integer,
    volume integer
);

ALTER TABLE finance_schema.txtoptionpricehistory OWNER TO finance_master;

COMMENT ON TABLE finance_schema.txtoptionpricehistory IS 'Daily price history per option contract. One row per contract per trading day. Append-only.';

COMMENT ON COLUMN finance_schema.txtoptionpricehistory.historyid IS 'Unique identifier for each option price history record.';

COMMENT ON COLUMN finance_schema.txtoptionpricehistory.contractid IS 'Option contract this history row belongs to. References mstoptioncontract.';

COMMENT ON COLUMN finance_schema.txtoptionpricehistory.tradedate IS 'The trading date for this price record.';

COMMENT ON COLUMN finance_schema.txtoptionpricehistory.optionprice IS 'Closing price (premium) of the option contract on this date.';

COMMENT ON COLUMN finance_schema.txtoptionpricehistory.openinterest IS 'Open interest at end of trading day.';

COMMENT ON COLUMN finance_schema.txtoptionpricehistory.volume IS 'Number of contracts traded during this day.';

CREATE SEQUENCE finance_schema.txtoptionpricehistory_historyid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER TABLE finance_schema.txtoptionpricehistory_historyid_seq OWNER TO finance_master;

ALTER SEQUENCE finance_schema.txtoptionpricehistory_historyid_seq OWNED BY finance_schema.txtoptionpricehistory.historyid;

ALTER TABLE ONLY finance_schema.txtoptionpricehistory ALTER COLUMN historyid SET DEFAULT nextval('finance_schema.txtoptionpricehistory_historyid_seq'::regclass);

ALTER TABLE ONLY finance_schema.txtoptionpricehistory
    ADD CONSTRAINT txtoptionpricehistory_contract_date_key UNIQUE (contractid, tradedate);

ALTER TABLE ONLY finance_schema.txtoptionpricehistory
    ADD CONSTRAINT txtoptionpricehistory_pkey PRIMARY KEY (historyid);

CREATE INDEX idx_txtoptionpricehistory_contract_date ON finance_schema.txtoptionpricehistory USING btree (contractid, tradedate DESC);

ALTER TABLE ONLY finance_schema.txtoptionpricehistory
    ADD CONSTRAINT txtoptionpricehistory_contractid_fkey FOREIGN KEY (contractid) REFERENCES finance_schema.mstoptioncontract(contractid) ON UPDATE RESTRICT ON DELETE RESTRICT;

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE finance_schema.txtoptionpricehistory TO finance_app_role;

GRANT ALL ON SEQUENCE finance_schema.txtoptionpricehistory_historyid_seq TO finance_app_role;
