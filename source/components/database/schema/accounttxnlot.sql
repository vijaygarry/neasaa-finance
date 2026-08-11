-- Table: finance_schema.accounttxnlot
-- One row per buy lot. One account activity can be split into multiple lots if it is partially sold. 
-- Each lot will have a status like OPEN or CLOSED.

CREATE TABLE IF NOT EXISTS finance_schema.accounttxnlot
(
    accountid bigint NOT NULL,
    txnid character varying(55) COLLATE pg_catalog."default" NOT NULL,
    lotid integer NOT NULL,
    quantity numeric(12,4) NOT NULL,
    fees numeric(12,4),
    commission numeric(12,4),
    accruedinterest numeric(12,4),
    totalamount numeric(15,4) NOT NULL,
    status character varying(25) COLLATE pg_catalog."default" NOT NULL,
    coveredtxnids character varying(255) COLLATE pg_catalog."default",
    createdby integer NOT NULL,
    createddate timestamp with time zone NOT NULL,
    lastupdatedby integer NOT NULL,
    lastupdateddate timestamp with time zone NOT NULL,
    CONSTRAINT accounttxnlot_pkey PRIMARY KEY (accountid, txnid, lotid),
    CONSTRAINT accounttxnlot_accountid_txnid_fkey FOREIGN KEY (accountid, txnid)
        REFERENCES finance_schema.accountactivity (accountid, txnid) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS finance_schema.accounttxnlot
    OWNER to finance_master;

COMMENT ON COLUMN finance_schema.accounttxnlot.lotid
    IS 'One transaction (activity) can have multiple (tax) lot.
Transaction in fedelity
1 Buy 10 NVDA on 1/1/2023 - One transaction in Fidelity
2 Sell 2 NVDA on 2/1/2023 - Sell partial shares from previous transaction
3 Sell 8 NVDA on 3/1/2023 - Sell remaining from transaction 1
This translate to below
    Txn-1 LOT-1 Buy 2 NVDA on 1/1/2023
    Txn-1 LOT-2 Buy 8 NVDA on 1/1/2023
    Txn-2 LOT-1 Sell 2 NVDA on 2/1/2023 - This transaction will close Txn-1;LOT-1
    Txn-3 LOT-1 Sell 8 NVDA on 3/1/2023 - This transaction will close Txn-1;LOT-2';

COMMENT ON COLUMN finance_schema.accounttxnlot.status
    IS 'Lot status. OPEN: no shares sold yet. CLOSED: all shares in this lot have been sold. LOT will be either OPEN or CLOSED. PARTIAL_CLOSE not applicable for lot.';

COMMENT ON COLUMN finance_schema.accounttxnlot.coveredtxnids
    IS 'In case of this equity transaction, covered options are used, this will hold the comma separated list of Open (Sell) Covered call Ids.
If this transaction endup buying equity because of PUT exercise, first coveredtxnids is always PUT txn id.';
