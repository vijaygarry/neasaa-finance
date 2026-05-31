CREATE TABLE finance_schema.lkpindustry (
    industry character varying(50) NOT NULL,
    description character varying(255) NOT NULL,
    enable boolean DEFAULT true NOT NULL,
    createdby integer NOT NULL,
    createddate timestamp with time zone NOT NULL,
    lastupdatedby integer NOT NULL,
    lastupdateddate timestamp with time zone NOT NULL
);

ALTER TABLE finance_schema.lkpindustry OWNER TO finance_master;

COMMENT ON TABLE finance_schema.lkpindustry IS 'Lookup table of industries based on GICS (Global Industry Classification Standard). Not all asset types have an industry — bonds, indices and cash leave this null.';

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

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE finance_schema.lkpindustry TO finance_app_role;
