#!/bin/bash
for d in /var/lib/postgresql/*/main; do
  chown -R postgres:postgres "$d"
  chmod 700 "$d"
done
for d in /etc/postgresql/*/main; do
  chown -R postgres:postgres "$d"
  chmod 755 "$d"
  chmod 644 "$d/postgresql.conf"
  chmod 640 "$d/pg_hba.conf" "$d/pg_ident.conf"
done
