#!/bin/bash
chown -R root /etc/nginx
chmod -R go-w /etc/nginx
chmod 755 /etc/nginx
chmod 644 /etc/nginx/nginx.conf
chmod -R o-w /var/www
chown www-data:adm /var/log/nginx /var/log/nginx/*.log
chmod 750 /var/log/nginx
chmod 640 /var/log/nginx/*.log
