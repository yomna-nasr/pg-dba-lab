# W1-T3 Native PostgreSQL install (RHEL)
- PGDG repo, postgresql17-server, initdb via postgresql-17-setup
- Service: systemctl enable --now postgresql-17 (active, enabled)
- Data dir: /var/lib/pgsql/17/data
- Config: /var/lib/pgsql/17/data/postgresql.conf
- Second cluster: initdb -D /var/lib/pgsql/17/data2, port 5434, started with pg_ctl
- Note: initdb defaults to trust auth for local connections; to be hardened in W1-T5
