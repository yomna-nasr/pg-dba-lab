# W2-T5 Bloat and reindexing
- VACUUM makes dead space reusable but does not return it to the OS, so tables and indexes stay big.
- REINDEX CONCURRENTLY rebuilds an index while reads and writes continue.
- pg_repack rebuilds a table online with only short locks. VACUUM FULL is only for planned downtime.
