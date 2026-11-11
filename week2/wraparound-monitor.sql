SELECT datname, age(datfrozenxid) AS xid_age, round(100.0 * age(datfrozenxid) / 2147483647, 2) AS pct_of_limit FROM pg_database ORDER BY xid_age DESC;
SELECT c.oid::regclass AS table_name, age(c.relfrozenxid) AS xid_age, pg_size_pretty(pg_total_relation_size(c.oid)) AS size FROM pg_class c WHERE c.relkind IN ('r','m','t') ORDER BY age(c.relfrozenxid) DESC LIMIT 10;
SHOW autovacuum_freeze_max_age;
