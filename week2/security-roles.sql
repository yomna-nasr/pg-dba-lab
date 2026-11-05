-- W2-T1 Roles, privileges and least access

-- 1. Roles (roles are cluster-wide)
CREATE ROLE app_owner LOGIN PASSWORD 'OwnerPass1';
CREATE ROLE app_rw    LOGIN PASSWORD 'RwPass1';
CREATE ROLE app_ro    LOGIN PASSWORD 'RoPass1';
CREATE ROLE app_dba   LOGIN PASSWORD 'DbaPass1' CREATEROLE CREATEDB;
GRANT pg_monitor TO app_dba;

-- 2. Database owned by app_owner; remove default access for everyone else
CREATE DATABASE appdb OWNER app_owner;
REVOKE ALL ON DATABASE appdb FROM PUBLIC;
GRANT CONNECT ON DATABASE appdb TO app_rw, app_ro, app_dba;

\c appdb

-- 3. Remove default PUBLIC privileges on the public schema
REVOKE ALL ON SCHEMA public FROM PUBLIC;

-- 4. Schema owned by app_owner; others may only look inside (USAGE)
CREATE SCHEMA app AUTHORIZATION app_owner;
GRANT USAGE ON SCHEMA app TO app_rw, app_ro, app_dba;

-- 5. Default privileges: any future table app_owner creates in schema app
ALTER DEFAULT PRIVILEGES FOR ROLE app_owner IN SCHEMA app
  GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO app_rw;
ALTER DEFAULT PRIVILEGES FOR ROLE app_owner IN SCHEMA app
  GRANT SELECT ON TABLES TO app_ro;
ALTER DEFAULT PRIVILEGES FOR ROLE app_owner IN SCHEMA app
  GRANT USAGE, SELECT ON SEQUENCES TO app_rw;

-- 6. Create a test table as the owner
SET ROLE app_owner;
CREATE TABLE app.orders (
  id bigserial PRIMARY KEY,
  branch text NOT NULL,
  amount numeric(10,2) NOT NULL
);
INSERT INTO app.orders (branch, amount) VALUES
  ('cairo', 100.00), ('cairo', 250.50), ('alex', 75.25), ('giza', 310.00);
RESET ROLE;

\dn+
\dp app.*
