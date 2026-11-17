# W4-T2 Physical backup and PITR drill
- WAL archiving on: archive_mode on, archive_command copies segments to /var/lib/pgsql/wal_archive.
- pg_basebackup taken, then 500 more rows inserted and the time recorded.
- Table important dropped by accident, then pg_switch_wal to archive the last segment.
- Base backup restored to a new directory with recovery_target_time set to the recorded time.
- Result: the table is back with 1500 rows on port 5436.
