export PATH=/usr/pgsql-17/bin:$PATH
run() { echo; echo "[$1] $3"; PGPASSWORD=$2 psql -X -h 127.0.0.1 -U $1 -d appdb -c "$3" 2>&1; }

echo "=== READ-ONLY USER (app_ro) ==="
run app_ro RoPass1 "SELECT count(*) FROM app.orders;"
run app_ro RoPass1 "INSERT INTO app.orders(branch,amount) VALUES ('x',1);"
run app_ro RoPass1 "UPDATE app.orders SET amount = 0 WHERE id = 999999;"
run app_ro RoPass1 "DELETE FROM app.orders WHERE id = 999999;"
run app_ro RoPass1 "CREATE TABLE app.hack(id int);"
run app_ro RoPass1 "CREATE TABLE public.hack(id int);"

echo; echo "=== READ-WRITE USER (app_rw) ==="
run app_rw RwPass1 "INSERT INTO app.orders(branch,amount) VALUES ('test',1);"
run app_rw RwPass1 "UPDATE app.orders SET amount = amount WHERE id = 1;"
run app_rw RwPass1 "DELETE FROM app.orders WHERE branch = 'test';"
run app_rw RwPass1 "CREATE TABLE app.hack2(id int);"
run app_rw RwPass1 "DROP TABLE app.orders;"

echo; echo "=== OWNER creates a new table, default privileges apply ==="
run app_owner OwnerPass1 "CREATE TABLE app.customers(id serial PRIMARY KEY, name text);"
run app_ro RoPass1 "SELECT * FROM app.customers;"
run app_ro RoPass1 "INSERT INTO app.customers(name) VALUES ('a');"
run app_rw RwPass1 "INSERT INTO app.customers(name) VALUES ('a');"

echo; echo "=== USER WITHOUT CONNECT (labuser2) ==="
run labuser2 GoodPass123 "SELECT 1;"

echo; echo "=== DBA ROLE (app_dba) ==="
run app_dba DbaPass1 "CREATE ROLE tmp_test;"
run app_dba DbaPass1 "DROP ROLE tmp_test;"
run app_dba DbaPass1 "SELECT count(*) FROM pg_stat_activity;"
