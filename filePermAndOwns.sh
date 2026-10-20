#!/bin/bash
# Fixed-value permission/ownership fixes (Ubuntu 22.04 /Mint 21 defaults)
# "No such file" errors are fine(file just doesn't exist on this image).
# Home directories (/home/<user>) not ahanled, d those by hand
 
[ "$(id -u)" -eq 0 ] || { echo "Run as root (sudo)."; exit 1; }
 
echo "--- Account files ---"
chown root:root /etc/passwd /etc/passwd- /etc/group /etc/group-
chmod 644 /etc/passwd /etc/passwd- /etc/group /etc/group-
chown root:shadow /etc/shadow /etc/shadow- /etc/gshadow /etc/gshadow-
chmod 640 /etc/shadow /etc/shadow- /etc/gshadow /etc/gshadow-
chown root:root /etc/security/opasswd
chmod 600 /etc/security/opasswd
 
echo "--- sudo ---"
chown root:root /etc/sudoers /etc/sudoers.d
chmod 440 /etc/sudoers
chmod 750 /etc/sudoers.d
chown root:root /etc/sudoers.d/*
chmod 440 /etc/sudoers.d/*
 
echo "--- SSL private keys ---"
chown root:ssl-cert /etc/ssl/private
chmod 710 /etc/ssl/private
 
echo "--- apt ---"
chown root:root /etc/apt/apt.conf /etc/apt/apt.conf.d
chmod 644 /etc/apt/apt.conf
chmod 755 /etc/apt/apt.conf.d
 
echo "--- Core system files ---"
chown root:root /etc/fstab /etc/hosts /boot/grub/grub.cfg
chmod 644 /etc/fstab /etc/hosts
chmod 444 /boot/grub/grub.cfg
chown root:root /root
chmod 700 /root
chmod 1777 /tmp /var/tmp
 
echo "--- Cron ---"
chown root:root /etc/crontab /etc/cron.d /etc/cron.hourly /etc/cron.daily /etc/cron.weekly /etc/cron.monthly
chmod 644 /etc/crontab
chmod 755 /etc/cron.d /etc/cron.hourly /etc/cron.daily /etc/cron.weekly /etc/cron.monthly
chown root:crontab /var/spool/cron/crontabs
chmod 1730 /var/spool/cron/crontabs
 
echo "--- Logs ---"
chown syslog:adm /var/log/auth.log /var/log/syslog
chmod 640 /var/log/auth.log /var/log/syslog
 
echo "Done. Verify with:"
echo "  stat -c '%a %U:%G %n' /etc/passwd /etc/shadow /etc/gshadow /etc/sudoers /etc/sudoers.d /etc/ssl/private /tmp"
 