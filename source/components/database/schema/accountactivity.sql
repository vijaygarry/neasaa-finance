-- Table: finance_schema.accountactivity
-- Raw trade activity log for all buy and sell activity.
-- Every downloaded or manually entered trade gets one row here.
-- Buy/Sell trades also produce a corresponding accountlot/tax lot in accountlot.

CREATE TABLE IF NOT EXISTS finance_schema.accountactivity
(
    accountid bigint NOT NULL,
    txnid character varying(55) COLLATE pg_catalog."default" NOT NULL,
    txntype character varying(55) COLLATE pg_catalog."default" NOT NULL,
    txndate date NOT NULL,
    description character varying(255) COLLATE pg_catalog."default",
    symbol character varying(25) COLLATE pg_catalog."default" NOT NULL,
    investmentid character varying(25) COLLATE pg_catalog."default" NOT NULL,
    quantity numeric(12,4) NOT NULL,
    price numeric(15,4) NOT NULL,
    fees numeric(12,4),
    commission numeric(12,4),
    accruedinterest numeric(12,4),
    totalamount numeric(15,4) NOT NULL,
    runningbalance numeric(12,2),
    settlementdate date NOT NULL,
    status character varying(25) COLLATE pg_catalog."default" NOT NULL,
    createdby integer NOT NULL,
    createddate timestamp with time zone NOT NULL,
    lastupdatedby integer NOT NULL,
    lastupdateddate timestamp with time zone NOT NULL,
    stockpriceatopen numeric(15,4),
    CONSTRAINT accountactivity_pkey PRIMARY KEY (accountid, txnid),
    CONSTRAINT accountactivity_accountid_fkey FOREIGN KEY (accountid)
        REFERENCES finance_schema.account (accountid) MATCH SIMPLE
        ON UPDATE RESTRICT
        ON DELETE RESTRICT
        NOT VALID
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS finance_schema.accountactivity
    OWNER to finance_master;

COMMENT ON TABLE finance_schema.accountactivity
    IS 'Raw buy and sell trade event log. One row per trade downloaded. This should match with account activity in bank like fidelity.';

COMMENT ON COLUMN finance_schema.accountactivity.accountid
    IS 'Account Identifier';

COMMENT ON COLUMN finance_schema.accountactivity.txnid
    IS 'Unique transaction id for an account. This will be symbol + sequence. E.g. AAPL-1 or AMZN-5. Sequence number is specific to account.';

COMMENT ON COLUMN finance_schema.accountactivity.txntype
    IS 'One of the predefine transaction type.';

COMMENT ON COLUMN finance_schema.accountactivity.txndate
    IS 'Transaction date';

COMMENT ON COLUMN finance_schema.accountactivity.description
    IS 'Free-text description from the brokerage download or user notes.';

COMMENT ON COLUMN finance_schema.accountactivity.symbol
    IS 'For option transaction this is underlying equity symbol. For non-option symbol, this will be same as investmentid.';

COMMENT ON COLUMN finance_schema.accountactivity.investmentid
    IS 'Investment id is name for equity (e.g. TSLA) or option (e.g. TSLA240119C200) or CD (46656MKD2).';

COMMENT ON COLUMN finance_schema.accountactivity.quantity
    IS 'Number of shares or contracts. Positive for buy and negative value for sell. This will be zero fir cash transaction, dividend, fees or interest.';

COMMENT ON COLUMN finance_schema.accountactivity.price
    IS 'Price per share or per contract at execution.';

COMMENT ON COLUMN finance_schema.accountactivity.fees
    IS 'Some time trading company apply some fees to maintain foreign stocks e.g. JD or NIO. Null or zero if no fees were charged.';

COMMENT ON COLUMN finance_schema.accountactivity.commission
    IS 'Commission for this transaction.  Null or zero if no commission were charged.';

COMMENT ON COLUMN finance_schema.accountactivity.totalamount
    IS 'Total trade amount including fees and commission. Negative for cash outflows (buys), positive for cash inflows (sells).';

COMMENT ON COLUMN finance_schema.accountactivity.runningbalance
    IS 'Whats running balance after this transaction for this account.';

COMMENT ON COLUMN finance_schema.accountactivity.settlementdate
    IS 'Date when this transaction is settled e.g. Option expired on Friday get settled on Monday.';

COMMENT ON COLUMN finance_schema.accountactivity.status
    IS 'PENDING - Txn uploaded to table but not yet processes i.e. not added to transaction lot and closed transaction table.
OPEN - If complete transaction is open
CLOSED - If complete transaction is CLOSED
PARTIAL_CLOSED - If partially closed the transaction
';

COMMENT ON COLUMN finance_schema.accountactivity.stockpriceatopen
    IS 'For CALL or PUT SELL transaction, this is the stock price at the time of opening CALL/PUT transaction.';
    