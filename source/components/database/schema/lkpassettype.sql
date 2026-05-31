CREATE TABLE finance_schema.lkpassettype (
    assettype character varying(20) NOT NULL,
    description character varying(255) NOT NULL,
    enable boolean DEFAULT true NOT NULL,
    createdby integer NOT NULL,
    createddate timestamp with time zone NOT NULL,
    lastupdatedby integer NOT NULL,
    lastupdateddate timestamp with time zone NOT NULL
);

ALTER TABLE finance_schema.lkpassettype OWNER TO finance_master;

COMMENT ON TABLE finance_schema.lkpassettype IS 'Lookup table of valid asset types. Add new types here before using them in mstasset.';

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

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE finance_schema.lkpassettype TO finance_app_role;
