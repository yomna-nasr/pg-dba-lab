\echo === 1 BEFORE: bad row estimate (no statistics)
EXPLAIN (ANALYZE, BUFFERS) SELECT count(*) FROM orders WHERE amount > 990;
ANALYZE orders;
ANALYZE customers;
\echo === 1 AFTER: statistics collected
EXPLAIN (ANALYZE, BUFFERS) SELECT count(*) FROM orders WHERE amount > 990;

\echo === 2 BEFORE: seq scan on customer_id
EXPLAIN (ANALYZE, BUFFERS) SELECT * FROM orders WHERE customer_id = 4242;
CREATE INDEX idx_orders_customer ON orders (customer_id);
\echo === 2 AFTER: index added
EXPLAIN (ANALYZE, BUFFERS) SELECT * FROM orders WHERE customer_id = 4242;

\echo === 3 BEFORE: nested loop over a large set (hash and merge join disabled)
SET enable_hashjoin = off;
SET enable_mergejoin = off;
EXPLAIN (ANALYZE, BUFFERS) SELECT count(*) FROM orders o JOIN customers c ON c.id = o.customer_id WHERE o.amount > 500;
RESET enable_hashjoin;
RESET enable_mergejoin;
\echo === 3 AFTER: planner free to choose
EXPLAIN (ANALYZE, BUFFERS) SELECT count(*) FROM orders o JOIN customers c ON c.id = o.customer_id WHERE o.amount > 500;

\echo === 4 BEFORE: sort spilling to disk (work_mem 1MB)
SET work_mem = '1MB';
EXPLAIN (ANALYZE, BUFFERS) SELECT id, amount FROM orders ORDER BY amount;
SET work_mem = '256MB';
\echo === 4 AFTER: work_mem 256MB
EXPLAIN (ANALYZE, BUFFERS) SELECT id, amount FROM orders ORDER BY amount;
RESET work_mem;

\echo === 5 BEFORE: function on a column prevents index use
EXPLAIN (ANALYZE, BUFFERS) SELECT * FROM customers WHERE lower(email) = 'user500@example.com';
CREATE INDEX idx_customers_lower_email ON customers (lower(email));
\echo === 5 AFTER: expression index
EXPLAIN (ANALYZE, BUFFERS) SELECT * FROM customers WHERE lower(email) = 'user500@example.com';
