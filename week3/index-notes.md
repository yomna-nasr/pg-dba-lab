# W3-T3 Indexing strategy
- B-tree for equality and range, partial for a small subset, covering (INCLUDE) for index only scans.
- Expression index when the query uses a function, GIN for jsonb and full text, BRIN for huge ordered tables.
- CONCURRENTLY builds an index without blocking writes.
- Duplicate and unused indexes waste space and slow writes, so find and drop them.
