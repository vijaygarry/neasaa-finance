REVOKE ALL ON SCHEMA finance_schema FROM PUBLIC;
REVOKE ALL ON SCHEMA finance_schema FROM finance_master;

GRANT ALL ON SCHEMA finance_schema TO finance_master;
-- grant access on finance_schema schema to app group
GRANT USAGE ON SCHEMA finance_schema TO finance_app_role;


GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA finance_schema TO finance_app_role;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA finance_schema TO finance_app_role;
GRANT ALL ON ALL SEQUENCES IN SCHEMA finance_schema TO finance_app_role;
