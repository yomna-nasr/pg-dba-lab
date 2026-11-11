DROP TABLE IF EXISTS events;
CREATE TABLE events (id int PRIMARY KEY, created_at timestamptz, user_id int, status text, payload jsonb, body text) WITH (autovacuum_enabled = false);
INSERT INTO events SELECT g, now() - (g || ' seconds')::interval, g % 1000, CASE WHEN g % 100 = 0 THEN 'cancelled' ELSE 'paid' END, jsonb_build_object('user', g % 1000, 'tag', 'tag' || g % 50), 'Word' || g % 500 || ' sample text ' || g FROM generate_series(1,500000) g;
VACUUM ANALYZE events;
\echo === B-TREE before
EXPLAIN (ANALYZE, COSTS OFF) SELECT * FROM events WHERE user_id = 42;
CREATE INDEX CONCURRENTLY idx_events_user ON events (user_id);
\echo === B-TREE after
EXPLAIN (ANALYZE, COSTS OFF) SELECT * FROM events WHERE user_id = 42;
\echo === COVERING (INCLUDE) index only scan
CREATE INDEX CONCURRENTLY idx_events_user_cov ON events (user_id) INCLUDE (created_at);
EXPLAIN (ANALYZE, COSTS OFF) SELECT created_at FROM events WHERE user_id = 42;
\echo === PARTIAL index
CREATE INDEX CONCURRENTLY idx_events_cancelled ON events (id) WHERE status = 'cancelled';
EXPLAIN (ANALYZE, COSTS OFF) SELECT id FROM events WHERE status = 'cancelled';
\echo === EXPRESSION index
EXPLAIN (ANALYZE, COSTS OFF) SELECT * FROM events WHERE lower(body) = 'word7 sample text 7';
CREATE INDEX CONCURRENTLY idx_events_lower_body ON events (lower(body));
EXPLAIN (ANALYZE, COSTS OFF) SELECT * FROM events WHERE lower(body) = 'word7 sample text 7';
\echo === GIN jsonb
EXPLAIN (ANALYZE, COSTS OFF) SELECT count(*) FROM events WHERE payload @> '{"tag":"tag7"}';
CREATE INDEX CONCURRENTLY idx_events_payload ON events USING gin (payload);
EXPLAIN (ANALYZE, COSTS OFF) SELECT count(*) FROM events WHERE payload @> '{"tag":"tag7"}';
\echo === GIN full text
EXPLAIN (ANALYZE, COSTS OFF) SELECT count(*) FROM events WHERE to_tsvector('english', body) @@ to_tsquery('english', 'word7');
CREATE INDEX CONCURRENTLY idx_events_fts ON events USING gin (to_tsvector('english', body));
EXPLAIN (ANALYZE, COSTS OFF) SELECT count(*) FROM events WHERE to_tsvector('english', body) @@ to_tsquery('english', 'word7');
\echo === BRIN
CREATE INDEX CONCURRENTLY idx_events_created_brin ON events USING brin (created_at);
EXPLAIN (ANALYZE, COSTS OFF) SELECT count(*) FROM events WHERE created_at > now() - interval '1 hour';
CREATE INDEX CONCURRENTLY idx_events_created_btree ON events (created_at);
SELECT indexrelname, pg_size_pretty(pg_relation_size(indexrelid)) AS size FROM pg_stat_user_indexes WHERE indexrelname IN ('idx_events_created_brin','idx_events_created_btree');
\echo === DUPLICATE index and unused index checks
CREATE INDEX CONCURRENTLY idx_events_user_dup ON events (user_id);
SELECT indrelid::regclass AS tbl, array_agg(indexrelid::regclass) AS duplicates FROM pg_index GROUP BY indrelid, indkey::text, indclass::text, coalesce(indpred::text,''), coalesce(indexprs::text,'') HAVING count(*) > 1;
SELECT indexrelname, idx_scan, pg_size_pretty(pg_relation_size(indexrelid)) AS size FROM pg_stat_user_indexes WHERE relname = 'events' ORDER BY idx_scan, pg_relation_size(indexrelid) DESC;
