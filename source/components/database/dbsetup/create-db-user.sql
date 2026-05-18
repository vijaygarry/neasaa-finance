\qecho 'creating database users for finance application.'

-- Create finance_master user to manage database. Application won't use this user.
CREATE USER finance_master WITH PASSWORD 'random-password' ;

-- Create user for application.
CREATE USER finance_app_user WITH PASSWORD 'random-password';
-- Local development system DB password encryption salt key is: secret-key

-- Create user for replication. This user will be used only for replication.
CREATE USER replicator REPLICATION PASSWORD 'random-password';

-- Create role. All permissions will be given to this role.
-- Application user will belongs to this role.
CREATE ROLE finance_app_role
  NOSUPERUSER INHERIT NOCREATEDB NOCREATEROLE NOREPLICATION;
COMMENT ON ROLE finance_app_role IS 'Group for finance app user';

-- grant app group to app user
grant finance_app_role to finance_app_user;