CREATE TABLE finance_schema.mstassetprice (
    assetid integer NOT NULL,
    currentprice numeric(15,4),
    previousclose numeric(15,4),
    marketopen numeric(15,4),
    dayhigh numeric(15,4),
    daylow numeric(15,4),
    marketchange numeric(15,4),
    marketchangepercent numeric(10,4),
    volume bigint,
    markettime timestamp with time zone,
    bid numeric(15,4),
    ask numeric(15,4),
    bidsize integer,
    asksize integer,
    premarketprice numeric(15,4),
    premarketchange numeric(15,4),
    premarketchangepercent numeric(10,4),
    week52high numeric(15,4),
    week52low numeric(15,4),
    fiftydayaverage numeric(15,4),
    fiftydayaveragechange numeric(15,4),
    twohundreddayaverage numeric(15,4),
    twohundreddayaveragechange numeric(15,4),
    avgdailyvolume3month bigint,
    avgdailyvolume10day bigint,
    marketcap numeric(20,4),
    dividendyield numeric(10,4),
    lastupdateddate timestamp with time zone NOT NULL
);

ALTER TABLE finance_schema.mstassetprice OWNER TO finance_master;

COMMENT ON TABLE finance_schema.mstassetprice IS 'Current price snapshot for each asset. One row per asset, overwritten on each price refresh. Updated frequently during market hours.';

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

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE finance_schema.mstassetprice TO finance_app_role;
