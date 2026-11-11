ALTER SYSTEM SET log_autovacuum_min_duration = 0;
SELECT pg_reload_conf();
ALTER TABLE accounts RESET (autovacuum_enabled);
ALTER TABLE accounts SET (autovacuum_vacuum_scale_factor = 0.02, autovacuum_vacuum_threshold = 1000, autovacuum_vacuum_cost_limit = 1000);
SELECT relname, reloptions FROM pg_class WHERE relname = 'accounts';
SELECT name, setting FROM pg_settings WHERE name IN ('autovacuum_vacuum_scale_factor','autovacuum_vacuum_threshold','autovacuum_vacuum_cost_limit','autovacuum_naptime');
UPDATE accounts SET balance = balance + 1 WHERE id <= 5000;
