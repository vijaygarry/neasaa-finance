-- Application database creation
\set databaseName 'finance'

CREATE DATABASE finance
    WITH
    OWNER = finance_master
    ENCODING = 'UTF8';

COMMENT ON DATABASE finance
    IS 'Finance database';

ALTER DATABASE finance SET search_path TO finance_schema;

-- Drop the default public schema
DROP schema public;
