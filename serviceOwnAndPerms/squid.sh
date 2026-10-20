#!/bin/bash
chown -R root /etc/squid
chmod -R go-w /etc/squid
chmod 755 /etc/squid
chmod 644 /etc/squid/squid.conf
chown -R proxy:proxy /var/log/squid /var/spool/squid
chmod 750 /var/log/squid /var/spool/squid
