\qecho 'creating finance db'

-- Switch to finance database 
\connect finance

-- Drop the default public schema
DROP schema public;

\qecho 'creating finance_schema in finance db'
-- Create application specific schema
CREATE SCHEMA finance_schema AUTHORIZATION finance_master;
COMMENT ON SCHEMA finance_schema
    IS 'Schema specific to finance application';
