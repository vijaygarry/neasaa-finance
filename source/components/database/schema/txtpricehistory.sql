CREATE TABLE finance_schema.txtpricehistory (
    historyid bigint NOT NULL,
    assetid integer NOT NULL,
    tradedate date NOT NULL,
    openprice numeric(15,4) NOT NULL,
    closeprice numeric(15,4) NOT NULL,
    highprice numeric(15,4) NOT NULL,
    lowprice numeric(15,4) NOT NULL,
    volume bigint
);

ALTER TABLE finance_schema.txtpricehistory OWNER TO finance_master;

COMMENT ON TABLE finance_schema.txtpricehistory IS 'Daily OHLCV (open, high, low, close, volume) price history per asset. One row per asset per trading day.';

COMMENT ON COLUMN finance_schema.txtpricehistory.historyid IS 'Unique identifier for each price history record.';

COMMENT ON COLUMN finance_schema.txtpricehistory.assetid IS 'Asset this history row belongs to. References mstasset.';

COMMENT ON COLUMN finance_schema.txtpricehistory.tradedate IS 'The trading date for this price record.';

COMMENT ON COLUMN finance_schema.txtpricehistory.openprice IS 'Opening price at market open.';

COMMENT ON COLUMN finance_schema.txtpricehistory.closeprice IS 'Closing price at market close.';

COMMENT ON COLUMN finance_schema.txtpricehistory.highprice IS 'Highest price traded during the day.';

COMMENT ON COLUMN finance_schema.txtpricehistory.lowprice IS 'Lowest price traded during the day.';

COMMENT ON COLUMN finance_schema.txtpricehistory.volume IS 'Total number of shares traded during the day.';

CREATE SEQUENCE finance_schema.txtpricehistory_historyid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER TABLE finance_schema.txtpricehistory_historyid_seq OWNER TO finance_master;

ALTER SEQUENCE finance_schema.txtpricehistory_historyid_seq OWNED BY finance_schema.txtpricehistory.historyid;

ALTER TABLE ONLY finance_schema.txtpricehistory ALTER COLUMN historyid SET DEFAULT nextval('finance_schema.txtpricehistory_historyid_seq'::regclass);

ALTER TABLE ONLY finance_schema.txtpricehistory
    ADD CONSTRAINT txtpricehistory_asset_date_key UNIQUE (assetid, tradedate);

ALTER TABLE ONLY finance_schema.txtpricehistory
    ADD CONSTRAINT txtpricehistory_pkey PRIMARY KEY (historyid);

CREATE INDEX idx_txtpricehistory_asset_date ON finance_schema.txtpricehistory USING btree (assetid, tradedate DESC);

ALTER TABLE ONLY finance_schema.txtpricehistory
    ADD CONSTRAINT txtpricehistory_assetid_fkey FOREIGN KEY (assetid) REFERENCES finance_schema.mstasset(assetid) ON UPDATE RESTRICT ON DELETE RESTRICT;

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE finance_schema.txtpricehistory TO finance_app_role;

GRANT ALL ON SEQUENCE finance_schema.txtpricehistory_historyid_seq TO finance_app_role;
