# W3-T4 Memory, WAL and checkpoint tuning

## Settings before

## Settings after

## pgbench before

## pgbench after

## Checkpoints before

## Checkpoints after

## Why each change
- shared_buffers 2GB: about 25 percent of RAM, caches more data pages.
- work_mem 32MB: sorts and hashes stay in memory.
- effective_cache_size 6GB: tells the planner how much OS cache exists.
- maintenance_work_mem 512MB: faster VACUUM and index builds.
- max_wal_size 4GB: fewer forced checkpoints.
- checkpoint_completion_target 0.9: spreads checkpoint writes over time.
