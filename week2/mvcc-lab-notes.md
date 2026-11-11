# W2-T3 MVCC and dead tuples
- An UPDATE writes a new row version and leaves the old one as a dead tuple.
- xmin is the transaction that created a version, xmax the one that replaced it.
- VACUUM marks dead space reusable, VACUUM FULL rewrites the table and returns space but locks it.
- A long open transaction keeps an old snapshot, so VACUUM cannot remove versions it might still need.
