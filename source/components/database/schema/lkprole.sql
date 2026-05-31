CREATE TABLE finance_schema.lkprole (
    roleid character varying(55) NOT NULL,
    roledesc character varying(255) NOT NULL,
    enable boolean DEFAULT true NOT NULL,
    createdby integer NOT NULL,
    createddate timestamp with time zone NOT NULL,
    lastupdatedby integer NOT NULL,
    lastupdateddate timestamp with time zone NOT NULL
);

ALTER TABLE finance_schema.lkprole OWNER TO finance_master;

COMMENT ON TABLE finance_schema.lkprole IS 'Role table';

COMMENT ON COLUMN finance_schema.lkprole.roleid IS 'Unique alphanumeric role id';

COMMENT ON COLUMN finance_schema.lkprole.roledesc IS 'Desc for this role';

COMMENT ON COLUMN finance_schema.lkprole.enable IS 'This flag indicate if this role is active.';

ALTER TABLE ONLY finance_schema.lkprole
    ADD CONSTRAINT lkprole_pkey PRIMARY KEY (roleid);

ALTER TABLE ONLY finance_schema.lkprole
    ADD CONSTRAINT lkprole_createdby_fkey FOREIGN KEY (createdby) REFERENCES finance_schema.appuser(userid) ON UPDATE RESTRICT ON DELETE RESTRICT;

ALTER TABLE ONLY finance_schema.lkprole
    ADD CONSTRAINT lkprole_lastupdatedby_fkey FOREIGN KEY (lastupdatedby) REFERENCES finance_schema.appuser(userid) ON UPDATE RESTRICT ON DELETE RESTRICT;

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE finance_schema.lkprole TO finance_app_role;
