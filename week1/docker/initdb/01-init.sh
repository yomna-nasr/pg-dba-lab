#!/bin/bash
set -e
psql -v ON_ERROR_STOP=1 -v pw="$APP_PASSWORD" -U "$POSTGRES_USER" -d postgres <<'SQL'
CREATE ROLE dockeruser LOGIN PASSWORD :'pw';
CREATE DATABASE dockerdb OWNER dockeruser;
SQL
