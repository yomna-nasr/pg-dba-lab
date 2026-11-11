CREATE EXTENSION IF NOT EXISTS pgstattuple;
CREATE EXTENSION IF NOT EXISTS pageinspect;
DROP TABLE IF EXISTS accounts;
CREATE TABLE accounts (id int PRIMARY KEY, balance int) WITH (autovacuum_enabled = false);
INSERT INTO accounts SELECT g, 100 FROM generate_series(1,100000) g;
ANALYZE accounts;
\echo === row before update
SELECT ctid, xmin, xmax, * FROM accounts WHERE id = 1;
UPDATE accounts SET balance = balance + 1 WHERE id = 1;
\echo === row after update (new version)
SELECT ctid, xmin, xmax, * FROM accounts WHERE id = 1;
\echo === old version still on the page
SELECT lp, t_xmin, t_xmax, t_ctid FROM heap_page_items(get_raw_page('accounts', 0)) WHERE lp = 1;
SELECT pg_size_pretty(pg_relation_size('accounts')) AS size_start;
UPDATE accounts SET balance = balance + 1;
SELECT pg_sleep(2);
\echo === dead tuples after updating every row
SELECT n_live_tup, n_dead_tup FROM pg_stat_user_tables WHERE relname = 'accounts';
SELECT tuple_count, dead_tuple_count, round(dead_tuple_percent::numeric,1) AS dead_pct, pg_size_pretty(table_len) AS size FROM pgstattuple('accounts');
VACUUM accounts;
SELECT pg_sleep(2);
\echo === after VACUUM
SELECT n_live_tup, n_dead_tup FROM pg_stat_user_tables WHERE relname = 'accounts';
SELECT tuple_count, dead_tuple_count, round(free_percent::numeric,1) AS free_pct, pg_size_pretty(table_len) AS size FROM pgstattuple('accounts');
VACUUM FULL accounts;
\echo === after VACUUM FULL
SELECT pg_size_pretty(pg_relation_size('accounts')) AS size_after_full;
