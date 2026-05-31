CREATE TABLE finance_schema.mstassetfundamentals (
    assetid integer NOT NULL,
    pettm numeric(10,4),
    peftm numeric(10,4),
    epsttm numeric(10,4),
    epsforward numeric(10,4),
    epscurrentyear numeric(10,4),
    priceepscurrentyear numeric(10,4),
    dividendrate numeric(10,4),
    dividendexdate date,
    dividendpaydate date,
    nextearningsdate date,
    earningsstartdate date,
    earningsenddate date,
    averageanalystrating numeric(4,2),
    analystratinglevel character varying(20),
    oneyearpricetarget numeric(15,4),
    pricetargetupdateddate date,
    lastupdateddate timestamp with time zone NOT NULL
);

ALTER TABLE finance_schema.mstassetfundamentals OWNER TO finance_master;

COMMENT ON TABLE finance_schema.mstassetfundamentals IS 'Quarterly-updated fundamental data per asset. Kept separate from mstassetprice to avoid high-frequency price updates locking this data.';

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

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE finance_schema.mstassetfundamentals TO finance_app_role;
