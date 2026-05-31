CREATE TABLE finance_schema.lkpconfig (
    configname character varying(255) NOT NULL,
    paramname character varying(255) NOT NULL,
    paramvalue character varying(500) NOT NULL,
    enable boolean DEFAULT true NOT NULL,
    listorderseq smallint,
    createdby integer NOT NULL,
    createddate timestamp with time zone NOT NULL,
    lastupdatedby integer NOT NULL,
    lastupdateddate timestamp with time zone NOT NULL
);

ALTER TABLE finance_schema.lkpconfig OWNER TO finance_master;

COMMENT ON COLUMN finance_schema.lkpconfig.configname IS 'Main config name e.g. COUNTRYNAME';

COMMENT ON COLUMN finance_schema.lkpconfig.paramname IS 'config parameter name e.g. HINDI. This will be the same as config name if no sub config name';

COMMENT ON COLUMN finance_schema.lkpconfig.paramvalue IS 'Config value for config name and config param name';

COMMENT ON COLUMN finance_schema.lkpconfig.enable IS 'Y means enabled and should be pickup by application';

COMMENT ON COLUMN finance_schema.lkpconfig.listorderseq IS 'If config has multiple param, then this will be order of config.';

COMMENT ON COLUMN finance_schema.lkpconfig.createdby IS 'User id for user who created this record';

COMMENT ON COLUMN finance_schema.lkpconfig.createddate IS 'Time when this record was created';

COMMENT ON COLUMN finance_schema.lkpconfig.lastupdatedby IS 'User id for user who last updated this record';

COMMENT ON COLUMN finance_schema.lkpconfig.lastupdateddate IS 'Time when this record was last updated';

ALTER TABLE ONLY finance_schema.lkpconfig
    ADD CONSTRAINT lkpconfig_pkey PRIMARY KEY (configname, paramname);

ALTER TABLE ONLY finance_schema.lkpconfig
    ADD CONSTRAINT lkpconfig_createdby_fkey FOREIGN KEY (createdby) REFERENCES finance_schema.appuser(userid) ON UPDATE RESTRICT ON DELETE RESTRICT;

ALTER TABLE ONLY finance_schema.lkpconfig
    ADD CONSTRAINT lkpconfig_lastupdatedby_fkey FOREIGN KEY (lastupdatedby) REFERENCES finance_schema.appuser(userid) ON UPDATE RESTRICT ON DELETE RESTRICT;

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE finance_schema.lkpconfig TO finance_app_role;
