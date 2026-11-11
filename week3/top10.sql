\echo === TOP 10 BY TOTAL TIME
SELECT d.datname, left(s.query, 60) AS query, s.calls, round(s.total_exec_time::numeric,1) AS total_ms, round(s.mean_exec_time::numeric,2) AS mean_ms FROM pg_stat_statements s JOIN pg_database d ON d.oid = s.dbid ORDER BY s.total_exec_time DESC LIMIT 10;
\echo === TOP 10 BY MEAN TIME
SELECT d.datname, left(s.query, 60) AS query, s.calls, round(s.total_exec_time::numeric,1) AS total_ms, round(s.mean_exec_time::numeric,2) AS mean_ms FROM pg_stat_statements s JOIN pg_database d ON d.oid = s.dbid ORDER BY s.mean_exec_time DESC LIMIT 10;
\echo === TOP 10 BY CALLS
SELECT d.datname, left(s.query, 60) AS query, s.calls, round(s.total_exec_time::numeric,1) AS total_ms, round(s.mean_exec_time::numeric,2) AS mean_ms FROM pg_stat_statements s JOIN pg_database d ON d.oid = s.dbid ORDER BY s.calls DESC LIMIT 10;
