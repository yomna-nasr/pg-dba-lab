export PATH=/usr/pgsql-17/bin:$PATH
D=/var/backups/pg
rm -rf $D/*
echo plain; ( time pg_dump -Fp -d backup_lab -f $D/plain.sql ) 2>&1 | grep real
echo custom; ( time pg_dump -Fc -d backup_lab -f $D/custom.dump ) 2>&1 | grep real
echo directory-4-jobs; ( time pg_dump -Fd -j 4 -d backup_lab -f $D/dir ) 2>&1 | grep real
pg_dumpall --globals-only -f $D/globals.sql
du -sh $D/plain.sql $D/custom.dump $D/dir $D/globals.sql
