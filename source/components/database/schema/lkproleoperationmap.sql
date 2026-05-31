CREATE TABLE finance_schema.lkproleoperationmap (
    roleid character varying(55) NOT NULL,
    operationid character varying(55) NOT NULL,
    createdby integer NOT NULL,
    createddate timestamp with time zone NOT NULL,
    lastupdatedby integer NOT NULL,
    lastupdateddate timestamp with time zone NOT NULL
);

ALTER TABLE finance_schema.lkproleoperationmap OWNER TO finance_master;

COMMENT ON TABLE finance_schema.lkproleoperationmap IS 'Role Operation link table. This will have list of operation mapped to a role.';

COMMENT ON COLUMN finance_schema.lkproleoperationmap.roleid IS 'Role Id';

COMMENT ON COLUMN finance_schema.lkproleoperationmap.operationid IS 'Operation id assign to role';

ALTER TABLE ONLY finance_schema.lkproleoperationmap
    ADD CONSTRAINT lkproleoperationmap_pkey PRIMARY KEY (roleid, operationid);

ALTER TABLE ONLY finance_schema.lkproleoperationmap
    ADD CONSTRAINT lkproleoperationmap_createdby_fkey FOREIGN KEY (createdby) REFERENCES finance_schema.appuser(userid) ON UPDATE RESTRICT ON DELETE RESTRICT;

ALTER TABLE ONLY finance_schema.lkproleoperationmap
    ADD CONSTRAINT lkproleoperationmap_lastupdatedby_fkey FOREIGN KEY (lastupdatedby) REFERENCES finance_schema.appuser(userid) ON UPDATE RESTRICT ON DELETE RESTRICT;

ALTER TABLE ONLY finance_schema.lkproleoperationmap
    ADD CONSTRAINT lkproleoperationmap_operationid_fkey FOREIGN KEY (operationid) REFERENCES finance_schema.lkpoperation(operationid) ON UPDATE RESTRICT ON DELETE RESTRICT;

ALTER TABLE ONLY finance_schema.lkproleoperationmap
    ADD CONSTRAINT lkproleoperationmap_roleid_fkey FOREIGN KEY (roleid) REFERENCES finance_schema.lkprole(roleid) ON UPDATE RESTRICT ON DELETE RESTRICT;

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE finance_schema.lkproleoperationmap TO finance_app_role;
