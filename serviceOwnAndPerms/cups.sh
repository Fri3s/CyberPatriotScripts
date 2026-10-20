#!/bin/bash
chown root:lp /etc/cups
chmod 755 /etc/cups
chown root:lp /etc/cups/cupsd.conf
chmod 640 /etc/cups/cupsd.conf
chown root:lp /var/spool/cups
chmod 710 /var/spool/cups
