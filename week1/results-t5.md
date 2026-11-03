# W1-T5 psql, configuration, client authentication
- .psqlrc created: \timing on, \x auto
- ALTER SYSTEM SET work_mem = '16MB' + pg_reload_conf(): no restart needed (context: user)
- listen_addresses = 'localhost' in postgresql.conf: restart needed (context: postmaster)
- pg_hba.conf: host lines changed from ident to scram-sha-256, then reloaded
- User labuser2 created with a scram-sha-256 password
- Correct password: login OK
- Wrong password: FATAL: password authentication failed for user "labuser2"
