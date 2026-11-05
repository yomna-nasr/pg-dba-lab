. ~/pg-dba-lab/week2/passwords.env
export PATH=/usr/pgsql-17/bin:$PATH

run() {
    echo
    echo "[$1] $3"
    PGPASSWORD=$2 psql -X -h 127.0.0.1 -U "$1" -d appdb -c "$3" 2>&1
}

echo "=== Each branch sees only its own rows ==="

run br_cairo "$PW_CAIRO" "SELECT * FROM app.orders ORDER BY id;"
run br_alex "$PW_ALEX" "SELECT * FROM app.orders ORDER BY id;"
run br_giza "$PW_GIZA" "SELECT * FROM app.orders ORDER BY id;"

echo
echo "=== A branch cannot see another branch ==="

run br_cairo "$PW_CAIRO" "SELECT * FROM app.orders WHERE branch = 'alex';"

echo
echo "=== A branch cannot write ==="

run br_cairo "$PW_CAIRO" "INSERT INTO app.orders(branch,amount) VALUES ('cairo',1);"

echo
echo "=== Staff see everything ==="

run app_rw "$PW_RW" "SELECT * FROM app.orders ORDER BY id;"
