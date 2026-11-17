# W3-T4 Memory, WAL and checkpoint tuning
## Settings before
Timing is on.
Expanded display is used automatically.
             name             | setting | unit 
------------------------------+---------+------
 checkpoint_completion_target | 0.9     | 
 effective_cache_size         | 524288  | 8kB
 maintenance_work_mem         | 65536   | kB
 max_wal_size                 | 1024    | MB
 shared_buffers               | 16384   | 8kB
 work_mem                     | 16384   | kB
(6 rows)

Time: 7.796 ms
## Settings after
Timing is on.
Expanded display is used automatically.
             name             | setting | unit 
------------------------------+---------+------
 checkpoint_completion_target | 0.9     | 
 effective_cache_size         | 786432  | 8kB
 maintenance_work_mem         | 524288  | kB
 max_wal_size                 | 4096    | MB
 shared_buffers               | 262144  | 8kB
 work_mem                     | 32768   | kB
(6 rows)

Time: 4.987 ms
## pgbench before
latency average = 4.840 ms
tps = 2065.914301 (without initial connection time)
## pgbench after
latency average = 3.688 ms
tps = 2711.467442 (without initial connection time)
## Checkpoints before
Timing is on.
Expanded display is used automatically.
 num_timed | num_requested 
-----------+---------------
         0 |             1
(1 row)

Time: 1.943 ms
## Checkpoints after
## Result
- TPS 2065.9 to 2711.5 (about 31 percent higher), latency 4.840 ms to 3.688 ms (about 24 percent lower).
## Why each change
- shared_buffers 2GB: caches more data pages.
- work_mem 32MB: sorts and hashes stay in memory.
- effective_cache_size 6GB: tells the planner how much OS cache exists.
- maintenance_work_mem 512MB: faster VACUUM and index builds.
- max_wal_size 4GB: fewer forced checkpoints.
- checkpoint_completion_target 0.9: spreads checkpoint writes over time.
