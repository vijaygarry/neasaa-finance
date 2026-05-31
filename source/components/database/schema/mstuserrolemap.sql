CREATE TABLE finance_schema.mstuserrolemap (
    userid integer NOT NULL,
    roleid character varying(100) NOT NULL,
    createdby integer NOT NULL,
    createddate timestamp with time zone NOT NULL,
    lastupdatedby integer NOT NULL,
    lastupdateddate timestamp with time zone NOT NULL
);

ALTER TABLE finance_schema.mstuserrolemap OWNER TO finance_master;

COMMENT ON TABLE finance_schema.mstuserrolemap IS 'User role link table. This table will have list of roles assign to user.';

COMMENT ON COLUMN finance_schema.mstuserrolemap.userid IS 'User Id';

COMMENT ON COLUMN finance_schema.mstuserrolemap.roleid IS 'Role Id';

ALTER TABLE ONLY finance_schema.mstuserrolemap
    ADD CONSTRAINT mstuserrolemap_pkey PRIMARY KEY (userid, roleid);

ALTER TABLE ONLY finance_schema.mstuserrolemap
    ADD CONSTRAINT mstuserrolemap_createdby_fkey FOREIGN KEY (createdby) REFERENCES finance_schema.appuser(userid) ON UPDATE RESTRICT ON DELETE RESTRICT;

ALTER TABLE ONLY finance_schema.mstuserrolemap
    ADD CONSTRAINT mstuserrolemap_lastupdatedby_fkey FOREIGN KEY (lastupdatedby) REFERENCES finance_schema.appuser(userid) ON UPDATE RESTRICT ON DELETE RESTRICT;

ALTER TABLE ONLY finance_schema.mstuserrolemap
    ADD CONSTRAINT mstuserrolemap_roleid_fkey FOREIGN KEY (roleid) REFERENCES finance_schema.lkprole(roleid) ON UPDATE RESTRICT ON DELETE RESTRICT;

ALTER TABLE ONLY finance_schema.mstuserrolemap
    ADD CONSTRAINT mstuserrolemap_userid_fkey FOREIGN KEY (userid) REFERENCES finance_schema.appuser(userid) ON UPDATE RESTRICT ON DELETE RESTRICT;

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE finance_schema.mstuserrolemap TO finance_app_role;
