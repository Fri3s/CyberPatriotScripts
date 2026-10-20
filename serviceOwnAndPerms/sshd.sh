#!/bin/bash
chown root:root /etc/ssh
chmod 755 /etc/ssh
chown root:root /etc/ssh/sshd_config
chmod 600 /etc/ssh/sshd_config
chown root:root /etc/ssh/ssh_host_*_key /etc/ssh/ssh_host_*_key.pub
chmod 600 /etc/ssh/ssh_host_*_key
chmod 644 /etc/ssh/ssh_host_*_key.pub
# per-user ssh files
for h in /home/*; do
  u=$(stat -c %U "$h"); g=$(stat -c %G "$h")
  chown "$u:$g" "$h/.ssh" "$h/.ssh/authorized_keys" 2>/dev/null
  chmod 700 "$h/.ssh" 2>/dev/null
  chmod 600 "$h/.ssh/authorized_keys" 2>/dev/null
done
