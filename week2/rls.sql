CREATE ROLE br_cairo LOGIN PASSWORD :'pw_cairo' IN ROLE app_ro;
CREATE ROLE br_alex  LOGIN PASSWORD :'pw_alex'  IN ROLE app_ro;
CREATE ROLE br_giza  LOGIN PASSWORD :'pw_giza'  IN ROLE app_ro;

ALTER TABLE app.orders ENABLE ROW LEVEL SECURITY;

CREATE POLICY branch_sees_own ON app.orders
  FOR SELECT TO app_ro
  USING (branch = substr(current_user, 4));

CREATE POLICY staff_see_all ON app.orders
  FOR ALL TO app_rw
  USING (true) WITH CHECK (true);

\d+ app.orders
SELECT policyname, roles, cmd, qual FROM pg_policies WHERE tablename = 'orders';
