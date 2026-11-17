ALTER SYSTEM SET shared_buffers = '2GB';
ALTER SYSTEM SET work_mem = '32MB';
ALTER SYSTEM SET effective_cache_size = '6GB';
ALTER SYSTEM SET maintenance_work_mem = '512MB';
ALTER SYSTEM SET max_wal_size = '4GB';
ALTER SYSTEM SET checkpoint_completion_target = 0.9;
