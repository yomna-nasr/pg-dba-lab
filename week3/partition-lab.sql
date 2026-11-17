DROP TABLE IF EXISTS sales_flat;
DROP TABLE IF EXISTS sales CASCADE;
CREATE TABLE sales_flat (id bigserial, sold_at date NOT NULL, region text, amount numeric(8,2));
INSERT INTO sales_flat (sold_at, region, amount) SELECT date '2026-01-01' + (g % 150), 'r' || (g % 10), (random() * 500)::numeric(8,2) FROM generate_series(1,1000000) g;
CREATE TABLE sales (id bigint, sold_at date NOT NULL, region text, amount numeric(8,2)) PARTITION BY RANGE (sold_at);
CREATE TABLE sales_2026_01 PARTITION OF sales FOR VALUES FROM ('2026-01-01') TO ('2026-02-01');
CREATE TABLE sales_2026_02 PARTITION OF sales FOR VALUES FROM ('2026-02-01') TO ('2026-03-01');
CREATE TABLE sales_2026_03 PARTITION OF sales FOR VALUES FROM ('2026-03-01') TO ('2026-04-01');
CREATE TABLE sales_2026_04 PARTITION OF sales FOR VALUES FROM ('2026-04-01') TO ('2026-05-01');
CREATE TABLE sales_2026_05 PARTITION OF sales FOR VALUES FROM ('2026-05-01') TO ('2026-06-01');
INSERT INTO sales SELECT id, sold_at, region, amount FROM sales_flat;
ANALYZE sales;
ANALYZE sales_flat;
\echo === NOT partitioned
EXPLAIN (ANALYZE, COSTS OFF) SELECT count(*) FROM sales_flat WHERE sold_at BETWEEN '2026-03-01' AND '2026-03-31';
\echo === partitioned, pruning
EXPLAIN (ANALYZE, COSTS OFF) SELECT count(*) FROM sales WHERE sold_at BETWEEN '2026-03-01' AND '2026-03-31';
\echo === attach and detach
CREATE TABLE sales_2026_06 (LIKE sales);
INSERT INTO sales_2026_06 VALUES (1, '2026-06-15', 'r1', 10.00);
ALTER TABLE sales ATTACH PARTITION sales_2026_06 FOR VALUES FROM ('2026-06-01') TO ('2026-07-01');
SELECT count(*) FROM sales WHERE sold_at >= '2026-06-01';
ALTER TABLE sales DETACH PARTITION sales_2026_06;
SELECT count(*) FROM sales WHERE sold_at >= '2026-06-01';
\echo === statistics test
DROP TABLE IF EXISTS addr;
CREATE TABLE addr (id int, city text, zip text);
INSERT INTO addr SELECT g, 'city' || (g % 100), 'zip' || (g % 100) FROM generate_series(1,200000) g;
ANALYZE addr;
\echo === estimate BEFORE extended statistics
EXPLAIN SELECT * FROM addr WHERE city = 'city7' AND zip = 'zip7';
CREATE STATISTICS addr_city_zip (dependencies) ON city, zip FROM addr;
ANALYZE addr;
\echo === estimate AFTER extended statistics
EXPLAIN SELECT * FROM addr WHERE city = 'city7' AND zip = 'zip7';
