SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;


-- ------------------------------------------------------------
-- lkpassettype
-- Lookup table for asset types. Referenced by mstasset.assettype.
-- ------------------------------------------------------------
CREATE TABLE finance_schema.lkpassettype (
    assettype           character varying(20)       NOT NULL,
    description         character varying(255)      NOT NULL,
    enable              boolean                     NOT NULL DEFAULT true,
    createdby           integer                     NOT NULL,
    createddate         timestamp with time zone    NOT NULL,
    lastupdatedby       integer                     NOT NULL,
    lastupdateddate     timestamp with time zone    NOT NULL
);

ALTER TABLE finance_schema.lkpassettype OWNER TO finance_master;

COMMENT ON TABLE  finance_schema.lkpassettype IS 'Lookup table of valid asset types. Add new types here before using them in mstasset.';
COMMENT ON COLUMN finance_schema.lkpassettype.assettype IS 'Unique code for the asset type e.g. STOCK, ETF, BOND.';
COMMENT ON COLUMN finance_schema.lkpassettype.description IS 'Human readable description of the asset type.';
COMMENT ON COLUMN finance_schema.lkpassettype.enable IS 'False disables this asset type — it will not be available for new assets.';
COMMENT ON COLUMN finance_schema.lkpassettype.createdby IS 'User id of the user who created this record.';
COMMENT ON COLUMN finance_schema.lkpassettype.createddate IS 'Timestamp when this record was created.';
COMMENT ON COLUMN finance_schema.lkpassettype.lastupdatedby IS 'User id of the user who last updated this record.';
COMMENT ON COLUMN finance_schema.lkpassettype.lastupdateddate IS 'Timestamp when this record was last updated.';

ALTER TABLE ONLY finance_schema.lkpassettype
    ADD CONSTRAINT lkpassettype_pkey PRIMARY KEY (assettype);
ALTER TABLE ONLY finance_schema.lkpassettype
    ADD CONSTRAINT lkpassettype_createdby_fkey FOREIGN KEY (createdby) REFERENCES finance_schema.appuser(userid) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY finance_schema.lkpassettype
    ADD CONSTRAINT lkpassettype_lastupdatedby_fkey FOREIGN KEY (lastupdatedby) REFERENCES finance_schema.appuser(userid) ON UPDATE RESTRICT ON DELETE RESTRICT;


-- ------------------------------------------------------------
-- lkpindustry
-- Lookup table for asset industries. Based on GICS standard.
-- Referenced by mstasset.industry.
-- ------------------------------------------------------------
CREATE TABLE finance_schema.lkpindustry (
    industry            character varying(50)       NOT NULL,
    description         character varying(255)      NOT NULL,
    enable              boolean                     NOT NULL DEFAULT true,
    createdby           integer                     NOT NULL,
    createddate         timestamp with time zone    NOT NULL,
    lastupdatedby       integer                     NOT NULL,
    lastupdateddate     timestamp with time zone    NOT NULL
);

ALTER TABLE finance_schema.lkpindustry OWNER TO finance_master;

COMMENT ON TABLE  finance_schema.lkpindustry IS 'Lookup table of industries based on GICS (Global Industry Classification Standard). Not all asset types have an industry — bonds, indices and cash leave this null.';
COMMENT ON COLUMN finance_schema.lkpindustry.industry IS 'Unique industry code e.g. SOFTWARE, RETAIL, PHARMACEUTICALS.';
COMMENT ON COLUMN finance_schema.lkpindustry.description IS 'Human readable description of the industry.';
COMMENT ON COLUMN finance_schema.lkpindustry.enable IS 'False disables this industry — it will not be available for new assets.';
COMMENT ON COLUMN finance_schema.lkpindustry.createdby IS 'User id of the user who created this record.';
COMMENT ON COLUMN finance_schema.lkpindustry.createddate IS 'Timestamp when this record was created.';
COMMENT ON COLUMN finance_schema.lkpindustry.lastupdatedby IS 'User id of the user who last updated this record.';
COMMENT ON COLUMN finance_schema.lkpindustry.lastupdateddate IS 'Timestamp when this record was last updated.';

ALTER TABLE ONLY finance_schema.lkpindustry
    ADD CONSTRAINT lkpindustry_pkey PRIMARY KEY (industry);
ALTER TABLE ONLY finance_schema.lkpindustry
    ADD CONSTRAINT lkpindustry_createdby_fkey FOREIGN KEY (createdby) REFERENCES finance_schema.appuser(userid) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY finance_schema.lkpindustry
    ADD CONSTRAINT lkpindustry_lastupdatedby_fkey FOREIGN KEY (lastupdatedby) REFERENCES finance_schema.appuser(userid) ON UPDATE RESTRICT ON DELETE RESTRICT;


-- ------------------------------------------------------------
-- mstasset
-- Master table for all tradeable assets (stocks, ETFs, bonds).
-- ------------------------------------------------------------
CREATE TABLE finance_schema.mstasset (
    assetid             integer                     NOT NULL,
    symbol              character varying(20)       NOT NULL,
    name                character varying(255)      NOT NULL,
    displayname         character varying(100),
    assettype           character varying(20)       NOT NULL,
    industry            character varying(50)       NOT NULL DEFAULT 'NOT_APPLICABLE',
    market              character varying(50),
    optionsupported     boolean                     NOT NULL DEFAULT false,
    trackprice          boolean                     NOT NULL DEFAULT true,
    createdby           integer                     NOT NULL,
    createddate         timestamp with time zone    NOT NULL,
    lastupdatedby       integer                     NOT NULL,
    lastupdateddate     timestamp with time zone    NOT NULL
);

ALTER TABLE finance_schema.mstasset OWNER TO finance_master;

COMMENT ON TABLE  finance_schema.mstasset IS 'Master list of tradeable assets including stocks, ETFs, bonds and other instruments.';
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
    ADD CONSTRAINT mstasset_industry_fkey FOREIGN KEY (industry) REFERENCES finance_schema.lkpindustry(industry) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY finance_schema.mstasset
    ADD CONSTRAINT mstasset_createdby_fkey FOREIGN KEY (createdby) REFERENCES finance_schema.appuser(userid) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY finance_schema.mstasset
    ADD CONSTRAINT mstasset_lastupdatedby_fkey FOREIGN KEY (lastupdatedby) REFERENCES finance_schema.appuser(userid) ON UPDATE RESTRICT ON DELETE RESTRICT;


-- ------------------------------------------------------------
-- mstassetprice
-- Current price snapshot for each asset. One row per asset.
-- Updated frequently — every price tick or end of day.
-- ------------------------------------------------------------
CREATE TABLE finance_schema.mstassetprice (
    assetid                     integer                     NOT NULL,
    currentprice                numeric(15,4),
    previousclose               numeric(15,4),
    marketopen                  numeric(15,4),
    dayhigh                     numeric(15,4),
    daylow                      numeric(15,4),
    marketchange                numeric(15,4),
    marketchangepercent         numeric(10,4),
    volume                      bigint,
    markettime                  timestamp with time zone,
    bid                         numeric(15,4),
    ask                         numeric(15,4),
    bidsize                     integer,
    asksize                     integer,
    premarketprice              numeric(15,4),
    premarketchange             numeric(15,4),
    premarketchangepercent      numeric(10,4),
    week52high                  numeric(15,4),
    week52low                   numeric(15,4),
    fiftydayaverage             numeric(15,4),
    fiftydayaveragechange       numeric(15,4),
    twohundreddayaverage        numeric(15,4),
    twohundreddayaveragechange  numeric(15,4),
    avgdailyvolume3month        bigint,
    avgdailyvolume10day         bigint,
    marketcap                   numeric(20,4),
    dividendyield               numeric(10,4),
    lastupdateddate             timestamp with time zone    NOT NULL
);

ALTER TABLE finance_schema.mstassetprice OWNER TO finance_master;

COMMENT ON TABLE  finance_schema.mstassetprice IS 'Current price snapshot for each asset. One row per asset, overwritten on each price refresh. Updated frequently during market hours.';
COMMENT ON COLUMN finance_schema.mstassetprice.assetid IS 'Asset this price row belongs to. References mstasset.';
COMMENT ON COLUMN finance_schema.mstassetprice.currentprice IS 'Latest traded price (regularMarketPrice).';
COMMENT ON COLUMN finance_schema.mstassetprice.previousclose IS 'Closing price from the previous trading day.';
COMMENT ON COLUMN finance_schema.mstassetprice.marketopen IS 'Opening price at market open for the current trading day.';
COMMENT ON COLUMN finance_schema.mstassetprice.dayhigh IS 'Highest price traded during the current trading day.';
COMMENT ON COLUMN finance_schema.mstassetprice.daylow IS 'Lowest price traded during the current trading day.';
COMMENT ON COLUMN finance_schema.mstassetprice.marketchange IS 'Price change from previous close to current price.';
COMMENT ON COLUMN finance_schema.mstassetprice.marketchangepercent IS 'Percentage price change from previous close to current price.';
COMMENT ON COLUMN finance_schema.mstassetprice.volume IS 'Total number of shares traded during the current session.';
COMMENT ON COLUMN finance_schema.mstassetprice.markettime IS 'Timestamp of the latest market price update from the data feed.';
COMMENT ON COLUMN finance_schema.mstassetprice.bid IS 'Current highest buy price quoted by market makers.';
COMMENT ON COLUMN finance_schema.mstassetprice.ask IS 'Current lowest sell price quoted by market makers.';
COMMENT ON COLUMN finance_schema.mstassetprice.bidsize IS 'Number of shares available at the current bid price (in lots of 100).';
COMMENT ON COLUMN finance_schema.mstassetprice.asksize IS 'Number of shares available at the current ask price (in lots of 100).';
COMMENT ON COLUMN finance_schema.mstassetprice.premarketprice IS 'Price in pre-market trading session.';
COMMENT ON COLUMN finance_schema.mstassetprice.premarketchange IS 'Price change during pre-market session.';
COMMENT ON COLUMN finance_schema.mstassetprice.premarketchangepercent IS 'Percentage price change during pre-market session.';
COMMENT ON COLUMN finance_schema.mstassetprice.week52high IS 'Highest price over the trailing 52 weeks.';
COMMENT ON COLUMN finance_schema.mstassetprice.week52low IS 'Lowest price over the trailing 52 weeks.';
COMMENT ON COLUMN finance_schema.mstassetprice.fiftydayaverage IS '50-day moving average price.';
COMMENT ON COLUMN finance_schema.mstassetprice.fiftydayaveragechange IS 'Difference between current price and 50-day moving average.';
COMMENT ON COLUMN finance_schema.mstassetprice.twohundreddayaverage IS '200-day moving average price.';
COMMENT ON COLUMN finance_schema.mstassetprice.twohundreddayaveragechange IS 'Difference between current price and 200-day moving average.';
COMMENT ON COLUMN finance_schema.mstassetprice.avgdailyvolume3month IS 'Average daily trading volume over the trailing 3 months.';
COMMENT ON COLUMN finance_schema.mstassetprice.avgdailyvolume10day IS 'Average daily trading volume over the trailing 10 days.';
COMMENT ON COLUMN finance_schema.mstassetprice.marketcap IS 'Total market capitalisation (currentprice x shares outstanding). Updated with each price refresh.';
COMMENT ON COLUMN finance_schema.mstassetprice.dividendyield IS 'Dividend yield as a percentage (dividendrate / currentprice). Updated with each price refresh.';
COMMENT ON COLUMN finance_schema.mstassetprice.lastupdateddate IS 'Timestamp when this price row was last refreshed.';

ALTER TABLE ONLY finance_schema.mstassetprice
    ADD CONSTRAINT mstassetprice_pkey PRIMARY KEY (assetid);
ALTER TABLE ONLY finance_schema.mstassetprice
    ADD CONSTRAINT mstassetprice_assetid_fkey FOREIGN KEY (assetid) REFERENCES finance_schema.mstasset(assetid) ON UPDATE RESTRICT ON DELETE RESTRICT;


-- ------------------------------------------------------------
-- mstassetfundamentals
-- Quarterly-updated fundamental data per asset. One row per asset.
-- Updated on earnings releases, dividend announcements, etc.
-- ------------------------------------------------------------
CREATE TABLE finance_schema.mstassetfundamentals (
    assetid                 integer                     NOT NULL,
    pettm                   numeric(10,4),
    peftm                   numeric(10,4),
    epsttm                  numeric(10,4),
    epsforward              numeric(10,4),
    epscurrentyear          numeric(10,4),
    priceepscurrentyear     numeric(10,4),
    dividendrate            numeric(10,4),
    dividendexdate          date,
    dividendpaydate         date,
    nextearningsdate        date,
    earningsstartdate       date,
    earningsenddate         date,
    averageanalystrating    numeric(4,2),
    analystratinglevel      character varying(20),
    oneyearpricetarget      numeric(15,4),
    pricetargetupdateddate  date,
    lastupdateddate         timestamp with time zone    NOT NULL
);

ALTER TABLE finance_schema.mstassetfundamentals OWNER TO finance_master;

COMMENT ON TABLE  finance_schema.mstassetfundamentals IS 'Quarterly-updated fundamental data per asset. Kept separate from mstassetprice to avoid high-frequency price updates locking this data.';
COMMENT ON COLUMN finance_schema.mstassetfundamentals.assetid IS 'Asset this fundamentals row belongs to. References mstasset.';
COMMENT ON COLUMN finance_schema.mstassetfundamentals.pettm IS 'Price to Earnings ratio based on trailing twelve months earnings (trailingPE).';
COMMENT ON COLUMN finance_schema.mstassetfundamentals.peftm IS 'Price to Earnings ratio based on forward twelve months estimated earnings (forwardPE).';
COMMENT ON COLUMN finance_schema.mstassetfundamentals.epsttm IS 'Earnings Per Share over the trailing twelve months (epsTrailingTwelveMonths).';
COMMENT ON COLUMN finance_schema.mstassetfundamentals.epsforward IS 'Forward Earnings Per Share estimate for the next twelve months.';
COMMENT ON COLUMN finance_schema.mstassetfundamentals.epscurrentyear IS 'Earnings Per Share estimate for the current fiscal year.';
COMMENT ON COLUMN finance_schema.mstassetfundamentals.priceepscurrentyear IS 'Price to current year EPS ratio (priceEpsCurrentYear).';
COMMENT ON COLUMN finance_schema.mstassetfundamentals.dividendrate IS 'Annual dividend amount per share in dollars (dividendRate).';
COMMENT ON COLUMN finance_schema.mstassetfundamentals.dividendexdate IS 'Ex-dividend date. Investor must own shares before this date to receive the dividend.';
COMMENT ON COLUMN finance_schema.mstassetfundamentals.dividendpaydate IS 'Date on which the dividend is paid to shareholders (dividendDate).';
COMMENT ON COLUMN finance_schema.mstassetfundamentals.nextearningsdate IS 'Scheduled date of next earnings announcement (earningsTimestamp).';
COMMENT ON COLUMN finance_schema.mstassetfundamentals.earningsstartdate IS 'Start of the earnings announcement window (earningsTimestampStart).';
COMMENT ON COLUMN finance_schema.mstassetfundamentals.earningsenddate IS 'End of the earnings announcement window (earningsTimestampEnd).';
COMMENT ON COLUMN finance_schema.mstassetfundamentals.averageanalystrating IS 'Numeric average analyst rating. 1.0 = Strong Buy, 5.0 = Strong Sell.';
COMMENT ON COLUMN finance_schema.mstassetfundamentals.analystratinglevel IS 'Text label for analyst consensus e.g. Strong Buy, Buy, Hold, Sell.';
COMMENT ON COLUMN finance_schema.mstassetfundamentals.oneyearpricetarget IS 'Consensus 12-month price target from analyst coverage.';
COMMENT ON COLUMN finance_schema.mstassetfundamentals.pricetargetupdateddate IS 'Date when the analyst price target was last revised.';
COMMENT ON COLUMN finance_schema.mstassetfundamentals.lastupdateddate IS 'Timestamp when this fundamentals row was last updated.';

ALTER TABLE ONLY finance_schema.mstassetfundamentals
    ADD CONSTRAINT mstassetfundamentals_pkey PRIMARY KEY (assetid);
ALTER TABLE ONLY finance_schema.mstassetfundamentals
    ADD CONSTRAINT mstassetfundamentals_assetid_fkey FOREIGN KEY (assetid) REFERENCES finance_schema.mstasset(assetid) ON UPDATE RESTRICT ON DELETE RESTRICT;


-- ------------------------------------------------------------
-- txtpricehistory
-- Daily OHLCV price history per asset. Append-only.
-- ------------------------------------------------------------
CREATE TABLE finance_schema.txtpricehistory (
    historyid           bigint                      NOT NULL,
    assetid             integer                     NOT NULL,
    tradedate           date                        NOT NULL,
    openprice           numeric(15,4)               NOT NULL,
    closeprice          numeric(15,4)               NOT NULL,
    highprice           numeric(15,4)               NOT NULL,
    lowprice            numeric(15,4)               NOT NULL,
    volume              bigint
);

ALTER TABLE finance_schema.txtpricehistory OWNER TO finance_master;

COMMENT ON TABLE  finance_schema.txtpricehistory IS 'Daily OHLCV (open, high, low, close, volume) price history per asset. One row per asset per trading day.';
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
    ADD CONSTRAINT txtpricehistory_pkey PRIMARY KEY (historyid);
ALTER TABLE ONLY finance_schema.txtpricehistory
    ADD CONSTRAINT txtpricehistory_asset_date_key UNIQUE (assetid, tradedate);
ALTER TABLE ONLY finance_schema.txtpricehistory
    ADD CONSTRAINT txtpricehistory_assetid_fkey FOREIGN KEY (assetid) REFERENCES finance_schema.mstasset(assetid) ON UPDATE RESTRICT ON DELETE RESTRICT;

CREATE INDEX idx_txtpricehistory_asset_date ON finance_schema.txtpricehistory(assetid, tradedate DESC);


-- ------------------------------------------------------------
-- mstoptioncontract
-- Option contract definitions (calls and puts) for supported assets.
-- Contains only static contract data. Never updated after creation.
-- ------------------------------------------------------------
CREATE TABLE finance_schema.mstoptioncontract (
    contractid          bigint                      NOT NULL,
    underlyingassetid   integer                     NOT NULL,
    optiontype          character varying(4)        NOT NULL,
    strikeprice         numeric(15,4)               NOT NULL,
    expirydate          date                        NOT NULL,
    frequency           character varying(10)       NOT NULL,
    lotsize             integer                     NOT NULL DEFAULT 100,
    optionsymbol        character varying(21)       NOT NULL,
    createdby           integer                     NOT NULL,
    createddate         timestamp with time zone    NOT NULL,
    CONSTRAINT mstoptioncontract_optiontype_check CHECK (optiontype IN ('CALL', 'PUT')),
    CONSTRAINT mstoptioncontract_frequency_check CHECK (frequency IN ('WEEKLY', 'MONTHLY'))
);

ALTER TABLE finance_schema.mstoptioncontract OWNER TO finance_master;

COMMENT ON TABLE  finance_schema.mstoptioncontract IS 'Option contract definitions (calls and puts) for assets where optionsupported is true. Static data only — price data is in mstoptionprice and txtoptionpricehistory.';
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
    ADD CONSTRAINT mstoptioncontract_pkey PRIMARY KEY (contractid);
ALTER TABLE ONLY finance_schema.mstoptioncontract
    ADD CONSTRAINT mstoptioncontract_unique_key UNIQUE (underlyingassetid, optiontype, strikeprice, expirydate);
ALTER TABLE ONLY finance_schema.mstoptioncontract
    ADD CONSTRAINT mstoptioncontract_optionsymbol_key UNIQUE (optionsymbol);
ALTER TABLE ONLY finance_schema.mstoptioncontract
    ADD CONSTRAINT mstoptioncontract_assetid_fkey FOREIGN KEY (underlyingassetid) REFERENCES finance_schema.mstasset(assetid) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY finance_schema.mstoptioncontract
    ADD CONSTRAINT mstoptioncontract_createdby_fkey FOREIGN KEY (createdby) REFERENCES finance_schema.appuser(userid) ON UPDATE RESTRICT ON DELETE RESTRICT;

CREATE INDEX idx_mstoptioncontract_asset_expiry ON finance_schema.mstoptioncontract(underlyingassetid, expirydate);
CREATE INDEX idx_mstoptioncontract_chain         ON finance_schema.mstoptioncontract(underlyingassetid, optiontype, strikeprice);


-- ------------------------------------------------------------
-- mstoptionprice
-- Current price snapshot for each option contract. One row per
-- contract, overwritten on each price refresh.
-- ------------------------------------------------------------
CREATE TABLE finance_schema.mstoptionprice (
    contractid          bigint                      NOT NULL,
    optionprice         numeric(15,4),
    openinterest        integer,
    volume              integer,
    lastupdateddate     timestamp with time zone    NOT NULL
);

ALTER TABLE finance_schema.mstoptionprice OWNER TO finance_master;

COMMENT ON TABLE  finance_schema.mstoptionprice IS 'Current price snapshot for each option contract. One row per contract, overwritten on each price refresh.';
COMMENT ON COLUMN finance_schema.mstoptionprice.contractid IS 'Option contract this price row belongs to. References mstoptioncontract.';
COMMENT ON COLUMN finance_schema.mstoptionprice.optionprice IS 'Current market price (premium) of the option contract.';
COMMENT ON COLUMN finance_schema.mstoptionprice.openinterest IS 'Total number of outstanding open contracts.';
COMMENT ON COLUMN finance_schema.mstoptionprice.volume IS 'Number of contracts traded during the current session.';
COMMENT ON COLUMN finance_schema.mstoptionprice.lastupdateddate IS 'Timestamp when this price row was last refreshed.';

ALTER TABLE ONLY finance_schema.mstoptionprice
    ADD CONSTRAINT mstoptionprice_pkey PRIMARY KEY (contractid);
ALTER TABLE ONLY finance_schema.mstoptionprice
    ADD CONSTRAINT mstoptionprice_contractid_fkey FOREIGN KEY (contractid) REFERENCES finance_schema.mstoptioncontract(contractid) ON UPDATE RESTRICT ON DELETE RESTRICT;


-- ------------------------------------------------------------
-- txtoptionpricehistory
-- Daily price history per option contract. Append-only.
-- ------------------------------------------------------------
CREATE TABLE finance_schema.txtoptionpricehistory (
    historyid           bigint                      NOT NULL,
    contractid          bigint                      NOT NULL,
    tradedate           date                        NOT NULL,
    optionprice         numeric(15,4)               NOT NULL,
    openinterest        integer,
    volume              integer
);

ALTER TABLE finance_schema.txtoptionpricehistory OWNER TO finance_master;

COMMENT ON TABLE  finance_schema.txtoptionpricehistory IS 'Daily price history per option contract. One row per contract per trading day. Append-only.';
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
    ADD CONSTRAINT txtoptionpricehistory_pkey PRIMARY KEY (historyid);
ALTER TABLE ONLY finance_schema.txtoptionpricehistory
    ADD CONSTRAINT txtoptionpricehistory_contract_date_key UNIQUE (contractid, tradedate);
ALTER TABLE ONLY finance_schema.txtoptionpricehistory
    ADD CONSTRAINT txtoptionpricehistory_contractid_fkey FOREIGN KEY (contractid) REFERENCES finance_schema.mstoptioncontract(contractid) ON UPDATE RESTRICT ON DELETE RESTRICT;

CREATE INDEX idx_txtoptionpricehistory_contract_date ON finance_schema.txtoptionpricehistory(contractid, tradedate DESC);


-- ------------------------------------------------------------
-- Grants
-- ------------------------------------------------------------
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE finance_schema.lkpassettype              TO finance_app_role;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE finance_schema.lkpindustry               TO finance_app_role;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE finance_schema.mstasset                  TO finance_app_role;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE finance_schema.mstassetprice             TO finance_app_role;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE finance_schema.mstassetfundamentals      TO finance_app_role;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE finance_schema.txtpricehistory           TO finance_app_role;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE finance_schema.mstoptioncontract         TO finance_app_role;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE finance_schema.mstoptionprice            TO finance_app_role;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE finance_schema.txtoptionpricehistory     TO finance_app_role;

GRANT ALL ON SEQUENCE finance_schema.mstasset_assetid_seq                      TO finance_app_role;
GRANT ALL ON SEQUENCE finance_schema.txtpricehistory_historyid_seq             TO finance_app_role;
GRANT ALL ON SEQUENCE finance_schema.mstoptioncontract_contractid_seq          TO finance_app_role;
GRANT ALL ON SEQUENCE finance_schema.txtoptionpricehistory_historyid_seq       TO finance_app_role;
