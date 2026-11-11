DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS customers;
CREATE TABLE customers (id int PRIMARY KEY, email text, city text) WITH (autovacuum_enabled = false);
INSERT INTO customers SELECT g, 'user' || g || '@example.com', 'city' || (g % 100) FROM generate_series(1,100000) g;
CREATE TABLE orders (id int PRIMARY KEY, customer_id int, amount numeric(8,2), created_at timestamptz) WITH (autovacuum_enabled = false);
INSERT INTO orders SELECT g, (random() * 99999)::int + 1, (random() * 1000)::numeric(8,2), now() - (((random() * 365)::int || ' days')::interval) FROM generate_series(1,1000000) g;
