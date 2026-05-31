CREATE TABLE finance_schema.mstasset (
    assetid integer NOT NULL,
    symbol character varying(20) NOT NULL,
    name character varying(255) NOT NULL,
    displayname character varying(100),
    assettype character varying(20) NOT NULL,
    industry character varying(50) DEFAULT 'NOT_APPLICABLE'::character varying NOT NULL,
    market character varying(50),
    optionsupported boolean DEFAULT false NOT NULL,
    trackprice boolean DEFAULT true NOT NULL,
    createdby integer NOT NULL,
    createddate timestamp with time zone NOT NULL,
    lastupdatedby integer NOT NULL,
    lastupdateddate timestamp with time zone NOT NULL
);

ALTER TABLE finance_schema.mstasset OWNER TO finance_master;

COMMENT ON TABLE finance_schema.mstasset IS 'Master list of tradeable assets including stocks, ETFs, bonds and other instruments.';

COMMENT ON COLUMN finance_schema.mstasset.assetid IS 'Unique numeric id for the asset.';

COMMENT ON COLUMN finance_schema.mstasset.symbol IS 'Ticker symbol e.g. AAPL, SPY. Unique across all assets.';

COMMENT ON COLUMN finance_schema.mstasset.name IS 'Full legal name of the asset e.g. Apple Inc.';

COMMENT ON COLUMN finance_schema.mstasset.displayname IS 'Short display name shown in UI e.g. Apple. May differ from full legal name.';

COMMENT ON COLUMN finance_schema.mstasset.assettype IS 'Type of asset. References lkpassettype.';

COMMENT ON COLUMN finance_schema.mstasset.industry IS 'Industry classification based on GICS standard e.g. SOFTWARE, RETAIL. Set to NOT_APPLICABLE for asset types where industry does not apply e.g. BOND, INDEX, CASH. References lkpindustry.';

COMMENT ON COLUMN finance_schema.mstasset.market IS 'Market this asset is traded on e.g. us_market, nasdaq, nyse.';

COMMENT ON COLUMN finance_schema.mstasset.optionsupported IS 'True if option contracts are available for this asset.';

COMMENT ON COLUMN finance_schema.mstasset.trackprice IS 'True if price and market data should be fetched from the API for this asset. Set to false to skip price fetching while keeping the asset in the system. Default is true.';

COMMENT ON COLUMN finance_schema.mstasset.createdby IS 'User id of the user who created this record.';

COMMENT ON COLUMN finance_schema.mstasset.createddate IS 'Timestamp when this record was created.';

COMMENT ON COLUMN finance_schema.mstasset.lastupdatedby IS 'User id of the user who last updated this record.';

COMMENT ON COLUMN finance_schema.mstasset.lastupdateddate IS 'Timestamp when this record was last updated.';

CREATE SEQUENCE finance_schema.mstasset_assetid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER TABLE finance_schema.mstasset_assetid_seq OWNER TO finance_master;

ALTER SEQUENCE finance_schema.mstasset_assetid_seq OWNED BY finance_schema.mstasset.assetid;

ALTER TABLE ONLY finance_schema.mstasset ALTER COLUMN assetid SET DEFAULT nextval('finance_schema.mstasset_assetid_seq'::regclass);

ALTER TABLE ONLY finance_schema.mstasset
    ADD CONSTRAINT mstasset_pkey PRIMARY KEY (assetid);

ALTER TABLE ONLY finance_schema.mstasset
    ADD CONSTRAINT mstasset_symbol_key UNIQUE (symbol);

ALTER TABLE ONLY finance_schema.mstasset
    ADD CONSTRAINT mstasset_assettype_fkey FOREIGN KEY (assettype) REFERENCES finance_schema.lkpassettype(assettype) ON UPDATE RESTRICT ON DELETE RESTRICT;

ALTER TABLE ONLY finance_schema.mstasset
    ADD CONSTRAINT mstasset_createdby_fkey FOREIGN KEY (createdby) REFERENCES finance_schema.appuser(userid) ON UPDATE RESTRICT ON DELETE RESTRICT;

ALTER TABLE ONLY finance_schema.mstasset
    ADD CONSTRAINT mstasset_industry_fkey FOREIGN KEY (industry) REFERENCES finance_schema.lkpindustry(industry) ON UPDATE RESTRICT ON DELETE RESTRICT;

ALTER TABLE ONLY finance_schema.mstasset
    ADD CONSTRAINT mstasset_lastupdatedby_fkey FOREIGN KEY (lastupdatedby) REFERENCES finance_schema.appuser(userid) ON UPDATE RESTRICT ON DELETE RESTRICT;

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE finance_schema.mstasset TO finance_app_role;

GRANT ALL ON SEQUENCE finance_schema.mstasset_assetid_seq TO finance_app_role;
