#!/bin/bash
chown -R root /etc/mysql
chmod -R go-w /etc/mysql
chmod 755 /etc/mysql
chmod 644 /etc/mysql/my.cnf
chown root:root /etc/mysql/debian.cnf
chmod 600 /etc/mysql/debian.cnf
chown -R mysql:mysql /var/lib/mysql
chmod 750 /var/lib/mysql
chown mysql:adm /var/log/mysql /var/log/mysql/*.log
chmod 750 /var/log/mysql
chmod 640 /var/log/mysql/*.log
