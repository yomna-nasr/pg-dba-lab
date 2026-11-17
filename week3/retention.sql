CREATE OR REPLACE FUNCTION drop_old_partitions(keep_months int) RETURNS void LANGUAGE plpgsql AS $$
DECLARE r record;
BEGIN
  FOR r IN SELECT c.relname FROM pg_inherits i JOIN pg_class c ON c.oid = i.inhrelid WHERE i.inhparent = 'sales'::regclass AND to_date(substr(c.relname, 7), 'YYYY_MM') < date_trunc('month', current_date) - make_interval(months => keep_months)
  LOOP
    EXECUTE format('DROP TABLE %I', r.relname);
  END LOOP;
END $$;
SELECT drop_old_partitions(7);
\d+ sales
