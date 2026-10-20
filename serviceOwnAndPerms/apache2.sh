#!/bin/bash
chown -R root /etc/apache2
chmod -R go-w /etc/apache2
chmod 755 /etc/apache2
chmod -R o-w /var/www
chown root:adm /var/log/apache2 /var/log/apache2/*.log
chmod 750 /var/log/apache2
chmod 640 /var/log/apache2/*.log
