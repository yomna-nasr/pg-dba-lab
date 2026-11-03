# W1-T4 PostgreSQL Architecture

## The idea
PostgreSQL runs as many small processes, each with one job.
One main process (the postmaster) starts all the others.

## Diagram

    Client (psql / app)
         |  connects
         v
    postmaster  -- starts -->  backend (one per client)
                                  |  reads and writes
                                  v
    SHARED MEMORY (fast, temporary)
      [ shared_buffers ]        [ WAL buffers ]
            |                         |
        saved later               saved first
            v                         v
    DISK (slow, permanent)
      [ data files: base/ ]     [ WAL files: pg_wal/ ]

    Background workers move changes from memory to disk.

## The main parts
- postmaster: the manager. It waits for connections and starts a backend for each one.
- backend: one per client. It runs the client's queries.
- shared_buffers: memory cache of data pages, so PostgreSQL avoids reading the disk every time.
- WAL (write-ahead log): every change is written here first. After a crash, PostgreSQL replays it to recover.

## Background workers
- checkpointer: saves all changed pages to disk every few minutes
- background writer: saves changed pages slowly in the background
- walwriter: writes WAL from memory to disk
- autovacuum launcher: starts cleanup of old (dead) rows
- logical replication launcher: used only for logical replication
- logger: writes the log files

## PGDATA folder (/var/lib/pgsql/17/data)
- base/ : the databases (tables and indexes)
- global/ : cluster-wide data such as roles
- pg_wal/ : the WAL files

## How I verified it
- ps -ef --forest shows the postmaster and its child processes
- pg_stat_activity lists the background workers by backend_type
- I run two clusters (ports 5432 and 5434), so I see two postmasters
- Output is saved in processes.txt
