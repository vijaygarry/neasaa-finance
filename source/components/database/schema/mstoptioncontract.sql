CREATE TABLE finance_schema.mstoptioncontract (
    contractid bigint NOT NULL,
    underlyingassetid integer NOT NULL,
    optiontype character varying(4) NOT NULL,
    strikeprice numeric(15,4) NOT NULL,
    expirydate date NOT NULL,
    frequency character varying(10) NOT NULL,
    lotsize integer DEFAULT 100 NOT NULL,
    optionsymbol character varying(21) NOT NULL,
    createdby integer NOT NULL,
    createddate timestamp with time zone NOT NULL,
    CONSTRAINT mstoptioncontract_frequency_check CHECK (((frequency)::text = ANY ((ARRAY['WEEKLY'::character varying, 'MONTHLY'::character varying])::text[]))),
    CONSTRAINT mstoptioncontract_optiontype_check CHECK (((optiontype)::text = ANY ((ARRAY['CALL'::character varying, 'PUT'::character varying])::text[])))
);

ALTER TABLE finance_schema.mstoptioncontract OWNER TO finance_master;

COMMENT ON TABLE finance_schema.mstoptioncontract IS 'Option contract definitions (calls and puts) for assets where optionsupported is true. Static data only — price data is in mstoptionprice and txtoptionpricehistory.';

COMMENT ON COLUMN finance_schema.mstoptioncontract.contractid IS 'Unique identifier for each option contract.';

COMMENT ON COLUMN finance_schema.mstoptioncontract.underlyingassetid IS 'The asset this option is written on. References mstasset.';

COMMENT ON COLUMN finance_schema.mstoptioncontract.optiontype IS 'Type of option contract. Allowed values: CALL, PUT.';

COMMENT ON COLUMN finance_schema.mstoptioncontract.strikeprice IS 'The price at which the option can be exercised.';

COMMENT ON COLUMN finance_schema.mstoptioncontract.expirydate IS 'Date on which the option contract expires.';

COMMENT ON COLUMN finance_schema.mstoptioncontract.frequency IS 'Expiry cycle of the option. Allowed values: WEEKLY, MONTHLY.';

COMMENT ON COLUMN finance_schema.mstoptioncontract.lotsize IS 'Number of shares per contract. Industry standard is 100.';

COMMENT ON COLUMN finance_schema.mstoptioncontract.optionsymbol IS 'OCC standard option symbol as returned by the data feed API. e.g. TSLA230804C00020000. Format: symbol + YYMMDD + C/P + strike x 1000 zero-padded to 8 digits.';

COMMENT ON COLUMN finance_schema.mstoptioncontract.createdby IS 'User id of the user who created this record.';

COMMENT ON COLUMN finance_schema.mstoptioncontract.createddate IS 'Timestamp when this contract was first loaded.';

CREATE SEQUENCE finance_schema.mstoptioncontract_contractid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER TABLE finance_schema.mstoptioncontract_contractid_seq OWNER TO finance_master;

ALTER SEQUENCE finance_schema.mstoptioncontract_contractid_seq OWNED BY finance_schema.mstoptioncontract.contractid;

ALTER TABLE ONLY finance_schema.mstoptioncontract ALTER COLUMN contractid SET DEFAULT nextval('finance_schema.mstoptioncontract_contractid_seq'::regclass);

ALTER TABLE ONLY finance_schema.mstoptioncontract
    ADD CONSTRAINT mstoptioncontract_optionsymbol_key UNIQUE (optionsymbol);

ALTER TABLE ONLY finance_schema.mstoptioncontract
    ADD CONSTRAINT mstoptioncontract_pkey PRIMARY KEY (contractid);

ALTER TABLE ONLY finance_schema.mstoptioncontract
    ADD CONSTRAINT mstoptioncontract_unique_key UNIQUE (underlyingassetid, optiontype, strikeprice, expirydate);

CREATE INDEX idx_mstoptioncontract_asset_expiry ON finance_schema.mstoptioncontract USING btree (underlyingassetid, expirydate);

CREATE INDEX idx_mstoptioncontract_chain ON finance_schema.mstoptioncontract USING btree (underlyingassetid, optiontype, strikeprice);

ALTER TABLE ONLY finance_schema.mstoptioncontract
    ADD CONSTRAINT mstoptioncontract_assetid_fkey FOREIGN KEY (underlyingassetid) REFERENCES finance_schema.mstasset(assetid) ON UPDATE RESTRICT ON DELETE RESTRICT;

ALTER TABLE ONLY finance_schema.mstoptioncontract
    ADD CONSTRAINT mstoptioncontract_createdby_fkey FOREIGN KEY (createdby) REFERENCES finance_schema.appuser(userid) ON UPDATE RESTRICT ON DELETE RESTRICT;

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE finance_schema.mstoptioncontract TO finance_app_role;

GRANT ALL ON SEQUENCE finance_schema.mstoptioncontract_contractid_seq TO finance_app_role;
