ALTER SYSTEM SET log_line_prefix = '%m [%p] %q%u@%d ';
ALTER SYSTEM SET log_min_duration_statement = '500ms';
ALTER SYSTEM SET log_lock_waits = on;
ALTER SYSTEM SET log_checkpoints = on;
ALTER SYSTEM SET auto_explain.log_min_duration = '500ms';
ALTER SYSTEM SET auto_explain.log_analyze = on;
ALTER SYSTEM SET pg_stat_statements.track = 'all';
SELECT format('ALTER SYSTEM SET shared_preload_libraries = %L', concat_ws(',', NULLIF(current_setting('shared_preload_libraries'), ''), 'auto_explain', 'pg_stat_statements')) \gexec
