CREATE EXTENSION IF NOT EXISTS pgstattuple;
DROP TABLE IF EXISTS bloat_lab;
CREATE TABLE bloat_lab (id int PRIMARY KEY, balance int, pad text) WITH (autovacuum_enabled = false);
INSERT INTO bloat_lab SELECT g, 100, repeat('x', 100) FROM generate_series(1,300000) g;
UPDATE bloat_lab SET balance = balance + 1;
UPDATE bloat_lab SET balance = balance + 1;
DELETE FROM bloat_lab WHERE id % 5 < 3;
VACUUM bloat_lab;
\echo === BEFORE
SELECT pg_size_pretty(pg_table_size('bloat_lab')) AS table_size, pg_size_pretty(pg_indexes_size('bloat_lab')) AS index_size;
SELECT tuple_count, round(free_percent::numeric,1) AS table_free_pct FROM pgstattuple('bloat_lab');
SELECT leaf_pages, round(avg_leaf_density::numeric,1) AS leaf_density, round(leaf_fragmentation::numeric,1) AS fragmentation FROM pgstatindex('bloat_lab_pkey');
